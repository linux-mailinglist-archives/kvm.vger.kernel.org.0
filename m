Return-Path: <kvm+bounces-57101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78689B4ACFA
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6A04346A18
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C74C322DAC;
	Tue,  9 Sep 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tg8eRB8o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A460E322549;
	Tue,  9 Sep 2025 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418914; cv=none; b=EQaCGfDqE+dk28BFxUMyreJgY7xAChzhGRafHCQ6O3bXCLn0hQGlH7tHRduHmuT4vhLxUBrISNJmm8ycmgxNyM6ITFc/pq5yvH9NzBWJLdl8rWGpw5WXYZo70840KHs12fQ/4nClVFbqrBWd0pjndKvePXKufbMUhH/bTjofOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418914; c=relaxed/simple;
	bh=EDY+sNKmp8vPeydDPfj0J/5qEu2JxSZXb8ePcIUMCbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7ynG22bvwaL4nyqduLcxYsdg+7Rln/MaEW12IsgilMQAgO9XtCmUG2gkxSe04q6vUSPonAPtUCQsTG21FMVpPCCW+IVGEPZRj8U8JDsXJE8pwZIvty0YblWUPxKP967zW0Dt2wyxSZN7lJU8Ki0gIs7ew2DPKde8/DtIJPNHXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tg8eRB8o; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589ANtv8016609;
	Tue, 9 Sep 2025 11:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K1xfU7rRlNzLdOKM/
	sLZhUJJsCE51Y/ZvaojlK/jf38=; b=tg8eRB8oBNwoXZnJUwQDcKNYKjgDTu+2S
	8HTP8Dl9V6rAYgqHxGJIEtFH/N59j18zl6gEGZn/Nhd8yx68AJUOFEDfBF9Panxd
	6x88VmTyEyRdsY/UNuHsUUBCUzR9g/b26YhtMkwZtpFpZobcMSi/tbdHb3ikW+Lr
	ctOmJ9RH88MrzNPnfxsxQcMr+7tPn4oLz6DO9M6eBFlbPqJQt8RAV5DQWYU9dOBa
	a4SJ7aw4I9bbE8+nmp4InagodzxJyGNy00m5OqS9u0NUwEqh38q9CM+bXmPe4QwS
	lScBd5gyANODH5mpgxV0R01M8acri8SwKxb2s7K5MZ88q84RBvQoA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsq994-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5899tTSi007929;
	Tue, 9 Sep 2025 11:55:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109pjyg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589Bt4RO57606610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:55:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CC1A20043;
	Tue,  9 Sep 2025 11:55:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AFE320040;
	Tue,  9 Sep 2025 11:55:04 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.111.71.18])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:55:03 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 1/3] KVM: s390: Fix access to unavailable adapter indicator pages during postcopy
Date: Tue,  9 Sep 2025 13:46:13 +0200
Message-ID: <20250909115446.90338-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909115446.90338-1-frankja@linux.ibm.com>
References: <20250909115446.90338-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX/nlG9xdpmMhb
 F5iBnh5ZIZcZzrmy2sg1AA31TjP4kgnomc4rex+Uk2QWx51x30U5bxOw7ZGg/2ScAP7B0ypIsvp
 gs+IOukhz5+7oirPZuo+6Sq5yOlI9gX8xmyW4SgwUt/i9O06UvkeGBIBjOSIPOx5yO+/Iww4TXN
 DpnuFdCPzhIAavDORIP7gwdm6aTtlIND8fgNuHlF268BUFUdpPw1PHiOA5i+AYy7vl5MjLnolGf
 q3G/NhC8H0geFhrnl+octdCgBs5Simdm6ju2yh6uAzpQowWHagUYl8GaH2PLdIWLYjcrrzPPB/r
 ciyMSSdXvPaS9E+bcTbLN9KgTdjDu9TfgvmywCBgsbAHGhdBn9+bzjKCs4UCjFBZJTdQ6Ny4QOI
 rrmB7neL
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c0159d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=kFCvNu4vXPeMiJgJUQ8A:9
X-Proofpoint-GUID: vzVZNwvujzdTYPdqTHTqx_wYTYtqp_8B
X-Proofpoint-ORIG-GUID: vzVZNwvujzdTYPdqTHTqx_wYTYtqp_8B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

