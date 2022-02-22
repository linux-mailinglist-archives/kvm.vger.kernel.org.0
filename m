Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBED4BFB42
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiBVOza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiBVOz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:55:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2AC10C513;
        Tue, 22 Feb 2022 06:55:04 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MDhVXK008641;
        Tue, 22 Feb 2022 14:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WasIFNVspPrrzPbL8xLUvMFJeNc3XqAvekSgehFfi20=;
 b=Vod4WPSFBbiayYgCy30r2HM15daNcc/JDMXJ/XKpA7jfUUq7/Cw+kigl6qjXqQ8SzTQI
 CLqAZUsLhXyUBU3pTgM/BFh4U0kXIBAgUgSt9WGgkkGZIMchIe0ezllK3Xj/piEsfHI4
 CrTis5OSxR5jRkGmlOxiMQqrKfXAwvAiKaWQkhCukNCwFmf6e1iGsfv0S6L7/Ps4NWQJ
 5CyGInMQmIL69fmBeyKC+6Db47oCnQ5O7dyzt/xXrdc0PRkakQFVrex78kI31WmiTavJ
 R8IRooxZaRFyN1v03jae4NL35akyy2NAyUjkiV5P62cUQvA2erZJ+WiviWsCnPwzFhD/ rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ed0pwtdr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:03 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MEqx68013445;
        Tue, 22 Feb 2022 14:55:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ed0pwtdqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MEguC5011763;
        Tue, 22 Feb 2022 14:55:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear692fuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MEsw6o45351252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 14:54:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DF29A4054;
        Tue, 22 Feb 2022 14:54:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C890BA4060;
        Tue, 22 Feb 2022 14:54:56 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 14:54:56 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/5] s390x: Attestation tests
Date:   Tue, 22 Feb 2022 14:54:51 +0000
Message-Id: <20220222145456.9956-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TbooUvHV8ilGI7yusbF72c0JjCyzCDkA
X-Proofpoint-ORIG-GUID: veF9STmdeu7PRvBCs0CT-cquFoIypKbg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
  s390x: uv-host: Add attestation test
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: add share bit test
  s390x: uv-guest: Add attestation tests

 lib/s390x/asm/uv.h |  28 +++++-
 lib/s390x/uv.c     |   8 ++
 lib/s390x/uv.h     |   1 +
 s390x/uv-guest.c   | 229 +++++++++++++++++++++++++++++++++++++++++----
 s390x/uv-host.c    |   1 +
 5 files changed, 249 insertions(+), 18 deletions(-)

-- 
2.30.2

