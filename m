Return-Path: <kvm+bounces-36495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C622EA1B6EC
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1EA1684B5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624833596F;
	Fri, 24 Jan 2025 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YWFrOg9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242757080B
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725860; cv=none; b=md1DAHXFc08Y+f74sIQbIIqBa/EkiA7tzSc2J2g8OkA/1RVDysy73ioJbM0B/OOCcoolfp5FK2xAEFB0gfL9Byk6nYikKqTwKGHBF106vYDnPTTi7mxulCwSi1phXp82ylFg4RfoLRCL7GOWC7SJ3syIPWgP90V4fTAYlqcz6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725860; c=relaxed/simple;
	bh=F8ch/qHyLt2WHZ+uYLam5gSOJtfGWUCHU0mx+JtYsOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Caj56VuKvNhW2XVp1P75TXZZ0ZU6zlJPl6YDwsR5b6AxybJqDmlW7Qt9Iqp9uTee1COP4hTOBmXJaUK37uONg9jWgcNOA+M1yC9q44IZNzi67yZLxvAcmJCm/Rp40A3BxYO12bixd8sblBUXoKcVm+0m+ZtIcfe9kGQFuiAs9/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YWFrOg9Y; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725860; x=1769261860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8ch/qHyLt2WHZ+uYLam5gSOJtfGWUCHU0mx+JtYsOU=;
  b=YWFrOg9Y+lPTLr4ax6LAStQMzohtlFhL3sGtn0je5bNLL3maYMkXJDlv
   AQnj8detcmPXgs/xQkVZjZXfKT+Vfx0fv26XrP6aOd3zQ4rbV1ONvwyCc
   OF/wtIE4z4YMYaSCRcwwcMpvHj9lM+9OWTAKzuNqmTE9R2xalUavuntQc
   I0uYew7m0obNod5aOM3eNpGDa1SILRFTisM58BZZuFqITJNc8BhU3IloF
   Scaz2nZbkzgH9zfr+CfwGPUXTVbROot99lVUbQZRdg4/2AyGhkJfiyl1P
   GwPyhnw6OcEH/cqahKclKOGUKGUsYQI/lmmclYa8HMBRb31kwPSb45nfF
   Q==;
X-CSE-ConnectionGUID: UiOHkY5TTXCkzhWd3yc/iw==
X-CSE-MsgGUID: /GJAGQ1RTdy2FjX794/n1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246245"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246245"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:39 -0800
X-CSE-ConnectionGUID: vCehlZIdQm6+gmZkBYWjMA==
X-CSE-MsgGUID: vRKtt1j1Q2ecC5GamkpXiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804188"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:35 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 10/52] i386/tdx: Make sept_ve_disable set by default
Date: Fri, 24 Jan 2025 08:20:06 -0500
Message-Id: <20250124132048.3229049-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX KVM use case, Linux guest is the most major one.  It requires
sept_ve_disable set.  Make it default for the main use case.  For other use
case, it can be enabled/disabled via qemu command line.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 214ff7409e1f..dcb19a18e405 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -286,7 +286,7 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     cgs->require_guest_memfd = true;
-    tdx->attributes = 0;
+    tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
                                    OBJ_PROP_FLAG_READWRITE);
-- 
2.34.1


