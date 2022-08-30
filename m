Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D205A6509
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiH3Ni7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiH3NiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EB8E9A95
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqmqdlDTDI5z0ZN2Br8ZM1fyndGHGtgHR1grcbr3ajc=;
        b=exlAvNIvg7S38cO1nj4QlWmCu7rdpTTf2eGEwZWgMsjrH0wylNWC5Vlmt/yzmV6bL9Z0HZ
        hHtOYGPXxVtifY+KXdeda/2artha0Iw9CZNTCIL46459IE62ywm82ulcHVhrMNWoPRlDsO
        L/lVrTZWkGWSnSlj7zVTqaJkLDTs3X8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-m-Qanej8N6WppPH-RF8-0g-1; Tue, 30 Aug 2022 09:37:58 -0400
X-MC-Unique: m-Qanej8N6WppPH-RF8-0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A64CD382ECC6;
        Tue, 30 Aug 2022 13:37:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 687192166B26;
        Tue, 30 Aug 2022 13:37:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/33] KVM: nVMX: Refactor unsupported eVMCS controls logic to use 2-d array
Date:   Tue, 30 Aug 2022 15:37:11 +0200
Message-Id: <20220830133737.1539624-8-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the handling of unsupported eVMCS to use a 2-d array to store
the set of unsupported controls.  KVM's handling of eVMCS is completely
broken as there is no way for userspace to query which features are
unsupported, nor does KVM prevent userspace from attempting to enable
unsupported features.  A future commit will remedy that by filtering and
enforcing unsupported features when eVMCS, but that needs to be opt-in
from userspace to avoid breakage, i.e. KVM needs to maintain its legacy
behavior by snapshotting the exact set of controls that are currently
(un)supported by eVMCS.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: split to standalone patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/evmcs.c | 60 +++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 9139c70b6008..a82af2482f84 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -345,6 +345,45 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+enum evmcs_revision {
+	EVMCSv1_LEGACY,
+	NR_EVMCS_REVISIONS,
+};
+
+enum evmcs_ctrl_type {
+	EVMCS_EXIT_CTRLS,
+	EVMCS_ENTRY_CTRLS,
+	EVMCS_2NDEXEC,
+	EVMCS_PINCTRL,
+	EVMCS_VMFUNC,
+	NR_EVMCS_CTRLS,
+};
+
+static const u32 evmcs_unsupported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
+	[EVMCS_EXIT_CTRLS] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
+	},
+	[EVMCS_ENTRY_CTRLS] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
+	},
+	[EVMCS_2NDEXEC] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_2NDEXEC,
+	},
+	[EVMCS_PINCTRL] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_PINCTRL,
+	},
+	[EVMCS_VMFUNC] = {
+		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMFUNC,
+	},
+};
+
+static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
+{
+	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
+
+	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
+}
+
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 {
 	u32 ctl_low = (u32)*pdata;
@@ -357,21 +396,21 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
 		break;
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
+		ctl_low &= ~evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
 		break;
 	}
 
@@ -384,7 +423,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	u32 unsupp_ctl;
 
 	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
-		EVMCS1_UNSUPPORTED_PINCTRL;
+		evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported pin-based VM-execution controls",
@@ -393,7 +432,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->secondary_vm_exec_control &
-		EVMCS1_UNSUPPORTED_2NDEXEC;
+		evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported secondary VM-execution controls",
@@ -402,7 +441,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->vm_exit_controls &
-		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-exit controls",
@@ -411,7 +450,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	}
 
 	unsupp_ctl = vmcs12->vm_entry_controls &
-		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-entry controls",
@@ -419,7 +458,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 		ret = -EINVAL;
 	}
 
-	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
+	unsupp_ctl = vmcs12->vm_function_control &
+		evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
 			"eVMCS: unsupported VM-function controls",
-- 
2.37.2

