Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A1C6B69B2
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjCLSG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjCLSFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C903CE12;
        Sun, 12 Mar 2023 11:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644050; x=1710180050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q8SlPnpVQ19Y0vaCeMMd33IDv3YcYUS6ZiHVRcdkCLU=;
  b=JZg7H/2Wh9qZwDRH1hOZfiMCbF2tFc5lg+RKEewrSZnzrqXxvDOu4oyL
   zc+6qpaLorT6jY3NUpQzUzEzyTo6J+Mo6sTwIuBRcwLYdGuaqUj0HHqo2
   2D4hpfI3e97pah99EuH++P8sMQ01lo7qCfy9Mom+mMAcZ2D5he5P3LD60
   3++ClzAaskmnM8mwg0E6ugMynisWr74XQC6+z2aakdPeD1qxGESq9o685
   mVRUrcLXooIJfCsZCT4SdYep1sgnGCzzj21A1Fhmgr6YeSBMHGq8BNPA+
   OUJd0ac3eyDFHXCyvkaQZiIU0noi87SeuGyAHqmz2dDmRdfmQ492sXreP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660057"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596793"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596793"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 089/113] KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
Date:   Sun, 12 Mar 2023 10:56:53 -0700
Message-Id: <2cf69dc2abf641f255b16a7bfe0d21fa0c48cba3.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index b3cac901a32f..12af9a763ff4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -844,8 +844,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
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

