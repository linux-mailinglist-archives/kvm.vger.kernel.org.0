Return-Path: <kvm+bounces-63496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 73229C67C06
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9FA274F134D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98572EC0A3;
	Tue, 18 Nov 2025 06:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gA8/sdQi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656192EA754
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447772; cv=none; b=pr4iRsJBnyrDJw+l1/oQkxb1K6BiNDMmySOITaFOgLMgUc/yvCEkawZypaBw+eEt78vanorJl6zQvGWqnLFOtN0SgI6OB7zoXs6uAm2PHg/DQuGlFkLAYObOshVhsenGlAhc1hQFodB8fbIifE2IvYncYUnd9TnoZy29vhbd/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447772; c=relaxed/simple;
	bh=1XhH2LXoPRYyYcYy5qWLa8QGY0M70kIQwv5hJ1y6GGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o01QYIPFl3NHF41sGyqsQtH6otLvF0PGhMBx+2aLyak4zDnATBvZXKICelAu5/xi0OQ1RzeHdg0gruf43MhCYgfT/RQgD8M0xe7O65VLIpMWVghEFA9xVStqOWIsVC4RcKtAMDNGqfN/6U79tKPFvJnM+jv8G19aYoq5myVwIfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gA8/sdQi; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447772; x=1794983772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XhH2LXoPRYyYcYy5qWLa8QGY0M70kIQwv5hJ1y6GGo=;
  b=gA8/sdQirksWbjaKZEOHSb/kkzu1yE1dMYSod2oCgF9oj2mvIAmkY1P4
   MxOzJvn2708u2EAnGpfmDEo3xs7qn2Nl7W2aId3vdoX72LsjA5PFHNrVk
   MI5KJQu3orrrf674DDLTDbL8rkDtOr+z6RNfen7WWfCJHaTwnZC/G71bm
   0lL9pVRL3SvDtPNDGpx7Im4z0/6x43REIFF/x3OqlAECmW9c3M8o7IJjm
   bv9KsOBDVh257TQjTby/vrjC3Eyu+ayEg1iYa67YsSeRUByrMH9dr/8cS
   7A5fJzxTIAiEQfeQd55iSE40KWBnA0yiUi8uws9Q3XyvnnC0HJ1phJaYx
   w==;
X-CSE-ConnectionGUID: 1xJ5G639TZqRzaOkZriX7g==
X-CSE-MsgGUID: y+W4XyTZSG27QGnYewsPaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82850983"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82850983"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:36:12 -0800
X-CSE-ConnectionGUID: zlKmW00rTzO4QaXpCn7qfg==
X-CSE-MsgGUID: vMYZRm97RHeO1BIHzRv60Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189962704"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 17 Nov 2025 22:36:10 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 5/5] i386/cpu: Mark apx xstate as migratable
Date: Tue, 18 Nov 2025 14:58:17 +0800
Message-Id: <20251118065817.835017-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118065817.835017-1-zhao1.liu@intel.com>
References: <20251118065817.835017-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apx xstate is user xstate. The related registers are cached in
X86CPUState. And there's a vmsd "vmstate_apx" to migrate these
registers.

Thus, it's safe to mark it as migratable.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9cc553a86442..f703b1478d71 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1544,7 +1544,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
-            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK,
+            XSTATE_PKRU_MASK | XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK |
+            XSTATE_APX_MASK,
     },
     [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
-- 
2.34.1


