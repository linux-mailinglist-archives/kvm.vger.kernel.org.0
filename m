Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5875B1530C3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgBEMan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:30:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgBEMam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 07:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580905842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4rO/yoB3tUWP9A0Ut5u9Rz301Z7Edprg1oEfc2ROnk=;
        b=W8VcjH12xW2bxqiNLh9M9uJB+IsZlnGTaY4JEhLT+Ad2itoS5CbHLCQ2MCgo8/FvS+k/SF
        iUnuUFvTbmVPjcNHc1clZRFVd0Es42OrnwC8kjRf3XEwvln7Wih0xZhlq8MT0Odkzv3QRY
        U6IzMxQsImWPUSQm70pAYvzmLyWbdYg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-dtUUwUwZPhuJ2Tv_ka-7mQ-1; Wed, 05 Feb 2020 07:30:41 -0500
X-MC-Unique: dtUUwUwZPhuJ2Tv_ka-7mQ-1
Received: by mail-wr1-f71.google.com with SMTP id w6so1103700wrm.16
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V4rO/yoB3tUWP9A0Ut5u9Rz301Z7Edprg1oEfc2ROnk=;
        b=jN5LQ2uWGNPmSbj1q7a4Lgpp2WuajjTUc1Q1zNHhHCzoehHCP8nEXzY6dti57osCMD
         9k2p8Shh9pB1GLM+Vbn4GVn+hYPUVLxfZf6P5o9z7ejI8DWN2l4doajrLM9D1ave/BzJ
         jYdK4mv8v+EJHl+D92m9xhUNlH4U/ox4nsjBk09tnqLn5sNPoNw0F4d9kHR5GdkA6M9x
         WCR+dN+FYfRwPzv+mYe/xLiWJAUKrNCFYoM8Zs4a/1eZ3vr9QzMk4Iayex5oPs8m1Xgj
         4J7OJziI6mDtsrxHaiHkjZes6ccpPBNJawTP6tnA0LpxNjG7zEzKU4H2czlp138XRu4L
         lqBw==
X-Gm-Message-State: APjAAAVTAt2CHa92eAhHfU0HUCqJM3Gd03myAYSD38IjcnlgmOJNcOph
        AkP99rBK4df1o7EiqWlNYQkb/mgJjeJoR5UZqWBvkYCLdgI5ROo7fprwqJxU/0dz06A2s8My3fV
        +BbHXgCr0REJU
X-Received: by 2002:a5d:56ca:: with SMTP id m10mr29730382wrw.313.1580905839737;
        Wed, 05 Feb 2020 04:30:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoZ811CuIhzZ2Yjt9DCyKIdSs8VFWHUqrGe60Zg+dvF2g2RxTSF7EBPUQXMQlKKeA9TPT+tw==
X-Received: by 2002:a5d:56ca:: with SMTP id m10mr29730358wrw.313.1580905839472;
        Wed, 05 Feb 2020 04:30:39 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm34227251wrq.21.2020.02.05.04.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 04:30:38 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
Date:   Wed,  5 Feb 2020 13:30:33 +0100
Message-Id: <20200205123034.630229-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205123034.630229-1-vkuznets@redhat.com>
References: <20200205123034.630229-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
with default (matching CPU model) values and in case eVMCS is also enabled,
fails.

It would be possible to drop VMX feature filtering completely and make
this a guest's responsibility: if it decides to use eVMCS it should know
which fields are available and which are not. Hyper-V mostly complies to
this, however, there are some problematic controls:
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTR

which Hyper-V enables. As there are no corresponding fields in eVMCS, we
can't handle this properly in KVM. This is a Hyper-V issue.

Move VMX controls sanitization from nested_enable_evmcs() to vmx_get_msr(),
and do the bare minimum (controls, which are known to cause issues). This
allows userspace to keep setting controls it wants and at the same
time hides them from the guest.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 32 ++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/evmcs.h |  1 +
 arch/x86/kvm/vmx/vmx.c   | 16 ++++++++++++++--
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 89c3e0caf39f..ba886fb7bc39 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -346,6 +346,32 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
        return 0;
 }
 
+void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+{
+	u32 ctl_low = (u32)*pdata;
+	u32 ctl_high = (u32)(*pdata >> 32);
+
+	/*
+	 * Hyper-V 2016 and 2019 try using these features even when eVMCS
+	 * is enabled but there are no corresponding fields.
+	 */
+	switch (msr_index) {
+	case MSR_IA32_VMX_EXIT_CTLS:
+	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
+		ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		break;
+	case MSR_IA32_VMX_ENTRY_CTLS:
+	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
+		ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+		break;
+	}
+
+	*pdata = ctl_low | ((u64)ctl_high << 32);
+}
+
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version)
 {
@@ -356,11 +382,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	if (vmcs_version)
 		*vmcs_version = nested_get_evmcs_version(vcpu);
 
-	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
-	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-	vmx->nested.msrs.secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
-	vmx->nested.msrs.vmfunc_controls &= ~EVMCS1_UNSUPPORTED_VMFUNC;
-
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 07ebf6882a45..b88d9807a796 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -201,5 +201,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
+void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cdb4bf50ee14..e3adf230ca8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1849,8 +1849,20 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
-		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
-				       &msr_info->data);
+		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
+				    &msr_info->data))
+			return 1;
+		/*
+		 * Enlightened VMCS v1 doesn't have certain fields, but buggy
+		 * Hyper-V versions are still trying to use corresponding
+		 * features when they are exposed. Filter out the essential
+		 * minimum.
+		 */
+		if (!msr_info->host_initiated &&
+		    vmx->nested.enlightened_vmcs_enabled)
+			nested_evmcs_filter_control_msr(msr_info->index,
+							&msr_info->data);
+		break;
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-- 
2.24.1

