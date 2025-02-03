Return-Path: <kvm+bounces-37109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85572A2548A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 075C51627F6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA91207A28;
	Mon,  3 Feb 2025 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CuZ6yDSF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88850206F19
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571809; cv=none; b=UaWZM3mjShMGzXZ/XaUmwrykhJPsXvttMSm9DgufW+hNt9GzxyceWt6DsxyWJdkSBtv9e2+cAuUys78uU3tNnPv613XKlv2hvuuQaM9e1qM5zEjS2bxHpwiDQ/13W2w2OoJ1aYhhh4ec9YpVkV9YYWTcyqEQnrJaDd9bY/2noWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571809; c=relaxed/simple;
	bh=6P5z+4LJU18rE1I/34p8nPTX4NPOt1cL9y1MPI1fA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAOXbQ70xNXm1Lw7das4pqztOovf5NzsUl+GldSuDGwn1yIAu9rdwl0JsAOUokpj2xjpZQljBOwoqUq0GwNv5LDy+7bkMNTN3iExTN2ZNMSVuH1cFajjNDQ+hJo5lUoBNIo4uKZjld1vFoh6HsLbbv+M2CZAVlJNS+7kxygS2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CuZ6yDSF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51320sRi006368;
	Mon, 3 Feb 2025 08:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=xzlLtiA3mZb/MH0jgyn0Azh1HII9nu7nBrzomFcGV
	Bw=; b=CuZ6yDSFaKmiSNJC5w970QG6OzdhHy8v/fN6isL+zkewOmL24pyvqj7Ma
	f7LYeQMapz6dYcLjyIl8o6Vpl8NKMR3UDFbc310ZXI3OVwV7+NiVYmW44I+TVPxu
	jiud7PMH9PKwFQMC7XC3PDMEYV+epQ0r7z+5WvbFtN5WTICFJ+ZYdtXHDrY1i5D1
	UQDtYDqEp7sBSE7L5pylMgc+nuKz52i+dHBvnBidb886exY951Gn/QkvyhERCWLN
	wSdKux9is8k2kYjx2SG8fZ8b9beMiVVB3Xetg4PGEzpNJIMsZv8UzqzwYr2u6T+T
	KjC7dq5vBHqQLTrJ1AF85QP7lIcEg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jmmy9cbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134v9EZ021493;
	Mon, 3 Feb 2025 08:36:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j0n153fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aOMP56623386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42FF320043;
	Mon,  3 Feb 2025 08:36:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D140D20040;
	Mon,  3 Feb 2025 08:36:23 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:23 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/18] s390x: new edat, diag258 and STFLE tests; fixes for genprotimg >= 2.36.0; cleanups for snippets and makefiles
Date: Mon,  3 Feb 2025 09:35:08 +0100
Message-ID: <20250203083606.22864-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8LyvZCg_nbZ_GtXxSw6fDqFY-APSrocO
X-Proofpoint-ORIG-GUID: 8LyvZCg_nbZ_GtXxSw6fDqFY-APSrocO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

Hi Paolo and/or Thomas,

Changes in this pull request:
- cpacf query function were reworked in the kernel, that fix was
  cherry-picked by Nina. This fixes issues with possible incorrect
  instruction format
- Claudio extended the edat test for a special case with a 2G page at
  the end of memory to ensure the correct addressing exception happens.
- I added a test for diag258 where we had some issues with
  virtual-physical address confusion.
- Nina took the time to add library functions that help exiting from a
  snippet s390x.
- Nina contributed a test for STFLE interpretive execution. Thank you!
- Marc did a lot of magic fixing issues in our Makefiles. This fixes
  several issues with out-of-tree-builds. We now also build out-of-tree
  in our downstream CI to avoid unpleasant surprises for maintainers :)
  Marc, thanks for contributing your Makefile knowledge and for turning my
  complaints into something productive
- Janosch also invested some time to clean up snippets and Makefiles,
  which made the code a lot nicer, thanks for that as well!
- we have a compatibility issue with genprotimg
  versions >= 2.36.0. Thanks Marc to fixing that. You should upgrade
  kvm-unit-tests if you use genprotimg >= 2.36.0!

