Return-Path: <kvm+bounces-25783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 273C396A724
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72261B218EC
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 19:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0E31D5CC0;
	Tue,  3 Sep 2024 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xkkaLEtP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C61D5CCD;
	Tue,  3 Sep 2024 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725390653; cv=fail; b=PwIPt/CXqZ+YbXRLQLJchd2fS/jZYCt1kVY3dhLnCuv7CTz1zh98AHD9e8ZjwUldc0qeMCa3RHzJ1281n0lS0gbeA8Q++gxYopG4gQ8fFTYf0eO5bVE1RnyY6UeAW8J4+KXnVBDfITkrXnhiMsL5tbNxj2RBPIlaAE1YGkVm5Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725390653; c=relaxed/simple;
	bh=HWlIErtkRHHpR5vR7QxKSi4lmcRz+l2B03rEgrOxFEE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lsBqGn/vGn1eKV5MY+4RqLhMuR51rDz6CTMAP7BrWtpK9MOLmLvfq9m6/127T++3aDQ/3G3b2uh0NxUPsrsAcm0TXnD/FeMcIU70Z7AV6qeffmBhNx/Usg5bI6Ml2fDdG8qeOg0QeOjEzxs2gvvCAO3XUT44XRbRHRIpSn73aBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xkkaLEtP; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nj526PaD3Xgh+2x1rnbscESxKkp3TrtRlPgDgNnVVSfJAmCdh0B4BCy98jZe+IT5CFU3YHSgRXqN4dT0NLUdx4PeGrk4hbkvDxR84VI/6+UQtwg7mFhMXh0MIMeZrBptWRw6x3B9CuNLgE1KoJ25QRr9iMV2Iae/GklrBf3Z0HOGjM8uAcMMaUAaGdUOVtts/oGAHr4J9FtedRHEpaEL04BqlDv6WgHwpwG48hXc74zTam80XZ3Gm9plIl7MOi8LW64B7VPkptdXxtCID49JNzvTd7d38OhwQxWMgLoFGCOKduEASL6sA7DNUJfKx73lsDrDMHvgCYtqeZquVwU+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YZxDswGnZpZvn6HrpSeryRVanQZHA2MhZdhyTYwCTw=;
 b=p/O7/NIAJ/e2wRiUS96/3rTXYOGzwb+pmZD4m5f6+YsNGROanjuHJIIk0PnKBTuJb1s83sEjtZXWIr+6mtRBrChkrTpvYOeVcn9OiwNWyMQCuZbgby10HgTWsZqjB9IJnF1Cx2vCqm/sjt5RLct94+7u33D4cbKgbXZmaFan3kBr9Hy/j65Ye/8rdFicBwdRFlS9H/D9dnHpjrRasT8HV/cFlnWhHYtRdcI6DO2NSZ0R2AS49GjZYx2e10orMP9ZbXsvevctvVub7H26Naqm4KNpw/pL4IsU/Hxu8MKOBd9YRte1XuI+U4phqq2DGGLwReoAiruF/SkDLkCw58HHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YZxDswGnZpZvn6HrpSeryRVanQZHA2MhZdhyTYwCTw=;
 b=xkkaLEtPNaVdyZxL3F+inxzaiC6H3mE+td+a6+zDnSbXDLAsNBhUuNC2Yc71srQgBTVq6Zcbs3g3MKQfwjz/wEDi1pgIBrRKtdxQszEQXtZQgk1ufVj7qFPgn92mdsMQjvbkUu38To8VbKzvRmSf+DqZI3XCqPIPZaTk5zHwUeA=
Received: from CH2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:610:5a::33)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Tue, 3 Sep
 2024 19:10:46 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::db) by CH2PR08CA0023.outlook.office365.com
 (2603:10b6:610:5a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Tue, 3 Sep 2024 19:10:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 19:10:43 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Sep
 2024 14:10:42 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@linux.intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>
CC: <hpa@zytor.com>, <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
	<kexec@lists.infradead.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v2] x86/sev: Fix host kdump support for SNP
