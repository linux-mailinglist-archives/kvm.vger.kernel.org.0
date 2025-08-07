Return-Path: <kvm+bounces-54264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07595B1DC0A
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 19:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 110B3560F2D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 17:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F302727E3;
	Thu,  7 Aug 2025 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kypPOajP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D562727EE;
	Thu,  7 Aug 2025 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754586004; cv=fail; b=YDiJGOvU0srL5ZVALIZ4p3CytaGpqFVA7Tx2IkMd9Ziafsu4UiOcEcwx2W66GWv7XbZuciyYL3sSXFdgMUSPmqQszHFK8AUhFntPMHDNGzm0yGwj2SzhQBwoFh47N0lG8iz3XnP0q1KgsjYUoPeWhAId3WkCH3VU97TmS/999Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754586004; c=relaxed/simple;
	bh=LUz79zn8T+EE5c8V5ZbheeX0sYtxHyrN7OA1ACwQE3g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CovktxYx5VDm7dkBOonKbXZmcCt2CAWuyFerQgJOWNF2q/kRSJVq8QEXaRNmmu1Iedanl4I5BO6lHQclqwYktnhwjcBzHaHm/mdlB4PVlj5nuZlqNfgtMga83+9EPOA8i4wDIp4sE/iiLdWV0WSyqY/G++e1q3Dg5/rmbfvvIZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kypPOajP; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4AruFvVzm0wTi8v/uCy/y1HtMLZvuFZS98Gai4F47PGjipPpW38Qem/ggu6ACnKLsXAwHlCuDxU6aVki7JsdyNqPr5mcBxiU8t1en2aXceAAc6G7tjg97OWC3P2ZF1NwgnvbM5XVE2iq9xV0y6CA0S/4Nr8tcXsPpU3SFppT8mfl6F5ky2/tWkWjrZLEHngXSDh4199L/bCV7X1trpcXtGH3eE6h3IZeT72AC6Vb3QlNecIahPsVe+TpzUMEcN2VIj3e1YEZ9hB3ykvYRgL2Dobi3xh5g5elHqOTP3M26Saji7MY7f0Q58bQzJW2jIpLwb/Fe1fwqLkYsK3I+vaiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPbsbCKUe51XOGLiLCNgkOqLJwyd0ye0jOeo3gYW9m8=;
 b=Zw8+rPOR9nWY4K1+SfuZqBmZ8j480RXpvVYlLcc6MLyugieETCndHPvmw5bQ3+EcpE2+5mxJM/9X0BgbCTatQHeUTDrqn2l/AfjazBpR4ymRPmQQQ+Xgub1gMvRvQKFs3DYz4OGp9vrytWewzpoyrVHZbLfbYLF13BUDRdVbHORCV6uJ/SIPMc5mXUeggK1CsfGSvszPnSraL3f0fdJ7DEmZA/32GWASaXmTWRP9WjaezIEWPHSKr8icgyARqY4qLsajPcpZ5kVkctZaa/Eerit0dZAxfkrVckWm30sIEazsyr6bgz4ybZiDwpWeCFd14/CIDu+AqWKN6Ipby5bFkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPbsbCKUe51XOGLiLCNgkOqLJwyd0ye0jOeo3gYW9m8=;
 b=kypPOajPqBhiDfVybbVr1BrQpxLDHJ9jViDd0cc33iyKAjzPZISFFFx8bYi7ggrOYEJCo8VshpMOdz1jFC7HjeM1PrluuBVl4h/bjnHCTIKPfNAmBaGBO69F8m9KHK5lkGMcECiWzx/6R+n9oE7x44wfvKdY6kW4xekkW0z9RP8=
