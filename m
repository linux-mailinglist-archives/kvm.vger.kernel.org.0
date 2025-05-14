Return-Path: <kvm+bounces-46520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F16A2AB71A5
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADB578C76EC
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2BB27F73A;
	Wed, 14 May 2025 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BwLCWmsg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37627B4FF;
	Wed, 14 May 2025 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240745; cv=none; b=GxplD20qZLysoL71N+Z/A3qtnIQx9LczQxLytKWpqLxH0LRegH45OFDX8Tf0LSnMd0m6fThX7qD5jiEQBLdKgw2DyFCkWk8IXEPy3d+LR7LezfjpjMAmP5QkBxsuru1U4v3qRhfkyuaNH9J33BRTgbKJXvqg7tEobYhNbtuJGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240745; c=relaxed/simple;
	bh=WAe2gBQcaFCatTHgCyLsYjR5j7NvnE+qJZNxR7cVc14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DFOe9Oeq0mKDkUxUG5YZlEAJLAjEPlnMjWQ1n178SwO4sbZDk4aFzw7s4LEyKP7JOFZheXuh8BZJfx3+BN/Id4rnC/xx/TLAIzsv3YySDHk8zZ2CB/4VhPTcPvNwKDevmFdsTC66KkqGewlBs/xwZ++DdgL4FNQPIHTRZ/fqJ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BwLCWmsg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDn6S0003586;
	Wed, 14 May 2025 16:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=eowll/TW0WD58NPvwR0O4PIW5Z3pU/gcEtw6ynQtt
	UU=; b=BwLCWmsghEcu16PWUNqvUyOtqeFLjRi4hMFiPXI7fiFgPTMJPn7fWNV8+
	VE6k2xdjDgi6px7Wt5F1QDd5xpp2lfYuxvfjh2fcAO6efUNcQKA3XXnUPR2AegTA
	786EQJ1S2cY26Ltcg8NGrlyr3T4KFxji/AKd5VdF+M2QTA4ozPlnARsrB8lG9O8W
	rigaV/sTqYx76xW/jFcILzlTfWz/q65u73x/9NlfIpR/rNWtR/j+zUwxksmq19sB
	iPvj0dfeEnnIUcDe0mZ4jLN5dG3AmqOrepAYDJ9YAeqXsoTCFaJHq3UZF0EaNzgt
	HFTqBQ3cuh9SCLsXqpHsX+BEmTLWQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mvd38yrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EGaBfa021797;
	Wed, 14 May 2025 16:39:00 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpn9y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGcu7D52560360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:38:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6343320043;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 035CD2004E;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:38:55 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v1 0/5] KVM: s390: some cleanup and small fixes
Date: Wed, 14 May 2025 18:38:50 +0200
Message-ID: <20250514163855.124471-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZhD0P873Zd389sHiFHtY9H1Z0_zZL8ks
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0OSBTYWx0ZWRfX6NGq5f1439ib 1yqdn0FpIklHaH2qqvzMdGkHJXSB6v2BC1531SnDv85vweepi/acWs1bjYpNt0AFgUoN90YGmHE riKzZsDLpparhFLwX9VBnn0hfw2dl0W4Uiwj8B9I5HXDQTEZTn+3ivPm9UctD1rJtYxQ4D2eUvp
 t4To0sduWcttNajTkrQO3pPQsBFKnSlxe1LvX/PG8X6Cfmrne/xoHWBAInRsnT3OgwzGTbhFyMP T8IwguAy6VGF/GUr0JOqThxbP6CL4d5azT9XSwTRpNcoSvRDtcF7B+cvwXBQQZUaOgiKRAJ3J+d q2A7FHz7yaMW96a7/qmzY1Xm56VR7aGndxCqQ888VMq8fVMiQGUCPM6Pv/JrQxeZzcObmxpQ0/c
 zbDDkPF9RHIQUo4S6muHb/WkeufaGdMBjNcFEk9kazaJ54flpybHPspnBVp04aOaNrGQ1s+e
X-Proofpoint-ORIG-GUID: ZhD0P873Zd389sHiFHtY9H1Z0_zZL8ks
X-Authority-Analysis: v=2.4 cv=GbEXnRXL c=1 sm=1 tr=0 ts=6824c725 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=h1Z-BSGDGoOSRx-kxQYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=834 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140149

This series has some cleanups and small fixes in preparation of the
upcoming series that will finally completely move all guest page table
handling into kvm. The cleaups and fixes in this series are good enough
on their own, hence why they are being sent now.

Claudio Imbrenda (5):
  s390: remove unneeded includes
  KVM: s390: remove unneeded srcu lock
  KVM: s390: refactor some functions in priv.c
  KVM: s390: refactor and split some gmap helpers
  KVM: s390: simplify and move pv code

 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap_helpers.h |  18 ++
 arch/s390/include/asm/tlb.h          |   1 +
 arch/s390/include/asm/uv.h           |   1 -
 arch/s390/kernel/uv.c                |  12 +-
 arch/s390/kvm/Makefile               |   2 +-
 arch/s390/kvm/diag.c                 |  11 +-
 arch/s390/kvm/gaccess.c              |   3 +-
 arch/s390/kvm/gmap-vsie.c            |   1 -
 arch/s390/kvm/gmap.c                 | 121 -----------
 arch/s390/kvm/gmap.h                 |  39 ----
 arch/s390/kvm/intercept.c            |  10 +-
 arch/s390/kvm/kvm-s390.c             |   8 +-
 arch/s390/kvm/kvm-s390.h             |  57 ++++++
 arch/s390/kvm/priv.c                 | 292 ++++++++++++---------------
 arch/s390/kvm/pv.c                   |  61 +++++-
 arch/s390/kvm/vsie.c                 |  19 +-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/fault.c                 |   1 -
 arch/s390/mm/gmap.c                  |  47 +----
 arch/s390/mm/gmap_helpers.c          | 266 ++++++++++++++++++++++++
 arch/s390/mm/init.c                  |   1 -
 arch/s390/mm/pgalloc.c               |   2 -
 arch/s390/mm/pgtable.c               |   1 -
 24 files changed, 590 insertions(+), 388 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

-- 
2.49.0


