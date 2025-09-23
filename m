Return-Path: <kvm+bounces-58457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B56EB9447F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EEE12A8424
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FBE30E0D8;
	Tue, 23 Sep 2025 05:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2AX6Zvhi"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011057.outbound.protection.outlook.com [52.101.57.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0B26E16F;
	Tue, 23 Sep 2025 05:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603935; cv=fail; b=eAX3Cq8srk3L7h/xKT3TD8zabLOhXYA+FK11LdBLWWbQyts3YeL1QxoMJUsoDdEQp81/ICCNyKa/Z1QGwo9xgm1H8w6ImpDTJoj8S2jo8mp6BYF4lLCC4KBEk1PXiByLwkjWqriCOYpr73Gc8INTjUOReZPlgouKr4hcdOU4FSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603935; c=relaxed/simple;
	bh=HKODIZar39zCpkFbNMNjlDmxs8AKCTHmjogrSvfGx0M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkeohMD3WMaO82lev5J/N4BwrjDaV4C5TNYVSI0lIcAPvPffGG4iceq+1kPQ0beR44qr5RKEvxxmnmsZXVQUeGQE6mTlxPJCZvoVt3rhCzUnH3OHVTLfRc2R1COTcDMZJf8ro1HMyBKq37YpjWZ9cYCnbvRdTQhcRKUBSKXsDUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2AX6Zvhi; arc=fail smtp.client-ip=52.101.57.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vn12yZXrJFQGF1VvEzk4JSdDFFDm/AM9BhmfNgfBdwWoNSIWKySCcrfscL32pbt8sprftT900+4v8AQeKt+Ok2TA5Fc2r85kVRIK75xEdWiVQ7iWjwWgvxPJXIkE6qse8QGcUvOkJQ2ht8E2gYusI/A2Rv2bH0eTlD3Y3TUonTw26PZq+Iu5CWyzLTSYeLZBdkZpi+TzhP5PABPdW/HIsSF/8g8XKhS+WaGRuGvTwhOi/jURkmBcBapaaz7qLft+OfWO+2qjDufVtAM8jhDwL0lejH2Z6mEISRNPe9M4U/slwmds/qI3WAuzabaq9bHFLQqCpN/LkpUzYdIfJSYCdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCE73AGCuOXtXxSCOnqEwE9MT3d/notlrPsBIm75ryY=;
 b=AZ028MJbmRR/hoEDhoIVnzcuCD4IFNnrzuxC1j1CEbqDZRvEQLt5u+2WX1C7kN4hr7QGV5WkY93/eGbHIBcvuOBkQar9tVHpt1OomZNWWJ6d5/KRMdngeM/fOsNFWdMJPbNcCNuRkqT9iTdW1q5XM+hn1fhOVOOEyJO+hGC2dymxfxevuWUzKLfbs6upZgy6K4JYYGnwbMTPu8W3eKgKIiTsvuJsBQ6XkiB5lE3mPtDfPJX90FaE82eGUlaeJX3I6KV2mfaJayhCspvQy8yvf7Mwor/CBnHM2fbaoBs1PQCJb5zDfg7poSmQ+pXj7Xi25ri1WQ+fWUXDlI71pETDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCE73AGCuOXtXxSCOnqEwE9MT3d/notlrPsBIm75ryY=;
 b=2AX6Zvhitj57//VM0oEFLcy7GMnc8AlGp2lWRBDT0OJ7i2eBvydGVFCtzA4CvoR9IGM8j5xPeB1GLqsyyV/PgxSyz5KS0wvCjAje6o4uy+4BdUY7DkzJoh2PZ7MFrRc9SDmxAoHNTUKZ5uLmDH0uWd2GiEKVGZwog8Epz0nvS2Q=
Received: from SJ2PR07CA0016.namprd07.prod.outlook.com (2603:10b6:a03:505::16)
 by CH3PR12MB7761.namprd12.prod.outlook.com (2603:10b6:610:153::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:05:30 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::47) by SJ2PR07CA0016.outlook.office365.com
 (2603:10b6:a03:505::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Tue,
 23 Sep 2025 05:05:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:05:29 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:05:24 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 07/17] KVM: SVM: Add IPI Delivery Support for Secure AVIC
