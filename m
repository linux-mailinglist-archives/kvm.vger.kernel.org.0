Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFD15A0F90
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 13:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiHYLu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 07:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbiHYLuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 07:50:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885114622E
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 04:50:24 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PBNhLY022609
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KnBF96c7Rm3csqfgaFDgzBHijdgflpIZHGoxW6EU/dY=;
 b=jAtOXPSLivlBKNru7dAPkR/dvug33MxOgIZ4KQ5pqoUyIB7vyaHkqrqHvREQDcW3cFWD
 jgvASRxRE6Ks0SmU6EU0b8ZThRIjQ5RV2wQlAh+oSZIKBT422iQF/nDSpW51QQk7+z84
 /vIzSyUrDQZ2+/RPx4rjt6sG3VFpQL2XOkbWuq1QM7F4dAsm9Ipk7L3qHFQ2Y9ylvqLm
 9TBe2DH0W1XyWGStgbVy6twJ9NeaiwiH05dxVc94bpyV5EvGuBjIXXif6Frv7OsD5lRP
 yIMmPWNNElBEazbC9zUa6edrV0wZ4VGUMxBeIqZVMOca7gQ1IIYlRTZ0ZfMKcJTaIois Vw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j685y8qc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:21 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PBZnUc012543
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88vp0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:50:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PBoGIR38994218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 11:50:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F90A11C04A;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BA1411C050;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 11:50:16 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [RFC PATCH v1 1/1] KVM: s390: pv: don't allow userspace to set the clock under PV
Date:   Thu, 25 Aug 2022 13:50:15 +0200
Message-Id: <20220825115015.45545-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220825115015.45545-1-nrb@linux.ibm.com>
References: <20220825115015.45545-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ggruVdMWlrccZJFzxVez_AOcpepdcq5q
X-Proofpoint-ORIG-GUID: ggruVdMWlrccZJFzxVez_AOcpepdcq5q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=884 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..b6404cedda78 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1259,6 +1259,12 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -1273,6 +1279,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
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

