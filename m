Return-Path: <kvm+bounces-32033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 148669D1B50
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 23:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7D071F22006
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 22:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DF71EE02C;
	Mon, 18 Nov 2024 22:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mz47KisO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4463E1EC003
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970482; cv=none; b=C/8OSAKjiKX1SaRhIC7F7+sWXZtVzTuMI0RqSNwvTyRmaBGaS7Hi+rm0mX+Oa7TmqD+ttPZVV36S3i8zmNo8CYQGIQLwMhLKySeYP17EJvXMJ+QmGbRqjGoQjZqa7PY9X//iWtdwuGmxGebb91dt0Juush1lN4EGPjWYxjBCKOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970482; c=relaxed/simple;
	bh=LrIhoRDkl1g5eGLdsoZdxBUgHPnoAOkFcR6YkyMdOy0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J3yTrGTdP8iIxRibG4zqe5KnHjYq5zuwFc6jEegd8U3eHMtYBfYqabBcDzyaE761+MSjYWNs0Op6dCNxD7JMRBxeAIqD48AeBuvumHJTVG5kWhcAEw+8aFY1JV0qgxaeb+fp0QqOMeng6NRkxpyGXNjiXGvwy5W1NkgTxYB8EAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mz47KisO; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731970481; x=1763506481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LrIhoRDkl1g5eGLdsoZdxBUgHPnoAOkFcR6YkyMdOy0=;
  b=mz47KisOkC85cQzQ003BvoxivaWCgCWK8tLsoxk3QvS3RIuLBchWmHi3
   /qajZSnqeFGwzv6GxKYnNixaU77IHkblQROHkV+8TadGZ3wH+Va6YAA9R
   5tBA+VFW5ht4wblnq0n9Rw8rjhuOHo31eLKBmG1wGyi/I413rTDvA0jHW
   LZ+ladkE6gJuIIQtk57Nwa11dHEckCNL074Cks0jERx9a2GQr1FR6iAM8
   mxhNZ6XkfZOT1SuC7HDsKctbSDTPffDXDaJ9Hbn2zEh9Hlw2ybRw1ebMf
   01UYkI2SC+k4/9Y/wS1omx4oHnmBfgxZWi6EJ5km7IE9UPbc81dDkMjTJ
   g==;
X-CSE-ConnectionGUID: rLPDwIulSsWGmej1dcXATw==
X-CSE-MsgGUID: 0d7711y1S66m/8LtTPpCog==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="42579575"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="42579575"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:40 -0800
X-CSE-ConnectionGUID: e4+zddq+QYWgNmgujs9mSQ==
X-CSE-MsgGUID: I/vAUhtnThGO97dYI4ITlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="89145924"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 14:54:40 -0800
From: Zide Chen <zide.chen@intel.com>
To: kvm@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-test PATCH 2/3] x86/pmu: Fixed PEBS basic record parsing issue
Date: Mon, 18 Nov 2024 14:52:06 -0800
Message-Id: <20241118225207.16596-2-zide.chen@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241118225207.16596-1-zide.chen@intel.com>
References: <20241118225207.16596-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If adaptive PEBS is supported, to parse the PEBS record_format[47:0],
SDM states that "This field indicates which data groups are included
in the record. The field is zero if none of the counters that triggered
the current PEBS record have their Adaptive_Record bit set. Otherwise
it contains the value of MSR_PEBS_DATA_CFG."

Without this fix, if neither IA32_PERFEVTSELx.Adaptive_Record[34] nor
IA32_FIXED_CTR_CTRL.FCx_Adaptive_Record is set on adaptive PEBS capable
systems, test will fail.

Fixes: 2cb2af7f53d ("x86/pmu: Test adaptive PEBS without any adaptive counters")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu_pebs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 77875c4fee35..6b4a5ed3b91e 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -297,6 +297,8 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
 		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
+		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
+				 (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
 		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
-- 
2.34.1


