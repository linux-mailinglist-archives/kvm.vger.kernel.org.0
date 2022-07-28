Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF59F5843D5
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiG1QMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiG1QMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:12:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DCB3DF2C;
        Thu, 28 Jul 2022 09:12:14 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SFlLPf024645;
        Thu, 28 Jul 2022 16:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g0+JB1nWC1+o1YMbiG5nEyLpot84x3ty03qwELNs8ig=;
 b=nmQ6rn8dyaYWglNvOdFu5WPl6K57qOEoLgxIOxJOEn+yXKNcMUCFxtuqrigDtbwX9eK/
 wB26dvwuAuZb7NjLcEQCDpiBj9JEMxc1e6AMkzoJou+1kHMuN7/Sx5cKWHykWbbgjbRN
 o94XbufLTWMgflGq31Aq54i3EINubtspZlVtgkEQWFNiWH049lSd9SniaXmKA9/BxC6L
 URPTfyrAtZLwnri7rZ/NiZgkb8Ryz7SpijfYnR+4ON9EGVJsUeJEU4lQOsXPWHXpOtVZ
 QiJuizKtYzjZAX5rEhMlLTrgkkFz1gCB3EcSXbgplgdTnFGmNPmKRrwyYI9lyDeVqLIm 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkwdhgvxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:11 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SForGQ020666;
        Thu, 28 Jul 2022 16:12:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hkwdhgvw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SG5DA4018637;
        Thu, 28 Jul 2022 16:12:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6eun8wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 16:12:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SGCJ2030605784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 16:12:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D87952057;
        Thu, 28 Jul 2022 16:12:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3918552052;
        Thu, 28 Jul 2022 16:12:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 16A3FE1231; Thu, 28 Jul 2022 18:05:52 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 3/3] vfio/ccw: Check return code from subchannel quiesce
Date:   Thu, 28 Jul 2022 18:05:50 +0200
Message-Id: <20220728160550.2119289-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728160550.2119289-1-farman@linux.ibm.com>
References: <20220728160550.2119289-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7G8umVfg8CDtee2lXC5RMHsirOPbTvpg
X-Proofpoint-ORIG-GUID: htO8ObBA130TTcxVW84U9O-GPiUSsy7I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207280073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a subchannel is busy when a close is performed, the subchannel
needs to be quiesced and left nice and tidy, so nothing unexpected
(like a solicited interrupt) shows up while in the closed state.
Unfortunately, the return code from this call isn't checked,
so any busy subchannel is treated as a failing one.

Fix that, so that the close on a busy subchannel happens normally.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 4b8b623df24f..a59c758869f8 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -407,7 +407,7 @@ static void fsm_close(struct vfio_ccw_private *private,
 
 	ret = cio_disable_subchannel(sch);
 	if (ret == -EBUSY)
-		vfio_ccw_sch_quiesce(sch);
+		ret = vfio_ccw_sch_quiesce(sch);
 	if (ret)
 		goto err_unlock;
 
-- 
2.34.1

