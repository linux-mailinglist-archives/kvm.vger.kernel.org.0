Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26646509CAE
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387856AbiDUJs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387820AbiDUJsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:48:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2837C1FA5E;
        Thu, 21 Apr 2022 02:45:35 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9j2jT013411;
        Thu, 21 Apr 2022 09:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1YGqo0Pq2bosapwQS3AMb2KuFAn0jGkFAeewTEQOx+g=;
 b=FL4ThNaqWNRpeVK9nBaSVJM7X6ej2RoovsktOm2TaDULC+8dQDXDjh+74KgP3ugbCeM+
 7sHi3zpueRCFG01InvQYUkLoF6huqY+OHbDzgHJrgFZPczjz4s+ZwEtI4w7s5BeSPQWG
 5Ch7fsTuIqRiMcd+N2+RVxcf9mp6GiRO8MhfapwXZ2+Y4CxodQ7/j5qN/q9uzHRqKHIe
 7z3q89JDTKFESb9z0Mpy5Lnm/M51R/3yIbcLTlxaM6797QWSVsQdgUoLMwjInm5qAcx1
 l9fZevvfEYtQq4fuho8htNr9gelTdvRJ+uwadPYyJ+YsW0UG5Y4ST8rjFs9hTsHraJXU 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjn0xhmyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:34 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9jYmk016177;
        Thu, 21 Apr 2022 09:45:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjn0xhmxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L9dAZs027620;
        Thu, 21 Apr 2022 09:45:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8qm4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:45:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L9jS0N56230160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:45:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C17F811C050;
        Thu, 21 Apr 2022 09:45:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 082F311C054;
        Thu, 21 Apr 2022 09:45:28 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 09:45:27 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/5] s390x: Attestation tests
Date:   Thu, 21 Apr 2022 09:45:22 +0000
Message-Id: <20220421094527.32261-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dDQKKEBLWZgEfJJouc2mZp-n5fSQM97Y
X-Proofpoint-ORIG-GUID: 2Lf2QT2GbJQnTmlLkc4cisU8ySs_5hGN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=986 bulkscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Steffen Eiden (5):
  s390x: uv-host: Add invalid command attestation check
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: add share bit test
  s390x: uv-guest: Add attestation tests

 lib/s390x/asm/uv.h |  28 +++++-
 lib/s390x/uv.c     |   8 ++
 lib/s390x/uv.h     |   1 +
 s390x/Makefile     |   1 +
 s390x/pv-attest.c  | 225 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/uv-guest.c   |  49 ++++++----
 s390x/uv-host.c    |   1 +
 7 files changed, 293 insertions(+), 20 deletions(-)
 create mode 100644 s390x/pv-attest.c

-- 
2.30.2

