Return-Path: <kvm+bounces-43343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0EFA89BC9
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28A211894A5B
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B4628F515;
	Tue, 15 Apr 2025 11:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HQjFZGlP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2628DF1B;
	Tue, 15 Apr 2025 11:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744715784; cv=fail; b=JUZNnGUWilMjNkR4xcaWjCfaaCwzc+AoBQVY/TU4DuNN/2oO5fY1Qb5Jm03CNusqvAF6mbiUh/sOGsTc8LsQNWcpPYDuUAA/EqjgDJcp8PGb6Z4gY1lsfCKOSLmLRi9A7iAHomotIE4XE4hWRJpKQcch/NdXSovNDE93e+j427c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744715784; c=relaxed/simple;
	bh=xp6E5fVCJxCoPohXFGHLO9KZ8C/uXWD2gZbFz9mbEAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CUsGh+/NobabkVimwrHpBAPf0XsSUQvjGc3bAheURu9g9aGE1bcKVyQy0vYGTwinvIsdL2GUVed1lgPJQnrLofZ+qm4j9MFt5WCYvfQiidbUKWSh9tGldhlK3L+RDr/WenZmrwgawHob7uoDJpfjyyI/HHW5a8oBBQ9rK2dRphY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HQjFZGlP; arc=fail smtp.client-ip=40.107.101.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/nny1b0Z/evy6NYizWqROfwL+8baOiId6IsB7KlXavcqipHrL6DHc3FYBN9sZCrUNwqlsynJFn/QPlKqTpXDK+QoSP5gdESKT/lzfDThMBce49f9nZ3OJ9qWU8IKqgJKLI3HTiq8+TB+IwAHr04bKdwQFAYwPeXsaGLhZQKwylGlidbSyKYygmw2G9gYPp5/mpccn6ZPdU9TIIa4LMVftT+/IIMj1tkauzUxMF7wK9zU+H0xX+3iLL511Vh9rrdmd59V75gv/YB8gMQ4E1JLR7+4RfRrq0P90pQhnINftvnSVHeJRW4vVn9YwhLGtZ/kose7sI+9zYNgHl4xkPmng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Hvdk1oi4vMLjZBVRkyoOabA8RwwUoKetFaG7r0H6fg=;
 b=p4xime4zl6DepppqEMu11ylm3xflBNXKstnCJoofMf94fQqzfteTfozRlRKDdMBeg0Cv+b6T5KlcqrZZ3nf/ddgVdcibAfvhbR09tUyR7cX14Glq/HmErCTdQmAtBNYi93fatKMhXjMi9+tDodO3gX03pz/GW0s+STwzm76A5klx86ZYt5mxiiwPeJ/5ClEw9wCjQeUAJmzHQ3KarOPk450ULHgIR1d1TpqIOR4Ha54uyids2o9hN6H4EDMPudZ98w8Q+loPuFMCl/5dhdbUMTHnAMcr5vd/3X89q3hAdmEPz0RpqRB7In9G6lKxBvWmBXcTAHyrrClQ9ItqlIM3fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hvdk1oi4vMLjZBVRkyoOabA8RwwUoKetFaG7r0H6fg=;
 b=HQjFZGlPPaoxbsk7+cwYG3WaQ6fVBakz0th0NIW6gBgmmpPFF24pYesHea9ZuLhjW9z7sCyIUCervCIg11938JwgnOrJmAy/fNUcn6ovYE0D4s/8rz7lkv/K6FxliOEe+L8jJjObi/PhmwI1+N568EdUsJU1OwkBz21rAFBEPwU=
