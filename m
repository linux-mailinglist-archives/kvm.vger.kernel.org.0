Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5026F5F0912
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiI3K1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiI3KZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:25:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB3322B12;
        Fri, 30 Sep 2022 03:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533198; x=1696069198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pTAM5O5il6nt/65EYbq7evLkjZPVzO1QuMnGQ4g6lmg=;
  b=HTgqNGZNTvEXsgdbEQrOEcs4t+XHPjRYu24IgFjSHv7dKlOKqgL1VMvg
   GHJUNnTMFXmwhHLhD0TSvmHQqb44lRCEDvmiXgco/eF56vIJ+u/zxQ4Xs
   kNYR2y3rj4Uzazl2hDJlykwksNGpAlG8X+29/LJgHrvOUWtRqMHI2GTUm
   vd7y0zeVT17VswUvHyb4ZJO/uq/RgnuVr2la1jd+Tlveoci+4/h3A8WNd
   kOzAaV2nlshDVrim5Bi5ZYCIlrYGzANEahlPMK9U/4ASpmYvgn/8Xw6pB
   m9fB2UMDzT94TS8ioDnvPu44w32nUz5J3pTokEA3sHMif5YsbHwvHsEs1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540177"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540177"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807822"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807822"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 097/105] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Fri, 30 Sep 2022 03:18:31 -0700
Message-Id: <58ea2a6ddcc53bfe1a5755c308e695c1343a8bd3.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV report fatal error hypercall to KVM_SYSTEM_EVENT_CRASH KVM
exit event.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c   | 20 ++++++++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6cf18eca654a..a7cf08d60744 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1060,6 +1060,24 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Exit to userspace device model for teardown.
+	 * Because guest TD is already panicing, returning an error to guerst TD
+	 * doesn't make sense.  No argument check is done.
+	 */
+
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX;
+	vcpu->run->system_event.ndata = 3;
+	vcpu->run->system_event.data[0] = TDG_VP_VMCALL_REPORT_FATAL_ERROR;
+	vcpu->run->system_event.data[1] = tdvmcall_a0_read(vcpu);
+	vcpu->run->system_event.data[2] = tdvmcall_a1_read(vcpu);
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1078,6 +1096,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 47621588a792..498a2b92f2db 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -478,6 +478,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX            7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.25.1

