Return-Path: <kvm+bounces-26773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C101A97743A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 00:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 856BB286524
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787F81C243E;
	Thu, 12 Sep 2024 22:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oyCu6NF/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE26E18EFDB;
	Thu, 12 Sep 2024 22:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726179504; cv=fail; b=qKcL4i+cXgJQjj2GNLwyd51YjbMxMhq768Zr+kFf+lYimMe+W3ak642IOkT0nof0Mmoh48Qo6AYBQuaKkQeKpDD84t2crGE49Hm/QLsjo0jvR4F5MqZjqeTpdpf2y1nVppoQ22f4qLuXTrAk6EweEu2EfGtww7XLiyskp3FpWMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726179504; c=relaxed/simple;
	bh=qyI9Pot2SDyqji3qI+DH8xCaflQTq0m6per3F3IMbUw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQiN2EMGz7v3kKCxLO4+32WakHiGZ+20MCKsPqZP8g85DLZkW5wwdaUvw1gSNW8ZBmyyX92sLt0Qcf7542REY6ltg8+OIV8An2kHeyvHysvjGarCjEbqsbdP5wc8cxa0A1/e9QkFu0xce41qd43zwnBcU3k5VoLApdQBOzdb4Vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oyCu6NF/; arc=fail smtp.client-ip=40.107.95.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBefwbgjGiaGbTdtnq68npmSekh2d/yZCjK4FEpcK4bIFm8J1CNCAtD7TEWbp1fpQRJCMhEj7dOMAjoYUzNzrCOfrtMjE8p903LqMjA6z8X/2IDEu1Mie8y+/28757Owy2GgZxRiJS9UaLLwjCrnwUsDXJzEDt4qW424TTWs2ySEkqSzl7yy7BwiZPDSBsxiYj6ncie8IGS4p4T1Xw8T+KH8ecLcSkQIgY74EC3DHtc2PqkXd9DO+vp5Q/ARN3WS5QiCW1Wpn/4l1e70JZQVBEzEUgh+/AfLXizsM7OeI+cfU2vrPNJCEWRkw9MPCtQM0FZNCG9mh+t162ettVDNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIVitQjRsAGXejK1D6ZKS8T1atXuSuboDCbl2N4CvOM=;
 b=QfOpIb5ntlp8DBoz0+B6tlECkPApLN+jKmI2vJB56JfLUbI4b7NxRGsiyoMhygIdCIuPFZvkqIl522c4UDfrxMOrPg/zgHcmI2OFF6sHMtRq/LmADvaTZ7pgHP51lLAx78upMcB/S/x+VVgw8mBnF53v5I4C7yFDs0XPDlHHXLxUSosO9szI6yce2xXKN+uX+1nb/u8Afxm7AM/4W6SJp5ievYKaAYsn0SgMKFeWQoyTX/zwpgbTwNO34NgQHMllXUqKVBPLwHExi9Oxprr9PDSmADE4ZUG02kfqCY9IKuDXxpyL8vu8vXE8rdKjMlDUt+lSE/pUIx5qdG0OO2ml8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIVitQjRsAGXejK1D6ZKS8T1atXuSuboDCbl2N4CvOM=;
 b=oyCu6NF/5wVw6V0ju3skHst7eF6QKctzOLYcFRSy5zDA6lsNF+/yB026UmMZCL8sKwUhzTNdEbeKx7+plXB98IxoYMoZ1o5D9ghE+ShqbzW5tLYDjB/lT1jsCLr1mizzvbgb4uAsi15+Uz4l15JlsPL3n/GHAZAdJayq40ZxTuI=
