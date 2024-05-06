Return-Path: <kvm+bounces-16771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3EF8BD7FF
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 00:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D9241C230C5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 22:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFDE15F40D;
	Mon,  6 May 2024 22:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jOrSkDXt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB715EFC7;
	Mon,  6 May 2024 22:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715036012; cv=none; b=KlnIPc/3Jm5Q1gkvbgbKhcRESWqSUJKXWPA6FpEo4qzRjaY07V5IVKjoR9++UWsnYwIf0zpBTNbeAaOYdmfzYfHIbjStmg+4Wa+2d26hIEMEyEGoVuedA79jhlU+mwrTJ+xKqJ4CZ7pQ2qedegSdLedj0QOzyunYfpMamJJHEOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715036012; c=relaxed/simple;
	bh=t5m5X8l1lGsaDr6JkMgbUNaOOXPX6KBq64+h46gU6UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WVjAPzyniyXn/MpA64GHWLTSDD4qAvxbpp/rHTUGMkuWVuvwqpLQ9CWUwEaUKCEMjdnRsHjtWbcDv+CEUGsS7f9Q1U3yQHYzMjB7MrPr1xedRpzDwCy1Zj90+mL2exqcKUHfY0aG+gChOwrSB+1C08kesoCSLabYPfRZPd7cCTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jOrSkDXt; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqfiX031673;
	Mon, 6 May 2024 22:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=A2XtzDXeNoRq/ufPaLApKpwk+q93I7X6NJO3p9yDQPM=;
 b=jOrSkDXtWEHagHReGU4sZxpnDGl+tvZdTDmZPj2oUZN5FxumD0tiPQOb9oPsmvbdPlQC
 GBuj/y10W/g2M/KS8IL6pl5d5NpmhA2Zi0QyEVV+MSzpK43CsvDBramfP8k7gdJL3U6l
 b1S9sOSS91TBvjbQvxiDHao4q8gfN9PKHmUwOkC98p6eVCuMyYBQ/KMVpZ07IY93rVww
 HNJUvoYHYMvQrHHcXtEaHQ0ashdK9IksEcxnZLi4BnWbOsIyXa7C9SKj5UAAs4hC1fcz
 /X00pAEd7nVaHR0JbMBoGKV8GntiIBh/MCGWiTt/Fb1J8a3eMM9ngu5goKXB+FcrxM/h Eg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuupqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446LL33H027634;
	Mon, 6 May 2024 22:53:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfdg8n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 22:53:22 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446MrMxA006764;
	Mon, 6 May 2024 22:53:22 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xwbfdg8mq-1;
	Mon, 06 May 2024 22:53:22 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com, vasant.hegde@amd.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 0/2] Print names of apicv inhibit reasons in traces
Date: Mon,  6 May 2024 22:53:19 +0000
Message-Id: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_17,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060166
X-Proofpoint-ORIG-GUID: UKBLgMe9FheJPimU9wUznHLP_WY0ga4n
X-Proofpoint-GUID: UKBLgMe9FheJPimU9wUznHLP_WY0ga4n

v2:
- Use Sean's implementation/patch from v1: https://lore.kernel.org/all/ZjVQOFLXWrZvoa-Y@google.com/
- Fix typo in commit message (s/inhbit/inhibit).
- Add patch renaming APICV_INHIBIT_REASON_DISABLE to APICV_INHIBIT_REASON_DISABLED.
- Drop Vasant's R-b from v1 since implementation was refined, even though the
general approach and behavior remains the same.

v1: https://lore.kernel.org/all/20240214223554.1033154-1-alejandro.j.jimenez@oracle.com/

Tested on Genoa system. With the proposed changes, the tracepoint output looks
like the following examples:

 qemu-system-x86-7068    [194] .....  1397.647770: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4 ABSENT
 qemu-system-x86-7068    [003] .....  1397.676703: kvm_apicv_inhibit_changed: cleared reason=2, inhibits=0x0
 qemu-system-x86-7074    [247] .....  1397.701398: kvm_apicv_inhibit_changed: cleared reason=4, inhibits=0x0

 qemu-system-x86-7074    [008] .....  1408.697413: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x100 IRQWIN
 qemu-system-x86-7074    [008] .....  1408.697420: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x0

[...]

 qemu-system-x86-7173    [056] .....  1570.541372: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x300 IRQWIN|PIT_REINJ
 qemu-system-x86-7173    [056] .....  1570.541380: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x200 PIT_REINJ


Alejandro Jimenez (2):
  KVM: x86: Print names of apicv inhibit reasons in traces
  KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons

 arch/x86/include/asm/kvm_host.h | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/trace.h            |  9 +++++++--
 arch/x86/kvm/vmx/main.c         |  2 +-
 arch/x86/kvm/x86.c              |  6 +++++-
 5 files changed, 34 insertions(+), 6 deletions(-)


base-commit: d91a9cc16417b8247213a0144a1f0fd61dc855dd
-- 
2.39.3


