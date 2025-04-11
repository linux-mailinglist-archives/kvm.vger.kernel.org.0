Return-Path: <kvm+bounces-43156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3075A85ABF
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C53B1BA6904
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D99238C05;
	Fri, 11 Apr 2025 10:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4995HAki"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E2221297;
	Fri, 11 Apr 2025 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369065; cv=fail; b=ZJvWiWFdq80C3K95xSKDwZMEmQ4n6YegcIj4gjn7aXjzVkB9Cfhoms8JeDOxKZlt0LgfNOR8qWAP0r3AAKGXOU7pT9rFQFbpxDaIxfxqd1sUknKQqa36b5jiKHsrWZTzgaDRGJE+0M4UFcyiO1ny8dOFP4wi+yHuyngT0yltPF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369065; c=relaxed/simple;
	bh=zNFl/2CrTlFNXAWXxOKUCDzHNS8fg8hKky67cowzztk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gaa7SzUWbcJP/Ul9ofXXXFq5Z0yNJzOyuHzzESOZf7gA1LChvQZDjluESNy8nTj2KA2+Rx/7n+BfkkwwIjxazTPZVnrnkazl5dJjkg6+3el2b9bnQ+3ZGUHPhnHToQaCfqfNMCVGewkWTHDbBti3VpvHLQvwaSKGvLsQAaHnJHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4995HAki; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rX2pIkrOepK1dW2GSKBbmtf9LNL+vAHasbSLybCFCAx+f66m1+TtHMseEmcOkHNYydDlqTpsIDwpxThZ3Hx45mim5K6/rICOt61Yp5siWQOmNwAnNDcvNloogKuDn+a1DfBt/tZ4FcxpNnGlMkxq9kdTErAgJJ896X7di9b+F9vaUfPRgdv4UDP3vMMJW3roEtI32i+nIS2CsWr3lhl0fnMftFzIfO3EsJjov88dMBgZ+7DBoOBr38A3cyLetZ2GohphgLlSAzXhm72KLDQx4rDxbI+FlIF/buhIllfoV3nIqDcZy2sQfYckUTs5e+H7R9ZeIiJUybkdWnzcnqdlnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olzvvHCbgJENYDCF6ntpRhFi1o31IX4gukMg7Sx+WVg=;
 b=j9N46GK4gMrgL8IqzMMfEBQ55HTm7kFoMT7dHyGTTZVUxSohi+69oVrnWoTYgjRf5y64DUJziBvlNE+rXIFKD3UNzgIbiVeQudEryMYChRDVZt0vsgzQQMUHfmgFqDgIGvkluHCUTgFn5AT3k5ySmu7LmIk/xCvLXQBD7mvZj0iEKsI9jyUHh+Q4CVygz75ohQOa6NctWlWutEWIsremwNfP5yr6P/YAGe4HdKfS/T5Tk9tQOeMTL75H1g7bzPg86y5jcydRgPVlA/2BWsdAQpN1BOMFTbNaX/oqhBTE3pDiTGY8hkioAMr96N250wOcTgfcRYMa0nEFoPuVjIskCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olzvvHCbgJENYDCF6ntpRhFi1o31IX4gukMg7Sx+WVg=;
 b=4995HAkicikq1Nl3P7KU0BCab7GgUNiGKtzPVQBE7wr6u7LFl3mj4ao46/ndAy5sA23k/aNekb4/Yq6rW1+GTRprNyEOWq13GDiNkbuhQT/ehtAPZRNK1fAJnyZYeRl83+ntvuWPLn6A/OUijdXkBeoG2QMwtn2Shzfw4Em+DCQ=
