Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659B3739871
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjFVHwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjFVHwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954891A1;
        Thu, 22 Jun 2023 00:52:06 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7llAe022470;
        Thu, 22 Jun 2023 07:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=84LkuBbzflMCsTRR7PkzXnUNsPXpO+evdLbENUGBTLs=;
 b=GGZZme2DYf+MwWHoYZt+71ozQ5nA5JFyp9DYr213+wEeu4XRLjC+doX2RaSez5+YAV7F
 4zHRuA+29AUWD+FPoe2WxIkaSoJTW7U3n0kAJpNb9ltau1LGBpht+F0gUJBvQJ/Ie+kO
 wkFLjRL01ZbYd7V8X6Z4YZESdfwm6XprFOGb7Me7fzCAHMDgXaX7B+JEIL/xQB4P/d12
 auO1HmFTBAl16XuINuajsn2JgeOBeb25EmIbxXgiBR3yEr0Fc+nEcb+9b5Ha/jR1T1Ph
 M3eb+iUUIzTTpxnorDgV82matXcRM59nlciIi00CIVmUQhFV2TbRZqvci8+r76k9NBE/ 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchyj8jk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:05 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7VFLH022321;
        Thu, 22 Jun 2023 07:52:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchyj8jjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M2IcWp030142;
        Thu, 22 Jun 2023 07:52:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5baqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7pxic33751410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:51:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A1A20043;
        Thu, 22 Jun 2023 07:51:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9AF820040;
        Thu, 22 Jun 2023 07:51:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:51:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/8] s390x: uv-host: Fixups and extensions part 1
Date:   Thu, 22 Jun 2023 07:50:46 +0000
Message-Id: <20230622075054.3190-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wk8ob83USK19qrQbXxrZ1t-q75aKhk8k
X-Proofpoint-ORIG-GUID: ooadA8d8eqLmUGp4TjSErz3ZUKQHzITW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=937 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The uv-host test has a lot of historical growth problems which has
largely been overlooked since running it is harder than running a KVM
(guest 2) based test.

This series fixes up smaller problems but still leaves the test with
fails when running create config base and variable storage
tests. Those problems will either be fixed up with the second series
or with a firmware fix since I'm unsure on which side of the os/fw
fence the problem exists.

The series is based on my other series that introduces pv-ipl and
pv-icpt. The memory allocation fix will be added to the new version of
that series so all G1 tests are fixed.

v4:
	- Re-based on the ipl/icpt series
	- Replaced 1024 divisions with SZ_1M
	- Instead of making the variable storage test a xfail it's now
          removed until I understand what's going on
	- Since the sigp patch only changed code that I removed, the
          patch could be dropped
v3:
	- Re-based on the ipl/icpt series
	- Added review-bys
v2:
	- Added patch that exchanges sigp_retry with the smp variant
	- Re-worked the create config test handling
	- Minor fixups


Janosch Frank (8):
  s390x: uv-host: Fix UV init test memory allocation
  s390x: uv-host: Check for sufficient amount of memory
  s390x: uv-host: Beautify code
  s390x: uv-host: Add cpu number check to test_init
  s390x: uv-host: Remove create guest variable storage prefix check
  s390x: uv-host: Properly handle config creation errors
  s390x: uv-host: Fence access checks when UV debug is enabled
  s390x: uv-host: Add the test to unittests.conf

 lib/s390x/asm/uv.h  |   1 +
 s390x/unittests.cfg |   7 +++
 s390x/uv-host.c     | 134 ++++++++++++++++++++++++++++++++------------
 3 files changed, 107 insertions(+), 35 deletions(-)

-- 
2.34.1

