Return-Path: <kvm+bounces-15047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B65D28A911D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 04:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44C2EB21066
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D403D4EB43;
	Thu, 18 Apr 2024 02:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FpNPlP36"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5959E29A9;
	Thu, 18 Apr 2024 02:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713406719; cv=none; b=nqPX+SKRFexhuSFDOfQxzX5nHrtLYlCwLFOdwaju/yxI7YHfk2bjRerK5cUGgCEd7ktoXQSirmhj/rSYpWyvAi7BtA0CbkkqnYpHpW6QP4fvaM+rw9tCNNfpDx4hrTh2d8v6CmL29siNBOxbRppBuCQuALwm4ohe9taA0qt9rcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713406719; c=relaxed/simple;
	bh=LdBOiQwvjg5Kp+MeXZph3ue8qXhzEm0I8QJrxpgzuGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fKChnRH37Jf8ZQzKYto4H0ev9u18BYx9eaVejeuRZJvsamoyCvQygExz0je09fHadQv0BOfkFOvT98y4Zm+ocO2KZwquPXEDAVHW9QzwACtNKZvUktnXl90mTs0Q7QwF98DAphFBVwr5Z1oa04R1ua4+H/SgySKZ7bz+tagF0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FpNPlP36; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HM4eYX005387;
	Thu, 18 Apr 2024 02:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=hNrEjDB9bjRSHaUcmPAg94SOw3Fy9F6a5F/ZJLVVE+4=;
 b=FpNPlP36jEI4gOopMjgC1HzMKrvNc1k2uMYdjbg5FzGW5pjryWvsY9F7BzlK2kO9eYNM
 Zi27ClStCiRtkZdDTeoN873eWWheeOT16UPvlpBlqzjx1ZXwk7hMeUzkl0iYcITwj8EF
 0qO3sVNyjgAnFTF7aAbJNCpV4f5+Gin5lMT9bcocKLYUOBUs4drZeN6Q/Eu1AnGSk8z4
 QaPl+cqnZkRKqGaAGWUXXsqJjW2ggC8Oj34lBbMoy86ObnwAphccW8nMELLP6++xPuXE
 WZ4u8TTo8wrWq6yLf2PzN5OyXydW/Uqp+uyzOYQLnK10KnaQMV9fq1xeAySxW3C8PV7E 4Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfhxbs66j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43I04cYt029294;
	Thu, 18 Apr 2024 02:18:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg9qa20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 02:18:30 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43I2ITLo012052;
	Thu, 18 Apr 2024 02:18:30 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xfgg9q9y8-2;
	Thu, 18 Apr 2024 02:18:30 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org, seanjc@google.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
Date: Thu, 18 Apr 2024 02:18:22 +0000
Message-Id: <20240418021823.1275276-2-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
References: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
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
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180015
X-Proofpoint-ORIG-GUID: HVQxBm7xcUsyr1U4AaL_Ee7-llFMD3X8
X-Proofpoint-GUID: HVQxBm7xcUsyr1U4AaL_Ee7-llFMD3X8

Use the APICv enablement status to determine if APICV_INHIBIT_REASON_ABSENT
needs to be set, instead of unconditionally setting the reason during
initialization.

Specifically, in cases where AVIC is disabled via module parameter or lack
of hardware support, unconditionally setting an inhibit reason due to the
absence of an in-kernel local APIC can lead to a scenario where the reason
incorrectly remains set after a local APIC has been created by either
KVM_CREATE_IRQCHIP or the enabling of KVM_CAP_IRQCHIP_SPLIT. This is
because the helpers in charge of removing the inhibit return early if
enable_apicv is not true, and therefore the bit remains set.

This leads to confusion as to the cause why APICv is not active, since an
incorrect reason will be reported by tracepoints and/or a debugging tool
that examines the currently set inhibit reasons.

Fixes: ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no APIC")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
---
 arch/x86/kvm/x86.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26288ca05364..09052ff5a9a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9995,15 +9995,14 @@ static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 
 static void kvm_apicv_init(struct kvm *kvm)
 {
-	unsigned long *inhibits = &kvm->arch.apicv_inhibit_reasons;
+	enum kvm_apicv_inhibit reason = enable_apicv ?
+						APICV_INHIBIT_REASON_ABSENT :
+						APICV_INHIBIT_REASON_DISABLE;
 
-	init_rwsem(&kvm->arch.apicv_update_lock);
-
-	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
+	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason,
+				   true);
 
-	if (!enable_apicv)
-		set_or_clear_apicv_inhibit(inhibits,
-					   APICV_INHIBIT_REASON_DISABLE, true);
+	init_rwsem(&kvm->arch.apicv_update_lock);
 }
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
-- 
2.39.3


