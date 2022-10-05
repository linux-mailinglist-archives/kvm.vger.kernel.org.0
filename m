Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9299D5F5854
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJEQdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 12:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJEQdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 12:33:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E7E7CB7B
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 09:33:05 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295GVcOP000715
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 16:33:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=U3z7DAWu1isz1n8p4y/vVf/RgvahKopSbORbEpJBYTo=;
 b=OrhWM4ZAly0NbgNSFS0AEPygTS77eM0y450quYPHEaGYRLwuPwTs3C/7v0nVVUJYgy6c
 nDoHjIi/mZGVJdbqNHMaBOtcDLn3NryNoBwbP2uzzpB9BF6MOsBwWy7nS2qgYvlHj0s8
 1N8PMc2LUFAeSZhdzFWLv3dhsKaAAQl7MdyxAv/u1lC5xvFNCr4P0Zpp2lL1vcmwH4nT
 gXYLkZfLj3ItvrTJM3HnhTcS9mBiM3TP60QIOUfJEwWtON1PGM1KkBzYIVVrj2EJHZFe
 2D3cg+aS2ErJ/6hngpdSLifYufdcLTxCYNEK62z8VHKT9AEM4R8O3t17Rgrr49qyo1RN 6A== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1dh4g1ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:33:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295GMKKR018902
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 16:33:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3jxd695t99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:33:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295GWxDC32112980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 16:32:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 316E0AE051;
        Wed,  5 Oct 2022 16:32:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F121CAE045;
        Wed,  5 Oct 2022 16:32:58 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 16:32:58 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH v3 1/2] KVM: s390: pv: don't allow userspace to set the clock under PV
Date:   Wed,  5 Oct 2022 18:32:57 +0200
Message-Id: <20221005163258.117232-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221005163258.117232-1-nrb@linux.ibm.com>
References: <20221005163258.117232-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jWkXO0nFejk8U30y7PeLvQBiv7w3BTc_
X-Proofpoint-ORIG-GUID: jWkXO0nFejk8U30y7PeLvQBiv7w3BTc_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running under PV, the guest's TOD clock is under control of the
ultravisor and the hypervisor isn't allowed to change it. Hence, don't
allow userspace to change the guest's TOD clock by returning
-EOPNOTSUPP.

When userspace changes the guest's TOD clock, KVM updates its
kvm.arch.epoch field and, in addition, the epoch field in all state
descriptions of all VCPUs.

But, under PV, the ultravisor will ignore the epoch field in the state
description and simply overwrite it on next SIE exit with the actual
guest epoch. This leads to KVM having an incorrect view of the guest's
TOD clock: it has updated its internal kvm.arch.epoch field, but the
ultravisor ignores the field in the state description.

Whenever a guest is now waiting for a clock comparator, KVM will
incorrectly calculate the time when the guest should wake up, possibly
causing the guest to sleep for much longer than expected.

With this change, kvm_s390_set_tod() will now take the kvm->lock to be
able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.

Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b7ef0b71014d..0a8019b14c8f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
 	return 0;
 }
 
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+
 static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_tod_clock gtod;
@@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
 		return -EINVAL;
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 
 	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
 		gtod.epoch_idx, gtod.tod);
@@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
 			   sizeof(gtod.tod)))
 		return -EFAULT;
 
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
 	return 0;
 }
@@ -1259,6 +1261,12 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (attr->flags)
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+	if (kvm_s390_pv_is_protected(kvm)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	switch (attr->attr) {
 	case KVM_S390_VM_TOD_EXT:
 		ret = kvm_s390_set_tod_ext(kvm, attr);
@@ -1273,6 +1281,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -ENXIO;
 		break;
 	}
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
-- 
2.36.1

