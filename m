Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F901D469B
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgEOHCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:02:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgEOHCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 03:02:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F6HPZI067429;
        Fri, 15 May 2020 06:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=wDFhn5H/C9kM4VHoboipp+aYGGi/BV3LgIbQk0IRbys=;
 b=i/dC9M2Eyj0Kc4VEqSA+MwcakTKo9rslJjEguG19Ki5lGI1AI7FyucfMFx6i1wuvCfgn
 msFjrfiY0V5F6Z669ajF/dLDO7OLqBs9mr5HBjkYYuWx9zMfdLVEaLEWKeZZbF9THsAJ
 c6bfshlXDqhOZ6gscAAt9LKmO/cOw5Dp98/X71k/KSseRYgaF5iGkm9rvEib2nMUzVeC
 exuQrD+5Fa+ImN9NCr+Fp0aJhOHf95yRC0wxxKTQZxThTAXIrScHsattH6DCkuGfJueK
 D5Adr7x+8s17CMsy3lNtz1cD/iCNdBVY7vV3cBR0higWXMxjyov7I3ndl6LaiKa4SAz+ aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xwqsnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 06:18:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F68j3d108044;
        Fri, 15 May 2020 06:16:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3100yqup6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 06:16:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F6GiG1014398;
        Fri, 15 May 2020 06:16:44 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 23:16:44 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Fri, 15 May 2020 01:36:08 -0400
Message-Id: <20200515053609.3347-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150053
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
index afba830..0f394af 100644
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

