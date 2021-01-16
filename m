Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CB32F8AB6
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 03:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbhAPCXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 21:23:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49876 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbhAPCXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 21:23:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G24taN125791;
        Sat, 16 Jan 2021 02:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=GiA7Wx2KS5t1Hb9isnMosVuN4QXjqyqUQrz7pk10Szc=;
 b=r3MccLJyUQGpl8CzidwLbMJoRNEUpPNmx8eqjgGfsYCw5QUJyhCOmU1ruRwkYZ3moTnr
 SQXmhMP0BVRSKb5lvS6MRqssU++LSiQ1CbkjSUutnKxyo4xvzIZFD8PEciljzK2nrHf1
 PgFrnNsPz9BQ4UwoKOWVsnGEgxNnPXd1DITKEUe5ZH/7Av6hOmSXdclIsG2+8WHsHOcU
 IqjMU82FPBrXpJqDvUa5lQ1mkgvY9WXab8dFhVsDDDGsHeysaQDVDFT2L7m8oTtO7zq3
 rhAjQPdaC4GbrJ+11dAOCIe2htpamPIpyq4K21f9YbKXaCifkj9UZBuMprC113dV3s6W 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 363nna83jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:22:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G26M3w194851;
        Sat, 16 Jan 2021 02:20:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 360kebux94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 02:20:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10G2KoZO019555;
        Sat, 16 Jan 2021 02:20:50 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 18:20:50 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/3 v2] nSVM: Check addresses of MSR and IO bitmap
Date:   Sat, 16 Jan 2021 02:20:37 +0000
Message-Id: <20210116022039.7316-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
References: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

        "The MSR or IOIO intercept tables extend to a physical address that
         is greater than or equal to the maximum supported physical address."

Also check that these addresses are aligned on page boundary.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cb4c6ee10029..2419f392a13d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -211,7 +211,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_control_area *control)
 {
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
@@ -223,10 +224,15 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	if (!page_address_valid(vcpu, control->msrpm_base_pa))
+		return false;
+	if (!page_address_valid(vcpu, control->iopm_base_pa))
+		return false;
+
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
 {
 	bool vmcb12_lma;
 
@@ -255,10 +261,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
 			return false;
 	}
-	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb12->control);
+	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -485,7 +491,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(svm, vmcb12)) {
+	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -1173,7 +1179,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(vcpu, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0

