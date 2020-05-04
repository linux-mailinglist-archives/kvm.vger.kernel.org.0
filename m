Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EF1C4A14
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEDXQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:16:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgEDXQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:16:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NEC65183271;
        Mon, 4 May 2020 23:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9I2vImwy/zqfi6uJ3ui1h/VbPItrShDU2Gls9M26DZs=;
 b=BN1L9YXXwnXocNYLk48ZmX7vfnwES2qxGKHgCmxQ8HarNdceQF0k6MmI+7SJpAF4zKIq
 JX9D2SGEblWPJKJ7u1a/sZALbSBu8JGmno3+jtnR2e4MMQysmnwfTIwlg9SglMGuBh8x
 ObQJ9NqBREB+uoeGK3FAgUC0Zzl+/edpsJSNXYwDeOcG6T0ev5t7vzBXcBPKaK3qtU7j
 OBuZaedtEaZ+Mo3KwTIz13rcJmwhjGxz9b6oBkk7uwll/h8xfmAUwxX6qBYqf2Htawc1
 xuxf/01uZGKrkxd3kYpNNlIdR5+q0k9JNm0hVMmcj/3cG4oefTdlgW86K3Qylh5nxyaS vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r1ugg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDLDW022915;
        Mon, 4 May 2020 23:16:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjncaw93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044NGh13031010;
        Mon, 4 May 2020 23:16:43 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:16:43 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Mon,  4 May 2020 18:35:22 -0400
Message-Id: <20200504223523.7166-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
References: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state is illegal:

    "Any MBZ bit of CR3 is set."
    "Any MBZ bit of CR4 is set."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h    |  7 ++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1ca9..1804a97 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -207,6 +207,24 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
+	if (!(vmcb->save.efer & EFER_LMA)) {
+		if (vmcb->save.cr4 & X86_CR4_PAE) {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+				return false;
+		} else {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+				return false;
+		}
+		if (vmcb->save.cr4 & MSR_CR4_LEGACY_RESERVED_MASK)
+			return false;
+	} else {
+		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
+		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+			return false;
+		if (vmcb->save.cr4 & MSR_CR4_RESERVED_MASK)
+			return false;
+	}
+
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index df3474f..796c083 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -354,7 +354,12 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_INVALID			0xffffffffU
+#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
+#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
+#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define MSR_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
+#define MSR_CR4_RESERVED_MASK			0xffffffffffbaf000U
+#define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
-- 
1.8.3.1

