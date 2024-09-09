Return-Path: <kvm+bounces-26170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 471FB9725C3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85152B23665
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D0E18E020;
	Mon,  9 Sep 2024 23:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EIWXrXCV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF377130495;
	Mon,  9 Sep 2024 23:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924865; cv=fail; b=K+zje3xxB1FCglv+x0yRMfRZ+/9qgZUU4zvA+PQPJtn0SDaFiWFnxfbcMZ1nq1SMkx57K1QjaPI2tMBjqSYmzSxDy06pXhMoS/IUGg9hx0JsICX89tevk3npKzxOZz7wkFEwZNXVLs7zi0ZkbCB4SCCqFPcpLSWv0O3AcdNWBOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924865; c=relaxed/simple;
	bh=9LHbQcJlkEQtAZLr04POOHw4T7/Gj8aQt20/q1yVGKw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTyz67CzKrA0FzkP5PEo5iKSl6yQzcb3yoyfpS+zuaOWkH1BjVz1uuBNU7VA3jRS4X2tk9n+k+Pyv+ae/9PQQlgxwmKYu2t5tVWd0mHzVlyc1oETTMzzmhhlkkYot52HJaYASRR1PQ46EOahGxhQMVKTsSZT/tFB8XL9vvfS9ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EIWXrXCV; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GhtSe76ifTYwPK8L4RppQ/vr8gWALomQVLYPa20RT0LoRd6H6QqqyMcdi1VRQNSBHI+AlCcjQuHsFuWRK22xVo5WS2XCbYEkBXVugzscBX1ninVbk6wr1mxhrF5EIbWvhyV5NTbhHNx18s/ir1xp+GQ5Q7iFYk1icDbLIWQmHQhYHhcGYNS7QRJCUPRgh+e6IdEa6+NmnhS5X54+4HMJNpMDYRklq5V+BfGEYdIngKWHowdfUtEGcRPIXdAxj06EPSf4Pfe20hUAQjDBDvBs7PF+XekC+wGwZHSeCMYpiVF90nADBYzxMVofEuAakngm3ZXBrs84IatTOJrHn2uD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IvNxHOyaPNa7dODJ0V0986Ug1mueN+mziud9Fesnug=;
 b=Q755r7Z/QVWptIqZ9noqOXq/NIRYtdHYfd8Jjd6HeoabeUVi2Y7T++i3CJGK2EpnYR459gAFbA5GRaxMpMO/EXnnitRF+Jf4bbTHHOZsBMy7Nf10agJi6YlIiaWDYXiQKHecuK3vMqmam4bkTMI+1fkuzS8WT0o4MYknu/VgqVnXUWh63Vo6ghnR5KdGJ/U6KZIGt1RZp+0eOD/7Bz9Vlwpu/DweTpCZpPoxBysbTMlcdir80kW5m5tWzKelA34d98vkxDIA3EGVYSRRWo5uv52nxuNJhkIsqxN8i44sItt1CtoHg3a3cMaMyk1KzZjCERDYHrz9FB22s6Fd5b9YMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IvNxHOyaPNa7dODJ0V0986Ug1mueN+mziud9Fesnug=;
 b=EIWXrXCVV5O3ua84/9vFlqXE4JFTtreBl4Bw33nq8PNzNRfByjVqf8bSlImZySLgDyCI/o8aDOeRF/JHPj6Z1U6Z186tF4jc6ty3aWJpAdAMro/XYfTrCJt/8aZ/LA095lXz3136l53seWcxCM98ZHSa4NVxok3ae8Z9vB8ZfU0=
