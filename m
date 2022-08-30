Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE445A64FF
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiH3NjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiH3Nio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04337E9AB5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=spABDc82uqtVdtz60huBLMXsnXofvcWaFNGz++WjUa8=;
        b=MKR6lL8SmhgT2CYvm6B9xupoaQTj4duMdD2F8TYEQxGIKQlDqKjsyhwdLN6M7zX3S9ueFh
        U926f8it6l0iZU/VrOdT6nt2Gj7PKNwQOjz7bW+9qg/huV3FMUYo0GnRZ4MZ/W8XQWHkqJ
        iwgeUyf0EWd/RZDjpnbvXD89UqPeaNE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-jbBYwNy-OtKyjM_o0xIChA-1; Tue, 30 Aug 2022 09:38:01 -0400
X-MC-Unique: jbBYwNy-OtKyjM_o0xIChA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9375A382ECC5;
        Tue, 30 Aug 2022 13:38:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3E872166B26;
        Tue, 30 Aug 2022 13:37:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/33] KVM: nVMX: Use CC() macro to handle eVMCS unsupported controls checks
Date:   Tue, 30 Aug 2022 15:37:12 +0200
Message-Id: <20220830133737.1539624-9-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Locally #define and use the nested virtualization Consistency Check (CC)
macro to handle eVMCS unsupported controls checks.  Using the macro loses
the existing printing of the unsupported controls, but that's a feature
and not a bug.  The existing approach is flawed because the @err param to
trace_kvm_nested_vmenter_failed() is the error code, not the error value.

The eVMCS trickery mostly works as __print_symbolic() falls back to
printing the raw hex value, but that subtly relies on not having a match
between the unsupported value and VMX_VMENTER_INSTRUCTION_ERRORS.

If it's really truly necessary to snapshot the bad value, then the
tracepoint can be extended in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 68 ++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index a82af2482f84..b620880a8af3 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -10,6 +10,8 @@
 #include "vmx.h"
 #include "trace.h"
 
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
+
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
@@ -417,57 +419,35 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	*pdata = ctl_low | ((u64)ctl_high << 32);
 }
 
+static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
+					   u32 val)
+{
+	return !(val & evmcs_get_unsupported_ctls(ctrl_type));
+}
+
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 {
-	int ret = 0;
-	u32 unsupp_ctl;
-
-	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
-		evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported pin-based VM-execution controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
+					       vmcs12->pin_based_vm_exec_control)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->secondary_vm_exec_control &
-		evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported secondary VM-execution controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_2NDEXEC,
+					       vmcs12->secondary_vm_exec_control)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_exit_controls &
-		evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-exit controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_EXIT_CTRLS,
+					       vmcs12->vm_exit_controls)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_entry_controls &
-		evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-entry controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_ENTRY_CTRLS,
+					       vmcs12->vm_entry_controls)))
+		return -EINVAL;
 
-	unsupp_ctl = vmcs12->vm_function_control &
-		evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
-	if (unsupp_ctl) {
-		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-function controls",
-			unsupp_ctl);
-		ret = -EINVAL;
-	}
+	if (CC(!nested_evmcs_is_valid_controls(EVMCS_VMFUNC,
+					       vmcs12->vm_function_control)))
+		return -EINVAL;
 
-	return ret;
+	return 0;
 }
 
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-- 
2.37.2

