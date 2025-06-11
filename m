Return-Path: <kvm+bounces-49062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 166BFAD5744
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B7B3A583D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4DA2BE7B1;
	Wed, 11 Jun 2025 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VT1v5AJW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D3C2BDC39
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648847; cv=none; b=k8dnKgmNvftdJpy+5hWgT/1zOAaymFo7+hQvY4vp4vaaC91qGeMDtA7KtVQptOPdfUjMHjjCZ1AUikwdsyyYHHIjCOfXnp0o6oghFhI87EZN5KCvsw/is2uFsSUqsvYTxBQuYh5+I9nKLRjQRGxeZ+3AolTry1jibGUPo0OEOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648847; c=relaxed/simple;
	bh=afnwtC3mJv0p/q01Hm03VsZ9g+kofebcwWBhQ+EF1D0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ujkWDzXnXCMapQaWIjl1WXDj1sQgCHM8BPX619EXUcZhrlwBeTTH82RBuIr50HGTp8TB6Vr/QZ7eipah73BOHEAMVSwsL+d+X4flA0jxEee7ShkfhTIghheWTZzbs4ErnJmdgjwR5IlAKH4NlY/SVtc9KIMhoww5TWrI/Js2nSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VT1v5AJW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a5058f9ef4so3117209f8f.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648844; x=1750253644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr60yTRM3Le7KlhcyzAIwAP1RCDbA7i9ZnNcPDG0Gps=;
        b=VT1v5AJWu/NsYW/1e0KSEKs3rM+ou2U/8cv3SNJdrBtSP6G3fy3qWhBuO53akKQ9Ya
         8XWtxr9nd3tov8r5hn2ZlyH22hSUPSNxIAHDapWLQa8jAkK4u2k9Glh7Cmn+WYOsFEH9
         OxkNTRNggJC13/4XU1vNKLFxaKHJmrdrQ/6By2Kr+srVYYkuPysIFvorobKvG/fmWraM
         ENrahrD4edf3cp7lbey5JQo03S9BHh/7EMKMD5ELuf8o3VfzZBhf+f62jDVqNmUrEcDR
         VNcEdv5kj5Jov2qQAmo89VYmgPrAou4bNhhL6lwmiwIj8TgMloXBDudq48hgWRuYDUuh
         NIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648844; x=1750253644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fr60yTRM3Le7KlhcyzAIwAP1RCDbA7i9ZnNcPDG0Gps=;
        b=FxnRM1fQ1vwXrMfpt6kNyXyJ2rNWYGJeSS9ZyyOdXA232qjNCl0MTZ4jU72G2iwouu
         dAUlKjKPKTquCZ5K3zLcStonb9Zb/nWKoOc7B7WEC5pv7Rx/1dv1zBo8NZt9H7ZcW/kv
         DccJ85hzO9bas3h56YbbocKmEtPee+IqZ63xytnuAQvT2UCgcAS82cq108yKKKwp96FS
         triUpU1w7KMrFvOw/VnCytjz3qgB7GkfeaDr9Re7Q69IzNZKZU2fcG/x0blxqeXrypWU
         608AlrNK7n5bMmJXjseyhEiiu35Jczxn9guztXw/6iPedE5ldoSWGSfjCNPF8fwaV8+y
         U3sg==
X-Gm-Message-State: AOJu0YySANxWmM0GXtMS27xbcpbLSFwMnkYJPRWQ7SGDupoZhvgt8Ny+
	B//1/K8oS7nC6OGFJITepeHAHweCPbTK6AzAPfZ54m/2WU9EZo5ajxcdnNK/yiwKeMUg+EwMCPl
	38XFT9MIRWSJmBnonYpZsa2E2BsLh9M0gZnWqLq5I4GW+3C+jyinSiLPjuSC4V2b/qMRegVzDg1
	xBTKT+gbcRQOx+TAjOqDKhrnM3jF0=
X-Google-Smtp-Source: AGHT+IH14t+wSkhybtHuLmzZkceSzcjY9wgExM45VH1zSci1aRvRXa2k0A1lOzdSmzXE1XT7zgcgV0z25g==
X-Received: from wmsd14.prod.google.com ([2002:a05:600c:3ace:b0:43d:1873:dbaf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:144a:b0:3a5:2cca:6054
 with SMTP id ffacd0b85a97d-3a558691a5amr2274572f8f.4.1749648843428; Wed, 11
 Jun 2025 06:34:03 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:27 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-16-tabba@google.com>
Subject: [PATCH v12 15/18] KVM: arm64: Enable host mapping of shared
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

Enable the host mapping of guest_memfd-backed memory on arm64.

This applies to all current arm64 VM types that support guest_memfd.
Future VM types can restrict this behavior via the
kvm_arch_gmem_supports_shared_mem() hook if needed.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/mmu.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ce2c5173482..0cd26219a12e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1655,5 +1655,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+#endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..87120d46919a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 71f8b53683e7..55ac03f277e0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2274,6 +2274,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with shared memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


