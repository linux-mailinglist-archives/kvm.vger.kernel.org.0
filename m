Return-Path: <kvm+bounces-7331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 541E8840477
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 088BD2834C3
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DB2627E4;
	Mon, 29 Jan 2024 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dkc2vBBR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C95FEEF;
	Mon, 29 Jan 2024 11:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706529406; cv=none; b=DDpwQECktut7fBlg1HyO59AOpe6xPKJAcas+WUW4VzSU6+PbXZ6l6G6PYMMlRX/RY+YLQBHhCZbpwg0AOyEu85dSnujmgXwphIkCbfWmV86j08oHyc0dV0LtGB0L4As7RmyAc43SI7UNFnhzwZNna8g/HxocfBXVLj5iW1AHbJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706529406; c=relaxed/simple;
	bh=k7bPu+gk7Cd3HeftqicW+V1b6QVdrKTlCbgVbfhaERo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=av6PPxHMcG4Hm/Z4vB3D3pdqSFVxxSuS7xAUnJDfPAtP93b+3FIyZVkfs1BEGNXpEEzeHlja/bAGxt62Ka/PWPHji5rkUIIUd2inEj+nthNmf+2+ULqkdS8n3P65uLo0y/6iwnUgjrz9wFn3kq4bL+82K9vDcM693kn1nVa1U+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dkc2vBBR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40T9i0gO031130;
	Mon, 29 Jan 2024 11:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-11-20;
 bh=hlNIjt1lJtZP47W7eO4KvEIII2+KWpAFpv+PlhUsURU=;
 b=Dkc2vBBRBTvsZlO7T4TvusBg6wHtE9zGXmASy3zOpPc3z8UjHLPM1TBsWZ76zIndlrRC
 Gw3GZpjbYY2BWk2tFcMv39SWwPSxAxUH8V1USGnktX9NBEGF0Wz9qZsxeTECgYi58emX
 Ex7AKWY8WiXDcshhlj9tvAvO+fAbZKI/cRAoG5TYoU/TyPf4NOAYb6h/yTPP+aAHh4/p
 RZh/NBjn7qZkV52izKM87tUUYecme0sQDdQuaG/3dD05ACYnpktR5+836e0KAOvw6GGo
 DQ3ECOjlqFcDF5YnE/tyCvivlBo8g8v5OVz2t/Q8T4yGJ3+XRGnDgbi055jl2K9FsvlL rw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsvdkmjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TBO1J0035318;
	Mon, 29 Jan 2024 11:55:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9bhcye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 11:55:57 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40TBtniG038181;
	Mon, 29 Jan 2024 11:55:57 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3vvr9bhcty-7;
	Mon, 29 Jan 2024 11:55:57 +0000
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
Subject: [PATCH v3 6/7] cpuidle-haltpoll: ARM64 support
Date: Mon, 29 Jan 2024 12:40:33 +0200
Message-Id: <1706524834-11275-7-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-ORIG-GUID: wkUgjNDdhBzF5BVtyM9jPwMQtYzMif9m
X-Proofpoint-GUID: wkUgjNDdhBzF5BVtyM9jPwMQtYzMif9m
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Joao Martins <joao.m.martins@oracle.com>

To test whether it's a guest or not for the default cases, the haltpoll
driver uses the kvm_para* helpers to find out if it's a guest or not.

ARM64 doesn't have or defined any of these, so it remains disabled on
the default. Although it allows to be force-loaded.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 drivers/cpuidle/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..067927eda466 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,7 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
+	depends on (X86 && KVM_GUEST) || ARM64
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on (X86 && KVM_GUEST) || ARM64
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
1.8.3.1


