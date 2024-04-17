Return-Path: <kvm+bounces-15005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4908A8CC4
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E36261F212F1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBDC38F97;
	Wed, 17 Apr 2024 20:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cdSGUfdg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955CA208D6;
	Wed, 17 Apr 2024 20:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713384539; cv=none; b=X9ZfmKx7rfB4SEGv7KPrgHHYpOBKoxLIMLJJ3SJT0PtOJGImXYJwnbG6mSkkOZ9F3m4Gpk9jXPi+7wQdl95fonGfa4Mzfhgp+rLmRaC4cWJGi7gFnHNRoMHYHUlnJ8yR2IElYBH6rwSJugDHlOcDVqY1mO9ueH6EfCeglzKD+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713384539; c=relaxed/simple;
	bh=VknEffKHj1PZgH1uEn80nMcT9jnRsgJX/G/Okxr0uLw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mIT4V1sXO09cwI6ItidDc78/YPjkeME/F36SbsKH8XPQ9mXLhhDEDgLuFy0zxcP90fo7N8VXLpSf0YRrUOmY9lReFk5nkphG85xGBLLJW4wRWyvT53uZPKMZ5b/K9YWlSUHYYidFIS5mEbD0Yz9/Qok6LzzSUENLSPmalUUmoXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cdSGUfdg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HHiU0q019589;
	Wed, 17 Apr 2024 20:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=+aPlqRckBAt6+fQx4OcscVJKfAl7LjDyQP0GzpxXAb8=;
 b=cdSGUfdgJYx1KuJd4kq5K1A+vNJRj4bjbtGFJz48TLVK+fuhh53iIedyQVmYPe6Crjrg
 Xi2hgweBj8VMo/5eYHoIPI0F6jx3Rectl8/E9uGFDaBj+BFNykfTRbmj6PsMgDCLEgpN
 Y14Id791faGW3G/he7A6ZbHbOqtz5iHEVrulL3p29kyAAGl3kU683xO5tQFwYvenv30F
 QYfaCu6T+WkUgNreI37DIzSXRvErTQblpdAjKwOG50NbToO4uZazC6c/L1ULw7yG8gJ3
 cHE9YLL31F/0Lkq+tg54mtvCT9cVOpnuZTAJwMrlvbZsNc/LWdlrEmWd9VuBxvUobkfs tQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfjkv8s7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43HJ5TkB021596;
	Wed, 17 Apr 2024 20:08:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggfny8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 20:08:51 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43HK8oFN023405;
	Wed, 17 Apr 2024 20:08:50 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xfggfny84-1;
	Wed, 17 Apr 2024 20:08:50 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH 0/2] APICv-related fixes for inhibits and tracepoint
Date: Wed, 17 Apr 2024 20:08:47 +0000
Message-Id: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_17,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=833
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404170141
X-Proofpoint-ORIG-GUID: WxQu117E2HJlDsifUKJhCnhl-4BDbA__
X-Proofpoint-GUID: WxQu117E2HJlDsifUKJhCnhl-4BDbA__

Patch 1 fixes an issue when avic=0 (current default) where
APICV_INHIBIT_REASON_ABSENT remains set even after an in-kernel local APIC has
been created. e.g. tracing the inhibition tracepoint shows:

<...>-196432  [247] ..... 70380.628931: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4
<...>-196432  [247] ..... 70380.628941: kvm_apicv_inhibit_changed: set reason=0, inhibits=0x5

and the reason=2 inhibit is not removed after the local APIC is created.

Patch 2 modifies the wording in the pi_irte_update tracepoint to make it clear
that it is used by the posted interrupt implementation of both vendors. I have
reservations about modifying the tracepoint output and breaking user scripts,
but according to recent discussions tracepoints are not strictly a stable ABI,
so I'd consider this minor change to avoid confusion around this area.

Thank you,
Alejandro

Alejandro Jimenez (2):
  KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
  KVM: x86: Remove VT-d mention in posted interrupt tracepoint

 arch/x86/kvm/trace.h |  4 ++--
 arch/x86/kvm/x86.c   | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)


base-commit: 2d181d84af38146748042a6974c577fc46c3f1c3
-- 
2.39.3


