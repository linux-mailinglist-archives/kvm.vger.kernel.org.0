Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344406EF4B7
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbjDZMwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbjDZMwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:52:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D24C5;
        Wed, 26 Apr 2023 05:52:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCplB0010584;
        Wed, 26 Apr 2023 12:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=jFpX19GO6htuI9teldvOplQ17cjFer+usT7pN5p+oeo=;
 b=OJxLjKS5pZmcoRaiPlWQrdTKh27l+g4vTTda5s8QIzTvfa7JzFGBLucuC8eP+4mohNHH
 qCQXKr2UOeUtBCkx5S7j8X539/krSP0hySbJpIoZInV1aOOkTPwhhIn7HhNVAe9LoEL/
 P/0silOMCEpEmGAufUGn2QfUa95i0Jyx9Mo2ff8K45+HBvH0Le1cvutKwmbdNz57t4AP
 3t+a9gVSM9mn7FC0WwTGVkulC+bDw8ELUuLcpQFuGv1rn4i3fP4I8AgGa2gFme0Nxhn2
 Qd5hzgR+KuofdVNa+jFEFYMmhfYdgpgAFBBK5DQxzjOd4XSETF7cUfa+JZN1GjPUVPky Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73xw0q84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:35 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QCqZJt017094;
        Wed, 26 Apr 2023 12:52:35 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73xw0q6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:35 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCTKKq029585;
        Wed, 26 Apr 2023 12:52:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3q46ug1xr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QCqTfn42730128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 12:52:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C413A2004E;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2369020040;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.39.26])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [GIT PULL 1/3] KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
Date:   Wed, 26 Apr 2023 14:51:17 +0200
Message-Id: <20230426125119.11472-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230426125119.11472-1-frankja@linux.ibm.com>
References: <20230426125119.11472-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TmdwD-at0YkFlBDo08-wUy7WTVgW5oak
X-Proofpoint-ORIG-GUID: 2qSA-SBf0YYd2X6LI_SB0DOIdijX7_8l
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

We sometimes put a virtual address in next_alert, which should always be
a physical address, since it is shared with hardware.

This currently works, because virtual and physical addresses are
the same.

Add phys_to_virt() to resolve the virtual-physical confusion.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230223162236.51569-1-nrb@linux.ibm.com
Message-Id: <20230223162236.51569-1-nrb@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9250fde1f97d..da6dac36e959 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
 
 static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
 {
-	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
+	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
 }
 
 static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
@@ -3168,7 +3168,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	gi->timer.function = gisa_vcpu_kicker;
 	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
-	gi->origin->next_alert = (u32)(u64)gi->origin;
+	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
 	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
 }
 
-- 
2.40.0

