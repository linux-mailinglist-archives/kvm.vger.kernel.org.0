Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0593C516D89
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384289AbiEBJnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382377AbiEBJnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:43:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1678511144;
        Mon,  2 May 2022 02:39:34 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2428ADwM031519;
        Mon, 2 May 2022 09:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uBUEP4IVJ/UpVM8bS+tTYqgJq7RGCjFh55cg67cXDrA=;
 b=ThfGBit+iSoCcuRMIk08qx2FSGWfthSttoZk/HXh3KcpGT67zctYVFuN6CJlx2DkQyw4
 PtCQpM25VvkS5UHlz4xl2cf3+Arkhy9DcXa1j7/Rw5pk+EGw7cZeW7/ygt/+RTNP8MKR
 hy/danywKZtkNWz+V5RBEHYp+Dwk4ncgX1sjUGC5Og2xtsM9e+457C2SVxg7KwroEy7D
 4iE27s8LsrWJ1v04O3OM0e2dIPpOZoQoorD3w174mLN0XzGi5v8TBy7AQPWTL3bA+XVn
 h7X5/QkvQMsUANumpMysweidmbpzD536N0w+qSRWsgUZveUpiOvbHcReOU9NCwqtzqKG 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fta1bk651-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:33 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2429dHub017814;
        Mon, 2 May 2022 09:39:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fta1bk64g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429c9MC002355;
        Mon, 2 May 2022 09:39:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3frvr8j1dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429dRA845547884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:39:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E832BAE04D;
        Mon,  2 May 2022 09:39:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 329B8AE045;
        Mon,  2 May 2022 09:39:26 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 09:39:26 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 0/6] s390x: Attestation tests
Date:   Mon,  2 May 2022 09:39:19 +0000
Message-Id: <20220502093925.4118-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JSr1nCvLGtV30Rgx2uw-ZifwCmQiGYmu
X-Proofpoint-ORIG-GUID: 3u-xuftLjIIbN1xlJPBr5R3ssIUEUyPt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds some test in s390x/uv-guest.c verifying error paths of the
Request Attestation Measurement UVC.
Also adds a test in s390x/uv-host.c to verify that the
Request Attestation Measurement UVC cannot be called in guest1.

Additionally, adds a shared bit test and removes duplicated tests.

v4->v5:
  * added r-b from Janosch
  * fixed some nits
  * Added PATCH to remove double prefix_pop in uv-guest
  * renamed latch PATCH

v3->v4:
  * renamed PATCH 1
  * moved attestation guest tests into own file
  * rebased onto current master

v2->v3:
  * added test for share bits as new PATCH 4/5
  * added r-b from Claudio in PATCH 1/4
  * replaced all u* with uint*_t
  * incorporated misc feedback from Claudio

v1->v2:
  * renamed 'uv_get_info(void)' to 'uv_get_query_data(void)'
  * renamed various fields in 'struct uv_arcb_v1'
  * added a test for invalid additional size
  * added r-b from Janosch in PATCH 1/4
  * added r-b from Janosch in PATCH 3/4

Steffen Eiden (6):
  s390x: uv-host: Add invalid command attestation check
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: Remove double report_prefix_pop
  s390x: uv-guest: add share bit test
  s390x: Add attestation tests

 lib/s390x/asm/uv.h |  28 +++++-
 lib/s390x/uv.c     |   8 ++
 lib/s390x/uv.h     |   1 +
 s390x/Makefile     |   1 +
 s390x/pv-attest.c  | 225 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/uv-guest.c   |  51 ++++++----
 s390x/uv-host.c    |   1 +
 7 files changed, 295 insertions(+), 20 deletions(-)
 create mode 100644 s390x/pv-attest.c

-- 
2.30.2

