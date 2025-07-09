Return-Path: <kvm+bounces-51910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BD1AFE6AA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 929CE1899887
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA5128E605;
	Wed,  9 Jul 2025 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBAp8rME"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467C1288528
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058800; cv=none; b=GwHX367N58eFAPWdfOr9/PNvjFTd17YDxRg91btruHaUxQ2Ji2n0wRuUBg5XokxVSOQYwErOUAme8lIaZrJ9Pg+McCXdt7EIFxXXUuevyy0L3OetmHiftO1fBQ4uZwzBEts3C1qA0zeTtXkjQzNpxP2H+2mwelHbo2tA8Yagrns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058800; c=relaxed/simple;
	bh=2b6nSv0bwUErhVoOBs3cT+exDtwGfNb4xvlPdPBIM3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aA5eY2L5mdtrQGC5z/V18sAIrVIMROL1xz24Fq86ygQBy5/PZ+NNdwygRSZ9i5Xs8PUhEyEuXi4jvQFoFQ1+ZfW5aYqKUiwIk7B0iEjFkieCZ2jxZNSUdvhyoUmT2nzIrS0lCkISeazyF0lvOa2/6tw//zlPfXmciGTPtTq8HzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBAp8rME; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso3564003f8f.2
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 03:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058795; x=1752663595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/2/5k9iCVK4sluqJkzej8GF1zXf8/iatR3hB1LHDLTc=;
        b=NBAp8rMEiunjCkzfxdgpYW5Q+EyA97BnrDp6gQTcf1SPtXC2u4UKHwoRyBoLgdxyxW
         EJwgjPhZEfFyIb+nmiHEAqy3wsy9FJc0ZarqXAdEBdJvqAXrbvDcKUuHH1vVzqqkthM0
         k7l1XGi4tZum4qV96fhyOp8TXo77QIsoNQwgaPCVi2gcttJR2ML6KM1W17S5Fv/PfMmy
         j1IhhmeJa5rzrDypp79byAL6dvU14CGLoM8jca6xUIUY3V+72eKdBUeeQYvwpKFR0I4j
         te+cLvf6+rNdLgxmmyYlbw/4w+UFw8Q7qqjZGgeRtgtas5Uiqd7HmzIGwio4scHGEkQU
         PUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058795; x=1752663595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2/5k9iCVK4sluqJkzej8GF1zXf8/iatR3hB1LHDLTc=;
        b=dP9TpnmfqayZlapd0ZKQNOtvyswmd52tjNmaYmBSqPNl3cGaPtlkEnkh/B6eRR8kaB
         cG5M8hx8xtDJPVRWa6RKizV/tnJUwyEIk6jp7jhhfD6fTCMPeC6QbOJ5JvrGXujAUP9Y
         P6Lain0ZwOj+RUvsx2Wd/dhqlmW5sU9splIZxea+yKd65cn4nqng6HESbXIHdDtvxQ8W
         LLKxXceGbJoUlAVUMh1damyp7hHs/WSajMOqAcIV6Sn6kw4/yWVzMqXsk33LcwPP+Qv2
         TZSsZmjpmBBSlGT3Awk6VYe0uLTsZ1qTe7GUvstdO3idByUn21nOEMLU6oTccHhvGjE/
         OXbA==
X-Gm-Message-State: AOJu0Yz38P0wGUW/nqGpDFmr3IZPBjgZ1FwBHrb5SGhRUTrUesKdOEHZ
	TUlv/xtTRLSU0+Y2BJn2nZfPZSbQtfDWkVxoQyLDoNGW661rkIxZ39XpYC05LhJdPWooFaHJadW
	wTMCE0TJc8Z4xtLDpsdh6QfiBJ0Oscd5vvKTzTiiPzdja7ndGLe3sjeNuXqdOU8R/cWmClUEgW2
	eEBfelSPxfTdPFslt0dTLneKrEw1M=
X-Google-Smtp-Source: AGHT+IH+GCPnEbUmc5xCDJrxqxEMrnsLUxOEixnkyz4j0lbk37O9I/877tBzCTgA4X6krbxurCDFJURhUQ==
X-Received: from wmbhj26.prod.google.com ([2002:a05:600c:529a:b0:451:d76f:e1d7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588e:0:b0:3b3:a0f6:e8d0
 with SMTP id ffacd0b85a97d-3b5e453ec38mr1599355f8f.54.1752058795174; Wed, 09
 Jul 2025 03:59:55 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:29 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-4-tabba@google.com>
Subject: [PATCH v13 03/20] KVM: Introduce kvm_arch_supports_gmem()
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

Introduce kvm_arch_supports_gmem() to explicitly indicate whether an
architecture supports guest_memfd.

Previously, kvm_arch_has_private_mem() was used to check for guest_memfd
support. However, this conflated guest_memfd with "private" memory,
implying that guest_memfd was exclusively for CoCo VMs or other private
memory use cases.

With the expansion of guest_memfd to support non-private memory, such as
shared host mappings, it is necessary to decouple these concepts. The
new kvm_arch_supports_gmem() function provides a clear way to check for
guest_memfd support.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++-
 include/linux/kvm_host.h        | 11 +++++++++++
 virt/kvm/kvm_main.c             |  4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 66bdd0759d27..09f4f6240d9d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2271,8 +2271,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2325,7 +2327,7 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define KVM_MAX_NR_ADDRESS_SPACES	2
-/* SMM is currently unsupported for guests with private memory. */
+/* SMM is currently unsupported for guests with guest_memfd private memory. */
 # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 359baaae5e9f..ab1bde048034 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_supports_gmem if support for guest_memfd is
+ * enabled.
+ */
+#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 898c3d5a7ba8..afbc025ce4d3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4912,7 +4912,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return !kvm || kvm_arch_supports_gmem(kvm);
 #endif
 	default:
 		break;
-- 
2.50.0.727.gbf7dc18ff4-goog


