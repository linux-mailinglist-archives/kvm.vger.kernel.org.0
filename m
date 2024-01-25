Return-Path: <kvm+bounces-6919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A7B83B7E3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ADA81F24EE8
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7402C125B4;
	Thu, 25 Jan 2024 03:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R0du6TdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59F11712
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153308; cv=none; b=kahJWhgNRMAI/J546Dj9r41w9yh7A7w+/P52eCV/C73BuzmwHh/DD48IL8MDkF6UJKPB5rWqzBl1h7/mW10Q0J9mU7VhVXkDkGGgyYmxr74gHj5pVRJBvv8T4ho0t0wk6gPkEvmxH1pxyN7do4G2Ly4x16cgv8w9VViki661PJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153308; c=relaxed/simple;
	bh=MDV1CK+CwY5NNGZELqNeBXtymIPsaa9CAufkhjBYBw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ub+iOqBI4w40nxD9AyS/uUvXhAlDJeo4RX664V3rByulMVm+lRNSS0f22hWZAtkQADmBKEZx8nORqhpqEJQ2z8xWmxGAspdpPj7wvaV8wSL+owHpHilewOdwegXuBT/HcBWmoIqQWslDhtrTwsw617VWHNnbTRaaWFkZL5nwzms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R0du6TdZ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153307; x=1737689307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDV1CK+CwY5NNGZELqNeBXtymIPsaa9CAufkhjBYBw4=;
  b=R0du6TdZ1n6U/dvqSJhTEkDnMEMmz+NliLhPtaXR7i+9vwh7SDOIcDpM
   6Q1J/aaW64tpaSjSr/U9qpz9aWihPO/OZvWqAtR0ET+caYb+XNLrQWlJH
   Da2eeTlhk1UItAcLPKM/g69jR5WKSwtN+WICKqOOdF0wwXD9DqrYHk1+u
   IGCOHIwkzdKcSRxKxJlsaRk+ycYD3EN3R6HAIhPXRCicSDYunYHfr5xxn
   i9u/m4i1kHqzxrJeyeEVBha20yRFloXwdV5oY1IOKg4kEPZrl5bqWwYx8
   KttjUfMNoumiR0zxByhTyq88fPss7WvR+uLRrAepW/rUlGnIgXxvTdZek
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428467"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428467"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085263"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:11 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 18/66] i386/tdx: Make Intel-PT unsupported for TD guest
Date: Wed, 24 Jan 2024 22:22:40 -0500
Message-Id: <20240125032328.2522472-19-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to the fact that Intel-PT virtualization support has been broken in
QEMU since Sapphire Rapids generation[1], below warning is triggered when
luanching TD guest:

  warning: host doesn't support requested feature: CPUID.07H:EBX.intel-pt [bit 25]

Before Intel-pt is fixed in QEMU, just make Intel-PT unsupported for TD
guest, to avoid the confusing warning.

[1] https://lore.kernel.org/qemu-devel/20230531084311.3807277-1-xiaoyao.li@intel.com/

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - newly added patch;
---
 target/i386/kvm/tdx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a962f8a4ea60..2703e97f991d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -292,6 +292,11 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
     if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
         *ret &= ~CPUID_EXT_MONITOR;
     }
+
+    /* QEMU Intel-pt support is broken, don't advertise Intel-PT */
+    if (function == 7 && reg == R_EBX) {
+        *ret &= ~CPUID_7_0_EBX_INTEL_PT;
+    }
 }
 
 enum tdx_ioctl_level{
-- 
2.34.1