Date: Tue, 3 Sep 2024 19:10:33 +0000
Message-ID: <20240903191033.28365-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: a76e69fc-d383-4407-9cf1-08dccc4c1bfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5IFh+uwULaaXirvPyIHS4wflz+WO1libDZ99Sww89/xppaHeqkzkcctnWFTn?=
 =?us-ascii?Q?eda1kuQeJPif8v5MO1acyXZ9nadJyN7W67V+ZIff8tlzYJkLYygNNwJwSWHM?=
 =?us-ascii?Q?Be/XlYPRoSczT1cWRbnSQ4ssiAqlC5ydAKzCutvyhpZK+c//l87MlgZgHDUj?=
 =?us-ascii?Q?kjq6Yv02pk1brLAbubfmJJhnNPLCdsK1/eqS10JD7Tgd/WfYLHXkweBmRS8x?=
 =?us-ascii?Q?jh0wx7tJ5p4MEdsUio1LgVpI4GF5cwR2PHGgK3vjDFyrh71iXuzTQeR5gWs6?=
 =?us-ascii?Q?aUUAhVKP9SRiaj1aa/B/5E6z3A0NU+hq0Z9A3Sufc6CR/pdG1L/uinEOc9LT?=
 =?us-ascii?Q?+kPrOTfP1sSWlnS6xD9ii3oh5qmxV49enIxGy4WvcQwzZzBJ15UeqS4SxWHz?=
 =?us-ascii?Q?cwexCK+jkC4P9+JGmar11+bdPM0VO87SrAtg3ZztEuIdFmVcHxYSLUFXsVSV?=
 =?us-ascii?Q?o0BrP5+UoNzyyFUiq//tN0jPss50X/V91vQ5afQZnZ1LgVoQd5uDBdBsZF0u?=
 =?us-ascii?Q?ggg9XB1Wz1xpY/Ruci8Nx47zFV1b5HkjO+jZynMokakvrkcWf8UXEl5kGdoJ?=
 =?us-ascii?Q?ieIyCQwAGAPCGwt93cA3VA8FWQr2woUaYogMc+0F7AXZ0gtTHa9fmN1SSGjS?=
 =?us-ascii?Q?xUgOVHxrraa8nRxtGF25m8WxWGsKOyul3CtIGHX8yA06OmUgXEom3nHVqCSa?=
 =?us-ascii?Q?iOc5FoGJJoXzLBixWibkZC0slsPROeZ0yB/rQme09LPstOKrmwNmVtf2/+jv?=
 =?us-ascii?Q?uPzfSKKK89F7BjkFUOxIkNJvAcIof0WbX+8UeyTuA/RoU9R57JZElmikJh15?=
 =?us-ascii?Q?Udot/ka9oOHgycSTBsSlQzgzpgGtOjwxWBWS3tEvkJt5fqz21QKUdSBZ9N+q?=
 =?us-ascii?Q?p/oSk+zi5ZZp/Yv6+ey9KnB+uYh3z+0lVSU+ew+XN0n3CBg3t2zzoQzZzAal?=
 =?us-ascii?Q?Lqt1ToEj0QkqU26LhCGMZJobPuMXN0A98alGO8IDd513QOizil1FQrFk4QRy?=
 =?us-ascii?Q?ks1v5tLZlzXsB38qcgXQ68UW+68mAoCXrAwfbIPsB+yL8u/OP+sAikTmr7HU?=
 =?us-ascii?Q?ACcV1CFPTPtD47AbRXgaME+AIJAP7FYVAVyTSDe6eSr/Z5Uprmhg39vdIztf?=
 =?us-ascii?Q?bYDx9ng5liDy4Y0RnfezKr/AnQZrcChrKE+3kIPM7oIaD+Zbnnc+s49pu3Kq?=
 =?us-ascii?Q?HFVp9JgX4/5/1mBnsk7M93NnIsJm3SZDWKZsqPuj7s2Ryui6zv+HPReYUAzO?=
 =?us-ascii?Q?yfEjbm8Ziq3MRZlFSQCuc4yDdBBkx927vQ3dwfmjpaixTf9V+qr38ENQlYGT?=
 =?us-ascii?Q?gCpvHGOm35G/aSUcQF6iGXX0CsjFkr6IiE+grml60h84oZX8gEeHfV6xFU02?=
 =?us-ascii?Q?4GE0399MSLHxMt6wootUgYLwgFhnOWDWZEglnMOyoFIpSK1CQk+hqLmqneKN?=
 =?us-ascii?Q?WjnDrG5AO2sQQfrIkvH+X2u3hT2IKe3v?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 19:10:43.7637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a76e69fc-d383-4407-9cf1-08dccc4c1bfc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010

From: Ashish Kalra <ashish.kalra@amd.com>

