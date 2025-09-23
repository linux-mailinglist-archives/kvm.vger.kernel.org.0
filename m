Return-Path: <kvm+bounces-58450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C69D9B94455
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08ED07A18D7
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBE130DD07;
	Tue, 23 Sep 2025 05:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aXkjrLHA"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B3247299;
	Tue, 23 Sep 2025 05:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603820; cv=fail; b=eXKtX9/OmZk0LwLpR8eZn3ZclLWx/fiR3XdsNXFV/kZx9ie2zbCBr4Jv/TEHDR/v7dvpgo6d6nim7IH0FLjYf74fCj2RQByKjqjOsupHw8atzslnyWgQaNZoMFTcHsxY6PBl7E6tYDTOo4rrKoTqjoEBZs52brjYtwtmohhAOiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603820; c=relaxed/simple;
	bh=ju7kbKEvTVRfsJTe8uZwsTSSEdOcfmtJVyi4kd8lYkE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h0LtsQXqKyh3sKAXEW3j+OYz7SxgTuVpoExmigPTNFyjff4J4SO6C82B3u0OJDFjRDmm+1Fq+TLt0Juz09xQvYe/wNFZ6H7RBaMJ4M4fL5HyB9SVQ+KrxsVTDK8JPsM5TFBIXv0I9PilrXE7LW7XA9uieXIoUYoZceyR7+mfxAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aXkjrLHA; arc=fail smtp.client-ip=52.101.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3vyyYU1NJeRX1f8BJKma7Fm1ho5Wq+oWvjbNpOS1bWgSdTaXjDKzKmNQ6Z6XRkbka3oVggjbjqL0sFQu9tlzV9jlWNJgm8GpVd8sA0EEGzHSjFGG3Rc9T8KzK/v5yzpJaAIQgjI6fdqBO/T+yxkX+7D4rnQTK//1mGy2vc+kiUSSBeLspCXGxShBwngiJbtJRYEMURzD3lDqSywIUTdfhJ2DLP6ettTr3TMBnD3dLpwgr6aS+pgXYVntwk8+p4Vb9eyeAp0iNw2T95hERY1JM06t+Sq8K1PjCqwk0JFhqUHGF5XSS97PAPz2OM063WEEzY5mqF+dyiOQux1jxThTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wa/jDeVRZqlSy6cT2Gwfpv5Ox8blkoQpfQtOCAXc9o=;
 b=NqXDXeKi7NPLVLm3i+dWaX06zMdwiOtMCrmdFI0re8F5o4GmTEL18RmPg7G418JKhRVMvy7d3A0YMunQtXVoHhq3EG1dAHkk+TmT4MlRYJg91DGnHaYBzjwLiHAN30nxmMQAK16TVBPVKOMvyiustdWWnSrOyDXykZLMOGvr7pRGXipFCQ+2geWEOzJmu8VhMZtxHyw/akInSo+RRYXtD+2yIXi9SXmaH+wGCbJuCJ73kXAwP4KLCUpcm6X6FEEjofIfIljfCsmOwDzyNsZKyrEcfjWh7aqJdw7xwWXdd9CcsbJ/78RE4Xdq+WSn17REcvVEVZoqGYgptZvUmTAY3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wa/jDeVRZqlSy6cT2Gwfpv5Ox8blkoQpfQtOCAXc9o=;
 b=aXkjrLHAWrgorZwg1+PXEbOA69ZyGH56iBpx6kH6xD+5YeA4O+zwPEvxq7HGOyQX89rHaFhvRgETndXTTl4wBznFh4MwXaJ0Ozg6fUDUdmt76RkADcWC2FFUOCxTB5KQJEJebKy2nqmDX9ykxDNZ6cHqLVijqA2ee4UgEfIC6gM=
Received: from SJ0PR03CA0287.namprd03.prod.outlook.com (2603:10b6:a03:39e::22)
 by DS2PR12MB9661.namprd12.prod.outlook.com (2603:10b6:8:27b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:03:30 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:39e:cafe::fe) by SJ0PR03CA0287.outlook.office365.com
 (2603:10b6:a03:39e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:03:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:03:30 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:03:25 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 00/17] AMD: Add Secure AVIC KVM Support
