Return-Path: <kvm+bounces-46428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE62AB63EF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92F6D3BF0B0
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FBF42040B6;
	Wed, 14 May 2025 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="duZ85zvw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF474C7C;
	Wed, 14 May 2025 07:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207109; cv=fail; b=dzU+llxaVk5LTzselEztUdJ5UM691HWfYqO37Djdl3Depbm6tnwGDQi//EoskuWzX+FQGz7F+od64IZEp0bMhr3QhymkPDwjpCdjEIlh+Mm+ScKh4JDk5Hh+ev7ACMtFVZkZrJssFbdrzsauPyYxiAlZ1tRykmivMJWle8kXyg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207109; c=relaxed/simple;
	bh=7w4AM7XjWgjvK82A4umaBqcJpHROHI3xsHEOON8PGSk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PQxsOPYdlovub3v0XzJt17LaZ2kHaotNCAFCtk/ls5waqXkeQi4MbB0ADetrqGtAiRHRIz0AIQHpib/xri2F8Lc1RR52rJY9UsXf5jj5fleqg90xGih5XZc/IVk4miyytHnrCWZPKWDwZfxyuEakL96L3ZmCKH9AXjnV84DXDko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=duZ85zvw; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOiE9c3HOhXdHkI1CGWjw2cZ8QabijMASpO2E2gy/r2UPCdUfjOG5PpyLZjXPvNG+bJMHkGchhyslnwVQXilfSB0NVNtI6bTGmNWcWq8XD5A29MOauAM7ZdQZ8KGBCv7JTeT0y+Prma0/ND745cPEtslYWMCWqVfkoiaxL+gyoLoIzE4HPoG5K01HXPrCD7XRiXRC+OUNgKUrCF++QE7+0f64p92TacKDruoJlDD2RQ82XVkqhm66pUe1z1Ott5jHfSFdIOQYsg4BFtWGY96FlK7iJ5wedyF98nIMTNLjHklR+c7gEil9Fm0Lg8xQnhTHcyltrgAegKZctdeUPAv4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzsYyyoPBBUyLX7d2m0IMLOYeteuUsaa5fvxVNSggmY=;
 b=bAcw6p5KFMLYIKRYmOtFXUB9cM8L6BqtJ0pBKcnC6Z2RhaDhtujF+CU45vRCX2BJbrMKWGrDnIVvDm6hb/c8rov+JK+cLa3zJfKDn3buv6z8uCxS5gSfmaVCwKficf7F3COfxgNBpyk/D+SdIHGjzVaRdhpj6DGBENvXYfqoiIiePZ8E3O+BH1gIQNSQKFr9Zk+mt+zPkPdTx6LUa8cisaQkTaGg/xw3wNoO66y+hXt0PJUWbTpwCFc2sHxEI+VKFqBVibjLF2GidPpQEJ09+unzZE8QA730KSw98CG+TmIppuo1Cl2l0QpoU4B394s+wmZPUcLIfGn1tEx6zHbung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzsYyyoPBBUyLX7d2m0IMLOYeteuUsaa5fvxVNSggmY=;
 b=duZ85zvwMf3JfLQCQtBMSGGkSOVFtb5KmhkpQJ2yR7AvEYZRnyhraNrb5WUOaGCkqISUM6o/qti6eAilMYXmSqPOusRG6otpw17Cfp0WowjY3jyncjZk8cVtgx3rh7tjYNtaHczPpawTQ/yAaRI8nOTxCrCMDS1zWwST7mBNbz4=
Received: from PH7P221CA0080.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::34)
 by DS2PR12MB9712.namprd12.prod.outlook.com (2603:10b6:8:275::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 07:18:21 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:510:328:cafe::1b) by PH7P221CA0080.outlook.office365.com
 (2603:10b6:510:328::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:18:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:18:21 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:18:12 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 00/32] AMD: Add Secure AVIC Guest Support
