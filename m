Return-Path: <kvm+bounces-42812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD524A7D6B7
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF1977A76C3
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81925227E9B;
	Mon,  7 Apr 2025 07:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mEj+anw7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3F2226170
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012238; cv=none; b=T77vfcGMlV6dsfQL+UCV68ktiX5OHwuhPJUuI3jpYMhlHbo6PPIlCNbnfVyzciUTKtblXfiOrs3TT252KnxlrnjXOnjepwmqlmspMFU4CQSPR6ryKIubfL6WryyP9RA4lnkkDTyx2vS11WZpFNPGo3sthcEKuzNt2k4zRU4tUyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012238; c=relaxed/simple;
	bh=72seqPwiqtTTIfhrsv8Di6UixdAaQLoSv7f9LbSTVdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXCImQYLcE+zSkgpH5wVQWYv4xq2qufz5O1+doBaga5f9uDbwF8KdLviHrKieA1HaY36H3QVbNf08uovS3ad2g/hH6xiR+boqX3izNDtzjwTE23BJ+qSZwWACIPHf4dVc7C0LeDFGrYFnPvlL6e8CPwSEa+8MfD4Ut6AmWdEjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mEj+anw7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012237; x=1775548237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=72seqPwiqtTTIfhrsv8Di6UixdAaQLoSv7f9LbSTVdM=;
  b=mEj+anw78jFm7aVouiq/iipDPYnaqpnqgDawI11g7kPKQ5RiOd8IE1fQ
   BIZomayg5JA2hz3L01H9i9ifSiItS3A/elvKl2+DQQl55Czpjqds0lxuC
   xdrXXk/biI/NkhZ4hA9KYmBr3cAHW4SoliMeS966DiHGedvzUFH6xnRdB
   UQhKMtmeyRDsGC6cbaDstH+rHzBDPT7rg3wBTNgQ964oqv13szGkkAkWJ
   +eS4VPGznz6CCtuejQVAyKdW4FTZLMvIYqJlX0pBJ6Fc8j0UGKp3jQ8rn
   RWUpIVVuJxxpSsbdtjNdzlSot+I8qJvy5WRrxQ2wGMCQXr59QmziVNKCF
   w==;
X-CSE-ConnectionGUID: zJ+UYIC8TKO6Z9N21k5VSg==
X-CSE-MsgGUID: ar1ul16xSnCfHopYDBPA5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857619"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857619"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:37 -0700
X-CSE-ConnectionGUID: uVjmCoGaRRmRYXxjCVAOLw==
X-CSE-MsgGUID: 4g4q8ObRQZijpc802CGgiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405709"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:34 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
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
Subject: [PATCH v4 13/13] RAMBlock: Make guest_memfd require coordinate discard
Date: Mon,  7 Apr 2025 15:49:33 +0800
Message-ID: <20250407074939.18657-14-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As guest_memfd is now managed by ram_block_attribute with
PrivateSharedManager, only block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Modify commit message (RamDiscardManager->PrivateSharedManager).

Changes in v3:
    - No change.

Changes in v2:
    - Change the ram_block_discard_require(false) to
      ram_block_coordinated_discard_require(false).
---
 system/physmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index fb74321e10..5e72d2a544 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1871,7 +1871,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         assert(kvm_enabled());
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
@@ -1895,7 +1895,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
              */
             object_unref(OBJECT(new_block->ram_block_attribute));
             close(new_block->guest_memfd);
-            ram_block_discard_require(false);
+            ram_block_coordinated_discard_require(false);
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
@@ -2155,7 +2155,7 @@ static void reclaim_ramblock(RAMBlock *block)
         ram_block_attribute_unrealize(block->ram_block_attribute);
         object_unref(OBJECT(block->ram_block_attribute));
         close(block->guest_memfd);
-        ram_block_discard_require(false);
+        ram_block_coordinated_discard_require(false);
     }
 
     g_free(block);
-- 
2.43.5


