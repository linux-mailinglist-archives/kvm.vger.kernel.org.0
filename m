Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8062351C748
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359337AbiEESVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383273AbiEESTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC605DA6D;
        Thu,  5 May 2022 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774558; x=1683310558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5gKEBATWdi7brsOaUqd9Sxn2b02OlGwx2H6cEqgaWQU=;
  b=Qe02oA3Hxdk5tamuLi064gGfQzUVVXL4ZArhXrF1I2/jaJNYw9WKJ24w
   266q5VAO5suDwwIZYP0rfHa0QyzKEm5ati93odo8WwAXgnBC2zT6rY8+T
   MHzuSakX0/wiCetypb+jQ7ruQY8ptR9b9KIRlSbYdg5u1t088uqrYbmS6
   yAMrbdABgE/mEwBnn4nTyZ0kCBk7n77VyAjb8CDdS6rsTlNRqdOWkRY7k
   RMIoTWXUkmQz6TTR3cb19RSYtCndnZEWZrwRgcl7h26E9W654dQe9J9Uu
   kNs0RmhoCjydCc4P7igEp3+SBWvIVw+eujJpHXDGsjOdGnstrqikqlpDy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268097119"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268097119"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083491"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 096/104] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Thu,  5 May 2022 11:15:30 -0700
Message-Id: <6bb829189d8d94c64fb42db2d84f7519b7d29359.1651774251.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c   | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1518a8c310d6..ee83539d5228 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1202,6 +1202,25 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
+	vcpu->run->system_event.type =
+		KVM_SYSTEM_EVENT_TDX | KVM_SYSTEM_EVENT_NDATA_VALID;
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
@@ -1220,6 +1239,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9a3fd7b41fc5..df1b89ffdac6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,6 +445,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_SEV_TERM       4
+#define KVM_SYSTEM_EVENT_TDX            5
 #define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
 			__u32 ndata;
-- 
2.25.1

