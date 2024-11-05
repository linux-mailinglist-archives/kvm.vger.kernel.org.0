Return-Path: <kvm+bounces-30645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 350219BC582
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E15A61F2221A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6370E1FDFA5;
	Tue,  5 Nov 2024 06:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hbHR2tUk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E761FE0E5
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788630; cv=none; b=Dup5cf+VEPOpi7CpXzoE2csAIBsyRSvwHco8S0M2k05O5voqgYAk4utXL2L0KnF15hk1KiBxCVRiRzr+hhQtMfzSyEr7ANTN2PN+6aIJpPiI7WOS+wC6AKLXpX87TdHbLysFfvG2zoqYnjTPRHRYFNjDqI0MEYjtTWNSzGuUKxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788630; c=relaxed/simple;
	bh=3vrjucC0HxJukGg8dTLCBBUFcd1deUmBY7cHA/rzJ28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PyuRBN1rphI1SX/J4dZpRiSIzLnOhO51W2UxBiaweGs/ypsoDRPkCTpXMpu9RlyuLjfI8rQSSqRefAELGAAyy1kw6gnKWJAMh8ar5Fo5s3YITzLpdyn4/VjhxJ+SIU1f62SDmjwYEHXwrmlVq6JbMiF161rIJ/Yv256sNNHpOyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hbHR2tUk; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788629; x=1762324629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3vrjucC0HxJukGg8dTLCBBUFcd1deUmBY7cHA/rzJ28=;
  b=hbHR2tUkk2hGy13NWdcugBFuRrFbkhdqa+NJVAGuHm9fgJIX/C1qCzq7
   dtxMIpVVMWWsY//qJ9MK5pqRf++WA9Mf9prF0hX12uKrs/i1J18T0JvWK
   3S2fAWY2J7T1wWrB+GjPwSRg/W3nm9PCrqg7hc+hJk/Yb1btVeK86GG24
   v9VBIdIiIHnboeaOovYkJpgjKOclkwYeo8gi3yIEthMRRlwIkhuM55y8v
   juhqUssb/C7x3ApS1kCln/y1IFm+tIyJw2LYtLX9yid39nbcXZjk2EmuN
   VB2H9Fv/nyffg6AtyIWWkt7Qct49dq4MVO205J4GxXmREe2HjR0nrMVTi
   A==;
X-CSE-ConnectionGUID: ivybeuNQTKqa7nK6sTuQ8A==
X-CSE-MsgGUID: gU9rHaaaRyqJJjX9qGz9EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689399"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689399"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:09 -0800
X-CSE-ConnectionGUID: Zm2pPz90SC68qOWzD6MiDQ==
X-CSE-MsgGUID: UIm5o8N/TvOypSmczHpCoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988743"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:04 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 11/60] i386/tdx: Make sept_ve_disable set by default
Date: Tue,  5 Nov 2024 01:23:19 -0500
Message-Id: <20241105062408.3533704-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
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
---
 target/i386/kvm/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index faac05ef630f..e8fd5c7d49e7 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -258,7 +258,7 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     cgs->require_guest_memfd = true;
-    tdx->attributes = 0;
+    tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
                                    OBJ_PROP_FLAG_READWRITE);
-- 
2.34.1


