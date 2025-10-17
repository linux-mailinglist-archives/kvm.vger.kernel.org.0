Return-Path: <kvm+bounces-60252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C500BE5EFA
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A5D5E3571E4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C7128506C;
	Fri, 17 Oct 2025 00:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AeJO1Vfg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96C627814C
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661189; cv=none; b=AtLJShzuj2o1TNqKG+vUnBTLTz3B0XTXQVExATwKLahybKWENkkOW+eM6lxReJFUEjyH4o9jXAX/o6NpOEcviWbQIi4oZe8d3Onq0tPSfef8b7+mvk+pLGj/8dkpWYDlUeLtD0dVX3NDeka6pkw28f70LP5mrA2nQv+Kna8bgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661189; c=relaxed/simple;
	bh=k9Z9jxwZO5TaNJ3JVHODzpRZ428q5OixM7USLnsTl5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KccWbWswgNrWVPudV9WiUYO6dKEnSXOnNg/b3RsjQtDJd07TdVPJw2jddq7q7P+cDNC7K57VUhdnWdPlTlIv1+fsQQi+uL39f+K/AZ7U+cmnHA2j7RPonv5Yk1stHA7ELcEweqJ17gZQmvvq0bH55R5e49WAcdB+WudMNLgAKnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AeJO1Vfg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-277f0ea6fbaso17441255ad.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661186; x=1761265986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VqN6FPJY384bIppIse52Rb5Kgtgq051USSGGCGlx7fA=;
        b=AeJO1VfgJohwvULVXJk2NTW8Jdh/YNcAKx0bjr2W0pS6gFtanW3VoUWwICyRiTgFBC
         DmB7cxRVzPenINwp6L2vRYSBqvKAjIPtYZfjLywoVnkjU5SbrC0jzX3vJw75OwsYrgkK
         D6lyWr9icVCPOBGk+3FVogjBeK127/EOzaocvc6dWsdB5gYECn9EXW1RpxraSdKQGJHZ
         dz6zlXeHolZ4zNMcG9oq7hb4tgFjxSq+bwTJqFAV2kCy+NL0F8JWdKFVp2Jg1Ykuky84
         rKRMx1nrmcn9WkFNHp6K9oMOLeGVsojpM0/IHebO+ovaDaEmNky//Q92VD3vn6OjP3C0
         crgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661186; x=1761265986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VqN6FPJY384bIppIse52Rb5Kgtgq051USSGGCGlx7fA=;
        b=APdpyUeywB+zm80fmE6RmfV42nsy9A+UiVuAu9gCwwdZH7G3Oo9PXgrvF4eKX0aQ/M
         iiHutOyq0gNUdL1BccvDWXpJxakfIsR0o7nJUcfW3mtk/52vIPY/O81klA15ADkEnJAE
         ApfGI3biiHFMGKniMtUQaSWR9aQarwBzB6zWn3Wr9GDbTFLdI0JQOx7EdsLl5INzZa5G
         dr1PXzPQ9cxOHZfkT689YxEZ/OeEioQTMo/pOq/qTBynrIHaIbz83EukV+azLIHww3kI
         RsKUzYTIgg405Yn1+UMvLyxuinmblbYKnHzVpAd38Nxx3f27XZPHA1r0c4s2mIpMF0gj
         lzbg==
X-Forwarded-Encrypted: i=1; AJvYcCX90oAz17/NTbLruWJZVxhVuOqQEsGQUJ/FahZk4u0eS1HTCVSbVya4m5Vy1H2nKBE0How=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKlvlyR/aRJtJr6yet8jaQIEVwtKLIlL+7syFkaodAMma8lpAN
	WKrN4C6Y2cvEPF3k1dnOsoKpjKBVZQw0jwyCmtHfqGl2mikQ8pqdFGy3n2HHueH7Th1LrZchPui
	VCzKUHA==
X-Google-Smtp-Source: AGHT+IECAB7Q2xyCVxo4b5IYRWMRhmsnO9Lb3GIfoRWMBXN6TTKJmV4zclbiOdup5YJYV9LbxCAcEbMCp+c=
X-Received: from pjzg1.prod.google.com ([2002:a17:90a:e581:b0:33b:51fe:1a78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2d0:b0:254:70cb:5b36
 with SMTP id d9443c01a7336-290c9cf37b2mr17571675ad.8.1760661186063; Thu, 16
 Oct 2025 17:33:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:28 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-11-seanjc@google.com>
Subject: [PATCH v3 10/25] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the return code from kvm_x86_ops.remove_external_spte(), a.k.a.
tdx_sept_remove_private_spte(), as KVM simply does a KVM_BUG_ON() failure,
and that KVM_BUG_ON() is redundant since all error paths in TDX also do a
KVM_BUG_ON().

Opportunistically pass the spte instead of the pfn, as the API is clearly
about removing an spte.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++------
 arch/x86/kvm/vmx/tdx.c          | 17 ++++++++---------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..7e92aebd07e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1855,8 +1855,8 @@ struct kvm_x86_ops {
 				 void *external_spt);
 
 	/* Update external page table from spte getting removed, and flush TLB. */
-	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				    kvm_pfn_t pfn_for_gfn);
+	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				     u64 spte);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9b4006c2120e..c09c25f3f93b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -362,9 +362,6 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				 int level)
 {
-	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
-	int ret;
-
 	/*
 	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
 	 * PTs are removed in a special order, involving free_external_spt().
@@ -377,9 +374,8 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 
 	/* Zapping leaf spte is allowed only when write lock is held. */
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	/* Because write lock is held, operation should success. */
-	ret = kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_pfn);
-	KVM_BUG_ON(ret, kvm);
+
+	kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
 }
 
 /**
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index abea9b3d08cf..f5cbcbf4e663 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1806,12 +1806,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt));
 }
 
-static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					enum pg_level level, kvm_pfn_t pfn)
+static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					 enum pg_level level, u64 spte)
 {
+	struct page *page = pfn_to_page(spte_to_pfn(spte));
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct page *page = pfn_to_page(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	int ret;
@@ -1822,15 +1822,15 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * there can't be anything populated in the private EPT.
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EIO;
+		return;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
+		return;
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
-		return ret;
+		return;
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
@@ -1859,17 +1859,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
-		return -EIO;
+		return;
 	}
 
 	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
-		return -EIO;
+		return;
 	}
 
 	tdx_quirk_reset_page(page);
-	return 0;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.0.858.gf9c4a03a3a-goog


