Return-Path: <kvm+bounces-895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FF07E4233
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76FEBB20D55
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF03315A9;
	Tue,  7 Nov 2023 14:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmzZRIoH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE43159B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:46 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2423120;
	Tue,  7 Nov 2023 06:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369064; x=1730905064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NecVbGHHCyQtzLmEwFOsvUh9HAGJADDZV1+nGp6pu58=;
  b=WmzZRIoHfg5DQdGwTRYzsvzrwU7iT4kqxFEE8X/3g8WDxa7+6DK195Od
   9DSn6dOjKjjbafsr+xFvmGUla3gYfMI7muAKCqf25HNmDUhrToSdb7mE5
   3URsLSCVh6aWzDSpKYWELJX40DhC2vSVZ2fanuJbi4AjC6WLxm2Q3zqeX
   fZvfGVJzIzAvAaju3tAu3njk43IQa4Yw5VFrSPFOPKG91CE41D/THDf8/
   E6+Gnp9nSbrUehTehgNo3XcrayGvHPJze5zj+WirZ9i/gOxM9uloqofKn
   RH60fyHuSzdjxh8qWC4eENnW3ZLY+/31yQjoOXUoOzapiKDwhxNH+auwZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555641"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555641"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="886319171"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="886319171"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:38 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 002/116] KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
Date: Tue,  7 Nov 2023 06:55:28 -0800
Message-Id: <2909211f19ff00fccbfeb9dee396a891384333f2.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
kvm_init(), initialize it in vmx_hardware_setup() so that tdx module
initialization, hardware_setup method, can reference the variable.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e081c964e7a..0f3769cc3741 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8263,8 +8263,12 @@ __init int vmx_hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
+	int cpu;
 	int r;
 
+	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
@@ -8507,11 +8511,8 @@ static int __init vmx_init(void)
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