Received: from SJ0PR13CA0110.namprd13.prod.outlook.com (2603:10b6:a03:2c5::25)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Tue, 15 Apr
 2025 11:16:17 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::c4) by SJ0PR13CA0110.outlook.office365.com
 (2603:10b6:a03:2c5::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.13 via Frontend Transport; Tue,
 15 Apr 2025 11:16:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Tue, 15 Apr 2025 11:16:17 +0000
Received: from [10.85.32.54] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Apr
 2025 06:16:13 -0500
Message-ID: <a1f32fa7-2946-4efa-be74-cfb5c7d5dd22@amd.com>
Date: Tue, 15 Apr 2025 16:46:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/67] KVM: SVM: Drop redundant check in AVIC code on ID
 during vCPU creation
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-18-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|SN7PR12MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: f19d4dd3-39fb-4a0b-44ec-08dd7c0ef14b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUdTWFVjMFh2WURxMS9mUHJBM2k3NGJCRDZDT3VpaFdxK294T0htS2J3N1pk?=
 =?utf-8?B?MUlnYVFkYUhnY1Z6NzM0UzVnLzYzY0JQVXBUbnpFRlp6UXZRdUJsSTNOT1kw?=
 =?utf-8?B?WXRweEsySVhzSmVoaGw5eExvV3l4WUcwd1UyMDF4OU1TZkhUVS9hYlpLbVZ2?=
 =?utf-8?B?aVN3TzVxVXkxNUtlYWF0Uit3MEpUVllPR0RnQVpEYjBFV2pGMzUvRjAwaWs0?=
 =?utf-8?B?eVVDNldSN1BhYTJqczE2djhJVllwUkkxbWFEY2dWbk5NTjJyam1HUlFBOGpa?=
 =?utf-8?B?V3ZFaVluSyttdVErUTBVc2EyQlh6NXhnNldXb3RaamE2aHAzSW4xNkVnTTd1?=
 =?utf-8?B?NTNxVThJWGFWbGVZRDc1QmxiTFFDRGVDaHVFT0NXQ1hKTEFFT2hvNUdGQTA2?=
 =?utf-8?B?VDRPZVFjbnJyMFk0NG1BR2RVTVh0RlZMVTcrbkNDbSt4ZFdEWjkyeHRXc0Ja?=
 =?utf-8?B?cy8xMHFvZGFLYkdSa3h0bitIZm1RcFZuaVRPamxSbU9wSVF0ZEcvTjM2MlJU?=
 =?utf-8?B?NCtVUDgrMlZEaE5DMVJPQkV2V3hIZGJWU3htSkpMSWliaFgxWUFVZ2NjbytO?=
 =?utf-8?B?UGZqV2YwRDFDdVdYWDVHVnU0SEtYWmtUejNDb01iWXFBd21rN3pNL244blVn?=
 =?utf-8?B?WHc1NmNLU3lneEJYcTdMV3lkUVRnZnc5ZHQ1dmhSLy91Y2ZUSzJiV2VONmRu?=
 =?utf-8?B?dUhQeFVFb0xYc0luTzBUUjNZbHB0eVhTS3laRnFHMzM5MitDbmRodFFvcitV?=
 =?utf-8?B?WW9VdGxSSlJkcmJ2T1kzOXZsd1hjOVp4U0swMy9DOVZlTkxUcGMrWW9ETzJF?=
 =?utf-8?B?NTg2MHQ2U1FMVVpmOTJXOVljbGx0blhCeVZCeVdMdUlseFZ5b3h3NHMxcnVW?=
 =?utf-8?B?VFJjVlFRRXYzVnpITDBvQnhxczE5dUdzdG1nS0hLRDYxdWlpaFdNenNzZDVF?=
 =?utf-8?B?NlhrQStBdlMvdHdOS3NUekJzS254WVd2VTArcjdxQVh5RUxwQ3p3ZHFoc2lJ?=
 =?utf-8?B?TTNTOHRBdEJvSzhYbHZwdEFva09xbnkvSEFtMkd2Rmk1QXh4N1FLWmdJZFJ3?=
 =?utf-8?B?STM2VVhGK1cvRHR2bjFpeExtMlB5S3hsc0dRODBteWdUVVZPRGxvanBxN1p6?=
 =?utf-8?B?cmdhVWRlU1l3bk1HTGNFZVEwYjNBeG04SUhyaWlCako5L3UvTXludzdXaEF2?=
 =?utf-8?B?dkVJNUF2RDBscU5kdy83RnRGZ3RvdVZHTFY5ODJLbDRHNDhIcXFjekJDWjBp?=
 =?utf-8?B?TWVWRjJjZWQxTmJYbk12RmMxNzRRbVk1VzhJNzRrUHJxT2VONGpJTWdxWG5o?=
 =?utf-8?B?bTNTT2RHTTJJeXc2RzJmTzhMWEdJcFVhSzJMcEwzbXNPQ2QzdE5pSGxXVzlu?=
 =?utf-8?B?VTFTcCtVdnY4cTBDbGxPUWRuWk43OVRCU3VhSEJIcHZuY3RRTlZRVFo1OFl6?=
 =?utf-8?B?Tm15a1AwSUZLbks2Zm56U2tlaWw1cXpRZGVtKy84Y1IrdTBQbUZLaFpzMGJO?=
 =?utf-8?B?a3p0SFc0VGJDcGVXdThuY2toc1VpY1h6bHR6ZVlTQnN0YTlnLzg1SmdZamJZ?=
 =?utf-8?B?VHJZcUZXSFZCODVscklIM3pIQnQzZEpjMHRtc2t0UWI4K2xTc2Q3eHhWWjRs?=
 =?utf-8?B?Mm5nNW94ellqMklWK3F0aCtvZys4N2ZuVk1LYVFmSUVZTUlPdlRVV0Z2VC9y?=
 =?utf-8?B?ZlJQTUlvcUY2Rmx1RWRGOWduV0xpd2lqSVQ1U01ZemEwYkdXV3lpRXE5WU52?=
 =?utf-8?B?TTZNNXNqdGNxSS8wNDk1QWtzcjV1TVl1eXovWllkZzRFUldJaGFSemhvNlUx?=
 =?utf-8?B?QmErd0s0cnlsR1pQV3pvdFVMNi94UzJoMTYzN1Q4TkVzYm8zOVY1MTY2Tis5?=
 =?utf-8?B?bFUxQjlhWHdidG45QmpnOTJST2NCY1hYMW9sand1ZTVPZDVuUTJlT004UHoy?=
 =?utf-8?B?NHNHRXBnYktZcy9EcVN3V21VZXhSMHc2dm9UQU1OeGhraFZTL2tZRXJORjhF?=
 =?utf-8?B?WmU3YkR0NmhDSG00ZXhkTXE5a3lUaU16bElmbUVibE5nQTRQZ1lWaVF5dnh3?=
 =?utf-8?Q?csw/i2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 11:16:17.4700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f19d4dd3-39fb-4a0b-44ec-08dd7c0ef14b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Drop avic_get_physical_id_entry()'s compatibility check on the incoming
