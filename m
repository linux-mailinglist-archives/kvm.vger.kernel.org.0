Return-Path: <kvm+bounces-999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 653CB7E42CA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9BC8B2268E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79CCC31A71;
	Tue,  7 Nov 2023 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4UUUH2U"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B203F38F88
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:10 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DE95BA5;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3hwdDWQaIoOEj7Dq3xlMB4Z5kjD4AB7DeA+afbSW1AI=;
  b=H4UUUH2UhmjVOy6bS3x2ebu27F5snftqghDqcDV4BYN0O5mZNXRJRege
   Wngrk7yuMb7FS7G4fIhing9ykAQCTh5ozMa3cj5T8LfAAlP1dMG7lAycT
   xxmSHUjYA3NRwKlvIg8X23NULi1uVUUaCrkJ2s241Ak2UcwHukA3cQ/ZB
   C+ZXJwXxjyLYE1Jy1zsowNoIqNq4ZFHxNQ3eifvIDne2S8XLiyoiCehrF
   XAsPZiq3CapazpTX6dpmlD8bslO+BLZqZ8rLBc51QWYu1upi7XHdMGb0l
   ULIS6pivBpq0IqHuv1RQN7kCKGor5s2QRbLYYiivZDT+3Bi3ICFFlJ/2m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462576"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462576"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851566"
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
Subject: [PATCH v17 089/116] KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
Date: Tue,  7 Nov 2023 06:56:55 -0800
Message-Id: <78e3f911bf3adf6c03f136f28b57ffc37a5fa64d.1699368322.git.isaku.yamahata@intel.com>
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

The TDX Guest-Host communication interface (GHCI) specification defines
the ABI for the guest TD to issue hypercall.   It reserves vendor specific
arguments for VMM specific use.  Use it as KVM hypercall and handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0128df19fccf..f1d46cd002b6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -982,8 +982,41 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+
+	/*
+	 * ABI for KVM tdvmcall argument:
+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
+	 * Non-zero leaf number (R10 != 0) is defined to indicate
+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
+	 * number.
+	 *
+	 * R10: KVM hypercall number
+	 * arguments: R11, R12, R13, R14.
+	 */
+	nr = kvm_r10_read(vcpu);
+	a0 = kvm_r11_read(vcpu);
+	a1 = kvm_r12_read(vcpu);
+	a2 = kvm_r13_read(vcpu);
+	a3 = kvm_r14_read(vcpu);
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true, 0);
+
+	tdvmcall_set_return_code(vcpu, ret);
+
+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
+		return 0;
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
+	if (tdvmcall_exit_type(vcpu))
+		return tdx_emulate_vmcall(vcpu);
+
 	switch (tdvmcall_leaf(vcpu)) {
 	default:
 		break;
-- 
2.25.1