Date: Tue, 23 Sep 2025 10:33:00 +0530
Message-ID: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|DS2PR12MB9661:EE_
X-MS-Office365-Filtering-Correlation-Id: bada213a-30ce-476c-dbd1-08ddfa5e89d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?diovYq8vOSRstnFXEBANNKkOivjhbV6JBLAgdQpH+wcoiajvuzaDyIlEfkq5?=
 =?us-ascii?Q?T7FKtx9zEbpGENdRPm5IrWe3pnV1zGkQbqa6XXcKKqjkjEFGTWjVQ2Hm+gCJ?=
 =?us-ascii?Q?2BnRFmIbh3IKfct6IfcFJ7sqE9c57B9iWfjigah892usYcc0va5NZBVPBCZP?=
 =?us-ascii?Q?R4CcV0k0wunKjDKjfINrL4/kioqte7Y5jzhjQSxOXGedTFYKaKsV2xiDKSq5?=
 =?us-ascii?Q?iHaDqP6yhwGiGFMzwPeXWHx6fUuDPTfl5o9TFIAlFCZH5RvenBLwcL4LMIzM?=
 =?us-ascii?Q?uJjtVFr1+AxDHm0EhKtUlsXuQvuKW3BZf3vgX0f3xUDR5HJ0dmw+ddGjPlJB?=
 =?us-ascii?Q?rC62xeUdVEgKfkfVmOnCZN8kU7qCgtRf+j6GKE9C4K45NB/WTuplS67v7oRR?=
 =?us-ascii?Q?sDPwnxx4jk6LHMvic1v3Rq/Lj2TPvIYZjmXq8i6uBNqL5ExIsr2UdwZRjJod?=
 =?us-ascii?Q?TNGYxFb4sVa9M3NjYaEPjC5UmBFvwmYOTet+JRr9Fmey3hcefse/e6lg8wYD?=
 =?us-ascii?Q?+81L/P5Ncv0mWMm9dUOaNoNQnVlhuu3/MDerPJnVWgz9uwR5f791Gt8PcoqW?=
 =?us-ascii?Q?Duis3nPx/sDmkHyErC9audURT3JHE/AkVSR42EE6zU5FFccfY4Ei55pP0hzc?=
 =?us-ascii?Q?U9EzRDz5ZjnPElfzRSm83k4UoJWayD00pAbkq6wA/V3E3v1tcw0+AEIgAWcN?=
 =?us-ascii?Q?x8cUM4KOSzLFibt/XJ1V0MJqRXQ+4oj1PdQBKzwuptKM8NsOZNiqGd/9JLHB?=
 =?us-ascii?Q?qeCZpeOQdW08UFZ1kedlkxxtJCGTtJ3iqAZ96RQzcqpcq2BQq2NIRMLk98ss?=
 =?us-ascii?Q?jNP4ry410GrvLZFPJCQbQWIdsIL1jbl6en46Pyy0NiVboQfHfeba4IBnJVX5?=
 =?us-ascii?Q?p3aVCD7HWQf8i0bT9VHys/DTR0Zv9MxXOM8xKNJkCt7n5fgX7vkC/x1G+9hv?=
 =?us-ascii?Q?ezzxPIbMAnNi/a2wYX/IIwNC9KwrTdKxNnwYjHtmiveGbZmPRnBOtGV0UIyY?=
 =?us-ascii?Q?1dDZQ/ZoJnoIwnZhK3bzmxwp2Xqxsp9eEQih1qqm05c8guVUBW+CDuT5rMV3?=
 =?us-ascii?Q?2yIm6CqXKKskS49MJkc1JFbP8wSFkFiFBTs/EZ8J1p1g4wFvbX3QtYh72633?=
 =?us-ascii?Q?aPBENfvyJ2+W86kozste7q/cAp8m1Gdf2Dyg8g1VTj6m2hvaoT99heE1pNiB?=
 =?us-ascii?Q?EkFKIsBiCunLGdbu0J0DZHpi+Q1kbxa0VDgO4eC9ESe/lCC3s1v8TT2t84AS?=
 =?us-ascii?Q?1BxV/SD1a3J3TZEbSMScTUhg7E+3TrSaZpe/nEU6g7wt203XaBCpYPyJ/PW+?=
 =?us-ascii?Q?3iVMV1eaH3oghgmmSuTP2NWJ86p/4gb+G4sncPtc/zhYx/o4xilvYvKs+vh7?=
 =?us-ascii?Q?E1LBGnjoyQbb06SRAdX65m+cYrXVL/UfWBGY/ykTSBazqf463YthoItgWvhU?=
 =?us-ascii?Q?9IV7hOBkvRtRrGxchq5uq8B2IIV3i6obV2XngxUHPytx3AgB+ekdmEEyPAyG?=
 =?us-ascii?Q?FqqaM+bJzAC7QLs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:03:30.1568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bada213a-30ce-476c-dbd1-08ddfa5e89d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9661

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
Each vCPU has a guest-allocated APIC backing page, which maintains APIC
state for that vCPU. The x2APIC MSRs are mapped at their corresposing
x2APIC MMIO offset within the guest APIC backing page. All x2APIC accesses
by guest or Secure AVIC hardware operate on this backing page. The
backing page should be pinned and NPT entry for it should be always
mapped while the corresponding vCPU is running.

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
APIC MSR reads are accelerated similar to AVIC, as described in
table "15-22. Guest vAPIC Register Access Behavior" of APM.

