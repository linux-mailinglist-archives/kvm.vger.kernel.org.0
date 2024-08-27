Return-Path: <kvm+bounces-25200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A3E96189A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F372284C36
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F87D1C8FC4;
	Tue, 27 Aug 2024 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mxVRi+so"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F86E537F5;
	Tue, 27 Aug 2024 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724791104; cv=fail; b=iLcsVvMn4DvfnO9N89ciZRmlkIl/RxVWtu8VE6QWPnahKOernepFQlQxctnH8ezAub5Wqis9S5tv2Md3whxS+NTDiMbhr/7VlcYfBRAhAnIvaCBCLre++/sCytG71u7tCsyVGPb4tpPaQzyAskO4McqkImUJmGoYeDKKgAiwR7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724791104; c=relaxed/simple;
	bh=/bxEs4/Mre1eJvxb9LDSGEN5wRbX2IjQ4ct16BrMG/Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vEGPgfIWglvRVmi4wV0b1kLp9XrkBySC7ZCShLILewc2zufDVy6pDLlerrkHG+1zJNygTz/dk9aJq+d9Bv6B1gx3w4OYKH6T1FknE/e0tqy1m5oJu/UUngHLoXqS5TI5Jzp2UW3gqqo2sQxNZ58Gm7IMddouk39RXJjpuToWjhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mxVRi+so; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NE3mlBVad/jjg0xBP88DXSpGsdq7wyqxga0ro3mvFrhT9n+mpczoaY2aX/kpRPat/vQQZjsDMxizYvqbW3GY9aPUvZ1jwG6InJ2zGYiX5wZhO6jQsXn2Ty/LmwmpM5XNTuqfZvw8lz3BoMdm+KUhyoMUW9+PYjJRLJRHsZur1DXLJ+5jbIQGISgxf3m5HgsHWt8zndqAjAwQFgjGs4Um7k5VgtpvfVGiq0jrY4gLfOJrk4OCOZAFjws5diOfPwrHNhs5IhJIAlXRsrQ5WzXQv4z2Z1HEtSc9xgafFQuel2hoChULOnxQ1fFxQvhugm+whpRwCMmPd/a1Tc/1tAitXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fl096LLw+ONomYqKEJnIBksMtwlNK1ZuvoEdAlXorsM=;
 b=TI6YE6CI+2J4ZKAvclWGLJ1ZfnBKxeq5I6bmpacW3Zk9xNpVgNu1ifqrvMjNbwv64pa8FGj5yDFKNfd4uwWOQnekBwQZLlVpYJ3aCfe0QSgOwPO2xmH7Irymp4DiGplmvXYqH/NZnPT5b4TxHeWw1797sVy5IfAdAnipCLpSE5pyROWHquHB8McT1j1AlbUshcleimBuYlTEoECf7DS2jMnpLTf5N/Njhwa6nj7n8bWD/5PPook3ILYHfgMZEm7VAMnhYBQtJt8HJqP+msSCCXi1KIibWNE+zQvNpWwx26Gc0Uic0EE0HzMRnBepZfySLkIlaBfdbigNvfgZs5RVhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fl096LLw+ONomYqKEJnIBksMtwlNK1ZuvoEdAlXorsM=;
 b=mxVRi+sov7sw3cdnIT/ph9i5gY4jCEDxoPp/wPHboG1hrF7Ca4+rCuIIY4q9dYbMzzob0Y//ApH/EvMrMO20gDhkeg8qkUP0uQeikpSwXfuVeJRTWsfDKcbMa+qp6qaKKrgdMKd68HsscXtDHvZXpr6DqsDr06DpfwUkKeZrjQc=
Received: from SA0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:806:130::7)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 20:38:15 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::80) by SA0PR13CA0002.outlook.office365.com
 (2603:10b6:806:130::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.16 via Frontend
 Transport; Tue, 27 Aug 2024 20:38:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 20:38:15 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 15:38:14 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@linux.intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>
CC: <hpa@zytor.com>, <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
	<kexec@lists.infradead.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH] x86/sev: Fix host kdump support for SNP
