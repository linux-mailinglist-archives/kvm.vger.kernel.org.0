Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A122FE58
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgG1ALR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 20:11:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgG1ALQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 20:11:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S07dWi098897;
        Tue, 28 Jul 2020 00:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vXnj/gnqmHKObJdeOI0HW17ejiMSjp3dJmhAljiBIXo=;
 b=FCpMV570cbd+0qevU4Lup/EdxyBrxCdX91FMZf7h0MyjZzgEg0MbidehQALQGTZscbEZ
 Ka1afBr6vekJA/As/W0akfWe8PbVtjYptgm+aEyrO9T3leyOHRr6IAhhjRgVtLL/BDwR
 1Xc7XRMSU6tliuwXtedSO2ds2qxv4zcW1++ZQXQW3iIMrA4fCK2zVXAYuyRcy924P542
 HB4t6jxIbPSPJKtyI/7uQi/Vir5yJx8zNnuVPWJ1cXFw1EVF0NG8oRpg7GWFfVq/SB0+
 530QfBeI7uvRL1NcgK0qUmaw614LGqNg4toJq70KI94pcTZsjj4VK+WTVs2hhPF/L59A Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1jcgnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 00:11:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S08RQq040890;
        Tue, 28 Jul 2020 00:11:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32hu5s4mnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 00:11:03 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06S0B1u4020224;
        Tue, 28 Jul 2020 00:11:01 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 17:11:01 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 5/6 v3] KVM: nVMX: Fill in conforming vmx_nested_ops via macro
Date:   Tue, 28 Jul 2020 00:10:49 +0000
Message-Id: <1595895050-105504-6-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=826 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=835
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=3 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of some of the vmx_nested_ops functions do not have a corresponding
'nested_vmx_' prefix. Generate the names using a macro so that the names are
conformant. Fixing the naming will help in better readability and
maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 24 +++++++++++++-----------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a898b53..fc09bb0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3105,7 +3105,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static bool nested_vmx_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3295,7 +3295,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+		if (unlikely(!nested_vmx_get_vmcs12_pages(vcpu)))
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
@@ -3711,7 +3711,7 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
+static int nested_vmx_check_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qual;
@@ -5907,7 +5907,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
+static int nested_vmx_get_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
@@ -6031,7 +6031,7 @@ void vmx_leave_nested(struct kvm_vcpu *vcpu)
 	free_nested(vcpu);
 }
 
-static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
+static int nested_vmx_set_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state)
 {
@@ -6448,7 +6448,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->vmcs_enum = VMCS12_MAX_FIELD_INDEX << 1;
 }
 
-void nested_vmx_hardware_unsetup(void)
+void nested_vmx_hardware_teardown(void)
 {
 	int i;
 
@@ -6473,7 +6473,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 			vmx_bitmap[i] = (unsigned long *)
 				__get_free_page(GFP_KERNEL);
 			if (!vmx_bitmap[i]) {
-				nested_vmx_hardware_unsetup();
+				nested_vmx_hardware_teardown();
 				return -ENOMEM;
 			}
 		}
@@ -6497,12 +6497,14 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 	return 0;
 }
 
+#define KVM_X86_NESTED_OP(name) .name = nested_vmx_##name
+
 struct kvm_x86_nested_ops vmx_nested_ops = {
-	.check_events = vmx_check_nested_events,
+	KVM_X86_NESTED_OP(check_events),
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
-	.get_state = vmx_get_nested_state,
-	.set_state = vmx_set_nested_state,
-	.get_vmcs12_pages = nested_get_vmcs12_pages,
+	KVM_X86_NESTED_OP(get_state),
+	KVM_X86_NESTED_OP(set_state),
+	KVM_X86_NESTED_OP(get_vmcs12_pages),
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
 };
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 758bccc..ac6b561 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -18,7 +18,7 @@ enum nvmx_vmentry_status {
 
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
 void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
-void nested_vmx_hardware_unsetup(void);
+void nested_vmx_hardware_teardown(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f6a6674..6512e6e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7830,7 +7830,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 static void vmx_hardware_teardown(void)
 {
 	if (nested)
-		nested_vmx_hardware_unsetup();
+		nested_vmx_hardware_teardown();
 
 	free_kvm_area();
 }
@@ -8144,7 +8144,7 @@ static __init int hardware_setup(void)
 
 	r = alloc_kvm_area();
 	if (r)
-		nested_vmx_hardware_unsetup();
+		nested_vmx_hardware_teardown();
 	return r;
 }
 
-- 
1.8.3.1

