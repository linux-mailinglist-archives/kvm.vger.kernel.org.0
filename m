Return-Path: <kvm+bounces-44945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 200C9AA5239
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7599B1673CD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF25266585;
	Wed, 30 Apr 2025 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rKeOxJ8Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44426563B
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032228; cv=none; b=h2Odj5wj5cloEo5vB8EyiCUAFP8Y1a057Fa4LHj1Qy2Is6dFmODYYOgD5odMDuDXvRDOrqkBCkXV0PBO0RguYUFopmbbga9wX3Thzb0v6pkQ7two9Qco6EHSFvRJc/9/nGK6Ab2TEmzDXjUvpDyklay1nbbMRyNW1JhsFnJJHN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032228; c=relaxed/simple;
	bh=0TQvTx5CXZPmFiUOoGx3wMGS7zheBLdOgtENc3r3J0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AHGzYogYhRQVpLRqvW8Vglc/VG1ZOMSNu8z/VI5Kop67IRWhU25a3RzfQGqbFwIJmYkrefwMYtlJznoq6DR7UbiTfm3qYiDW1TIsuOvm6sumrU15IDu3Q+RbKr/E1YCbYnXIexD2hXpXXkO8QLy/M1iJSh53s+dxL+qJDjuMx7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rKeOxJ8Y; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso179555e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032225; x=1746637025; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+iNXVDAdj/+L0buigDqwZwszhQH/OtOVJlCHKS7HfQ=;
        b=rKeOxJ8Ykydsysr11XEtuJrMc2JkTivZMIPHy16Mg6T+kLJc6505G1E6B2GXprUgOn
         823v8IuRVmKb6N+wedsRb/BrOVWUTjpnnKjUDK37QLPyadpAfeKGeHastNsRa++SPTKG
         AB2YnlCDjILDv1PP9QnFrftBROcrakDIwZaoTGba2xEPJhoDozfC4PIkIs/REk2QhBca
         h8iNBWK0Fsz/xrjlr6CKI6yOjhR+0JIZNhaoel2Nt0zJg9TBZMSGBOL4Ac/UmsKlHqzK
         LkoBwQ3i8g2PMgtKjQ1cr7kxsRZz/wiBSy1he3F/rB93DONYeKQ/meQjSrwqUeV9zDks
         ocrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032225; x=1746637025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d+iNXVDAdj/+L0buigDqwZwszhQH/OtOVJlCHKS7HfQ=;
        b=dTqrTx9fJhQtoYUCCFiGGG9GqYVK6v/iAUnwzyuHaizLiGdLRgtODcYQoRjoqYAA0D
         pK0bZ92nsPkPJbwCmq7jWfpXxfR1AfZWmF8k85e+VikD5EgncU6IG5mvY8xRQEDNfeRa
         7gKhbjFQWWkTlaUCs3n73pUKtgkDh8y1fqlMqS1YDpexjP3YpFhfgHvzGWdbspK0kLwU
         8S9YUSFCMoNNE05bx9IztrWkvOXr22OkC3UfkMO3bGZcimNAvxNruZHwS2c+tmzS1sEU
         ysKDQ2WdcVOwY8+JnnjD1z0ED9LxpuRqgPlWB1toERMQ8P6t9S8Pzgx+6aHZk1qszVof
         2jOA==
X-Gm-Message-State: AOJu0Ywpy8aXlyxW7Wi2nsk0ywh1T1YTIWtO7zzNSIRUFwd0tuQhthVN
	VNdbOChoTlJkh81MhUh7LKiP4rDoXzj3WhpCEUdJj3+/du8rwZlHy2m/orCoM25SwyNs7E/52VQ
	6gXTOq0SI8e9tM0z0yPjk/FF0JwAdxAMQg2aGW6kLIve+m6HxZ/G0uCp8cQdiDitelVTyGoj5Pj
	9I2lAb7lUyQvsiJD4Rd2Kv3J0=
X-Google-Smtp-Source: AGHT+IGeJ+b68NCUJ4eFqZSVib8F8N0sKNWqmlNPLoK9UTBi2tb0PPBoARkhkoRHW90xn5kcTM/fwf0JnQ==
X-Received: from wmbep11.prod.google.com ([2002:a05:600c:840b:b0:439:7e67:ca7b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310c:b0:43d:fa58:81d4
 with SMTP id 5b1f17b1804b1-441b1f61365mr32474785e9.33.1746032225114; Wed, 30
 Apr 2025 09:57:05 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:46 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-5-tabba@google.com>
Subject: [PATCH v8 04/13] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The bool has_private_mem is used to indicate whether guest_memfd is
supported. Rename it to supports_gmem to make its meaning clearer and to
decouple memory being private from guest_memfd.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/x86.c              | 3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a83fbae7056..709cc2a7ba66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,7 +1331,7 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	u8 vm_type;
-	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2254,7 +2254,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_supports_gmem(kvm) false
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7d654506d800..734d71ec97ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3486,7 +3486,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
 	 * case might go down the slow path. Either case will resolve itself.
 	 */
-	if (kvm->arch.has_private_mem &&
+	if (kvm->arch.supports_gmem &&
 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5d0c5c3300b..b391dd6208cf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5048,8 +5048,8 @@ static int svm_vm_init(struct kvm *kvm)
 			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 
-		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
-		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df5b99ea1f18..5b11ef131d5c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12716,8 +12716,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.49.0.901.g37484f566f-goog


