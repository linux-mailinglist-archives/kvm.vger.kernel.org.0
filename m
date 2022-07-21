Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E509457D109
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiGUQN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiGUQNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2688E21;
        Thu, 21 Jul 2022 09:13:29 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFiHrN010834;
        Thu, 21 Jul 2022 16:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=BrZR/6+FwIeEt60RPyHBAipK0gVgNwVg80JZNVTOQPA=;
 b=ImhP9lp+fNgr4I1506YrbHzagvnRQgrlL5pN+QNt8AvQxrIKLLX3u3NoJGpgog85qA60
 KIZgtQie5qS0ckElh3mlqAzoXgfB7O5AO3iAayI0PPBDuYowjfTkHrlf7HBrznYEnAIC
 qZE90ThwYUESGni25DmxocyLkyEJ1714T/IaAouJDzfvka+JZT/NXhGnDdB0F7j5ktsJ
 zk+0fgVsg4a4PwQ5xtQrzURgfaT3gUfZpD5aKPkyfn/pyQxRheqtjZl45QNeH/VG+6wz
 uhtQ4kUbU+xYZxiGFmqGQBjEOHCgh1E3zVPg5eNm44oBrGGbVO74laqW0r1QlYK7zlez eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0v1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:23 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFrobl024219;
        Thu, 21 Jul 2022 16:13:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9pu0uyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6iX7029928;
        Thu, 21 Jul 2022 16:13:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGBTul22938104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:11:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02401A405B;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 721DEA4054;
        Thu, 21 Jul 2022 16:13:17 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:17 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Jiang Jian <jiangjian@cdjrlc.com>
Subject: [GIT PULL 22/42] KVM: s390: drop unexpected word 'and' in the comments
Date:   Thu, 21 Jul 2022 18:12:42 +0200
Message-Id: <20220721161302.156182-23-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4m6_zvBAF2rMFWkQ1byRodyYZBAvtMtl
X-Proofpoint-GUID: N87K7jmK_maersNhxdJdxptynsnTO31e
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 phishscore=0
 mlxlogscore=705 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiang Jian <jiangjian@cdjrlc.com>

there is an unexpected word 'and' in the comments that need to be dropped

file: arch/s390/kvm/interrupt.c
line: 705

* Subsystem damage are the only two and and are indicated by

changed to:

* Subsystem damage are the only two and are indicated by

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
Link: https://lore.kernel.org/lkml/20220622140720.7617-1-jiangjian@cdjrlc.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index d8e1fce78b7c..b9c944b262c7 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -704,7 +704,7 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
 	/*
 	 * We indicate floating repressible conditions along with
 	 * other pending conditions. Channel Report Pending and Channel
-	 * Subsystem damage are the only two and and are indicated by
+	 * Subsystem damage are the only two and are indicated by
 	 * bits in mcic and masked in cr14.
 	 */
 	if (test_and_clear_bit(IRQ_PEND_MCHK_REP, &fi->pending_irqs)) {
-- 
2.36.1

