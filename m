Return-Path: <kvm+bounces-39665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B10A49411
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5565188F066
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74317254867;
	Fri, 28 Feb 2025 08:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UDZWJCcd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F851C5D42;
	Fri, 28 Feb 2025 08:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740732837; cv=fail; b=tuXq3AOoNW5xUS8avoklGjgc2aF8zKmVPUrCWGoN2j7jMWevLJ5+NN6vlkjkg3AHuB5N4qF+xVvqdeLySqphkDG89NwYGJbOeZwdKLTn8pzoM6rbOCkVDeiPiKaYHa7NAODbKMq3ecassIAfgftEZ27m8rdAX18QtvwlqzwOv/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740732837; c=relaxed/simple;
	bh=IDSwh2LDbPIzBRn9xtCZ5Q26WPSisdhxKehNCfQOYuA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ABm4YD9aRqUWiVIr6XMBpOH2LH1Hq0npjVjRQehT0vDqnFjFUO/ngOYc/JqlDR2POozrHduAuFRo7rD69sOENvbWYEuggmhVyWTD0RSfJ6BnZtf1UXxIL9fjt4QQxlZJvShNqh2FHo4aup0I5NH+oDkmQDSPa4mfnW1EC3FpZts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UDZWJCcd; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVi671rlO0Yuv7msviG4NukIQvzc1pGn5qGQYJ0r+YCQ1PpRBlCNux+RYTX4dkrLjmjumuaCxCArNm7LYN8aiaX/z8D5nJTMF01Ag5FMzoZ0WmYuEcLbKPeT/kF2dy1RY1WTluEcM/frMO87+xZx69EMEDbAPEr4YOMBROSK+GpQ9Tq2rNeS3RD6a7UfE5m0fNSdpbpCLJXdQi1hfMynMA+eLbq9R/jyKbBuUxO5tsrn09CqpiwMxTbK1uAdfOxALVae/dYCVMfLW0Hyb8aEj5wrG1647qD0h63J0PraM1m3bz5ZSffBHEO8Bd5ZCqBOq6E3ObcT+uKYZyTO6qcLaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyvkN8giYJzc821gCjUuxUBLCcAl1AfshMDzA/xREgk=;
 b=Nz8k4eO0M1RaKcQm4E8gAVpZMoLGJ211oz8ifgzdADvftHbqYhaJDhf2Mxo+W1wGQdtRJuCvNlVGrMi5qzgoF0l9Kqkx5Z0s8wbD/k3GQ7ubMpOgaWEmINqzcIuBvr2vvwCOCZIBO/yW/OtsC3mpuBV5qy0giPgQRC+xtAaq81HkuacDQEemyODxqHuyYKAwDO84PhD2i037dsaIkPNCVayZKtZBf+BAjA3VeO5vrnDf5SV913JQE/4t3YH43+B/jtZS0PUyPUm+MwgpfXFwhGk1gESOXZmMxNPza7hM7cEhX0OLApqRkp/F3+qcrtMLd0CHVoB98HH1NjYXc6oNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyvkN8giYJzc821gCjUuxUBLCcAl1AfshMDzA/xREgk=;
 b=UDZWJCcdrwVq7xxPGiIVP9vR/UCtXlxqwMblQRWdJOkVGlELx9DXwUxnGBSIcrSTdH9hkRMcrxYUHkHll58O1mbZEcmOjatC+uVpX8dUylmFE2VjHdAJ5M7X7lnaqLHY6y4wsLM8jx71nrm6Ez/gPUhbIaoIdka65gp/iZZjBcw=
Received: from BN9PR03CA0353.namprd03.prod.outlook.com (2603:10b6:408:f6::28)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Fri, 28 Feb
 2025 08:53:51 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:408:f6:cafe::ac) by BN9PR03CA0353.outlook.office365.com
 (2603:10b6:408:f6::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.23 via Frontend Transport; Fri,
 28 Feb 2025 08:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 08:53:51 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 02:52:07 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 00/19] AMD: Add Secure AVIC KVM Support
