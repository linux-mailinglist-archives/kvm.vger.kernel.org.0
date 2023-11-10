Return-Path: <kvm+bounces-1460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624347E7CA8
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA7DD281486
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4281B279;
	Fri, 10 Nov 2023 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OrOzxive"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851681A26B
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:20 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C656E3821D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:18 -0800 (PST)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADnk7j014940;
	Fri, 10 Nov 2023 13:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=2ZGvhXxn3pWYz5mT8VvJnC0ERysaMmv4er3yIH1kBks=;
 b=OrOzxiveiCkJUtygnDsvPnNuhqkVszEoGmccritN+KSORI7DqVViwE8jMptwtlb2bCvj
 9VboTNZN17+mnW82J5i+mmDczVQFfm7NuXGPBHBgyzMvR0ukV8u+dagijh1hZwBpn5tV
 r3sZ33xOOZIOy90c5x4+crSOx3oJU+dGNnfBG/Nsx4al6mhpmMhhPr95oG1CTPvloV9S
 yvcF/HUEi/aZks5QkPIlXqVIjSoRTgCfZw/JBxgQtN5NUWUnhkXjarQ5xDtEQypX3Cyf
 0gd339VuZpwZPrDsbLlZEi2TiTaK8x35/FikZRvnsEEFcXuV3tkUCOVHyxtS1tVwbj0l 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrag4xb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:06 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADokww017862;
	Fri, 10 Nov 2023 13:54:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nrag4wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:06 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAAvM2A019256;
	Fri, 10 Nov 2023 13:54:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w24b6ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADs2FL37683838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51B842004B;
	Fri, 10 Nov 2023 13:54:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0717620043;
	Fri, 10 Nov 2023 13:54:00 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:53:59 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/26] s390x: multiline unittests.cfg, sclp enhancements, topology fixes and improvements, sie without MSO/MSL, 2G guest alignment, bug fixes
Date: Fri, 10 Nov 2023 14:52:09 +0100
Message-ID: <20231110135348.245156-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I6Rn6OVTZvdmAvyqzzReNqACqWH3lnid
X-Proofpoint-ORIG-GUID: jp7DTB5TD4bMzzLaNV6YxwjOP6hYpgSz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=925 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

Hi Paolo and/or Thomas,

lots of code for s390x has accumulated, so it's time for another PR :)

Please note that this PR includes a common code change from Nina (see below).

Changes in this pull request:

* Nina contributed multiline support for unittests.cfg in common code,
* Janosch contributed enhancements for the sclp console,
* Nina fixed some issues in the topology tests and improved coverage,
* I've added support for running sie() tests without MSO/MSL,
* kvm-unit-tests is now compatible with environments which require 2GB alignment
  of guests in SIE,
* several smaller improvements and bug fixes.

Thanks
Nico

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/48

PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/1067877258

PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2023-11-09
----
The following changes since commit bfe5d7d0e14c8199d134df84d6ae8487a9772c48:

  migration: Fix test harness hang if source does not reach migration point (2023-10-19 10:06:54 +0200)

are available in the Git repository at:

  https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2023-11-09

for you to fetch changes up to bb88caeff9dd2ee57511bc9efbb742a8d6197903:

  lib: s390x: interrupt: remove TEID_ASCE defines (2023-11-10 09:50:33 +0100)

----------------------------------------------------------------
Janosch Frank (3):
      lib: s390x: hw: rework do_detect_host so we don't need allocation
      lib: s390x: sclp: Add compat handling for HMC ASCII consoles
      lib: s390x: sclp: Add line mode input handling

Nico Boehr (13):
      s390x: spec_ex: load full register
      s390x: run PV guests with confidential guest enabled
      s390x: spec_ex-sie: refactor to use snippet API
      s390x: sie: ensure guests are aligned to 2GB
      s390x: mvpg-sie: fix virtual-physical address confusion
      lib: s390x: introduce bitfield for PSW mask
      s390x: add function to set DAT mode for all interrupts
      s390x: sie: switch to home space mode before entering SIE
      s390x: lib: don't forward PSW when handling exception in SIE
      s390x: lib: sie: don't reenter SIE on pgm int
      s390x: add test source dir to include paths
      s390x: add a test for SIE without MSO/MSL
      lib: s390x: interrupt: remove TEID_ASCE defines

Nina Schoetterl-Glausch (10):
      s390x: topology: Introduce enums for polarization & cpu type
      s390x: topology: Fix report message
      s390x: topology: Use function parameter in stsi_get_sysib
      s390x: topology: Fix parsing loop
      s390x: topology: Make some report messages unique
      s390x: topology: Refine stsi header test
      s390x: topology: Rename topology_core to topology_cpu
      s390x: topology: Rewrite topology list test
      scripts: Implement multiline strings for extra_params
      s390x: topology: Add complex topology test

 lib/s390x/asm/arch_def.h   |  36 ++++++-
 lib/s390x/asm/interrupt.h  |  21 ++++-
 lib/s390x/asm/mem.h        |   1 +
 lib/s390x/hardware.c       |  11 +--
 lib/s390x/interrupt.c      |  36 +++++++
 lib/s390x/mmu.c            |   5 +-
 lib/s390x/sclp-console.c   | 206 +++++++++++++++++++++++++++++++++++-----
 lib/s390x/sclp.h           |  26 ++++-
 lib/s390x/sie.c            |  75 ++++++++++++++-
 lib/s390x/sie.h            |   2 +
 lib/s390x/snippet.h        |   9 +-
 lib/s390x/stsi.h           |  47 ++++++---
 s390x/Makefile             |   4 +-
 s390x/mvpg-sie.c           |  16 +++-
 s390x/run                  |  19 +++-
 s390x/selftest.c           |  34 +++++++
 s390x/sie-dat.c            | 114 ++++++++++++++++++++++
 s390x/sie.c                |   4 +-
 s390x/snippets/c/sie-dat.c |  57 +++++++++++
 s390x/snippets/c/sie-dat.h |   2 +
 s390x/spec_ex-sie.c        |  13 ++-
 s390x/spec_ex.c            |   2 +-
 s390x/topology.c           | 230 ++++++++++++++++++++++++++++-----------------
 s390x/unittests.cfg        | 136 +++++++++++++++++++++++++++
 scripts/common.bash        |  16 ++++
 scripts/runtime.bash       |   4 +-
 26 files changed, 960 insertions(+), 166 deletions(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.h