Received: from BN7PR02CA0012.namprd02.prod.outlook.com (2603:10b6:408:20::25)
 by DS0PR12MB7779.namprd12.prod.outlook.com (2603:10b6:8:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Thu, 12 Sep
 2024 22:18:15 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:20:cafe::b0) by BN7PR02CA0012.outlook.office365.com
 (2603:10b6:408:20::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Thu, 12 Sep 2024 22:18:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 22:18:15 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Sep
 2024 17:18:13 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <ashish.kalra@amd.com>
CC: <bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Date: Thu, 12 Sep 2024 22:18:02 +0000
Message-ID: <20240912221802.4791-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240909233332.4779-1-Ashish.Kalra@amd.com>
References: <20240909233332.4779-1-Ashish.Kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|DS0PR12MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: a76a8ce5-d28b-4e2d-2398-08dcd378cc23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzVmajlmaWZEYmNpbXo4dlpCWC95QXlQMVlCcGFHL1ZZQkQ2K0psR2JDeUdi?=
 =?utf-8?B?MnB0b1BQYU5EdjZDMnBvYkpVYzdvMjFPbjJNUjhNL1FYYnV1SzFHNmxxS0lE?=
 =?utf-8?B?NU1vQ0srdFlwbVlvTmF6ZXdXLzgremhGZDRjT2VRdmRRSEd1UXcrY0REUElo?=
 =?utf-8?B?bXdOeXVsNGdBOVN5cFQrRm1idmxPWlFvRi9OOGRkbWVmU3Fudm8vRFA2RUxN?=
 =?utf-8?B?Lys4cEVpYkg3MVZZK2J0RlVRdWoyOTRzUXZISFYrblV6b2xXZDlEazlLRFlE?=
 =?utf-8?B?emlUQ0EwSEdJK0Z5eUFWMVBNK3ZNdk5EazBTbXN0SGpSTHVnZVZGOGxrR0Fk?=
 =?utf-8?B?c29aVTMzM0FyUjlPQmNXTitLYjJPMUpQV1k4Z2RXbFdwOUJJaFQxeVR5S01y?=
 =?utf-8?B?ZkQxWmlKYWdkd0dhRytHdEVJcGhHQTRVZUJtZmVyTzNQMnFkTjRjeTF3OE9R?=
 =?utf-8?B?OElRVzU4QnBFSTJMdjAybEY3ODl3N2t2OS9LL1ZMWUp5Vm5nNXE0dGFJK2xp?=
 =?utf-8?B?a0tCM2tSSTVQRmRCZDRJTSs2amY0MXlPUkVsYnhydmMwTWs2YjloYkJxQjBu?=
 =?utf-8?B?Vm83Z0Y0NmY0QUxsbWV5VFBjQk9GMFdOTVZDSmcwR08rckJNTnF0dzArNGtQ?=
 =?utf-8?B?b2o4UU1OQzJqTTVOUms1aUJ3U2QwcGlHRHY0eEZaamw2WVdBL0Q1YlpnWGxY?=
 =?utf-8?B?cUw1L3hod25KM0VIMzRENENEdTdxYnJXMTBhSm1xKytTUjhlZ3NzQ1NIdDBM?=
 =?utf-8?B?TmE2VVVsQTAyTkdScys4MEtCVXFST24wclBwMUhmaDFsQmZyQlQ5MTBnbFBX?=
 =?utf-8?B?NDBSR1dyL2xBdUh3R0Z1NDNVcXp5YmsyeUFScDVIV3NiNk9VbUw2MEZJV0Nr?=
 =?utf-8?B?a0FwWnVlNS9zRlc5MlRRKzZla3laWSszL1ZuYjVyK1ZGd1pMNng4VENrL0pR?=
 =?utf-8?B?T24zdSs2NjBZYzNvckpoUnJuN243S1RkUElJUEtXKzY4UzRJNmEvbmFMZ0Rw?=
 =?utf-8?B?d3Z3TW5sdVNVVmFJUzd3czZBMTNCdWFTUTJoNVJyMWgzS1d0WWR5Z3hTMUo5?=
 =?utf-8?B?R3VGQTVVQ2I2V0d0RkdTRUNzbWJKWHZ1Y0p5Wm1GV1hHb1F3bXhyRHpDQVQ0?=
 =?utf-8?B?eUUvUjBKelZoN1g4QUYzZzBkaFJoVFBvR1A3VWtSQUZGcUJSRk5oS2hLNlkw?=
 =?utf-8?B?aklvYmV0b1lRYnNoWWJhY3BBUEJ6Z21BT1NnSVV5S2NaamNDZUl3ZkFJOUVY?=
 =?utf-8?B?YkpaYndhaG55V0VMN25JbC9UVVNEQm5Ba1ROYXlQYnhvOTRxNEVJNzZWKzNF?=
 =?utf-8?B?OTlmeDlQRDdabUxuTkxpUlAxWElHY0xuK2lGRkJ3Rks2OWZnVXorV1EyTkZa?=
 =?utf-8?B?Q1VYbTZpNWlHbXpIaVRFYnBhNHZINDBNa0JvZEVKVk03YmNXd2dNaWRDaXJY?=
 =?utf-8?B?UVorWWlMa0pwd2xzYjN4UFdyUTNsek4yMlNqblljdWk0S1AwWjFwWERaWEhE?=
 =?utf-8?B?TWM2T1k0VFJFbGRZcEo3YWNvd3l2bksrWk9UbEd1emhKbXNEYnNWbTRkem5U?=
 =?utf-8?B?eEluLzBIRTlpTERVbXdNdW9VN0gwbEwzY3I3Qmc5UVBKNG5tejB0Q1AwRGtl?=
 =?utf-8?B?ZkZnaWxJT2l5dUptVkNTZ2FHWnVWdjgvaSs4Zk4vLzh0NHUrOXFBWitWajAv?=
 =?utf-8?B?K1V6UU9NZWxkY0NTUU9wU2VTaFZoZzBwZm94ZFR0WFlQYkpURlQ3NTVKSFRy?=
 =?utf-8?B?eWt6dnBuamNtUXpVRVZjVWRtTnE2L0k1bFF2Zm1kNXg1NnpnekZ4SVNlMVk5?=
 =?utf-8?B?dStGazRVaWpLSVFDRVlNZHpPN0ZaN3ZpNVB5NG1lUmprMkxIWmw3VTFLWlBO?=
 =?utf-8?B?aTFRYWIxZUxla2JqK1NZNnBVbW1MMEFQd2dTdDRWWVNTMUVLYVNzS3J5dVVK?=
 =?utf-8?Q?GeDfz6dZefLSTqNflJN2+t25OUtoITo5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 22:18:15.3377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a76a8ce5-d28b-4e2d-2398-08dcd378cc23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7779

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

More follow-up on this: 

Fixed crashkernel/kdump boot with IOMMU SNP support still enabled prior to kdump boot by reusing the pages of the previous 
kernel for IOMMU completion wait buffers, command buffer and device table and memremap them during kdump boot, with this change in 
the IOMMU driver kdump boots and is able to complete saving the core image.

With this IOMMU driver fix, there is no need to do SNP_DECOMMISSION during panic() and kdump kernel boot will be more agnostic to 
whether or not SNP_SHUTDOWN is done properly (or even done at all), i.e., even with active SNP guests.

As mentioned earlier as SNP is not shutdown and IOMMU SNP support is still enabled prior to kdump boot, all the MMIO registers 
mentioned in AMD IOMMU specs (as below) are locked:

2.12.2.1 SEV-SNP Register Locks
The following IOMMU registers become locked and are no longer writeable after the system
becomes SNP-enabled:
- Device Table Base Address Register [MMIO Offset 0000h]
- Command Buffer Base Address Register [MMIO Offset 0008h]
- Event Log Base Address Register [MMIO Offset 0010h]
- IOMMU Control Register [MMIO Offset 0018h] fields:
- MMIO Offset 0018h[IOMMUEn]
- MMIO Offset 0018h[DevTblSegEn]
- IOMMU Exclusion Base Register / Completion Store Base Register [MMIO Offset 0020h]
- IOMMU Exclusion Range Limit Register / Completion Store Limit Register [MMIO Offset 0028h]
- PPR Log Base Address Register [MMIO Offset 0038h]
- Guest Virtual APIC Log Base Address Register [MMIO Offset 00E0h]
- Guest Virtual APIC Log Tail Address Register [MMIO Offset 00E8h]
- PPR Log B Base Address Register [MMIO Offset 00F0h]
- Event Log B Base Address Register [MMIO Offset 00F8h]
- Device Table Segment n Base Address Register

As Device Table Base Address Register, Command Buffer Base Address Register and Completion Store Base Register and Completion Store
Limit Register are locked, the writes look to them are ignored, they don’t cause any errors, but as writes are being ignored these 
registers are not updated with new allocations for device table, command buffer and CWB buffers during IOMMU driver init when doing 
kdump boot and these are required to initialize the IOMMU and enable irq remapping support in the kdump kernel.
 
Therefore, we reuse the pages of the previous kernel for CWB buffers, command buffer and device table and memremap them during 
kdump boot and essentially work with an already enabled SNP configuration and re-using the previous kernel’s data structures.

So now this will be an IOMMU driver change and we can skip the need to do SNP_DECOMMISSION and this should work in all situations 
irrespective of SNP_SHUTDOWN done prior to kdump boot.

Thanks,
Ashish