With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
crashkernel boot failure with the following signature:

[  563.497112] sysrq: Trigger a crash
[  563.508415] Kernel panic - not syncing: sysrq triggered crash
[  563.522002] CPU: 10 UID: 0 PID: 4661 Comm: bash Kdump: loaded Not tainted 6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty #61
[  563.549762] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM100AB 10/17/2022
[  563.566266] Call Trace:
[  563.576430]  <TASK>
[  563.585932]  dump_stack_lvl+0x2b/0x90
[  563.597244]  dump_stack+0x14/0x20
[  563.608141]  panic+0x3b9/0x400
[  563.618801]  ? srso_alias_return_thunk+0x5/0xfbef5
[  563.631271]  sysrq_handle_crash+0x19/0x20
[  563.642696]  __handle_sysrq+0xf9/0x290
[  563.653691]  ? srso_alias_return_thunk+0x5/0xfbef5
[  563.666126]  write_sysrq_trigger+0x60/0x80
...
...
[  564.186804] in panic
[  564.194287] in panic_other_cpus_shutdown
[  564.203674] kexec: in crash_smp_send_stop
[  564.213205] kexec: in kdump_nmi_shootdown_cpus
[  564.224338] Kernel Offset: 0x35a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  564.282209] in snp_shutdown_on_panic after decommission, wbinvd + df_flush required
[  564.462217] ccp 0000:23:00.1: SEV-SNP DF_FLUSH failed with error 14
[  564.676920] kexec: in native_machine_crash_shutdown
early console in extract_kernel
input_data: 0x000000007410d2cc
input_len: 0x0000000000ce98b2
output: 0x0000000071600000
output_len: 0x000000000379eb8c
kernel_total_size: 0x0000000002c30000
needed_size: 0x0000000003800000
trampoline_32bit: 0x0000000000000000

Invalid physical address chosen!

Physical KASLR disabled: no suitable memory region!

Virtual KASLR using RDRAND RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel (entry_offset: 0x0000000000000bda).
[    0.000000] Linux version 6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty (amd@ethanolx7e2ehost) (gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils) 2.40) #61 SMP Mon Aug 19 19:59:02 UTC 2024
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty root=UUID=4b87a03b-0e78-42ca-a8ad-997e63bba4e0 ro console=tty0 console=ttyS0,115200n8 earlyprintk=ttyS0,115200n8 amd_iommu_dump=1 reset_devices systemd.unit=kdump-tools-dump.service nr_cpus=1 irqpoll nousb elfcorehdr=1916276K
[    0.000000] KERNEL supported cpus:
...
...
[    1.671804] AMD-Vi: Using global IVHD EFR:0x841f77e022094ace, EFR2:0x0
[    1.679835] AMD-Vi: Translation is already enabled - trying to copy translation structures
[    1.689363] AMD-Vi: Copied DEV table from previous kernel.
[    1.864369] AMD-Vi: Completion-Wait loop timed out
[    2.038289] AMD-Vi: Completion-Wait loop timed out
[    2.212215] AMD-Vi: Completion-Wait loop timed out
[    2.386141] AMD-Vi: Completion-Wait loop timed out
[    2.560068] AMD-Vi: Completion-Wait loop timed out
[    2.733997] AMD-Vi: Completion-Wait loop timed out
[    2.907927] AMD-Vi: Completion-Wait loop timed out
[    3.081855] AMD-Vi: Completion-Wait loop timed out
[    3.225500] AMD-Vi: Completion-Wait loop timed out
[    3.231083] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
d out
[    3.579592] AMD-Vi: Completion-Wait loop timed out
[    3.753164] AMD-Vi: Completion-Wait loop timed out
[    3.815762] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
[    3.825347] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty #61
[    3.837188] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM100AB 10/17/2022
[    3.846215] Call Trace:
[    3.848939]  <TASK>
[    3.851277]  dump_stack_lvl+0x2b/0x90
[    3.855354]  dump_stack+0x14/0x20
[    3.859050]  panic+0x3b9/0x400
[    3.862454]  panic_if_irq_remap+0x21/0x30
[    3.866925]  setup_IO_APIC+0x8aa/0xa50
[    3.871106]  ? __pfx_amd_iommu_enable_faulting+0x10/0x10
[    3.877032]  ? __cpuhp_setup_state+0x5e/0xd0
[    3.881793]  apic_intr_mode_init+0x6a/0xf0
[    3.886360]  x86_late_time_init+0x28/0x40
[    3.890832]  start_kernel+0x6a8/0xb50
[    3.894914]  x86_64_start_reservations+0x1c/0x30
[    3.900064]  x86_64_start_kernel+0xbf/0x110
[    3.904729]  ? setup_ghcb+0x12/0x130
[    3.908716]  common_startup_64+0x13e/0x141
[    3.913283]  </TASK>
[    3.915715] in panic
[    3.918149] in panic_other_cpus_shutdown
[    3.922523] ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC ]---

