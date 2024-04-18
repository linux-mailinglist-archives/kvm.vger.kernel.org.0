Return-Path: <kvm+bounces-15049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E174B8A9121
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 04:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51E1A281DE2
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FFE4F889;
	Thu, 18 Apr 2024 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IVpx+GvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB33543AAD;
	Thu, 18 Apr 2024 02:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713406719; cv=none; b=Ebk1L66fUkpguv/4k4UyHguZ04X00HDVwHIPTuZhlUMAGcCVofmpDu7JumdBbE3ZYW4EAoP8G18tOElJzstlRx9AIGefloAQZ1HahbNCKq8VOM8Gs98xXQSzSB9EQDpLfT3KqM1VbuIeaB5IcWYnCVLLCYaqrybYs4DcImsv8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713406719; c=relaxed/simple;
	bh=4nGTBiDvzsV3UPPg4p0qRTy7EDCT600LVYyPJv+rr6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jo7g6qj9MU0Gl9ryTWi8B03CqxwtuZe9sn3/kMPh8WxXmSsIi/Nkn/gnKe3a0t2YQzvBND2idmNSZRszQVLiZpeg3cVJ3ekCJ3gG8s/A8AR0Qn5l74jXTYJN2gPJlj6QrnIrtLR6pdmPSZBSB0gVoL0jTTfhwYdn4VT4HrVXLt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IVpx+GvJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HM4dSZ011199;
	Thu, 18 Apr 2024 02:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=oeI3mdv5Vths/wN59qgdVlMqlhdifdF9wFALCHB7w0U=;
 b=IVpx+GvJs9A1QTPoqgWO/2IrcrpsEgS2osF7fJTqYZosI6ID0R8tcuVQGhHJzIacU75o
 +iRyQe3a1Zyoq395CQ1PvSke7Nt2/tgfQsYG2uFmtsGwinPrZnRm2ZTCcOKcnuYmYfqF
 iIGYDC3rF9aq5hssCsCx8razofQurM7S4402NX02bg7xKk/GkMmkT7pdfgRUz8ThTCls
 tfOW2wW7K8vkIqo6J0EHMIjtg6WivZD6R4G/vPmcOPKCwE5khORUgkz87yHFr4qEqXad
 VccjZn5lx0QSKQhTwy7hVZwBMZrn+HIir48eeSe7ukcAyWZZcC7pRcp/6lYKRgxpjSbD sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2s9g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43I0nopC029348;
	Thu, 18 Apr 2024 02:18:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg9qa17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:29 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43I2ITLm012052;
	Thu, 18 Apr 2024 02:18:29 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xfgg9q9y8-1;
	Thu, 18 Apr 2024 02:18:29 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 0/2] APICv-related fixes for inhibits and tracepoint
Date: Thu, 18 Apr 2024 02:18:21 +0000
Message-Id: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
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
 definitions=2024-04-18_01,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=834 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180015
X-Proofpoint-ORIG-GUID: 9SHXZgIpiwjg9Wgs_EyViWlgUKCJMUPE
X-Proofpoint-GUID: 9SHXZgIpiwjg9Wgs_EyViWlgUKCJMUPE

v2: Add Sean's changes to [PATCH 1/2].

--

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
 arch/x86/kvm/x86.c   | 13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)


base-commit: 2d181d84af38146748042a6974c577fc46c3f1c3
-- 
2.39.3


