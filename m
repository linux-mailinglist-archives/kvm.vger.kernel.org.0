Return-Path: <kvm+bounces-989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EB57E42C0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 028BF281FFF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8118C3986F;
	Tue,  7 Nov 2023 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ikYBGiff"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379E5374DF
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:05 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6400F5BA1;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kvg6M3PP9b1Feqc+dqMh6ZHnL38eYag5ZqbCXP1dUlA=;
  b=ikYBGiffbmACyZvrbR2N8hbBSeE8Bvzk2GjNZCtLWNIfHeSP8OJU8Fsb
   56QviQJI5pLWGl8pDkt2uxpWu6cZgaqj67Ci/wIJBhlNXwT+zupAaTewS
   8di7d61Od7OQjtzjvknTXcFHP+V+aFNWxxDPzbmtI544k9hl4Ux2Y0iKo
   H43cw2QBcEe5R/wZQTA+pQKdmvZj6/FhOVflROgJwHn+sGkvqAedfRQtt
   BsBjs/xxj35F1YNvlZp/QQppcEyLZTVKYiF8Gw1lYVT+WBjSYlIRBcG4/
   SXgAzl2OnVTtfwmXnfl9BvRJq1Ve1TkiOLG+nHe8luaFpJXXAvMjm10xY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462580"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462580"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851576"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:24 -0800
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
Subject: [PATCH v17 091/116] KVM: TDX: Handle TDX PV CPUID hypercall
Date: Tue,  7 Nov 2023 06:56:57 -0800
Message-Id: <47d4b77c758f9127b1a9e306b06ca15acd87ac79.1699368322.git.isaku.yamahata@intel.com>
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

Wire up TDX PV CPUID hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 252c075cb430..3a1fe74b95c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1084,12 +1084,34 @@ static int tdx_vp_vmcall_to_user(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdvmcall_a0_read(vcpu);
+	ecx = tdvmcall_a1_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+
+	tdvmcall_a0_write(vcpu, eax);
+	tdvmcall_a1_write(vcpu, ebx);
+	tdvmcall_a2_write(vcpu, ecx);
+	tdvmcall_a3_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
 		return tdx_emulate_vmcall(vcpu);
 
 	switch (tdvmcall_leaf(vcpu)) {
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1