In addition to the architected MSRs, following new fields are added to
the guest APIC backing page which can be modified directly by the
guest:

a. ALLOWED_IRR

ALLOWED_IRR vector indicates the interrupt vectors which the guest
allows the hypervisor to send. The combination of host-controlled
REQUESTED_IRR vectors (part of VMCB) and guest-controlled ALLOWED_IRR
is used by hardware to update the IRR vectors of the Guest APIC
backing page.

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
MSR_PROT RDMSR VMGEXIT and updated in the guest APIC backing page.

3. APIC TPR

TPR writes are accelerated and not communicated to KVM. So, the
hypervisor does not have information about TPR value for a vCPU.

4. APIC PPR

Current state of PPR is not visible to KVM.

5. APIC SPIV

Spurious Interrupt Vector register value is communicated by the guest to
the KVM.

6. APIC IRR and APIC ISR

IRR and ISR states are visible only to the guest. So, KVM cannot use these
registers to determine guest interrupts which are pending completion.

7. APIC TMR

Trigger Mode Register state is owned by the guest and not visible to KVM.
However, for IOAPIC external interrupts, KVM's software vAPIC trigger
mode is set from the guest-controlled redirection table. So, the APIC_TMR
values in the software vAPIC state can be used to identify between edge
and level triggered IOAPIC interrupts.

8. Timer registers - TMICT, TMCCT, TDCR

Timer registers are accessed using MSR_PROT VMGEXIT calls and not from the
guest APIC backing page.

9. LVT* registers

LVT registers state is accessed from KVM vAPIC state for the vCPU.

Idle HLT Intercept
-------------------

As KVM does not have access to the APIC IRR state for a Secure AVIC guest,
idle HLT intercept feature should be always enabled for a Secure AVIC
guest. Otherwise, any pending interrupts in vAPIC IRR during HLT VMEXIT
would not be serviced and the vCPU could get stuck in HLT until the next
wakeup event (which could arrive after non-deterministic amount of time).
For idle HLT intercept to work vAPIC TPR value should not block the
pending interrupts.

LAPIC Timer Support
-------------------
LAPIC timer is emulated by KVM. So, APIC_LVTT, APIC_TMICT and APIC_TDCR,
APIC_TMCCT APIC registers are not read/written to the guest APIC backing
page and are communicated to KVM using MSR_PROT VMGEXIT. 

IPI Support
-----------
Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPI
destination shorthands result in VMEXIT_AVIC_INCOMPLETE_IPI #VC exception.
The expected guest handling for VMEXIT_AVIC_INCOMPLETE_IPI is:

- For interrupts, update APIC_IRR in target vCPUs' guest APIC backing
  page.

- For NMIs, update NMI_REQUEST in target vCPUs' guest backing page.

- ICR based SMI, INIT, SIPI requests are not supported.

- After updating the target vCPU's guest APIC backing page, source vCPU
  does a MSR_PROT VMGEXIT.

