Return-Path: <kvm+bounces-60251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E117BBE5EF4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DECC1A67A68
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55EEA281532;
	Fri, 17 Oct 2025 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GE9el0w/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1525F994
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661187; cv=none; b=IurA8FhVtR21+POEmLfazsXV2ihiNZ9yqxHK/EIg9cZkpswl0FWWQy2JBlRBsELXUJIgvE9ZwqxxaCuIeICFX67V+y0adEor0Wtha8NGNNTPSoG1dgQwwdjRuYhWCLBcQcvPtCCealYlMlF0h3vwRJPEG8Pgrnl/Ryj668HikaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661187; c=relaxed/simple;
	bh=QkFUtx5sPoQ6tUw0mbfzfEAj27904ErfeoisebxrDLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QyPbNFxm/bTnZ8dwknCbGcmVVZy8j3yAUa4kUFShwCTzcT8kS2TX6yJAEyyTpJ2ZMOasKwC3pPDVUy1H/GCxE2lLHlUE6jJCHfOkArMUA+j2WnQrF02U+hoIZ6WwBRfPEyukciv6ioQ8uUgD3TzqfYSpvAiSBP0ArNP5w/N84qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GE9el0w/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so2168163a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661184; x=1761265984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RrkTXpYpJ7TF3q/IfNrztO0QiwCsWOWOHOU78mYwx64=;
        b=GE9el0w/M8keJ7fupiyx6IGO4pOo3MRgbl30ySwpxqi7q/OfMPPqJTOEdy4E8mzLiZ
         /Cx0c4lcuQwWG/1VEMC0ExMS0/FE2/4MU5bs6TV7/qh5wF80T9LKAnXJepxbYItAuTIz
         lBz149inpJNX+qIu7IHGn59o9xSy7KcTKyDR6CLBMtBdgedClP/oBo9XL9SadzXhfR/L
         q1P6/cUhxgkjMsZcPLI2xytkHLqsMPIFjor02isao8Jjyyatz/DTJImQo65vC4jRRjxF
         tVxCFTPXUPNEei2U2mBUl/eLtuIk7uiEjPUefZ8g1FNKQ5nvSGTxWMbo6v+Jyzc4z57t
         pibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661184; x=1761265984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrkTXpYpJ7TF3q/IfNrztO0QiwCsWOWOHOU78mYwx64=;
        b=H5Bha2CS8Jonjigwb+VkUs2J4Ezb4i6DFSh/uEBWmcMYV6Yp99TQiePF2b7IhPSiVe
         yO69MCZyPLL15Sd2Rzb9FNm7bWSMdptgrHKK+w5psK/ir16/eZcY9mvCAbPwZnilNqGz
         +nPjdamXQkya4HE7J5WYfCWgwPh7nLbcrFA3df/rapCP15hBhk7ouki2mog2biJ8jFhh
         8vmZZBL+cNImtXY8q7DYPuJIhk2w3iVQV6zRw49xyLRrV93AzBd5C6EwOxtHPKYlFn6+
         a+rSM406P9mrvqAXfovN3SrATFlsQbthHS762Zy4Pb01TK6z+h01DTZKad+GsBQ2CSqZ
         pcRg==
X-Forwarded-Encrypted: i=1; AJvYcCWBVCi4f7TiVHJ2mbNCdB5TDzJh/ftR7dMW2ZNeQ8e8MgsdcemPmkBq1TXlqDRjgpmKpy0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeB64EHXG5LvNk3ghQlEeFFH19Vd0J0YMnW+HxALfPXQYj6ZDn
	jYKS8AdX3hZ/B6vI0Y3QfQCpYDvKj8LVZ2Zn/BbRXIGatVv/jNLxSXshqgKyWkzqBaqArr7EIXD
	pdzqYlw==
X-Google-Smtp-Source: AGHT+IEszDWyEl04dE1jeZ+WdRgxVfIHlmHOlr4lEQiQaFSefc7rtggxfv5d/ZUmkL9dWZiaizwe6/ECFgw=
X-Received: from pjtf14.prod.google.com ([2002:a17:90a:c28e:b0:32b:ae4c:196c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cb:b0:339:9f7d:92d4
 with SMTP id 98e67ed59e1d1-33bcf87b8a5mr2036638a91.9.1760661184417; Thu, 16
 Oct 2025 17:33:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:27 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-10-seanjc@google.com>
Subject: [PATCH v3 09/25] KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
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

Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() to
avoid having to differnatiate between "zap", "drop", and "remove", and to
eliminate dead code due to redundant checks, e.g. on an HKID being
assigned.

No functional change intended.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 90 +++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c242d73b6a7b..abea9b3d08cf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1648,55 +1648,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
 
-static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
-				      enum pg_level level, struct page *page)
-{
-	int tdx_level = pg_level_to_tdx_sept_level(level);
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	gpa_t gpa = gfn_to_gpa(gfn);
-	u64 err, entry, level_state;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
-
-	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
-		return -EIO;
-
-	/*
-	 * When zapping private page, write lock is held. So no race condition
-	 * with other vcpu sept operation.
-	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
-	 */
-	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-				  &level_state);
-
-	if (unlikely(tdx_operand_busy(err))) {
-		/*
-		 * The second retry is expected to succeed after kicking off all
-		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
-		 */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-					  &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
-		return -EIO;
-	}
-
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
-		return -EIO;
-	}
-	tdx_quirk_reset_page(page);
-	return 0;
-}
-
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
@@ -1858,7 +1809,11 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
 	int ret;
 
 	/*
@@ -1869,6 +1824,10 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EIO;
 
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EIO;
+
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
 		return ret;
@@ -1879,7 +1838,38 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	tdx_track(kvm);
 
-	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
+	/*
+	 * When zapping private page, write lock is held. So no race condition
+	 * with other vcpu sept operation.
+	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
+	 */
+	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+				  &level_state);
+
+	if (unlikely(tdx_operand_busy(err))) {
+		/*
+		 * The second retry is expected to succeed after kicking off all
+		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
+		 */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+					  &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+		return -EIO;
+	}
+
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return -EIO;
+	}
+
+	tdx_quirk_reset_page(page);
+	return 0;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.0.858.gf9c4a03a3a-goog


