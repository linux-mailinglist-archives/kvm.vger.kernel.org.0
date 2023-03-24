Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4654D6C7DDE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCXMS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjCXMS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B957ECD
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:14 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OB31Dv026373
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3gJubOlqxRJDfZEsUD6XCHcs1ZeFo+gk4x/sWGiVzTM=;
 b=qcXUYRjVySwj2kTRmegYR7121AjwPEI3HjpAO97SHUdcqNc1Ck0eeEg6d7LXRodOOofo
 SMfwKmYRN1lAprnkeR4rVbNPJyqtA3n7a4Raojqm7PMoRl0pS0lvS0ecNIHKshbaQs2n
 uC7JHvNLH4mJJ82wbxN2mHfCYb17+ShtvJ+v+NTyU/tdA2CLHt3+WStWM2XdrIesCUaW
 pgmwl7j7jJorO+axY/IkqRTY8gznzDPDz8QXaXbVt0Psoz5Ux8Ze2S8D+sk8ADVDRA/S
 AU1MpPSP/bgYLO2QmFrprzaIGBQ47dpx3bGd69r1CRsjPp4u4UQGB+Rv9r4HXvYoVoq0 Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84udmv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:14 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OCFJY3005080
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84udmun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLKcqn024767;
        Fri, 24 Mar 2023 12:18:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pgxkrrttb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCI8C228115496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B03220071;
        Fri, 24 Mar 2023 12:18:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78A212004E;
        Fri, 24 Mar 2023 12:18:07 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/9] s390x: uv-host: Fixups and extensions part 1
Date:   Fri, 24 Mar 2023 12:17:15 +0000
Message-Id: <20230324121724.1627-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pbovufDaZyRNBhV85fu1R64BBO2F4r7I
X-Proofpoint-ORIG-GUID: Wbx2WRqr59vNNxL5361T4wdYVrAhVTD3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 mlxlogscore=982 suspectscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The uv-host test has a lot of historical growth problems which have
largely been overlooked since running it is harder than running a KVM
(guest 2) based test.

This series fixes up smaler problems but still leaves the test with
fails when running create config base and variable storage
tests. Those problems will either be fixed up with the second series
or with a firmware fix since I'm unsure on which side of the os/fw
fence the problem exists.

The series is based on my other series that introduces pv-ipl and
pv-icpt. The memory allocation fix will be added to the new version of
that series so all G1 tests are fixed.

v2:
	- Added patch that exchanges sigp_retry with the smp variant
	- Re-worked the create config test handling
	- Minor fixups

Janosch Frank (9):
  s390x: uv-host: Fix UV init test memory allocation
  s390x: uv-host: Check for sufficient amount of memory
  s390x: Add PV tests to unittests.cfg
  s390x: uv-host: Beautify code
  s390x: uv-host: Add cpu number check
  s390x: uv-host: Fix create guest variable storage prefix check
  s390x: uv-host: Switch to smp_sigp
  s390x: uv-host: Properly handle config creation errors
  s390x: uv-host: Fence access checks when UV debug is enabled

 lib/s390x/asm/uv.h  |   1 +
 s390x/unittests.cfg |  17 ++++++
 s390x/uv-host.c     | 140 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 129 insertions(+), 29 deletions(-)

-- 
2.34.1

