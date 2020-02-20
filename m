Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54F2165BD6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBTKkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:40:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727285AbgBTKk3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAZMQJ057418;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8uc13yuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:27 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAadel060990;
        Thu, 20 Feb 2020 05:40:27 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8uc13yuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:27 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAVa7L021658;
        Thu, 20 Feb 2020 10:40:26 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 2y6897ex8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeOKe51184108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E52DA112069;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17D9112061;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v3 13/37] KVM: s390: protvirt: Handle SE notification interceptions
Date:   Thu, 20 Feb 2020 05:39:56 -0500
Message-Id: <20200220104020.5343-14-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200078
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
index 1aa2382fe363..fdc6ceff6397 100644
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
2.25.0

