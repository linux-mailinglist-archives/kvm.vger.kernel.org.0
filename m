Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5396679FF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbjALP5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjALP40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:56:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB775B169;
        Thu, 12 Jan 2023 07:46:38 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFXCdk018161;
        Thu, 12 Jan 2023 15:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Po4Z9g63qLbcIpDff3bFXjhcxIOKTNLi7VkVkIX1fNs=;
 b=s+uMyP7pzKi/cT6ftqyibh0e3Z7ZUYQR7cPBxWlX3NTaiWaz3GG0giXClJyxgIeAqj66
 O25MPioc5urFXmvlNjvXpU8iJdwe3rfBemDijJk7PvM9v5CYCTBmK55dZGR6RhF19AfM
 uQlF9tdXy3hrk/vlY4fz+W+NgxblAAZz+P5PxzAcr26iVUmnRJacEp47IZlYC/uvEIu4
 Z++qpTrhATjYY83wx5QC4jF8RCqwB72GpWXJ43j1ZJYY3j4F0qyuQQu/oELyjF/3JKR4
 QnCUvYyUQS/N2Yi/YrqWzkgcLwEd56oElhDUZFuRzTYpyt54dLnIajh8A3XrDUJTRCYO ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mxwge4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CFaN2c028801;
        Thu, 12 Jan 2023 15:46:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mxwge48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CCVoQU003398;
        Thu, 12 Jan 2023 15:46:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n1kmthydq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CFkVqV50987286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 15:46:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D6220040;
        Thu, 12 Jan 2023 15:46:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 834E620043;
        Thu, 12 Jan 2023 15:46:31 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 15:46:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/7] s390x: Snippet fixes
Date:   Thu, 12 Jan 2023 15:45:41 +0000
Message-Id: <20230112154548.163021-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FBolfFwj-sMMrC5qdeTUC5E89SOi12Ci
X-Proofpoint-ORIG-GUID: omE8xgrsyGPNeg-sPGPTpwf90E3SSG6s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=920
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small set of fixes mostly related to the snippet support and error
management.

v2:
	* Added basic linker script cleanups
	  * Changed alignment from 64k to 4k
	  * Added more comments
	  * Removed unneeded sections
	* This patch set is a also preparation for a larger loader
          script change by Marc

Janosch Frank (7):
  s390x: Cleanup flat.lds
  s390x: snippets: c: Cleanup flat.lds
  s390x: Add a linker script to assembly snippets
  s390x: snippets: Fix SET_PSW_NEW_ADDR macro
  lib: s390x: sie: Set guest memory pointer
  s390x: Clear first stack frame and end backtrace early
  lib: s390x: Handle debug prints for SIE exceptions correctly

 lib/s390x/interrupt.c              | 46 ++++++++++++++++++++++++++----
 lib/s390x/sie.c                    |  1 +
 lib/s390x/sie.h                    |  2 ++
 lib/s390x/snippet.h                |  3 +-
 lib/s390x/stack.c                  |  2 ++
 s390x/Makefile                     |  5 ++--
 s390x/cpu.S                        |  6 ++--
 s390x/cstart64.S                   |  2 ++
 s390x/flat.lds                     | 19 +++---------
 s390x/mvpg-sie.c                   |  2 +-
 s390x/pv-diags.c                   |  6 ++--
 s390x/snippets/{c => asm}/flat.lds | 39 +++++++++----------------
 s390x/snippets/asm/macros.S        |  2 +-
 s390x/snippets/c/flat.lds          | 28 ++++++------------
 14 files changed, 87 insertions(+), 76 deletions(-)
 copy s390x/snippets/{c => asm}/flat.lds (55%)

-- 
2.34.1

