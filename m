Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41A86A1D41
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBXOJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjBXOJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:09:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D10C64F;
        Fri, 24 Feb 2023 06:09:16 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OD6Zco017977;
        Fri, 24 Feb 2023 14:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0LMQ8iO7QdteryPNQBN7SfvQEGfkrn4/g7UdokzeLGk=;
 b=p0yjD9k2ZcVE96d6dEm+Z6XOMGWbyNYutJ7FtGkFksemjMlzakQ3FyNtDYRPKe/r9NVJ
 +0UTJIv5DIr/8ki7idWTOnfexAwX6F+AJTuybguF26glfG75R/0hbMQYqQ33AM9IIDP/
 34MpJjxUrF7OHUmryKtXQYKJcnzA/IbDMaJcsF1OKtKj+/zO0OPksqz3B6SP0yvuo9vC
 DXlEIbf1aDNYv+g09LTl8DfJNFaQmFZgV8mzcQmGOxl4x2m0BW+lD46ypF70YzfUVcBp
 08EGbF3ibK7n9WgDxWStSf4Cnw3fwBf/YsvKaW9L1WuqsfsQJyRWzgRLSYEmE9k63I90 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxuq7vprq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:16 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31OCEO4c005644;
        Fri, 24 Feb 2023 14:09:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxuq7vpqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31O5j5hs019852;
        Fri, 24 Feb 2023 14:09:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6624h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 14:09:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31OE99lw43974924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 14:09:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9381A2004D;
        Fri, 24 Feb 2023 14:09:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E81E20049;
        Fri, 24 Feb 2023 14:09:09 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 14:09:09 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mimu@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 1/1] KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
Date:   Fri, 24 Feb 2023 15:09:08 +0100
Message-Id: <20230224140908.75208-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224140908.75208-1-nrb@linux.ibm.com>
References: <20230224140908.75208-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hpQfWKuZK4oldcHOML0_Hq4crcGWWN5T
X-Proofpoint-ORIG-GUID: fhK5l8ERwvOW3AwWQgK9PmkMHsExOuBw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_08,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gisa next alert address is defined as a host absolute address so
let's use virt_to_phys() to make sure we always write an absolute
address to this hardware structure.

This is not a bug and currently works, because virtual and physical
addresses are the same.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab26aa53ee37..20743c5b000a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
 
 static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
 {
-	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
+	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
 }
 
 static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
@@ -3167,7 +3167,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	gi->timer.function = gisa_vcpu_kicker;
 	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
-	gi->origin->next_alert = (u32)(u64)gi->origin;
+	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
 	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
 }
 
-- 
2.39.1

