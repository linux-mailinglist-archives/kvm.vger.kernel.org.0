Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6D6A0DCD
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 17:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbjBWQWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 11:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbjBWQWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 11:22:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF1117CFC;
        Thu, 23 Feb 2023 08:22:44 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NG0PpQ018502;
        Thu, 23 Feb 2023 16:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=i2EuYrmKAcZOK6gHWGbraQGKswiqhfiip50aZ1tl3DA=;
 b=Rz0hsGr85EmiZlKTIlFBs9eKNgUkykzwAHKsW2HNnb9Vu6PPeLJsvYq/myIyKR/nI/63
 ltLNvXZXvkU93sFd74PYt6XfYwEou8q01sMPPHm5sd2/WCEEJ2vojzAQ8k+Mjknyu+Ro
 y+HpRBChBDt4Gq0GztAwpaklV1kfUoT+49q+FBCTl8vw2TbeSzuS99UIX8DUmYQch4tE
 dfQBUieK/kzQYGbKRDh3BirJ5MBmP8fxN5uhxIIoLVzh29DMY6CV75bY7F362YkoG0qE
 LcUBCOTgYgG/+tjvC2nzaMCARgEslfWu2Cls4UivW5DKMWiUdUU4W1YrFUmUOgI6LS3V mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxarsshe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 16:22:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31NG0Wh9019682;
        Thu, 23 Feb 2023 16:22:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxarsshd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 16:22:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31N7tx4N001654;
        Thu, 23 Feb 2023 16:22:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ntpa657ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 16:22:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31NGMbDm27853492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 16:22:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E25D52004B;
        Thu, 23 Feb 2023 16:22:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C01A20040;
        Thu, 23 Feb 2023 16:22:36 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 16:22:36 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mimu@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1] KVM: s390: interrupt: fix virtual-physical confusion for next alert GISA
Date:   Thu, 23 Feb 2023 17:22:36 +0100
Message-Id: <20230223162236.51569-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YbRJv3Wrw5tK2xVIuROTfbx9ooDsOKnb
X-Proofpoint-ORIG-GUID: e2naCEkQNk_TANA01sxbocW1uDhxxquq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_10,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sometimes put a virtual address in next_alert, which should always be
a physical address, since it is shared with hardware.

This currently works, because virtual and physical addresses are
the same.

Add phys_to_virt() to resolve the virtual-physical confusion.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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

