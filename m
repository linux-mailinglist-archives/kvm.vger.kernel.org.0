Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E42356A0C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 15:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFZNKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 09:10:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZNKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 09:10:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QD8wgs027298;
        Wed, 26 Jun 2019 13:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=nA0TmGzAFDXuucTYARXoXJ3NJQovAqRDIkh37JQ+n0w=;
 b=vWwwWFdeoVzghxLO6KfwBQpZQTdOxnbPATMIX7ugv0b19usNlMLYIc4KOjqcZer11BZq
 sOk+5eQeZ7mwmTsIAousOV88CVPeb3V7fsppcM3SIT6gMWOZgqnB0+4MjiLibMvFQCq3
 GcMH1C+SVUXSrX0/UZ8QxoFun0i8HrHPs2bsnNa1653QjN7PmtuqSzHffLymJ3tKeLY+
 sbIukZEyXfif87Uz46ltG5nn8xJq1yHIWkWQK4hmyv8KFg5/lgiPAHGUjbPGBiqPWEbl
 /AxREVhvG+9fonQA5yl8dtXkB13VFMyo9hyfq5u01FVDXHDTapC5JJaU0++Jg7X8GA04 zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t9cyqj5u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 13:09:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QD9WK8176693;
        Wed, 26 Jun 2019 13:09:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t9accpgt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 13:09:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QD9tJv005741;
        Wed, 26 Jun 2019 13:09:56 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 06:09:55 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Maran Wilson <maran.wilson@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12 is copied from eVMCS
Date:   Wed, 26 Jun 2019 16:09:27 +0300
Message-Id: <20190626130927.121459-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently KVM_STATE_NESTED_EVMCS is used to signal that eVMCS
capability is enabled on vCPU.
As indicated by vmx->nested.enlightened_vmcs_enabled.

This is quite bizarre as userspace VMM should make sure to expose
same vCPU with same CPUID values in both source and destination.
In case vCPU is exposed with eVMCS support on CPUID, it is also
expected to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS capability.
Therefore, KVM_STATE_NESTED_EVMCS is redundant.

KVM_STATE_NESTED_EVMCS is currently used on restore path
(vmx_set_nested_state()) only to enable eVMCS capability in KVM
and to signal need_vmcs12_sync such that on next VMEntry to guest
nested_sync_from_vmcs12() will be called to sync vmcs12 content
into eVMCS in guest memory.
However, because restore nested-state is rare enough, we could
have just modified vmx_set_nested_state() to always signal
need_vmcs12_sync.

From all the above, it seems that we could have just removed
the usage of KVM_STATE_NESTED_EVMCS. However, in order to preserve
backwards migration compatibility, we cannot do that.
(vmx_get_nested_state() needs to signal flag when migrating from
new kernel to old kernel).

Returning KVM_STATE_NESTED_EVMCS when just vCPU have eVMCS enabled
have a bad side-effect of userspace VMM having to send nested-state
from source to destination as part of migration stream. Even if
guest have never used eVMCS as it doesn't even run a nested
hypervisor workload. This requires destination userspace VMM and
KVM to support setting nested-state. Which make it more difficult
to migrate from new host to older host.
To avoid this, change KVM_STATE_NESTED_EVMCS to signal eVMCS is
not only enabled but also active. i.e. Guest have made some
eVMCS active via an enlightened VMEntry. i.e. vmcs12 is copied
from eVMCS and therefore should be restored into eVMCS resident
in memory (by copy_vmcs12_to_enlightened()).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c                     | 25 ++++++++++++-------
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  1 +
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b66001fb0232..18efb338ed8a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5240,9 +5240,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	vmx = to_vmx(vcpu);
 	vmcs12 = get_vmcs12(vcpu);
 
-	if (nested_vmx_allowed(vcpu) && vmx->nested.enlightened_vmcs_enabled)
-		kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
-
 	if (nested_vmx_allowed(vcpu) &&
 	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
 		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
@@ -5251,6 +5248,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (vmx_has_valid_vmcs12(vcpu)) {
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
+			if (vmx->nested.hv_evmcs)
+				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
+
 			if (is_guest_mode(vcpu) &&
 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
 			    vmcs12->vmcs_link_pointer != -1ull)
@@ -5350,6 +5350,15 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
 			return -EINVAL;
 
+		/*
+		 * KVM_STATE_NESTED_EVMCS used to signal that KVM should
+		 * enable eVMCS capability on vCPU. However, since then
+		 * code was changed such that flag signals vmcs12 should
+		 * be copied into eVMCS in guest memory.
+		 *
+		 * To preserve backwards compatability, allow user
+		 * to set this flag even when there is no VMXON region.
+		 */
 		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
 			return -EINVAL;
 	} else {
@@ -5358,7 +5367,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
 			return -EINVAL;
-    	}
+	}
 
 	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
 	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
@@ -5383,13 +5392,11 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	    !(kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON))
 		return -EINVAL;
 
-	vmx_leave_nested(vcpu);
-	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
-		if (!nested_vmx_allowed(vcpu))
+	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
+		(!nested_vmx_allowed(vcpu) || !vmx->nested.enlightened_vmcs_enabled))
 			return -EINVAL;
 
-		nested_enable_evmcs(vcpu, NULL);
-	}
+	vmx_leave_nested(vcpu);
 
 	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
 		return 0;
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index b38260e29775..241919ef1eac 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -146,6 +146,7 @@ int main(int argc, char *argv[])
 		kvm_vm_restart(vm, O_RDWR);
 		vm_vcpu_add(vm, VCPU_ID, 0, 0);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+		vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
 		free(state);
-- 
2.20.1

