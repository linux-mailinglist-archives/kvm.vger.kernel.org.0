Return-Path: <kvm+bounces-469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD11D7DFFFF
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D94A41C20A86
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB5F13FEF;
	Fri,  3 Nov 2023 09:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m4aPXRH6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499811C82
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 09:30:00 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2161AD;
	Fri,  3 Nov 2023 02:29:59 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A39D2YU013866;
	Fri, 3 Nov 2023 09:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YXYAwnUtHym5osNANq4ZZm1guANxxDAw0GD/oxyBUh8=;
 b=m4aPXRH6ZBF45YdDTmLWWuSXBcxRU0xiME/oVhR93lj9piD6lPPPmXmCxUt00wLG7yPy
 oRqn/QHEhB/mY9Pq4Z2MwHu0iOzRUiBuS7ou5rA1SVjZ0CncasCpc4O3bVBQ2bQtMsFH
 CT74UDpNjRHq4kNBLu58pBmnspa+IHaVJ3V6cJ7mkCg3gcEGzOwLrnw3suqiJIN2thUJ
 uIqCB3H5TpwYzg0tDUmE1fhe4e2+OQ2O6wVozbjuAkHnlvx0nWyTEj/EXpGgbThERSHT
 0n1DnZl2RpFgky3ZSLw76p6ZKbwyZJAO93iMp8s2uZdG70wjvEROioZLsTopP3bw981G gg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wpf92wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:58 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A39D7IF014588;
	Fri, 3 Nov 2023 09:29:58 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wpf92vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:58 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A37JmGn011268;
	Fri, 3 Nov 2023 09:29:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukmjga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A39TsqZ20906716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 09:29:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B11DB20040;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E3562004D;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 09:29:54 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 0/8] s390x: Add support for running guests without MSO/MSL
Date: Fri,  3 Nov 2023 10:29:29 +0100
Message-ID: <20231103092954.238491-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gHi10CTZm9VWzqOtv2vi5pFm_hUeM13E
X-Proofpoint-ORIG-GUID: wEso65Wu-vkdQjS0T31rMQcfP1mdlQH3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=913 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030078

v7:
---
* pick up r-bs
* fixup unneeded linebreak (thanks Janosch)
* remove outdated comments (thanks Janosch)
* remove unneeded includes (thanks Janosch)

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

 lib/s390x/asm/arch_def.h   |  36 ++++++++++--
 lib/s390x/asm/interrupt.h  |  21 +++++--
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/interrupt.c      |  36 ++++++++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sie.c            |  30 +++++++++-
 s390x/Makefile             |   4 +-
 s390x/selftest.c           |  34 ++++++++++++
 s390x/sie-dat.c            | 110 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  52 ++++++++++++++++++
 s390x/snippets/c/sie-dat.h |   2 +
 s390x/unittests.cfg        |   3 +
 12 files changed, 320 insertions(+), 14 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.h

-- 
2.41.0


