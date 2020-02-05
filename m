Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0F1530C5
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBEMaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:30:46 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49365 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728102AbgBEMaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580905845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kH9R5qygaELgrXQXaWn/tfFU/2DvggTDzmG5IhlZM0c=;
        b=Y+gAnnSvbjXvQgfmo62iFahMHa9iU6va0dXlOkDCqTG55qtd36Nqa/73y0k9xIeVnPpPxE
        6R2/eDdOSXWKAn7yYdJ2vhyOjqI7VkxhF9GYDmqyiWcJ7Mt/syh5Buz9bHXaj07PxQcU1c
        WwDTxon3zE76wuShCQmtkmHvIi3xvhg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-jKqfTACBOB-bEP1vPTSZ5w-1; Wed, 05 Feb 2020 07:30:42 -0500
X-MC-Unique: jKqfTACBOB-bEP1vPTSZ5w-1
Received: by mail-wr1-f70.google.com with SMTP id s13so1099388wrb.21
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:30:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kH9R5qygaELgrXQXaWn/tfFU/2DvggTDzmG5IhlZM0c=;
        b=hpxRdyz8Nm2EBhPzYbElVQTEtjNCABBV+IwDoHJqCjzLDDXVoQTHAhOvXLRKR81HSp
         JZ3WrigsSokhrxy3aO0ESGfFamFwfaE+LOKiiAM0rP8CgeYoIcUBKuW0xdQBJ6UL1U7c
         F22+2Q9KUBqEi+4cDlh4K7i6qIQeRVVMp67y0nESw499p+aCV1lw0ONqUhxmxmVhb2dI
         CrAZ8Ih3hXVJB05cpC4bsBwXZq0GaVxNKTWK0U6OyDeiLfc2O72KslAr6w4kqa3Gf8X3
         B8LRMeN/S3WV1UM6/Rf7Ncu5WXd9W299uSTG8zHgFdATuzp0LaLVdAGUIZu672eD4oDB
         iu+Q==
X-Gm-Message-State: APjAAAVdEUVLbTK0W7StsMEL2gAH3MbnH+5p+e6OJgw7J02HylHCwsJ3
        YgX8U3fekcPQEywhNbuQyLfE+rOOVwsOqPe7FVZ8IFVuGm2MiyX2hyJ09fImr+2l899kzgnt5GP
        D/ZJpy7gX5kdY
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr23997735wrn.292.1580905841363;
        Wed, 05 Feb 2020 04:30:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6a7nZphH4CpZdYImL27XES4Yf2yGaYtSWHx6fRouFNr/X6nSst7FOsMjeu0DoqFuZVNRk3A==
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr23997707wrn.292.1580905841119;
        Wed, 05 Feb 2020 04:30:41 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm34227251wrq.21.2020.02.05.04.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:30:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 3/3] x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for nested guests
Date:   Wed,  5 Feb 2020 13:30:34 +0100
Message-Id: <20200205123034.630229-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205123034.630229-1-vkuznets@redhat.com>
References: <20200205123034.630229-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sane L1 hypervisors are not supposed to turn any of the unsupported VMX
controls on for its guests and nested_vmx_check_controls() checks for
that. This is, however, not the case for the controls which are supported
on the host but are missing in enlightened VMCS and when eVMCS is in use.

It would certainly be possible to add these missing checks to
nested_check_vm_execution_controls()/_vm_exit_controls()/.. but it seems
preferable to keep eVMCS-specific stuff in eVMCS and reduce the impact on
non-eVMCS guests by doing less unrelated checks. Create a separate
nested_evmcs_check_controls() for this purpose.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 53 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h  |  2 ++
 arch/x86/kvm/vmx/nested.c |  3 +++
 3 files changed, 58 insertions(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ba886fb7bc39..303813423c3e 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -7,6 +7,7 @@
 #include "evmcs.h"
 #include "vmcs.h"
 #include "vmx.h"
+#include "trace.h"
 
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
@@ -372,6 +373,58 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	*pdata = ctl_low | ((u64)ctl_high << 32);
 }
 
+int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
+{
+	int ret = 0;
+	u32 unsupp_ctl;
+
+	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
+		EVMCS1_UNSUPPORTED_PINCTRL;
+	if (unsupp_ctl) {
+		trace_kvm_nested_vmenter_failed(
+			"eVMCS: unsupported pin-based VM-execution controls",
+			unsupp_ctl);
+		ret = -EINVAL;
+	}
+
+	unsupp_ctl = vmcs12->secondary_vm_exec_control &
+		EVMCS1_UNSUPPORTED_2NDEXEC;
+	if (unsupp_ctl) {
+		trace_kvm_nested_vmenter_failed(
+			"eVMCS: unsupported secondary VM-execution controls",
+			unsupp_ctl);
+		ret = -EINVAL;
+	}
+
+	unsupp_ctl = vmcs12->vm_exit_controls &
+		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+	if (unsupp_ctl) {
+		trace_kvm_nested_vmenter_failed(
+			"eVMCS: unsupported VM-exit controls",
+			unsupp_ctl);
+		ret = -EINVAL;
+	}
+
+	unsupp_ctl = vmcs12->vm_entry_controls &
+		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+	if (unsupp_ctl) {
+		trace_kvm_nested_vmenter_failed(
+			"eVMCS: unsupported VM-entry controls",
+			unsupp_ctl);
+		ret = -EINVAL;
+	}
+
+	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
+	if (unsupp_ctl) {
+		trace_kvm_nested_vmenter_failed(
+			"eVMCS: unsupported VM-function controls",
+			unsupp_ctl);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version)
 {
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index b88d9807a796..6de47f2569c9 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -10,6 +10,7 @@
 
 #include "capabilities.h"
 #include "vmcs.h"
+#include "vmcs12.h"
 
 struct vmcs_config;
 
@@ -202,5 +203,6 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
+int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6879966b7648..b9fd508f40c5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2767,6 +2767,9 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	    nested_check_vm_entry_controls(vcpu, vmcs12))
 		return -EINVAL;
 
+	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
+		return nested_evmcs_check_controls(vmcs12);
+
 	return 0;
 }
 
-- 
2.24.1