Received: from CH0PR03CA0367.namprd03.prod.outlook.com (2603:10b6:610:119::24)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 23:34:18 +0000
Received: from CH2PEPF00000144.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::71) by CH0PR03CA0367.outlook.office365.com
 (2603:10b6:610:119::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Mon, 9 Sep 2024 23:34:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH2PEPF00000144.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Mon, 9 Sep 2024 23:34:16 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Sep
 2024 18:34:15 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <ashish.kalra@amd.com>
CC: <bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Date: Mon, 9 Sep 2024 23:33:32 +0000
Message-ID: <20240909233332.4779-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240906202757.5258-1-Ashish.Kalra@amd.com>
References: <20240906202757.5258-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000144:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: 4905275f-5a5f-48b8-ad74-08dcd127eb47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9V6HrtXt2u0oWhDfNpJEWzxxHwp/LQB7YKVqro3o55cCFECI0YPmcdgKyQfH?=
 =?us-ascii?Q?2yHrKe8F6fngH/I+6bq20jpZTAWpu/mlywp+quuPbGwTiWIgSyWXb29JQBdd?=
 =?us-ascii?Q?8gzpUTqj/1ve+kNpc3aKrToN+VHhPQF3kctADfanX89OUG3KXg7l96cUc2Wr?=
 =?us-ascii?Q?eChrZtriuxhKkp/TeIW0uxg5/DwahFtbA6hjQbpggRsMXPpU1jkvLzj+pOGM?=
 =?us-ascii?Q?RBKSa/lIHXMv4nTFlBnrBu1Xnx6R6CPCdyXkFPsxM5kYKBl7Sw3rQTJObrwq?=
 =?us-ascii?Q?v7TgaW4+72OYiCHOfhkiVEvnkHmC3pHy35ufP4X2klBSaPORYjxSptQo8nth?=
 =?us-ascii?Q?edQ4Osl1R9w/o7Jn4YjSIF53GbqCgeEdABdAxaaFTKcSeLYxMRh9nhD/acYv?=
 =?us-ascii?Q?uxzKfjWxhwYczXB2GWtp2I79R1LmBv4Rp0CoqfH6QTNSBmu1hSfy9oM4vLPN?=
 =?us-ascii?Q?+kXhZhCV2qqRRYnX/HhY/x1J10JBs39al3RjKaijjVC03RmXxrnRl5COr0sl?=
 =?us-ascii?Q?6CVzKZJCRTRZYhGS2Y3d2YtnHpIcAKRBN3GsRlpbGQXurX8qvLej/B6gevGy?=
 =?us-ascii?Q?akYHfg34QsKbTS2Fr2a1eO6gVLyVWNkOzuFgpYPBuQBgIn7SWTi+TaZhjURU?=
 =?us-ascii?Q?J3+9Bs7sHjQpPMH3F4L+Ytjz2aml/oDxrPf7n1F+0qM3ZnMvMx8lEwD4rqUP?=
 =?us-ascii?Q?MEq0TTemMn3oj+j84TMv/FqWX6odoqkAqoigGDmn+mEAVGHteK60fPkih2xH?=
 =?us-ascii?Q?tVzPaYToo79vzOjP3z0j01zdnh8xzuH1WMbN48J7cZki/vdNEhzd7KuXAuPi?=
 =?us-ascii?Q?A4xexInQRmPu6yz9ouHjzFvEkcLsuWmCsKgPDI0dDctcftI6BhYuz1uxMGsJ?=
 =?us-ascii?Q?QBF+2JiGQfRoZxn7hvc6rvFMs0+IFfVf5dChcJzCkSbOlcOgnfBpjbL27oe5?=
 =?us-ascii?Q?Rmh3G/VXhMpYX+WtwTes80wsJvHB3tPm3peoZi+IMZRdtn3uhKlnJTDUOz1V?=
 =?us-ascii?Q?D4CakxjTCo9YNSkMjqJVYW12IYEkmMc3AVblw1jkC11dGCanxE0q8j32+yW4?=
 =?us-ascii?Q?4Bvdxha+LZ/KPyYqFrTGt+R8M5ulW50iHjqzEsLOtCbAsfFxr4JuIPr9E++c?=
 =?us-ascii?Q?I5pR06FcosOlY3jsIJ+yEsmhOacocDav9Mpru5IAZT8ifJcZyJ4+FcOwFTM3?=
 =?us-ascii?Q?8lH4ixEQfmoUuG82TTPNN8eZUDXAdq6OiEA4z92eJSTW5iFjaJMy9pWhdase?=
 =?us-ascii?Q?KhuLyxI5xHHb3PFQijeywhrm337dUSofpjjmHYZysH609sH0XGt8MMuPnSra?=
 =?us-ascii?Q?vmGqR9LdG940UD63eMGYce2ZRFBlK/T+JkoOZuaM0V2NENXih4OXtqnlPgyo?=
 =?us-ascii?Q?p7bQ6qUfvf900yc0gs9PJtNztlg2x0CjMbGkLikVe1R+xuDGGvFq6CaCPlu9?=
 =?us-ascii?Q?7Qx0krkiTJdE8ESHF4sAmTRJ9CUWT1Wy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 23:34:16.0103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4905275f-5a5f-48b8-ad74-08dcd127eb47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000144.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136

Hello Sean,

On 9/4/2024 5:23 PM, Sean Christopherson wrote:
>> On Wed, Sep 04, 2024, Ashish Kalra wrote:
>>> On 9/4/2024 2:54 PM, Michael Roth wrote:
>>>>   - Sean inquired about making the target kdump kernel more agnostic to
>>>>     whether or not SNP_SHUTDOWN was done properly, since that might
>>>>     allow for capturing state even for edge cases where we can't go
>>>>     through the normal cleanup path. I mentioned we'd tried this to some
>>>>     degree but hit issues with the IOMMU, and when working around that
>>>>     there was another issue but I don't quite recall the specifics.
>>>>     Can you post a quick recap of what the issues are with that approach
>>>>     so we can determine whether or not this is still an option?
>>>
>>> Yes, i believe without SNP_SHUTDOWN, early_enable_iommus() configure the
>>> IOMMUs into an IRQ remapping configuration causing the crash in
>>> io_apic.c::check_timer().
>>>
>>> It looks like in this case, we enable IRQ remapping configuration *earlier*
>>> than when it needs to be enabled and which causes the panic as indicated:
>>>
>>> EMERGENCY [    1.376701] Kernel panic - not syncing: timer doesn't work
>>> through Interrupt-remapped IO-APIC
>>
>> I assume the problem is that IOMMU setup fails in the kdump kernel, not that it
>> does the setup earlier.  That's that part I want to understand.

>Here is a deeper understanding of this issue:

>It looks like this is happening: when we do SNP_SHUTDOWN without IOMMU_SNP_SHUTDOWN during panic, kdump boot runs with iommu snp 
>enforcement still enabled and IOMMU completion wait buffers (cwb) still locked and exclusivity still setup on those, and then in 
>kdump boot, we allocate new iommu completion wait buffers and try to use them, but we get a iommu command completion wait time-out,
>due to the locked in (prev) completion wait buffers, the newly allocated completion wait buffers are not getting used for iommu 
>command execution and completion indication :

>[    1.711588] AMD-Vi: early_amd_iommu_init: irq remaping enabled
>[    1.718972] AMD-Vi: in early_enable_iommus
>[    1.723543] AMD-Vi: Translation is already enabled - trying to copy translation structures
>[    1.733333] AMD-Vi: Copied DEV table from previous kernel.
>[    1.739566] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.11.0-rc6-next-20240903-snp-host-f2a41ff576cc+ #78
>[    1.750920] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM100AB 10/17/2022
>[    1.759950] Call Trace:
>[    1.762677]  <TASK>
>[    1.765018]  dump_stack_lvl+0x70/0x90
>[    1.769109]  dump_stack+0x14/0x20
>[    1.772809]  iommu_completion_wait.part.0.isra.0+0x38/0x140
>[    1.779035]  amd_iommu_flush_all_caches+0xa3/0x240
>[    1.784383]  ? memcpy_toio+0x25/0xc0
>[    1.788372]  early_enable_iommus+0x151/0x880
>[    1.793140]  state_next+0xe67/0x22b0
>[    1.797130]  ? __raw_callee_save___native_queued_spin_unlock+0x19/0x30
>[    1.804421]  amd_iommu_enable+0x24/0x60
>[    1.808702]  irq_remapping_enable+0x1f/0x50
>[    1.813371]  enable_IR_x2apic+0x155/0x260
>[    1.817848]  x86_64_probe_apic+0x13/0x70
>[    1.822226]  apic_intr_mode_init+0x39/0xf0
>[    1.826799]  x86_late_time_init+0x28/0x40
>[    1.831266]  start_kernel+0x6ad/0xb50
>[    1.835436]  x86_64_start_reservations+0x1c/0x30
>[    1.840591]  x86_64_start_kernel+0xbf/0x110
>[    1.845256]  ? setup_ghcb+0x12/0x130
>[    1.849247]  common_startup_64+0x13e/0x141
>[    1.853821]  </TASK>
>[    2.077901] AMD-Vi: Completion-Wait loop timed out
>...

>And because of this the iommu command, in this case which is for enabling irq remapping does not succeed and that eventually causes 
>timer to fail without irq remapping support enabled.

>Once IOMMU SNP support is enabled, to enforce RMP enforcement the IOMMU completion wait buffers are setup as read-only and 
>exclusivity set on these and additionally the IOMMU registers used to mark the exclusivity on the store addresses associated with 
>these CWB is also locked. This enforcement of SNP in the IOMMU is only disabled with the IOMMU_SNP_SHUTDOWN parameter with 
>SNP_SHUTDOWN_EX command.

>From the AMD IOMMU specifications:

>2.12.2.2 SEV-SNP COMPLETION_WAIT Store Restrictions On systems that are SNP-enabled, the store address associated with any host 
>COMPLETION_WAIT command (s=1) is restricted. The Store Address must fall within the address range specified by the Completion Store 
>Base and Completion Store Limit registers. When the system is SNP-enabled, the memory within this range will be marked in the RMP 
>using a special immutable state by the PSP. This memory region will be readable by the CPU but not writable.

>2.12.2.3 SEV-SNP Exclusion Range Restrictions The exclusion range feature is not supported on systems that are SNP-enabled. 
>Additionally, the Exclusion Base and Exclusion Range Limit registers are re-purposed to act as the Completion Store Base and Limit 
>registers.

>Therefore, we need to disable IOMMU SNP enforcement with SNP_SHUTDOWN_EX command before the kdump kernel starts booting as we can't 
>setup IOMMU CWB again in kdump as SEV-SNP exclusion base and range limit registers are locked as IOMMU SNP support is still enabled.

>I tried to use the previous kernel's CWB (cmd_sem) as below: 

>static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>{
>        if (!is_kdump_kernel())
>                iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
>        else {
>                if (check_feature(FEATURE_SNP)) {
>                        u64 cwwb_sem_paddr;
>
>                        cwwb_sem_paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET);
>                        iommu->cmd_sem = iommu_phys_to_virt(cwwb_sem_paddr);
>        		return iommu->cmd_sem ? 0 : -ENOMEM;
>                }
>        }
>
>        return iommu->cmd_sem ? 0 : -ENOMEM;
>}

