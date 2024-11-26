Return-Path: <kvm+bounces-32513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D579D9584
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34878B28FC4
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D6A1C9B7A;
	Tue, 26 Nov 2024 10:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aIXXZUJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3918FDBA;
	Tue, 26 Nov 2024 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616725; cv=none; b=kEHO+98q5I5nQ3hEN4uGeAshEeSyZK2giGd9WpO4e94vZe/gFsv5pR0TbRRC/C1aUsR6gSlCavVjaGUsXgDBnp/ZKvN0H4nN6EgWcl9Yb0Uus7F7jDYimzDgMAlRRN1WbbP4LMMDWVsIt7JQJRSiuMWuJ2DZ43ThO/QQUAmy1eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616725; c=relaxed/simple;
	bh=sN4gMg9uBLGYCgEAiCW2m+6i8yxHMS1uivc2+893cgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tozmq5MrGd47T4iNetGXJzxVi/IP0ap0s34bwfU/G36atmYPjGntkLDRM8SmY5zUlhEJZmLtryh45OIk8NFzNNQr/SeLjcP970eKUlBJDgJKqZD9t/QYRqp6xkfCSuRUOt4T9a3rEFx9bM/npUfJDQgfCZE8pcf937YZw59uong=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aIXXZUJ9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ8NhYk011347;
	Tue, 26 Nov 2024 10:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=d1aG/8cN0IYk6bFwJfeq264k7++gwids8Ohxh5FXr
	fc=; b=aIXXZUJ9dOOQOD/ojeB7NePAJDdsV6tCzFaQei5oRv40EndfEgLs+9saX
	3iy5djua2u/Sv3l6Uzsq9c74fh537K/EgC+YpJUYo6BSF5ZnSet1qaNbqsLqWJfj
	VEKLMgFWq3m75EWK5VzosB79TuvR+D8RynJBe2+DyTDIguuyB5FWY306X8xcrRvH
	KscKlEtIx+BiyEHharg+Je2UZXSNymnIwVdattMBsEy5VLNZrZFXyNx8LnOxhkN9
	0DeVo+kzm8KNVThsrKjdOWLL11HHXRj4mg5yjC5p0OelJI/humn+K9g4KwWTUl1x
	NEkJ5tid01GCt12GmXUn/UGSBbmSw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43389cdbba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ6WcDF010044;
	Tue, 26 Nov 2024 10:25:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj46rq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQAPGv727198002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 10:25:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44F8B20077;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20AD320072;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: s390: Couple of small cmpxchg() optimizations
Date: Tue, 26 Nov 2024 11:25:12 +0100
Message-ID: <20241126102515.3178914-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4c_-XVv-4HNHkRdhL1mUIE7TE2BztFhX
X-Proofpoint-ORIG-GUID: 4c_-XVv-4HNHkRdhL1mUIE7TE2BztFhX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=719
 adultscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411260079

v2:
- Replace broken WRITE_ONCE(..., 9) with intended WRITE_ONCE(..., 0).

v1:
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

-- 
2.45.2