Date: Tue, 27 Aug 2024 20:38:04 +0000
Message-ID: <20240827203804.4989-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: d8d706bd-c981-484d-2f45-08dcc6d82d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AHjkn0ihVg1ePGjVqao76zDKwuN4FJK4LXaViPRPaf5qaNqIAwaYVkk/fSyY?=
 =?us-ascii?Q?jkpDlpTnPdh5EHZ7OxbRgCNj/31xPYXxOL0Dz6gL14VKtOh4fC12k/ZTtMMf?=
 =?us-ascii?Q?EwtRisqfLIfsyudYDpizYlZm5V+qTMY3OoB39f0+rlN5yIjnH4IdnfE+21Uq?=
 =?us-ascii?Q?VuhoPy0SY/0epMN/doVnLca5mcLQIseDzcv2x+TQpKZIpho4fkuyr8Ez5WJG?=
 =?us-ascii?Q?4dg2BxYO0P4/dZ8NljTjPsKThgTbWbWWmEjL2WdJ1ytE+aW9oxH9RSgDQnKC?=
 =?us-ascii?Q?KhQTAKpRYfdkpHRxoVyjCHh7YMbacARqVGPxZmQY69iMURXAduRiMPUePSQg?=
 =?us-ascii?Q?cPntY8Um+VcEWoYec08ODzXMWjD2D4gPOMRZ52d+sh4upN141YqJSqNvMTeG?=
 =?us-ascii?Q?F4RfyH9mr/WDD/x88cpe7QrGcW2wqZsHOSPhs0foCjp/evAiQ42DQzygjV14?=
 =?us-ascii?Q?NENGFElBg62vfIQiMzAENyBnx+00/VJvrvbfMIaHVRjqe9focIXM014GubW4?=
 =?us-ascii?Q?UDVffOMv7NIHXbHGeoSHWGGpiIzz+/5WaZU28aPc3j/TIz6af+Ihei2GfTHO?=
 =?us-ascii?Q?5EthcDDaPA+sX8Wmol6f1c0fxlEFYFl/KNI0OzB9/cmROFgyx6L6w8oOz+kt?=
 =?us-ascii?Q?C0GCrhynOYYR3jTiRVgtOMNcbW56xkdjfx4XKQzhRjwYzfzEfyB6UZK4hYE1?=
 =?us-ascii?Q?NbgKnH+ZLxe3celHtw9+10BBM+tbkATfzCTqcxQpnk82AkN+Lq8I1DTtt5dY?=
 =?us-ascii?Q?1A8hD/H7FP9lGPLToW6C2DlmugCQPDnvTosQFjG8v4SxALdJA0t/5uAn/7P8?=
 =?us-ascii?Q?HDLlpISEEqPlf1ZMY9WpgACjZcPCbm4IA9UNmMeTZ9aupBMMJ+btwUuBmSzP?=
 =?us-ascii?Q?4dEHCYXAgjTZ44bKmju16cSUXB8b5H50ih6Yy0m2XY1++XmUcyt+cf2CT4pl?=
 =?us-ascii?Q?EIKaW15egYucIfnSDkFD6arIUiOPO013eS9iuRmXYlePe3xcYf6hFI39lt+W?=
 =?us-ascii?Q?19g7bX0Vbh4iYQzORe5p/PIbO27wuTc8wZ/kQ/FGKjfNfW2bAlo10dzIOz3w?=
 =?us-ascii?Q?WW68r9+NxzxeqwS+fu/QiwlcctLMtf280iZFLcKU2Y+S5LQYRlUBgmrr9Oau?=
 =?us-ascii?Q?wtA5iH8ILW+zptDHzX4TWmQo3zxmJ4eGTeLod6y9rup43aPMby+RKylzp16Y?=
 =?us-ascii?Q?1wqyAOgnSax0gfwQeT85GgdIDwuzCHIXJ9T/QcmQSz9k8ikFpausbGtJFEhS?=
 =?us-ascii?Q?S1EkRqWABZKc4e3LnbOswaPRaXPDdAKpzb87UD1pvY9weeF8VwHXC94Lpqt6?=
 =?us-ascii?Q?fwr5TFMSEPJIyT8A/Ka8TKZMM+E0ueOPxOpchBzjyE7X3nDtddz34VBMbDQS?=
 =?us-ascii?Q?rrzgimQJnFj90MfJDdEvJCsfE2uHWSCNJfF0CNsB4yAHLom8p4aimeN5AtlB?=
 =?us-ascii?Q?EbLzeuBIIZy9Gr9OEiOnltZa/nYUqCeI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 20:38:15.4164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d706bd-c981-484d-2f45-08dcc6d82d4e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

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
[  564.282209] in snp_shutdown_on_panic after decommision, wbinvd + df_flush required
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

To fix this, added support to do SNP_DECOMMISION of all active SNP VMs
in the panic notifier before doing SNP_SHUTDOWN_EX, but then
SNP_DECOMMISION tags all CPUs on which guest has been activated to do
a WBINVD. This causes SNP_DF_FLUSH command failure with the following
flow: SNP_DECOMMISION -> SNP_SHUTDOWN_EX -> SNP_DF_FLUSH ->
failure with WBINVD_REQUIRED.

