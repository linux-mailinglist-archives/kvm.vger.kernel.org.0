Return-Path: <kvm+bounces-45913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D041AAFE60
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CB843AA3AC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE4128033B;
	Thu,  8 May 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hO7XxZuU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C9280304
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716726; cv=none; b=X7XyneroJ/htDPxv/fvEgUntDIZw2WNcmUlEKKqQyoCiEmGAvm6cfrz/27EnXBnMBV62RFDHvsOs9HKRwtXfN/zF1puNY0JrlqMVfTs6SxggXZD6mNJj+UD0fGs46whK4A86RFZU8za6jFr+YI1tPND7Xr7xMyD0kssOSuL2hgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716726; c=relaxed/simple;
	bh=DTR2reLVr32ztLRUsZ/63i5tZqMftT2NNn7Lh3AoxvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a72jU+9FEfjZ07Sw1YiETdfCi3wVg32Ws4BaWyK5NjuuAqLpvPVaIaQik9jPKizSrs2U9xWGEd1UgV5+x3sK9hQ8MI2GqSNKDUihzRBFbJjNykRXrcXgPY5Uio6iiNfInHx7WvS+mh/r4H9hjZ9St0rpWkW3N7hxQdTl5n4MxTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hO7XxZuU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716725; x=1778252725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DTR2reLVr32ztLRUsZ/63i5tZqMftT2NNn7Lh3AoxvM=;
  b=hO7XxZuUF//m5iS/80KUx5LEwWH6rQGM06mcpHaqdXqkc6N7/VEtb49q
   3uJ/E13hd9PkuGArjNOL6xV2u6Vjf8Dopp0cYjErETb2DfDTBh0Ti10Pz
   Upn5xvzK+rjUb09RFO9ooBOV1vlQZPQo0RqNDqX0kXeZ2Uy9NuTBj+MPZ
   2Ip93fBKXMAAyBtlJmEvH7JEHC+/N0krztpe48FBJ7bvTolWRvrqykLrA
   MQWRmjVXJEN0csA8sZifBE2dNVDuj0p4TStNwvARmf9RnpdE66eNO/Gws
   +fAbZFTPyuAE2PcQNVQcCy1X0FzqrnaKp0bX170ceItTKw5J2gzMj1pcB
   A==;
X-CSE-ConnectionGUID: BjPuOPzDTMOWZQ3cHPldwA==
X-CSE-MsgGUID: 56DfAqWpQTq2vKj+g9r0Gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888066"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888066"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:24 -0700
X-CSE-ConnectionGUID: 9+IEfk3jSKuT4w3K01M9PQ==
X-CSE-MsgGUID: 4R7sHZGTQ66gN4T/eXJBdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439857"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:22 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 10/55] i386/tdx: Make sept_ve_disable set by default
Date: Thu,  8 May 2025 10:59:16 -0400
Message-ID: <20250508150002.689633-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX KVM use case, Linux guest is the most major one.  It requires
sept_ve_disable set.  Make it default for the main use case.  For other use
case, it can be enabled/disabled via qemu command line.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 370bd86f2ca7..2ed40b76141a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -288,7 +288,7 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     cgs->require_guest_memfd = true;
-    tdx->attributes = 0;
+    tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
                                    OBJ_PROP_FLAG_READWRITE);
-- 
2.43.0


