Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD9662924
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbjAIOzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbjAIOzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:55:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0ECE50;
        Mon,  9 Jan 2023 06:55:03 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309DtYHv025507;
        Mon, 9 Jan 2023 14:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dz3MBxgQWcjymajRU5SZ8XCXO5den3d97KfPX9mneKc=;
 b=Pd+k30NgEpANXlDSQJi26MRjzX8UX/wtx9a/ZY8jVMPwfWK/rebx8QGhRIkzDK77KGiW
 N7FIeQzGXbQVisAYyPAL2sqh4VONOQAWXc2BX+cYZdIPIgPdl8ksURYdP0ntd8CtNffZ
 9acjI/BYRL1hPy+ly20PH6uukJh5ZpcVCT6v/EExsIp3V1rD8QXVjz/kMlY/QimofepK
 xNJkJWClvGEAngyUYKJuXKL68oU7aN57qC/n25frlTd4qBqc0arrKpihRs49p/DGXbig
 fzCFc9zGe82VGYLmmjrfAtvJtCfaa2BZefGX4ixPAO4VDb/OTWFRGHzF4178+wlxyi1O 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjhtggvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:55:03 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309DTKi9005770;
        Mon, 9 Jan 2023 14:55:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjhtgguh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:55:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3098dsvM012475;
        Mon, 9 Jan 2023 14:55:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3my00fk47m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:55:00 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309EsuRX23724752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 14:54:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF9342004B;
        Mon,  9 Jan 2023 14:54:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3D020043;
        Mon,  9 Jan 2023 14:54:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 14:54:56 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Date:   Mon,  9 Jan 2023 15:54:56 +0100
Message-Id: <20230109145456.2895385-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0dbQWy9H7XsqBjKZb6ZTZYdt6mU72qVt
X-Proofpoint-GUID: PIGQ1sQM3rg2WuyihH4gTqfp3N0E5Xt3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_08,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxlogscore=730
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
code that fetches the to be compared old value several times from memory.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---

v2: make it compile

arch/s390/kvm/interrupt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1dae78deddf2..ab26aa53ee37 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -83,8 +83,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union esca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -95,8 +96,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union bsca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -126,16 +128,18 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl old = *sigp_ctrl;
+		union esca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	} else {
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl old = *sigp_ctrl;
+		union bsca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	}
-- 
2.34.1

