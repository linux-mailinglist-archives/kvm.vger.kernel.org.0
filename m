Return-Path: <kvm+bounces-48301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5681CACC861
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363743A5F0A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 13:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B327238C3A;
	Tue,  3 Jun 2025 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qaEYbHIj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7123371F;
	Tue,  3 Jun 2025 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958587; cv=none; b=mAbEMJYi9femRAx67PktYuPry8kih14CFRUhXduD0COX2+v1cyWaVik0qXym7cYR1rJB5aYM4aKRSyKjWq4eYvqgLIyA0G6p0fx7iDXnM99oSNmSlPYxgZkMw+GtmexMVdG9qlGIBLrSuYrAh1kKkAfk4w1pwk68M4WPtcH0I5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958587; c=relaxed/simple;
	bh=oOflVTrjIKfKjHI3/rAtRo6kTL1xuh9s0r9Kr/eceso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AA/f7I0wZJDZzqnv9qD6K3713qMmYrzlM88zPbijQrNfATTQcUDtv4SlzgqHtcsWbraBlh6VroSbr0RE+mWihYzIAQYeE1zL+hU5zVXOLCpjoBiF8Y4EG3IEQDdztsLzM2ABjwoE6dBBw2gOOLMtbMdqW/HCS0NnLL2Nz8ladeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qaEYbHIj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55373DDQ031542;
	Tue, 3 Jun 2025 13:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=V/5GvlFUG4VzYX1Xrnq2YgcwHiE0tNl19SS43t8b2
	7Y=; b=qaEYbHIjCVvn4EFZ2vdySqKPQtCRsTmarO6imYu1JHHh6UuGWrJlMLsyT
	V2JwSE9MPyFc5O7nwjspgrwMW+WmTpe7PxgkKuBMEPTY7Twb3HipwI9aTqJjdGIG
	5+gEhjKpvWBJll+qt1tDQYJQO2PQccHWqT2Ni3so5nDqVK+FsnhV1UJhXOzytKl1
	hRCFl+Rr5cuDFG0dcf7dCXGKxGKC/TFzd/8WIqlcJjyfEibdTAMt5IsvyO2yTwwH
	0+rJY14G+jwGNWkzR0gCcOa7ObVYCqYkHGjQ+DeR6BT/nfeetFM4wPesLZiKP/MR
	vXARSSPRH9NtwaayzDk8MiPQQM/OA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf04ruu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 13:49:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553A0pOT031636;
	Tue, 3 Jun 2025 13:49:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470cfyu71q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 13:49:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553DnaSh25821796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 13:49:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C01E20040;
	Tue,  3 Jun 2025 13:49:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B3A920043;
	Tue,  3 Jun 2025 13:49:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 13:49:36 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390/mm: Fix in_atomic() handling in do_secure_storage_access()
Date: Tue,  3 Jun 2025 15:49:36 +0200
Message-ID: <20250603134936.1314139-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cwz5uSt7-0ETBNBBpzgK1cdANnsHMkw0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDExNyBTYWx0ZWRfX/sMPPzX7+zzj TFgkl/7brEY/cX+ZTbbbdjNzguz+J9cIcpMxvieb8odjB+nifndZnTeRwdwppfmQ8HkSAaQJ2Pd Qs/aQt8N6N4XdOxYepl77MqA/Lei5693pqXo50fy8azBrz0GdpW4I2omFF5ZQENPgZi46ombGsw
 S89RWqU9twHLPhmswIVjbMo1C9Prdtib1U/z2jpgiJNwl30d8UxnoLG/yGYZQjZTDe5oSPko1VN k9ekvT3PacGokAYWOf0eet/SzhoZuTdYiM/BQVbJp4EksjuxOLzvjI/QQ5EKZR1irlKeAs+vscl P7Tk5sp5Q7w5K3FaPqp/Sqc51l4/XIN21AZGt9zIq6DB/iI1Y2APQtidZwx2KAqx2At5gqSzn4N
 pCgNNR4K9SRjXUYZT5nI9VHPfKoYUPhliuPE3pYwqowMjs6+M8Iejgl+orZdGEl8pmQ6JOCi
X-Proofpoint-ORIG-GUID: cwz5uSt7-0ETBNBBpzgK1cdANnsHMkw0
X-Authority-Analysis: v=2.4 cv=c+WrQQ9l c=1 sm=1 tr=0 ts=683efd75 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=3nF8smJztN8JD-OeeQ8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=825 phishscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030117

Kernel user spaces accesses to not exported pages in atomic context
incorrectly try to resolve the page fault.
With debug options enabled call traces like this can be seen:

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1523
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 419074, name: qemu-system-s39
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<00000383ea47cfa2>] copy_page_from_iter_atomic+0xa2/0x8a0
CPU: 12 UID: 0 PID: 419074 Comm: qemu-system-s39
Tainted: G        W           6.16.0-20250531.rc0.git0.69b3a602feac.63.fc42.s390x+debug #1 PREEMPT
Tainted: [W]=WARN
Hardware name: IBM 3931 A01 703 (LPAR)
Call Trace:
 [<00000383e990d282>] dump_stack_lvl+0xa2/0xe8
 [<00000383e99bf152>] __might_resched+0x292/0x2d0
 [<00000383eaa7c374>] down_read+0x34/0x2d0
 [<00000383e99432f8>] do_secure_storage_access+0x108/0x360
 [<00000383eaa724b0>] __do_pgm_check+0x130/0x220
 [<00000383eaa842e4>] pgm_check_handler+0x114/0x160
 [<00000383ea47d028>] copy_page_from_iter_atomic+0x128/0x8a0
([<00000383ea47d016>] copy_page_from_iter_atomic+0x116/0x8a0)
 [<00000383e9c45eae>] generic_perform_write+0x16e/0x310
 [<00000383e9eb87f4>] ext4_buffered_write_iter+0x84/0x160
 [<00000383e9da0de4>] vfs_write+0x1c4/0x460
 [<00000383e9da123c>] ksys_write+0x7c/0x100
 [<00000383eaa7284e>] __do_syscall+0x15e/0x280
 [<00000383eaa8417e>] system_call+0x6e/0x90
INFO: lockdep is turned off.

It is not allowed to take the mmap_lock while in atomic context. Therefore
handle such a secure storage access fault as if the accessed page is not
mapped: the uaccess function will return -EFAULT, and the caller has to
deal with this. Usually this means that the access is retried in process
context, which allows to resolve the page fault (or in this case export the
page).

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 3829521450dd..e1ad05bfd28a 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 	} else {
+		if (faulthandler_disabled())
+			return handle_fault_error_nolock(regs, 0);
 		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
-- 
2.45.2


