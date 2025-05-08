Return-Path: <kvm+bounces-45941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 426B8AAFEF3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76897B20B7A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B8427AC43;
	Thu,  8 May 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CVa0hplN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A920286D46
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716814; cv=none; b=SI4xtsqXgNXCnWGNe9sEEOJrVUdgKX2EKnFiV7k3L3fvmCSNuG6EOMVYLMAgo6V+8UneVQ+g27fMB/c58uREJwTyAZk8p2iU6qNEnVA8v1uiggYSvyDfB23Ixa5GkFkDH2RynWUTkLs0hElZf/B5AEKTtWO1GnClgWFUzgwXvfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716814; c=relaxed/simple;
	bh=nPB+X3gAjskQD6x6nk5Fs5ZTRPuUkDL2ErdsB5rE8l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sP3Fg78I+mCoY2zxVwItZHMuRrdFFi8/gF/0Jh21LNsJmmHCdfW2tiR522lPW7VUTWjybGvaaTiVzxyjKy1WkfxuK/ua7kTabuKV/9B2ZL5cVGSEml5CnHrbQeGlmn3IvgP4rWL9zXgronJhh23CO9vfDVpU6PHETKXSGTfCJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CVa0hplN; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716812; x=1778252812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPB+X3gAjskQD6x6nk5Fs5ZTRPuUkDL2ErdsB5rE8l0=;
  b=CVa0hplNnUN4Upgrgprw8sHvQRXc2Ss9WinJVfiqahY79y1XmAr1qRpm
   ZfZuCJ1rdPkMFVI4R+gNAF+xIaRUna17UUMf5CXKlAb7G4b30FIAMPjAL
   JquMjAIFpbPY7Ot/qi6LJ/v3q2ofnrNWmbtmdebll/7WVuxSOBeObN5S0
   rr3foyn1T8l7HDkiv3zgwaZy8AgeAFVqlm6H5MGmsbdiWIpAvukd95TL7
   nfaqls9p/jkyysLaDdkU9X3xlxUuCDkSErv8HzFLJtjfOyH/uMW9eMH6k
   TgfgR2WwzbhO6VXqxg3Jcn/q2yjgUw9HnFGaWsTDuAibBYql+qL7MNp50
   Q==;
X-CSE-ConnectionGUID: PL6tjU5OSCKlmnJ3BYJ3Rg==
X-CSE-MsgGUID: D9lSjTy5SpK0ICduNvjQYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888343"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888343"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:52 -0700
X-CSE-ConnectionGUID: BcxlXAESSUaOfjafgGbhbg==
X-CSE-MsgGUID: pXOQZjApSimy2sPq6+eUSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440295"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:49 -0700
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
Subject: [PATCH v9 38/55] i386/tdx: Set and check kernel_irqchip mode for TDX
Date: Thu,  8 May 2025 10:59:44 -0400
Message-ID: <20250508150002.689633-39-xiaoyao.li@intel.com>
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

KVM mandates kernel_irqchip to be split mode.

Set it to split mode automatically when users don't provide an explicit
value, otherwise check it to be the split mode.

Suggested-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4cb767668a3a..0e1fd3e3ffa1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,6 +16,7 @@
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
+#include "system/kvm_int.h"
 #include "system/runstate.h"
 #include "system/system.h"
 #include "exec/ramblock.h"
@@ -395,6 +396,13 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -EINVAL;
     }
 
+    if (kvm_state->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
+        kvm_state->kernel_irqchip_split = ON_OFF_AUTO_ON;
+    } else if (kvm_state->kernel_irqchip_split != ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM requires kernel_irqchip to be split");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.43.0