>I tried this, but this fails as i believe the kdump kernel will not have these previous kernel's allocated IOMMU CWB in the kernel 
>direct map : 

>[    1.708959] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.714327] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x100805000, cmd_sem_vaddr 0xffff9f5340805000
>[    1.726309] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.731676] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x1050051000, cmd_sem_vaddr 0xffff9f6290051000
>[    1.743742] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.749109] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x1050052000, cmd_sem_vaddr 0xffff9f6290052000
>[    1.761177] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.766542] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x100808000, cmd_sem_vaddr 0xffff9f5340808000
>[    1.778509] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.783877] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x1050053000, cmd_sem_vaddr 0xffff9f6290053000
>[    1.795942] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.801300] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x100809000, cmd_sem_vaddr 0xffff9f5340809000
>[    1.813268] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.818636] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x1050054000, cmd_sem_vaddr 0xffff9f6290054000
>[    1.830701] AMD-Vi: in alloc_cwwb_sem kdump kernel
>[    1.836069] AMD-Vi: in alloc_cwwb_sem SNP feature enabled, cmd_sem_paddr 0x10080a000, cmd_sem_vaddr 0xffff9f534080a000
>[    1.848039] AMD-Vi: early_amd_iommu_init: irq remaping enabled
>[    1.855431] AMD-Vi: in early_enable_iommus
>[    1.860032] AMD-Vi: Translation is already enabled - trying to copy translation structures
>[    1.869812] AMD-Vi: Copied DEV table from previous kernel.
>[    1.875958] AMD-Vi: in build_completion_wait, paddr = 0x100805000
>[    1.882766] BUG: unable to handle page fault for address: ffff9f5340805000
>[    1.890441] #PF: supervisor read access in kernel mode
>[    1.896177] #PF: error_code(0x0000) - not-present page

>....

>I think that memremap(..,..,MEMREMAP_WB) will also fail for the same reason as memremap(.., MEMREMAP_WB) for the RAM region will 
>again use the kernel directmap.

To follow up on this:

I am able to use memremap() to map the previous kernel's allocated CWB buffers and try to reuse the same CWB buffers in the
kdump kernel, obviously, memremap() does not return a direct pointer to kernel directmap as the previous kernel's CWB buffers 
will be in a RAM address which is not directly mapped into kdump kernel's directmap.
 
And these memremap() mappings seem to be correct, because if i do a memset(0) on these, i get a RMP #PF violation due
to these buffers being setup as RO in the RMP table, so that means that memremap() seems to have done the mapping correctly.

I am getting inconsistent IOMMU command completion wait timeout's with these reused CWB buffers (which are used as
semaphores to indicate IOMMU command completions) and i am still debugging those issues.

Thanks,
Ashish