- KVM either wakes up the non-running target vCPU or sends an AVIC doorbell.

Exceptions Injection
--------------------

Secure AVIC does not support event injection for guests with Secure AVIC
enabled in SEV_FEATURES. So, KVM cannot inject exceptions to Secure AVIC
guests. Hardware takes care of reinjecting an interrupted exception (for
example due to NPF) on next VMRUN. #VC exception is not reinjected. KVM
clears all exception intercepts for the Secure AVIC guest.

Interrupt Injection
-------------------

IOAPIC and MSI based device interrupts can be injected by KVM. The
interrupt flow for this is:

- IOAPIC/MSI interrupts are updated in KVM's APIC_IRR state via
  kvm_irq_delivery_to_apic().
- in ->inject_irq() callback, all interrupts which are set in KVM's
  APIC_IRR are copied to RequestedIRR VMCB field and UpdateIRR bit is
  set.
- VMRUN moves the current value of RequestedIRR to APIC_IRR in the
  guest APIC backing page and clears RequestedIRR, UpdateIRR.

Given that hardware clearing of RequestedIRR and UpdateIRR can race with
KVM's writes to these fields, above interrupt injection flow ensures
that all RequestedIRR and UpdateIRR writes are done from the same CPU
where the vCPU is run.

As interrupt delivery to a vCPU is managed by hardware, interrupt window
is not applicable for Secure AVIC guests and interrupts are always
allowed to be injected.

PIC interrupts
--------------

Legacy PIC interrupts cannot be injected as they require event_inj or
VINTR injection support. Both of these cannot be done for Secure
AVIC guest.

PIT
---

PIT Reinject mode is not supported for edge-triggered interrupts, as it
requires IRQ ack notification on EOI. As EOI is accelerated by Secure
AVIC hardware for edge- triggered interrupts, IRQ ack notification is
not called for them.

NMI Injection
-------------

NMI injection requires ALLOWED_NMI to be set in Secure AVIC control MSR
by the guest. Only VNMI injection is allowed.

Design Caveats, Open Points and Improvement Opportunities
---------------------------------------------------------

- Current code uses KVM's vAPIC APIC_IRR for storing the interrupts which
  need to be injected to the guest. It then reuses the exiting KVM's
  interrupt injection flow (with some modifications to the injectable
  interrupt determination).
  
  While functional, this approach conflates the state of KVM's
  software-emulated vAPIC with the state of the hardware-accelerated Secure
  AVIC. This can make the code harder to reason about. A cleaner approach
  could be desired here which would introduce a dedicated struct for
  holding SAVIC-specific state, completely decoupling it from the software
  lapic state and avoiding this overload of semantics.
  
  In addition, preserving the existing notion of a boolean
  guest_apic_protected instead of having to subcategorize it based on the
  interrupt injection flow would be desired. Given that KVM cannot use the
  TDX's PI (asynchronous interrupt injection) mechanism for SAVIC and must
  instead adopt the pre-VMRUN injection model of writing to the
  guest-visible backing page, this would require creating a separate flow
  for moving the KVM's pending interrupts for the vCPU to the RequestedIRR
  field.

- EOI handling for level-triggered interrupts uses KVM's unused vAPIC
  APIC_ISR regs for tracking pending level interrupts. KVM uses its
  APIC_TMR state to determine level-triggered interrupts. As KVM's
  APIC_TMR is updated from IOAPIC redirection tables, the TMR information
  should be accurate and match the guest vAPIC state.
  
  This can be cleaned up to not use KVM's vAPIC APIC_ISR state and 
  maintain the state within sev code.

- RTC_GSI requires pending EOI information to detect coalesced interrupts.
  As RTC_GSI is edge triggered, Secure AVIC does not forward EOI write to
  KVM for this interrupt. In addition, APIC_IRR and APIC_ISR states are
  not visible to KVM and are part of the guest APIC backing page. Approach
  taken in this series is to disable checking of coalesced RTC_GSI
  interrupts for Secure AVIC, which could impact userspace code which
  relies on detecting RT_GSI interrupt coalescing.
  
  Alternate approach would be to not support in-kernel IOAPIC emulation for
  Secure AVIC guests, similar to TDX.

