Return-Path: <kvm+bounces-62187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F41FC3C448
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE1601B21A0C
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C2134B661;
	Thu,  6 Nov 2025 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ErxnYFq/"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A2329B766;
	Thu,  6 Nov 2025 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445355; cv=fail; b=ZZYCgXhKLN8CHYa31nGFDogwvRTAtgs7jzyYmqB0OSGgxRl/Syk60ZkSdKoR7jLAODTmbDweW2JpI4kGTkP0+ZDE18tEfTM5At3JC2ZDSYYF4r0GdSJjHlBb19SRPrQzrTtQAKj3/CLqGdiSqQNl2q//yE5IbGxyznWWx/Wj3jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445355; c=relaxed/simple;
	bh=ZfFStExC3BVw0Bn0jzqrrpDEya2elUUZKo5fSTsZhxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZzcvtQ70h7t6JmV9srjzvnorwII/6A7KSIAJsOz/ezqmiSvIohm2P0B+efU9E0y9UQxXMtFdBsa6Jl1/GiWw0W/3zE/j35ZKQ/eGC+Xs9poYFa/Iojah9hBZJPoFUrMF9lJ3KzPzTubx5G3sGuNgSdas6+PjO93qQIjHmh8VdJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ErxnYFq/; arc=fail smtp.client-ip=40.93.196.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2e8czzKN3odEwSAxPS2nRj8h/GTpUBIjhLOP5QY9w21iLaxSGkqx8cOt8nKNASkAg19N1OQqEV6nJ3Q1kfIjes7o6GNvknEnfFHT9J8T33vcrfy+olg8kyUDHlBKnzrOhlmFW0m9PY1vmXwKgaNvq3mJMtoMJpCFblKY/Vvc/SH9v2K/DIays3SUHmVU4dKi956ziSv6Fyiepq4VouWythBqxIvgxpVZmeHX74Y221radrxB5ot+4pYEP8T6K0U8SVhU28INQ/vTYLRuWXX+srf5G1Jr/MlmB30UHhAxslJsscmvIVgnFj8M1FgtoOHBhTsJ2q8e7cjc8IfjkQADA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LN0ij2p4wFTCjOedRMnPL2tPIR2cLXsUzXtHJQnRsKI=;
 b=ncAX2aoxZA7MABrapR42HG8Z1FyQxd4ZXB8+1tESrMVOGKcOeG21O/dsZy301tHfnGjLNz8uFyq5XOa9a8TUpw74yZRw6m+84/OyaUHDt9+rjy5XckdELvbG5CfGBWzfzbuo5YU9oLX8jNApoTbn700Usoqd8lF7FIFiYJTjUQJUEpt+n1AvpM7giXONNDmPxRm2WWEJQkBvM3stV6E6EI6aINCOVO2samq0Ol/48+sOntCDTSFGpENS2mt2cSZb9GWQYdfKC5MLA/WZB5sUcS2yA9/OrzkBiixirx32mnsHdcOuTR9n3tnpsCJaGR3VTqOhAV+04SZs/jObxpSy0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LN0ij2p4wFTCjOedRMnPL2tPIR2cLXsUzXtHJQnRsKI=;
 b=ErxnYFq/1ziHoFlwY13rQsOSvleeyBafrAzZY0p8wg6qr5UZKE0zCvqHPat58U32xVMe+IfgGZWHCIZ34NVHnpagDiMuX9W8j1Frft8pfSXpghGPG5N81oL9BdMGTjV08yRQv7h87Mv6dGbcBzejqg7L+AaKZZL1Sk5HuiAQyQY=
