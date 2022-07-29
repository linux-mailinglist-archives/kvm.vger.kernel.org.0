Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA1584D58
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiG2I2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiG2I2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7265583202
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:17 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8Gi86029372
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WS2M5BDmB4yB4xxJdTHP2A7E5DOfgj1M3zzj06/3HKs=;
 b=UzR0KtRVPOmPrAAqe09NNLIc0BIpcNNFmJm5EbJSFK/qmV23JP/u/6wUTpZfZ7+yRGow
 zFxli3t6NcV+307ur/5HpW9oi5PIkgI6qmTkwQ07EcrvP/Tf66Xk5PEWOJSb+xZHRToo
 W9D76uXpx1mpg6XIBNB2XZl9aw05lOLyPMvdIg94cOjicf9JZOCZJbuJKL0jMwyAirH5
 0z/K15DI3BS5aqP5TJi8YkP+LnlgFROmsNCaObDZLeajqcBCmMuhcUF3O3tBlFFMRRz2
 7SBliV/2lyqwM/1r7SVfsXZv6FeyQaRzp1v61EFZswqUDdZKeD0beCGwgZ/rzt83OTbV cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbw9g82s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:16 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8HwNU003676
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbw9g81q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8LE3G009709;
        Fri, 29 Jul 2022 08:27:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97tfaxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8RBaS32178512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFCB052051;
        Fri, 29 Jul 2022 08:27:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 429665204E;
        Fri, 29 Jul 2022 08:27:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/6] s390x: PV fixups
Date:   Fri, 29 Jul 2022 08:26:27 +0000
Message-Id: <20220729082633.277240-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1LsMsHfE4jTFT1GQTrL4gDhYZDLiga27
X-Proofpoint-ORIG-GUID: Pk4-vqu2fDZXXuN8aDFY9zWTldwdIUmd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=815 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207290032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small set of patches that clean up the PV snippet handling.

Janosch Frank (6):
  s390x: snippets: asm: Add a macro to write an exception PSW
  s390x: MAKEFILE: Use $< instead of pathsubst
  s390x: Add a linker script to assembly snippets
  lib: s390x: sie: Improve validity handling and make it vm specific
  lib: s390x: Use a new asce for each PV guest
  lib: s390x: sie: Properly populate SCA

 lib/s390x/asm-offsets.c                  |  2 ++
 lib/s390x/sie.c                          | 36 +++++++++++++-------
 lib/s390x/sie.h                          | 43 ++++++++++++++++++++++--
 lib/s390x/snippet.h                      |  3 +-
 lib/s390x/uv.c                           | 35 +++++++++++++++++--
 lib/s390x/uv.h                           |  5 ++-
 s390x/Makefile                           | 18 +++++++---
 s390x/cpu.S                              |  6 ++++
 s390x/mvpg-sie.c                         |  2 +-
 s390x/pv-diags.c                         |  6 ++--
 s390x/snippets/asm/macros.S              | 28 +++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S |  4 +--
 s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++--
 13 files changed, 157 insertions(+), 37 deletions(-)
 create mode 100644 s390x/snippets/asm/macros.S

-- 
2.34.1