Date: Wed, 14 May 2025 12:47:31 +0530
Message-ID: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|DS2PR12MB9712:EE_
X-MS-Office365-Filtering-Correlation-Id: 5290b994-49d4-47e5-e2c9-08dd92b781fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWVOU05Va05LWGZ0Z25rbTV2SnBWb2pCeWFrZWR1NGc3MEE0S0ZKSlM4MkpG?=
 =?utf-8?B?akEyMklUdS9ubjQ1VnU5SWZ6U2V2TUhtczVzYlBtYVlreFlpaW8rNCsrS0NW?=
 =?utf-8?B?dFF3MVR3K3ZwM1RtV0NQQVE2SEFQa252WjJ4bzJmUUQvTk9hcU5JUFlja1Aw?=
 =?utf-8?B?OTFjZ2s1ejRUNnpibGJGQWFvTVYvZCtIOGhTeEczMWdFWm1mY1hLM2R5REk0?=
 =?utf-8?B?VEpXNVUwQUFOR3NLeFB5MEJ5Mk5BNWo0aUwzNVFUU01ETU5peGJ2dnNLMVpX?=
 =?utf-8?B?dUxXTlpXdjV0ckx1bVBwWHY4ZFZsVGlFZ2VqSVExd2tvUUtnckRTNjZmOXR4?=
 =?utf-8?B?TkZUcWxlL2V1SGxvVWJTS0VmVkVTTkx5aXVVSmp2RWUxSHNIV1p2V1ZmYVpV?=
 =?utf-8?B?Vm9zNGpwb3p1VWs3ZU14eXlac0VNVWhDamdiY1Y2QVZreXByZkFBM0ZITzBq?=
 =?utf-8?B?MGlDNVk2UDJMMFh3eFZVYzBUeEdiU0pjWkhQYUQ0VXIzeDRhUXBGSDFuaHB3?=
 =?utf-8?B?OGRmOFFpaU9sWGdHd2ZpT2RKMFhOTFpmdFF5WUVIaWVhNk1CWGtnRkhvMUJU?=
 =?utf-8?B?c2ZsdzEvbytQLzVMTUFneEpWQkFCUk4yT3E5WmlYSHRsWm5VTklEWWtMRUpI?=
 =?utf-8?B?YXlVTVFPdnZzeUpIQ041dDByeHZRVGJhSzJac3BiQUwyUGpiMGRpS2JRZEI5?=
 =?utf-8?B?MzVwYTBTVEtaSnNiRWxiczZTUGFvT1dqVUE2NFJ0ZHV4YlR3Z3RkRGEwZnR2?=
 =?utf-8?B?NHlwNmV3MTlBS3pLSWlJZ2p5Z1c5OEZXcWl4R3BvZ1pXQlNxc1RDQS9SMDVm?=
 =?utf-8?B?ZVBneml1dmFCMjY4ZitjYWx6a1hmRENBM3RXMHQ3RlhnOGhsUGN1eVVsbmhK?=
 =?utf-8?B?VWRGeDNHd3Eyam16c2wrNGszSldPNDJycXdGK0JkbXVaYnhJNWo2VCtnMVg0?=
 =?utf-8?B?NU4zTnYzZXZLeTJJUE55a0wrcHY2eTRpSUw2VUhZU05PTWJnc1F0ZGZ1amkz?=
 =?utf-8?B?TUdOMlEzTTZQak96cHVSVDNycC85ZGxEVTRGS1kxckN2eDRzVmhBbGhmT2Vs?=
 =?utf-8?B?TzJlRHdxejVjdFg0RW0xNDlNdnJGRTNuV0R0c09vUitSQW05MWpNL2VqVVZJ?=
 =?utf-8?B?cko0ZHRmdG85UUFvUnRvUVZaN1JRQjJodjM5T2FDb2VHMEt1QkdCQ3ltdmR2?=
 =?utf-8?B?OE5vNm1SK2M0VkthRmlFT0JZcXU4NGY0UG9UREdDZDNaM3dKRkNiZ0xMTHNo?=
 =?utf-8?B?cWoyRVhhSFBoaUs3ZlQyNkhLY3VrcEpKa095Rzl3R0xNQVVRZk5NYXdhb3ZI?=
 =?utf-8?B?eklUVTcxdkhUS0xxdk1vb1ZSQWRJQ2Y0bDBnWEZWUGtFbVJqdm83bTEzdFZm?=
 =?utf-8?B?WXVuWUtheDJVS3JudWNRQVdCQTBkYXpGL2ZVOWhIbi95MVhaUzRpZ3BwNTl4?=
 =?utf-8?B?emhPWit0ME9xZjRBTUltRkxJcldOWnFFUE90TzJlSDFhMEFTZThFSG5seFdW?=
 =?utf-8?B?SXBrR2hUL1ZOdjFQZU4rR3NSWXBpdEZPRGtGYnduT3l3YlBQaGhmZXcraXdu?=
 =?utf-8?B?R2JQU0xjNCtrUHBNRWFUalJaeUIwY0t2UUgxQXhLcFZ6UzlwRDh3NU9PSHZy?=
 =?utf-8?B?d0J4WHI3Q0ZoOVd3ejBpaEFRWnFSck1ua3ZqclNEdTNLTDJHaE5mMi90eHp5?=
 =?utf-8?B?aHpnQm9GQjJ0R1EvSmVRdE5BdTQ0UGhYWTFsdjRmVDV6NlZwbnNKYXJYQXF1?=
 =?utf-8?B?MW8ydFJPQzhFdTB0L0VkVzh6bTl4VXYvOUJHazNHbTRwMUhkVk80SGJ2L3hP?=
 =?utf-8?B?ZGI0cUNvSmNRbldHS1BBaG85MlFFVTRkTVFtbmNwblBCUFZJL1BzNlFtcWNR?=
 =?utf-8?B?bXVDcXRBUm5DYzY2OFYzNUVMaUs3V0JPWjI4N2V5TXl6a3F1Um1zYjdQbkxX?=
 =?utf-8?B?aGFYZlZmdTJMdkdHempiWUxnK3l4cEJxa1IyS1VSdGdSamhwUDRRVnpkOUw4?=
 =?utf-8?Q?LxQRv7u3RB1UpTvl17u2UGG7qXGu78=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:18:21.3311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5290b994-49d4-47e5-e2c9-08dd92b781fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9712

