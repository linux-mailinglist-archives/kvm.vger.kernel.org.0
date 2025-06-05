Return-Path: <kvm+bounces-48529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 171E8ACF301
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44A3B7A4285
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689731DE3AB;
	Thu,  5 Jun 2025 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WguTG4cm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E912F19DF48
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137113; cv=none; b=c+uk44MYetPpDKy/A/05Fu0ALQCbB3NeNZQGZdQlZExZgGh3VjPLhytvnbegs/7eD3HJIZ9iAbL3zLbxdQJglDxEd5GNzZPmCj5sN2gaJbgdNbH/NPaxLIwlpps09+Z36y7NEq+VmrSFqsOC5LY5Z/gIMAoQqvI8q8UXA/WVWKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137113; c=relaxed/simple;
	bh=DEBISH+cp7aY/ZWOt+xXHWtq8PEDbM8fhoSEyysnQNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJRoqxNYowunoBPh22nlmdDii6wOV93/2tcUcsTja+dCQpXFBdJiwMeViTPP44dVIs+FGt0voYJWN8nvekwk8J/Gk98C9HM/QMxCD65indaTKGno7BTT6JejDVO2zaZ6hfibZN74nKN3vgGxO2BD10Mtbv47Volkvvs1404dGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WguTG4cm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtVrd023934;
	Thu, 5 Jun 2025 15:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=EBc67
	OyfAN5lefNk6ebfJV1LMXuI7F3DpzJkZN1NX5E=; b=WguTG4cmU/gBuq3M1qo3f
	aL88q75MZc2Jr6fBp/WwL3FP7Xi06n1r91D5noxmT/I6HlH60UMRXE/JsEUjxK3j
	s3zlB4W4VHej9/EQnmZePBYkWbvnvOpwAkdGb7jpSWsxv9E/ZtLXtQtkQCOqX8MN
	bUGfAdbLTKpYj1xXd2cw8g/Jx4k2FCDJYUxVg2JcnZ2s24pODS9yh6cbZcuncz/i
	20v6xE8mgDcxOWFrldAOGAMYjv6AwjY0SZ590IYXGdAcWjHXbJcDBx9ALa0J1Tsl
	hT8buJcyLZBXbv1hIdX6U8X6spkaBq5nGc6gSnt+qT+ACwsLh2n6AdoQONmlfx9w
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahefgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555FNCP3039102;
	Thu, 5 Jun 2025 15:25:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c8bw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:06 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 555FP4lu016227;
	Thu, 5 Jun 2025 15:25:06 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46yr7c8bt3-2;
	Thu, 05 Jun 2025 15:25:06 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH 1/3] KVM: Batch setting of per-page memory attributes to avoid soft lockup
Date: Thu,  5 Jun 2025 15:25:00 +0000
Message-ID: <20250605152502.919385-2-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250605152502.919385-1-liam.merwick@oracle.com>
References: <20250605152502.919385-1-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050134
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=6841b6d4 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=AGTAuo3DM2HaP5LwbvMA:9
X-Proofpoint-GUID: VhkCtI6upOSnOW3AxIgXnoMeKDYni6JQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfX9Q5C0GGBP1xK Jy76LRNyw0mvOQjG0R2CPgcrVpgGqoeT2ZYKuZfwMZcPrOdlhiX/DaKatuXrPbehKXpefsN7sHP gz1XaTp4HeMIG8gBYPW6D6BOCJeV0o6FSX5ys5507CNJFr1Tlrfn1/j2AJIwPadtbaPCvP6zG6z
 Q3ApdZiJ0mRNIGceqK+xRELfat26IOBkVBj7bOIZtW6js41n0VMTPgR8gJOeQj7pi8rz/gOYqpF Z1fLtXfFO3N0vexTTv6pmbuQf0+PMcBMjhJE4VyJidMYW8Lf4nyRe7VZRxMg58vJE/m9QpgTRem ORkOOz/nHENUoSCfGGniVA2fRaJz94wbfAmFqY2bAcWjmEKRu7Oui53B9hKGh5EBQb7qZBM2R53
 /ruqfkopO6xv+koJbRRJ+IAbzaMW6FqnOoFwWhWGneX+uVoS5wIynjHtcXaOhFS/i3qCEacv