Date: Fri, 28 Feb 2025 14:20:56 +0530
Message-ID: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: 99936a1b-ee59-4877-95b6-08dd57d56c87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEdBdkFYTlpzaWNUaXR1SWMxZDB5Y3NLb2ZZTEY2eTFBeVdma1FISm5WSnlv?=
 =?utf-8?B?YXBYM0dRLzNQZ3U5ekNpZHJEaG96NXZBVkZiYjZNa2dRREpFYXM0R2VtY295?=
 =?utf-8?B?SmdnZEJHblE2L2VHUzFwNUcyOU5DMWZORStjeXhxOHRWYWJBOGExaTJYNDNW?=
 =?utf-8?B?VE14VTRaT3NzSGZhOGxHVmZwQVVXZStPNjdQZk5PTnJZNEZXakN0eDlieUty?=
 =?utf-8?B?M2RHTGFMTEJha3JaMVRodlpMakJvVkM4L2NlNXpvTFMyNXJtMFJ1TFVmaFlQ?=
 =?utf-8?B?cTI0M3M4UE9lMHdMUHQ1eUhpenJDY2ErTWRxTm85YmFhblBVZzRsUVZlOUtl?=
 =?utf-8?B?SmYydUlyYTExRUtoY0tlZW1aS3dDM1BkNVFYaXlBOHA1VGpFNm5XOWtGMmdI?=
 =?utf-8?B?SUZacy9lRWtUYUtRaURFOUc0ODVpN0RhQzllaTlJMEUxa29sVjdXMUp3cVF6?=
 =?utf-8?B?TnBPbk9jNU9USTZFVUtuamJaWnV6SVoyT051MlBjWXVJNVRPeTVtbTQ2QXhX?=
 =?utf-8?B?b3o0OFZpcStRcHJYUDNNZFRZeFg4NmZPbHFHVlNCRWFXenlrZ0FBQjdyWDh6?=
 =?utf-8?B?VVd0a1FpK0N6cHMrR2U0UFlWOFdqcWo5NVFPVWJ0eWNHWHREeitVRkdnWStZ?=
 =?utf-8?B?U3VyZFZhZlBBQ3FMRlNFb1R3NnVyanFYZWFCZUkvVUlidGlCUWxsc3Z4aC9W?=
 =?utf-8?B?NEtVYjc1QTliZkg2Nnk2S0hXY3N6VjhydXZmVHF0aE0yZVEzczIyOG02THF0?=
 =?utf-8?B?a0JNN1pDaEJSTHI4SDBVNitFZjdsQnVRR2VXTkRVeU55WDNUZVdDOG5KWnFh?=
 =?utf-8?B?NXVSdTBFSzdZNVQzTlZCVWJyNmVKUHBWWW1OUnpqa3lMQk44aStYR1laUktJ?=
 =?utf-8?B?Ykt1SVVXN1g3S0FGd2R4ekVPdldLTlFiQ0IxZUtycHlYUEcwN0p3c0hLWFNQ?=
 =?utf-8?B?NUI4UHkrc1EyLzhHQm93Y0pLZTJOTm01YTdVQUs3bjd4Si96bXBpQVYyMCtU?=
 =?utf-8?B?R1gvOWp5OFlLYXdKNW5CK1ZjQzFsVmhoYWNuVWx3clR3aDhSY290azBqaUUy?=
 =?utf-8?B?SFgvSHhWeXRPODNnanp4RURuUkNPK3dndHQrbVE5eEljT2FpTTVrS3czd0p0?=
 =?utf-8?B?NUN6eFZhT1djSElHWUlUekxoZ1ZHLzZ1c1U0SU9FRGpCd0V1dGh0TUtDaUFS?=
 =?utf-8?B?TEF3QkI4SGNwL3hhd2lPd2dtWVJQUDIyRFFhT3pJL3dQUnNWaGNlQWxYb2kr?=
 =?utf-8?B?VU42ZDJsOHhLSXhNSUtlU3JnWGk0RGNMMmYwTXBMRnBrT0N0OVVXVWI5OHdR?=
 =?utf-8?B?WnpvY0orNjBzdFJhY0szZHBSRjZxSDRQdEhIdzljQ3BySDhVOE9QaWVGVGhY?=
 =?utf-8?B?QmZCQXRjU0JBcExuSVVkYXpuOXN0cVlMZVNuaVJBTWpWRzd5bC9yOG54MXpk?=
 =?utf-8?B?NlIzZTJNN3RudjlVL3FqaXYwcWRvU0xFTmRjYytqeWlMR0NJNXBBT3RNd2Fa?=
 =?utf-8?B?bjUrTWRtVzhzVzZLVWl0ZTY4UTczdVpBZDRsck03d21vaFVHU252YVQycUtO?=
 =?utf-8?B?L1I0b2VDdnRnV3R1RzVaSEtBZkFGTGRwRVczMUtmYUdoYlJqaTJpTmdNOHlk?=
 =?utf-8?B?NUZ4KzV1WXcwcVBVbnd2UHFpREJxWVJidXFlVnlhNzhUbmhpSXF5emtDVzdy?=
 =?utf-8?B?TXZWWkJWMHpheURtOXBXSEhTUE4rZWwwVkcybzRXenlwaG1ucnU1U2xCQW9v?=
 =?utf-8?B?WGpXM0g2Q0EwZHI0dWI1V1Y3VnAyVzJtQWplQlRPZndvSmEyaDRkS1lnckNh?=
 =?utf-8?B?VUdPRnNVWTc0Wms4KzNVMFpFRkVEVExzdWRHWjRHaTNhZ3NHemNoQU5xMi8z?=
 =?utf-8?B?cmhJWFNvWlA5T1NUMU0yWWRyWEFOMFh2d0JGWXM5ZnAwM2xxMkZoTk9VUmE2?=
 =?utf-8?Q?oi5hMujnq/mjL+gsDGaeDkiYh9tkkmJ2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 08:53:51.6641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99936a1b-ee59-4877-95b6-08dd57d56c87
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302

