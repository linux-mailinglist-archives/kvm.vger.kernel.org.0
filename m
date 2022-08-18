Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A545598418
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbiHRN0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 09:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245107AbiHRN0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 09:26:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83BAB5152;
        Thu, 18 Aug 2022 06:26:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ICBuk8006519;
        Thu, 18 Aug 2022 13:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=cy7TOBkBTUsUGXp1HFb/zjQD2mtz9+NBBqSnwdv4rL8=;
 b=MVsMdVEI+lij3D2MXCJ6HW4dbkUMfC+++eKMzhYPJoAnH2G4I0SiSkTxdsG7ueL09OuE
 KKVWM63ErEPApgEXKcG/+DnIveOidTDrhyLRjFFSfUztHodjVPumxnHjHir2Z8413Ujh
 t6S9nbLbcLzcL1rg7FAD2u8twkwOdGWUX1/pSyHIqe0kc8X48rFLQsJAHG8dW1BGbVxY
 AgwFkw8S2ZQ+8xnVN8ir18fzXiu3YGBNrZotIirgdy3uEA5NnxtdTzUUc7M8Sn0FijrL
 OnTEbSy/cjLkRAQphKK397HtbnsOwgNojVtrQkMwVCnrqOfCTgeN4i4Gha+4aG90t7WK 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1n7cjkt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ICh08O032161;
        Thu, 18 Aug 2022 13:26:11 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1n7cjkse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:11 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IDJvau000471;
        Thu, 18 Aug 2022 13:26:09 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3hx3ka704e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 13:26:09 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IDQ8Tf6029914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 13:26:08 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCD406E050;
        Thu, 18 Aug 2022 13:26:08 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B01226E052;
        Thu, 18 Aug 2022 13:26:07 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.64.167])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 13:26:07 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: [PATCH v2 0/2] s390/vfio-ap: fix two problems discovered in the vfio_ap driver
Date:   Thu, 18 Aug 2022 09:26:04 -0400
Message-Id: <20220818132606.13321-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: naYnCpwq83TT-adBpbmKSPS_COtxlT9t
X-Proofpoint-ORIG-GUID: J2i-395Jiy_ONmAD2n-vqoYMwjplYzOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208180045
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

Change log v1 => v2:
====================
* Added Fixes: tags to both patches
* Copying stable@vger.kernel.org

Tony Krowiak (2):
  s390/vfio-ap: fix hang during removal of mdev after duplicate
    assignment
  s390/vfio-ap: fix unlinking of queues from the mdev

 drivers/s390/crypto/vfio_ap_ops.c | 36 +++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.31.1

