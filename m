Return-Path: <kvm+bounces-8798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A36C8568A9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C8FAB21DCB
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA231339A3;
	Thu, 15 Feb 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFkFYSZL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A677D20B3D;
	Thu, 15 Feb 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708012909; cv=none; b=BTLa1M6o0cKg6eFSGsgJCEdq+hGjFvouCieS7SiJJND3tBYitlGqyn4GgtJp93U2mWGWIEXC3ATehgO4m4xV8tJ4NxGcTL2kSAa4VG9oWqqacBgAKUAuT4NNZX03TxP0t6cbGTp/O6UqK4qtM8GzIrz+V83kszlNa4QgT5T3aq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708012909; c=relaxed/simple;
	bh=V3kpBue3P3meAyX+1HSi9AH3VSVEyzeJ+FuYYhoELcE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lO4FXJyvjAjH0UDvaIDq/Z17eJ+etOAil441iNYg/UWMbKkhCxwiPrSIO53rFx9kXH2gOdDkMMK15iV/3ynZW6Tkp4OHC67rwYKG6wC7F7nownXFDX3Ks75TMu7RqXeXUYxaxv/8RRmSKbIUrffPv/3dXP1rArEUHMoizH8axG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NFkFYSZL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTYlw030199;
	Thu, 15 Feb 2024 16:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=+NjmOTX3CsrKN1v5/+XuTP0aoVY5fQmXlmcThaiCXH4=;
 b=NFkFYSZLrPtrxgh2N8fN+nX/gLb4b2KU4Bk++MesbmxvSabk1AyZQHh3jHbi9OQGrGAF
 YyG/Vtf/YAxVRgVlZZIZSD8gs5sopt5Ey0pauMOqN9149BYUygPxWcl3FoaWqBGeuy+O
 90n5DU9Xw9kBG5qj+NCX8pf/pW+H8X70rpgG6vCBWEaWbhoDukbH/AOcbU2pkLillhNF
 c89HUllMJ8w33R5z2e9axw7mFw63LvoUkNB7f/mv62f3CUIprOz4CZ/p6an7fYJCR8zW
 ZRsXA8FE/koV6iatHRKx1GgSJcCA/n+xPttM+n6tM18GR+AGbjjjD5LpsMXCcWJdwhJM oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91f02t8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFZh9Z013875;
	Thu, 15 Feb 2024 16:01:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w6apdker0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:01:38 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FG1cZS031601;
	Thu, 15 Feb 2024 16:01:38 GMT
Received: from alaljime-dev-e4flex-vm.osdevelopmeniad.oraclevcn.com (alaljime-dev-e4flex-vm.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.249.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w6apdkep6-1;
	Thu, 15 Feb 2024 16:01:38 +0000
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, alejandro.j.jimenez@oracle.com
Subject: [RFC 0/3] Export APICv-related state via binary stats interface
Date: Thu, 15 Feb 2024 16:01:33 +0000
Message-Id: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
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
 definitions=2024-02-15_14,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=939 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150128
X-Proofpoint-ORIG-GUID: j0Kt_fpUjNlkODnGPzdp7ycg9RdnpFVL
X-Proofpoint-GUID: j0Kt_fpUjNlkODnGPzdp7ycg9RdnpFVL

The goal of this RFC is to agree on a mechanism for querying the state (and
related stats) of APICv/AVIC. I clearly have an AVIC bias when approaching this
topic since that is the side that I have mostly looked at, and has the greater
number of possible inhibits, but I believe the argument applies for both
vendor's technologies.

Currently, a user or monitoring app trying to determine if APICv is actually
being used needs implementation-specific knowlegde in order to look for specific
types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GALog events
by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing tracepoints
(e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easier, but
tracefs is not viable in some scenarios. Adding kvm debugfs entries has similar
downsides. Suravee has previously proposed a new IOCTL interface[0] to expose
this information, but there has not been any development in that direction.
Sean has mentioned a preference for using BPF to extract info from the current
tracepoints, which would require reworking existing structs to access some
desired data, but as far as I know there isn't any work done on that approach
yet.

Recently Joao mentioned another alternative: the binary stats framework that is
already supported by kernel[1] and QEMU[2]. This RFC has minimal code changes to
expose the relevant info based on the existing data types the framework already
supports. If there is consensus on using this approach, I can expand the fd
stats subsystem to include other data types (e.g. a bitmap type for exposing the
inhibit reasons), as well as adding documentation on KVM explaining which stats
are relevant for APICv and how to query them.

A basic example of retrieving the stats via qmp-shell, showing both a VM and
per-vCPU case:

# /usr/local/bin/qmp-shell --pretty ./qmp-sock

(QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['apicv_inhibited']}]
{
    "return": [
        {
            "provider": "kvm",
            "stats": [
                {
                    "name": "apicv_inhibited",
                    "value": false
                }
            ]
        }
    ]
}

(QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_accept_irq','ga_log_event']}]
{
    "return": [
        {
            "provider": "kvm",
            "qom-path": "/machine/unattached/device[0]",
            "stats": [
                {
                    "name": "ga_log_event",
                    "value": 98
                },
                {
                    "name": "apicv_accept_irq",
                    "value": 166920
                }
            ]
        }
    ]
}

If other alternatives are preferred, please let's use this thread to discuss and
I can take a shot at implementing the desired solution.

Regards,
Alejandro

[0] https://lore.kernel.org/qemu-devel/7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com/
[1] https://lore.kernel.org/all/20210618222709.1858088-1-jingzhangos@google.com/
[2] https://lore.kernel.org/qemu-devel/20220530150714.756954-1-pbonzini@redhat.com/

Alejandro Jimenez (3):
  x86: KVM: stats: Add a stat to report status of APICv inhibition
  x86: KVM: stats: Add stat counter for IRQs injected via APICv
  x86: KVM: stats: Add a stat counter for GALog events

 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/avic.c         |  4 +++-
 arch/x86/kvm/svm/svm.c          |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.c              | 12 +++++++++++-
 5 files changed, 22 insertions(+), 2 deletions(-)


base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.39.3