This happens as SNP_SHUTDOWN_EX fails when SNP VMs are active as the
firmware checks every encryption-capable ASID to verify that it is
not in use by a guest and a DF_FLUSH is not required. If a DF_FLUSH
is required, the firmware returns DFFLUSH_REQUIRED.

To fix this, added support to do SNP_DECOMMISSION of all active SNP VMs
in the panic notifier before doing SNP_SHUTDOWN_EX, but then
SNP_DECOMMISSION tags all CPUs on which guest has been activated to do
a WBINVD. This causes SNP_DF_FLUSH command failure with the following
flow: SNP_DECOMMISSION -> SNP_SHUTDOWN_EX -> SNP_DF_FLUSH ->
failure with WBINVD_REQUIRED.

When panic notifier is invoked all other CPUs have already been
shutdown, so it is not possible to do a wbinvd_on_all_cpus() after
SNP_DECOMMISSION has been executed. This eventually causes SNP_SHUTDOWN_EX
to fail after SNP_DECOMMISSION.

Adding fix to do SNP_DECOMMISSION and subsequent WBINVD on all CPUs
during NMI shutdown of CPUs as part of disabling virtualization on
all CPUs via cpu_emergency_disable_virtualization ->
svm_emergency_disable().

SNP_DECOMMISSION unbinds the ASID from SNP context and marks the ASID
as unusable and then transitions the SNP guest context page to a
firmware page and SNP_SHUTDOWN_EX transitions all pages associated
with the IOMMU to reclaim state which the hypervisor then transitions
to hypervisor state, all these page state changes are in the RMP
table, so there is no loss of guest data as such and the complete
host memory is captured with the crashkernel boot. There are no
processes which are being killed and host/guest memory is not
being altered or modified in any way.

This fixes and enables crashkernel/kdump on SNP host.

v2:
- rename all instances of decommision to decommission
- created a new function sev_emergency_disable() which is exported from 
sev.c and calls __snp_decommission_all() to do SNP_DECOMMISSION
- added more information to commit message

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 133 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |   2 +
 arch/x86/kvm/svm/svm.h |   3 +-
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b7..30f286a3afb0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -16,6 +16,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/delay.h>
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
@@ -89,6 +90,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static DEFINE_SPINLOCK(snp_decommission_lock);
+static void **snp_asid_to_gctx_pages_map;
 static int snp_decommission_context(struct kvm *kvm);
 
 struct enc_region {
@@ -2248,6 +2251,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_context;
 	}
 
+	if (snp_asid_to_gctx_pages_map)
+		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = sev->snp_context;
+
 	return 0;
 
 e_free_context:
@@ -2884,9 +2890,126 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	if (snp_asid_to_gctx_pages_map)
+		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = NULL;
+
 	return 0;
 }
 
