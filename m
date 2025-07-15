Return-Path: <kvm+bounces-52471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBE1B0567C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E9F0563472
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244332D8398;
	Tue, 15 Jul 2025 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCkjx5dW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763602D6603
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572042; cv=none; b=WXLhsKyDe2PPcKwTvJgFFSgknYvJCvCT2VgE/IBTAYv9t9prRxPKZDrbHcQBVL6a7bRBYYD22m2fgMaAzTr1KdA552rs287Nd6/Vy3JbdfPjrl6ZCjZ2SgRfKbch3cLZ6PMUJrP3mF4FYtNLQ9SmJHjx9ZsWWgWbdQwSBD3eAbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572042; c=relaxed/simple;
	bh=IZ5AHKXw15eeD5dW7wpbeUhThV1vd/U26y5B6eznwi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejrDtcTZHqDAGJtspP7ASWevtEVRzeZQd8zjjNkoSLaxx79dwDKGr4QO1/OdD7J9iDEs49oT3WkoYlHLv7sg+u7ZTMT8Cn+RTMdM/ctSextTP0t7HvkN8L/lDA8Fg37M8VudnA+IzxGP2JRy0BdMt8B/HSAwQtNdftfJ+N6QbI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCkjx5dW; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-606ee65164fso5748314a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572038; x=1753176838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yc2PxbUB6sWoXqmBD+SX5wgz6y1jaRto2Doaa4ZyIEE=;
        b=RCkjx5dW8/AvmYFGtM3qVFd0G/myOOiN0/jyGEK0rrivAHa/lEgiEquM9jAcPRuOn7
         jM6qsAqjt5F7rmAwdp1NZqbV33KmmHZCN7hBPmkchii8Uss3fdR3/wW9jsatuaBmN73a
         M6Kema+rc8xziJSAAe47Uz9mkAA5ePETen8iSJ3h7sR0kY7Fr1d2kQxQBPP1chqYgvyZ
         NXJU7wTrOlGZ+znnS6LiuzadWn0lpDYO1sToQYo+oycaNI8+8+h7ttvPK1no9vEw/NvO
         HRaBAP0A2djrP3Y88vy6IC+GyzkCNlWEzNqY6MvxO/yPZEw93ZE70ECWSUaLQIoDnui7
         mUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572038; x=1753176838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yc2PxbUB6sWoXqmBD+SX5wgz6y1jaRto2Doaa4ZyIEE=;
        b=bpDAd4Kj6aFP7KrAPXlXpDqxDJczi6uXRRd4KfyPEgWw5NpQIIUhaZs3/0sx6RG3Wz
         hP8F+/T7phSyMbRYn6nZgB7iNzq7NB9yT1xQ/f9gv7TMSKHrsb7n7g3CpgENR4lQahqD
         hUWcSUfB+hekq5M0yz7kgEOccai1iqMjeIwcRAr9sKhZk/4aw1u4eleAEufgBCV60mUp
         5ebgjbuDmwFgEEdMVCHGEycwxyQQd6X266MD8qrEKdlxd3tNzezhZW2PqEGuYRv22KVi
         jiPU2Aov/BIU/+NTSS3d0OLOSIeiWeUsMzzxZ9AYEBpOo420ctYVHNLR2bZguhCuMmdm
         I7Sg==
X-Gm-Message-State: AOJu0YwfYpoRknJVKAubQG245p0jAl4El5lg2UHP+cTuyp+96kJwRc30
	GcpfEazog7vYvBGGJkzxD97A3En1PCSjVwHsuCOiMISthmuIULfgOjldUUjbY+SGtHv5XOoLTn4
	pVQnAyXCUhdm6WpW0ZE/1zrpOD3GuXr7LJCqpU3yWhqXFC3A5+owzDxxx/frpPCNLbvU3X35BrQ
	fvhAjyADg+yrVvKY6yfaeAQTVmivc=
X-Google-Smtp-Source: AGHT+IEXYs7T9kwp4zt9Q6duZzuD37c0z/m16xiUI6ublpH8MZEPzSJPqggoJ+YdDeQOgE64Wo1Xc33Ecg==
X-Received: from edip15.prod.google.com ([2002:a50:cd8f:0:b0:60c:7ccc:867c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4308:b0:606:dee2:42df
 with SMTP id 4fb4d7f45d1cf-611e8490658mr14145606a12.17.1752572038209; Tue, 15
 Jul 2025 02:33:58 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:32 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-4-tabba@google.com>
Subject: [PATCH v14 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
index acb25f935d84..bde811b2d303 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2277,8 +2277,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2331,7 +2333,7 @@ enum {
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
index d5f0ec2d321f..162e2a69cc49 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -4915,7 +4915,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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


