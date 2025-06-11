Return-Path: <kvm+bounces-49051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 060C8AD5726
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9F4F165E94
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A3A2882C5;
	Wed, 11 Jun 2025 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FO4nOTQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358EB28C5BE
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648823; cv=none; b=IaakiiD4D7VudYnIUVzMuhf45jF6KiLZ3iA4Fql3ryUoQZMEfR5ZLgg6Mmoy7B1k/IPiN9N9xZHa50VbE5vi8IkzWs/7fqrxJeSDtaOWaZPa4Bc0uEwjE7Jg2tHbJPtBTQ3dGrtLBie6fWwLIzn5ysLOCEXxV5qpj5IugzHAHSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648823; c=relaxed/simple;
	bh=UnBr6ZKeBRX2X4RzMs4nllrQn7CMH9xEVizI/3gix6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U7pjpNjQ/8a8uG/UFoCP6avZ+SkXbzq5roRCS48Ko53PPR3rVSKCsnaUHGfEffNWG1DhK2zFbSGMKAqFKbxHIb6ITc7COvZNyNCwbzV6YZq7/wIz84F2oPXqD6aD4alLSMlFUG54gomsXYej8px3/ZTNaqTRKes1oTXgJy7yjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FO4nOTQX; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450df53d461so57763635e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648820; x=1750253620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7yd1sTKmH/kZRCQtJiM/n5Yx3TGG8dKDUQIn8zaPVo=;
        b=FO4nOTQXyjIvp1P7zjERUwk+R5UiGk9XyG4RNowSC6FxdOrxO1eIS6vdzevT4xfr2A
         qkn/WiMjK/P/t4s43s6JRX+pmZleNPQDkMjuARITjXdsig1urfqDpij5Qo2y+gU6dMJa
         /2doTEy6ZxlMftOYu2nS9um2qt/ENJW1pWsTnLhpyIiwCIcqCO0aOSkLnApmEobCy9op
         k+izJ7EJ4JaxRnJSMAknToPpwchcdWKeb/F5wI8Sh59rHHVJ3AozanbHFsBlye85174Z
         zHSgYo6M+ffNGrnB4ioGWQ6PTz9vdXZQ4PRaWrD4fve7667VKd1E4aRxk0v2S7jtOGXG
         irxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648820; x=1750253620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7yd1sTKmH/kZRCQtJiM/n5Yx3TGG8dKDUQIn8zaPVo=;
        b=h86YxT5Fgs6QkGvpX7CAx/Q9p0l6cB/w+w/rBkXMZVqZJcJvs5wLzgU7Yt9wLzA52d
         Z+ufRhHEZBleZVz73nixycd4O5C8cLh/l/uSx80pPzvF2tQ6+/dGvkDeY0RX+BaMk1fn
         omnvV37oMN5tJIn5kF/3/t74rSMQ5ncKDkm8a3uyGIeiL6Kr1EdELrE1D+Rem5IXAhMJ
         zBfDFuHDs/nRkGFmM7hVmE2YHXYVne/fFVw9e7fmUgFk95Jg7BbOQ78oOVxjpeopg+MP
         0IDar8wc99mr6nIClHrSWIVlJI9yu5NgCqAitCLDrmpR9c3Xv3YCXYkCELmd5p6KbEOG
         lyCQ==
X-Gm-Message-State: AOJu0Yyv/ifr6eb3HX0hKShyIQ1pknmFi9esMpprf3j8iDUhHvuwn7Sh
	YONDbhmDhHFNMfqWV49+Z21RV4l4QrvLFmteyqDOoKau15TRFLP0Pvdg/vRE9PqIHTKt5amOtCd
	yXnAfJKpC5caMXgOBK1Vpc2hQJ3M3sl8zcOP+HeoNayN0k6GWwZZkDYf2Di5SzH80Vp3R7BVqDX
	F7yaXJUvOmR5CP3mpYKc0iJbp4mac=
X-Google-Smtp-Source: AGHT+IFYroU/xAzMZJoiD4oD3uWDCygQkGmdgzYq+m8br75EHz3uTlJS0gPFUhk11qXKmVV8klVdxJfKvA==
X-Received: from wmrn17.prod.google.com ([2002:a05:600c:5011:b0:450:d5b8:85b2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b04:b0:453:a88:d509
 with SMTP id 5b1f17b1804b1-45324edfb8amr33328415e9.10.1749648820022; Wed, 11
 Jun 2025 06:33:40 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:16 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-5-tabba@google.com>
Subject: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
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

The bool has_private_mem is used to indicate whether guest_memfd is
supported. Rename it to supports_gmem to make its meaning clearer and to
decouple memory being private from guest_memfd.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
index 3d69da6d2d9e..4bc50c1e21bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1341,7 +1341,7 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	u8 vm_type;
-	bool has_private_mem;
+	bool supports_gmem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -2270,7 +2270,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
 #else
 #define kvm_arch_supports_gmem(kvm) false
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e7ecf089780a..c4e10797610c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3488,7 +3488,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
 	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
 	 * case might go down the slow path. Either case will resolve itself.
 	 */
-	if (kvm->arch.has_private_mem &&
+	if (kvm->arch.supports_gmem &&
 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..67ab05fd3517 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5180,8 +5180,8 @@ static int svm_vm_init(struct kvm *kvm)
 			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 
-		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
-		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..401256ee817f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12778,8 +12778,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.rc0.642.g800a2b2222-goog