Note that there are two checkpatch errors:
> ERROR: space prohibited before that ':' (ctx:WxW)
I would suggest to ignore them, the code really looks ugly otherwise.

Thanks
Nico

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/73

PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/1650287644

PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2025-01-31
----
The following changes since commit 2e66bb4b9423970ceb6ea195bd8697733bcd9071:

  Makefile: Use 'vpath' for out-of-source builds and not 'VPATH' (2025-01-31 10:40:51 +0100)

are available in the Git repository at:

  https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2025-01-31

for you to fetch changes up to 12b23c79ac6c5af4f9351c7502c4a3ffccf4b8eb:

  s390x/Makefile: Add auxinfo.o to cflatobjs (2025-01-31 13:02:25 +0100)

----------------------------------------------------------------
Claudio Imbrenda (1):
      s390x: edat: test 2G large page spanning end of memory

Janosch Frank (4):
      s390x/Makefile: Split snippet makefile rules into new file
      s390x/Makefile: Add more comments
      s390x: Move SIE assembly into new file
      lib: s390x: Split SIE fw structs from lib structs

Marc Hartmayer (4):
      s390x/Makefile: snippets: Add separate target for the ELF snippets
      s390x: Support newer version of genprotimg
      s390x/Makefile: Make sure the linker script is generated in the build directory
      s390x/Makefile: Add auxinfo.o to cflatobjs

Nico Boehr (2):
      s390x: edat: move LC_SIZE to arch_def.h
      s390x: add test for diag258

Nina Schoetterl-Glausch (7):
      s390x: Split and rework cpacf query functions
      s390x: lib: Remove double include
      s390x: Add sie_is_pv
      s390x: Add function for checking diagnose intercepts
      s390x: Add library functions for exiting from snippet
      s390x: Use library functions for snippet exit
      s390x: Add test for STFLE interpretive execution (format-0)

 lib/s390x/asm/arch_def.h          |  17 +++
 lib/s390x/asm/cpacf.h             |  77 ++++++++++--
 lib/s390x/asm/facility.h          |  10 +-
 lib/s390x/asm/sie-arch.h          | 238 +++++++++++++++++++++++++++++++++++
 lib/s390x/pv_icptdata.h           |  42 -------
 lib/s390x/sie-icpt.c              |  60 +++++++++
 lib/s390x/sie-icpt.h              |  39 ++++++
 lib/s390x/sie.c                   |   5 +-
 lib/s390x/sie.h                   | 237 ++--------------------------------
 lib/s390x/snippet-exit.h          |  45 +++++++
 s390x/Makefile                    |  75 ++++++-----
 s390x/cpu-sie.S                   |  74 +++++++++++
 s390x/cpu.S                       |  64 ----------
 s390x/diag258.c                   | 259 ++++++++++++++++++++++++++++++++++++++
 s390x/edat.c                      |  19 ++-
 s390x/pv-diags.c                  |   9 +-
 s390x/pv-icptcode.c               |  12 +-
 s390x/pv-ipl.c                    |   8 +-
 s390x/sie-dat.c                   |  12 +-
 s390x/snippets/Makefile           |  35 ++++++
 s390x/snippets/c/sie-dat.c        |  19 +--
 s390x/snippets/c/stfle.c          |  29 +++++
 s390x/snippets/lib/snippet-exit.h |  28 +++++
 s390x/stfle-sie.c                 | 138 ++++++++++++++++++++
 s390x/unittests.cfg               |   6 +
 25 files changed, 1124 insertions(+), 433 deletions(-)
 create mode 100644 lib/s390x/asm/sie-arch.h
 delete mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 lib/s390x/sie-icpt.c
 create mode 100644 lib/s390x/sie-icpt.h
 create mode 100644 lib/s390x/snippet-exit.h
 create mode 100644 s390x/cpu-sie.S
 create mode 100644 s390x/diag258.c
 create mode 100644 s390x/snippets/Makefile
 create mode 100644 s390x/snippets/c/stfle.c
 create mode 100644 s390x/snippets/lib/snippet-exit.h
 create mode 100644 s390x/stfle-sie.c