Introduction
------------

Secure AVIC is a new hardware feature in the AMD64 architecture to
allow SEV-SNP guests to prevent the hypervisor from generating
unexpected interrupts to a vCPU or otherwise violate architectural
assumptions around APIC behavior.

One of the significant differences from AVIC or emulated x2APIC is that
Secure AVIC uses a guest-owned and managed APIC backing page. It also
introduces additional fields in both the VMCB and the Secure AVIC backing
page to aid the guest in limiting which interrupt vectors can be injected
into the guest.

Guest APIC Backing Page
-----------------------
Each vCPU has a guest-allocated APIC backing page of size 4K, which
maintains APIC state for that vCPU. The x2APIC MSRs are mapped at
their corresposing x2APIC MMIO offset within the guest APIC backing
page. All x2APIC accesses by guest or Secure AVIC hardware operate
on this backing page. The backing page should be pinned and NPT entry
for it should be always mapped while the corresponding vCPU is running.


MSR Accesses
------------
Secure AVIC only supports x2APIC MSR accesses. xAPIC MMIO offset based
accesses are not supported.

Some of the MSR accesses such as ICR writes (with shorthand equal to
self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
hardware. Other MSR accesses generate a #VC exception. The #VC
exception handler reads/writes to the guest APIC backing page.
As guest APIC backing page is accessible to the guest, the Secure
AVIC driver code optimizes APIC register access by directly
reading/writing to the guest APIC backing page (instead of taking
the #VC exception route).

In addition to the architected MSRs, following new fields are added to
the guest APIC backing page which can be modified directly by the
guest:

a. ALLOWED_IRR

ALLOWED_IRR reg offset indicates the interrupt vectors which the guest
allows the hypervisor to send. The combination of host-controlled
REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
hardware to update the IRR vectors of the Guest APIC backing page.

#Offset        #bits        Description
204h           31:0         Guest allowed vectors 0-31
214h           31:0         Guest allowed vectors 32-63
...
274h           31:0         Guest allowed vectors 224-255

ALLOWED_IRR is meant to be used specifically for vectors that the
hypervisor is allowed to inject, such as device interrupts.  Interrupt
vectors used exclusively by the guest itself (like IPI vectors) should
not be allowed to be injected into the guest for security reasons.

b. NMI Request
 
#Offset        #bits        Description
278h           0            Set by Guest to request Virtual NMI

Guest need to set NMI Request register to allow the Hypervisor to
inject vNMI to it.

LAPIC Timer Support
-------------------
LAPIC timer is emulated by the hypervisor. So, APIC_LVTT, APIC_TMICT and
APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
VMGEXIT. 

IPI Support
-----------
Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
writing (from the Secure AVIC driver) to the IRR vector of the target CPU
backing page and then issuing VMGEXIT for the hypervisor to notify the
target vCPU.

KEXEC Support
-------------
Secure AVIC enabled guest can kexec to another kernel which has Secure
AVIC enabled, as the Hypervisor has Secure AVIC feature bit set in the
sev_status.

Open Points
-----------

The Secure AVIC driver only supports physical destination mode. If
logical destination mode need to be supported, then a separate x2apic
driver would be required for supporting logical destination mode.


Testing
-------

This series is based on top of commit 8e3f38516462 "Merge branch into tip/master: 'x86/sgx'" of tip/tip master branch.

Host Secure AVIC support patch series is at [1].

Qemu support patch is at [2].

QEMU commandline for testing Secure AVIC enabled guest:

qemu-system-x86_64 <...> -object sev-snp-guest,id=sev0,policy=0xb0000,cbitpos=51,
reduced-phys-bits=1,allowed-sev-features=true,secure-avic=true

Following tests are done:

1) Boot to Prompt using initramfs and ubuntu fs.
2) Verified timer and IPI as part of the guest bootup.
3) Verified long run SCF TORTURE IPI test.