Date: Tue, 23 Sep 2025 10:33:07 +0530
Message-ID: <20250923050317.205482-8-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|CH3PR12MB7761:EE_
X-MS-Office365-Filtering-Correlation-Id: 07590adb-0de4-4c39-629e-08ddfa5ed113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yGLwAcRitRK8n9+FMPfnTAVEso8awVgRgLC4eYaRi4VTLP118oZHAXOmfFSs?=
 =?us-ascii?Q?luTflWWwckeeEfNaTbkhKkocm/zn9L0PlByCDpm1aeRXS09cGjJd1EFhSNLA?=
 =?us-ascii?Q?kyUC2oYcAaECHZd8zMLlREbZ6HfoeUlMtZZGTFe9JPjguJQAGuJa7PUWFqEv?=
 =?us-ascii?Q?sujd2PJi8HiQu/txa2i0SBDl/mQcqtYGRyFq+iFmcFJGpOQtfh+DOLfOM4BG?=
 =?us-ascii?Q?6nNISg2bVF88hBcbkd36bjMc55dHpjZ/l3qGplsAhKijQm9kaQEzV8KD0TGn?=
 =?us-ascii?Q?jbM4gMx3NYkNpayKyd2yT6Nj/z66doif9gh8PicLwBGGGtwp8acJuLXZgnRy?=
 =?us-ascii?Q?PPkpbgHFv92RTW/ISy9FLbq73di6UBKXsv939LvWEnQTAUggh3X5CpBLk/3Z?=
 =?us-ascii?Q?MXAfcidl+phKdw7ZXtwjljE+O6uiloNFwyufsPXL/CeRYuzziPluoXrHZ0wr?=
 =?us-ascii?Q?Gj6HscT9SwQKY0AsCdQB5LA/cIKobTS8UByoieYy1SZwbg/o66EgXnhtnNWA?=
 =?us-ascii?Q?65jpI7rXvabEPHdYypqwdCU6yUFSxFMMRAqw4nywdK+33PNaKo/nue9up8qJ?=
 =?us-ascii?Q?C3m8qaZyvqLWmGFvRnRsS91G/zCAHmiP6v9Jc9iE0Jugm2F3Rc54vRTcQ9V/?=
 =?us-ascii?Q?42qRX9wkx/N2k8aH3JnqTsU47NdVsyY5IDeA2RZ+/1LjKeaXZg6FPpO+CWI3?=
 =?us-ascii?Q?BXT2Xz1edlVYxm65fWsArtlJRhpFVDokjHVyQHVSthmyWwDa1CeQ6rXiYGEY?=
 =?us-ascii?Q?8CrTe8y7EhMBsed2OCVdJ8mCNUpYCJDn8aChej9dqbc91sxwuNkYDwne8vSD?=
 =?us-ascii?Q?5u5gLIbifXkK6sl0WTtQDXTTAZEyI4Nvpa2amV3wAWdq1s+fyNBPdvWyr5/5?=
 =?us-ascii?Q?kKr3Xovk2kTeAUNTTJhpudWmDhRjjIj/6IAH0bQL9V05mdzO2oXr7uwVV6sU?=
 =?us-ascii?Q?CtcjFYHxF/Qb/IbwrbRKk/gXUaAIj3WPDseUagA1YW2C5yBC3qHTDQn1up84?=
 =?us-ascii?Q?OCpGJb0S4Wn20mJh84iKBTU/zDb2aTA9AIexaev29Yk2mBjaK3DBHuijljJZ?=
 =?us-ascii?Q?NuAgNI3xAqfOaRFRK8zFoLGAiu6aUFRiSdiLY6QUmxtTRrvXlsf+3jkXaBIm?=
 =?us-ascii?Q?7rmfjDdZPAQK+Sbie+YdkUIZADhOVDhhn0SN0HYn5doDlQD0f8uaFtXKxXHZ?=
 =?us-ascii?Q?bugbS00GLkheuFcVg9yaT0D6zXEJXD6y/ExTL6VHKRVhs/Vnp66HGbul3UvA?=
 =?us-ascii?Q?kWYUCF0r68r7Do+8NWllkHVT3mB5gKb+V9Y/ayX0un0D7cN6+GpziQghpMn6?=
 =?us-ascii?Q?e5gjA71/yf6GU+7ZE1oew6xDhAzEPKvIY3HdKFkO+C/1p6KDT/OT+7giNQ3Q?=
 =?us-ascii?Q?ntKFdw2aTubmAVMoSr3fehrhPbqMuY5KLc2NoRkXrhHJQ1nFHv5a1u+mrsCU?=
 =?us-ascii?Q?vSzCAXEMUkwKdg7nOk0uwW1LEl70YxKP5xeSqwUJo+cntKUyIKlgljyjZ4wL?=
 =?us-ascii?Q?A+SG7kRc4BV4A14rZL5kdTBw53wLTn0qz7Yw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:05:29.6717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07590adb-0de4-4c39-629e-08ddfa5ed113
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7761

