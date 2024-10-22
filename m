Return-Path: <kvm+bounces-29393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B559AA1CC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 442522835ED
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98C119D07E;
	Tue, 22 Oct 2024 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gtja4ZOR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E07019EEC7;
	Tue, 22 Oct 2024 12:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598778; cv=none; b=JI8vf2PVjNH8V4n0fjqkiqB6dmWJvT6ziqJl91r2To/1p6NOR2grF/5ffUZLxbpbn6E74NgU6YaA2L7EiWD38B8rNjZgN4HrVC2GyVBbhkUELlSkMW67hC8kGi9i7FMrg4fCvcuGqs0aN5OVmEAqorS+s2GE+T7MQGVll2mFsqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598778; c=relaxed/simple;
	bh=39oSipGDXH9p1T4K8H6XcCxakzf8Fn/NsTJugMKljtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3KILQQnXybdyk+c2/gQHn7bKhyamGXHGutgnly+BM+tJHMu6rf0eb3ApficTt7R6zzC+nYASaib14K1UgH1K+0nKEpQMxW37z8qCEww+mPJXzCQLvHUNc0haNbry3137c+rsv215aYxlNqbVhB4b3Vv2AoTl6xcMA4wCAQu6H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gtja4ZOR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M4KW4k004606;
	Tue, 22 Oct 2024 12:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FUZLhdRDl2ic51Het
	OVDs8c+zc3+2YK+1ohzJjc6My4=; b=Gtja4ZORGLpDRmQgqMxmSHMPcxxCGZzzp
	F+AS+86jrLKkCXXhYUQfor756grHZVKaROojBjQQcCafckS36lgaXbuhaPzfOBHo
	cv8LKuiNgc/kO/7VoNbZTNC4MT7YEvUJzOe4wnk5QDahRVL10NHqbJB+a/1j1Kf6
	GkHeXjVRCUh4N6DP+9XYjRz5ekyjRqHZhuz3nyKkZwyFyfXIIp69eV1If7/PBwAV
	KPacBV7PfzNWn2Ev3llFUDeBT4AMtBXbcL8nTY7TNPvhzE4inTWDPLYXYvrTIFbX
	HASV6QmoBj+nF2Fsu5/6Pl4tZf63ohtmmC/bObqUCXuga9YC4/kaw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42e4xfhnrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MBGvki023927;
	Tue, 22 Oct 2024 12:06:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cst12scr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC6AC320251034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 410C020040;
	Tue, 22 Oct 2024 12:06:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A20D220043;
	Tue, 22 Oct 2024 12:06:09 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:09 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 08/11] s390: Remove gmap pointer from lowcore
Date: Tue, 22 Oct 2024 14:05:58 +0200
Message-ID: <20241022120601.167009-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bf_8Vt_KDaKs6TICJzc_WEJxr4LlXn4F
X-Proofpoint-ORIG-GUID: bf_8Vt_KDaKs6TICJzc_WEJxr4LlXn4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=601 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410220074

Remove the gmap pointer from lowcore, since it is not used anymore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/lowcore.h | 3 +--
 arch/s390/kernel/asm-offsets.c  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 48c64716d1f2..42a092fa1029 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -165,8 +165,7 @@ struct lowcore {
 	__u64	percpu_offset;			/* 0x03b8 */
 	__u8	pad_0x03c0[0x03c8-0x03c0];	/* 0x03c0 */
 	__u64	machine_flags;			/* 0x03c8 */
-	__u64	gmap;				/* 0x03d0 */
-	__u8	pad_0x03d8[0x0400-0x03d8];	/* 0x03d8 */
+	__u8	pad_0x03d0[0x0400-0x03d0];	/* 0x03d0 */
 
 	__u32	return_lpswe;			/* 0x0400 */
 	__u32	return_mcck_lpswe;		/* 0x0404 */
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 3a6ee5043761..1d7ed0faff8b 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -137,7 +137,6 @@ int main(void)
 	OFFSET(__LC_USER_ASCE, lowcore, user_asce);
 	OFFSET(__LC_LPP, lowcore, lpp);
 	OFFSET(__LC_CURRENT_PID, lowcore, current_pid);
-	OFFSET(__LC_GMAP, lowcore, gmap);
 	OFFSET(__LC_LAST_BREAK, lowcore, last_break);
 	/* software defined ABI-relevant lowcore locations 0xe00 - 0xe20 */
 	OFFSET(__LC_DUMP_REIPL, lowcore, ipib);
-- 
2.47.0


