Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835DC55CA93
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242151AbiF0V6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241603AbiF0Vzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70AD18365;
        Mon, 27 Jun 2022 14:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366910; x=1687902910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z+oGW1stVMnX6ptGRRcW6UXD1Jk+CvVMKsEtYzTtz08=;
  b=MUaQzJJd9yCu6c+/vCyNok5kEoIkqFqGRmXdu4BH6beyxdlSxW+iyhqk
   rIFsLc/mUelIAHgf+zgETM9N2eJMhpmLPblBWTQOGWM6tFQzx66te7e9/
   7LwggRj1p0exAJei+EsS2uaTuBArYS+mWTO+gKdJW55Prl9VwqukZP9qo
   CipoCyv861NmbQpchBwhk404A1rq7oF7S9okkzuyHcFkBMk4zqFpWAOIL
   xgeDPjFEDq7RTtUAM1yazznO8LnyIP8ddsILLe4CnAera3Yz21dxrHL9L
   gt9KdwXZSnDCWiwtn39vr3tJlWBHdGuo4t/2kpD7M+2SpXZduVjCNQNFL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116147"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116147"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863755"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 095/102] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Mon, 27 Jun 2022 14:54:27 -0700
Message-Id: <fc9fa1611a46c9cace99d6e718f84bab7cef79b9.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/x86/kvm/vmx/tdx.c   | 20 ++++++++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dc66c799cae8..00baecbb62ff 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1203,6 +1203,24 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
@@ -1221,6 +1239,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d6785d2685f..014337760dfa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -448,6 +448,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX            7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.25.1