+static void __snp_decommission_all(void)
+{
+	struct sev_data_snp_addr data = {};
+	int ret, asid;
+
+	if (!snp_asid_to_gctx_pages_map)
+		return;
+
+	for (asid = 1; asid < min_sev_asid; asid++) {
+		if (snp_asid_to_gctx_pages_map[asid]) {
+			data.address = __sme_pa(snp_asid_to_gctx_pages_map[asid]);
+			ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+			if (!ret) {
+				snp_free_firmware_page(snp_asid_to_gctx_pages_map[asid]);
+				snp_asid_to_gctx_pages_map[asid] = NULL;
+			}
+		}
+	}
+}
+
+/*
+ * NOTE: called in NMI context from svm_emergency_disable().
+ */
+void sev_emergency_disable(void)
+{
+	static atomic_t waiting_for_cpus_synchronized;
+	static bool synchronize_cpus_initiated;
+	static bool snp_decommission_handled;
+	static atomic_t cpus_synchronized;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	/*
+	 * SNP_SHUTDOWN_EX fails when SNP VMs are active as the firmware checks
+	 * every encryption-capable ASID to verify that it is not in use by a
+	 * guest and a DF_FLUSH is not required. If a DF_FLUSH is required,
+	 * the firmware returns DFFLUSH_REQUIRED. To address this, SNP_DECOMMISSION
+	 * is required to shutdown all active SNP VMs, but SNP_DECOMMISSION tags all
+	 * CPUs that guest was activated on to do a WBINVD. When panic notifier
+	 * is invoked all other CPUs have already been shutdown, so it is not
+	 * possible to do a wbinvd_on_all_cpus() after SNP_DECOMMISSION has been
+	 * executed. This eventually causes SNP_SHUTDOWN_EX to fail after
+	 * SNP_DECOMMISSION. To fix this, do SNP_DECOMMISSION and subsequent WBINVD
+	 * on all CPUs during NMI shutdown of CPUs as part of disabling
+	 * virtualization on all CPUs via cpu_emergency_disable_virtualization().
+	 */
+
+	spin_lock(&snp_decommission_lock);
+
+	/*
+	 * exit early for call from native_machine_crash_shutdown()
+	 * as SNP_DECOMMISSION has already been done as part of
+	 * NMI shutdown of the CPUs.
+	 */
+	if (snp_decommission_handled) {
+		spin_unlock(&snp_decommission_lock);
+		return;
+	}
+
+	/*
+	 * Synchronize all CPUs handling NMI before issuing
+	 * SNP_DECOMMISSION.
+	 */
+	if (!synchronize_cpus_initiated) {
+		/*
+		 * one CPU handling panic, the other CPU is initiator for
+		 * CPU synchronization.
+		 */
+		atomic_set(&waiting_for_cpus_synchronized, num_online_cpus() - 2);
+		synchronize_cpus_initiated = true;
+		/*
+		 * Ensure CPU synchronization parameters are setup before dropping
+		 * the lock to let other CPUs continue to reach synchronization.
+		 */
+		wmb();
+
+		spin_unlock(&snp_decommission_lock);
+
+		/*
+		 * This will not cause system to hang forever as the CPU
+		 * handling panic waits for maximum one second for
+		 * other CPUs to stop in nmi_shootdown_cpus().
+		 */
+		while (atomic_read(&waiting_for_cpus_synchronized) > 0)
+		       mdelay(1);
+
+		/* Reacquire the lock once CPUs are synchronized */
+		spin_lock(&snp_decommission_lock);
+
+		atomic_set(&cpus_synchronized, 1);
+	} else {
+		atomic_dec(&waiting_for_cpus_synchronized);
+		/*
+		 * drop the lock to let other CPUs contiune to reach
+		 * synchronization.
+		 */
+		spin_unlock(&snp_decommission_lock);
+
+		while (atomic_read(&cpus_synchronized) == 0)
+		       mdelay(1);
+
+		/* Try to re-acquire lock after CPUs are synchronized */
+		spin_lock(&snp_decommission_lock);
+	}
+
+	if (!snp_decommission_handled) {
+		__snp_decommission_all();
+		snp_decommission_handled = true;
+	}
+	spin_unlock(&snp_decommission_lock);
+	wbinvd();
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -3052,6 +3175,13 @@ void __init sev_hardware_setup(void)
 	sev_es_supported = true;
 	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
+	if (sev_snp_supported) {
+		snp_asid_to_gctx_pages_map = kmalloc_array(min_sev_asid,
+							   sizeof(void *),
+							   GFP_KERNEL | __GFP_ZERO);
+		if (!snp_asid_to_gctx_pages_map)
+			pr_warn("Could not allocate SNP asid to guest context map\n");
+	}
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
@@ -3094,6 +3224,9 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	kfree(snp_asid_to_gctx_pages_map);
+	snp_asid_to_gctx_pages_map = NULL;
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ecf4303422ed..899f4481107c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -597,6 +597,8 @@ static void svm_emergency_disable(void)
 	kvm_rebooting = true;
 
 	kvm_cpu_svm_disable();
+
+	sev_emergency_disable();
 }
 
 static void svm_hardware_disable(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..644101327c19 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -763,6 +763,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+void sev_emergency_disable(void);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -793,7 +794,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
-
+static void sev_emergency_disable(void) {}
 #endif
 
 /* vmenter.S */
-- 
2.34.1