Received: from SJ0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:a03:2c0::34)
 by LV8PR12MB9666.namprd12.prod.outlook.com (2603:10b6:408:296::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 7 Aug
 2025 16:59:59 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::2e) by SJ0PR13CA0029.outlook.office365.com
 (2603:10b6:a03:2c0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.8 via Frontend Transport; Thu, 7
 Aug 2025 16:59:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Thu, 7 Aug 2025 16:59:59 +0000
Received: from dryer.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 7 Aug
 2025 11:59:56 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, K Prateek
 Nayak <kprateek.nayak@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Borislav Petkov
	<borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Dhaval Giani <Dhaval.Giani@amd.com>, "Santosh
 Shukla" <santosh.shukla@amd.com>, Naveen Rao <naveen.rao@amd.com>, "Gautham R
 . Shenoy" <gautham.shenoy@amd.com>, Ananth Narayan <ananth.narayan@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>, David Kaplan <david.kaplan@amd.com>,
	"Jon Grimm" <Jon.Grimm@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [RFC PATCH 0/1] KVM: SEV: Add support for SMT Protection
Date: Thu, 7 Aug 2025 11:59:49 -0500
Message-ID: <20250807165950.14953-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|LV8PR12MB9666:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f39ec79-0aed-485a-28eb-08ddd5d3d7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VaF2WVJsbowUH9LyY3HOyb73km7evdWEHWeG43Lf9+1eNxNcn4zQOiUkmYCq?=
 =?us-ascii?Q?cf2bZhMe75ziYVHdSBIw/HSsLXO3FY1l4Y/raqnSId9E49gldV0ThqJRo7Pw?=
 =?us-ascii?Q?FYWq67LM+2/6zM+fhUS0imy864cnRcI4Tgtok5gsvTcMkJsOVGPxSnIX7RnI?=
 =?us-ascii?Q?4ioH9fYbwNrX9OyUCBDjHXIXi1S7+tzYw7j8qPO7EtF1sorPpL+usSVuCl6u?=
 =?us-ascii?Q?3hsm2D60/X0J31u1y1M84lXDdeiMafKgBT7as51UddqwWk87Y68QbO708YB2?=
 =?us-ascii?Q?j8XWTwXWdCN/77F3UqZtUFHlmxptHcavX2Pvtkz4ewl94oUCYJ6/SNx63c7d?=
 =?us-ascii?Q?12D+CmFO5G0VhF0rMvve127Kk203/tAb5A7m5R2lC9RzqGoaTJNNTnPBVCjX?=
 =?us-ascii?Q?iMQFvrUUoiV/1SAIJQKaji3o6fe5ZFe4tooAJ6Fypl34W7qbALSHJFnhJS8p?=
 =?us-ascii?Q?wVmaXPc20T0u6mj1c+rOdkHg9GBQ697cIw+BWKs3Fn8Y+PtUqTduauJSYfyh?=
 =?us-ascii?Q?QPK26eCvklqbbCxQgbU2wHHC+ep7YZFmmbqgrJuBXEsKFkSknUgEKoSZbT7p?=
 =?us-ascii?Q?2GLFD5jbTFTJ75YJaOhnSfYy+CXY1q0Z1XOXmD/t2D4fDUvvbxFNb4/Zd8y8?=
 =?us-ascii?Q?VsgHb20HXx/MlRozoHzxoFQk6JjjEhO2BREFdeWnSVag90Y8sBRuSfDfHMqv?=
 =?us-ascii?Q?WomMfVNBDcgonoLfhblO3QIwmDvCcptqmYPM61US/2GpCuPXf7cnwBjML62n?=
 =?us-ascii?Q?Ek8BM+yn6qqzgeIapWHHyAY0XueQR/3Fg3nM0Yz/sRblffBgoU2uLi+yYgup?=
 =?us-ascii?Q?KagL1EMwgUNPAV4m4Rj83MggcMkFWz7G2fvSsR4sUHAhSqsbkxNvGxDwzzCP?=
 =?us-ascii?Q?xqdq/LcF8f7fCwtmlgnvGJ4KUJepQIgBk0NQ1ZXxebudYn4lI5wVg1BN4Dew?=
 =?us-ascii?Q?/eWMUJ1kgt/y/BdSjsO6bHOAgQcYhxpF0f/3E4gpkEjzAiLw+hUtnCXm/nu2?=
 =?us-ascii?Q?wLO+JuX4JT6tmJE8r+jyHSIqj/2N7nsUnw3asNxe8k0/EgKs4JV80QSvlVJE?=
 =?us-ascii?Q?IASbsKq2jVK8fmGHVlym/ruwUXqSZh4wve0OOXIsxGAm/vHcU9rm2au9eTpW?=
 =?us-ascii?Q?ubOvDph4IPAumPP2QXwcV19CuADu9Chq2WNMPyScSLp1qaaes+PPYc3Q+oUg?=
 =?us-ascii?Q?ihGxqAL3b5YavscO4oYd7+gXmXFF+62UBhOG+cZBTd2mh1luqjqduLfh4cwM?=
 =?us-ascii?Q?Dgva/T3GsxluLaPqdnojuS47XRb6d7H+vrARKL+kfSBsYvSYVvif1ANzCQbN?=
 =?us-ascii?Q?xttNri7a5Tbi2DRQ5+ZJLi77IgL1aWdgzGdyaBVNVpmS1yZcy6Ldnx+Mki0L?=
 =?us-ascii?Q?1kiQqpEJ9E3yRbWBlvSrlQAc2AWSlHdzPdxu9LJO8Iee/K9o+GsyNp3kNWlS?=
 =?us-ascii?Q?AdRLczu43dmF4oLrSG1Ok70E7p2fMjv30HK6ia5oeQwUp8wLTYwNK7sAvCrv?=
 =?us-ascii?Q?873gtq4LPwxUFkM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:59:59.1420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f39ec79-0aed-485a-28eb-08ddd5d3d7db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9666

On an SMT-enabled system, the SMT Protection feature allows an
SNP guest to demand its hardware vCPU thread to run alone on
the physical core.  It will opt to do this to protect itself
against possible side channel attacks from shared core resources.
Hardware supports this by enforcing the sibling of the vCPU thread
to be in the idle state when the vCPU is running: If hardware detects
the sibling has not entered the idle state, or it exited it, then
the vCPU VMRUN exits with a new "IDLE_REQUIRED" status, where the
hypervisor should schedule the idle process on the sibling thread
simultaneously with resuming the vCPU VMRUN.

There is a new HLT_WAKEUP_ICR MSR that the hypervisor programs
for each system SMT thread such that if an idle sibling of a
SMT Protected guest vCPU receives an interrupt, hardware will write
the HLT_WAKEUP_ICR value to the APIC ICR to 'kick' the vCPU
thread out of its VMRUN state. Hardware then allows the sibling
to then exit the idle state and service its interrupt.

The feature is supported on EYPC Zen 4 and above CPUs.

For more information, see "15.36.17 Side-Channel Protection",
"SMT Protection", in:

"AMD64 Architecture Programmer's Manual Volume 2: System Programming Part 2,
Pub. 24593 Rev. 3.42 - March 2024"

available here:

https://bugzilla.kernel.org/attachment.cgi?id=306250

See the end of this message for the qemu hack that calls the
Linux Core Scheduler prctl syscall to create a unique per-vCPU
cookie to ensure the vCPU process will not be scheduled if
there is anything else running on the sibling thread of the
core.

As it turns out, this approach is less than efficient because
existing Core Scheduling semantics only prevent other userspace
processes from running on the sibling thread that hardware requires
to be in the idle state.

Because of this, the sibling CPU VMRUN frequently exits with
"IDLE_REQUIRED" when the scheduler runs its "OS noise" (softirq
work, etc.) instead of forcing the hardware idle state throughout
the duration of the VMRUN.

Mild testing yields eventual CPU stalls in the guest (minutes after
boot):

[    C0] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[    C0] rcu: 	1-...!: (0 ticks this GP) idle=8d58/0/0x0 softirq=12830/12830 fqs=0 (false positive?)
[    C0] rcu: 	(detected by 0, t=16253 jiffies, g=12377, q=12 ncpus=2)
[    C0] rcu: rcu_preempt kthread timer wakeup didn't happen for 16252 jiffies! g12377 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
[    C0] rcu: 	Possible timer handling issue on cpu=1 timer-softirq=15006
[    C0] rcu: rcu_preempt kthread starved for 16253 jiffies! g12377 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
[    C0] rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.

..with the occasional "NOHZ tick-stop error: local softirq work is
pending, handler #200!!!" on the host.

However, this RFC represents only one of three approaches attempted:

 - Another brute-force approach simply called remove_cpu() on the sibling
   before, and add_cpu() after __svm_sev_es_vcpu_run() in
   svm_vcpu_enter_exit().  The effort was quickly abandoned since
   it led to insurmountable lock contention issues:
   BUG: scheduling while atomic: qemu-system-x86/6743/0x00000002
    4 locks held by qemu-system-x86/6743:
    #0: ff160079b2dd80b8 (&vcpu->mutex){....}-{3:3}, at: kvm_vcpu_ioctl+0x94/0xa40 [kvm]
    #1: ffffffffba3c5410 (device_hotplug_lock){....}-{3:3}, at: lock_device_hotplug+0x1b/0x30
    #2: ff16009838ff5398 (&dev->mutex){....}-{3:3}, at: device_offline+0x9c/0x120
    #3: ffffffffb9e7e6b0 (cpu_add_remove_lock){....}-{3:3}, at: cpu_device_down+0x24/0x50

 - The third approach attempted to forward port vCPU Core Scheduling
   from the original 4.18 based work by Peter Z.:

   https://github.com/pdxChen/gang/commits/sched_1.23-base

   K. Prateek Nayak provided enough guidance to get me past host lockups
   from "kvm,sched: Track VCPU threads", but the following "sched: Add VCPU
   aware SMT scheduling" commit proved insurmountable to forward-port
   given the complex changes to scheduler internals since then.

Comments welcome:

- Are any of these three approaches even close to an
  upstream-acceptable solution to support SMT Protection?

- Given the feature's strict sibling idle state constraints,
  should SMT Protection even be supported at all?

This RFC applies to kvm-x86/next kvm-x86-next-2025.07.21 (33f843444e28).

Qemu hack:

From 0278a4078933d9bce16a8e80f415466b44244a59 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Wed, 2 Apr 2025 16:02:50 -0500
Subject: [RFC PATCH] system/cpus: Affine and Core-Schedule vCPUs onto pCPUs

DO NOT MERGE.

Hack to experiment supporting SEV-SNP "SMT Protection" feature.  It:

 1. Affines vCPUs to individual core pCPUs (as cpu_index increments
    over single-core threads 1, 2, etc.),

 2. Calls the Linux Core Scheduler prctl syscall to create a per-vCPU
    unique cookie to ensure the vCPU process will not be scheduled
    if there is anything else on the sibling thread of the pCPU core.

Note: It contains POSIX-specific code that really belongs in
util/qemu-thread-posix.c, and other hackery.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 accel/kvm/kvm-accel-ops.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index c239dfc87a..4b853d3024 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -26,9 +26,12 @@
 #include <linux/kvm.h>
 #include "kvm-cpus.h"

+#include <sys/prctl.h> /* PR_SCHED_CORE_CREATE */
+
 static void *kvm_vcpu_thread_fn(void *arg)
 {
     CPUState *cpu = arg;
+    cpu_set_t cpuset;
     int r;

     rcu_register_thread();
@@ -38,6 +41,16 @@ static void *kvm_vcpu_thread_fn(void *arg)
     cpu->thread_id = qemu_get_thread_id();
     current_cpu = cpu;

+    CPU_ZERO(&cpuset);
+    CPU_SET(cpu->cpu_index, &cpuset);
+    pthread_setaffinity_np(cpu->thread->thread, sizeof(cpu_set_t), &cpuset);
+
+    r = prctl(PR_SCHED_CORE, PR_SCHED_CORE_CREATE, 0, 0, 0);
+    if (r) {
+        printf("%s %d: CORE CREATE ret %d \r\n", __func__, __LINE__, r);
+        exit(1);
+    }
+
     r = kvm_init_vcpu(cpu, &error_fatal);
     kvm_init_cpu_signals(cpu);

--
2.43.0

Kim Phillips (1):
  KVM: SEV: Add support for SMT Protection

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/svm.h    |  1 +
 arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 +++
 6 files changed, 24 insertions(+)

base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
--
2.43.0

Kim Phillips (1):
  KVM: SEV: Add support for SMT Protection

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/svm.h    |  1 +
 arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 +++
 6 files changed, 24 insertions(+)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.43.0


