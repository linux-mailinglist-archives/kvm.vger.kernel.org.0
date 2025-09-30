Return-Path: <kvm+bounces-59178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E24EBBAE0DB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADBD04E2710
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E02823F294;
	Tue, 30 Sep 2025 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bn9XeT9j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B99035940;
	Tue, 30 Sep 2025 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250039; cv=none; b=nalZfZkn8CCXCprtC75htX62xi0JP2sIJwjWWOnl5zjEXQlApxoEGU/waT6rJiEmk7S74HVmC0tTn9SVz9+v82WdawYUrieqzCw4yunFgq+J5U5JV+5s9GtcocjujN1sDgdb6rVyJ5waA7mxTd38CosDBUJGhd+Elq4Qjb6CMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250039; c=relaxed/simple;
	bh=EudJkBkALuaGHLIJqgeUKqmJLJ43uJNRpufF8T9QRZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oA7rJTMJ4ojyFLzjKYWLhNKPvwgPIqcuH7cqlMDvGgeUTqYBEFGzRYRGUGTgnE19ZBrmrUlCez50zyOuKjKYjVYzEo0vFzx0Rr6s/8+LOf3QSMvXXRnwZGRiyHvqO1flazw7UQ/Qj4SMXJqhbx1D2HwyyFPhOd4IZkrv55MpNyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bn9XeT9j; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U7sc0L007592;
	Tue, 30 Sep 2025 16:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=EeRq+7lE9NBdp8ssWhUDbKWVS9bf
	MmlUI7WHavQx10U=; b=Bn9XeT9jKJ3/e5YVGJzjcKj1A8eEi9+af2+wjayX9tSm
	e3PcdGm6emU0Hz4Mvribv7bN/JdujGMF755Vuc9Cp1Qn/kSbkt5vXaU7qlXDGDrx
	jZWaFR4Vlg+3zbv0dWUF/sWFoj3fp6BGqRdp+T+i71+BdmPSDyDhRmRQgW9LHkjK
	c/eHZS1hgHetQ4yxpt1xveseK/dHbsjuc4Ic4cqrzxngeBYZw0cFcB3jAn78qTRc
	5eFeZVYxBHCYmTmhcmpyXRTgcwKkHn8MBN4coLIT6kg9mxliJxIChtpyV8AwV8KR
	rAeVzJEKHJu6q82TDUqGwrScrgA8zu0bGWsIge9MoA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5bqt07w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58UGX5pe007285;
	Tue, 30 Sep 2025 16:33:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49eurjvb3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UGXotf52429114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 16:33:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97CD420043;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 789E520040;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 0/2] KVM: s390: A bugfix and a performance improvement
Date: Tue, 30 Sep 2025 18:33:48 +0200
Message-ID: <20250930163350.83377-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDIxNCBTYWx0ZWRfX0DPOM7qWx+aM
 TrPTC/4kxQGoRjh+LBdIeRy1E/mlmltrbycOL9IFqcHCA9MRGRpwJuollsAbnx0YE49r1Py8QCh
 Jhrv2my83l32T+IZL6j1nlhGgPp6mTCy0qDKASETtq0O9pyuv1cjHH/hRvEhzk5+YiNvHP7mjZY
 Bnyjfq0ttjVZ8NpGhj7mPzqpqEynCv2ZRrm9y/G43lrwitVJ+xwehbNEm6kO9G4YHxeUgdQ78AO
 Nv0NoGhnx4kPk1Jdy7dS0Z5m5XoGx5HnM2HBnhX08VKRECYXTm2oejJU/fm70ziytBG/guYlZSD
 WVjF3BfIRFauFWUL/2sm/OEQ/cCYx7UikqaAPI8eRGBjqhu7CUFZ+uojLccDY3qEJUG+ipWyxfM
 FD2av1/8UUcrBPbBSWhP2af8VFLNwg==
X-Proofpoint-GUID: MMAHy2oDusfYEkaNrzoZ5GWpIExl2zbw
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=68dc0673 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=aISnZ6o9eOw1yl-8LIYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MMAHy2oDusfYEkaNrzoZ5GWpIExl2zbw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509260214

Ciao Paolo,

here is a small pull request that does two things:

* Improve interrupt cpu for wakeup, change the heuristic to decide wich
  vCPU to deliver a floating interrupt to.
* Clear the pte when discarding a swapped page because of CMMA; this
  bug was introduced in 6.16 when refactoring gmap code.

Unfortunately Christian had pushed his patch on -next when it was still
based on the previous release, and he wanted to keep the patch ID stable;
the branch should nonetheless merge cleanly (I tested).


The following changes since commit 57d88f02eb4449d96dfee3af4b7cd4287998bdbd:

  KVM: s390: Rework guest entry logic (2025-07-21 13:01:03 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.18-1

for you to fetch changes up to 5deafa27d9ae040b75d392f60b12e300b42b4792:

  KVM: s390: Fix to clear PTE when discarding a swapped page (2025-09-30 15:58:30 +0200)

----------------------------------------------------------------
KVM: s390: A bugfix and a performance improvement

* Improve interrupt cpu for wakeup, change the heuristic to decide wich
  vCPU to deliver a floating interrupt to.
* Clear the pte when discarding a swapped page because of CMMA; this
  bug was introduced in 6.16 when refactoring gmap code.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: improve interrupt cpu for wakeup

Gautam Gala (1):
      KVM: s390: Fix to clear PTE when discarding a swapped page

 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/include/asm/pgtable.h  | 22 ++++++++++++++++++++++
 arch/s390/kvm/interrupt.c        | 20 +++++++++-----------
 arch/s390/mm/gmap_helpers.c      | 12 +++++++++++-
 arch/s390/mm/pgtable.c           | 23 +----------------------
 5 files changed, 44 insertions(+), 35 deletions(-)

