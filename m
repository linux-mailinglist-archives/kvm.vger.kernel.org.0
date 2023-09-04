Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8267791349
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352552AbjIDIXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjIDIXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:23:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0537118;
        Mon,  4 Sep 2023 01:23:24 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38489R8S030264;
        Mon, 4 Sep 2023 08:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Z2+eQgPUlqNLwk0TA48I+41KBK/CX+qyq9PG/BzsBcw=;
 b=VaLCDrKejA887cSxOlvribdMO4D23vP5ojIpA2/VkaUI2kUHF+cCFdfgW3U5wY9KBC5c
 vMgBcrQD8/WzCFPFU2ZY3y36trUY9y92SouVQ/8BlJ4Grz/oFwwYjYR5YAwNRbOcsFI5
 Nj+ZKXUS2PfbP7ahBPVeiYvEmUw9epk0ALE2hz16OlxtRvmE4XaoyEP8B2k893bUjo7c
 Z8bCDsOeZwLXToc1D2xvEu+OkuaAWJeXcjKtRw7ovKLt66Ya/1Lvh8mH+rHwvtddoj6I
 qr7r/rZLemtNBOORAmNSxogy7W+qAlA62rDfjlVLxwHIQM0unXtHmSgKfgX7b2yY88M/ 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7s755x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:23 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3848BrWb006490;
        Mon, 4 Sep 2023 08:23:23 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7s755wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:23 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3846rBva011108;
        Mon, 4 Sep 2023 08:23:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svj318ega-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3848NJqa23266014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 08:23:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0604620043;
        Mon,  4 Sep 2023 08:23:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C424E20040;
        Mon,  4 Sep 2023 08:23:18 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 08:23:18 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 0/8] s390x: Add support for running guests without MSO/MSL
Date:   Mon,  4 Sep 2023 10:22:18 +0200
Message-ID: <20230904082318.1465055-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K0HuOTUd3MIDRe9XOGZf2ZmwE51U-tZB
X-Proofpoint-GUID: _6Snk4B3HLw9nAsfQBryLsGSqny0GwTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_05,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 mlxlogscore=737 malwarescore=0 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2309040072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v6:
---
* add commit "s390x: add test source dir to include paths" and share define with number of pages between snippet and test (Thomas)
* add commit "lib: s390x: interrupt: remove TEID_ASCE defines"
* rename dat -> use_dat (thanks Thomas)
* remove IRQ_DAT_ON/_OFF defines (thanks Thomas)
* add a comment to explain why we switch to home space when entering SIE (thanks Thomas)
* clarify register_ext_cleanup_func() doesn't touch address space mode when DAT is off (thanks Thomas)
* convert address space defines to enum (thanks Thomas)
* switch bitfield member to uint64_t (thanks Claudio)
* upercase hex number
* in selftest, set the bitfield value to a define and then assert on the bitfield (thanks Thomas)

v5:
---
* fix a big oopsie in irq_set_dat_mode() which caused parts of lowcore being
  overwritten (thanks Claudio)

v4:
---
- add static assert for PSW bitfield (Janosch, Claudio)
- remove unneeded includes (Janosch)
- move variable decls to function start (Janosch)
- remove unneeded imports (Janosch)
- lowerocase hex (Janosch)
- remove unneeded attr (Janosch)
- tyop :-) fixes (Janosch)

v3:
---
* introduce bitfield for the PSW to make handling less clumsy
* some variable renames (Claudio)
* remove unneeded barriers (Claudio)
* remove rebase leftover sie_had_pgm_int (Claudio)
* move read_pgm_int_code to header (Claudio)
* squash include fix commit into the one causing the issue (Claudio)

v2:
---
* add function to change DAT/AS mode for all irq handlers (Janosch, Claudio)
* instead of a new flag in PROG0C, check the pgm int code in lowcore (Janosch)
* fix indents, comments (Nina)

Right now, all SIE tests in kvm-unit-tests (i.e. where kvm-unit-test is the
hypervisor) run using MSO/MSL.

This is convenient, because it's simple. But it also comes with
disadvantages, for example some features are unavailabe with MSO/MSL.

This series adds support for running guests without MSO/MSL with dedicated
guest page tables for the GPA->HPA translation.

Since SIE implicitly uses the primary space mode for the guest, the host
can't run in the primary space mode, too. To avoid moving all tests to the
home space mode, only switch to home space mode when it is actually needed.

This series also comes with various bugfixes that were caught while
develoing this.

Nico Boehr (8):
  lib: s390x: introduce bitfield for PSW mask
  s390x: add function to set DAT mode for all interrupts
  s390x: sie: switch to home space mode before entering SIE
  s390x: lib: don't forward PSW when handling exception in SIE
  s390x: lib: sie: don't reenter SIE on pgm int
  s390x: add test source dir to include paths
  s390x: add a test for SIE without MSO/MSL
  lib: s390x: interrupt: remove TEID_ASCE defines

 lib/s390x/asm/arch_def.h   |  37 +++++++++++--
 lib/s390x/asm/interrupt.h  |  21 +++++--
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/interrupt.c      |  36 ++++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  30 +++++++++-
 s390x/Makefile             |   4 +-
 s390x/selftest.c           |  34 ++++++++++++
 s390x/sie-dat.c            | 110 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  54 ++++++++++++++++++
 s390x/snippets/c/sie-dat.h |   5 ++
 s390x/unittests.cfg        |   3 +
 12 files changed, 326 insertions(+), 14 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.h

-- 
2.41.0