Secure AVIC hardware only accelerates Self-IPI, i.e. on WRMSR to
APIC_SELF_IPI and APIC_ICR (with destination shorthand equal to "self")
registers, hardware takes care of updating the APIC_IRR in the guest-owned
APIC backing page of the vCPU. For other IPI types (cross-vCPU, broadcast
IPIs), software needs to take care of updating the APIC_IRR state in the
target vCPUs' APIC backing page and to ensure that the target vCPU notices
the new pending interrupt.

To ensure that the remote vCPU notices the new pending interrupt, the guest
sends a APIC_ICR MSR-write GHCB protocol event to the hypervisor.

Handle the APIC_ICR write MSR exits for Secure AVIC guests by either
sending an AVIC doorbell (if the target vCPU is running) or by waking up
the non-running target vCPU thread.

To ensure that the target vCPU observes the new IPI request, introduce a
new per-vcpu flag, sev_savic_has_pending_ipi. This flag acts as a reliable
"sticky bit" that signals a pending IPI, ensuring the event is not lost
even if the primary wakeup mechanism is missed. Update
sev_savic_has_pending_interrupt() to return true if
sev_savic_has_pending_ipi is set. This ensures that when a vCPU is about
to block (in kvm_vcpu_block()), it correctly recognizes that it has work
to do and will not go to sleep.

Clear the sev_savic_has_pending_ipi flag in pre_sev_run() just before the
next VM-entry. This resets the one-shot signal, as the pending interrupt
is now about to be processed by the hardware upon VMRUN.

During APIC_ICR write GHCB request handling, unconditionally set
sev_savic_has_pending_ipi for the target vCPU irrespective of whether the
target vCPU is in guest mode or not. If the target vCPU does not take any
other VMEXIT before taking next hlt exit, the vCPU blocking fails as
sev_savic_has_pending_ipi remains set. The sev_savic_has_pending_ipi is
cleared before next VMRUN and on subsequent hlt exit the vCPU thread
would block.

Following are the race conditions which can occur between target vCPU
doing hlt and the source vCPU's IPI request handling.

a. VMEXIT before HLT when RFLAGS.IF = 0 or Interrupt shadow is active.

   #Source-vCPU                          #Target-VCPU

   1. sev_savic_has_pending_ipi = true
   2. smp_mb();
                                         3. Disable interrupts
   4. Target vCPU is in guest mode
   5. Raise AVIC doorbell to target
      vCPU's physical APIC_ID
                                         6. VMEXIT
                                         7. sev_savic_has_pending_ipi =
                                            false
                                         8. VMRUN
                                         9. HLT
                                        10. VMEXIT
                                        11. kvm_arch_vcpu_runnable()
                                            returns false
                                        12. vCPU thread blocks

   In this scenario IDLE HLT intercept ensures that the target vCPU does
   not take hlt intercept as V_INTR is set (AVIC doorbell by source vCPU
   triggers evaluation of Secure AVIC backing page of the target vCPU
   and sets V_INTR).

b. Target vCPU takes HLT VMEXIT but hasn't cleared IN_GUEST_MODE at the
   time when doorbell write is issued by source CPU.

   #Source-vCPU                          #Target-VCPU

   1. sev_savic_has_pending_ipi = true
   2. smp_mb();
   3. Target vCPU is in guest mode
                                         4. HLT
                                         5. VMEXIT
   6. Raise AVIC doorbell to the target
      physical CPU.
                                         7. vcpu->mode =
                                              OUTSIDE_GUEST_MODE
                                         8. kvm_cpu_has_interrupt()
                                             protected_..._interrupt()
                                              smp_mb()
                                              sev_savic_has_pending_ipi is
                                              true

   In this case, the smp_mb() barriers at 2, 8 guarantee that the target
   vCPU's thread observes sev_savic_has_pending_ipi is set and returns to
   the guest mode without blocking.

