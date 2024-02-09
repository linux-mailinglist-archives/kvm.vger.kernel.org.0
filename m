Return-Path: <kvm+bounces-8503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90F684FFE8
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E189B226EF
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3680364D4;
	Fri,  9 Feb 2024 22:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIscm1Td"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7493B25625
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517742; cv=none; b=bStiZIsMDoKy5lfA+ZfIQaBdoCLZF5KmQ3rvfegccBHYp2s1eg6Hyh0z0jVa/dCp2bNq293IbaV6ZRDefWloG0cOi29L3LFR12BUq7JqTkvjK3Hk2mPWtOTwNcIgE2Jmdw5xOSmmvC+wEfM9mun1VQjxuQs+EfzjK4d4oDf7cMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517742; c=relaxed/simple;
	bh=fIqYvORhxAkyZm48va/2ujkvGA7C8gveY8KxKZlfit8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QduSeCPZ3eVxkvkJoy4WA0HLNY4FSReI9aNkIaaT9pZRg1OEAu+tFfA1/ePSIVQaQYiP1JP7r/YQdCGndNfqyLRDIvaCr6/KIzOKzmCPUnHaBXEBWI7pvQ08WbIwNx3xtyViVXHpWxyIQUtBLSGMbNiV/D0rlj2DopeC/gkhRQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIscm1Td; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso1425927a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517741; x=1708122541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H5hQFyPpf+rydxjBfMUUkTUJgr64hFiwgdcvFQinuS0=;
        b=SIscm1Tdv48XiEjz2aULMyi6MQ2rnjaJt5Fwnz4t1rR2ImKXv1n3e/fvvp62YQr79b
         0mLDKp1cJ8wilJVvw3JnI0V2Whdwai95C/Wzv/+qTkjtCFN0dBDqcdPv2ltLMJnMSUlw
         qJtNzqknyiVBq2hlElFG+aMUJZVeNiCrSBahIp++bADTzPs2R+36tSW1HQTJedLWK4+u
         oQbctEz9n7rJwrUW/y9/0dkbEBDEPH4/FGeynSggChs29A12dqT+RUxOQrX536SoWIPM
         bRazaiSeqGXMODYPwEC3fQpSvU67iZkem4e8wR0l0j0Ie+qSceiYz/piiIw+HVd1/kTQ
         3f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517741; x=1708122541;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5hQFyPpf+rydxjBfMUUkTUJgr64hFiwgdcvFQinuS0=;
        b=kXfaOCBn0W14SAIvk4eEdBWglZGNQTiZnIX0vbZ2g3PH8SyrioWvLZTcloIJ8jhnDI
         vkNT66xHIa9+tOKktF+spKcC/jhLwJTniL74kyMpGHC7ReReJhI8dONQ6pLRluITnLFT
         5Jw7kxCNjEjOYT/FVh2vKCkGL+V08H5ZJ29RrehRkAbgjbDtmBS3SPZf8QK/4JsVcshl
         Ivlf2fAEFujBmNz/8v8Uwkxd9tX86no91e+9AUELtX6TSKGz8PF9Ar7jHzRevaurLLDd
         CfthG9XXuoLj0XL1013b7+WqPHz1AUHXJAe74KxTUlM9ZFrAm+g5L2anZJXOrwlU3DX6
         waDw==
X-Gm-Message-State: AOJu0YxnTNlD/bujsfYGS8qD/1G8ePsRcfzLnATthgvtbQ1XV9Scbgea
	fI7WJBOjnXWS8Kvew62hSGA9TpYf4KJNkFVeCSI1bhbpXvtz4bmEj7h4Mk4QixPAYq/K0weRWC3
	Ssw==
X-Google-Smtp-Source: AGHT+IH4XFzuF2DKPAkh093CaHpAAUCLEz9Un/+UQsFkngrgKl6K7U6HxZSJmwZ1mrguGsAZTnMEI+Kpv+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d07:0:b0:5dc:5111:d8b1 with SMTP id
 bf7-20020a656d07000000b005dc5111d8b1mr936pgb.5.1707517740545; Fri, 09 Feb
 2024 14:29:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:28:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222858.396696-1-seanjc@google.com>
Subject: [PATCH v4 0/4] KVM: x86/mmu: Pre-check for mmu_notifier retry
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Michael Roth <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Retry page faults without acquiring mmu_lock, and potentially even without
resolving a pfn, if the gfn is covered by an active invalidation.  This
avoids resource and lock contention, which can be especially beneficial
for preemptible kernels as KVM can get stuck bouncing mmu_lock between a
vCPU and the invalidation task the vCPU is waiting on to finish.

v4: 
 - Pre-check for retry before resolving the pfn, too. [Yan]
 - Add a patch to fix a private/shared vs. memslot validity check
   priority inversion bug.
 - Refactor kvm_faultin_pfn() to clean up the handling of noslot faults.

v3:
 - https://lkml.kernel.org/r/20240203003518.387220-1-seanjc%40google.com
 - Release the pfn, i.e. put the struct page reference if one was held,
   as the caller doesn't expect to get a reference on "failure". [Yuan]
 - Fix a typo in the comment.

v2:
 - Introduce a dedicated helper and collapse to a single patch (because
   adding an unused helper would be quite silly).
 - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
 - Add Kai's Ack.

v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

Sean Christopherson (4):
  KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is
    changing
  KVM: x86/mmu: Move private vs. shared check above slot validity checks
  KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to
    kvm_faultin_pfn()
  KVM: x86/mmu: Handle no-slot faults at the beginning of
    kvm_faultin_pfn()

 arch/x86/kvm/mmu/mmu.c          | 134 ++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |   5 +-
 include/linux/kvm_host.h        |  26 +++++++
 3 files changed, 122 insertions(+), 43 deletions(-)


base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 
2.43.0.687.g38aa6559b0-goog


