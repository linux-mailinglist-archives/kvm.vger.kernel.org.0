Return-Path: <kvm+bounces-63494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C46C67C03
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B38A24F0366
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031022EA73D;
	Tue, 18 Nov 2025 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ds/0x8hF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99B2EB85E
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447769; cv=none; b=UE7xsAZsvy/pPKqfx6b/L2ZUteKmi1R0Yefh8pEZqbJ83ANVXJ/Ncry++Kr0hvS4kr8yFoq7DtLqSj8KBEywEA2qvx8g99+iHWWirBpcX3PP43patz/Co7S3wvVXj2q/d/K0M3uoH4kEVHIBkJZASQFTeOmYi3GaxFtyS9kI7yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447769; c=relaxed/simple;
	bh=2EeeRsC/XUg3teXyYaUyiQUeaj5evO6uMb81KhvNQWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+sD7PEN2UTy6qHWPwe/qPg0Zise7h4KojGUZT/mXU69Lu/+55d/8mdIWyFDHrTd2fDb2Gqpea0O/W50i2NBlz19KE6xWU91en6iIlsymP+GGaJ7A8oP4nDmJDd4C32vbB3cbEK8pmavpTCh14OSQ1Pzy+1DUPC7klppmyF5sp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ds/0x8hF; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447768; x=1794983768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2EeeRsC/XUg3teXyYaUyiQUeaj5evO6uMb81KhvNQWo=;
  b=Ds/0x8hFAPnpWr4X01ryoFu17PRsQgRMGzjA2fv9iLjSJkzSod/NopEY
   X/jOuzVg54u3WsDdDF8YK27EBVhmuLJohSXvRXI1bFouG1jNve2VsDM+7
   mjZLogRolLUUBmJ9l0hObNSIJNkXb8sSuQrVvgUF0CiaXtDz4WglzmENT
   rP8jzmAsLkFIBQxETZIAzb/CgySn/qoUQFLjvCANt33TC/NDwZbaSK69p
   P12qjzVZq54iymPx1O064h1KllZo8J72X3tcBNT0ZjfnP7qetISqSbuby
   PnAe9GyrxsHvQT4SpITOPGhi3ykPO7juH4ojQarWCWPIlJu7jlQGFV4fP
   w==;
X-CSE-ConnectionGUID: mJ0Q6VR4S02P96oUEy+dXQ==
X-CSE-MsgGUID: IJnXhe7ZTEizB+sBhT4zqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82850962"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="82850962"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:36:07 -0800
X-CSE-ConnectionGUID: ilqn+WJjQVuS1nRIFuCG7A==
X-CSE-MsgGUID: GmCXOVJZTai3lJ4np4cO6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189962670"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 17 Nov 2025 22:36:05 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 3/5] i386/cpu: Add APX migration support
Date: Tue, 18 Nov 2025 14:58:15 +0800
Message-Id: <20251118065817.835017-4-zhao1.liu@intel.com>
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

From: Zide Chen <zide.chen@intel.com>

Add a VMStateDescription to migrate APX EGPRs.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/machine.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 265388f1fd36..84faa2f8f8d3 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1744,6 +1744,27 @@ static const VMStateDescription vmstate_cet = {
     },
 };
 
+#ifdef TARGET_X86_64
+static bool apx_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_APX);
+}
+
+static const VMStateDescription vmstate_apx = {
+    .name = "cpu/apx",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = apx_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64_ARRAY(env.egprs, X86CPU, EGPR_NUM),
+        VMSTATE_END_OF_LIST()
+    }
+};
+#endif
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1895,6 +1916,9 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_triple_fault,
         &vmstate_pl0_ssp,
         &vmstate_cet,
+#ifdef TARGET_X86_64
+        &vmstate_apx,
+#endif
         NULL
     }
 };
-- 
2.34.1


