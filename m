Return-Path: <kvm+bounces-18102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D818CE14E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 09:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A4161F22407
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 07:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD56A128807;
	Fri, 24 May 2024 07:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RaNx9+/L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF336D;
	Fri, 24 May 2024 07:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716534333; cv=none; b=OqXjncffEKbWUIA0SfeKARp1SHtbWGveparLuL7rCYDeoECAD+sOj3I4hGWI9t6SGhW28uF034glTRcrrTlj2FuygoP8WYh8ih74DzxHTtl1Zry/vvXGTYYgodXYwmyyPCPhqGweVTswEVB9BNtiTVj86to/ymfUZjuw9BhlQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716534333; c=relaxed/simple;
	bh=j+WyVH68DgCq9sHBM6WN02HyNxMeR3vS+yEYlfsJMjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jA8b56zcpCMgpNcuCeFj/lzlJxc3Wslflgb3B5maOWSVgLJ/jCtdf0MNv5Eoujb8UyComDLI5dms9cEacpRdbTFCXjunbRbiqmSmj+7+uqwsl2n53PETVt90J2wcWEBnbrQeakuCo5JZKqtMeRoLRdZf35DxD46OAl65jtlv6k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RaNx9+/L; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O6ueGA022177;
	Fri, 24 May 2024 07:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=B0E2pQOSkqRhF1xAHFhIHkcc7dyiyPWFa+UuS2hwL9E=;
 b=RaNx9+/LHgy5W+A3YUe8XXIhw6cJDDkqKVpgRqQZqmSbijOanVxfu7Op6Kz4g9IVgSko
 iugS5RJXEblaNzXnwZShTSpDA4Rd0+A9SAKzSRlO++K5rJmFl5FZ1E5XvJ0ZDZDPUIXI
 ymrpZKvSqFgEFwGJpF57tyitnz5OOLfjh22IyD7N3SISMwkdqqWTpo8cDRBM2RhJJ1UI
 Bm/7O1+bhm7EboHNKmbqiYrpj3JX39k4EM5T8S5ZsvdL5QynVmI5hFpAYmTwvHsgbSbz
 otp1Pmqs6B4lJiZstF8kEGrViJx2R6maIfv6WPcvJc+K71fCiDfT7bNr8qIzglBLtPW0 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7bbdnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 07:05:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O5CIBl002744;
	Fri, 24 May 2024 07:05:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsbhv4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 07:05:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44O740UO037114;
	Fri, 24 May 2024 07:05:03 GMT
Received: from laptop-dell-latitude7430.nl.oracle.com (dhcp-10-175-21-30.vpn.oracle.com [10.175.21.30])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6jsbhv35-1;
	Fri, 24 May 2024 07:05:03 +0000
From: Alexandre Chartre <alexandre.chartre@oracle.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, alexandre.chartre@oracle.com
Subject: [PATCH v2] x86/bhi: BHI mitigation can trigger warning in #DB handler
Date: Fri, 24 May 2024 09:04:59 +0200
Message-Id: <20240524070459.3674025-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240048
X-Proofpoint-ORIG-GUID: J0-c5BRsBuhouwMG-663WjxsFai3Yg4E
X-Proofpoint-GUID: J0-c5BRsBuhouwMG-663WjxsFai3Yg4E

When BHI mitigation is enabled, if sysenter is invoked with the TF flag
set then entry_SYSENTER_compat uses CLEAR_BRANCH_HISTORY and calls the
clear_bhb_loop() before the TF flag is cleared. This causes the #DB
handler (exc_debug_kernel) to issue a warning because single-step is
used outside the entry_SYSENTER_compat function.

To address this issue, entry_SYSENTER_compat() should use
CLEAR_BRANCH_HISTORY after making sure flag the TF flag is cleared.

The problem can be reproduced with the following sequence:

 $ cat sysenter_step.c
 int main()
 { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }

 $ gcc -o sysenter_step sysenter_step.c

 $ ./sysenter_step
 Segmentation fault (core dumped)

The program is expected to crash, and the #DB handler will issue a warning.

Kernel log:

  WARNING: CPU: 27 PID: 7000 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
  ...
  RIP: 0010:exc_debug_kernel+0xd2/0x160
  ...
  Call Trace:
  <#DB>
   ? show_regs+0x68/0x80
   ? __warn+0x8c/0x140
   ? exc_debug_kernel+0xd2/0x160
   ? report_bug+0x175/0x1a0
   ? handle_bug+0x44/0x90
   ? exc_invalid_op+0x1c/0x70
   ? asm_exc_invalid_op+0x1f/0x30
   ? exc_debug_kernel+0xd2/0x160
   exc_debug+0x43/0x50
   asm_exc_debug+0x1e/0x40
  RIP: 0010:clear_bhb_loop+0x0/0xb0
  ...
  </#DB>
  <TASK>
   ? entry_SYSENTER_compat_after_hwframe+0x6e/0x8d
  </TASK>

Fixes: 7390db8aea0d ("x86/bhi: Add support for clearing branch history at syscall entry")
Reported-by: Suman Maity <suman.m.maity@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/entry/entry_64_compat.S | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 11c9b8efdc4c..ed0a5f2dc129 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -89,10 +89,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 
 	cld
 
-	IBRS_ENTER
-	UNTRAIN_RET
-	CLEAR_BRANCH_HISTORY
-
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -116,6 +112,16 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 	jnz	.Lsysenter_fix_flags
 .Lsysenter_flags_fixed:
 
+	/*
+	 * CPU bugs mitigations mechanisms can call other functions. They
+	 * should be invoked after making sure TF is cleared because
+	 * single-step is ignored only for instructions inside the
+	 * entry_SYSENTER_compat function.
+	 */
+	IBRS_ENTER
+	UNTRAIN_RET
+	CLEAR_BRANCH_HISTORY
+
 	movq	%rsp, %rdi
 	call	do_SYSENTER_32
 	jmp	sysret32_from_system_call
-- 
2.39.3


