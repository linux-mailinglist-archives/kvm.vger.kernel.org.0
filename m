Return-Path: <kvm+bounces-56216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0658B3AEDE
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB98F1C83C1B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79342253EF;
	Fri, 29 Aug 2025 00:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qPyb8w9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769B41E3769
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426003; cv=none; b=DQt4lOUytTUq11NepAlBZoMoctFmLHpYv4MbCKMUmfe+nv458Xo9O5m7+RdG388flXkJz2lloVIh5OA8ZVBy/gb9e+N1On1L930lWZnZcw+5Jzc06KKv3Vctbq1k1ej1nz0W8UJ9qWN3BfbZ5jUXxLo4AGC+jdjVmq1MBnZLc4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426003; c=relaxed/simple;
	bh=+ii6r4N6rkBoNCWhPTC+aQwPcbsLf6WTE0C1KJpqLtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PcfjjQlL7UzW0FWqzciFhs/PfVio5s33tzrs9CTBOVlmX425inNNOfUPU1AscZFmT9e8oYn6XLMqmXwU2ReS4kUGVxUlBjmDqP0EHC/qtn+8c36iocm+Gx4T/9E92hyW2mzNmFoWNirCsnoi3rRW7/YDFQVf1Sl2omuZv7gms7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qPyb8w9o; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-327594fd627so1489865a91.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426001; x=1757030801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1YmgvG2RcaVdULnIb8Wec5M7oDs3P0onCjyYEMew5Ns=;
        b=qPyb8w9oWmCXYr15dtSP4y5Ym3U+tKxk9ExRv/uNuve/ywT4vsZkY30nQjUUv37JX0
         i3BJ2fdtVLXy/Lq6vgmKuqwkVzDyWqCozmlgGrB7AgQ+VvY2vLiIYmymBU95Iw7GO54t
         a5XmwxX2qSftIXRJI9XECd4CHaZlbZWZYQplK00ZpWAly+gap8W7+FSO+YfKiWAsdoK3
         uWpOZd8ZQgyi71uilknbSFVeS6K0wc75sb+G9Hg0KdfQstZixQIcyGSOXO49rpfMQJF/
         l+ODr18EQaUDmUMw8BR6KWBUU+33Jpp/szgisUGg13dnfqr/o2bNU14z+jjdF9wowTZh
         j8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426001; x=1757030801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YmgvG2RcaVdULnIb8Wec5M7oDs3P0onCjyYEMew5Ns=;
        b=psLsvPl5lkO9xF1nYVTOXoO6moYpu9xBeSCy/y2kmD8Eb0YsndnvQZFKXd/97ztHrH
         d5442hdd7JADNJueNNiUvvso/IzWkze+nRjBbEzw74XVAa0e2Ti3vIJ63q6YftyMQveV
         f4c3xr1eaf2kVGkRiCQSJno4oBlD8D5YHUUtQn1vFeUCijNh2ucSrbDjc7pGcc6LY/B6
         +WWyYCMxTu4w2JfvmciX9/Ao56uIQnxV0NOiRBef/ydOfplgrJYFiKHAY/EM+svVl7nh
         OFtEN3CcZufYh9UTs+A6iVJG77QkNWt60C0ZsE2b/kg71dnv98gU2VnG3ScsK8gRtC2F
         k2ww==
X-Gm-Message-State: AOJu0Yyv1ccc8u28eLibkpu7FjNkbWE81B3+tVkuA6eSDQjsQikLIHES
	/qTbGctkITuKmENRe+c7hfafcAD2/0v3AIs/Ni7TYOryRTdbEdjuPmgd/ajV51JPGD+UrkBcNaR
	DcVhmSA==
X-Google-Smtp-Source: AGHT+IEf2CEnlJGHZtsmzrHqeOd1ndTjoACnl8CdMuKToTrbMjiAb+CrTNoHK0d+D+dNU6wwE2PLQDR3nAM=
X-Received: from pjbsk5.prod.google.com ([2002:a17:90b:2dc5:b0:325:9cb3:419e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c45:b0:327:b824:2257
 with SMTP id 98e67ed59e1d1-327b8242bbemr4417101a91.32.1756426000789; Thu, 28
 Aug 2025 17:06:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:11 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-12-seanjc@google.com>
Subject: [RFC PATCH v2 11/18] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
providing a one-off helper for effectively three lines of code is at best a
wash, and splitting the code makes the comment for smp_rmb()  _extremely_
confusing as the comment talks about reading kvm->arch.pre_fault_allowed
before kvm_tdx->state, but the immediately visible code does the exact
opposite.

Opportunistically rewrite the comments to more explicitly explain who is
checking what, as well as _why_ the ordering matters.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fe0815d542e3..06dd2861eba7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1608,29 +1608,6 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-/*
- * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
- * callback tdx_gmem_post_populate() then maps pages into private memory.
- * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
- * private EPT structures for the page to have been built before, which is
- * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
- * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
- * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
- * are no half-initialized shared EPT pages.
- */
-static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
-					  enum pg_level level, kvm_pfn_t pfn)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-		return -EIO;
-
-	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
-	atomic64_inc(&kvm_tdx->nr_premapped);
-	return 0;
-}
-
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 
 	/*
-	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
-	 * barrier in tdx_td_finalize().
+	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
+	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
+	 * arbitrary memory until the initial memory image is finalized.  Pairs
+	 * with the smp_wmb() in tdx_td_finalize().
 	 */
 	smp_rmb();
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	/*
+	 * If the TD isn't finalized/runnable, then userspace is initializing
+	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
+	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
+	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pages
+	 * have been added to the image, to prevent running the TD with a
+	 * valid mapping in the mirror EPT, but not in the S-EPT.
+	 */
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
+		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+			return -EIO;
+
+		atomic64_inc(&kvm_tdx->nr_premapped);
+		return 0;
+	}
+
+	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.51.0.318.gd7df087d1a-goog


