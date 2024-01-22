Return-Path: <kvm+bounces-6578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 303888377E7
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42C47B24B6C
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 23:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E314C50241;
	Mon, 22 Jan 2024 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEn2Jglr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C94F209;
	Mon, 22 Jan 2024 23:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967697; cv=none; b=ryOTFkO+cK+Fmx7AGffg3WTXgAMF+UmKQOnrnDf09ZHqIbVWaL+9WQSAXRJMgPYuRuRKkGh4uzoWG9H+fsjDJ07K1DEQyRFsltEG75v8W99myd52Vsyakh3ivS4JaMaySAaV0M1Y75DrKOAR+XElLdn/xSqN6d+gpocMBgLUrdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967697; c=relaxed/simple;
	bh=w5Qeo1eALpoG+9WS05VfgzNYlYM5leha1sNWs649lTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SmNHNi572zguIa09HsmaVlYidJ4h14maNpDwP2NKBI8yDne4rEhCVgIN2AyR365Wi/eFIioN65r3gEqx9hNsCmio4ISQhlsf3E29dknyBf+hGSlpDSETUUDe5WLGXuCyOCVj3a56QCZrFmqYmeBb0P2v03YRHgCQ/MjYFhPDj94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEn2Jglr; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967696; x=1737503696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w5Qeo1eALpoG+9WS05VfgzNYlYM5leha1sNWs649lTo=;
  b=ZEn2JglrPCML1i6r5S/P/mW6wzUlLk5NuQ2MMj0W6xPMC7lvOuSW2HBd
   4WcRPdDbsBMAJBbk8ihdBc7rkKWR63TQkU3tJAGh7e+nfbtNVLKvQaD6U
   e3YPrRFpnDR8+GbOdOOp20aqtv9GOD2ulJAM/P/DQjWCditoP5iBd2KJ0
   zM1WHVd2oc5NWBM/fLIEI5nTUfWj5wW4xhauJ/Q4HV+rq4D0aYc/RhvLd
   aPt6FtZhabvgxJaw9M8jQ5l+hFfIdum8oxCk5ACI7/bQp+t+ACoXDRSiu
   1Ng+tHW7Z52xigDypNZ4vIxn2ZWt8DvNOjfur6hVUvekldaCW/aWqYtSr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217815"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217815"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350122"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 005/121] KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
Date: Mon, 22 Jan 2024 15:52:41 -0800
Message-Id: <51c5466c541e1eddad928af602bd889721524d34.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
hardware_disable_all().  To allow hardware_enable/disable_all() before
kvm_init(), initialize it in before kvm_x86_vendor_init() in vmx_init()
so that tdx module initialization, hardware_setup method, can reference
the variable.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- Move the vmcss_on_cpu initialization from vmx_hardware_setup() to
  early point of vmx_init() by Binbin
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 55597b3bdc55..77011799b1f4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8539,6 +8539,10 @@ static int __init vmx_init(void)
 	 */
 	hv_init_evmcs();
 
+	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
 	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		return r;
@@ -8554,11 +8558,8 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
-- 
2.25.1


