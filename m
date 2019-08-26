Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0ADF9CD3F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfHZKZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:25:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbfHZKZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:25:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QANsVU180791;
        Mon, 26 Aug 2019 10:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=QacjCGL6C1qC10u0aV5BZ75pYAYcRFcZumghMlWYfdY=;
 b=NSDLMJvYubivHUiEN6wp9/+t4J0WntlaxsfHI9Ne4oI2LYK27tWmKyVRSAY89n5UzxdH
 w9J+MgKpSfMgkBQBXHgLqVf3KSrZM1ClJeHGGxUwGc1zgsJTw0Jd5jsx8E8MsR3ieEjM
 SeAKFfhT7XIvOGkq1av7Fk6ir/ARHkxFgg2I2mUAMmXod09yrYQwm/qCE4o2Q+tHJe6w
 yiFcgDpgd0X1lRYqz36EFXWYkwW6wrpKnT0eYxmyFDe9R5u4uGEKtddcXTliUM1OqqjT
 LtRmJVwQkXjcr8HHfSgoBhfR9BECIF6jjsJPzU4A8tOV6EGOkb7367l36mOBQ8VmQxFl yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ujw700533-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QANwJ1135502;
        Mon, 26 Aug 2019 10:25:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ujw6c59bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QAPNOi001693;
        Mon, 26 Aug 2019 10:25:23 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 10:25:22 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU states
Date:   Mon, 26 Aug 2019 13:24:49 +0300
Message-Id: <20190826102449.142687-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826102449.142687-1-liran.alon@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=941
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit cd7764fe9f73 ("KVM: x86: latch INITs while in system management mode")
changed code to latch INIT while vCPU is in SMM and process latched INIT
when leaving SMM. It left a subtle remark in commit message that similar
treatment should also be done while vCPU is in VMX non-root-mode.

However, INIT signals should actually be latched in various vCPU states:
(*) For both Intel and AMD, INIT signals should be latched while vCPU
is in SMM.
(*) For Intel, INIT should also be latched while vCPU is in VMX
operation and later processed when vCPU leaves VMX operation by
executing VMXOFF.
(*) For AMD, INIT should also be latched while vCPU runs with GIF=0
or in guest-mode with intercept defined on INIT signal.

To fix this:
1) Add kvm_x86_ops->apic_init_signal_blocked() such that each CPU vendor
can define the various CPU states in which INIT signals should be
blocked and modify kvm_apic_accept_events() to use it.
2) Modify vmx_check_nested_events() to check for pending INIT signal
while vCPU in guest-mode. If so, emualte vmexit on
EXIT_REASON_INIT_SIGNAL. Note that nSVM should have similar behaviour
but is currently left as a TODO comment to implement in the future
because nSVM don't yet implement svm_check_nested_events().

Note: Currently KVM nVMX implementation don't support VMX wait-for-SIPI
activity state as specified in MSR_IA32_VMX_MISC bits 6:8 exposed to
guest (See nested_vmx_setup_ctls_msrs()).
If and when support for this activity state will be implemented,
kvm_check_nested_events() would need to avoid emulating vmexit on
INIT signal in case activity-state is wait-for-SIPI. In addition,
kvm_apic_accept_events() would need to be modified to avoid discarding
SIPI in case VMX activity-state is wait-for-SIPI but instead delay
SIPI processing to vmx_check_nested_events() that would clear
pending APIC events and emulate vmexit on SIPI.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/lapic.c            | 11 +++++++----
 arch/x86/kvm/svm.c              | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c       | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 5 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74e88e5edd9c..158483538181 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1209,6 +1209,8 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 685d17c11461..9620fe5ce8d1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2702,11 +2702,14 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		return;
 
 	/*
-	 * INITs are latched while in SMM.  Because an SMM CPU cannot
-	 * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
-	 * and delay processing of INIT until the next RSM.
+	 * INITs are latched while CPU is in specific states.
+	 * Because a CPU cannot be in these states immediately
+	 * after it have processed an INIT signal (and thus in
+	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
+	 * and delay processing of INIT until CPU leaves
+	 * the state which latch INIT signal.
 	 */
-	if (is_smm(vcpu)) {
+	if (kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6462c386015d..0e43acf7bea4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7205,6 +7205,24 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * TODO: Last condition latch INIT signals on vCPU when
+	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
+	 * To properly emulate INIT intercept, SVM should also implement
+	 * kvm_x86_ops->check_nested_events() and process pending INIT
+	 * signal to cause nested_svm_vmexit(). As SVM currently don't
+	 * implement check_nested_events(), this work is delayed
+	 * for future improvement.
+	 */
+	return is_smm(vcpu) ||
+		   !gif_set(svm) ||
+		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7341,6 +7359,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = nested_get_evmcs_version,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+
+	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..d655fcd04c01 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3401,6 +3401,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (lapic_in_kernel(vcpu) &&
+		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+		return 0;
+	}
 
 	if (vcpu->arch.exception.pending &&
 		nested_vmx_check_exception(vcpu, &exit_qual)) {
@@ -4466,7 +4475,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
 {
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
+
 	free_nested(vcpu);
+
+	/* Process a latched INIT during time CPU was in VMX operation */
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return nested_vmx_succeed(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b5b5b2e5dac5..5a1aa0640f2a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7479,6 +7479,11 @@ static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	return is_smm(vcpu) || to_vmx(vcpu)->nested.vmxon;
+}
+
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
@@ -7803,6 +7808,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
 
 static void vmx_cleanup_l1d_flush(void)
-- 
2.20.1

