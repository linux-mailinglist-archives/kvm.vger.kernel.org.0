Return-Path: <kvm+bounces-10195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0A286A6C7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A055B253C7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179A628E11;
	Wed, 28 Feb 2024 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jm6G4Zku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4A25615
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088129; cv=none; b=mIEQUwcm+emR9BFiVaBQhFj0qxLDBHQLnpgnJqtKe0rYgNnNDfuyB+mJSA9puQomQXPrcKBlleHVa0485yaABwVCCFjpZ0Tg412MR3KY4MNohInRHqpOiYlfPzeCk0T3fzvI7XY//0OR4DNVvD4u++3IxfLdRZ8FKCf6Yb5BNcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088129; c=relaxed/simple;
	bh=wTukbFZz6gTZ0AuLeXiBHYZaq0ngrSizsl1vey1TzwM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUi8eSeRfjv2zPN3hF2iu3mq9zJ2XMwaoTWvFKNoo2LySr+Nr2+OQHlNqq6zBfwaaA3p5g4Dlf5Q01OvQRlx+RiUqb5W3ORAAusR3QIGXRRsXG4lwmvLlPOyK2Fu0n02pQnuS8AMknzR8jGQz032Qf+L1l7/50TwH6CWaoF6TWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jm6G4Zku; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dbcf647a9dso4148875ad.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088127; x=1709692927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DGgOzzQ1+jAk85gp0p6D7NJFf1xx8C5oqxWRvpff3B4=;
        b=jm6G4ZkuHsVYDoi4cc6dCfEHacaybn5wOU3GFpqSoz0boWYz0rUoOTFsbvU5/zfXd0
         9M0JoaglZ0aT73cxmH3uR3FSrgqkThm5lG9ERhNuwGS1OyKsU3ufBa6wS8ShddvU3jIn
         os66jQ53NyvLRaYb65w9sLeU5HLz9IQZ8tcD2aETaYgecfgPrGbQDpQskq5i7l9n51I0
         lXOlR4uR89lBzOl9zitud+SKEiEVDVKjz9DbjmD7zlYvPXCbVV6wQWjCrCAYTe424T86
         sRdpoqBHVziaSbFkTw3qA3txAHoHenWoDU68M1OggvH+elix3TCsIkxObKeRE0u2bzO6
         Sucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088127; x=1709692927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DGgOzzQ1+jAk85gp0p6D7NJFf1xx8C5oqxWRvpff3B4=;
        b=N/tGbApuLcf8OaqfStOODAcsP0pthSJ6xVQdTdd3VDjhsBxbrufx0rrORcxg+zr2Hf
         aPBwLYiyshjXy4WC8uWunyVbIM9ugmQNHqoB6nSRZYGOaLpvf94b0jli6JEH5HdJPaJL
         g8zOD5ilN8LbmKeezdPSwbFLlos1wIkg+wquOYGHNDSYsPaqQUJboXYhvX+27kdCGm+G
         Pd+1XC3xnN7ZkHKOehEmWIoePzfdYnCZDWAfeAKuJPNUR8jnVnEoSltTc1yneBKHrXN6
         gVH+dQ9szlJw8mSkRZRzLNfavb7oAEVm4saBh5ljkIF5wPnE6vg89FdsiZ/ji9zugcyz
         Pvsw==
X-Gm-Message-State: AOJu0YyRgyhKROLeWMXO075d5MEyx0iHvRN4kgAkhsEEZV2F60SAYusn
	/3VJGmqDoHQG9SeHn/lJzcgAhL7vflUwya5MThNu2v/H9hQUJcbAB+WXtu2WZj95GCSyyGwpkdF
	NRg==
X-Google-Smtp-Source: AGHT+IHDf3xnx88tyDTwCRq6HMZJvOonccrd+E6zg1vRctJ9bCAsuL3M+j2Csp5VtZWLXjZfAOa9nJi8ie0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d114:b0:1dc:68a2:2cb6 with SMTP id
 w20-20020a170902d11400b001dc68a22cb6mr2554plw.6.1709088126987; Tue, 27 Feb
 2024 18:42:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:40 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-10-seanjc@google.com>
Subject: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above slot
 validity checks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Prioritize private vs. shared gfn attribute checks above slot validity
checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
userspace if there is no memslot, but emulate accesses to the APIC access
page even if the attributes mismatch.

Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9206cfa58feb..58c5ae8be66c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4365,11 +4365,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-		return -EFAULT;
-	}
-
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
@@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
+	/*
+	 * Check for a private vs. shared mismatch *after* taking a snapshot of
+	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
+	 * invalidation notifier.
+	 */
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
-- 
2.44.0.278.ge034bb2e1d-goog