Received: from CH0PR13CA0012.namprd13.prod.outlook.com (2603:10b6:610:b1::17)
 by CY8PR12MB7660.namprd12.prod.outlook.com (2603:10b6:930:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 16:09:10 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::e8) by CH0PR13CA0012.outlook.office365.com
 (2603:10b6:610:b1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.8 via Frontend Transport; Thu, 6
 Nov 2025 16:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Thu, 6 Nov 2025 16:09:10 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 6 Nov
 2025 08:09:09 -0800
Received: from [172.31.180.39] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 6 Nov 2025 08:09:01 -0800
Message-ID: <6f749888-28ef-419b-bc0a-5a82b6b58787@amd.com>
Date: Thu, 6 Nov 2025 21:38:54 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: SVM: Mark VMCB_LBR dirty when L1 sets
 DebugCtl[LBR]
To: Jim Mattson <jmattson@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <nikunj.dadhania@amd.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Matteo Rizzo
	<matteorizzo@google.com>, <evn@google.com>
References: <20251101000241.3764458-1-jmattson@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <20251101000241.3764458-1-jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|CY8PR12MB7660:EE_
X-MS-Office365-Filtering-Correlation-Id: 86550045-381e-4bd1-3013-08de1d4ed213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVlSNUZCRVdoa2FTMHc0REdoQ2Z6VDRjNXdyMVFXT2kxY0ZFTm5yWWVpWTNB?=
 =?utf-8?B?ZkhqR2RZaGlHK2ZrNUd2dUtqd3FmeUlmTVExZWRFakM2UVpsSk91bmsxcENC?=
 =?utf-8?B?aUk1WmJXMTkzbWp6QVVma2ZaWkFGQkRxZ3VDREx1WGdGaTlBaXZBOVRqNGxU?=
 =?utf-8?B?RGFudEFMeTN5UEQrMExXTjYzd0piZkcrMHVFaTZSVHppcUhNUUtlOVEreUUz?=
 =?utf-8?B?MUpHL2hBdWlzMTllV1YvcUlGbWcvTGR6N1ZLV2dWNkZhdnN4NjM1aEhMNFpa?=
 =?utf-8?B?aWNHcnI1OTA1MHB1cnhmTmZNVktJQlRTVkdFd1BKY1V6cDdOZnQ4dkJleVdZ?=
 =?utf-8?B?NnAwTWJJdGE3ZDNXb2JjaVF5Ukx2STJKbFQ3SmdqZmdpOHhpQnVlYUxkL2tQ?=
 =?utf-8?B?TnlPS3RWSjRGZjdwUTRlVGE1MEdGZW9GeHFxVmsxRmJYclVLQXdEMDR0Smxw?=
 =?utf-8?B?UnYybzExMzVYM3UvU0lXUTJ6VFZuYUJXZWNWK0k0YkVKY2MrQTV1dnRpZHZp?=
 =?utf-8?B?SVJ1QTQ4VDRZa0d5b0xXSnpUVEc1Y2Z2Y3ZSdWlpQjgyLytUWndodVZya25x?=
 =?utf-8?B?OFVDcWlodCsvUENaZGt4MTRQN2wwandrWVJReW0xWDM1ampBamVEbnkyTmZJ?=
 =?utf-8?B?YUwwbnMxVHo4NHMzZmtOV05XckI0QWVSdFhxYkl1VDVPbjBTUTIxM2xSUUtH?=
 =?utf-8?B?bktTWVpad2gyV20wTHFXeUV5V2FtMUIwZDI2WEF0RTgyMVY3ZitKV1RQVnVT?=
 =?utf-8?B?RmMwdFVidW16ZnBYOHdmU3FBbEVscTBIYlZ2NjR2WjF5VHhYY0NwMnQ5WHZX?=
 =?utf-8?B?ZVRLRzBhRk1zQzYrMkdZMzM1bytmbUdoakxmckN5U1FzdkxIUmxFY1k3Z2Vx?=
 =?utf-8?B?cnJGMy8wKytxTDJESFVMM2dkM2FNRlVlQVE3SUhSZk9vVjRxRkxCUGw3Um1E?=
 =?utf-8?B?ZVltRG9RamoveU9mZzNQaEwzNkVzWmk4N1l5T0VQUVRWc0RqeU55aUR1TFZt?=
 =?utf-8?B?Z1dtVXVUeU1iUGViem91MjRCMmtaak4zclRBT1E4Y04vQUF3Y3FZOGc1NEUy?=
 =?utf-8?B?ek1HSkpBUHcyM1hBdUpnYXFQSTAvZ0VPa2ptV2dDTndVK2JVeW5wOWpGWXlE?=
 =?utf-8?B?TjM3dExUNzV3akk1ejZvdEVtMzFNc3c5WElEazlFNWl5TTZTWTdZd1lUaEh3?=
 =?utf-8?B?cXRIQ3c5eG9pU1JLUGpySmxaczFQR1F3SngrNEVPdDUvVDlnQlBocTZrOGNj?=
 =?utf-8?B?L3ptaS9YTTFZRVFSeUk1RlZUeGFKeTl5UUx4STRTbUxTV2VScDdneTZpQ09y?=
 =?utf-8?B?dXpyVDFPNEh0WTZEdDVBOFhQVC9WV04yYlJZbjMzelpNaURoNjQ2aEI4TTdT?=
 =?utf-8?B?dThPYXlOMk9YSnVrbEx6V3dVZk9pWTVwSmdNOWFwRWNiMUQ3Z3UrU0NjdXFQ?=
 =?utf-8?B?VEJPYmphM2M1cVk1WVhoZFZkRk14SjBTbTd1d1N3VGhVQ2J3OEJyZllZcGlZ?=
 =?utf-8?B?VjdKVVlFYk5qRmFrK0RhSURZTGYraXFFUnFNT2FIVTNUcDZQMFVGWHIxZUF1?=
 =?utf-8?B?cXk4bFMwS2FXWi9TdEZNMEhPN3o5V3VZczVHaTluK2lwbHJtbEtyaElwN29n?=
 =?utf-8?B?S1lRMUJIS0RMei9OS0VCSmswbXMyRytzNUtDS0VOay9CSHZCSVpzLzliTENy?=
 =?utf-8?B?b2VqL1grNlpOSUN0bEJLeE9aVjNXSk1yQ2VYOElMWU9pV2E0S2w1MiszbkNi?=
 =?utf-8?B?N1JnK1JIamNNdm1XRi8zOFhkbmFLSVY3YTFpa1lnODdXVE0raHpLS3RjN0NS?=
 =?utf-8?B?MWJjY0xmUTdOK2w4Vy9ZSW0rSmZNZ0hDVFRmV1kxRFBPSkIydm5rSWxUWmpY?=
 =?utf-8?B?eXVtSjNCa014VHJuVE9TSGZJZUdZd0R6cUhra0t1YzkrYzFrRkc2NzMzRmll?=
 =?utf-8?B?WHcvd0hpWGY0OUZyanhNekkrbU9KNFRRWFRCNFFYVGZPd2Z6bCs5RXBnTzhi?=
 =?utf-8?B?NDhkakNxM1U2bDdoT2Y2aVlvSGZoVGg0Zmp4NUxyMDhGOE9VS2NWTXQ4R2RO?=
 =?utf-8?B?RTZKdDVTejEraTUvTVg2cUh2NFJjNk1hZTRTMlpwVk1xalZnQVBnbUFGWDJ0?=
 =?utf-8?Q?4uFk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:09:10.1787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86550045-381e-4bd1-3013-08de1d4ed213
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7660

On 01-11-2025 05:32, Jim Mattson wrote:
> With the VMCB's LBR_VIRTUALIZATION_ENABLE bit set, the CPU will load
> the DebugCtl MSR from the VMCB's DBGCTL field at VMRUN. To ensure that
> it does not load a stale cached value, clear the VMCB's LBR clean bit
> when L1 is running and bit 0 (LBR) of the DBGCTL field is changed from
> 0 to 1. (Note that this is already handled correctly when L2 is
> running.)
> 
> There is no need to clear the clean bit in the other direction,
> because when the VMCB's DBGCTL.LBR is 0, the VMCB's
> LBR_VIRTUALIZATION_ENABLE bit will be clear, and the CPU will not
> consult the VMCB's DBGCTL field at VMRUN.
> 
> Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
> Reported-by: Matteo Rizzo <matteorizzo@google.com>
> Reported-by: evn@google.com
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 153c12dbf3eb..b4e5a0684f57 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -816,6 +816,8 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
>  	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
>  	if (is_guest_mode(vcpu))
>  		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
> +	else
> +		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
>  }
>  
>  static void svm_disable_lbrv(struct kvm_vcpu *vcpu)

Hi Jim,
I am thinking, is it possible to add a test in KVM Unit Tests that
covers this? Something where the stale cached value is loaded instead of
the correct one, without your patch.

Best regards,
Shivansh

