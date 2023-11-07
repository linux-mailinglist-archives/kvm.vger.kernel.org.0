Return-Path: <kvm+bounces-896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D58077E4235
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 115461C20C9B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3676315B9;
	Tue,  7 Nov 2023 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwqWklkF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCCE3159C
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:46 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7FC126;
	Tue,  7 Nov 2023 06:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369065; x=1730905065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U8lWXTPwkeavCXYIsvajq3NYy2RkwrZkC4ZU3I7ZBCo=;
  b=EwqWklkFliywEn1SOFEHri4wEmw5FHDneWInwT9s/T0FTmFg8fwTM/OZ
   D8UvERI9705z9i/4ZuLKFEzJLwzX90+mAIW/M5DDACuFQcO+rpgTvATQj
   Cr+qoMPM5j91yEDi2jCyHTa5zDLJi4WCMB93gpWxHuqWJAqE2NB0eGOnh
   TMmhqVkQVENQe21ArxjPopWDmXXlpcGnih2tN+eHpBppslkkOkj6E47Cl
   bb+KznCXN79CaSV1aTspzCbAFEx4B0m6e0z1J+1mkxofT9hXKGoAxCqMa
   X9AXqXrOTR61GRud4ZIARwjb419TFOKYUAMtXWzCIWdKcqwvOuOPjRlrW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555656"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555656"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10443922"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:40 -0800
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
Subject: [PATCH v17 004/116] KVM: VMX: Reorder vmx initialization with kvm vendor initialization
Date: Tue,  7 Nov 2023 06:55:30 -0800
Message-Id: <2ae2d7d2bdf795fe0e5ef648714d56bd1029755e.1699368322.git.isaku.yamahata@intel.com>
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

To match vmx_exit cleanup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 266760865ed8..e07bec005eda 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -180,11 +180,11 @@ static int __init vt_init(void)
 	 */
 	hv_init_evmcs();
 
-	r = kvm_x86_vendor_init(&vt_init_ops);
+	r = vmx_init();
 	if (r)
-		return r;
+		goto err_vmx_init;
 
-	r = vmx_init();
+	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		goto err_vmx_init;
 
@@ -201,9 +201,9 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
-	vmx_exit();
-err_vmx_init:
 	kvm_x86_vendor_exit();
+err_vmx_init:
+	vmx_exit();
 	return r;
 }
 module_init(vt_init);
-- 
2.25.1


