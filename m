Return-Path: <kvm+bounces-47810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3E9AC59C2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97AC68A836D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180572820AD;
	Tue, 27 May 2025 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g1rfrfM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A636127D776
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368981; cv=none; b=fiBl0HosiMxQJ53Wuuq7sFTcdae/g6LgFvgGqE0L2xFmsQ05oKEFf98AjZnJQhBZBSXqSiKmk9V3Meo+RwwlknNddXAV8puNh5Dkp4YQLWt0BEovIyd+nJCWyHDRdIK2+7xRw6LfJgOAOBQMnl1zYFTCE76NT/wFfl0GiiOBt+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368981; c=relaxed/simple;
	bh=Eot37zmLKilj4Bha1mt6W8syR6jjo5Jw837ljSExbSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OesJrtDoh2bXxL2GuM/8Q+0iv/e+c58IGjvog5+lIV4HxuaxrjgEFDjLAQ4cPpS9SeMP7WKLyMXE1kU6Nn/tv2wOjbTaOhI60XlMEhu3x+LpGbxFqyADX1o8tsEjWdTDgTQnUnX9Mk0UDEMY+KWGTWe3zjvlTyTDUhpQZZR83bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g1rfrfM1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso20790205e9.3
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368975; x=1748973775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qcf5r9fuEv4TeXNhRM/FFKnchxS488iMuxF5wS7th8=;
        b=g1rfrfM1r4YlV46XbqecaQ1sqgkLc0yRYmj6bZewlq0SLwGtNCFNLxC8DUj0TYnRC1
         WcGJ4JptFtBrdXZOm5TEd60lDQs1qe4Pn9ncYya+3l7yyd13fB2TtqkQ024Q/SQqKAqs
         4J8Mc6kkkb16GdUkz8R5YNhtppm/1ZGZexRzdSOtCMUhuwoRjpLXC1Prgh8bgwlzBebf
         sjVlOZrncGdLxFypvnxFFYvoFD9oSTFDKthPLZGhCc+OdX5tyUvNhlsVuhYraftQ7i0K
         pdtLYDPFzcM2nkR+MI7tCX8WprF88uzBLAzX5QSiSAAamE5TlJzniX2GBpw4aNqklh7b
         OJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368975; x=1748973775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3qcf5r9fuEv4TeXNhRM/FFKnchxS488iMuxF5wS7th8=;
        b=WGxYoy+0Yp8v2QcB2XFfY5ax8TTO0JbyfJih7ytcGFMDczMml3FNQksq3jDMeWZ/qQ
         3VnS2cOng2c+d/9zwQUfxxCyOpOLb6cBJxzED1jdSNg440khVfUo4kh01mb1yJOhgMiM
         oCjyPmbmhKmiMaFemMDyw95GfRpzTcakj2ezEZfq8Uo2xTLZGUS3IgZsKmOLP9GgYjzJ
         CbXK6zgdhJUI+yyd7SYdVW+7Qq2osZvLkssLx0dLCsjexU/19rH59YMtOSQc+yHrnfR4
         27y7NL6hjw9ds9aSapNBvpXr5mmceBme+UJjrJQhNLLiKyd3xtRCwBx4mCpBSfDKLVua
         gwJA==
X-Gm-Message-State: AOJu0YxefWkjlEaPgNTee+j4J7csBAQFnbgyyFtnYTnkpqfgU+dZwlxn
	4eNL0/X6bDFia60DhfzZ1GuFWXnn4vXkt27r9h7MdDdNc/FQjeWX4Zh7DQ7uD0qtINz2pu6ml+g
	eXbCz5C32DwYp4WmXo9+R7kzBtzpad/DzK9HsKYz+qv5QOHG2HUiOfovXU3giXhkSeRcH0SBq3A
	ilFT7m2fk3iwpj1obgNM8vm66wq4I=
X-Google-Smtp-Source: AGHT+IHCvb9oBv7M9nYviQPq2lfNId9bBMU1rJU3c1ZALC9CNK8cl36mxeGLwyYnRx/AcP4NkYwJmgvK3A==
X-Received: from wmbbd24.prod.google.com ([2002:a05:600c:1f18:b0:442:dc6e:b907])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:430e:b0:3a4:dc32:6cbc
 with SMTP id ffacd0b85a97d-3a4dc326fb0mr6674535f8f.20.1748368974318; Tue, 27
 May 2025 11:02:54 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:33 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-5-tabba@google.com>
Subject: [PATCH v10 04/16] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The bool has_private_mem is used to indicate whether guest_memfd is
supported. Rename it to supports_gmem to make its meaning clearer and to
decouple memory being private from guest_memfd.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
index b66f1bf24e06..69bf2ef22ed0 100644
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
index a89c271a1951..a05b7dc7b717 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5110,8 +5110,8 @@ static int svm_vm_init(struct kvm *kvm)
 			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 
-		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
-		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
+		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be7bb6d20129..035ced06b2dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12718,8 +12718,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.49.0.1164.gab81da1b16-goog


