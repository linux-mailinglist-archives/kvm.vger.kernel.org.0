Return-Path: <kvm+bounces-14891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4482B8A75EA
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 003AF282B44
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179755338C;
	Tue, 16 Apr 2024 20:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kUHeEz6z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDC24315B;
	Tue, 16 Apr 2024 20:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300459; cv=none; b=kOAFjPBkDT87VfEuILTqRdXGY0PMh1nRrAvy1pVdPSbov5oV7ikaR15ZgiUjB2PNQglSrNh/NecPxv4U3ECIwyXGmDSOebA+SawP9CoCUR2+p3HWYN5ogFvQD8qBNk6WV+al66XCASA58npjyQXf3GIrL6XqgtJMwpPRLybZthM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300459; c=relaxed/simple;
	bh=sHZ70WphkG+mYobRvEaiJSM2HM+D/4WJgqMLw/E/qg0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jUL2Z1Y/naBWoUSpsYdJYXGd451H/RwdXBye5QYJTz3zoHqrRgjwaHepf4S9ewt17BgbsTFvE8iPD64anypd1qTnpsbTKESEGV7+YSIL3u8M+UJ2Bz5nk5k2XgLFUgTeYeZ39JWe8EsTOWvpuMd+gdgCGF8oTZo5aDvlFnlVPFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kUHeEz6z; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJju7K006461;
	Tue, 16 Apr 2024 20:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=I8c2MHcIh6zhRXVAVEyIPq0j0sNudTyJwUHR7heApzo=;
 b=kUHeEz6zCgRFCdZF1e5nO244Enp9BZHy8wanOfg1NRlrL94pXbwrZyXxPddjmVT4R0d5
 BLQQRySXOdjnewfrdWpGVBJ2F7x0HC6B8Pb6sjVOf3g8ZX4u8bR0MZYIAfQsdM766+gO
 KHduz2o1/EFI4U51Xmlf+2abpr9MS0TBwkyJGQl8Sb7v5VPzOAYJDbk27daeHGY7ulqs
 tCUrnVJZUijK2mMEs51VUyzLEObU/cWqVtX6Py6K+HSe0aUkwjgto1+RFyllz5v4PAA3
 inR9LfkJqWft3p8Wzi6k+9hKKm8S3ECpcm944ylhKF8tz0tC2orNAZ44G+D5mj3stznG BA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2paee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 20:47:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GKjN6U004355;
	Tue, 16 Apr 2024 20:47:29 GMT
Received: from bostrovs-home.us.oracle.com (bostrovs-home.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.254.198])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xfgge32vh-1;
	Tue, 16 Apr 2024 20:47:29 +0000
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Date: Tue, 16 Apr 2024 16:47:29 -0400
Message-Id: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
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
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=918 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160133
X-Proofpoint-ORIG-GUID: W3SfqcGs4ClkKsf_37POG1ZbFgSYcSkM
X-Proofpoint-GUID: W3SfqcGs4ClkKsf_37POG1ZbFgSYcSkM

When a processor is running in SMM and receives INIT message the interrupt
is left pending until SMM is exited. On the other hand, SIPI, which
typically follows INIT, is discarded. This presents a problem since sender
has no way of knowing that its SIPI has been dropped, which results in
processor failing to come up.

Keeping the SIPI pending avoids this scenario.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
I am not sure whether non-SMM cases should clear the bit.

 arch/x86/kvm/lapic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf37586f0466..4a57b69efc7f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3308,13 +3308,13 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * INITs are blocked while CPU is in specific states (SMM, VMX root
-	 * mode, SVM with GIF=0), while SIPIs are dropped if the CPU isn't in
-	 * wait-for-SIPI (WFS).
+	 * INIT/SIPI are blocked while CPU is in specific states (SMM, VMX root
+	 * mode, SVM with GIF=0).
 	 */
 	if (!kvm_apic_init_sipi_allowed(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
-		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
+		if (!is_smm(vcpu))
+			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		return 0;
 	}
 
-- 
2.39.3