From: Thomas Huth <thuth@redhat.com>

When you run a KVM guest with vhost-net and migrate that guest to
another host, and you immediately enable postcopy after starting the
migration, there is a big chance that the network connection of the
guest won't work anymore on the destination side after the migration.

With a debug kernel v6.16.0, there is also a call trace that looks
like this:

 FAULT_FLAG_ALLOW_RETRY missing 881
 CPU: 6 UID: 0 PID: 549 Comm: kworker/6:2 Kdump: loaded Not tainted 6.16.0 #56 NONE
 Hardware name: IBM 3931 LA1 400 (LPAR)
 Workqueue: events irqfd_inject [kvm]
 Call Trace:
  [<00003173cbecc634>] dump_stack_lvl+0x104/0x168
  [<00003173cca69588>] handle_userfault+0xde8/0x1310
  [<00003173cc756f0c>] handle_pte_fault+0x4fc/0x760
  [<00003173cc759212>] __handle_mm_fault+0x452/0xa00
  [<00003173cc7599ba>] handle_mm_fault+0x1fa/0x6a0
  [<00003173cc73409a>] __get_user_pages+0x4aa/0xba0
  [<00003173cc7349e8>] get_user_pages_remote+0x258/0x770
  [<000031734be6f052>] get_map_page+0xe2/0x190 [kvm]
  [<000031734be6f910>] adapter_indicators_set+0x50/0x4a0 [kvm]
  [<000031734be7f674>] set_adapter_int+0xc4/0x170 [kvm]
  [<000031734be2f268>] kvm_set_irq+0x228/0x3f0 [kvm]
  [<000031734be27000>] irqfd_inject+0xd0/0x150 [kvm]
  [<00003173cc00c9ec>] process_one_work+0x87c/0x1490
  [<00003173cc00dda6>] worker_thread+0x7a6/0x1010
  [<00003173cc02dc36>] kthread+0x3b6/0x710
  [<00003173cbed2f0c>] __ret_from_fork+0xdc/0x7f0
  [<00003173cdd737ca>] ret_from_fork+0xa/0x30
 3 locks held by kworker/6:2/549:
  #0: 00000000800bc958 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7ee/0x1490
  #1: 000030f3d527fbd0 ((work_completion)(&irqfd->inject)){+.+.}-{0:0}, at: process_one_work+0x81c/0x1490
  #2: 00000000f99862b0 (&mm->mmap_lock){++++}-{3:3}, at: get_map_page+0xa8/0x190 [kvm]

The "FAULT_FLAG_ALLOW_RETRY missing" indicates that handle_userfaultfd()
saw a page fault request without ALLOW_RETRY flag set, hence userfaultfd
cannot remotely resolve it (because the caller was asking for an immediate
resolution, aka, FAULT_FLAG_NOWAIT, while remote faults can take time).
With that, get_map_page() failed and the irq was lost.

We should not be strictly in an atomic environment here and the worker
should be sleepable (the call is done during an ioctl from userspace),
so we can allow adapter_indicators_set() to just sleep waiting for the
remote fault instead.

Link: https://issues.redhat.com/browse/RHEL-42486
Signed-off-by: Peter Xu <peterx@redhat.com>
[thuth: Assembled patch description and fixed some cosmetical issues]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: f65470661f36 ("KVM: s390/interrupt: do not pin adapter interrupt pages")
[frankja: Added fixes tag]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 2a92a8b9e4c2..9384572ffa7b 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2778,12 +2778,19 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 
 static struct page *get_map_page(struct kvm *kvm, u64 uaddr)
 {
+	struct mm_struct *mm = kvm->mm;
 	struct page *page = NULL;
+	int locked = 1;
+
+	if (mmget_not_zero(mm)) {
+		mmap_read_lock(mm);
+		get_user_pages_remote(mm, uaddr, 1, FOLL_WRITE,
+				      &page, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+		mmput(mm);
+	}
 
-	mmap_read_lock(kvm->mm);
-	get_user_pages_remote(kvm->mm, uaddr, 1, FOLL_WRITE,
-			      &page, NULL);
-	mmap_read_unlock(kvm->mm);
 	return page;
 }
 
-- 
2.51.0


