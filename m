Return-Path: <kvm+bounces-56669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5F5B4157B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 121D27A50BA
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28E72DEA8F;
	Wed,  3 Sep 2025 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bSorm1IE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4F2D94A4;
	Wed,  3 Sep 2025 06:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882067; cv=none; b=Uw69jKzU+xaXGsIywRVgd/wfm7SLSrcGYv6Oyo9BZH6QVoJThz3CSiNgQTNFDb7m2+8IAgHDCJWw/sjD+TK/UTGLMNkyCYlZhJHaVpcINtufPMZTcpSryeCI85Ec932xrxFYuBxTDV/A+rDChb5IRrBlRdaD46UIPgnmAz+U/yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882067; c=relaxed/simple;
	bh=IM6ZpntWH9mILQir1heZmjp9QGGWbJ+kZ3cIa25NE84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ML83JkMZYb9kNjBBWME/ShUpVSDv3YFUj4gTDWszlhwjibV2aDOBBlrhgzuKYH44aFASD5vWRcy6zl8dSdaZpW32rCiZxBre6BdHtcL642/T+rOll72dc9PBTW+VOS4wSZoJ/vRPZtE7Kpb/+6vKs1aEU5UAGeBLNOXqh3LlYH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bSorm1IE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882065; x=1788418065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IM6ZpntWH9mILQir1heZmjp9QGGWbJ+kZ3cIa25NE84=;
  b=bSorm1IEdP9XadG1ORgHJLUgtMzej2DRrW2bUfjbsv63IiYw4zzdJz0z
   Hqpux9zvj5Zo+2JNFCNV85+xf0/g82t2QyKxhKJLUAmHM+wv7yt8pFGz+
   lGfi3fMdcV87mXU6jsm0OeBNUBT1xiWYv0LHaQUqtcYvlLeIGg6dK/yvz
   GY1ou6/lm8BtMJba2KvtvQQrqpotEPefXa2gSLnew+ROizXBJWt7yrPBU
   fPe4Yw8/foORN7KODgP6XpQ8JR+DfhanR/pMhQ5OSYql2AJGIUc96fgop
   Cu+OXN+jQcZPL7XgS6QK0i/VcknfQDN0Z/0wzN93503NMVhcWZ+bxLu8k
   Q==;
X-CSE-ConnectionGUID: dlKMFmNcQ2yMeeYZ1wyVWg==
X-CSE-MsgGUID: SWN+kreiQuysKP3VQ3wBCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003813"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003813"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:45 -0700
X-CSE-ConnectionGUID: 2k8TZlO2SLepA7aqjhDHlw==
X-CSE-MsgGUID: zX8sWfvSTf2zDyq2q9Q/hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656620"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:42 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 7/8] x86: pmu_pebs: Remove abundant data_cfg_match calculation
Date: Wed,  3 Sep 2025 14:46:00 +0800
Message-Id: <20250903064601.32131-8-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove abundant data_cfg_match calculation.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu_pebs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 6e73fc34..2848cc1e 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -296,7 +296,6 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
-		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
 		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
 				 (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
-- 
2.34.1


