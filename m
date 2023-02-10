Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850726924BF
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjBJRmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 12:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjBJRmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 12:42:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B012007F;
        Fri, 10 Feb 2023 09:42:36 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHgRqf000491;
        Fri, 10 Feb 2023 17:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0u5s5bu2AGAhcgXEPqbH2WvzBv8j6GzCgTayotfsUGw=;
 b=LWZhOxB9sr6wKjpvT9583c+gjSmjCwh3znWsQUELSGIOUqLtjtn6Zwakqy/10KsHKJ7/
 fAZuWO47VLA+9g3IEWI4c5bQLIcy3f3pvswj9mQyBJCa/sOt3EAeyNU00BCBvwHkLIGA
 33i6FPRdi6PEyX3ADeN0ijQXrdtcxOyeZUqbUq2o1k56f5p8G7BGJpBfUiXA7iIH+CVY
 gkCgk9fQvqUgizzAeMhpTjaTQgwt7MUW/ufRFTkWaGTfWvPC1CpCLerzslU6OfJMo7vn
 lqwnC60Z5q6eJIoCnPdas9hUnI9fY39lNCrGg5uqTIxOZqsQK3J3ThR4jHbUW25pQVeo yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nntj6r04k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 17:42:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AHgZVC000775;
        Fri, 10 Feb 2023 17:42:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nntj6r03q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 17:42:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31A1Co5x027412;
        Fri, 10 Feb 2023 17:42:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nhf06wkqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 17:42:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AHgS3E25362690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 17:42:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1C8F2004B;
        Fri, 10 Feb 2023 17:42:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF73320043;
        Fri, 10 Feb 2023 17:42:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 10 Feb 2023 17:42:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 6E2CFE0468; Fri, 10 Feb 2023 18:42:28 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] vfio/ccw: Remove WARN_ON during shutdown
Date:   Fri, 10 Feb 2023 18:42:27 +0100
Message-Id: <20230210174227.2256424-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j-NvG1nVPpOKaUT6kJFA2TC4VoEz9Vqn
X-Proofpoint-GUID: -lRAolwGvcNBMBpQoNontTv6QjqLHT2Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1011 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302100146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The logic in vfio_ccw_sch_shutdown() always assumed that the input
subchannel would point to a vfio_ccw_private struct, without checking
that one exists. The blamed commit put in a check for this scenario,
to prevent the possibility of a missing private.

The trouble is that check was put alongside a WARN_ON(), presuming
that such a scenario would be a cause for concern. But this can be
triggered by binding a subchannel to vfio-ccw, and rebooting the
system before starting the mdev (via "mdevctl start" or similar)
or after stopping it. In those cases, shutdown doesn't need to
worry because either the private was never allocated, or it was
cleaned up by vfio_ccw_mdev_remove().

Remove the WARN_ON() piece of this check, since there are plausible
scenarios where private would be NULL in this path.

Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 54aba7cceb33..ff538a086fc7 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -225,7 +225,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 	struct vfio_ccw_parent *parent = dev_get_drvdata(&sch->dev);
 	struct vfio_ccw_private *private = dev_get_drvdata(&parent->dev);
 
-	if (WARN_ON(!private))
+	if (!private)
 		return;
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
-- 
2.37.2

