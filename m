Return-Path: <kvm+bounces-32420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D628E9D84D2
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76AFC16AF0C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F3719CC37;
	Mon, 25 Nov 2024 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KJDksxwh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400FF376E0;
	Mon, 25 Nov 2024 11:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535447; cv=none; b=V5T6LU91k1EM0cKKs+YdXkNFELvfaOFOim/Y6GZSeaHO5PDoZCCzrxodOtIjWky3hcvNBUKpHFI88ML0BMXleaWay7uifH4d4WO+xeJovT+dd37xw/mIs02+/wJ96h9UtaJG2Kkkla4SYrrCs3n8I+ICGK7KKpa9kbX674q0BqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535447; c=relaxed/simple;
	bh=sdha4UFbzAj/IT3/+mxW7xRcKh1JUJ9MHdzxrrQtAhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q9ffHKUooFQ9g20AWj+bGiIq1q70yxZBKhqWDvPnuLwfhpX7lLXmK80E53yiF236J9RZ/BY5Hel8GoZQjBb88nesBN94+ZS0xgcyLwL75lvao/Lmo5Kv0FBE9fjlHYmJA7kMey8j2g+/reQHF+k2Qsjg4CX8SZOMo3gREwt7nLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KJDksxwh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APBiAx2028800;
	Mon, 25 Nov 2024 11:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=tW1SiColR96hkspMdkCnUsugwI9bUJxDV15p475UL
	Q8=; b=KJDksxwhxEt1wsF5iydiLk6+3lmv0R06uSQLWBNqiLAZw/uQAyChL2nel
	QrC+X74B81XK9gfPEA45vMzbDDa5qAtG9kp4AdK58QanXKPVX2/ewta6OZ5V0m3e
	6Wx9JVq5pHe1Rmv+xqlMQkDkYTjJ+R+f82jPr+dQKJzhcboTqu1RHslCsLk8n8NI
	bBwTuPgfffdH82syYEPxxTQTOgPel4jOZuwJxFnvf8YsYU3y+pbHNj53PnG4d+uW
	kTVDiH0x9+kibf8HtiT6YUNhO+zB9RsZFEzAvM0UlxatCN0JTKJ7DhzCsdwH+xU3
	5aHkHFQMNsVvaXPjjhNoCddIfA/IQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4338a77x2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP5ePqC026351;
	Mon, 25 Nov 2024 11:50:43 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 433v30ta4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APBodAW20840912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 11:50:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B280A2004B;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F42720043;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: s390: Couple of small cmpxchg() optimizations
Date: Mon, 25 Nov 2024 12:50:36 +0100
Message-ID: <20241125115039.1809353-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v7yQPefRjDtoGXpXvX1ze3UzwQYTBj3f
X-Proofpoint-ORIG-GUID: v7yQPefRjDtoGXpXvX1ze3UzwQYTBj3f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=721 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250098

Use try_cmpxchg() instead of cmpxchg() so compilers with flag output
operand support (gcc 14 and newer) can generate slightly better code.

Also get rid of two cmpxchg() usages on one/two byte memory areas
which generates inefficient code.

bloat-o-meter statistics of the kvm module:

add/remove: 0/0 grow/shrink: 0/11 up/down: 0/-318 (-318)
Function                                     old     new   delta
kvm_s390_handle_wait                         886     880      -6
kvm_s390_gisa_destroy                        226     220      -6
kvm_s390_gisa_clear                           96      90      -6
ipte_unlock                                  380     372      -8
kvm_s390_gisc_unregister                     270     260     -10
kvm_s390_gisc_register                       290     280     -10
gisa_vcpu_kicker                             200     190     -10
account_mem                                  250     232     -18
ipte_lock                                    416     368     -48
kvm_s390_update_topology_change_report       174     122     -52
kvm_s390_clear_local_irqs                    420     276    -144
Total: Before=316521, After=316203, chg -0.10%

Heiko Carstens (3):
  KVM: s390: Use try_cmpxchg() instead of cmpxchg() loops
  KVM: s390: Remove one byte cmpxchg() usage
  KVM: s390: Increase size of union sca_utility to four bytes

 arch/s390/include/asm/kvm_host.h | 10 +++++-----
 arch/s390/kvm/gaccess.c          | 16 ++++++++--------
 arch/s390/kvm/interrupt.c        | 25 ++++++++-----------------
 arch/s390/kvm/kvm-s390.c         |  4 ++--
 arch/s390/kvm/pci.c              |  5 ++---
 5 files changed, 25 insertions(+), 35 deletions(-)


base-commit: 9f16d5e6f220661f73b36a4be1b21575651d8833
-- 
2.45.2


