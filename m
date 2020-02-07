Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD341556FC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBGLkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727032AbgBGLkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:07 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017Bb6mr143566;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0ktsc5vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:05 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Bb9wm143985;
        Fri, 7 Feb 2020 06:40:05 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0ktsc5u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:05 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017BckBl029241;
        Fri, 7 Feb 2020 11:40:03 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 2xykc9vtw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:03 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be1r848169278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B85D9AC060;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38AFAC05E;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 13/35] KVM: s390: protvirt: Instruction emulation
Date:   Fri,  7 Feb 2020 06:39:36 -0500
Message-Id: <20200207113958.7320-14-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We have two new SIE exit codes dealing with instructions.
104 (0x68) for a secure instruction interception, on which the SIE needs
hypervisor action to complete the instruction. We can piggy-back on the
existing instruction handlers.

108 which is merely a notification and provides data for tracking and
management. For example this is used to tell the host about a new value
for the prefix register. As there will be several special case handlers
in later patches, we handle this in a separate function.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/intercept.c        | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 08acf280c4b0..ae7c611ee9dd 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -217,6 +217,8 @@ struct kvm_s390_sie_block {
 #define ICPT_KSS	0x5c
 #define ICPT_MCHKREQ	0x60
 #define ICPT_INT_ENABLE	0x64
+#define ICPT_PV_INSTR	0x68
+#define ICPT_PV_NOTIFY	0x6c
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 6aeb4b36042c..6fdbac696f65 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -444,6 +444,11 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 }
 
+static int handle_pv_notification(struct kvm_vcpu *vcpu)
+{
+	return handle_instruction(vcpu);
+}
+
 int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 {
 	int rc, per_rc = 0;
@@ -489,6 +494,12 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		 */
 		rc = 0;
 		break;
+	case ICPT_PV_INSTR:
+		rc = handle_instruction(vcpu);
+		break;
+	case ICPT_PV_NOTIFY:
+		rc = handle_pv_notification(vcpu);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.24.0