c. For other cases, where the source vCPU thread observes the target vCPU
   to be outside of the guest mode, memory barriers in rcuwait_wake_up()
   (source vCPU thread) and set_current_state() (target vCPU thread)
   provides the required ordering and ensures that read of
   sev_savic_has_pending_ipi in kvm_vcpu_check_block() observes the write
   by the source vCPU.

   #Source-vCPU                          #Target-VCPU

   rcuwait_wake_up()
     smp_mb()
     task = rcu_dereference(w->task);
     if (task)
       wake_up_process()
                                        prepare_to_rcuwait()
                                          w->task = current
                                        set_current_state(
                                            TASK_INTERRUPTIBLE)
                                          smp_mb()
                                        kvm_vcpu_check_block()
                                          kvm_cpu_has_interrupt()
                                            <Read sev_savic_has_..._ipi>

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 218 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h |   2 +
 2 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 78cefc14a2ee..a64fcc7637c7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3511,6 +3511,89 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
 		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
 
+	/*
+	 * It should be safe to clear sev_savic_has_pending_ipi here.
+	 *
+	 * Following are the scenarios possible:
+	 *
+	 * Scenario 1: sev_savic_has_pending_ipi is set before hlt exit of the
+	 * target vCPU.
+	 *
+	 * Source vCPU                     Target vCPU
+	 *
+	 * 1. Set APIC_IRR of target
+	 *    vCPU.
+	 *
+	 * 2. VMGEXIT
+	 *
+	 * 3. Set ...has_pending_ipi
+	 *
+	 * savic_handle_icr_write()
+	 *   ..._has_pending_ipi = true
+	 *
+	 * 4. avic_ring_doorbell()
+	 *                            - VS -
+	 *
+	 *				   4. VMEXIT
+	 *
+	 *                                 5. ..._has_pending_ipi = false
+	 *
+	 *                                 6. VM entry
+	 *
+	 *                                 7. hlt exit
+	 *
+	 * In this case, any VM exit taken by target vCPU before hlt exit
+	 * clears sev_savic_has_pending_ipi. On hlt exit, idle halt intercept
+	 * would find the V_INTR set and skip hlt exit.
+	 *
+	 * Scenario 2: sev_savic_has_pending_ipi is set when target vCPU
+	 * has taken hlt exit.
+	 *
+	 * Source vCPU                     Target vCPU
+	 *
+	 *                                 1. hlt exit
+	 *
+	 * 2. Set ...has_pending_ipi
+	 *                                 3. kvm_vcpu_has_events() returns true
+	 *                                    and VM is reentered.
+	 *
+	 *                                    vcpu_block()
+	 *                                      kvm_arch_vcpu_runnable()
+	 *                                        kvm_vcpu_has_events()
+	 *                                          <return true as ..._has_pending_ipi
+	 *                                           is set>
+	 *
+	 *                                 4. On VM entry, APIC_IRR state is re-evaluated
+	 *                                    and V_INTR is set and interrupt is delivered
+	 *                                    to vCPU.
+	 *
+	 *
+	 * Scenario 3: sev_savic_has_pending_ipi is set while halt exit is happening:
+	 *
+	 *
+	 * Source vCPU                        Target vCPU
+	 *
+	 *                                  1. hlt
+	 *                                       Hardware check V_INTR to determine
+	 *                                       if hlt exit need to be taken. No other
+	 *                                       exit such as intr exit can be taken
+	 *                                       while this sequence is being executed.
+	 *
+	 * 2. Set APIC_IRR of target vCPU.
+	 *
+	 * 3. Set ...has_pending_ipi
+	 *                                  4. hlt exit taken.
+	 *
+	 *                                  5. ...has_pending_ipi being set is observed
+	 *                                     by target vCPU and the vCPU is resumed.
+	 *
+	 * In this scenario, hardware ensures that target vCPU does not take any exit
+	 * between checking V_INTR state and halt exit. So, sev_savic_has_pending_ipi
+	 * remains set when vCPU takes hlt exit.
+	 */
+	if (READ_ONCE(svm->sev_savic_has_pending_ipi))
+		WRITE_ONCE(svm->sev_savic_has_pending_ipi, false);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
@@ -4281,6 +4364,129 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	return 0;
 }
 
