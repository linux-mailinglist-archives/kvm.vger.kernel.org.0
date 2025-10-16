Return-Path: <kvm+bounces-60212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A66BE50A0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65F371A67F67
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26DD8233155;
	Thu, 16 Oct 2025 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mq33SfXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DF7225A23
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638914; cv=none; b=uRfdfRLDoB/PlY0fyBd0HI8nFb7cHWKD658oKMaqTzrfqtQIe3rJ1r3UzEyH+xv6n9ChOlrGUrSX95woSwYymDwl4Kq1t3KUcRckYTSFzG/xZrCHcxiXEac89aSNsApE3Y1wMOvrIu7AwI/KkOa4B8q1Ch027f0Nr2/QFd90tXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638914; c=relaxed/simple;
	bh=Mh+E6gl011fW54E6RYWIlpW7g7mpCeL0nCd5AXo09UY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=q2N0IBNNRMWBuhTq+gbpINRstIQIvWFXb5opOLqUNZVOttxQAPRNmxYFLTjte7zR1FWiRla3m5M0IifpypBd3a5qFlza+4/yxIVMc+YBHSi3arkXRLz7QAyAJA776H+2jSJBMiS2UklbGhv3UkWlwhbjq7wsnblJ+RxoU4jqbHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mq33SfXt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso1622884a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 11:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760638911; x=1761243711; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4n4oum8oQsC/oMkZG6rVTrxCa4Asppbi7rtcXvwpYnI=;
        b=mq33SfXtimYnS0Y4KiWJcraa4kgYtvcwQ474gZxB6lmFWycplQ2eKjBGbGK0rOr7l6
         wDrx4n/lVZ5VipCDIP6bfVcArnXDhDC8nkp+b5p7kqTiliYarLRE1lhNZrrbaK7nA5wj
         sygNdbA/xMsqdFnpigajwxY7ye99MJ7iYDFfuxqcaKTgcMBeT69oyMwPkzbsBMzNkP+O
         DGsr4y7m7E0eRaEHRGSgy2xavNtjnBbpKcK8eeYHVH22CN2KlE1dwKFGj7c6jiuXGQvs
         Z4pLt7jidyvrY6fs485a5xSOlFHKrq2eYuwYhu1gKwLn+oz1etY9hIEEoBr2Zgo2+Pfu
         1Mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760638911; x=1761243711;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4n4oum8oQsC/oMkZG6rVTrxCa4Asppbi7rtcXvwpYnI=;
        b=I8FCVqoVp4rgLHXx6EoeLsYu2Qi+hfg8DhTikNJCAi8lsezLkevqxV6SZCsMnhq23x
         KNP/tDJxr2aRALu71yMB6YazQu1JebJPwitN/GtfbBXDtqI5f57BrUeoHJ7yJwGHGJr/
         MsObc0jDGU0ht+CSphPDIPNjzlvy3c58vr4GL2oybtnWIrIcN1ipFa4A7zbmMWKqK3Rv
         TicIFdYyq8GWS7ycSO/HSuglJhUGXPrrSIaPurfEjQU5u6XfeeF371O3B5dqcE93NM7y
         mnVh3NYbSP59Bk3Ev2DKNg7Hly7ZVp531TZJo3vHpcFAwpQdkCYmDude4upEpvownt8y
         G6Jg==
X-Gm-Message-State: AOJu0YxXc/Gkhh56Z4nH26jlNhDReOu+iCWBpZlTquAOdc6W68FsTbB0
	CoE1lmukeUj9kkZ71QTvk8huLgo5RYfj9bQHy4vZf1mdNMEk1BPRQMa+aKqB/z7sMlwe7sySKi/
	tLozYtw==
X-Google-Smtp-Source: AGHT+IFLCoX5WFUlmmHIT4Ie6C0AeGFBS2XH3ZTG/UN632Tqc/zBz1lEaUkWyKjkjgFodVUI9HmuC6chR/o=
X-Received: from pjyl20.prod.google.com ([2002:a17:90a:ec14:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8a:b0:33b:ae39:c297
 with SMTP id 98e67ed59e1d1-33bcf8a9ee7mr909953a91.16.1760638910678; Thu, 16
 Oct 2025 11:21:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 11:21:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016182148.69085-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: VMX: Handle SEAMCALL or TDCALL VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add VM-Exit handlers for SEAMCALL and TDCALL as the instructions are gated
only by VMXON, and so a buggy/misbehaving guest will likely be terminated
(because KVM bails with KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON) if the
guest executes SEAMCALL or TDCALL.

v2:
 - Apply the behavior only to VMX.  KVM can't inject #UDs for TDX, and the
   TDX-Module is supposed to handle SEAMCALL. [Chao]
 - Fix nested exit handling (inverted return). [Xiaoyao]
 - WARN if the TDX-Module punts a SEAMCALL exit to KVM. [Xiaoyao]
 - Fix typos. [Binbin]

v1: https://lore.kernel.org/all/20251014231042.1399849-1-seanjc@google.com

Sean Christopherson (2):
  KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL
  KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way out to KVM

 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 8 ++++++++
 arch/x86/kvm/vmx/tdx.c          | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 4 files changed, 20 insertions(+)


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.51.0.858.gf9c4a03a3a-goog


