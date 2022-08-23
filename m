Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600FD59E983
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiHWRc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiHWRaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 13:30:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8DC60EC;
        Tue, 23 Aug 2022 08:07:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NF0XWR029365;
        Tue, 23 Aug 2022 15:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=omApnrgtF9Z5XmKiZc62jLTdNnVnB5XqlLkFWCPxvPg=;
 b=YRO5RndTZej7PE+zS55Kjgj8dKAIucI5A4V3Nz0NmE2AyXoK2cLY+hUZTWc7c6xGy6oZ
 bHat2OYKNN+9yE3cLNLJCM/VpYML1refgmuUZoFSvR3SFto7ILtaP0AzXoKbR2SkLXHW
 W56PlG4/fu6Egfq6Myw18WnGRJUcmT5pf7bflcV33wyQ32jcCkdJlcau2olXhYMML+Wi
 uPIICSpCun1HECfvjaafyO0rJcV/lgDXhAlahVWIZFF8YKDWNJ9isgkOXiyRd/nou/KK
 nBKV5WUk4kpild6zOOsXmJv0uqzcbCaQOMN8bK289oTMSlbzZwNqxGEGqC2p4YN1/oCa rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5159gabd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:07:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NF12jY031836;
        Tue, 23 Aug 2022 15:07:18 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5159ga4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:07:17 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NF4w02004386;
        Tue, 23 Aug 2022 15:06:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3j2q89bmy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 15:06:46 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NF6jX654460888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 15:06:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E1EE112062;
        Tue, 23 Aug 2022 15:06:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1019112061;
        Tue, 23 Aug 2022 15:06:44 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.64.167])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 15:06:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v3 0/2] s390/vfio-ap: fix two problems discovered in the vfio_ap driver
Date:   Tue, 23 Aug 2022 11:06:41 -0400
Message-Id: <20220823150643.427737-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HGFKurM5tLU1lrxggt6k5j6HpHNSrK14
X-Proofpoint-ORIG-GUID: YwAMKYPJCo8o1liqvntxXUNpDWTweBbb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two problems have been discovered with the vfio_ap device driver since the
hot plug support was recently introduced:

1. Attempting to remove a matrix mdev after assigning a duplicate adapter
   or duplicate domain results in a hang.

2. The queues associated with an adapter or domain being unassigned from
   the matrix mdev do not get unlinked from it.

Two patches are provided to resolve these problems.

Change log v2 => v3:
--------------------
* Replaced the wrong commit IDs in the 'Fixes' tags in both patches. 
  (Halil and Alexander)

* Changed the subject line and description of patch 01/02 to better reflect the
  code changes in the patch. (Halil)

Tony Krowiak (2):
  s390/vfio-ap: bypass unnecessary processing of AP resources
  s390/vfio-ap: fix unlinking of queues from the mdev

 drivers/s390/crypto/vfio_ap_ops.c | 36 +++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.31.1