Received: from PH7PR02CA0008.namprd02.prod.outlook.com (2603:10b6:510:33d::27)
 by PH7PR12MB9152.namprd12.prod.outlook.com (2603:10b6:510:2ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Fri, 11 Apr
 2025 10:57:37 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:510:33d:cafe::a5) by PH7PR02CA0008.outlook.office365.com
 (2603:10b6:510:33d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Fri,
 11 Apr 2025 10:57:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Fri, 11 Apr 2025 10:57:37 +0000
Received: from [10.136.43.133] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 05:57:33 -0500
Message-ID: <6f76183f-a903-47fd-8c84-0d9892632fca@amd.com>
Date: Fri, 11 Apr 2025 16:27:25 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/67] KVM: x86: Pass new routing entries and irqfd when
 updating IRTEs
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Naveen N Rao <naveen.rao@amd.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-9-seanjc@google.com>
Content-Language: en-US
From: "Arun Kodilkar, Sairaj" <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|PH7PR12MB9152:EE_
X-MS-Office365-Filtering-Correlation-Id: b49fb2a1-a1f7-4476-3689-08dd78e7abee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTlielc1bjltK3NkTVBJMWFPZWFRbGM5WXNiT2lEN094OGtRc0dUZWZETFpK?=
 =?utf-8?B?VjFnQjdqZHBqRENremFDN08xVWttK1U2L0p1NEdzQ2tYRFZPZEpZd3kvNWNm?=
 =?utf-8?B?VHJkb0VIdUdURUNRSlQ5TFBubm5zVlRLelZBL2k3dTZPL21LQ3pMMFNla0lm?=
 =?utf-8?B?TzhCSysvWDJ6VStFT09qVU56d3VpTTJNWUFnTGtzcE5GOW9zUkpQcEFER3Zo?=
 =?utf-8?B?QkFETkZWeWw1MFZ3cjduMXRRU3ZGQlY1cWJkdkR6NnBYVEhFVzdxbDVoakFu?=
 =?utf-8?B?WGs0OHR5NDhmLzBCdTZMWGxmaE1nWlFYVWxkY1JhNVp0a2p5Sjg5ckRQZzZn?=
 =?utf-8?B?M2FaSTJRQ2FkbzJLTnZDcTZoK0VCYWhITHRlQmF2Q1UxTXZiZ0NKeXhHZkNK?=
 =?utf-8?B?cGRzenZoT3JTSDJCZi96eUlRcW5uVmFBc1JoSVQ5S1V4QVpVNWZPaFoxaHJS?=
 =?utf-8?B?d0RaWXVaNUJUN0F3bm5HdWx5dUcycWhuTnN3TERRVnRUSnc3SnNBM3I0NmNL?=
 =?utf-8?B?Yk1XUjdMdkVZRUVkVFdmMUdKOEptY2xBWmxtZGZ0c2dadkg5djVQa0NUZWV3?=
 =?utf-8?B?Zmplc2k5cm1xZzBIQlJHNlgzOGZYMjI3bHdhV0VKTkw2eENNRG5FTklscC9G?=
 =?utf-8?B?K3VyemZ5c2Ixb0RCdVV3VlVXTEE0SHM3MC9jenM0azkzRUdNZGlEalJqQ1Bo?=
 =?utf-8?B?YnVGUytKTTUwZkRiNHAxY0RKd2tad05oSGdCRHZVOXpEMFlYZXErWDlUWGsr?=
 =?utf-8?B?TEwxa3B4alB6M1duUlRZMndYZGZsN3VrRXYrZDREMG02Ni9PNUNtVzV2TW1l?=
 =?utf-8?B?ZFB6V2FjcG8vYnNqRWFqU0hFUVREMzJnRENJc2RPNEY1UlhRQ3hVMS93Qndm?=
 =?utf-8?B?YWUwQU9FR2N4VFJoRWZxbmJ5U1R1dDNrekxYbW5EV3NaVnNjZW1yZ1J2cE00?=
 =?utf-8?B?WEZmK1dsUDVTVS9YY2VXM25ucnRObjNGOEV4QjBvWjJGN1BFU1dsbHYwQzJx?=
 =?utf-8?B?NVBSNys2ejZOakEySFpVVy82bW1JS1lQZm5CODBWZlBSWXpNbWh6eFdLUmgz?=
 =?utf-8?B?Ylc4MXU3OStNTzNMQVg3dDNDYXlOMURLNkNUSVQ2VFc1RWNDRVZPZFUzWERN?=
 =?utf-8?B?Q1RqNFc4dlRiYSt1cnBwaFVyVnZvNWtlMG1JRGI2L294aElpaEVHdzhmb0pq?=
 =?utf-8?B?ZzE5bUxRS1BRaUZOSDRIVFBIbThDUHdEYWpoZGpKbi9pZ0dVOTZqOGU0S1hV?=
 =?utf-8?B?NVVucnhtbFQrUTNhTStqNHoycllmZlZ2alVJK3F3TjBOMEpRTGxSeklKZ1FO?=
 =?utf-8?B?ZU8ydk1PMC95T2d0ZzV2dHFUcDhCNGpHVi95ekVJNU50VjlMeUFINnBQMzFu?=
 =?utf-8?B?eG9LVldieENQOGlWUU45K2JoK2tLUS9xc2RDUThzQVpUcUNtbVI3TWhVdDln?=
 =?utf-8?B?TUZWZ3NuOTZYMnBkcHZEUkNpV3VubjJpZmNXZWw1UkM0bzVpNnZYSmJoVDdU?=
 =?utf-8?B?M1Ntb1JuZlpYeWJJS2FFanJzUVMzdHJoN3h5MGw1cXdIRGpMbHJWM05BUnFO?=
 =?utf-8?B?Y0s0TWZLRldJUVcwWkt1RDJ5N3JBOVUyUDV1a1Bpd1hMTVcxWnpCVG1mTzJX?=
 =?utf-8?B?YUJ4N2dqOFNVVld6UnhwTG8rTEYybU1FTDFvdk5PcGtNb2V4RTJyMXhYeTcy?=
 =?utf-8?B?aE5QbmxLb0d6QWRrTXBjcVE3WjZ1UTB2Rzd2c0lZc1kweGhFVnYreEhORW9a?=
 =?utf-8?B?cWJqYnllOU0vQ2YwaTFBZUUzUFd4S0NHV3d1eURvOWQ5YnFXVW5RSUF5djJa?=
 =?utf-8?B?REVoNENRNjc2eGR2RjVvcDJLSE1ySVNIRTU5SUtvTG51Nkx0RE5UdTVaQlFO?=
 =?utf-8?B?c3NreVlUTzBIV203SXRGUWFNUnl4ck0xeWh6WnFqNzk4ZzlVRFRPSlM5dVE0?=
 =?utf-8?B?MnVwUmVxMlI4OEFVSlRsNk5nMC9Eb29vN01GMTk0aytTTDYrUlNSNlJjVlc5?=
 =?utf-8?B?bmxWMkN1Kzgxbkpuam5VTUhpSFl5bG5mb2hkTEJCM3gwWHk4Rk9JUk44L3ox?=
 =?utf-8?Q?yHxYnx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 10:57:37.2365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b49fb2a1-a1f7-4476-3689-08dd78e7abee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9152

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> When updating IRTEs in response to a GSI routing or IRQ bypass change,
> pass the new/current routing information along with the associated irqfd.
> This will allow KVM x86 to harden, simplify, and deduplicate its code.
> 
> Since adding/removing a bypass producer is now conveniently protected with
> irqfds.lock, i.e. can't run concurrently with kvm_irq_routing_update(),
> use the routing information cached in the irqfd instead of looking up
> the information in the current GSI routing tables.
> 
> Opportunistically convert an existing printk() to pr_info() and put its
> string onto a single line (old code that strictly adhered to 80 chars).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  6 ++++--
>   arch/x86/kvm/svm/avic.c         | 18 +++++++----------
>   arch/x86/kvm/svm/svm.h          |  5 +++--
>   arch/x86/kvm/vmx/posted_intr.c  | 19 ++++++++---------
>   arch/x86/kvm/vmx/posted_intr.h  |  8 ++++++--
>   arch/x86/kvm/x86.c              | 36 ++++++++++++++++++---------------
>   include/linux/kvm_host.h        |  7 +++++--
>   virt/kvm/eventfd.c              | 11 +++++-----
>   8 files changed, 58 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6e8be274c089..54f3cf73329b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -294,6 +294,7 @@ enum x86_intercept_stage;
>    */
>   #define KVM_APIC_PV_EOI_PENDING	1
>   
> +struct kvm_kernel_irqfd;
>   struct kvm_kernel_irq_routing_entry;
>   
>   /*
> @@ -1828,8 +1829,9 @@ struct kvm_x86_ops {
>   	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
>   	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
>   
> -	int (*pi_update_irte)(struct kvm *kvm, unsigned int host_irq,
> -			      uint32_t guest_irq, bool set);
> +	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> +			      unsigned int host_irq, uint32_t guest_irq,
> +			      struct kvm_kernel_irq_routing_entry *new);
>   	void (*pi_start_assignment)(struct kvm *kvm);
>   	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
>   	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1708ea55125a..04dfd898ea8d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -18,6 +18,7 @@
>   #include <linux/hashtable.h>
>   #include <linux/amd-iommu.h>
>   #include <linux/kvm_host.h>
> +#include <linux/kvm_irqfd.h>
>   
>   #include <asm/irq_remapping.h>
>   
> @@ -885,21 +886,14 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>   	return 0;
>   }
>   
> -/*
> - * avic_pi_update_irte - set IRTE for Posted-Interrupts
> - *
> - * @kvm: kvm
> - * @host_irq: host irq of the interrupt
> - * @guest_irq: gsi of the interrupt
> - * @set: set or unset PI
> - * returns 0 on success, < 0 on failure
> - */
> -int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> -			uint32_t guest_irq, bool set)
> +int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> +			unsigned int host_irq, uint32_t guest_irq,
> +			struct kvm_kernel_irq_routing_entry *new)
>   {
>   	struct kvm_kernel_irq_routing_entry *e;
>   	struct kvm_irq_routing_table *irq_rt;
>   	bool enable_remapped_mode = true;
> +	bool set = !!new;
>   	int idx, ret = 0;
>   
>   	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
> @@ -925,6 +919,8 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   		if (e->type != KVM_IRQ_ROUTING_MSI)
>   			continue;
>   
> +		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
> +
> 

Hi Sean,

In kvm_irq_routing_update() function, its possible that there are
multiple entries in the `kvm_irq_routing_table`, and `irqfd_update()`
ends up setting up the new entry type to 0 instead of copying the entry.

if (n_entries == 1)
     irqfd->irq_entry = *e;
else
     irqfd->irq_entry.type = 0;

Since irqfd_update() did not copy the entry to irqfd->entries, the "new" 
will not match entry "e" obtained from irq_rt, which can trigger a false 
WARN_ON.

Let me know if I am missing something here.

Regards
Sairaj Kodilkar

>  		/**
>   		 * Here, we setup with legacy mode in the following cases:
>   		 * 1. When cannot target interrupt to a specific vcpu.
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d4490eaed55d..294d5594c724 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -731,8 +731,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   void avic_vcpu_put(struct kvm_vcpu *vcpu);
>   void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>   void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
> -int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> -			uint32_t guest_irq, bool set);
> +int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> +			unsigned int host_irq, uint32_t guest_irq,
> +			struct kvm_kernel_irq_routing_entry *new);
>   void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
>   void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void avic_ring_doorbell(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 78ba3d638fe8..1b6b655a2b8a 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -2,6 +2,7 @@
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
>   #include <linux/kvm_host.h>
> +#include <linux/kvm_irqfd.h>
>   
>   #include <asm/irq_remapping.h>
>   #include <asm/cpu.h>
> @@ -259,17 +260,9 @@ void vmx_pi_start_assignment(struct kvm *kvm)
>   	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
>   }
>   
> -/*
> - * vmx_pi_update_irte - set IRTE for Posted-Interrupts
> - *
> - * @kvm: kvm
> - * @host_irq: host irq of the interrupt
> - * @guest_irq: gsi of the interrupt
> - * @set: set or unset PI
> - * returns 0 on success, < 0 on failure
> - */
> -int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> -		       uint32_t guest_irq, bool set)
> +int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> +		       unsigned int host_irq, uint32_t guest_irq,
> +		       struct kvm_kernel_irq_routing_entry *new)
>   {
>   	struct kvm_kernel_irq_routing_entry *e;
>   	struct kvm_irq_routing_table *irq_rt;
> @@ -277,6 +270,7 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   	struct kvm_lapic_irq irq;
>   	struct kvm_vcpu *vcpu;
>   	struct vcpu_data vcpu_info;
> +	bool set = !!new;
>   	int idx, ret = 0;
>   
>   	if (!vmx_can_use_vtd_pi(kvm))
> @@ -294,6 +288,9 @@ int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>   	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
>   		if (e->type != KVM_IRQ_ROUTING_MSI)
>   			continue;
> +
> +		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
> +
>   		/*
>   		 * VT-d PI cannot support posting multicast/broadcast
>   		 * interrupts to a vCPU, we still use interrupt remapping
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index ad9116a99bcc..a586d6aaf862 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -3,6 +3,9 @@
>   #define __KVM_X86_VMX_POSTED_INTR_H
>   
>   #include <linux/bitmap.h>
> +#include <linux/find.h>
> +#include <linux/kvm_host.h>
> +
>   #include <asm/posted_intr.h>
>   
>   void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
> @@ -10,8 +13,9 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
>   void pi_wakeup_handler(void);
>   void __init pi_init_cpu(int cpu);
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
> -int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> -		       uint32_t guest_irq, bool set);
> +int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
> +		       unsigned int host_irq, uint32_t guest_irq,
> +		       struct kvm_kernel_irq_routing_entry *new);
>   void vmx_pi_start_assignment(struct kvm *kvm);
>   
>   static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dcc173852dc5..23376fcd928c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13570,31 +13570,31 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>   	struct kvm_kernel_irqfd *irqfd =
>   		container_of(cons, struct kvm_kernel_irqfd, consumer);
>   	struct kvm *kvm = irqfd->kvm;
> -	int ret;
> +	int ret = 0;
>   
>   	kvm_arch_start_assignment(irqfd->kvm);
>   
>   	spin_lock_irq(&kvm->irqfds.lock);
>   	irqfd->producer = prod;
>   
> -	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
> -					   prod->irq, irqfd->gsi, 1);
> -	if (ret)
> -		kvm_arch_end_assignment(irqfd->kvm);
> -
> +	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
> +		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
> +						   irqfd->gsi, &irqfd->irq_entry);
> +		if (ret)
> +			kvm_arch_end_assignment(irqfd->kvm);
> +	}
>   	spin_unlock_irq(&kvm->irqfds.lock);
>   
> -
>   	return ret;
>   }
>   
>   void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>   				      struct irq_bypass_producer *prod)
>   {
> -	int ret;
>   	struct kvm_kernel_irqfd *irqfd =
>   		container_of(cons, struct kvm_kernel_irqfd, consumer);
>   	struct kvm *kvm = irqfd->kvm;
> +	int ret;
>   
>   	WARN_ON(irqfd->producer != prod);
>   
> @@ -13607,11 +13607,13 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>   	spin_lock_irq(&kvm->irqfds.lock);
>   	irqfd->producer = NULL;
>   
> -	ret = kvm_x86_call(pi_update_irte)(irqfd->kvm,
> -					   prod->irq, irqfd->gsi, 0);
> -	if (ret)
> -		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
> -		       " fails: %d\n", irqfd->consumer.token, ret);
> +	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
> +		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
> +						   irqfd->gsi, NULL);
> +		if (ret)
> +			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
> +				irqfd->consumer.token, ret);
> +	}
>   
>   	spin_unlock_irq(&kvm->irqfds.lock);
>   
> @@ -13619,10 +13621,12 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>   	kvm_arch_end_assignment(irqfd->kvm);
>   }
>   
> -int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> -				   uint32_t guest_irq, bool set)
> +int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
> +				  struct kvm_kernel_irq_routing_entry *old,
> +				  struct kvm_kernel_irq_routing_entry *new)
>   {
> -	return kvm_x86_call(pi_update_irte)(kvm, host_irq, guest_irq, set);
> +	return kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, irqfd->producer->irq,
> +					    irqfd->gsi, new);
>   }
>   
>   bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5438a1b446a6..2d9f3aeb766a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2383,6 +2383,8 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
>   struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>   
>   #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> +struct kvm_kernel_irqfd;
> +
>   bool kvm_arch_has_irq_bypass(void);
>   int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
>   			   struct irq_bypass_producer *);
> @@ -2390,8 +2392,9 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
>   			   struct irq_bypass_producer *);
>   void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *);
>   void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
> -int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
> -				  uint32_t guest_irq, bool set);
> +int kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
> +				  struct kvm_kernel_irq_routing_entry *old,
> +				  struct kvm_kernel_irq_routing_entry *new);
>   bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
>   				  struct kvm_kernel_irq_routing_entry *);
>   #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 249ba5b72e9b..ad71e3e4d1c3 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -285,9 +285,9 @@ void __attribute__((weak)) kvm_arch_irq_bypass_start(
>   {
>   }
>   
> -int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
> -				struct kvm *kvm, unsigned int host_irq,
> -				uint32_t guest_irq, bool set)
> +int __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
> +					 struct kvm_kernel_irq_routing_entry *old,
> +					 struct kvm_kernel_irq_routing_entry *new)
>   {
>   	return 0;
>   }
> @@ -619,9 +619,8 @@ void kvm_irq_routing_update(struct kvm *kvm)
>   #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
>   		if (irqfd->producer &&
>   		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry)) {
> -			int ret = kvm_arch_update_irqfd_routing(
> -					irqfd->kvm, irqfd->producer->irq,
> -					irqfd->gsi, 1);
> +			int ret = kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
> +
>   			WARN_ON(ret);
>   		}
>   #endif


