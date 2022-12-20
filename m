Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A930652552
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiLTRM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiLTRL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:11:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB351D300;
        Tue, 20 Dec 2022 09:11:23 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8WWJ020849;
        Tue, 20 Dec 2022 17:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l+hJMSzvO5RqAoNd/EKM3XRdsLdu0O7enub5apvRcyc=;
 b=BvhWhtQMhvcxL5KqdPnwV9hR8A4cVJS5b685kJecJIdMs5y6Q3pfebsknraQc2UAc9cO
 rvVv7TdyfhtBxzOYbPzHK6lTJjbtzMbwKAb/K966z9RRV3GWGoSxxqbsfNbcRXQGcIg8
 lNoMEhI0j6C0vtJaf3+KxVnHFLhcM7zsojENmw/rxqdA9xgYKBgNdLJVQO2jpNfd2BDZ
 nzmSfm2CUF9wdRys9+6GBOdpSx9PjrIupuiQ0CbEKud92ksx1pkP9zNU06YytJxteUsh
 cqmHcKxxxNz5S6fVIlKpJym/ejKvXOtlJTErJAUmWMOQX0rKd3RXIptX60dcYTN2mvP0 tw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbw9x1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6gbmp025317;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywmacp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHA9sG26345936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D263F20049;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02FD20040;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 82B47E0819; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 03/16] vfio/ccw: allow non-zero storage keys
Date:   Tue, 20 Dec 2022 18:09:55 +0100
Message-Id: <20221220171008.1362680-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xOqF3U3LGcbgsfjdec3RzfLvY5l6iOL5
X-Proofpoint-ORIG-GUID: xOqF3U3LGcbgsfjdec3RzfLvY5l6iOL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, vfio-ccw copies the ORB from the io_region to the
channel_program struct being built. It then adjusts various
pieces of that ORB to the values needed to be used by the
SSCH issued by vfio-ccw in the host.

This includes setting the subchannel key to the default,
presumably because Linux doesn't do anything with non-zero
storage keys itself. But it seems wrong to convert every I/O
to the default key if the guest itself requested a non-zero
subchannel (access) key.

Any channel program that sets a non-zero key would expect the
same key returned in the SCSW of the IRB, not zero, so best to
allow that to occur unimpeded.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index a0060ef1119e..268a90252521 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -836,7 +836,6 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
 
 	orb->cmd.intparm = (u32)virt_to_phys(sch);
 	orb->cmd.fmt = 1;
-	orb->cmd.key = PAGE_DEFAULT_KEY >> 4;
 
 	if (orb->cmd.lpm == 0)
 		orb->cmd.lpm = sch->lpm;
-- 
2.34.1

