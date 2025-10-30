Return-Path: <kvm+bounces-61517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B30CAC21D88
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39B3D402F64
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E78A36E365;
	Thu, 30 Oct 2025 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0GC2ax02"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46B36E342
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850688; cv=none; b=QQ6ohNTVLI5CYWeCSzkHKtmsATRDqFzj5klQCDlfTvnGIRmWYw+5IJwnRwzRJmHqyY6PcjITun+aFwf+YQur5DdfI37x7xEDM7ROSFgwR8ccitqoaodvltIBD/1D24QFRqFnPQBeuiKtyVVSrXUKmicx+i+CkeMKH2x6d/kVSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850688; c=relaxed/simple;
	bh=1ldPacxy7lpN2FFTvlH5HJr3OKosyTZU7xugA7xY/74=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=j6mJITTuKW4pmkag9+urT6cz2AWlZwV/7TDSzX++UGrUB6marOTdNcjRx/+OrxMtqm1n6nHvhIjsOysD44qDwWot4YgJBzlmpKoulKY+ufrZYSLVW+Bbld+Q3H+li6Nt6n8euDfKOMcfz903YIIJ1fGkPPmAMyTJsMQWyo4cpvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0GC2ax02; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f610f7325so1182950b3a.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761850684; x=1762455484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mffRtvPyK2ohMcs5gOIENlcL3RR2rGSXli0PgTsR1yM=;
        b=0GC2ax02v3M4qQvpLmh0KAm1JoJRm8NlYM8oNMFl8191LUSe9sEQk9YvRqcdpMva1m
         Q4Gj0wmPu/Npe+xQ0iG70xYGAD5H1ZaORsuFh2xFEMNnG6ytucLaKZW4xl0/yaDiOs+F
         GeJIICH68zaGhztO1oRGwFy2b6PNq+h7zIDpS3mTxPd/rgU+yjLQp+zXTpfmUx6tvnWE
         l++BA1A3B6W/3fj3NgJXbrG4Nv6CeHDLohjZ1G43nS77WAPiQPbyT6guLdNqab5YJtiA
         cg1lLB5GkjlN6kVU8M+x8krbekn9P6GcJ7KqfnEYswd1UlkaWvB0QVt6/00hn+7n9r8m
         gg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850684; x=1762455484;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mffRtvPyK2ohMcs5gOIENlcL3RR2rGSXli0PgTsR1yM=;
        b=P3um4wSKZyLFUuqT+0DYIMNQMttx9FT0bQvNsrKUqqHGjC/pQvidZmL87NiWUVRRkh
         qngXWEdzFUUV1SL4haTbf+hnuaRGFTekbw+6+olwcOTwvzIwJpsou4mCCadQAX6Gzwpy
         0uvXmurNTAU9M46n0l5XFnF1v1Ww0+WODaTU8lBnRaj4zPnLiQVe3uWZOwnTUY5q3NwN
         HPu0HznHVqLEolzTIFMPPGMyn+Hi1yjzPRW+m8UfEOW5Sm51VIRRdNRAnK/PHrj61V58
         DyV010wndRJ90sIpB6tcut0JfSxz3h5KhgiKK+r6uXarfkPQDMrdJDPr1An0b7VuTCxr
         yg8w==
X-Gm-Message-State: AOJu0YyQWFraZrFUh3aipcGMxltb4EJGlFwOHC4ibzGHyvq4yiISwWGY
	tU6N61iX/krDbm80uwoPtZy43VsniPG8cyxsu1j8rkFlEsw9blr3LQKfjQqIR49HBfbOSvTz+t2
	k6v9F8g==
X-Google-Smtp-Source: AGHT+IETfkGG2l69qUNqrmL0Zk9TdfHjZDfxqQmlHM933IQU/Cfltl9oAz1PMF0AfqGsmZ1sTDPLnFtBXEU=
X-Received: from pfbfm1.prod.google.com ([2002:a05:6a00:2f81:b0:77f:efc:1431])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1815:b0:780:f6db:b1af
 with SMTP id d2e1a72fcca58-7a7792c5703mr558199b3a.16.1761850683901; Thu, 30
 Oct 2025 11:58:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 11:58:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030185802.3375059-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Fix an FPU+CET splat
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a explosion found via syzkaller+KASAN where KVM attempts to "put" an
FPU without first having loading the FPU.  The underlying problem is the
ugly hack for dealing with INIT being processed during MP_STATE.

KVM needs to ensure the FPU state is resident in memory in order to clear
MPX and CET state.  In most cases, INIT is emulated during KVM_RUN, and so
KVM needs to put the FPU.  But for MP_STATE, the FPU doesn't need to be
loaded, and so isn't.  Except when KVM predicts that the FPU will be
unloaded.  CET enabling updated the "put" path but missed the prediction
logic in MP_STATE.

Rip out the ugly hack and instead do the obvious-in-hindsight thing of
checking if the FPU is loaded (or not).  To retain a sanity check, e.g.
that the FPU is loaded as expected during KVM_RUN, WARN if the FPU being
loaded and the vCPU wanting to run aren't equal.

Sean Christopherson (2):
  KVM: x86: Unload "FPU" state on INIT if and only if its currently
    in-use
  KVM: x86: Harden KVM against imbalanced load/put of guest FPU state

 arch/x86/kvm/x86.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)


base-commit: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
-- 
2.51.1.930.gacf6e81ea2-goog


