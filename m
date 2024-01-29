Return-Path: <kvm+bounces-7327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C4E84046C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D35541C22774
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F7060DC0;
	Mon, 29 Jan 2024 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQ1/4K1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E655605D6;
	Mon, 29 Jan 2024 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529404; cv=none; b=CrmpZisX3TVnegHLjkIR/i6Tcys65cxTMiITXl5j+EFS3j44m7qKdn/vnS9dvH1ZYV1wpRuCqqkKLEL39rCoXQfrXGfrEvFellvjJsjh33+p48CqcwGm6wAxXzWUEPRlTBg2dFKc0QV6DG51/20IV7nW2Ao5FMb7RfCBDPllzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529404; c=relaxed/simple;
	bh=eUrYOv/I6w1LdM+8mRRNgh2P64wGG8rbjX/OC7dZZ20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dNaDGzaAdB1Oz+S5n0eQ0egH1SioGVp7VzgwVWFUUfsn0pWKOGK1kyOz/UmPcs52e5iaIdwJcYq/doL2zo0iBcbp3uJwQbVt7P2tIREo2EkhqhMMim1fJPD7PbTLcut19geRcKbyZ1g1mZV7BI/fQAyKaAVfmU12jWFdSdaDsQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kQ1/4K1Y; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9htgq018239;
	Mon, 29 Jan 2024 11:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=jKh03mWKDcqOuOF269GXLPEMVoDT9umYR+fPhiDsATQ=;
 b=kQ1/4K1YV4SWbWkHP//cQ1eBzbeSSqsho4EfltLWxhd5idIQ0KcBAxplwx0suHq0X9Z3
 IOlnEI9PlCCWDqC6/VV8gREu0XJvwsAO7+NAd0ARXKFlMysyxFIvn6gxjjDAYy6Zc7cP
 WC2yjAPGE6g6XY0j2CjdGqJ7pPJ7IgfnaenGTzqFtUZn/hIj4IRBgyH7RPOGVHbA3T+h
 gyhR4Oscbt4B6BMxQZyp2w9hhx1ZOK5gKZeQ0LgcVJMQmjt+65AuB8K4av3bScrTn2F7
 Fdm5zKOhDkt1nWQU15zTtmIat2OLgdckbvAN+drRsaOmkfHonZvi+LBOouWMaHxsVFcL rQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ebmny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TBEgP1035372;
	Mon, 29 Jan 2024 11:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:55 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtniC038181;
	Mon, 29 Jan 2024 11:55:54 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-5;
	Mon, 29 Jan 2024 11:55:54 +0000
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
Subject: [PATCH v3 4/7] arm64: Select ARCH_HAS_CPU_RELAX
Date: Mon, 29 Jan 2024 12:40:31 +0200
Message-Id: <1706524834-11275-5-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_06,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=985 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290086
X-Proofpoint-ORIG-GUID: ngYiJl-lfd-jlYaw52nRdQ-t_T4WdWB-
X-Proofpoint-GUID: ngYiJl-lfd-jlYaw52nRdQ-t_T4WdWB-
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

ARCH_HAS_CPU_RELAX controls the build of poll-state, so select it from ARM64
kconfig.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 78f20e632712..24adbe9a2aa6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -106,6 +106,7 @@ config ARM64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
+	select ARCH_HAS_CPU_RELAX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
-- 
1.8.3.1


