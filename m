Return-Path: <kvm+bounces-18043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E97C8CD253
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 514BC281208
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF38F14901E;
	Thu, 23 May 2024 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qt/z69XK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FB7148824;
	Thu, 23 May 2024 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716467635; cv=none; b=d4h+cgqlyrfjSm+m0ezkbBM8r7ywH4gLr4U6BD7prrDtTUfI/M2NajJoOkVpWnDejcF/JlMP39uKJlcb0PSUs+lMRdCggGRM4Qg1eyP8TlPkL1Zh09OMNvJtfmXm2b8EX1CuxLktWNUdZVSxC3NhMuvTFEQ6gQVGeKY7+2o9//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716467635; c=relaxed/simple;
	bh=smrF2fUmUHA7xyyomoTkTTinVqiDpVSE9fy64YqQQIw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ADwMS0kk6/gkUQEPEWE0neV/58Ja9NsmFd9+FeeJDK/wbVYx8sJXWimIS5GlA5LrkOiP2YQ51GSZkicx24f8H+8jDZeYdYBhFE3qkAnEq0qj7bnNzTfzsKVqB3z17PdyaOePoOmDLKkHaWsppxzWEk1YbeCHlkFoE8NgcUbOT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qt/z69XK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44N4xBDA032362;
	Thu, 23 May 2024 12:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=TG9RpsRGFzzFo4NixL4rHOJgwqr4kHslcW8q4P+LGVM=;
 b=Qt/z69XKEHsvrxyNZ+5fmHvUp118mNkGvV5fLuAKclnXE3MxnaMOg+gkfZFos4YJtAoU
 hA98aC0FtfmRYMvRgADAw8zbRUPEz+X+nX5mxyis5SoEKGHaNdyAt/9gftEouPgHCWM1
 RCob7mwm8HQrurZqD7/8TXBqHLk1yLtqWhDzFDZp3StI1BEUCDWD3ScHe65nTH/NEt+5
 8jSbI3/OkDDDxGWrg7LpoO8d3koMxMx+Gf2A9ftHwzGMQfAIOUDEgcqX+8jw2p9PA2jr
 oC6rhj5uvxTyHZi7bL6Zo5e5pCBWI9hG2rnhOeLC81Bj3Gphm8A6GQmExN5gpDqs76IY Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6kxva1g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 12:33:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NCC6o5019515;
	Thu, 23 May 2024 12:33:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsahjg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 12:33:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NCXP6F016719;
	Thu, 23 May 2024 12:33:25 GMT
Received: from laptop-dell-latitude7430.nl.oracle.com (dhcp-10-175-24-91.vpn.oracle.com [10.175.24.91])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6jsahje8-1;
	Thu, 23 May 2024 12:33:25 +0000
From: Alexandre Chartre <alexandre.chartre@oracle.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, alexandre.chartre@oracle.com
Subject: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB handler
Date: Thu, 23 May 2024 14:33:22 +0200
Message-Id: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
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
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230086
X-Proofpoint-GUID: dVpr_7H5SXUK8Sw610ASeh_7ItQhnjVO
X-Proofpoint-ORIG-GUID: dVpr_7H5SXUK8Sw610ASeh_7ItQhnjVO

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
 arch/x86/entry/entry_64_compat.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 11c9b8efdc4c..7fa04edc87e9 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -91,7 +91,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 
 	IBRS_ENTER
 	UNTRAIN_RET
-	CLEAR_BRANCH_HISTORY
 
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
@@ -116,6 +115,12 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
 	jnz	.Lsysenter_fix_flags
 .Lsysenter_flags_fixed:
 
+	/*
+	 * CLEAR_BRANCH_HISTORY can call other functions. It should be invoked
+	 * after making sure TF is cleared because single-step is ignored only
+	 * for instructions inside the entry_SYSENTER_compat function.
+	 */
+	CLEAR_BRANCH_HISTORY
 	movq	%rsp, %rdi
 	call	do_SYSENTER_32
 	jmp	sysret32_from_system_call
-- 
2.39.3


