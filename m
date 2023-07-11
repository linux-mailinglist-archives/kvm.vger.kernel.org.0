Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E349074F187
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjGKOQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjGKOQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DD1B0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:34 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BECf9T016982;
        Tue, 11 Jul 2023 14:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=mFJy8yJ21R3z6Hn7TL/AIvv94gBR4zzo6Eh+kqy/yO8=;
 b=FYfso79MaQDg6VksOdnurNE6zKR5WhJplQVR7noPj0pBWBdaz4+QBQyMro/zPEjzfuvh
 IdmZ0021ETodivHPvygejkNEiX7CfjXPsTVGQ0GPR3V/WeGmBZkpf2dX33hz0xPatMjh
 DysZ2sJgkifqHnsCphecGqcQm53bp/3SHcoxuO3qawXdNwMkJCtv561VNodMIKhtzDU0
 IOBvBeRcuwZF8YNoRZA2bnOZ8xlwoxaOrZlRxFEnaPhkKhuLQDUai7WPWsmDyKmmHHZY
 7Sng440vkq35WGOTMAm9bWsVV9TLd9lO9WVQuZgwzOFwIbT7pzsadwHOvkRT9xLSQW5L Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my85x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:24 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BED4Zu021085;
        Tue, 11 Jul 2023 14:16:24 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my85ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BBSqSA028231;
        Tue, 11 Jul 2023 14:16:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3rpye51c02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGGt766388306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F0CA20049;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8937B20043;
        Tue, 11 Jul 2023 14:16:15 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:15 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 10/22] s390x: pv-diags: Add the test to unittests.conf
Date:   Tue, 11 Jul 2023 16:15:43 +0200
Message-ID: <20230711141607.40742-11-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g0myZLEu4F_Ex7-y11arPQoa8mcGAIzA
X-Proofpoint-ORIG-GUID: Q5aXdpjt7Tt6nP7_gCKL8bZPY2G88qUz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Better to have it run into a skip than to not run it at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-9-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/unittests.cfg | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 26bab34..49b3cee 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -229,3 +229,8 @@ extra_params = -m 2200
 file = pv-ipl.elf
 groups = pv-host
 extra_params = -m 2200
+
+[pv-diags]
+file = pv-diags.elf
+groups = pv-host
+extra_params = -m 2200
-- 
2.41.0

