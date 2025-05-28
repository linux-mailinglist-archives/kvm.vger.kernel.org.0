Return-Path: <kvm+bounces-47865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C626BAC6658
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A3D74E1896
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477C327933F;
	Wed, 28 May 2025 09:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YGifMXx/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D9F27584C;
	Wed, 28 May 2025 09:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426117; cv=none; b=i51w0cKiWkow5lCg0YUUiiAggrHpQaiOWq1FWyGwDxJ46KKIN2wJsjPm6aOnSyABkCmHhez+OW5DspE1kOd3MUczKn6fO8U1HLRTkIh/WvvqkzV5UcviA0UPo3RoXRJytQLP674xHYFQdygf8ZhFq4ZOqBV+vdUYJ5TApSBfI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426117; c=relaxed/simple;
	bh=qxS8rQ60AEViIgdrw+xI0tC+FwrU/h7kHCn4xV2Hc6w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nt/wcuC2HzWgzu7Qi0JiBcBjkxsD6rkenGUcz6wuamdLDZwOOYpZfpWzv5JDX18ffi5brpRuXXetuvsLvRQfis25WF80+KOwrpPc5UyHd1w7GoZHfTuU9KGFsH9EY22rTEduPdwKqbYFVSf2TbAyuOQmiMWcpPlqS86BS/YVhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YGifMXx/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S0THbI017273;
	Wed, 28 May 2025 09:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=t5ypxL8g/1zbo9Ow9aBonSYjXan8wQvPyIBjMtpBm
	KY=; b=YGifMXx/yGD+gWcsVhlvBDLC0vseYGWgSTyUuJvBTq21kOQpHSFeMaWz6
	l6mVus60aWM1tNvnX33JEHnGlflcp8mPdS0EL8h6Nn1nBmHvYzKj22PeKI8oDTjV
	MeCVAqV6ByGR4tYpOsC55VetzG26QvlkpcDTEEnFh5ECSN/hntRc8iyzgRsLeE/s
	LQ4hOk4Tgz8iUnHr/DFz587XMi0GLiyI9Vf238KmUwcV9hz/glEBYZ0HN+FkzoKe
	p4cTumsBjcN++2n+i3gdx/dk4kntwhfnJ9d80j2TJDMKxLQq7whdNzcldJk//ZKc
	WEgX13evS1rGjdjmoIIz+JDY4eD+A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wgsgm1xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6FFZb016139;
	Wed, 28 May 2025 09:55:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46ureuf5he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9t8S754198580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:55:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C219B2004D;
	Wed, 28 May 2025 09:55:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EF7320043;
	Wed, 28 May 2025 09:55:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:55:07 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v5 0/4] KVM: s390: Some cleanup and small fixes
Date: Wed, 28 May 2025 11:54:58 +0200
Message-ID: <20250528095502.226213-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w98MoOY6b-ZR0tIdYVKuv_7Sc8q866uo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfX4tW+vsASkMZo qc+lgvjdjA9PAtZojA/NrD1ZpG9wUeuFI3kNsYit8ZmN3T3cOLfXGEXCKAH0Oy/ob/hhqzZ+H9m DKQDYTF1gYPHDeFS0HCOWAkNxe8DxRyfMhd5ZVK7bfC1uCnK2aJxwzESmmqs+0zCe5FcLeckJc3
 7QSgmx4sBvL4Q6E3eFP1+F6m2R85y1UKkpk2+SSCfMCIKvxn+SFUGhQfNVzArY5+koRFQuUiDpK /ivGsG6Ja1NwyVg4J9CvPaFIZhK/k//CfL2fubHD6OAatr76nlbok47KUMXvjZuSz66PmUnagek 5RL72gElgpd2zs32AeOvk4w3tbOMogf74z1d+dZOSn9fJNEP5kGOJtiXeHau7EdJuC/fZCocIbb
 WtCmM5F+N/T7/Fi5Nksj5gZzUhy7rdkjkE7rqzza0XkjcWc1KMa+3qy5F7kCPn/P0u2/NarD
X-Authority-Analysis: v=2.4 cv=bZRrUPPB c=1 sm=1 tr=0 ts=6836dd81 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=gRRxI3zbkkyk7srOQjYA:9
X-Proofpoint-GUID: w98MoOY6b-ZR0tIdYVKuv_7Sc8q866uo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=670 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

This series has some cleanups and small fixes in preparation of the
upcoming series that will finally completely move all guest page table
handling into kvm. The cleaups and fixes in this series are good enough
on their own, hence why they are being sent now.

v4->v5
* add missing #include <linux/swap.h> to mm/gmap_helpers.c (thanks
  kernel test robot)
* fix diag_release_pages(), I had accidentally removed the guest
  absolute to qemu virtual address translation
* fix patch subject lines (thanks Heiko)

v3->v4
* remove orphaned find_zeropage_ops and find_zeropage_pte_entry() from
  mm/gmap.c (thanks kernel test robot)
* add missing #include <linux/swapops.h> to mm/gmap_helpers.c (thanks
  kernel test robot)

v2->v3  (mainly addresses Nina's and Heiko's comments)
* drop patch 3 - it was just an attempt to clean up the code a little
  and make it more readable, but there were too many issues to address
* remove all dead code from s390/mm/gmap.c that is being replaced by
  code in s390/mm/gmap_helpers.c
* remove a couple of unused functions from s390/mm/gmap_helpers.c, some
  of them will be introduced again in a later series when they are
  actually needed
* added documentation to the functions in s390/mm/gmap_helpers.c
* general readability improvements

v1->v2
* remove uneeded "gmap.h" include from gaccess.c (thanks Christph)
* use a custom helper instead of u64_replace_bits() (thanks Nina)
* new helper functions in priv.c to increase readability (thanks Nina)
* add lockdep assertion in handle_essa() (thanks Nina)
* gmap_helper_disable_cow_sharing() will not take the mmap lock, and
  must now be called while already holding the mmap lock in write mode


Claudio Imbrenda (4):
  s390: Remove unneeded includes
  KVM: s390: Remove unneeded srcu lock
  KVM: s390: Refactor and split some gmap helpers
  KVM: s390: Simplify and move pv code

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap.h         |   2 -
 arch/s390/include/asm/gmap_helpers.h |  15 ++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  12 +-
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  30 +++-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 ---------------
 arch/s390/kvm/gmap.h                 |  39 -----
 arch/s390/kvm/intercept.c            |   9 +-
 arch/s390/kvm/kvm-s390.c             |  10 +-
 arch/s390/kvm/kvm-s390.h             |  42 +++++
 arch/s390/kvm/priv.c                 |   6 +-
 arch/s390/kvm/pv.c                   |  61 +++++++-
 arch/s390/kvm/vsie.c                 |  19 ++-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  | 185 +---------------------
 arch/s390/mm/gmap_helpers.c          | 221 +++++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 25 files changed, 410 insertions(+), 379 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

-- 
2.49.0


