Return-Path: <kvm+bounces-6702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50497837B9B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E45B11F28D30
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D6614FD10;
	Tue, 23 Jan 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bqtzD1ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5DF14E2DE;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969363; cv=none; b=lg83S+OYP03sAGti2HbK5V+dyZG9WQ3Mon68JHzg5mv1MzSQqExxqhthZNfZLHSv4pM0veXkzI5IwuMy2d03QcoU8bgHmyrovhz0cGgglzNZVfizvLiJ521NeGesLZnR6qNqwArGraGfkit6znerMQLCOoZm/F9XbOZPdiwv4SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969363; c=relaxed/simple;
	bh=D8ucLB5R3WU1RLu3fuizNfiGPSEyK3aQUihpWV4tz0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YD//OtF/rQm7nicCaLUXMvTORLFVj5YRCVQUkCD2/IebJN2+6fmS0QNfJv83AP51GHS2ZLhaDk9aj7eEkCEk9KY5tyA1nAMOQy4dW50hipC8cWU0GObYbaObvqIhcZserLWcNcUfay8ShqPZVfpHOHPEwx9lSs/dXRcAk0y25L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bqtzD1ZM; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969361; x=1737505361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D8ucLB5R3WU1RLu3fuizNfiGPSEyK3aQUihpWV4tz0k=;
  b=bqtzD1ZMQfzQtLpeY+iU+kCQW6TjpFXWeaN87YfHYtxGVpJTYxaJ+fVH
   LMAW6T7bLe8oXmoeyRLu3n5TuOUrWSBaln/23Fo6hnkMJciShaJgMGRP5
   M9TGXKI/di4Rc3te1+7Nw3d2FN3f5A8hCozVwwKh1M/A1KIIM0o00jiSX
   dtY/fWWImyL+4Lpbj8S1DaFKzSt8mnc8iCGB+yfLGUFRGk7zotXHTxVRi
   X9i2gla7xvKw/cBy+vY5dqltM3KmFeUAL58VPAjp0tCb4qN7tJ8nyDqy+
   k/fHC5Oo0dkHzGCbFmm5ztXTdJGhTPR318zH/u1sCI5polY5DHKtwIA7g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125675"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125675"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825650"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:39 -0800
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
Subject: [PATCH v7 07/13] KVM: x86/tdp_mmu: Allocate private page table for large page split
Date: Mon, 22 Jan 2024 16:22:22 -0800
Message-Id: <2e0999bc6c5d1ebdf07d195f5e99e6c8b2141378.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e9eafc2f7885..9888ea0046ea 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -203,6 +203,15 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
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
@@ -231,6 +240,11 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 {
 }
 
+static inline int kvm_alloc_private_spt_for_split(struct kvm_mmu_page *sp, gfp_t gfp)
+{
+	return -ENOMEM;
+}
+
 static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
 {
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 25c201686d1f..7991934b3f37 100644
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


