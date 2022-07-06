Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8676567EC0
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiGFGlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiGFGlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988B7167CA;
        Tue,  5 Jul 2022 23:41:17 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2665o3MH006481;
        Wed, 6 Jul 2022 06:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0Z0X96vgkhv+exkjHJyHeIbPb35vVYETGsRAdNRqah4=;
 b=Bn77bglD2dLlNyzBdH2UHKf8WUR6/xuRk1xlTUVxNu/kDFJ5kKX9LjTtNHTmh6g+8/cG
 I/d6OdwRMj5RGkOQibaLjtEGrl7oQnRoIvBjhvjW8B3plgvdctNqQwK+pSe/5GqJQgdP
 1hfiHbhvPD+UC87kyO4XQojqvBUwNiEzhXyYGOUIMriZ4xB/InxFUNO+NqoWBCYQ6s6F
 qR+V9lUb/s970QiFQhe/633XS+lC0ygCwO9eZQRGZbcelN2rXtgciTVbIcJCR8UwkBEW
 14/xK+FgeD+3oeh6SndPQM5pgRxX3NIrxx8h5JI3wd1TqACJ0QFxwZ9sIYaNqIY/Qpk+ kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h54kj92qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666fGg2013900;
        Wed, 6 Jul 2022 06:41:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h54kj92q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666M1bm025541;
        Wed, 6 Jul 2022 06:41:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsgjb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666dtpn23790058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:39:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 341D74C04A;
        Wed,  6 Jul 2022 06:41:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 462284C040;
        Wed,  6 Jul 2022 06:41:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/8] s390x: uv-host: Access check extensions and improvements
Date:   Wed,  6 Jul 2022 06:40:16 +0000
Message-Id: <20220706064024.16573-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sdZ7Qrx6Kf7rhNQW410AT3Qv8Kno4vID
X-Proofpoint-ORIG-GUID: WjtDdgPEjQbVHwBCpmFytL3BhMI--Wdc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 malwarescore=0
 bulkscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207060022
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the last few weeks I had a few ideas on how to extend the uv-host
test to get more coverage. Most checks are access checks for secure
pages or the UVCB and its satellites.

I've had limited time to cleanup this series, so consider having a closer
look.


v2:
	* Moved 3d access check in function
	* Small fixes
	* Added two more fix patches


Janosch Frank (8):
  s390x: uv-host: Add access checks for donated memory
  s390x: uv-host: Add uninitialized UV tests
  s390x: uv-host: Test uv immediate parameter
  s390x: uv-host: Add access exception test
  s390x: uv-host: Add a set secure config parameters test function
  s390x: uv-host: Remove duplicated +
  s390x: uv-host: Fence against being run as a PV guest
  s390x: uv-host: Fix init storage origin and length check

 s390x/uv-host.c | 256 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 246 insertions(+), 10 deletions(-)

-- 
2.34.1

