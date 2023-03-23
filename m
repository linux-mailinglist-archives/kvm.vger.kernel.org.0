Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E8E6C6571
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjCWKnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjCWKnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C1D3B3EA
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:25 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N8pNoF022777
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uq1A1Eo3w1m6OPhOjlEBUB/WO6Ldy1yFDgXzuAUo8gg=;
 b=Su9tKtEQ+bwRY0hL3ya4TxC126IZGt1gIByabLw3GgYbG3NYJBTXtgz1JLQ0DaBtp3XG
 +KZclNhINdULQVUXVQTH1oMXkpH8Yr2wCsyfUebVN807uEaLxzTY7f9+PgWTMPwhWXuy
 jvHOW400MNLjT4JsyEppq23s5MW/inqqSuExBB9lFgS39pV2tcKr45lU2GHxcseXzfn2
 IjepCRu0WYYh51t9u80GpETS/mn3iqST87Rif28XJfwwgsJCb8dtTJwSc7LV1t48FdK4
 QtYK6lxTBfXsIWGYVf0VuTQKMBSlXwsN3/pPyTG+33n8B5Qgn/5cypGUABz30vK56aMk Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pge77hrg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32N8a2Fv007598
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:20 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pge77hrff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MKG9nI014689;
        Thu, 23 Mar 2023 10:40:18 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e1xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeE4x39911946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AE742008F;
        Thu, 23 Mar 2023 10:40:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9645120088;
        Thu, 23 Mar 2023 10:40:13 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/8] s390x: uv-host: Fixups and extensions part 1
Date:   Thu, 23 Mar 2023 10:39:05 +0000
Message-Id: <20230323103913.40720-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8m7DENHiBxT8Bw40mdKO9UJMIGAFBn3A
X-Proofpoint-ORIG-GUID: wSz3eCBQGb61ymTU73D_EYGXUQFDap3Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
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

Janosch Frank (8):
  s390x: uv-host: Fix UV init test memory allocation
  s390x: uv-host: Check for sufficient amount of memory
  s390x: Add PV tests to unittests.cfg
  s390x: uv-host: Beautify code
  s390x: uv-host: Add cpu number check
  s390x: uv-host: Fix create guest variable storage prefix check
  s390x: uv-host: Properly handle config creation errors
  s390x: uv-host: Fence access checks when UV debug is enabled

 lib/s390x/asm/uv.h  |   1 +
 s390x/unittests.cfg |  16 +++++++
 s390x/uv-host.c     | 101 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 99 insertions(+), 19 deletions(-)

-- 
2.34.1

