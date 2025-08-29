Return-Path: <kvm+bounces-56219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759DBB3AEEC
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 591063B55C8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F37244686;
	Fri, 29 Aug 2025 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJJcdevi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB77239E80
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426007; cv=none; b=micqNnR2rP7cMHM15l2d4EXpGbijXwzq+defxLXCNkGtXqtYkX4oTuyAOSbGomMqmDBk2lihQJCg1tBBwMw3xjQATrOf+ghE8KhUEINkqa56fWej4ScsIVK1ZlpMUctN0Vb/zXy8HFWhyXR2DkLUK9W85aBHmLRzKJApOjZkzX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426007; c=relaxed/simple;
	bh=Jokid0DO/rV7NnsZCR0z+fHP5XwwBXdL/NPXkdhHIK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TimQB0WMwlINzMLLf57nuI4cQ4fsiKILk3uchY7BFJ27kyPKfWBUTaqAQo9EYiGNNs42aUbgsVDL+eKifZO6h6DJTVWzIkxpw0Y8TB2QKJ6umz7V7k8GQdV+iaOflD4TJNrsVCwf05rkweO9OtWlNHSM1u4NbK08S3nAQpeBk4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJJcdevi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e395107e2so1486998b3a.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426005; x=1757030805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U7cQHpMeOyPtobGJP9EpNG+eqgAlak3ByWO0DfJC83o=;
        b=tJJcdevizseaGw4GX+6mb2XBsSb/79QNcKkntmuMIZRTuv29Zm8cflhsaG6jjzafhC
         8MtXhq5eSmGbY33bKTqsV5Fv0aqHkl1d2DS3C2+lbfKd+GBLsggt87aVa+XrKW1UmJYK
         e/Ij/fdaxQ12lC+pLcyBosYI8EP7CySAohBykfUDk95k/IMJvwz+CE9P3d6CU2nypxSJ
         QbBkUupx7BSRbdYIt0xRfL5xlw+yyiju+D8KK0yr2RidiqEXHG0dY8xImMsjFVzeLmTr
         yD3jS5y2UTTtsQsttPxguly7lWPOLGXaRePV989bjfQWnDLbXg4OOQ01YanbicuSM2IK
         lMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426005; x=1757030805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U7cQHpMeOyPtobGJP9EpNG+eqgAlak3ByWO0DfJC83o=;
        b=Z4kq1OLd10JxA1hFzaUTWcSd5F9mi3js3DKasY5Z5hXtKzgrxFwwMe1RNbBtfU+3Xo
         AD+KXpumAXUwAOt2qjSW4OLgtpi5bCIIb/JBOf57q0XKPdRcsnFgKDu6XR4NchtogtL+
         0htrQcOu4Du06wefYuMtGJUPC3aoESiWLRfgeHQNSSVEz9kwUZB5CbfWPiPpqkXK6jhw
         0VnJWtSPAlQOjIys3Xra0djAQhWsQSApHfGq2y67Bpy808TsdgCJ468AzDc7mmZlU6zL
         ESDRE1w8UBDPTA0NlA37Kh1s1IzUYIp7ZSUjJLOR4LRoLjeoqEAKMV9UG/GHq19Lk4Ki
         FJrw==
X-Gm-Message-State: AOJu0YxijprrGt9kZ2KR1D4OBwOeDy5qmcbdduBD8HdspvGLdo60NUsp
	JHR+OqkJ1xFK6e5CS2tcwOZxL5CTD1Fw/PCn21caHwXw1hebzw3/3tl74WoZ6DHgryPsjjHogt7
	cyi8YjA==
X-Google-Smtp-Source: AGHT+IFUjUY1nfQcAvMaxHbMyGGpEn+Y2J7C9qldGHayAPHPs3JLhhD2fMtARg3auKDuKGakE4vLVFSBP0g=
X-Received: from pfbjo20.prod.google.com ([2002:a05:6a00:9094:b0:771:e6da:3861])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7347:b0:243:b190:d139
 with SMTP id adf61e73a8af0-243b190d746mr5814517637.39.1756426005459; Thu, 28
 Aug 2025 17:06:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:14 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-15-seanjc@google.com>
Subject: [RFC PATCH v2 14/18] KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Do TDH_MEM_RANGE_BLOCK directly in tdx_sept_remove_private_spte() instead
of using a one-off helper now that the nr_premapped tracking is gone.

Opportunistically drop the WARN on hugepages, which was dead code (see the
KVM_BUG_ON() in tdx_sept_remove_private_spte()).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 00c3dc376690..aa6d88629dae 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1682,33 +1682,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, struct page *page)
-{
-	int tdx_level = pg_level_to_tdx_sept_level(level);
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
-	u64 err, entry, level_state;
-
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
-
-	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-
-	if (unlikely(tdx_operand_busy(err))) {
-		/* After no vCPUs enter, the second retry is expected to succeed */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
-		return -EIO;
-	}
-	return 1;
-}
-
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
  * tdh_mem_track() is the only caller that increases TD epoch. An increase in
@@ -1789,7 +1762,6 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
-	int ret;
 
 	/*
 	 * HKID is released after all private pages have been removed, and set
@@ -1803,9 +1775,18 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return;
 
-	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
-	if (ret <= 0)
+	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err))) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return;
+	}
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
-- 
2.51.0.318.gd7df087d1a-goog


