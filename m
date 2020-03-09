Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBB117E3FF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgCIPwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727146AbgCIPwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IxoCj7ol2ys8Yu3qOzfjb+6i+I21gSxxhn+KMdZnqEM=;
        b=QmZmHQFKJ1ZVESAa7viSeHNJPbTWsIpiKiW8ml24w3k/ENmg/0x4eWWPLdPsp2Ty7sOmse
        42vfJKzxImRPikO/foWHEZd+c/FeFS3NJPePy2BPHMdTTepN9ooSh0vzZjIw8vVnmbSjtf
        c6QKWC9Rj6ZN3MDdAnGPwcXJHx/syM0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-tOAczm0gMd6XCplR06Yk6g-1; Mon, 09 Mar 2020 11:52:29 -0400
X-MC-Unique: tOAczm0gMd6XCplR06Yk6g-1
Received: by mail-wr1-f69.google.com with SMTP id j17so723159wru.19
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IxoCj7ol2ys8Yu3qOzfjb+6i+I21gSxxhn+KMdZnqEM=;
        b=ZfINAe5NFBIGh9TZnicDEVvPSfAfGBngtCh/+BaceRpmkHPOpY+wW2RL22i1JoyYRg
         RRk6Dxyt4LLKPmlUyqSJQm54H0RQY7ntsyP34OcfYz4kvsN+dn4ILjdpP+aRalhSTPzt
         VQsnIYXl9jhFqgnhnwf2kvC1bGKbqA94CrdueaeQaCEP9Py2Evj33L5PolWhQT59luUm
         NLgZHLoJB+xeI593ZKmpzPC33uZVFGv3lRPeMv137ivEYSxEH177Eg0+dSO2xWDPcZok
         PrccmQiMKnU7skyAgrQ0Yu00c+Ux2M/2TucHTvCGD+/bptdKweWGRdii9OtwvRK5vSLW
         kSmw==
X-Gm-Message-State: ANhLgQ1PYvL62B//dS1t12eRPIpdhz7R0PNJSIOKSvasbt49o346j3L7
        27R0dzO/sMD1yuKKB/1qBzC94wdKkdTlPqFT5Eq9KtBJzDiZf9X2U7B/WIjRxHAoEZr67B8WATu
        yl8+utOsWkqag
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr8730237wrw.165.1583769147787;
        Mon, 09 Mar 2020 08:52:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuxZwBEeKd41ZuDyKtmdkY8qKyyAAQOZ1rhXMhUYIQ36IGWq3i/Z2o/GbhrwKib2vpSgoZ30Q==
X-Received: by 2002:a5d:69c7:: with SMTP id s7mr8730220wrw.165.1583769147525;
        Mon, 09 Mar 2020 08:52:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 3/6] KVM: nVMX: properly handle errors in nested_vmx_handle_enlightened_vmptrld()
Date:   Mon,  9 Mar 2020 16:52:13 +0100
Message-Id: <20200309155216.204752-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_handle_enlightened_vmptrld() fails in two cases:
- when we fail to kvm_vcpu_map() the supplied GPA
- when revision_id is incorrect.
Genuine Hyper-V raises #UD in the former case (at least with *some*
incorrect GPAs) and does VMfailInvalid() in the later. KVM doesn't do
anything so L1 just gets stuck retrying the same faulty VMLAUNCH.

nested_vmx_handle_enlightened_vmptrld() has two call sites:
nested_vmx_run() and nested_get_vmcs12_pages(). The former needs to queue
do much: the failure there happens after migration when L2 was running (and
L1 did something weird like wrote to VP assist page from a different vCPU),
just kill L1 with KVM_EXIT_INTERNAL_ERROR.

Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h  |  7 +++++++
 arch/x86/kvm/vmx/nested.c | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 6de47f2569c9..e5f7a7ebf27d 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -198,6 +198,13 @@ static inline void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf) {}
 static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
+enum nested_evmptrld_status {
+	EVMPTRLD_DISABLED,
+	EVMPTRLD_SUCCEEDED,
+	EVMPTRLD_VMFAIL,
+	EVMPTRLD_ERROR,
+};
+
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 72398e3bc92b..65df8bcbb9c8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1910,18 +1910,18 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
  * This is an equivalent of the nested hypervisor executing the vmptrld
  * instruction.
  */
-static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
-						 bool from_launch)
+enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
+	struct kvm_vcpu *vcpu, bool from_launch)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
-		return 1;
+		return EVMPTRLD_DISABLED;
 
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
-		return 1;
+		return EVMPTRLD_DISABLED;
 
 	if (unlikely(!vmx->nested.hv_evmcs ||
 		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
@@ -1932,7 +1932,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 
 		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmcs_gpa),
 				 &vmx->nested.hv_evmcs_map))
-			return 0;
+			return EVMPTRLD_ERROR;
 
 		vmx->nested.hv_evmcs = vmx->nested.hv_evmcs_map.hva;
 
@@ -1961,7 +1961,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 		if ((vmx->nested.hv_evmcs->revision_id != KVM_EVMCS_VERSION) &&
 		    (vmx->nested.hv_evmcs->revision_id != VMCS12_REVISION)) {
 			nested_release_evmcs(vcpu);
-			return 0;
+			return EVMPTRLD_VMFAIL;
 		}
 
 		vmx->nested.dirty_vmcs12 = true;
@@ -1990,7 +1990,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 		vmx->nested.hv_evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
-	return 1;
+	return EVMPTRLD_SUCCEEDED;
 }
 
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
@@ -3050,8 +3050,21 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (vmx->nested.enlightened_vmcs_enabled && !vmx->nested.hv_evmcs)
-		nested_vmx_handle_enlightened_vmptrld(vcpu, false);
+	if (vmx->nested.enlightened_vmcs_enabled && !vmx->nested.hv_evmcs) {
+		enum nested_evmptrld_status evmptrld_status =
+			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
+
+		if (evmptrld_status == EVMPTRLD_VMFAIL ||
+		    evmptrld_status == EVMPTRLD_ERROR) {
+			pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
+					     __func__);
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+			return false;
+		}
+	}
 
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		/*
@@ -3316,12 +3329,18 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	enum nvmx_vmentry_status status;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
+	enum nested_evmptrld_status evmptrld_status;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (!nested_vmx_handle_enlightened_vmptrld(vcpu, launch))
+	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
+	if (evmptrld_status == EVMPTRLD_ERROR) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
+	} else if (evmptrld_status == EVMPTRLD_VMFAIL) {
+		return nested_vmx_failInvalid(vcpu);
+	}
 
 	if (!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull)
 		return nested_vmx_failInvalid(vcpu);
-- 
2.24.1

