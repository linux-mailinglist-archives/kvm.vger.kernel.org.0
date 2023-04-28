Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC306F1430
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345798AbjD1J3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345826AbjD1J3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:29:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6676A6E;
        Fri, 28 Apr 2023 02:28:28 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S9Qudj018531;
        Fri, 28 Apr 2023 09:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xwtJ/g43lO6A5YZJLyYeot9G64i5kCXSGDpr7I+t3u4=;
 b=PXxxEeOwtkNH4Dq/0AajY5uLuN5zmYkvK0NrPHQYxzkEmioL/GSevgU04Znc6VX1f0Js
 nh1cdVF9JqGw2orJW4s3bEIAxhGujv10T2HbaipYSitd0E5oKpvIrqJTbuPk+H3SHpjU
 RzvM0P6qaswN2sgf3eOme8a9ZiIMyMzWXB7GgXV4Cqvv4Lg64HnzaExCe7uiB/wuUxGQ
 6ron/PQ/0BUkEai/310r2g7asXLN6D+0St2NQt1Qyfp0KtwS79ICMklwVBYbCs2qxYQX
 xyrrdz+A48n7azguc/FWtwLp9p7G2Xu4kpM3wqMpaiebs4ZRtGp3hnoHrGo9p/mAZenF Sw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q89qnbja0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:28:02 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33S778a5000803;
        Fri, 28 Apr 2023 09:27:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q47772ukv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:27:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33S9RrSD36372854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 09:27:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A86E2004B;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BF7E20043;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Apr 2023 09:27:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, jgg@nvidia.com,
        hca@linux.ibm.com
Subject: [PATCH v3 0/1] fix race in gmap_make_secure()
Date:   Fri, 28 Apr 2023 11:27:52 +0200
Message-Id: <20230428092753.27913-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gohWUmygVOUofy0GzLd-_I0JXH5Y1vLm
X-Proofpoint-GUID: gohWUmygVOUofy0GzLd-_I0JXH5Y1vLm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=579 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304280073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a potential race and, most importantly, removes the last
user of follow_page() without FOLL_GET.

This removes the last user of follow_page without FOLL_GET. Once this
patch is merged I'll send a separate patch to perform FOLL_GET
automatically with follow_page, as suggested by Jason Gunthorpe.

v1->v2:
* fix and improve commit message [thanks Heiko]

Claudio Imbrenda (1):
  KVM: s390: fix race in gmap_make_secure()

 arch/s390/kernel/uv.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

-- 
2.40.0

