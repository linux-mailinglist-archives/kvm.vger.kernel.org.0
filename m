Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E8C423D8D
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhJFMTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 08:19:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238116AbhJFMT1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 08:19:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196AcIir030471;
        Wed, 6 Oct 2021 08:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3By4abvPiRAjKaxyIKru5TmqCCzfECwE3Q0W0WzAsjk=;
 b=cYR4Gb1KuRI9zyvjh/022jEbEk0BqhGCHX95Ss5vInJ5XeMUTo5lfMEGYHPrX9gJHePe
 32WPsMb5yIWfvBS8W22syOxFLLRoa7Y1ZcCEjRpOmzL6Ga6Em8Gi2FPL8iJybTqHjsWC
 GJB9TycA6R0rC4ScJmskTICL2xCBDuK/QZLWMMbvXAL+nA0gAcFib2UHBsbTGtqelBgx
 s6/MbvT9y9fjXBpKdSv/4TMAB5wOLoPeSLMqcEDqL9zDQFJZN4um+WVsAa2a9QvmG7XS
 PFpBXMj7BBRiHYxvvJHzE7nL0+w/7Chyga1DmSc9temv3tzhRFD9ooCCdsA9vcsmOxdw WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bh8cavt1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 08:17:34 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196BPUEv008005;
        Wed, 6 Oct 2021 08:17:34 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bh8cavt17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 08:17:33 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196CDMEX014373;
        Wed, 6 Oct 2021 12:17:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2a2c86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 12:17:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196CC5iB55574868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 12:12:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31669A405F;
        Wed,  6 Oct 2021 12:17:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14E4BA4068;
        Wed,  6 Oct 2021 12:17:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 Oct 2021 12:17:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 28C8AE2567; Wed,  6 Oct 2021 14:17:26 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Stefan Raspl <raspl@de.ibm.com>
Subject: [PATCH] KVM: kvm_stat: do not show halt_wait_ns
Date:   Wed,  6 Oct 2021 12:17:24 +0000
Message-Id: <20211006121724.4154-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ORRKPysGotAO6SBUsQs-Mpyx8D_TZT2V
X-Proofpoint-GUID: A-8NRpSnQ3bECARpxLWHF2oHpvw-dUQy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_02,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxlogscore=701 spamscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to commit 111d0bda8eeb ("tools/kvm_stat: Exempt time-based
counters"), we should not show timer values in kvm_stat. Remove the new
halt_wait_ns.

Fixes: 87bcc5fa092f ("KVM: stats: Add halt_wait_ns stats for all architectures")
Cc: Jing Zhang <jingzhangos@google.com>
Cc: Stefan Raspl <raspl@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index b0bf56c5f120..5a5bd74f55bd 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -742,7 +742,7 @@ class DebugfsProvider(Provider):
         The fields are all available KVM debugfs files
 
         """
-        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns']
+        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns', 'halt_wait_ns']
         fields = [field for field in self.walkdir(PATH_DEBUGFS_KVM)[2]
                   if field not in exempt_list]
 
-- 
2.32.0