X-Proofpoint-ORIG-GUID: VhkCtI6upOSnOW3AxIgXnoMeKDYni6JQ

When booting an SEV-SNP guest with a sufficiently large amount of memory (1TB+),
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
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
 __xa_store+0xa5/0x130
 xa_store+0x2c/0x50
 kvm_vm_set_mem_attributes+0x343/0x710 [kvm]
 kvm_vm_ioctl+0x796/0xab0 [kvm]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? rseq_ip_fixup+0x8c/0x1e0
 __x64_sys_ioctl+0xa3/0xd0
 do_syscall_64+0x8c/0x7a0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __alloc_frozen_pages_noprof+0x18d/0x340
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? try_charge_memcg+0x76/0x640
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __count_memcg_events+0xbb/0x150
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __mod_memcg_lruvec_state+0xb6/0x1b0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __lruvec_stat_mod_folio+0x83/0xd0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? set_ptes.isra.0+0x36/0x90
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_anonymous_page+0x103/0x4d0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __handle_mm_fault+0x397/0x6f0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __count_memcg_events+0xbb/0x150
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? count_memcg_events.constprop.0+0x26/0x50
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? handle_mm_fault+0x245/0x350
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_user_addr_fault+0x221/0x686
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? arch_exit_to_user_mode_prepare.isra.0+0x1e/0xd0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f5578d031bb
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d 4c 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe0a742b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000004020aed2 RCX: 00007f5578d031bb
RDX: 00007ffe0a742c80 RSI: 000000004020aed2 RDI: 000000000000000b
RBP: 0000010000000000 R08: 0000010000000000 R09: 0000017680000000
R10: 0000000000000080 R11: 0000000000000246 R12: 00005575e5f95120
R13: 00007ffe0a742c80 R14: 0000000000000008 R15: 00005575e5f961e0

Limit the range of memory per operation when setting the attributes to
avoid holding kvm->slots_lock for too long and causing a cpu soft lockup.

Fixes: 5a475554db1e ("KVM: Introduce per-page memory attributes")
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..6e6d404a7d7a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2533,7 +2533,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
-	gfn_t start, end;
+	gfn_t start, end, section_start, section_end;
+	u64 size, size_remaining;
+	int ret = 0;
 
 	/* flags is currently not used. */
 	if (attrs->flags)
@@ -2545,9 +2547,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
 		return -EINVAL;
 
-	start = attrs->address >> PAGE_SHIFT;
-	end = (attrs->address + attrs->size) >> PAGE_SHIFT;
-
 	/*
 	 * xarray tracks data using "unsigned long", and as a result so does
 	 * KVM.  For simplicity, supports generic attributes only on 64-bit
@@ -2555,7 +2554,35 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	size_remaining = attrs->size;
+	section_start = start = attrs->address >> PAGE_SHIFT;
+	section_end = end = (attrs->address + attrs->size) >> PAGE_SHIFT;
+	while (size_remaining > 0) {
+		/*
+		 * If the range of memory is greater than 512GB, clamp it for
+		 * this iteration to 512GB. This avoids a potential CPU soft
+		 * lockup when run on a larger range for an SEV-SNP guest.
+		 * (measured at 940GB so there is some headroom, just in case).
+		 */
+		if (size_remaining > SZ_512G) {
+			size = SZ_512G;
+			size_remaining -= size;
+			section_end = section_start + (size >> PAGE_SHIFT);
+		} else {
+			size = size_remaining;
+			size_remaining = 0;
+			section_end = end;
+			WARN_ON_ONCE(section_end != (section_start + (size >> PAGE_SHIFT)));
+		}
+
+		ret = kvm_vm_set_mem_attributes(kvm, section_start, section_end, attrs->attributes);
+		if (ret != 0)
+			break;
+
+		section_start = section_end;
+	}
+
+	return ret;
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.47.1


