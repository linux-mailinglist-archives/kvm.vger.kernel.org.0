Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848CD4EC52E
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbiC3NHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241644AbiC3NHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:07:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841B33377;
        Wed, 30 Mar 2022 06:05:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UAgOrR002849;
        Wed, 30 Mar 2022 12:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L+8PjHPMiq4AQHcRLajykYL0EPB3iNidhaOlepmKopc=;
 b=BQWNggh4+gtZOSc7uEwkRc+zcMnlquUnj26yjZWGLe4rVOEPFjwmWjuRA3NamGqDOYyl
 qqiQO8gbJeYI0ku5mO8AAEVzlI9o01Nh73P5lG/Imtz21ipd1uccO7jJXcRODVsnzTrH
 eE5TnuLrfiKOVJ8W3BSA5GciuN+mvw1NC4tVv5al8n4KWTi+0brTU5G3ZURKF6SBqsHZ
 OWqjn9FjB96BN6GSr5pVUFwURX/aw1TFkunktWHwfr9ENWtk6AUur/vT01skAEtflWWu
 OChVZDRzssFkmOozQkJEkZJ2EvBklPPGfqp7n7CZAFLTjI8oBe+pt+AZ1r0hJ2Vag760 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4npk271p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:21 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UC3K91027162;
        Wed, 30 Mar 2022 12:26:21 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4npk2715-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UCMPvE030948;
        Wed, 30 Mar 2022 12:26:19 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf90j51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCQGce27525418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:26:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B46B11C04C;
        Wed, 30 Mar 2022 12:26:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79EDA11C052;
        Wed, 30 Mar 2022 12:26:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:26:15 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 08/18] KVM: s390: pv: clear the state without memset
Date:   Wed, 30 Mar 2022 14:25:55 +0200
Message-Id: <20220330122605.247613-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330122605.247613-1-imbrenda@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j4BEhIoMFo_4n2ZRYsQLY9UeQ6MlhDXy
X-Proofpoint-ORIG-GUID: f9QepjJlO4UhlECqNgkl_yVKBY7Oam4E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 impostorscore=0 mlxlogscore=879 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not use memset to clean the whole struct kvm_s390_pv; instead,
explicitly clear the fields that need to be cleared.

Upcoming patches will introduce new fields in the struct kvm_s390_pv
that will not need to be cleared.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 9e900ce7387d..76ef33a277d3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,6 +16,14 @@
 #include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
+static void kvm_s390_clear_pv_state(struct kvm *kvm)
+{
+	kvm->arch.pv.handle = 0;
+	kvm->arch.pv.guest_len = 0;
+	kvm->arch.pv.stor_base = 0;
+	kvm->arch.pv.stor_var = NULL;
+}
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc;
@@ -110,7 +118,7 @@ static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
 	vfree(kvm->arch.pv.stor_var);
 	free_pages(kvm->arch.pv.stor_base,
 		   get_order(uv_info.guest_base_stor_len));
-	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+	kvm_s390_clear_pv_state(kvm);
 }
 
 static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
-- 
2.34.1

