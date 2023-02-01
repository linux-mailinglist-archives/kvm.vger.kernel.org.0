Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8E686207
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 09:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBAItL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 03:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBAItI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 03:49:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A4261851;
        Wed,  1 Feb 2023 00:49:00 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3118bDxU009981;
        Wed, 1 Feb 2023 08:49:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6JlnDFS49OpnzHxW99krDUJt5FgMdg1pee7rJ4pOOjQ=;
 b=KbHaciBOHfV2LaBl3tEQX513i8hJhImRwoRD3kdc8Ifa0V4G+BAx6m7lJFCACflzMJRF
 G3HKQ8MjS8z7aE27GwwLbPQjiWPVEox3kZCcONXSCJm9Go6Mihww2rytAoLbHf2A7Q8h
 ROUbBDP50dw5b35Eo3EyqiDllAG4US1T7IiSvsPpH4Ssfbi3gXjauvZ8vxMvgwOLxk90
 YdQu90ELP/+gqZaSQ3lBrTpvNoTOD9c8V6qYA6FDdmOEGWY0E6OJApq/aUECtf6Llctd
 ILyMVJ7ravjTBcMeLeu98sbfZ3ajXWfhjDNQv9dfNr90snBRB0uOHQ5OhTKNRlFmpdwd 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfm3bscj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:48:59 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3118lFoF017524;
        Wed, 1 Feb 2023 08:48:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfm3bschm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:48:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VFSDp6018469;
        Wed, 1 Feb 2023 08:48:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ncvugk9de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:48:57 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3118mrKu38666662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 08:48:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B5DD20040;
        Wed,  1 Feb 2023 08:48:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7BC12004B;
        Wed,  1 Feb 2023 08:48:52 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 08:48:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/3] s390x: Add PV SIE intercepts and ipl tests
Date:   Wed,  1 Feb 2023 08:48:30 +0000
Message-Id: <20230201084833.39846-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k2lpileibsC8c0py6tue21EwpcTI4YYN
X-Proofpoint-GUID: aLwCfE_NY7KkZc-a_3hfM0cutfRXTpl7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_03,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the coverage of the UVC interface.
The patches might be a bit dusty, they've been on a branch for a while.

Janosch Frank (3):
  lib: s390x: Introduce UV validity function
  s390x: pv: Test sie entry intercepts and validities
  s390x: pv: Add IPL reset tests

 lib/s390x/uv.h                                |   7 +
 s390x/Makefile                                |   7 +
 s390x/pv-icptcode.c                           | 366 ++++++++++++++++++
 s390x/pv-ipl.c                                | 237 ++++++++++++
 s390x/snippets/asm/snippet-loop.S             |  12 +
 s390x/snippets/asm/snippet-pv-diag-308.S      |  67 ++++
 s390x/snippets/asm/snippet-pv-icpt-112.S      |  77 ++++
 s390x/snippets/asm/snippet-pv-icpt-loop.S     |  15 +
 .../snippets/asm/snippet-pv-icpt-vir-timing.S |  22 ++
 9 files changed, 810 insertions(+)
 create mode 100644 s390x/pv-icptcode.c
 create mode 100644 s390x/pv-ipl.c
 create mode 100644 s390x/snippets/asm/snippet-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-308.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-112.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-loop.S
 create mode 100644 s390x/snippets/asm/snippet-pv-icpt-vir-timing.S

-- 
2.34.1

