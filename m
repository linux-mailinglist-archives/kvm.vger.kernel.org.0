Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4E58BDC5
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242081AbiHGWJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241870AbiHGWHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6371CBC17;
        Sun,  7 Aug 2022 15:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909798; x=1691445798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9k8hHT4h6MN648mDsUmZu+Cs5u9gYRKRacre65MQmzg=;
  b=P2zcuqkERoeJ36kwHn5dwZnO7VG6E4XplayhfnrHqnlS+ZHVc83Nr//V
   bDJTCptW8WqpO32gHfVIyHcgJgiWLYjTZUIs41CvREyP8Uv20QGL/0sMD
   MVrsR4FXXNPR4wJGpwz239Btf1JVTlR5RAt7VHpxBifLpkB0xFnyEVzqi
   YIVAZ5Ldrb4WGi3EQ88ADyfBzfmCtuC5ZNPcIoedLSP0d2cVibYLPCll3
   rBq0WhiO28nHBvuxlSGTscMaOFfdDH0ZIjnwni5POeAQNhnlJoJ1prc6F
   ERMZ223EUw+g31CBU20WmYhmUVYOYLIUWh4PKIEilihIqxdG3ig7DL3qG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240400"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240400"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682737"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:43 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 089/103] KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
Date:   Sun,  7 Aug 2022 15:02:14 -0700
Message-Id: <78f8eae8b9286409bfde60d06a05d822cd246fc9.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX Guest-Host communication interface (GHCI) specification defines
the ABI for the guest TD to issue hypercall.   It reserves vendor specific
arguments for VMM specific use.  Use it as KVM hypercall and handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c3cea3cb4d15..849bae37246a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -906,8 +906,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
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
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true);
+
+	tdvmcall_set_return_code(vcpu, ret);
+
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

