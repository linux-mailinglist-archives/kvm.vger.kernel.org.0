Return-Path: <kvm+bounces-51752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E23AFC715
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 11:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EDD7561F51
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BAC254AE4;
	Tue,  8 Jul 2025 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PeZ09sB7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618552264BE;
	Tue,  8 Jul 2025 09:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751966926; cv=none; b=WiaPltTbVxoTMkHMlPm92B0fYHobnxgBbeWwwFY9rRgWlujSdVL9bbeCUsdL5fDrvUREnYYRJVQ9rE9FvTVsmwMstQB8xn8rL1PcilhJq6Yk0oy6oH1d9hfrSIYZFqRdHskABhbhUAFFazNq4nTfq9ZTqwlDMZ9kxNjSNAUxYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751966926; c=relaxed/simple;
	bh=LtNQamByt00I6749sR/ATCcbWocCkYl6LlxKztAc26c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PqHEKErBQ3L3d0Wjn+jyn+u0h92+cdHaNQJxSIQDY25LDOsmIIKk4ss4j5H4acVKHymAvNoJsVz/yDgKSCUEjuqtGkkU26W+wqxj7fox7h9mSMKxWBlywXQxJLr2ZYqW/LW71y2pSp+bI+C5Rfx6JZEAUcm8mloTs2Dslro1gdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PeZ09sB7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56801Jeq022666;
	Tue, 8 Jul 2025 09:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=t30vuLOcKkepEeapyMINRaSWj+an0KHmEG8fdISek
	aQ=; b=PeZ09sB78LCDvbhBTFnurpd4i91Klz2mKFEJ+aJXvqQMfvmAxoc0BAHaD
	nzbBPOb1K7UTSAbehRZt3hzn8b5ieKDuTd35kup4GpaE6Yw1RQGBVhSNOD8tTVb1
	NEKReFHjwBgl+5MhNgvrhN9Q+lxvzGf38mUx8Msmq4eRlKk6wHSH7hsy/27WD/H+
	kqvfhau+MYWAaU1arMhSTdYaGhI7bthBodJ42i2YqGOAMaap7Kkt0AjT9anxx+RK
	BjWKy4Wuewn2lG9ksfi59TQ1d+MALfaUoFEk6dysR0B3zsVRj7ewM5ycFe5jfefb
	AtfKZ0UuWpaWJJDwv48ecRIQYluwA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ptfypc1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 09:28:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5685ifGV021566;
	Tue, 8 Jul 2025 09:28:11 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qectjeuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Jul 2025 09:28:11 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5689SA4030999050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Jul 2025 09:28:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41EE55805E;
	Tue,  8 Jul 2025 09:28:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 535FE5805D;
	Tue,  8 Jul 2025 09:28:00 +0000 (GMT)
Received: from jarvis.j0t-au.ibm.com (unknown [9.90.171.232])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Jul 2025 09:27:59 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] KVM: s390: Fix latent guest entry/exit bugs
Date: Tue,  8 Jul 2025 19:27:40 +1000
Message-ID: <20250708092742.104309-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=crubk04i c=1 sm=1 tr=0 ts=686ce4ac cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=JcICJyfkcYpUTDghlhwA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: 3iaupOe9fVcT-Epdat_lI0t-fxMzysKm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDA3NiBTYWx0ZWRfX0reOT8lwsZVO HzYgxXyg8caT4NF4m0VurUSUPEl+nzNfvhvnO1U+tuROTgLDOQw1whfxTlTxNs0TyyjUD+0wwBS OSlMK7vqH4gNxQ4xDKxkaMl6XnyN16f4z0eyAYA9eHyb3a+ONdCxJ21CjgpKVJvhiHBwUZGOFao
 sVJXrnqtLGKUsmIH+WMX3dAfXoYRONCfqElg3F0Xj3S4oSCkO5viSfYKPtdrqMueVd3ajUkdFwp idx2ogaTT1UN7AK0OguMlj4WzVjGBy/hjipwEq+Z+bLt24RegmNIWmEEVYGGugiFhkKYBF9IK4y HuAVKwq+eMzBxPm40hY2hh2MaXIGqJpuKtcNv4cBrp2fLfrJ6I2sa4arcKbRDvzKlstTHZh4Rxs
 fw9Oam+kFMKtKds+hlKpUagr8NYWn+183IrokFhxAUHZmnb1Wq+tyd9FRAIGTQ7dMR39xnpY
X-Proofpoint-GUID: 3iaupOe9fVcT-Epdat_lI0t-fxMzysKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_02,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=620
 priorityscore=1501 adultscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507080076

In [0], the guest_{enter,exit}_irqoff() helpers were deprecated, in favour
of guest_timing_{enter,exit}_irqoff() and
guest_context_{enter,exit}_irqoff(). This was to fix a number of latent
guest entry/exit bugs, relating to the enabling of interrupts during an
RCU extended quiescent state, instrumentation code, and correct handling
of lockdep and tracing.

However, while arm64, mips, riscv and x86 have been migrated to the new
helpers, s390 hasn't been. There was an initial attempt at [1] to do this,
but that didn't work for reasons discussed at [2].

Since then, Claudio Imbrenda has reworked much of the interrupt handling.
Moving interrupt handling into vcpu_post_run() avoids the issues in [2],
so we can now move to the new helpers.

I've rebased Mark's patches from [1]. kvm-unit-tests, the kvm selftests,
and IBM's internal test suites pass under debug_defconfig.

These patches do introduce some overhead - in my testing, a few of the
tests in the kvm-unit-tests exittime test suite appear 6-11% slower, but
some noticeable overhead may be unavoidable (we introduce a new function
call and the irq entry/exit paths change a bit).

[0] https://lore.kernel.org/lkml/20220201132926.3301912-1-mark.rutland@arm.com/
[1] https://lore.kernel.org/all/20220119105854.3160683-7-mark.rutland@arm.com/
[2] https://lore.kernel.org/all/a4a26805-3a56-d264-0a7e-60bed1ada9f3@linux.ibm.com/
[3] https://lore.kernel.org/all/20241022120601.167009-1-imbrenda@linux.ibm.com/

Mark Rutland (2):
  entry: Add arch_in_rcu_eqs()
  KVM: s390: Rework guest entry logic

 arch/s390/include/asm/entry-common.h | 10 ++++++
 arch/s390/include/asm/kvm_host.h     |  3 ++
 arch/s390/kvm/kvm-s390.c             | 51 +++++++++++++++++++++-------
 arch/s390/kvm/vsie.c                 | 17 ++++------
 include/linux/entry-common.h         | 16 +++++++++
 kernel/entry/common.c                |  3 +-
 6 files changed, 77 insertions(+), 23 deletions(-)

-- 
2.50.0

