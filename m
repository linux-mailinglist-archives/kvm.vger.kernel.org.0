Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACDC67371B
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjASLl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjASLlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B1F2696
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:07 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBKQsn029710
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vBl1Ba63/EcvNK7NviReEzsVKZGsvSadzy5EoqxY8J8=;
 b=aKVRnAYXnGSizAt71n1Mdm4doA+9DNJgGk51onj7vNSO+ck77AVKZpkuAdRZRMdQjGJT
 S2kg9BluAUDn3QKoBqzXb7KJMQx3NoyLwKsaF6uCCzpQr7el4zyY7Qv5phUlMTByNcob
 t/K0xAhFx7Ll24vELNXSEzKbap71ySBxJ1ZQHibL64vMhOj4EdcHGnyGm2Ws/QzBKMjv
 cPaBmaL2iP2cxWjBWD3f8qtkElYnYa1FTYMggfnPA+cVHlR1ZBIQWaA4cOhi+bWcicib
 oLoUHK4ePZMzBJEWUgBQ8vNSFQsGRRO+D/jVAjsXWrWmJobqCpH6doxWfLs9GedNu2Mz Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74wdrdaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBKQ5D029735
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:06 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n74wdrd9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:06 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30JA1hSA013361;
        Thu, 19 Jan 2023 11:41:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16ctv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:04 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf0Or20381998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC7ED20049;
        Thu, 19 Jan 2023 11:41:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7603420040;
        Thu, 19 Jan 2023 11:41:00 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:00 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/8] Some cleanup patches
Date:   Thu, 19 Jan 2023 12:40:37 +0100
Message-Id: <20230119114045.34553-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HFvfnM8D8c0EY1uPj0_9GNqCL9yL68SS
X-Proofpoint-ORIG-GUID: Ne101CvrJA9eUuIdCxGljF6pV3I4-nSV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series should be applied on top of Janosch's patch series
([kvm-unit-tests PATCH v2 1/7] s390x: Cleanup flat.lds).

Changelog:
v1->v2:
 + worked in comments from Claudio and Janosch
 + added r-b's from Janosch
 + added a new patch: `s390x/Makefile: add an extra `%.aux.o` target`

Marc Hartmayer (8):
  .gitignore: ignore `s390x/comm.key` file
  s390x/Makefile: simplify `%.hdr` target rules
  s390x/Makefile: fix `*.gbin` target dependencies
  s390x/Makefile: refactor CPPFLAGS
  s390x: use C pre-processor for linker script generation
  s390x: define a macro for the stack frame size
  lib/linux/const.h: test for `__ASSEMBLER__` as well
  s390x/Makefile: add an extra `%.aux.o` target

 .gitignore                                  |  2 ++
 lib/linux/const.h                           |  2 +-
 lib/s390x/asm-offsets.c                     |  1 +
 s390x/Makefile                              | 33 +++++++++++----------
 s390x/cstart64.S                            |  2 +-
 s390x/{flat.lds => flat.lds.S}              |  4 ++-
 s390x/gs.c                                  |  5 ++--
 s390x/macros.S                              |  4 +--
 s390x/snippets/asm/{flat.lds => flat.lds.S} |  0
 s390x/snippets/c/{flat.lds => flat.lds.S}   |  6 ++--
 10 files changed, 35 insertions(+), 24 deletions(-)
 rename s390x/{flat.lds => flat.lds.S} (93%)
 rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
 rename s390x/snippets/c/{flat.lds => flat.lds.S} (88%)

-- 
2.34.1

