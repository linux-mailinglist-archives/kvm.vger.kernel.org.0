Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040631CBC13
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgEIBR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 21:17:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgEIBR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 21:17:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0491EfCF032719;
        Sat, 9 May 2020 01:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=i5N4FIkJAtEDW2ZDByeH4fD9t2GoSacDyG3juSuo1GY=;
 b=YvSiqNvSDXdaoPYz3msGaKZRN62nsoIRbPbkhENOckOgeHneHxEWC28lh2I3Vg0wyCsM
 D8zSGnSrg2JihDAnkaDp/rhacc6KmyjeKmheq1/TCacVUeIzhZPFRVXTZwNW9OM5Y3Vn
 KOAYXVIDnAN3wh/JVHal/5fo2dw4S9HW0+5cq5MoPtqTGqYMSAKlxmSbVnjBaQSJuaqp
 IgspO07UGODpLsC/sh/QaOmIklEkIEVgNL9xkoQjIT3Y6q9DCNkc21dFDmYzQufV1eU+
 qET6a4u9xsDgX93KzmAgZuKwW6j6wRqiNFtUEeaqRwttY2DpXnNi4X8ehvDd4oehiJck tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30vtexwwb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04917rsD093294;
        Sat, 9 May 2020 01:17:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30whmqtp7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0491HN8v025485;
        Sat, 9 May 2020 01:17:23 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 18:17:22 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3 v2] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Fri,  8 May 2020 20:36:51 -0400
Message-Id: <20200509003652.25178-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
References: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=1 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state is illegal:

    "Any MBZ bit of CR3 is set."
    "Any MBZ bit of CR4 is set."

Suggeted-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 22 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h    |  5 ++++-
 arch/x86/kvm/x86.c        |  3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1ca9..9824de9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -202,11 +202,29 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vmcb *vmcb)
+extern int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+
+static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
+	if (!is_long_mode(&(svm->vcpu))) {
+		if (vmcb->save.cr4 & X86_CR4_PAE) {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+				return false;
+		} else {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+				return false;
+		}
+	} else {
+		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
+		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+			return false;
+	}
+	if (kvm_valid_cr4(&(svm->vcpu), vmcb->save.cr4))
+		return false;
+
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -355,7 +373,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_vmcb = map.hva;
 
-	if (!nested_vmcb_checks(nested_vmcb)) {
+	if (!nested_vmcb_checks(svm, nested_vmcb)) {
 		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
 		nested_vmcb->control.exit_code_hi = 0;
 		nested_vmcb->control.exit_info_1  = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index df3474f..83b480f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -354,7 +354,10 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_INVALID			0xffffffffU
+#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
+#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
+#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6030d65..236301b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -919,7 +919,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 	return reserved_bits;
 }
 
-static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
@@ -929,6 +929,7 @@ static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_valid_cr4);
 
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-- 
1.8.3.1

