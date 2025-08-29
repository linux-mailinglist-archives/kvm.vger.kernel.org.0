Return-Path: <kvm+bounces-56213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D49CDB3AED8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77EC617C03F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B139204866;
	Fri, 29 Aug 2025 00:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="trB5XW/a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C981A314B
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425997; cv=none; b=UkYlLVU3WQLF6aZHtC51bG40F+RDDWJDURLzLx8FLvsoKaJSEIcXMlB2UqA+JhdDR+oU2U7wCXqCovJbrYX38HqJvTnBFHkJwPwnigxkCcbDmNicIy4Ulk7KsVHu3xf1NBInCsEVHOTZ5OJSvLVeHBWazq++Wvjxozfvmd1v3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425997; c=relaxed/simple;
	bh=JfzT5/FL1aVHecSHpgPG+2w3eYSbVpsJ5usNCfH68Rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L98IOcZszNYouOakC7i8e+gZms+ali32CfX7Ama9O0i3sznAAAXeN6AjQnFVYyGI6IoVV8tWCahGjBZLGZvwxhgZTVrJHYdxOl6H/DnH6ucJ7rUbbtx2+WKI8XCnwmGPEj6f4KK2uWkNx/pnsGK7H3GqyMuULKBPZ5MefoSbm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=trB5XW/a; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2487543a4f9so30261095ad.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425995; x=1757030795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=azRRbHHODPAI7Q8DbQGHZhxFKo0H66S6km5uv5YyGbc=;
        b=trB5XW/aoEgvXi+VZVcQJ8r9KYecwgqEaYhAOfF96l3arqKDyuS7QA8ADvnvR3XKW/
         +UJ0VGk/GCXJXFxWEpkqLQbLkFb5Z3SiRxQMeA3tMlzlFXyf7U6HcTOWhmcMIxWuZwVQ
         b3hY6I0X8rOcP6vNSYfRU3FH4jgJyDkyiuGmHfCCT1ui934kNkSPAfCtAWHkWtnIxmgQ
         adcsNyEgYWGUTzVrOdDD5HruJbfz+EnLc7fofT1JvtwTmrmD+OvOby9PqqDu/clJiEo6
         tKJIuetsOXVFtJgmcBPlfr+dTvR95YAGaC9IP1Avm/HQ6WOshmnJnbEjAq5anl9idhhz
         murg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425995; x=1757030795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=azRRbHHODPAI7Q8DbQGHZhxFKo0H66S6km5uv5YyGbc=;
        b=aEWt2/Z690KmMyljQJXoZ2MDXDdH/HP2PM49wVV40ecrSgYAHJzGZe9HxQ7dJrgR3Q
         lwWv2bUeOIPcBHaontxEzLQYBQtNrLFxO5gL5J6VMHUm4PlI/r8fNvoWnaDxuvI4TBTi
         9wU7wnz/qyovJ0rbpXyvrCYIAksjwSWHwxM2i1fhqjN3ZUNU8ngCRx2FYwQ6xF3qhv+d
         kmfAtxTm5g3YF+IQG2b3BTxAUywVGz+EKlmIglGieu8qmKuLSZqVU1+ZHbZKHXq7iqYi
         aaK2CN1LQt6//WKZVkqakDwJoRT9V0/rQ05frfeFQJXyPQot2Lxf87T7waWmkdb+9VLJ
         erfw==
X-Gm-Message-State: AOJu0Yxot+T1uMjnbVHBMaFRPhcSw4nHjSdofrHzLHuprF+tAbGN9vhq
	lgLtfbLdz2UnM5AN5UzL7o+oEl2rOXVIQzgU6Qw9e1mxDYe/h4QN4gQijqTWcpwNxtw5O9Vhcwr
	fN2IqlQ==
X-Google-Smtp-Source: AGHT+IFwuejFD8NgObdi1RH1kHcvd/8tHC7uqcH6Kw+5g86hzjv1+yfj38VQpRu3YeTnyRiyW+LZbxmigXQ=
X-Received: from pjj6.prod.google.com ([2002:a17:90b:5546:b0:31f:6ddd:ef5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f543:b0:246:7a11:3775
 with SMTP id d9443c01a7336-2467a113b1amr262897495ad.48.1756425995581; Thu, 28
 Aug 2025 17:06:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:08 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-9-seanjc@google.com>
Subject: [RFC PATCH v2 08/18] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the return code from kvm_x86_ops.remove_external_spte(), a.k.a.
tdx_sept_remove_private_spte(), as KVM simply does a KVM_BUG_ON() failure,
and that KVM_BUG_ON() is redundant since all error paths in TDX also do a
KVM_BUG_ON().

Opportunistically pass the spte instead of the pfn, as the API is clearly
about removing an spte.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++------
 arch/x86/kvm/vmx/tdx.c          | 17 ++++++++---------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d3cc0fc27af..d0a8404a6b8f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1852,8 +1852,8 @@ struct kvm_x86_ops {
 				 void *external_spt);
 
 	/* Update external page table from spte getting removed, and flush TLB. */
-	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				    kvm_pfn_t pfn_for_gfn);
+	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				     u64 spte);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3ea2dd64ce72..78ee085f7cbc 100644
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
index 8cb6a2627eb2..07f9ad1fbfb6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1809,12 +1809,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
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
@@ -1825,15 +1825,15 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
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
@@ -1862,17 +1862,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
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
 
 	tdx_clear_page(page);
-	return 0;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.0.318.gd7df087d1a-goog


