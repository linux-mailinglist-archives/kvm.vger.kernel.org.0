Return-Path: <kvm+bounces-48732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9F8AD1A54
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63F173A8964
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273662505AF;
	Mon,  9 Jun 2025 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gu/hofz4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F81459F6
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460292; cv=none; b=qbiyrveb2GgTNi0YOR5LVuYdwPJbjrBz/r/kjXU2Q8JLhwQQBMqMyLeZtXilfSF/uqij+MJisedAcZbiPAGGE3vY2lO7h1sF4HNeAMxtWFNWGrYBai7vtrsEUT6jkEeILPzmgzTKxzyNiKRrv0aLJgGxIDefUl11q9cdC/cZIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460292; c=relaxed/simple;
	bh=WrVpeo3iWrdzg/CcO3s3kTyWtKvBqfViXvTWPCXcSls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1KCFTzyqPfb9lWaW15xD6YPxjaPmkrC1iQBdVusyizVjV7kcxw1w8RwiAw7bPP2q+ECNvqy3oZBGn/TQP2rK57EXj5YUtQD9emBxw6mRXSnLuJmZ7Cd+MBE6tDFIfyX/UrGZfb4KFKnS77IcvIFcTxqsixLYc0QtmBQisBUpVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gu/hofz4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5593iGoE011370;
	Mon, 9 Jun 2025 09:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=HYVI0
	ZR78vRef5vnXlqTZdeaI0/nbB49IKcnHKK7BJo=; b=Gu/hofz4Hv7LZnjNAQ++b
	fcy1zO57RhaDS74H6lnB+u48doCkj5biAzBoLbo/GxnrkFe7H6+rYLWPEkAzbknY
	IrDa4jcotvnu/YccQQSrcjpXe5fq+w+XrMiTO4wBkiMUx3MgEYWCoPQUf/rIO0gF
	T8sHFhUEsju2m6ljn0EVc/eYyx7IxC+loRP1LFqZazyIXY0tOl1jz8nxboUfMp71
	QhhzZuFlOebShmlhpOTcdWcqt9BhI+NtXMK5x4Y65Eu49126m+JNlWEHxfu5itSI
	KfF8EDjr0yBLlWuVyQDwOP4kA0C0w6OB2eUBxDFh8mqkWePPD9qnDknzFXq7kmwB
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf1t7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5598XE0J031344;
	Mon, 9 Jun 2025 09:11:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv77neq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5599BMj1030518;
	Mon, 9 Jun 2025 09:11:23 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv77nds-2;
	Mon, 09 Jun 2025 09:11:23 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH v2 1/3] KVM: Allow CPU to reschedule while setting per-page memory attributes
Date: Mon,  9 Jun 2025 09:11:19 +0000
Message-ID: <20250609091121.2497429-2-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250609091121.2497429-1-liam.merwick@oracle.com>
References: <20250609091121.2497429-1-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-09_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506090070
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=6846a53d cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=82mx9lFNDWqwwLemO1sA:9
X-Proofpoint-GUID: K-7yeNGX8x4qTKhZtYw7RXSy0NsP2JS4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA5MDA3MCBTYWx0ZWRfX20uRDFRh1jwE q8l3b4sXMYzq1RADI8H5acPeBKgCww9hdwyUKFyJpp9951OnyStgxBtHsLIFSDFfwzr9+JU/q3H +Kynux/IM6HYj9YZSN+rcq3IFKaQPKa0jXkjUkCz1RmzlwdNC/umUafXbZZi7+n0D4McGxFv6VH
 7Gn12stgzhjZLTcMEoC3rMdRVLBbTBBc4Pg4oHetPpaseWRaVk2PJvGUAvJl2jY0xeuwvw711tu icZ1WVH1zBdLuylFk7Snk8Cr+lbjCeafPqgeODxvUQi7W8f8sYyI8dpQn+0C8bR15NgKQcTHtwd mPGABoumPABIDGh/x2Qk9KiUKmKNAaUL2vTbwSytB1vX3TCAviSacLnq/+Rr/fwquNTgbo9BvTb
 nRTuU7EsX2/Ch/ZuNvZ/Xi0ZgUZRGycLPaPAJmNATctG2KCcbWYvBsY6veCRQeuz8gKhdlhH
X-Proofpoint-ORIG-GUID: K-7yeNGX8x4qTKhZtYw7RXSy0NsP2JS4

When running an SEV-SNP guest with a sufficiently large amount of memory (1TB+),
the host can experience CPU soft lockups when running an operation in
kvm_vm_set_mem_attributes() to set memory attributes on the whole
range of guest memory.

watchdog: BUG: soft lockup - CPU#8 stuck for 26s! [qemu-kvm:6372]
CPU: 8 UID: 0 PID: 6372 Comm: qemu-kvm Kdump: loaded Not tainted 6.15.0-rc7.20250520.el9uek.rc1.x86_64 #1 PREEMPT(voluntary)
Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB Tray,2U,E4-2c, BIOS 78016600 11/13/2024
RIP: 0010:xas_create+0x78/0x1f0
Code: 00 00 00 41 80 fc 01 0f 84 82 00 00 00 ba 06 00 00 00 bd 06 00 00 00 49 8b 45 08 4d 8d 65 08 41 39 d6 73 20 83 ed 06 48 85 c0 <74> 67 48 89 c2 83 e2 03 48 83 fa 02 75 0c 48 3d 00 10 00 00 0f 87
RSP: 0018:ffffad890a34b940 EFLAGS: 00000286
RAX: ffff96f30b261daa RBX: ffffad890a34b9c8 RCX: 0000000000000000
RDX: 000000000000001e RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffad890a356868
R13: ffffad890a356860 R14: 0000000000000000 R15: ffffad890a356868
FS:  00007f5578a2a400(0000) GS:ffff97ed317e1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f015c70fb18 CR3: 00000001109fd006 CR4: 0000000000f70ef0
PKRU: 55555554
Call Trace:
 <TASK>
 xas_store+0x58/0x630
 __xa_store+0xa5/0x130
 xa_store+0x2c/0x50
 kvm_vm_set_mem_attributes+0x343/0x710 [kvm]
 kvm_vm_ioctl+0x796/0xab0 [kvm]
 __x64_sys_ioctl+0xa3/0xd0
 do_syscall_64+0x8c/0x7a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f5578d031bb
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d 4c 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe0a742b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000004020aed2 RCX: 00007f5578d031bb
RDX: 00007ffe0a742c80 RSI: 000000004020aed2 RDI: 000000000000000b
RBP: 0000010000000000 R08: 0000010000000000 R09: 0000017680000000
R10: 0000000000000080 R11: 0000000000000246 R12: 00005575e5f95120
R13: 00007ffe0a742c80 R14: 0000000000000008 R15: 00005575e5f961e0

While looping through the range of memory setting the attributes,
call cond_resched() to give the scheduler a chance to run a higher
priority task on the runqueue if necessary and avoid staying in
kernel mode long enough to trigger the lockup.

Fixes: 5a475554db1e ("KVM: Introduce per-page memory attributes")
Cc: stable@vger.kernel.org # 6.12.x
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b99de3b5ffbc..aba4078ae225 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2557,6 +2557,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
 		if (r)
 			goto out_unlock;
+
+		cond_resched();
 	}
 
 	kvm_handle_gfn_range(kvm, &pre_set_range);
@@ -2565,6 +2567,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
+		cond_resched();
 	}
 
 	kvm_handle_gfn_range(kvm, &post_set_range);
-- 
2.47.1


