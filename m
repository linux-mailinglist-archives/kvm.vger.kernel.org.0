Return-Path: <kvm+bounces-9763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C603866DD9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB36FB264AC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05C9134CDA;
	Mon, 26 Feb 2024 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OzFZCYjp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5966A1DDF2;
	Mon, 26 Feb 2024 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936192; cv=none; b=osA+uYsGnX6yOZ5hOhGr03LlXbmnIEEtHbbtI5Kn3nWT+hrmAsNxXZJlH89uKIxbakhl4UEAR9eFOCjiv0nIpRHSGsZMYekQvw30ETavHfpd+0v4GrNlGXxWngAt7a5lVhDtbs9YB193CnYyCCP+mMl/Z479SYQRYnY4xxhYtYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936192; c=relaxed/simple;
	bh=AX82JcILUa46R1G0PfPXFjiVx0GFJf+AzOhgtIqj4R8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TLzuW94I5f+r7CjxiG6WdcFw+Ttz0ipUzMzpi2FAYmysFE39ePR3yeAt+KGcAcEgJIDnhqH4L3fcNr2JRhtUYoMMzcjWikEa1DX4JOEPN3KO1vu8tM6THUq5VCNjIW3zGhGG26XVU5aneDGGG8B+l6fF4l66DnwstBQ8Wq3BaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OzFZCYjp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936190; x=1740472190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AX82JcILUa46R1G0PfPXFjiVx0GFJf+AzOhgtIqj4R8=;
  b=OzFZCYjp7MydseztlfNJWt+31fupV8S4VOh5t2Q+7eMogLtfz+kXIe1l
   XfwYugpG17bSyno6Ot0yG36xlaSWxv3OKShEJ1l4j8c0hf5Yef3a5FmbC
   nY2IGmNcgHho8b7Wu2CgJGwrq38S6e1Rg2RxkM3voT1PXzYX2/b/ptQJn
   Q7LbW8hA6pdL3xJL1bFeAYc7pXdU1/LJg0SS5PzVHmrSZDnQoDta51W1i
   /vKTdRdnn2ltowBpbuwVVwfP+prVIUjWviKGiaCChPkQLczEg35gsfLaL
   5CFdQfMlv/DbOoXdhqgUfEyVf7QSSB0ZkliqdM3M4x/tetn6FS0inCuqE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623311"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623311"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519410"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v8 08/14] KVM: x86/tdp_mmu: Allocate private page table for large page split
Date: Mon, 26 Feb 2024 00:29:22 -0800
Message-Id: <657c4a403e63f2c7e1742b4cdb09ca94c6d5d9b8.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make tdp_mmu_alloc_sp_split() aware of private page table.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 9 +++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 ++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9e2c7c6d85bf..9aa4c6ffa207 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -201,6 +201,15 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 	}
 }
 
+static inline int kvm_alloc_private_spt_for_split(struct kvm_mmu_page *sp, gfp_t gfp)
+{
+	gfp &= ~__GFP_ZERO;
+	sp->private_spt = (void *)__get_free_page(gfp);
+	if (!sp->private_spt)
+		return -ENOMEM;
+	return 0;
+}
+
 static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
 {
 	if (sp->private_spt)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1a0e4baa8311..66de875d3de1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1593,8 +1593,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
 
 	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
-	/* TODO: large page support for private GPA. */
-	WARN_ON_ONCE(kvm_mmu_page_role_is_private(role));
+	if (kvm_mmu_page_role_is_private(role)) {
+		if (kvm_alloc_private_spt_for_split(sp, gfp)) {
+			free_page((unsigned long)sp->spt);
+			sp->spt = NULL;
+		}
+	}
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
-- 
2.25.1