Introduction
------------

Secure AVIC is a new hardware feature in the AMD64 architecture to
allow SEV-SNP guests to prevent hypervisor from generating unexpected
interrupts to a vCPU or otherwise violate architectural assumptions
around APIC behavior.

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

Some of the MSR writes such as ICR writes (with shorthand equal to
self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
hardware. Other MSR writes generate a #VC exception (
VMEXIT_AVIC_NOACCEL or VMEXIT_AVIC_INCOMPLETE_IPI). The #VC
exception handler reads/writes to the guest APIC backing page.
As guest APIC backing page is accessible to the guest, guest can
optimize APIC register access by directly reading/writing to the
guest APIC backing page (instead of taking the #VC exception route).
APIC msr reads are accelerated similar to AVIC, as described in
table "15-22. Guest vAPIC Register Access Behavior" of APM.

In addition to the architected MSRs, following new fields are added to
the guest APIC backing page which can be modified directly by the
guest:

a. ALLOWED_IRR

ALLOWED_IRR vector indicates the interrupt vectors which the guest
allows the hypervisor to send. The combination of host-controlled
REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
hardware to update the IRR vectors of the Guest APIC backing page.

#Offset        #bits        Description
204h           31:0         Guest allowed vectors 0-31
214h           31:0         Guest allowed vectors 32-63
...
274h           31:0         Guest allowed vectors 224-255

ALLOWED_IRR is meant to be used specifically for vectors that the
hypervisor emulates and is allowed to inject, such as IOAPIC/MSI
device interrupts.  Interrupt vectors used exclusively by the guest
itself (like IPI vectors) should not be allowed to be injected into
the guest for security reasons.

b. NMI Request
 
#Offset        #bits        Description
278h           0            Set by Guest to request Virtual NMI

Guest can set NMI_REQUEST to trigger APIC_ICR based NMIs.

APIC Registers
--------------

1. APIC ID

APIC_ID values is set by KVM and similar to x2apic, it is equal to
vcpu_id for a vCPU.

2. APIC LVR

APIC Version register is expected to be read from KVM's APIC state using
MSR_PROT rdmsr VMGEXIT and updated in guest APIC backing page.

3. APIC TPR

TPR writes are accelerated and not communicated to KVM. So,
hypervisor does not have information about TPR value for a vCPU.

4. APIC PPR

Current state of PPR is not visible to KVM.

5. APIC SPIV

Spurious Interrupt Vector register value is not communicated to KVM.

6. APIC IRR and ISR

IRR and ISR states are visible only to guest. So, KVM cannot use these
registers to determine interrupt which are pending completion.

7. APIC TMR

Trigger Mode Register state is owned by guest and not visible to
KVM.

8. Timer registers - TMICT, TMCCT, TDCR

Timer registers are accessed using MSR_PROT VMGEXIT calls and not from
the guest APIC backing page.

9. LVT* registers

LVT registers state is accessed from KVM APIC state for the vCPU.

Idle halt Intercept
-------------------

As hypervisor does not have access to the APIC IRR state for a Secure
AVIC guest, idle halt intercept feature should be always enabled for
a Secure AVIC guest. Otherwise, any pending interrupts in APIC IRR during
halt vmexit would not be serviced and vCPU could get stuck in halt forever.
For idle halt intercept to work APIC TPR value should not block the
pending interrupts.

LAPIC Timer Support
-------------------
LAPIC timer is emulated by KVM. So, APIC_LVTT, APIC_TMICT and APIC_TDCR,
APIC_TMCCT APIC registers are not read/written to the guest APIC backing
page and are communicated to the hypervisor using MSR_PROT VMGEXIT. 

IPI Support
-----------
Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPI
destination shorthands result in VMEXIT_AVIC_INCOMPLETE_IPI #VC exception.
The expected guest handling for VMEXIT_AVIC_INCOMPLETE_IPI is:

- For interrupts, update APIC_IRR in target vCPUs' guest APIC backing
  page.

- For NMIs, update NMI_REQUEST in target vCPUs' guest backing
  page.

- ICR based SMI, INIT, SIPI requests are not supported.

- After updating the target vCPU's guest APIC backing page, source vCPU
  does a MSR_PROT VMGEXIT.

- KVM either wakes up the non-running target vCPU or sends a
  AVIC doorbell.

Exceptions Injection
--------------------

Secure AVIC does not support event injection for guests with Secure AVIC
enabled in SEV_FEATURES. So, KVM cannot inject exceptions to Secure AVIC
guests. Hardware takes care of reinjecting an interrupted exception (for
example due to NPF) raised in guest on next VMRUN. VC exception is not
reinjected. KVM clears all exception intercepts for Secure AVIC guest.

Interrupt Injection
-------------------

IOAPIC and MSI based device interrupts can be injected by KVM. The
interrupt flow for this is:

- IOAPIC/MSI interrupts are updated in KVM's APIC_IRR state via
  kvm_irq_delivery_to_apic().
- in ->inject_irq() callback, all interrupts which are set in KVM's
  APIC_IRR are copied to RequestedIRR VMCB field and UpdateIRR bit is
  set.
- VMENTER moves the current value of RequestedIRR to APIC_IRR in
  guest APIC backing page and clears UpdateIRR.

Given that hardware clearing of RequestedIRR and UpdateIRR can race
with software writes to these fields, above interrupt injection
flow ensures that all RequestedIRR and UpdateIRR writes are done
from the same CPU where vCPU is run.

As interrupt delivery to vCPU is managed by hardware, interrupt window
is not applicable for Secure AVIC guests and interrupts are always
allowed to be injected.

PIC interrupts
--------------

Legacy PIC interrupts cannot be injected as they required event_inj or
VINTR injection support. Both of these are cannot be done for Secure
AVIC guest.

PIT
---

PIT Reinject mode is not supported as it requires IRQ ack notification
on EOI. As EOI is accelerated for edge interrupts, IRQ ack notification
is not called for those interrupts.

NMI Injection
-------------

NMI injection requires ALLOWED_NMI to be set in Secure AVIC control
msr by the guest. Only VNMI injection is allowed.

Open Points
-----------

- RTC_GSI requires pending EOI information to detect coalesced
  interrupts. As RTC_GSI is edge triggered, Secure AVIC does not
  forward EOI write to KVM for this interrupt. In addition, APIC_IRR
  and APIC_ISR states are not visible to KVM and are part of guest
  APIC backing page. Approach taken in this series is to disable
  checking of coalesced RTC_GSI interrupts for Secure AVIC, which
  could impact userspace.

- EOI handling for level interrupts uses KVM's unused APIC_ISR regs
  for tracking pending level interrupts. KVM uses its APIC_TMR state
  to determine level-triggered interrupts. As KVM's APIC_TMR is
  updated from IOAPIC redirect tables, the TMR information should be
  accurate and match guest APIC state. This can be cleaned up later
  to not use KVM's APIC_ISR state and maintained within sev code.

- Spurious Interrupt Vector Register writes are not visible to KVM.
  So, KVM cannot determine if the SW enabled bit is set.

- As exceptions cannot be injected by KVM, a more detailed examination
  of which intercepts need to be allowed for Secure AVIC guests is
  required.

- As KVM does not have access to the guest's APIC_IRR and APIC_ISR
  states, kvm_apic_pending_eoi() does not return correct information.

- External interrupts (PIC) are not supported. This breaks KVM's PIC
  emulation.

- PIT reinject mode is not supported.

- Current code uses KVM's vCPU APIC_IRR for interrupts which
  need to be injected to guest. Another approach could be to
  maintain pending interrupts within sev code and inject using
  flow similar to posted interrupts. 

This series is based on top of commit f7bafceba76e ("KVM: remove
kvm_arch_post_init_vm ") and is based on

  git.kernel.org/pub/scm/virt/kvm/kvm.git next

Git tree is available at:

  https://github.com/AMDESE/linux-kvm/tree/savic-host-latest

Qemu tree is at:
  https://github.com/AMDESE/qemu/tree/secure-avic

Guest Secure AVIC support is available at:

  https://lore.kernel.org/lkml/20250226090525.231882-1-Neeraj.Upadhyay@amd.com/

This series depends on below patch series:

1. Idle Halt Intercept

https://lore.kernel.org/all/20250128124812.7324-1-manali.shukla@amd.com/

2. ALLOWED_SEV_FEATURES support

https://lore.kernel.org/kvm/20250207233410.130813-1-kim.phillips@amd.com/


Kishon Vijay Abraham I (5):
  KVM: SEV: Do not intercept SECURE_AVIC_CONTROL MSR
  KVM: SVM: Secure AVIC: Do not inject "Exceptions" for Secure AVIC
  KVM: SVM/SEV: Secure AVIC: Set VGIF in VMSA area
  KVM: SVM/SEV: Secure AVIC: Enable NMI support
  KVM: x86: Secure AVIC: Indicate APIC is enabled by guest SW _always_

Neeraj Upadhyay (12):
  KVM: x86: Convert guest_apic_protected bool to an enum type
  x86/cpufeatures: Add Secure AVIC CPU Feature
  KVM: SVM: Add support for Secure AVIC capability in KVM
  KVM: SVM: Initialize apic protected state for SAVIC guests
  KVM: SVM/SEV/X86: Secure AVIC: Add support to inject interrupts
  KVM: SVM/SEV/X86: Secure AVIC: Add hypervisor side IPI Delivery
    Support
  KVM: SVM/SEV: Do not intercept exceptions for Secure AVIC guest
  KVM: SVM/SEV: Add SVM_VMGEXIT_SECURE_AVIC GHCB protocol event handling
  KVM: x86: Secure AVIC: Add IOAPIC EOI support for level interrupts
  KVM: x86/ioapic: Disable RTC_GSI EOI tracking for protected APIC
  X86: SVM: Check injected vectors before waiting for timer expiry
  KVM: SVM/SEV: Allow creating VMs with Secure AVIC enabled

Sean Christopherson (2):
  KVM: TDX: Add support for find pending IRQ in a protected local APIC
  KVM: x86: Assume timer IRQ was injected if APIC state is protected

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/msr-index.h   |   2 +
 arch/x86/include/asm/svm.h         |   9 +-
 arch/x86/include/uapi/asm/svm.h    |   3 +
 arch/x86/kvm/ioapic.c              |   8 +-
 arch/x86/kvm/irq.c                 |   6 +
 arch/x86/kvm/lapic.c               |  23 +-
 arch/x86/kvm/lapic.h               |  16 ++
 arch/x86/kvm/svm/sev.c             | 371 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  79 ++++--
 arch/x86/kvm/svm/svm.h             |  17 +-
 arch/x86/kvm/x86.c                 |  12 +-
 14 files changed, 518 insertions(+), 31 deletions(-)


base-commit: f7bafceba76e9ab475b413578c1757ee18c3e44b
-- 
2.34.1


