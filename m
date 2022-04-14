Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E786A5007DC
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240860AbiDNIGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240756AbiDNIFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:05:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDCC4CD6B;
        Thu, 14 Apr 2022 01:03:29 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E7VJc5025624;
        Thu, 14 Apr 2022 08:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M6axMoCaZkBhABGAXin7+UBYDAJxo/U5dkkHvsjduDM=;
 b=OZMu5oFQRGujy1Ia6WFFN4byYwrqUMijPJN8KFuDDg289AQ207/5/V/ZvuA9WZD25l19
 TjVzdI8FB9gJdXk7GaI0tMRgHblz+Z4lgQ+XpJPwQnSHRR6vbUp6MCtbCc9WhWP6kiJQ
 fRvU8CJGRmLEZydNqBuAkjL83RWCPRR8N9qHK4X5ZdukNSAnXu2H0cA7vavkP3GP8zZD
 YNu6C2UTj9MH45zT42hstAiu7mIk7WufGwa62drN3D58NdfWJZcOjgZFt8WevdRieQDv
 ZOBwl9d5hB94Nc4r6SkUhTCUMDSXH8VLOZiFcmmKZGI95QLTg8DZj7Ww4C/Gy9GvEbJR /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fef9ygh6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E7vYhU024760;
        Thu, 14 Apr 2022 08:03:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fef9ygh5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E7lvnT007276;
        Thu, 14 Apr 2022 08:03:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8pg2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:26 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E83MGC32047408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:03:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8193AE051;
        Thu, 14 Apr 2022 08:03:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C1C3AE04D;
        Thu, 14 Apr 2022 08:03:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:03:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 09/19] KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
Date:   Thu, 14 Apr 2022 10:03:00 +0200
Message-Id: <20220414080311.1084834-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CCH3CFDQyh5unPU7FHkWlKBH6W1wE-J2
X-Proofpoint-ORIG-GUID: wwTqNgWDXT_EMmlQ039Mp1TC-F7nCPRB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=938 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Future changes make it necessary to call this function from pv.c.

While we are at it, let's properly document kvm_s390_cpus_from_pv() and
kvm_s390_cpus_to_pv().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 26 +++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c7a8829e852c..ed55e2a89635 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2175,7 +2175,20 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
-static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
+/**
+ * kvm_s390_cpus_from_pv - Convert all protected vCPUs in a protected VM to
+ * non protected.
+ * @kvm the VM whose protected vCPUs are to be converted
+ * @rcp return value for the RC field of the UVC (in case of error)
+ * @rrcp return value for the RRC field of the UVC (in case of error)
+ *
+ * Does not stop in case of error, tries to convert as many
+ * CPUs as possible. In case of error, the RC and RRC of the last error are
+ * returned.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 {
 	struct kvm_vcpu *vcpu;
 	u16 rc, rrc;
@@ -2205,6 +2218,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 	return ret;
 }
 
+/**
+ * kvm_s390_cpus_to_pv - Convert all non-protected vCPUs in a protected VM
+ * to protected.
+ * @kvm the VM whose protected vCPUs are to be converted
+ * @rcp return value for the RC field of the UVC (in case of error)
+ * @rrcp return value for the RRC field of the UVC (in case of error)
+ *
+ * Tries to undo the conversion in case of error.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
 static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	unsigned long i;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 497d52a83c78..d3abedafa7a8 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -374,6 +374,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
2.34.1