When panic notifier is invoked all other CPUs have already been
shutdown, so it is not possible to do a wbinvd_on_all_cpus() after
SNP_DECOMMISION has been executed. This eventually causes SNP_SHUTDOWN_EX
to fail after SNP_DECOMMISION.

Adding fix to do SNP_DECOMMISION and subsequent WBINVD on all CPUs
during NMI shutdown of CPUs as part of disabling virtualization on
all CPUs via cpu_emergency_disable_virtualization ->
svm_emergency_disable().

This fixes and enables crashkernel/kdump on SNP host.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 91 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  3 +-
 3 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0b851ef937f2..34ddea43c4e6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -89,6 +89,7 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static void **snp_asid_to_gctx_pages_map;
 static int snp_decommission_context(struct kvm *kvm);
 
 struct enc_region {
@@ -2248,6 +2249,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free_context;
 	}
 
+	if (snp_asid_to_gctx_pages_map)
+		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = sev->snp_context;
+
 	return 0;
 
 e_free_context:
@@ -2884,9 +2888,35 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	if (snp_asid_to_gctx_pages_map)
+		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = NULL;
+
 	return 0;
 }
 
+/*
+ * NOTE: called in NMI context from sev_emergency_disable().
+ */
+void snp_decommision_all(void)
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
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -3052,6 +3082,13 @@ void __init sev_hardware_setup(void)
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
@@ -3094,6 +3131,8 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	kfree(snp_asid_to_gctx_pages_map);
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e13c54d93964..a8f64a1710c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/amd-iommu.h>
 #include <linux/sched.h>
+#include <linux/delay.h>
 #include <linux/trace_events.h>
 #include <linux/slab.h>
 #include <linux/hashtable.h>
@@ -248,6 +249,8 @@ static unsigned long iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
+static DEFINE_SPINLOCK(snp_decommision_lock);
+
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
  * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
@@ -594,9 +597,97 @@ static inline void kvm_cpu_svm_disable(void)
 
 static void svm_emergency_disable(void)
 {
+	static atomic_t waiting_for_cpus_synchronized;
+	static bool synchronize_cpus_initiated;
+	static bool snp_decommision_handled;
+	static atomic_t cpus_synchronized;
+
 	kvm_rebooting = true;
 
 	kvm_cpu_svm_disable();
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	/*
+	 * SNP_SHUTDOWN_EX fails when SNP VMs are active as the firmware checks
+	 * every encryption-capable ASID to verify that it is not in use by a
+	 * guest and a DF_FLUSH is not required. If a DF_FLUSH is required,
+	 * the firmware returns DFFLUSH_REQUIRED. To address this, SNP_DECOMMISION
+	 * is required to shutdown all active SNP VMs, but SNP_DECOMMISION tags all
+	 * CPUs that guest was activated on to do a WBINVD. When panic notifier
+	 * is invoked all other CPUs have already been shutdown, so it is not
+	 * possible to do a wbinvd_on_all_cpus() after SNP_DECOMMISION has been
+	 * executed. This eventually causes SNP_SHUTDOWN_EX to fail after
+	 * SNP_DECOMMISION. To fix this, do SNP_DECOMMISION and subsequent WBINVD
+	 * on all CPUs during NMI shutdown of CPUs as part of disabling
+	 * virtualization on all CPUs via cpu_emergency_disable_virtualization().
+	 */
+
+	spin_lock(&snp_decommision_lock);
+
+	/*
+	 * exit early for call from native_machine_crash_shutdown()
+	 * as SNP_DECOMMISSION has already been done as part of
+	 * NMI shutdown of the CPUs.
+	 */
+	if (snp_decommision_handled) {
+		spin_unlock(&snp_decommision_lock);
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
+		spin_unlock(&snp_decommision_lock);
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
+		spin_lock(&snp_decommision_lock);
+
+		atomic_set(&cpus_synchronized, 1);
+	} else {
+		atomic_dec(&waiting_for_cpus_synchronized);
+		/*
+		 * drop the lock to let other CPUs contiune to reach
+		 * synchronization.
+		 */
+		spin_unlock(&snp_decommision_lock);
+
+		while (atomic_read(&cpus_synchronized) == 0)
+		       mdelay(1);
+
+		/* Try to re-acquire lock after CPUs are synchronized */
+		spin_lock(&snp_decommision_lock);
+	}
+
+	if (!snp_decommision_handled) {
+		snp_decommision_all();
+		snp_decommision_handled = true;
+	}
+	spin_unlock(&snp_decommision_lock);
+	wbinvd();
 }
 
 static void svm_hardware_disable(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..2f933b941b8d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -749,6 +749,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+void snp_decommision_all(void);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -779,7 +780,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
-
+static void snp_decommision_all(void);
 #endif
 
 /* vmenter.S */
-- 
2.34.1