[1] https://github.com/AMDESE/linux-kvm/tree/savic-host-latest
[2] https://github.com/AMDESE/qemu/tree/secure-avic

Changes since v5

v5: https://lore.kernel.org/lkml/20250429061004.205839-1-Neeraj.Upadhyay@amd.com/

  - Add back RFC tag due to new changes to share code between KVM's
    lapic emulation and Secure AVIC.
  - Minor optimizations to the apic bitwise ops and set/get reg
    operations.
  - Other misc fixes, cleanups and refactoring due to code sharing with
    KVM lapic implementation.

Change since v4

v4: https://lore.kernel.org/lkml/20250417091708.215826-1-Neeraj.Upadhyay@amd.com/

  - Add separate patch for update_vector() apic callback addition.
  - Add a cleanup patch for moving apic_update_irq_cfg() calls to
    apic_update_vector().
  - Cleaned up change logs.
  - Rebased to latest tip/tip master. Resolved merge conflicts due to
    sev code movement to sev-startup.c in mainline.
  - Other misc cleanups.

Change since v3

v3: https://lore.kernel.org/lkml/20250401113616.204203-1-Neeraj.Upadhyay@amd.com/

  - Move KVM updates to a separate patch.
  - Cleanups to use guard().
  - Refactored IPI callbacks addition.
  - Misc cleanups.

Change since v2

v2: https://lore.kernel.org/lkml/20250226090525.231882-1-Neeraj.Upadhyay@amd.com/

  - Removed RFC tag.
  - Change config rule to not select AMD_SECURE_AVIC config if
    AMD_MEM_ENCRYPT config is enabled.
  - Fix broken backing page GFP_KERNEL allocation in setup_local_APIC().
    Use alloc_percpu() for APIC backing pages allocation during Secure
    AVIC driver probe.
  - Remove code to check for duplicate APIC_ID returned by the
    Hypervisor. Topology evaluation code already does that during boot.
  - Fix missing update_vector() callback invocation during vector
    cleanup paths. Invoke update_vector() during setup and tearing down
    of a vector.
  - Reuse find_highest_vector() from kvm/lapic.c.
  - Change savic_register_gpa/savic_unregister_gpa() interface to be
    invoked only for the local CPU.
  - Misc cleanups.

