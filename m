Return-Path: <kvm+bounces-15788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB3F8B07E2
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97CD62823A1
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A2815ADA4;
	Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NfADR42o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04A715991C
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956394; cv=none; b=J4yUHsj2kNyHPYajY2lJKJzwsCx2hhFdcD6zpWXSY51xpKzzSJzB7ck0rPpAxoQaZ/XufghoLVp9kPHdSP1Ulyr3YFFzq3KcM4LpusTn9sRddhHJXmj9ho5780B9MjEZV0mBVhYtOkG1lgZGVD2ew4jmFGyLg2J/YKCY/7ezTSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956394; c=relaxed/simple;
	bh=iErB9LOQ3smJIJRJkL/lRaBW7P2QniQb2c46P12fiTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ezFLFxVwTpxgE2cTFP5dnzZNGgOB3ObAvLmD953LZ7baZ+4BNogBkNUzbv/TsSV61SPkZa1o9hK4Jo0IrBOw0I8tRYNiCKIDbba8TBGLt4jgb93iqq/pq6UemDoMQ3M6gsTQBU2UZZMz9ytclNhXyc100To7iLYj4hIBuPjoq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NfADR42o; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAOvCG012285;
	Wed, 24 Apr 2024 10:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=3LfDvLG+E7Fqd0bL5pwZgct08Zr1Sg2osbRZCQ4G6/I=;
 b=NfADR42ohHpvC07tb9VMdVNULWgbcl5YQq10GMB60nXTMW2Q8XAPecp2J+cTFqpPr6+l
 XXeWb+TWzkkwwUZ4cxxZf9LKLVWg5gh4eXEdl/Q5yunhGn/7RVdqrhFyiFZ5xIepgfBX
 kPymdp8z87q9wbJf71uJEa6h+IBH/ThzBwhcpChMGuqXpkDcmSi3SS4FAnhviONOgD/y
 OBGNkIBc38Keh5Mzlk+YRdA5lTG5Q9oL6TXk9xNNPgi9twcFNQPuwCSFq7Gc3TUBsD6B
 j2VGeNR9jxs1XbIiV4AIMvoIvDnO09FBULdVNc4qFe7HdPz99tEHqHmBWkOxV9+PlMzI fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxjeY031245;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O81EbQ023051;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1p36vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxcED33882458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BB0A2004D;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B0820043;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/13] s390x: Improvement of CMM test, lot of small bugfixes and two refactorings
Date: Wed, 24 Apr 2024 12:59:19 +0200
Message-ID: <20240424105935.184138-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uICI67LW-rS5JkA41VBG4dsncu-Kie48
X-Proofpoint-ORIG-GUID: u88s8ugLBgRrgQ1s2MX_NvD_HmDAQOEz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240045

Hi Paolo and/or Thomas,

not much has happened, but a few smaller things have accumulated, so time for a
PR.

Changes in this pull request:

Just a single new test:
* test CMM no-translate bit after reset

A lot of smaller fixes:
* fix for secure guest size by Claudio
* fixes for shell script issues by Nicholas
* fix in error path of emulator test by Christian
* dirty condition code fixes by Janosch
* pv-attest missing from unittests.cfg

And, last but not least, two refactorings:
* simplification of secure boot image creation by Marc
* name inline assembly arguments in sigp lib by Janosch

Thanks
Nico

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/58

PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/1264518225

PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2024-04-22
----
The following changes since commit 69ee03b0598ee49f75ebab5cd0fe39bf18c1146e:

  Merge branch 'arm/queue' into 'master' (2024-04-19 10:41:39 +0000)

are available in the Git repository at:

  https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2024-04-22

for you to fetch changes up to 7315fc8a182e50e5c2f387812cd178b433a40cea:

  s390x: cmm: test no-translate bit after reset (2024-04-23 15:10:35 +0200)

----------------------------------------------------------------
Christian Borntraeger (1):
      s390x: emulator: Fix error path of invalid function code

Claudio Imbrenda (1):
      lib: s390: fix guest length in uv_create_guest()

Janosch Frank (6):
      lib: s390x: sigp: Dirty CC before sigp execution
      lib: s390x: uv: Dirty CC before uvc execution
      lib: s390x: css: Dirty CC before css instructions
      s390x: mvpg: Dirty CC before mvpg execution
      s390x: sclp: Dirty CC before sclp execution
      lib: s390x: sigp: Name inline assembly arguments

Marc Hartmayer (1):
      s390x/Makefile: simplify Secure Execution boot image generation

Nicholas Piggin (2):
      s390x: Fix is_pv check in run script
      s390x: Use local accel variable in arch_cmd_s390x

Nico Boehr (2):
      s390x: add pv-attest to unittests.cfg
      s390x: cmm: test no-translate bit after reset

 lib/s390x/asm/sigp.h    | 12 ++++++++----
 lib/s390x/asm/uv.h      |  4 +++-
 lib/s390x/css.h         | 16 ++++++++++++----
 lib/s390x/uv.c          |  2 +-
 s390x/Makefile          | 36 +++++++++++++++---------------------
 s390x/cmm.c             | 34 ++++++++++++++++++++++++++++++++++
 s390x/emulator.c        |  2 +-
 s390x/mvpg.c            |  6 ++++--
 s390x/run               |  8 ++++----
 s390x/sclp.c            |  5 ++++-
 s390x/unittests.cfg     |  3 +++
 scripts/s390x/func.bash |  2 +-
 12 files changed, 90 insertions(+), 40 deletions(-)

