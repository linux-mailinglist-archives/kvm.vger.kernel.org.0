Return-Path: <kvm+bounces-16171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95EAB8B5E4B
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C82A01C219B2
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8C683A18;
	Mon, 29 Apr 2024 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C30e7yIK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087A839E2;
	Mon, 29 Apr 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406268; cv=none; b=Pmh3242ELbPaC6MIsjw+MElkYVgbZj1K+Txp7+lJABAFeZtN8x/vNPuJbaNkUcQPYmDuko+uNVNqCpAcyCvrx81EGa1mWRStMvf6aNIJdDzcnSDCPlpeJhze9xvAnpDmUO581rQhuLD3w+z4fUDN1Ecemvrf5uVFI84Bt3qE08A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406268; c=relaxed/simple;
	bh=sLrrAHqZlF1X56CXdSNoLpSd8RrM139WBbW+izxEvXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iR2sFbrLs5KDxlLF2T/dwgVBhMe2UOlHG/3rfiIbUvViNrVd+yljSiVmfjNTEqlK6Khsox1BK6GHI9mFNGnqT92mioB5FfbBTWgeIUGfaXdmUrGd+BP0wYn1irwZJRBNXQE0cbmfF3yX+UDOS8yolJGNRbJiskemNIvrPY4t6aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C30e7yIK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TFnZ6f028131;
	Mon, 29 Apr 2024 15:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=NI3ArjhF/GJ5SZWvlrsqW2i59fZz8Art3BAI3Citk0o=;
 b=C30e7yIKf7YFf2BZ0YKapxyUwaT2M42hTa9NDaacHARrp4YlXSygfBpA+woGNKFh4vxd
 1sR6/IJUjUfOB/NaJmrZ64XweKWrO9q0zNtH7ViL3H1JuNtajKBs9jmoeCuK/4qXz8dV
 S4Ryl605sxdig1sFAMnXu9c1gF+xkAASaieveDhjGebnreJZWGjM/htSi0G5gk2qG+ri
 4+tVwLjgE7A6CrCwhoqZrr3F9OhQCVO9z6yuKbamOZP96aNtDsd1t9rBIyU1nxqtj1Qv
 dl8hURL9ef4ytPU+o7ESnXh3EGzunhl4C+kbDaG0OhaS7fxQqBIkKNmTpF9be/zh8NiO uA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrswvjxwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TF7l1T011403;
	Mon, 29 Apr 2024 15:57:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6j93f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 15:57:40 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TFuxjK040299;
	Mon, 29 Apr 2024 15:57:40 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xrqt6j91w-1;
	Mon, 29 Apr 2024 15:57:40 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 0/4] Export APICv-related state via binary stats interface
Date: Mon, 29 Apr 2024 15:57:34 +0000
Message-Id: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_14,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290101
X-Proofpoint-GUID: JooSZhZd6ljsWBVCn_gWkiWrys_PiyNw
X-Proofpoint-ORIG-GUID: JooSZhZd6ljsWBVCn_gWkiWrys_PiyNw

After discussion in the RFC thread[0], the following items were identified as
desirable to expose via the stats interface:

- APICv status: (apicv_enabled, boolean, per-vCPU)

- Guest using SynIC's AutoEOI: (synic_auto_eoi_used, boolean, per-VM)

- KVM PIT in reinject mode inhibits AVIC: (pit_reinject_mode, boolean, per-VM)

- APICv unaccelerated injections causing a vmexit (i.e. AVIC_INCOMPLETE_IPI,
  AVIC_UNACCELERATED_ACCESS, APIC_WRITE): (apicv_unaccelerated_inj, counter,
  per-vCPU)

Example retrieving the newly introduced stats for guest running on AMD Genoa
host, with AVIC enabled:

(QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_unaccelerated_inj','apicv_active']}]
{
    "return": [
        {
            "provider": "kvm",
            "qom-path": "/machine/unattached/device[0]",
            "stats": [
                {
                    "name": "apicv_unaccelerated_inj",
                    "value": 2561
                },
                {
                    "name": "apicv_active",
                    "value": true
                }
            ]
        }
    ]
}
(QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['pit_reinject_mode','synic_auto_eoi_used']}]
{
    "return": [
        {
            "provider": "kvm",
            "stats": [
                {
                    "name": "pit_reinject_mode",
                    "value": false
                },
                {
                    "name": "synic_auto_eoi_used",
                    "value": false
                }
            ]
        }
    ]
}

Changes were also sanity tested on Intel Sapphire Rapids platform, with/without
IPI virtualization.

Regards,
Alejandro

[0] https://lore.kernel.org/all/20240215160136.1256084-1-alejandro.j.jimenez@oracle.com/

Alejandro Jimenez (4):
  KVM: x86: Expose per-vCPU APICv status
  KVM: x86: Add a VM stat exposing when SynIC AutoEOI is in use
  KVM: x86: Add a VM stat exposing when KVM PIT is set to reinject mode
  KVM: x86: Add vCPU stat for APICv interrupt injections causing #VMEXIT

 arch/x86/include/asm/kvm_host.h | 4 ++++
 arch/x86/kvm/hyperv.c           | 2 ++
 arch/x86/kvm/i8254.c            | 2 ++
 arch/x86/kvm/lapic.c            | 1 +
 arch/x86/kvm/svm/avic.c         | 7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 7 ++++++-
 7 files changed, 24 insertions(+), 1 deletion(-)


base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
-- 
2.39.3


