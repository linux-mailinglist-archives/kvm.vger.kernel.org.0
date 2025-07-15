Return-Path: <kvm+bounces-52486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 323CAB0569D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58D023A8D9A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525782D7807;
	Tue, 15 Jul 2025 09:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rsCsku9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CDD2DCF5F
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572073; cv=none; b=Ts3MrblpDBvPO7dwRhKRnW6Wm2Jq/pfTBaFGvUpKxNK66kZlhYjeE8lKAG0vpcD6oSYj7NWJ3kliRPCT/y5f80v42R/vcyK8UFxtRxBhc3f+afwHlKMt1FEJoUGk5nvc0In+w/6/cxgNMfxYUt90pqp0/VBQKZ1TJ7PgtKrIe3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572073; c=relaxed/simple;
	bh=C3B/tCKG6OjtxxQwarA8/8UYBN4CjZQGHU0NMrczuD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bp0vnZO3rOKZ8wy9EyOrBHBvt+45GA/htiXTmKEXekM0YBJWRzBtfHZx5j6Qzvf9+oPGQ60Ym1eEU0HUW5VYEYwfIlMJ4BBWu4lS5DXej7Yhc++v7q8XL9UWkMnXBPCpvXHasDb0cioRKc8k6HBB1mDZWO0JeMs8fGJm/uYa/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rsCsku9/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45626e0d3e1so4969735e9.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572070; x=1753176870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=47rVlr8Uc/SdJ5Y2yETdFZUDua/sXacoe643TNgwpkI=;
        b=rsCsku9/Eg3hGHJNlYuq/2ImahB6S3AOsLHEa5j8lm2CmCqs5oi0XT20RaTFR6SeZT
         tQDjaSwrSTTkJV5FrGh0gOGdq8YSgQ8ZCzGpi2/CyjbV0qK1b4QvVX1Gs+i4LjhvrHZH
         /7Sds8X/ynyNzWrMeLGnxDzrRoqhu/hWrI4Z94DR5ZWBsiMaXt5LuTmOCIdYXNkg3QW+
         42viLTPWYsxyC/k5Dk6F7D0kjNmXXXGHOFx7IcaX8rHLacpgNgiP7JZIF0CNlAs55Ume
         7RZ/g7vk3sIcJXaCl787eDC01bxKmxiaS6M5p5SRNEwnOW1Gse5CO0ff9Lk32m1pEAUG
         vwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572070; x=1753176870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47rVlr8Uc/SdJ5Y2yETdFZUDua/sXacoe643TNgwpkI=;
        b=An7JHMMFnnj0yhaIjyCCs1jqpUihxODGSD5ufXYhL5PmJSxAPmRZFYIiCapDmDCmu6
         Kpn1s4Yo1KHW8U2K5qoQ8IijYSRl3B3C/YfZgKA1kbJD47LwJHgrYA8AOpDXCS8l8sd1
         OXobhqbt2yM4107GlEqaFYeQh60DRIllY1n/kdONyTguxbCFMUiklUvimO0G3pUCgCIV
         DKFeuWm+DyR6crEh2FQ+qHY3SyFEYlSm7BbtPgICV/qEdD4XdVS0Cb/N6haX7Z3LwYZY
         ka6kvYAwDA2WykOvrLawvyw6z0iCDV4sECMULBLDsuR5aRrVmls6VybVuYhpZj2zF+8V
         zzRg==
X-Gm-Message-State: AOJu0YzpkFZ3ToWmXg3dAcw0aT9Hn2xbmRr54aVSbxdxMgHMRQgG666O
	qZ/RObLhKIO8q1gg2Fkm+eyiS81WbmZp6l9shKZgPnzdJMYXkbOtd1kNXw+rs3T2tzdhvq9hSKg
	ihIcvpZjTDmqDskm9AzvUqJeI/fCdGqAyDddsS2F0CQWjjaIbzDwUIxOXaP74PdyIkQGDzdTsaF
	icySAK+b3UbTkG5nkRV3KWPaku574=
X-Google-Smtp-Source: AGHT+IGZGGp1NFdrhGIBj0xIFeHETS5Eg5RNZf/7w6Lo5N/3yqifjyWC27FTYp2tf115ynIZyMvpUL2uow==
X-Received: from wmbdr14.prod.google.com ([2002:a05:600c:608e:b0:456:15bd:a297])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b17:b0:455:fc16:9eb3
 with SMTP id 5b1f17b1804b1-455fc16a2ccmr100761475e9.33.1752572070039; Tue, 15
 Jul 2025 02:34:30 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:47 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-19-tabba@google.com>
Subject: [PATCH v14 18/21] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Enable host userspace mmap support for guest_memfd-backed memory on
arm64. This change provides arm64 with the capability to map guest
memory at the host directly from guest_memfd:

* Define kvm_arch_supports_gmem_mmap() for arm64: The
  kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
  CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
  types that support guest_memfd, this enables them to use guest_memfd
  with host userspace mappings. This provides a consistent behavior as
  there are currently no arm64 CoCo VMs that rely on guest_memfd solely
  for private, non-mappable memory. Future arm64 VM types can override
  or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
  if needed.

* Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.

* Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Checks are
  added to ensure that if guest_memfd is enabled on arm64,
  KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
  guest_memfd-backed memory slots on arm64 are currently only supported
  if they are intended for shared memory use cases (i.e.,
  kvm_memslot_is_gmem_only() is true). This design reflects the current
  arm64 KVM ecosystem where guest_memfd is primarily being introduced
  for VMs that support shared memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/Kconfig            | 2 ++
 arch/arm64/kvm/mmu.c              | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e41a880b062..63f7827cfa1b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1674,5 +1674,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
+#endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..323b46b7c82f 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,8 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM
+	select KVM_GMEM_SUPPORTS_MMAP
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c82df80a835..85559b8a0845 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with mappable memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.0.727.gbf7dc18ff4-goog