+static void savic_handle_icr_write(struct kvm_vcpu *kvm_vcpu, u64 icr)
+{
+	struct kvm *kvm = kvm_vcpu->kvm;
+	struct kvm_vcpu *vcpu;
+	u32 icr_low, icr_high;
+	bool in_guest_mode;
+	unsigned long i;
+
+	icr_low = lower_32_bits(icr);
+	icr_high = upper_32_bits(icr);
+
+	/*
+	 * TODO: Instead of scanning all the vCPUS, get fastpath working which should
+	 * look similar to avic_kick_target_vcpus_fast().
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_match_dest(vcpu, kvm_vcpu->arch.apic, icr_low & APIC_SHORT_MASK,
+					 icr_high, icr_low & APIC_DEST_MASK))
+			continue;
+
+		/*
+		 * Setting sev_savic_has_pending_ipi could result in a spurious
+		 * return from hlt (as kvm_cpu_has_interrupt() would return true)
+		 * if destination CPU is in guest mode and the guest takes a hlt
+		 * exit after handling the IPI. sev_savic_has_pending_ipi gets cleared
+		 * on VM entry, so there can be at most one spurious return per IPI.
+		 * For vcpu->mode == IN_GUEST_MODE, sev_savic_has_pending_ipi need
+		 * to be set to handle the case where the destination vCPU has taken
+		 * hlt exit and the source CPU has not observed (target)vcpu->mode !=
+		 * IN_GUEST_MODE.
+		 */
+		WRITE_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi, true);
+		/* Order sev_savic_has_pending_ipi write and vcpu->mode read. */
+		smp_mb();
+		/* Pairs with smp_store_release in vcpu_enter_guest. */
+		in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
+		if (in_guest_mode) {
+			/*
+			 * Signal the doorbell to tell hardware to inject the IRQ.
+			 *
+			 * If the vCPU exits the guest before the doorbell chimes,
+			 * below memory ordering guarantees that the destination vCPU
+			 * observes sev_savic_has_pending_ipi == true before
+			 * blocking.
+			 *
+			 *   Src-CPU                       Dest-CPU
+			 *
+			 *  savic_handle_icr_write()
+			 *    sev_savic_has_pending_ipi = true
+			 *    smp_mb()
+			 *    smp_load_acquire(&vcpu->mode)
+			 *
+			 *                    - VS -
+			 *                              vcpu->mode = OUTSIDE_GUEST_MODE
+			 *                              __kvm_emulate_halt()
+			 *                                kvm_cpu_has_interrupt()
+			 *                                  smp_mb()
+			 *                                  if (sev_savic_has_pending_ipi)
+			 *                                      return true;
+			 *
+			 *   [S1]
+			 *     sev_savic_has_pending_ipi = true
+			 *
+			 *     SMP_MB
+			 *
+			 *   [L1]
+			 *     vcpu->mode
+			 *                                  [S2]
+			 *                                  vcpu->mode = OUTSIDE_GUEST_MODE
+			 *
+			 *
+			 *                                  SMP_MB
+			 *
+			 *                                  [L2] sev_savic_has_pending_ipi == true
+			 *
+			 *   exists (L1=IN_GUEST_MODE /\ L2=false)
+			 *
+			 *   Above condition does not exit. So, if the source CPU observes
+			 *   vcpu->mode = IN_GUEST_MODE (L1), sev_savic_has_pending_ipi load by
+			 *   the destination CPU (L2) should observe the store (S1) from the
+			 *   source CPU.
+			 */
+			avic_ring_doorbell(vcpu);
+		} else {
+			/*
+			 * Wakeup the vCPU if it was blocking.
+			 *
+			 * Memory ordering is provided by smp_mb() in rcuwait_wake_up() on the
+			 * source CPU and smp_mb() in set_current_state() inside kvm_vcpu_block()
+			 * on the destination CPU.
+			 */
+			kvm_vcpu_kick(vcpu);
+		}
+	}
+}
+
+static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
+{
+	u32 msr, reg;
+
+	msr = kvm_rcx_read(vcpu);
+	reg = (msr - APIC_BASE_MSR) << 4;
+
+	switch (reg) {
+	case APIC_ICR:
+		/*
+		 * Only APIC_ICR WRMSR requires special handling for Secure AVIC
+		 * guests to wake up destination vCPUs.
+		 */
+		if (to_svm(vcpu)->vmcb->control.exit_info_1) {
+			u64 data = kvm_read_edx_eax(vcpu);
+
+			savic_handle_icr_write(vcpu, data);
+			return true;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4419,6 +4625,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_EXIT_MSR:
+		if (sev_savic_active(vcpu->kvm) && savic_handle_msr_exit(vcpu))
+			return 1;
+
+		fallthrough;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
 	}
@@ -5106,5 +5317,10 @@ void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
 
 bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_has_interrupt(vcpu) != -1;
+	/*
+	 * See memory ordering description in savic_handle_icr_write().
+	 */
+	smp_mb();
+	return READ_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi) ||
+		kvm_apic_has_interrupt(vcpu) != -1;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 60dc424d62c4..a3edb6e720cd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,6 +335,8 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	bool sev_savic_has_pending_ipi;
 };
 
 struct svm_cpu_data {
-- 
2.34.1


