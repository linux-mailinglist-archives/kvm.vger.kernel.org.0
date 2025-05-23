Return-Path: <kvm+bounces-47516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF1FAC199E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7AB1C01EA0
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2F0221F21;
	Fri, 23 May 2025 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QEWAt09y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC09D21E098
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963090; cv=none; b=Ev5URa144H6MRij8t7d0o7Mvl//rSIgxqglR7jP13Lp/2lWtEdu07WzBPHlxcCrv5RFhbsI7MEsY2cOiTn200nd00iaEE3VB0RI5M6HIplIK1diy9xmyRXNAvmsEof7jDfmnjzYvf3MlhR8H3jBZw8PwZoMFBF8lUzM/n2GyV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963090; c=relaxed/simple;
	bh=dX8nq0dpc2EQQRTZJEyJJGSZKFyoPAvHvk+9J9cF//A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r7/4n0FRXFt/n5RtK6grXBF45lcCxFgHgwZ41l4RYIMT0Xj4tNXsbJFTHo5zSkGvllr1egG3KRyHsXXj5vD/3+tSmaaxfz+Eplj1X2lABH9B2cMO/fkJmXEx03Y1a5yp80qdnoZ2K8TRRRu7pI9ECsuNQdCWg8V3dzgSRmxyggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QEWAt09y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9659a391so5608901a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747963088; x=1748567888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fufLLC396JAskRTF6ENXv8IgKQdaTngu642No/aWLio=;
        b=QEWAt09y2pL8xG9VRU4461w6qLuofwC+yLiRdknAL0xtWwFAqHZ8VjRVDIohbbYNEc
         B6Jj5GjKuWuwI1aPUhbe4+C5w03MKf27Ofzqc68/1TcK3+lXV/hVvo3XnJJ8OsLTl9FX
         240RvsUP5t2IX9sOCLrYyua54J7NsWt+T82AYpbRC7eh2UYkdtGS+K+esKqZgpURd/WJ
         5f8d/3J1fjAO0fZb1ZHwM8l7Oe13taCnWrERktiuJhXRcSN3QrlCOfTGoUc1hOJ78LWG
         wQZu0l1d6vuyqHJHAvTasiwsaQQBRk/7De3OiUMMx3ZV26nr6hbq4EERN7gWp3Ny+k2l
         QxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747963088; x=1748567888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fufLLC396JAskRTF6ENXv8IgKQdaTngu642No/aWLio=;
        b=rtuc9SNsfEkxM1bOpr3KOsIrxRobcWncD8S+payujaOARCvh3AiLQQ9gsZhEn+M/Ng
         EG2eGqUA3X9DbMfJ3ryQpni1JM5fhq+lf/044jL0JgnN6Tlw8wW6YuHyUcYaoubWCI+A
         jHaHQYf9udaPh9+4VTFsohE2g2UqhWMZNmCnEMptK4ACRQ5ABV0gujtCQEg2zTpxrA7J
         vfUBLyZvIhHbesYgxy/c/ypfRUKKxt1CAGTMdPpPWISrXJyS8YsmhE0l4VmVBMU+902+
         ORQdajVrpmah438Ufg+iBuh+Noa46dfbM8MREjg7fWR8pYq6b933p3Zy9QA+AHvuYW+N
         Wbng==
X-Gm-Message-State: AOJu0YwW0mrIcQeRNaxJlZ3d+IUN43ggWTkTJMUQgNT31YfqFGBoLs1S
	xljGJv3UcnbMYzRnrtKZ0m1AoZ0OqxUMFAjayH9ZdNPzoKRZ57CtvPzzvHD9eS6q85jkS7mQggo
	MVJ/eOw==
X-Google-Smtp-Source: AGHT+IFCOYwtizzYjOTae6Mj32F46dgD0uJVDssen2HZ7KTZkiFj54SwRB8bSELTYoqvR+qs9H39zDVz/wg=
X-Received: from pjbsl8.prod.google.com ([2002:a17:90b:2e08:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc4f:b0:2ff:4f04:4266
 with SMTP id 98e67ed59e1d1-30e83216290mr31617531a91.23.1747963088080; Thu, 22
 May 2025 18:18:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:17:56 -0700
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523011756.3243624-6-seanjc@google.com>
Subject: [PATCH 5/5] VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop kvm_arch_{start,end}_assignment() and all associated code now that
KVM x86 no longer consumes assigned_device_count.  Tracking whether or not
a VFIO-assigned device is formally associated with a VM is fundamentally
flawed, as such an association is optional for general usage, i.e. is prone
to false negatives.  E.g. prior to commit 2edd9cb79fb3 ("kvm: detect
assigned device via irqbypass manager"), device passthrough via VFIO would
fail to enable IRQ bypass if userspace omitted the formal VFIO<=>KVM
binding.

And device drivers that *need* the VFIO<=>KVM connection, e.g. KVM-GT,
shouldn't be relying on generic x86 tracking infrastructure.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/x86.c              | 18 ------------------
 include/linux/kvm_host.h        | 18 ------------------
 virt/kvm/vfio.c                 |  3 ---
 4 files changed, 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 043be00ec5b8..3cb57f6ef730 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1380,8 +1380,6 @@ struct kvm_arch {
 
 #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
 	atomic_t noncoherent_dma_count;
-#define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
-	atomic_t assigned_device_count;
 	unsigned long nr_possible_bypass_irqs;
 
 #ifdef CONFIG_KVM_IOAPIC
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3969e439a6bb..2a1563f2ee97 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13561,24 +13561,6 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
 }
 
-void kvm_arch_start_assignment(struct kvm *kvm)
-{
-	atomic_inc(&kvm->arch.assigned_device_count);
-}
-EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
-
-void kvm_arch_end_assignment(struct kvm *kvm)
-{
-	atomic_dec(&kvm->arch.assigned_device_count);
-}
-EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
-
-bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
-{
-	return raw_atomic_read(&kvm->arch.assigned_device_count);
-}
-EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
-
 static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 706f2402ae8e..31f183c32f9a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1686,24 +1686,6 @@ static inline bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 	return false;
 }
 #endif
-#ifdef __KVM_HAVE_ARCH_ASSIGNED_DEVICE
-void kvm_arch_start_assignment(struct kvm *kvm);
-void kvm_arch_end_assignment(struct kvm *kvm);
-bool kvm_arch_has_assigned_device(struct kvm *kvm);
-#else
-static inline void kvm_arch_start_assignment(struct kvm *kvm)
-{
-}
-
-static inline void kvm_arch_end_assignment(struct kvm *kvm)
-{
-}
-
-static __always_inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
-{
-	return false;
-}
-#endif
 
 static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
 {
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 196a102e34fb..be50514bbd11 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -175,7 +175,6 @@ static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 	kvf->file = get_file(filp);
 	list_add_tail(&kvf->node, &kv->file_list);
 
-	kvm_arch_start_assignment(dev->kvm);
 	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
@@ -205,7 +204,6 @@ static int kvm_vfio_file_del(struct kvm_device *dev, unsigned int fd)
 			continue;
 
 		list_del(&kvf->node);
-		kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
 #endif
@@ -336,7 +334,6 @@ static void kvm_vfio_release(struct kvm_device *dev)
 		fput(kvf->file);
 		list_del(&kvf->node);
 		kfree(kvf);
-		kvm_arch_end_assignment(dev->kvm);
 	}
 
 	kvm_vfio_update_coherency(dev);
-- 
2.49.0.1151.ga128411c76-goog


