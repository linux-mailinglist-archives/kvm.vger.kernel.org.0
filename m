Return-Path: <kvm+bounces-7325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F007840465
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F34311F22B64
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC13760275;
	Mon, 29 Jan 2024 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nBMoaWfX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7F60868;
	Mon, 29 Jan 2024 11:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529401; cv=none; b=QxppGypOcBgCcthXfs1S5v8mQlYOjVanEUrBL0YS0asJFa1nLhks6gLhxmWE/LsyIaCrKTm8TpWwMvWWSV38arIKEIJm837smcEQQJFtfOp/utbU1zJltzf4wYuMNlxwJgWhTZFvoZo/Fj1BD3NblVHWUbKWJbAE5CahPlF2Rdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529401; c=relaxed/simple;
	bh=xi7YP0n2K4yFSd2jqDSsLMpbqfYwHLVWBJxbmKyKXX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=MlNLfinyUCPovoCx3FGPbcrMMfjZCy97SXTbABqIC3vbETiYSjxglT7eoQK+Nj1yG5ohNF0luF5zK+vLvJfWJrmyObue5hrtq/Nbx5wxFw1o/8fe+4dNXPj86FEsm8nHg+Fm6k5LH/TN7A05zq7ZZ9B0ejwwGFJ1Xicy1n7E2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nBMoaWfX; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9iRll015940;
	Mon, 29 Jan 2024 11:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=Z9qDnSm8OWwlAaxt9Fnk40RHUt26ekA0qcYXgbx3N2g=;
 b=nBMoaWfXQOwOo7LbAMW6V8tOZKPfKrMMieXrkRf1tVlkxeRGf+Ix4EAEakx03U3o109q
 JpXuiv/8jSZ0UCmYCglo2kw1RiCn254trrQpD+QpL7xXsa8hS11NRB+AQsY68lTDy1Jm
 qAmkDThI4QgLMZgrBudZn0G9A+thCt4FPPrrDXz4BDi2NTQVdOxPpsn2cTOEMRHMzZO+
 eJqshjbeN7f/BKbK7om5XpginGKJPABrl6K7oTK+JgRtUFjtk4DF0H8u9YYbFr2ZPMVX
 6IV6Eo0DeF3RLg3XNoiI/DO/jZuwL7Z6c61Ng7/mMvC+t7neBlNGj9h7zD04scWhRtGx 6g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcuukg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TBEgP0035372;
	Mon, 29 Jan 2024 11:55:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtni6038181;
	Mon, 29 Jan 2024 11:55:51 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-2;
	Mon, 29 Jan 2024 11:55:51 +0000
From: Mihai Carabas <mihai.carabas@oracle.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, mihai.carabas@oracle.com, arnd@arndb.de,
        ankur.a.arora@oracle.com
Subject: [PATCH v3 1/7] x86: Move ARCH_HAS_CPU_RELAX to arch
Date: Mon, 29 Jan 2024 12:40:28 +0200
Message-Id: <1706524834-11275-2-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_06,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290086
X-Proofpoint-ORIG-GUID: TIDgASBHJXYtnPx3Vf4e7156qe29GyW2
X-Proofpoint-GUID: TIDgASBHJXYtnPx3Vf4e7156qe29GyW2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

ARM64 is going to use it for haltpoll support (for poll-state)
so move the definition to be arch-agnostic and allow architectures
to override it.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 12d51495caec..626ddd9ba7e0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1371,6 +1371,9 @@ config RELR
 config ARCH_HAS_MEM_ENCRYPT
 	bool
 
+config ARCH_HAS_CPU_RELAX
+	bool
+
 config ARCH_HAS_CC_PLATFORM
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66bfabae8814..aaca90ba791a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CPU_FINALIZE_INIT
+	select ARCH_HAS_CPU_RELAX
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
@@ -363,9 +364,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
1.8.3.1