Change since v1

v1: https://lore.kernel.org/lkml/20240913113705.419146-1-Neeraj.Upadhyay@amd.com/

  - Added Kexec support.
  - Instead of doing a 2M aligned allocation for backing pages,
    allocate individual PAGE_SIZE pages for vCPUs.
  - Instead of reading Extended Topology Enumeration CPUID, APIC_ID
    value is read from Hv and updated in APIC backing page. Hv returned
    ID is checked for any duplicates.
  - Propagate all LVT* register reads and writes to Hv.
  - Check that Secure AVIC control MSR is not intercepted by Hv.
  - Fix EOI handling for level-triggered interrupts.
  - Misc cleanups and commit log updates.

Kishon Vijay Abraham I (2):
  x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
  x86/sev: Enable NMI support for Secure AVIC

Neeraj Upadhyay (29):
  KVM: x86: Move find_highest_vector() to a common header
  KVM: x86: Move lapic get/set_reg() helpers to common code
  KVM: x86: Move lapic get/set_reg64() helpers to common code
  KVM: x86: Move lapic set/clear_vector() helpers to common code
  KVM: x86: Move {REG,VEC}_POS() macros to lapic.c
  KVM: x86: apic_test_vector() to common code
  x86/apic: Remove redundant parentheses around 'bitmap'
  x86/apic: Rename 'reg_off' to 'reg'
  x86/apic: Change apic_*_vector() vector param to unsigned
  x86/apic: Change get/set reg operations reg param to unsigned
  x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
  x86/apic: Simplify bitwise operations on apic bitmap
  x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
  x86/apic: Add new driver for Secure AVIC
  x86/apic: Initialize Secure AVIC APIC backing page
  x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
  x86/apic: Initialize APIC ID for Secure AVIC
  x86/apic: Add update_vector() callback for apic drivers
  x86/apic: Add update_vector() callback for Secure AVIC
  x86/apic: Add support to send IPI for Secure AVIC
  x86/apic: Support LAPIC timer for Secure AVIC
  x86/apic: Add support to send NMI IPI for Secure AVIC
  x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
  x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
  x86/apic: Handle EOI writes for Secure AVIC guests
  x86/apic: Add kexec support for Secure AVIC
  x86/apic: Enable Secure AVIC in Control MSR
  x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC
    guests
  x86/sev: Indicate SEV-SNP guest supports Secure AVIC

Sean Christopherson (1):
  x86/apic: KVM: Deduplicate APIC vector => register+bit math

 arch/x86/Kconfig                    |  13 +
 arch/x86/boot/compressed/sev.c      |  10 +-
 arch/x86/coco/core.c                |   3 +
 arch/x86/coco/sev/core.c            | 103 +++++++
 arch/x86/coco/sev/vc-handle.c       |  20 +-
 arch/x86/include/asm/apic.h         | 103 ++++++-
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/include/asm/msr-index.h    |   9 +-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   8 +
 arch/x86/include/uapi/asm/svm.h     |   4 +
 arch/x86/kernel/apic/Makefile       |   1 +
 arch/x86/kernel/apic/apic.c         |   8 +
 arch/x86/kernel/apic/vector.c       |  33 ++-
 arch/x86/kernel/apic/x2apic_savic.c | 437 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c                |  77 ++---
 arch/x86/kvm/lapic.h                |  24 +-
 include/linux/cc_platform.h         |   8 +
 18 files changed, 765 insertions(+), 100 deletions(-)
 create mode 100644 arch/x86/kernel/apic/x2apic_savic.c

base-commit: 8e3f385164626dc6bbf000decf04aa98e943e07e
-- 
2.34.1