- As exceptions cannot be injected by KVM, a more detailed examination
  of which exception intercepts need to be allowed for Secure AVIC
  guests is required.

- As KVM does not have access to the guest's APIC_IRR and APIC_ISR
  states, kvm_apic_pending_eoi() does not return correct information.

- External interrupts (PIC) are not supported. This breaks KVM's PIC
  emulation.

- PIT reinject mode is not supported.

Changes since v1:

v1: https://lore.kernel.org/lkml/20250228085115.105648-1-Neeraj.Upadhyay@amd.com/

- Rebased and resolved conflicts with the latest kvm next snapshot.
- Replaced enum with a separate lapic struct member to differentiate
  protected APIC's interrupt injection mechanism.
- Add a patch to disable KVM_FEATURE_PV_EOI and KVM_FEATURE_PV_SEND_IPI
  for protected APIC guests.
- Dropped SPIV hack patch, which always returns true from
  kvm_apic_sw_enabled():   20250228085115.105648-16-Neeraj.Upadhyay@amd.com
  Instead of this, rely on guest propagating APIC_SPIV value to KVM.
- Updates the the commit logs and cover letter to provide more
  description.

This series is based on top of commit a6ad54137af9 ("Merge branch
'guest-memfd-mmap' into HEAD") and is based on

  git.kernel.org/pub/scm/virt/kvm/kvm.git next

Git tree is available at:

  https://github.com/AMDESE/linux-kvm/tree/savic-host-latest

In addition, below patch from v1 is required, until SAVIC guest is
updated to propagate APIC_SPIV to the hypervisor.

  20250228085115.105648-16-Neeraj.Upadhyay@amd.com

Qemu tree is at:
  https://github.com/AMDESE/qemu/tree/secure-avic
  
QEMU commandline for testing Secure AVIC enabled guest:

qemu-system-x86_64 <...> -object sev-snp-guest,id=sev0,policy=0xb0000,cbitpos=51,reduced-phys-bits=1,allowed-sev-features=true,secure-avic=true

Guest Support is present in tip/tip master branch at the commit snapshot
835794d1ae4c ("Merge branch into tip/master: 'x86/tdx'").

Kishon Vijay Abraham I (2):
  KVM: SVM: Do not inject exception for Secure AVIC
  KVM: SVM: Set VGIF in VMSA area for Secure AVIC guests

Neeraj Upadhyay (15):
  KVM: x86/lapic: Differentiate protected APIC interrupt mechanisms
  x86/cpufeatures: Add Secure AVIC CPU feature
  KVM: SVM: Add support for Secure AVIC capability in KVM
  KVM: SVM: Set guest APIC protection flags for Secure AVIC
  KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR for SAVIC guests
  KVM: SVM: Implement interrupt injection for Secure AVIC
  KVM: SVM: Add IPI Delivery Support for Secure AVIC
  KVM: SVM: Do not intercept exceptions for Secure AVIC guests
  KVM: SVM: Enable NMI support for Secure AVIC guests
  KVM: SVM: Add VMGEXIT handler for Secure AVIC backing page
  KVM: SVM: Add IOAPIC EOI support for Secure AVIC guests
  KVM: x86/ioapic: Disable RTC EOI tracking for protected APIC guests
  KVM: SVM: Check injected timers for Secure AVIC guests
  KVM: x86/cpuid: Disable paravirt APIC features for protected APIC
  KVM: SVM: Advertise Secure AVIC support for SNP guests

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/msr-index.h   |   1 +
 arch/x86/include/asm/svm.h         |   9 +-
 arch/x86/include/uapi/asm/svm.h    |   3 +
 arch/x86/kvm/cpuid.c               |   4 +
 arch/x86/kvm/ioapic.c              |   8 +-
 arch/x86/kvm/lapic.c               |  17 +-
 arch/x86/kvm/lapic.h               |   5 +-
 arch/x86/kvm/svm/sev.c             | 367 ++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c             |  80 +++++--
 arch/x86/kvm/svm/svm.h             |  14 ++
 arch/x86/kvm/x86.c                 |  15 +-
 12 files changed, 493 insertions(+), 31 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.34.1


