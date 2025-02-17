Return-Path: <kvm+bounces-38337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B28BFA37CF5
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:19:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 851851885AF5
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA651A2C29;
	Mon, 17 Feb 2025 08:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="adTQuEKy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255181A2645
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780349; cv=none; b=Q9dXbWkP15HxrmDEUuV/wn05ykOZF4Hq1ihU+IHW2HfoBB60ryyheTDnHkwXgDU4DmTE2QLtL+Dc0f9qmxNlKVIX5qJm/lQMZQW7ugPhe9/VJrp35CYMoK/6DZDyxZn5ItwBQJ+QHOC/3+FP0sn6SPEDCjXG6p0CI01CtVYCTFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780349; c=relaxed/simple;
	bh=E5Ngw7fVDUDC+t1CAmd5+sTvqe9bA5/nLMHz0pQXMco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/QpQUSwWuH6wd5xu5fGIjjWUx0LG5Q+M3sJfZK2Sr2Ah5NbKc9xvzPAIR4kkcHzqsC1mqhw3Afu8lS1bl8MIjWyEtVdbevQ0ixHBlRGvYcAMd/gxviP8qwLv2ktxWmwQxkIyMlb1/I9AUkf/et/6law1KwSwAxBYGg+SDnltVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=adTQuEKy; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780348; x=1771316348;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E5Ngw7fVDUDC+t1CAmd5+sTvqe9bA5/nLMHz0pQXMco=;
  b=adTQuEKyBJuT/t6wTGBQVhaiOwtiq+YxZyZ66xF9CNzwN5XUrtXFHdlT
   G8F9FQ6ib7/b56T2vj/CKGrfBcUraYlrleTPXumWV0P5sohZpXLLXqh8h
   hu3rD6KdJIvwRXgmFg9nts22UsVgje9HLbtIdarMKSYbouAGHWJn3WGFD
   qTjr8I3cbvbnf5C85Qe8awVIcz+H4RAwi8Y71Ok+g3FTqlIPZbMnbYx8w
   VCnAzgNtzKLGFoybyQRI8CavJpFf0MKaBesGSgbap6TVKuWflymFMuD2t
   zxGzWdn+KAmAIUX95B0K8URS2hhbdLyOqVqwiweeUMeGvPrFCUmqkVsNW
   Q==;
X-CSE-ConnectionGUID: JoRCjkBQSCOIes8U6J7ijg==
X-CSE-MsgGUID: eSSJYZWiSbKljuGk/kAK2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50669012"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50669012"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:19:07 -0800
X-CSE-ConnectionGUID: 3PtVm0eITQy1Op+8wtRspw==
X-CSE-MsgGUID: 20dN3Mz6Qqm1GqR+j0/lpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690267"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:19:05 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v2 6/6] RAMBlock: Make guest_memfd require coordinate discard
Date: Mon, 17 Feb 2025 16:18:25 +0800
Message-ID: <20250217081833.21568-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217081833.21568-1-chenyi.qiang@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As guest_memfd is now managed by memory_attribute_manager with
RamDiscardManager, only block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v2:
    - Change the ram_block_discard_require(false) to
      ram_block_coordinated_discard_require(false).
---
 system/physmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 0ed394c5d2..a30cdd43ee 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         assert(kvm_enabled());
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
@@ -1892,7 +1892,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             error_setg(errp, "Failed to realize memory attribute manager");
             object_unref(OBJECT(new_block->memory_attribute_manager));
             close(new_block->guest_memfd);
-            ram_block_discard_require(false);
+            ram_block_coordinated_discard_require(false);
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
@@ -2152,7 +2152,7 @@ static void reclaim_ramblock(RAMBlock *block)
         memory_attribute_manager_unrealize(block->memory_attribute_manager);
         object_unref(OBJECT(block->memory_attribute_manager));
         close(block->guest_memfd);
-        ram_block_discard_require(false);
+        ram_block_coordinated_discard_require(false);
     }
 
     g_free(block);
-- 
2.43.5


