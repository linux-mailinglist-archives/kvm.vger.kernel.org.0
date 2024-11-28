Return-Path: <kvm+bounces-32626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635479DB053
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F123B282110
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D99101E6;
	Thu, 28 Nov 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MEZ3Crej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0273BE4F
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754629; cv=none; b=jIcCubIFzjq8vUKQ0/x5UOwlMxjbbnfukCRfUOj3sheoLaPom20ba3QrFy8TCikZltOgdq25UnnBWA7nHuzp72+hxGQy1HahROQyZPGojQInhWuB/VaGJoKKbSTQcM8cRidkUXJixOIxIgekbCsQcm5zg8a6lFC2XXgGlrUUR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754629; c=relaxed/simple;
	bh=B1y2jy7fnKaBm36j5gckhSpoywvnkFzo0gLuwHLp4EA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Vxp4tzYi6uCp/fJszW4M5QgcVd4QQYOpQfAA+6dHjYEtW1WZgrQ1kPLkQEPei6tyggoncsgofOcGCEFF/Jr0O6b/pP7mwQgrWSG+IachYxociaRAnIdW1IWXGocL8jSY8SiiwuDc4HO/K02X1TcRjlDcdm++thWDz7zi2zNEWD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MEZ3Crej; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea2bf5b5fbso293535a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732754627; x=1733359427; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2pP/D5ApA8LvNrizEVSSnOUuGnFz5mUBn/5mc3cKq0=;
        b=MEZ3Crej4gSZle4dM1vYBbUWmdBTQKrqdYQlqNhcOTABGoKHuoDYQohAyWp8f794YE
         ec/MsEPdHt39JH2AmiCfDYn+tfr/2dKkcoJ1Ymo4g/jOSSXB3kR/Xu+kBTx/yBAmHDRf
         f1ajz0nvc8W4PwKRNSV9TASvGIUJEFO6+0QclAAHu3HG0sgPzaSV+yGA4CZdyX9TgapW
         YQoPiky0faTh7YKE0QQoUXfI1bPPaUIrW66vOttNBjs9dkmeF2LsSAWFfFs/8nhd1Bv0
         4fbHPVADeyUpzIsn0KDe728FTuGzPWDgkDg4DjDlYflxSfmuEZK/ssbLDM8nijC7vOCV
         lyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732754627; x=1733359427;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2pP/D5ApA8LvNrizEVSSnOUuGnFz5mUBn/5mc3cKq0=;
        b=ECCOmXYrdLx+hcq2lGiERjjFxj9rnz1d7gJW+9Y7Udl0SYcGGZ3rbLe+Burc6x+GtZ
         GRZrIv1O6fLfB4LNs6JZbsB3CvuTNEhHl7cJsxfKBFDDqHbb5fg6k6dc/Pm6muhbLaG5
         jV50RUu+G9B0S5XwqE0qJIPKb5siGa0rF6CLPjQfXB9P4duRQndyt5Dn2KuzQeZpByqj
         IsP3pws8dsSz0IBwzAUIIKJ0aP5XPR0v1ExZnMdt3QkD1/CEP3XaEqTLa8hR5781f/Ku
         huEeXM/0DJq+f14PFxx/W5bEd3tcM5Y0b5zTT6MFImw84r2ktQz6J6QMajoeYd9LMeeK
         VD0Q==
X-Gm-Message-State: AOJu0YysWMkosQ3uh0a6DKfk4Kk9yINqNUCNSlxSkfUHatNdpkDmVetZ
	yHlgjAVv/UPg4KQiw+9sRf9xunAq0c11n79hNVJRyaHK1o8jibtg+vSF7RsQkCW9gN6jLfAbXfa
	J2Q==
X-Google-Smtp-Source: AGHT+IEIlNfV6nIK9pFETYOL1YOv5NcXcskE+x3BT40ihhGFnMtC9QI/qUMEfEdkXLdG2ih3pFg6iRAbhzQ=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2e0:5d64:e34c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4a:b0:2ea:4578:46de
 with SMTP id 98e67ed59e1d1-2ee08ecf99emr6668283a91.20.1732754627238; Wed, 27
 Nov 2024 16:43:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:43:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128004344.4072099-1-seanjc@google.com>
Subject: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Effectively v4 of Binbin's series to handle hypercall exits to userspace in
a generic manner, so that TDX

Binbin and Kai, this is fairly different that what we last discussed.  While
sorting through Binbin's latest patch, I stumbled on what I think/hope is an
approach that will make life easier for TDX.  Rather than have common code
set the return value, _and_ have TDX implement a callback to do the same for
user return MSRs, just use the callback for all paths.

As for abusing vcpu->run->hypercall.ret... It's obviously a bit gross, but
I think it's a lesser evil than having multiple a one-line wrappers just to
trampoline in the return code.

v4:
 - Fix an SEV-* bug where KVM trips the WARN in is_64_bit_mode().
 - Add a pile of reworks to (hopefully) avoid as much duplicate code when
   TDX comes along.

v3: https://lore.kernel.org/all/20240826022255.361406-1-binbin.wu@linux.intel.com

Binbin Wu (1):
  KVM: x86: Add a helper to check for user interception of KVM
    hypercalls

Sean Christopherson (5):
  KVM: x86: Play nice with protected guests in complete_hypercall_exit()
  KVM: x86: Move "emulate hypercall" function declarations to x86.h
  KVM: x86: Bump hypercall stat prior to fully completing hypercall
  KVM: x86: Always complete hypercall via function callback
  KVM: x86: Refactor __kvm_emulate_hypercall() into a macro

 arch/x86/include/asm/kvm_host.h |  6 ----
 arch/x86/kvm/svm/sev.c          |  4 +--
 arch/x86/kvm/x86.c              | 50 +++++++++++----------------------
 arch/x86/kvm/x86.h              | 28 ++++++++++++++++++
 4 files changed, 47 insertions(+), 41 deletions(-)


base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


