Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF42C2B34
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfJAAM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:12:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731960AbfJAAM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:12:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910CT0s016212;
        Tue, 1 Oct 2019 00:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=40miRSJQoffUSoB/95pu3r0SaiCbXdGnY4sDNqNWxT8=;
 b=CbkHu8Fk3jaxa310Qi3d52g0GrCQcbebD0jr2ShDj47XTLpbZ1fVJYY9D932WcDi1Gft
 T0907kEGvzp4TTrgugEIj3ArkGPaPYwdcnqwbWtr1RPM+YFrZzvT/3/OlovnhVsphVps
 YF8AhbUMPw3bDYSWZxlxvVgERQouToPNCOdif1YfWWTejOewFOOSmv3FT+UU4mpfh/Zh
 wuC9dxl8a3WfMDysDlpN1H+xST0Wmvr/nhK6oWN4zavLqkHgSB3dtSb0v2bio/42G82o
 x9/Q18U+sW5e8p/d+FFaEl8vhAgODtK3Ro3d7vSRTAufxGomWj1OiXDlY8TSBlUm39HX FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxujgcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:12:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9109tWa126915;
        Tue, 1 Oct 2019 00:12:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vbmpx9xaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:12:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x910CNM6025087;
        Tue, 1 Oct 2019 00:12:23 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 17:12:22 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH] nVMX: Defer error from VM-entry MSR-load area to until after hardware verifies VMCS guest state-area
Date:   Mon, 30 Sep 2019 19:36:26 -0400
Message-Id: <20190930233626.22852-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=979
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section “VM Entries” in Intel SDM vol 3C, VM-entry checks are
performed in a certain order. Checks on MSRs that are loaded on VM-entry
from VM-entry MSR-load area, should be done after verifying VMCS controls,
host-state area and guest-state area. As KVM relies on CPU hardware to
perform some of these checks, we need to defer VM-exit due to invalid
VM-entry MSR-load area to until after CPU hardware completes the earlier
checks and is ready to do VMLAUNCH/VMRESUME.

In order to defer errors arising from invalid VM-entry MSR-load area in
vmcs12, we set up a single invalid entry, which is illegal according to
section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area of
vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry failure
due to MSR loading" after it completes checks on VMCS controls, host-state
area and guest-state area. We reflect a synthesized Exit Qualification to
our guest.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
 arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..b74491c04090 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
-		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
 		exit_qual = nested_vmx_load_msr(vcpu,
 						vmcs12->vm_entry_msr_load_addr,
 						vmcs12->vm_entry_msr_load_count);
-		if (exit_qual)
-			goto vmentry_fail_vmexit_guest_mode;
+		if (exit_qual) {
+			/*
+			 * According to section “VM Entries” in Intel SDM
+			 * vol 3C, VM-entry checks are performed in a certain
+			 * order. Checks on MSRs that are loaded on VM-entry
+			 * from VM-entry MSR-load area, should be done after
+			 * verifying VMCS controls, host-state area and
+			 * guest-state area. As KVM relies on CPU hardware to
+			 * perform some of these checks, we need to defer
+			 * VM-exit due to invalid VM-entry MSR-load area to
+			 * until after CPU hardware completes the earlier
+			 * checks and is ready to do VMLAUNCH/VMRESUME.
+			 *
+			 * In order to defer errors arising from invalid
+			 * VM-entry MSR-load area in vmcs12, we set up a
+			 * single invalid entry, which is illegal according
+			 * to section "Loading MSRs in Intel SDM vol 3C, in
+			 * VM-entry MSR-load area of vmcs02. This will cause
+			 * the CPU hardware to VM-exit with "VM-entry
+			 * failure due to MSR loading" after it completes
+			 * checks on VMCS controls, host-state area and
+			 * guest-state area.
+			 */
+			vmx->loaded_vmcs->invalid_msr_load_area.index =
+			    MSR_FS_BASE;
+			vmx->loaded_vmcs->invalid_msr_load_area.value =
+			    exit_qual;
+			vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
+			vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
+			    __pa(&(vmx->loaded_vmcs->invalid_msr_load_area)));
+		}
 	} else {
 		/*
 		 * The MMU is not initialized to point at the right entities yet and
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..f3a384235b68 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 					    u32 exit_reason)
 {
+	u32 exit_qual;
 	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
 	 * At this point, the exit interruption info in exit_intr_info
@@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
 
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
-			  vmcs_readl(EXIT_QUALIFICATION));
+	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
+
+	if (vmx->loaded_vmcs->invalid_msr_load_area.index == MSR_FS_BASE &&
+	    (exit_reason == (VMX_EXIT_REASONS_FAILED_VMENTRY |
+			    EXIT_REASON_MSR_LOAD_FAIL))) {
+		exit_qual = vmx->loaded_vmcs->invalid_msr_load_area.value;
+	}
+
+	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 481ad879197b..e272788bd4b8 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -70,6 +70,12 @@ struct loaded_vmcs {
 	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs_host_state host_state;
 	struct vmcs_controls_shadow controls_shadow;
+	/*
+	 * This field is used to set up an invalid VM-entry MSR-load area
+	 * for vmcs02 if an error is detected while processing the entries
+	 * in VM-entry MSR-load area of vmcs12.
+	 */
+	struct vmx_msr_entry invalid_msr_load_area;
 };
 
 static inline bool is_exception_n(u32 intr_info, u8 vector)
-- 
2.20.1

