Return-Path: <kvm+bounces-63314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0741EC621C4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A0B94E64A2
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5534125DD1E;
	Mon, 17 Nov 2025 02:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+wA+68z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B926F29C;
	Mon, 17 Nov 2025 02:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347127; cv=none; b=GktcVEMbykDd6BXLuk2epvk01Vm0RCAsbwXvYN/8gsBE+1gAUwhwOIIoby0uIghIQpb+2hpSIz7R/W3NmgSgSUUnsQIP1+wOFlwFrsfK8yDuOQkvgkuEJ3m31p8k1c4M9gMDQxwjvGyjzaSokNy+slFdTl8Y6uGNB7MEoXEYUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347127; c=relaxed/simple;
	bh=Qzu5/4T6S1os8tzPghPrA00nkhB5gZ8VRPDx/+4Efhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rzX6pW/NRw7LpkS9H8Z4O/BpTdSWKFKNRA1jyvKn8VXcl9cRu8RQNv4+XH+8pzJHu/2DF0QBMAoMmzczPk/lBwM/AtHwjmovBlvYrQk/vdPtpAau8rfHMDGc2W77W6+NxM1D+rQl2xQpjqkAI/LOZGvHm6imfI3AfFoDTn0+CRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+wA+68z; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347127; x=1794883127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qzu5/4T6S1os8tzPghPrA00nkhB5gZ8VRPDx/+4Efhs=;
  b=Z+wA+68z99pHpHRlSy++/b0O9N4ucpXCnE6udmzV0ysDZLlDas3o2Dko
   EaeI4SUEksn+klTU8w/DjRX2j1rEhjsBNLsAzeYT0hHbs2UEYbM2Zp9b6
   f+TDtTHHhAUO7mkB0GXNkkjbkTFpxgiP1d/AGoqPlKxGtHB5wcRssZc0V
   1ddoMonBt/mDpB5jkUeJTMtNRHFGzYmJ0vZSowsZpp92dUBuAZU3MxL0u
   BWR+OaidV1KPanh72mtGHRWD+d5byNrau2d7x0+7Fc0KEDT+uP3HLdyEk
   laUZKkKZN1BcPuQZXX7NjwzLQiDInqzL6xxXNBshAiyZIoo+gRHDQsFq/
   A==;
X-CSE-ConnectionGUID: HwdnX4i1QSac5aF5OiJ5Hw==
X-CSE-MsgGUID: eN7EjitbQaSJHahc7YpmMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729556"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729556"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:46 -0800
X-CSE-ConnectionGUID: XrZFkQvCQbu0117IxfTZtA==
X-CSE-MsgGUID: 0vxXJKTrSx+69IqHN9g3+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658318"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:42 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 14/26] mm: Add __free() support for folio_put()
Date: Mon, 17 Nov 2025 10:22:58 +0800
Message-Id: <20251117022311.2443900-15-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for the declaration of struct folio * variables that trigger
folio_put() when they go out of scope.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 include/linux/mm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..2456bb775e27 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1425,6 +1425,8 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+DEFINE_FREE(folio_put, struct folio *, if (_T) folio_put(_T))
+
 /**
  * folio_put_refs - Reduce the reference count on a folio.
  * @folio: The folio.
-- 
2.25.1


