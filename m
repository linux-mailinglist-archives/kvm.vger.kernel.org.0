Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCDC514F03
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377736AbiD2PTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378258AbiD2PSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:18:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C76D39F;
        Fri, 29 Apr 2022 08:15:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDrlk3014944;
        Fri, 29 Apr 2022 15:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hfxgvehI11MS/VpLcvCmRookAnUjP0LCK+he3fTn98M=;
 b=fRq4NF2LthDEdmrZ9rSRGRoZuaH69/hIUFHTscF/f3LpDCDSenjFnPJnVRo2Iz4f0MS5
 mGU4Bj83VMru3u7DoprKRX1HrGSFd0WT9glglPoUz+JaosrKc3ghj9nbWjqziAQ9Mz44
 XTHwz5S7H2ZBYe2GLrNHWa2qT7mrpIyZlSc+1s3/wHvmATH1ARB2hLaWQHX1R4VKZxcd
 JpQTN0XSQZGOGQCNgIV7QRgUTlk7dAng0kENwS+GVKvL6yK04CSH06bQnZH6s6uHszAd
 SZf/6Spf/QxDzxzIlEDHWyKRvDtpUWfAZ4GV3LJ0zihRpcJzVobVMnbf7F1W5KGvJssm KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqv5rmhe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 15:15:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23TFFXxG026528;
        Fri, 29 Apr 2022 15:15:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqv5rmhdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 15:15:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TFChA4023751;
        Fri, 29 Apr 2022 15:15:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3fm9391awe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 15:15:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TFFRoC44368358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:15:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D2E352051;
        Fri, 29 Apr 2022 15:15:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 7BEE35204F;
        Fri, 29 Apr 2022 15:15:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 2C0F9E03CD; Fri, 29 Apr 2022 17:15:27 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH/RFC] KVM: s390: vsie/gmap: reduce gmap_rmap overhead
Date:   Fri, 29 Apr 2022 17:15:26 +0200
Message-Id: <20220429151526.1560-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Q4RpgXhQXL0naVgCxBs_HPVptOmfYUS
X-Proofpoint-ORIG-GUID: UQ6LwrjOubkJ7zW-IWiyyn4fSsE5jx--
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

there are cases that trigger a 2nd shadow event for the same
vmaddr/raddr combination. (prefix changes, reboots, some known races)
This will increase memory usages and it will result in long latencies
when cleaning up, e.g. on shutdown. To avoid cases with a list that has
hundreds of identical raddrs we check existing entries at insert time.
As this measurably reduces the list length this will be faster than
traversing the list at shutdown time.

In the long run several places will be optimized to create less entries
and a shrinker might be necessary.

Fixes: 4be130a08420 ("s390/mm: add shadow gmap support")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 69c08d966fda..0fc0c26a71f2 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1185,12 +1185,19 @@ static inline void gmap_insert_rmap(struct gmap *sg, unsigned long vmaddr,
 				    struct gmap_rmap *rmap)
 {
 	void __rcu **slot;
+	struct gmap_rmap *temp;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	slot = radix_tree_lookup_slot(&sg->host_to_rmap, vmaddr >> PAGE_SHIFT);
 	if (slot) {
 		rmap->next = radix_tree_deref_slot_protected(slot,
 							&sg->guest_table_lock);
+		for (temp = rmap->next; temp; temp = temp->next) {
+			if (temp->raddr == rmap->raddr) {
+				kfree(rmap);
+				return;
+			}
+		}
 		radix_tree_replace_slot(&sg->host_to_rmap, slot, rmap);
 	} else {
 		rmap->next = NULL;
-- 
2.35.1