> ID, as its sole caller, avic_init_backing_page(), performs the exact same
> check.  Drop avic_get_physical_id_entry() entirely as the only remaining
> functionality is getting the address of the Physical ID table, and
> accessing the array without an immediate bounds check is kludgy.
> 
> Opportunistically add a compile-time assertion to ensure the vcpu_id can't
> result in a bounds overflow, e.g. if KVM (really) messed up a maximum
> physical ID #define, as well as run-time assertions so that a NULL pointer
> dereference is morphed into a safer WARN().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 47 +++++++++++++++++------------------------
>   1 file changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ba8dfc8a12f4..344541e418c3 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -265,35 +265,19 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>   		avic_deactivate_vmcb(svm);
>   }
>   
> -static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
> -				       unsigned int index)
> -{
> -	u64 *avic_physical_id_table;
> -	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> -
> -	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
> -	    (index > X2AVIC_MAX_PHYSICAL_ID))
> -		return NULL;
> -
> -	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> -
> -	return &avic_physical_id_table[index];
> -}
> -
>   static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   {
> -	u64 *entry, new_entry;
> -	int id = vcpu->vcpu_id;
> +	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 id = vcpu->vcpu_id;
> +	u64 *table, new_entry;
>   
>   	/*
>   	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> -	 * hardware.  Do so immediately, i.e. don't defer the update via a
> -	 * request, as avic_vcpu_load() expects to be called if and only if the
> -	 * vCPU has fully initialized AVIC.  Immediately clear apicv_active,
> -	 * as avic_vcpu_load() assumes avic_physical_id_cache is valid, i.e.
> -	 * waiting until KVM_REQ_APICV_UPDATE is processed on the first KVM_RUN
> -	 * will result in an NULL pointer deference when loading the vCPU.
> +	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
> +	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
> +	 * avic_vcpu_load() expects to be called if and only if the vCPU has
> +	 * fully initialized AVIC.
>   	 */

Hi Sean,
I think above change in the comment belongs to patch 16.

Regards
Sairaj
>   	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
>   	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
> @@ -302,6 +286,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   		return 0;
>   	}
>   
> +	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
> +		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
> +
>   	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
>   		return -EINVAL;
>   
> @@ -320,9 +307,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   	}
>   
>   	/* Setting AVIC backing page address in the phy APIC ID table */
> -	entry = avic_get_physical_id_entry(vcpu, id);
> -	if (!entry)
> -		return -EINVAL;
> +	table = page_address(kvm_svm->avic_physical_id_table_page);
>   
>   	/* Note, fls64() returns the bit position, +1. */
>   	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
> @@ -330,9 +315,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   
>   	new_entry = avic_get_backing_page_address(svm) |
>   		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
> -	WRITE_ONCE(*entry, new_entry);
> +	WRITE_ONCE(table[id], new_entry);
>   
> -	svm->avic_physical_id_cache = entry;
> +	svm->avic_physical_id_cache = &table[id];
>   
>   	return 0;
>   }
> @@ -1018,6 +1003,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>   		return;
>   
> +	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
> +		return;
> +
>   	/*
>   	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
>   	 * is being scheduled in after being preempted.  The CPU entries in the
> @@ -1058,6 +1046,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>   
>   	lockdep_assert_preemption_disabled();
>   
> +	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
> +		return;
> +
>   	/*
>   	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
>   	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed


