Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2670155701
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgBGLkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727047AbgBGLkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:07 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017Bda6Y063657;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0murhbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:05 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Be4Af065402;
        Fri, 7 Feb 2020 06:40:04 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0murhbaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:04 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017Bcl0A026906;
        Fri, 7 Feb 2020 11:40:04 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2xykca1y7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:04 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be1mI45220156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DB1AC059;
        Fri,  7 Feb 2020 11:40:01 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94D39AC05B;
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
Subject: [PATCH 12/35] KVM: s390: protvirt: Handle SE notification interceptions
Date:   Fri,  7 Feb 2020 06:39:35 -0500
Message-Id: <20200207113958.7320-13-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002070090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Since there is no interception for load control and load psw
instruction in the protected mode, we need a new way to get notified
whenever we can inject an IRQ right after the guest has just enabled
the possibility for receiving them.

The new interception codes solve that problem by providing a
notification for changes to IRQ enablement relevant bits in CRs 0, 6
and 14, as well a the machine check mask bit in the PSW.

No special handling is needed for these interception codes, the KVM
pre-run code will consult all necessary CRs and PSW bits and inject
IRQs the guest is enabled for.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 ++
 arch/s390/kvm/intercept.c        | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3ed31c5f80e1..08acf280c4b0 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -215,6 +215,8 @@ struct kvm_s390_sie_block {
 #define ICPT_PARTEXEC	0x38
 #define ICPT_IOINST	0x40
 #define ICPT_KSS	0x5c
+#define ICPT_MCHKREQ	0x60
+#define ICPT_INT_ENABLE	0x64
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a389fa85cca2..6aeb4b36042c 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -480,6 +480,15 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 	case ICPT_KSS:
 		rc = kvm_s390_skey_check_enable(vcpu);
 		break;
+	case ICPT_MCHKREQ:
+	case ICPT_INT_ENABLE:
+		/*
+		 * PSW bit 13 or a CR (0, 6, 14) changed and we might
+		 * now be able to deliver interrupts. The pre-run code
+		 * will take care of this.
+		 */
+		rc = 0;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.24.0

