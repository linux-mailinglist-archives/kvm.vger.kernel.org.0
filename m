Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6ED4CAD1E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244607AbiCBSM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244462AbiCBSMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED64890CDC;
        Wed,  2 Mar 2022 10:11:55 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HO8jT020135;
        Wed, 2 Mar 2022 18:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sXGeJPQZ138O7pfZVDLvBQQyPZdncy8j85OElj4jRo8=;
 b=pfQkRgQeGm1hbyzpj8M1uG7ffvhGLmW7yTA3D24oyjUMq0oqxNGcjPiizGtAWfO4avxa
 Z1KYZle8PqqECsN24FTnc20NVeIKA2h11YaPYLQKPrmNa/DMMwcBbzBsanOWIj4ESJVR
 UfAEFnLjA0TJvpMFwAUGLqjEBzaHl4VkmbwgmVcUuiFEdOK60NaRprZrey5rrIWNVnYq
 64K0m+7RLtcOnBGhVHWQtWNy4EYb/6hyw9qa+urTBjcrKa+dboEowj1rqdLuuJ/AtXCw
 kLo8kRaxKQp/7yTB33oT15SnF21mHPc/S4+UcUdclNn4ZdJ7715g+vo5i6gDxHMaEtb9 tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejcxk0xbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:55 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222HSF2l031838;
        Wed, 2 Mar 2022 18:11:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejcxk0xb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:54 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I9925030641;
        Wed, 2 Mar 2022 18:11:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3efbu961uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBn6Y57213212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CDA45204E;
        Wed,  2 Mar 2022 18:11:49 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F25D752050;
        Wed,  2 Mar 2022 18:11:48 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 09/17] KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
Date:   Wed,  2 Mar 2022 19:11:35 +0100
Message-Id: <20220302181143.188283-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: waHwrhkQmWDK92Mr5JlFIvkOznsW_isK
X-Proofpoint-GUID: pU2TDfN3EGlt7J6BcFkmobW3crqfwLcN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=947 suspectscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
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
index 702696189505..21fcca09e9bf 100644
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
@@ -2202,6 +2215,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
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
index 098831e815e6..9276d910631b 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -365,6 +365,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
2.34.1

