Return-Path: <kvm+bounces-13996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A4F89DD58
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F13028A7D3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3854883A06;
	Tue,  9 Apr 2024 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IrrlCwog"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D14F8B1;
	Tue,  9 Apr 2024 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712674492; cv=fail; b=CZFrutEG8AraRtWOeCeZKngwS88M8AQjf794Viz0ZxydA9RYImgyKgRcTLUTRiU2eGW9WutIBO8bP9bsg06w+0MGVAMP61K7X71ddjukAadlZ189KisI53DcD2ZfARm/14oVuke0G5tYgXOOj3lwialD0NbCJcKMEZEMzBni19k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712674492; c=relaxed/simple;
	bh=Cz7eP6KgoF9cJ2n1YeLnZbZNgUczQOjQ5wEUku1i/oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ijZLVQfRt3TizFE3vhcfEgHgQhuo6ek2QHYnhuN5aLMvo/v2PHrzlxmS1YF9KL4aP6kHGoc3rYUuYGlSSJiCSB5Yd6dN7SQb4gbS7ldT63qO+TCDG8MjtyLsczugDcXz+cVTFz/v+jBgxpkHKG7AsLO9t7w8ZzzTvljp3/rV218=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IrrlCwog; arc=fail smtp.client-ip=40.107.92.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6UJuMfln2cpqm2osyFcUKiGhwgfURpj/qoFSc4gTEhWBQ7oSVaZCNAwEigP5As+HPJpGlnuDm6zKJLhuKLYg7ajsxE3SCS7qEwzSJhzA4+qUnd/vXZx1zHuid9cjL0zcYwL9gas0wc2MGZvKjYrplGGXg9MJmXCmk+6atjICaQDomsqt4s9TzpkmtdAtDLA3m4xZJr0l4KS3o6dZci0cjkkGWB2jy3DEuMMGfo3Lxrlxfd9FrqfSQR3JAGieTf0uws7/2YwSyz9NSzX+G0Uaf1JcyyprtPY4b+l74hTRI98c9fDq6j3MffZTgsqASqR6It80us/QMEKXSR2i73SAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbEr6xsheAjrUUcSaSga1D1eu8SCv5v+Q484kVMxvLQ=;
 b=XZy3EA3H4WTJ5YhJuYDGCGfFaDCqUFftd8UEDR7ux6bIJDJ2qZXRdtdVK+fNlu0Eh19nHa8nABPlI+0lNEw4pf4KzU2nE/ctMjqSSi8+3qCjqRTdqMzrQNUSYb4it8FlN25hp1CCqJnG7XgBZMOzfN18+dunvWOxejwHdxeJueXVJg1jrWdWfpBT9X36O930Yt65CanWQ9fhBFBnfUo7DV5ZdjD3omJo0azDy0oHj2vzxUh30WENRxP+LDapMCXfOuOkbz1z4f6uMefWQP6M8E6yl0ztLvp5QtCuaEGwIyjBPfodjVzLeR3RDP7fCbqs1v69rdcRYR9V1ublPDmMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbEr6xsheAjrUUcSaSga1D1eu8SCv5v+Q484kVMxvLQ=;
 b=IrrlCwogwX8Dx0Kg8+l7XLykUZ2YDljZuFhp4SVhOVCRwjPGkrJh7XbHiWcGyVvakNE7mdK89fzB0hs3HYAzMtT+l7kL+eNwZ7hW3G2RWEdDfCUldxGuHTumIQTFI6cvqc1d9ANfWy/JHmYMO8T2vIBsJXMpyRn5di42lHT1cHs=
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 LV3PR12MB9167.namprd12.prod.outlook.com (2603:10b6:408:196::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 14:54:47 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2042:e9fe:bf52:2e62]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::2042:e9fe:bf52:2e62%6]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 14:54:47 +0000
Message-ID: <7a2bc921-0784-42d5-937d-6f06773e2af6@amd.com>
Date: Tue, 9 Apr 2024 21:54:37 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/3] x86: KVM: stats: Add a stat to report status of APICv
 inhibition
Content-Language: en-US
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
 mark.kanda@oracle.com, mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|LV3PR12MB9167:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CciNpFdRwx/7Pm/43gfLjaZaqjyKz7nL6a669jxZtedgH3CU35asQ29dgpDSdUvRSrx0432vWOvw2vRxmYt4AQICANfXXogzO1fF0yDGoVfu4t61a+Xo81wwHndi5aR0l/YOfm2G83khVGJlPmJMiM3VIsQLivm/6SyCv+o4TzKg6uDKI/m1+ne/SssYJQiMemcXp+WvwHDESm5V3WsjoOH63AnjdsWB+KosCaeplqWcK0xj2V1Y8Z3om/3HxphGoIlsAa6HVI3Gr3uYsbB7tnzxSy8o5dD9EIwKQBQ300DFlaXi5Vibq/r9zzlAGou+I3TurPXXhXFBroTzZk3nahmADtBkwofzUZSqoouwlTkzv8KvwzcaHsCA+Mep9u4RdnUPAmKzLwXnkV/s60NxGPFD/3+g9h3DMTAGhn9Y/u1R+i95hoyl2ilxtW/je7JcUJP5i/tAZKy/hWnq0i5/YMOBeHfLRqXGR36SePWZUihBEerm3YLkci2ucwyXAbBCI60W3US6owGHRht1g667vJcZ/5MEp0hw9OA/AH/3gXt9Aamf5dcyT2d4xWHXJultGMp1YjSdBi8yDI1caLLxZGI/w7rl9z2PARae8rSXaCiIix+MwEViK08j7uBJmOy6kUYxDoRBYVXvKx9QLN0ZH85HvOQT2oSvrQ/SLMJCy4w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qzd4QXFRRGpyeWZiVlJTK2diMnFVRVhxZWRsa3pLUzZVakN3WmR6V3p2L20w?=
 =?utf-8?B?NzkyMTduelI2NXY5RFJUQUNqQjVKbVU0VU0zaUhuWUtPbU40b1lRQnJEVStH?=
 =?utf-8?B?ZGVxZjNMMFdodzZ3bHNONEorNzhNR3ZFSjh3ZUIyZzN1LzZkQzRDOTFSa01x?=
 =?utf-8?B?T2FLVWhxK1dNQnBHVlY2dFBKU044a2t3aUw3S2JEbUMxVEQzdlVIZ0VQMGdM?=
 =?utf-8?B?bXJ5cldRN29xdDFKTXkra3lIYldKbDh6bEdRVTZUMi9IOVdTSlM0RE4vdVhC?=
 =?utf-8?B?U0NibDBTenY2c3ovdHh4SXFOYlVtSlBNa3NoU2YvRk90RlBqSk94WG5Kemwr?=
 =?utf-8?B?cmpDcENkZXkvVTdVM2t1dWpiblR4bEszK3l2bDBqNVRtbEpUK1VoV21EcExX?=
 =?utf-8?B?aXFqWjVhZUdsY1MvT3JTZVRqdmI2eHF4NXJPMUVrQjNhUnFPNGM4WjU3V3Y5?=
 =?utf-8?B?VGlEN29LUVd2OGd0cjBuR1hteWEzeUloRzZEeWFYYTNKMGZlZ1d4QzZQRHhD?=
 =?utf-8?B?dElUY3ZWRjNsL1lnY3UzTXV1d25ETzlybWg5Zk1pMFg5ZjRYY3lsSWtEcGFE?=
 =?utf-8?B?Y2ZOYWI5cXR3TUhmZVJsMGdqMTU0NnFoa1BBZ081bmNBaHRJdEZvUzlSNzJP?=
 =?utf-8?B?Zmw4M3dlQWJZMFhLY1BvakN5S2lOKzE2S2FDSXpvUVhEVUxQN3VuNys3SnV0?=
 =?utf-8?B?SjNEUk1GZklZKzY0dHdHZE1HdWdaeHJUcFBVWDJkdnZFTGJ1UjhqdFlpbVJL?=
 =?utf-8?B?TXQzYkhsZXg1bzVFTnpjKzU1MXg0MkRyS3JMc3A1bng0QWpOS1o2Y2JaL3ox?=
 =?utf-8?B?cUt0blM5VnBQV0NBRUlUSUU3aHV5YzBnK1lvNGpFQ3F6bmVSRnozWFBudS9z?=
 =?utf-8?B?SzZKaEIzREIxc1NaRjliOVZhSFRIemdqbXh0cjFmMWVvd2lNSHF1Tk5ISC9X?=
 =?utf-8?B?TDJVNjFGditmUEFoTGhUUFB2OUxnVVo4K1NMZnRLL056TDVlS0NVVXRPVFp3?=
 =?utf-8?B?Y0k0S3YxR1BkNVVzdEtCTHVDVnVlbExBNWMrdVl5bU5YTldBR1pYNmhYL0Yx?=
 =?utf-8?B?OVh4dmI3S05qbzNkY1B4ZEJjT1FZVTEwYWdhY283eG1ncERwd2FsTHVYQjRs?=
 =?utf-8?B?cG9lakovYWx4RWJSaWVzQ1JsUUVjOFA0RlVWcnJJaXEvT3A1UWN5QzJRMHBH?=
 =?utf-8?B?dys4VVJCWG1EamlmRlVPYVBXZ3JIQTEzUHZlaVZNazI5Y04yZ2NxdWkyV0Rh?=
 =?utf-8?B?ajlMWVlST0sxZm95NnFoY3dFV050OHhaWnhHUVVoZ2JkQzgxOU1FeXVSM2Qw?=
 =?utf-8?B?N3Zha1ZCUzFUNG5FWnZoeU8zWXprelFxanNrL0VnLzFuMm10ZFBDUWVLMEt6?=
 =?utf-8?B?b3FsUi9CUDlDd3ltWmdIRVNOVWRCL2EvTlhhQWRZYm1oaG9ySXBITjVNVHd2?=
 =?utf-8?B?SjRyVGdyQk5OOW9LTnRRWGk4RDFhRzFoalVBQlpIaUJZOXMxc05FcCtSa0c4?=
 =?utf-8?B?Vktsam9yOXFaK2RxdHZkQ0laWXBNSlduTXc1WmpscndGZllxM3Y1aDlFaDY4?=
 =?utf-8?B?bmw1N2g4Ky9MZFBZVWREZERwbTNBSmJUNXdTU05GMVpOclVNOTEvMHprcHVl?=
 =?utf-8?B?VURkTE14RHNWQzhNbnZBSUIvci9XTkduSmRvdUFQNWFMVGpuZG5MUmNiMDNI?=
 =?utf-8?B?TENPZ29HWkVKaGlnd3ZTQ09FdStuQ3Q1Q3U2eitSL2JkMWdBalBXdXBudXQr?=
 =?utf-8?B?alZTZWxvbEZBUlpyYlBBTWtFZ0lPcnIzSnpOK3NNb0FCOTlFUlF0Z21JV3lY?=
 =?utf-8?B?SENCeVFFZExlcXIyUXlVZS9jSG1CWmVWUGkvTUxaOWJrL2h5NjcvTDE2VnpF?=
 =?utf-8?B?K0xBYVJTYlZHcmh3dExibjVJSm40eXBodldLYlFpVWwwZDExbnVZNHcvZnY5?=
 =?utf-8?B?L1ZFbXUvYTFGckhTZFJnT0hjeVg4YWN3WkRad0hRbklVZDIrRFg5dDNDZlVX?=
 =?utf-8?B?cnlyWHZZZHFsWlh0YUZHa1M3KzBUenFpSUNlWFZIWWNvQWRsaFpjYWZBYkRL?=
 =?utf-8?B?Q2JGS0Q3RGhKTmhGc0o0bFZOZGIwTndCK202M2syREJtVGRTSEtYbENOZWxl?=
 =?utf-8?Q?tG2C2G42N4Y1hdqHi93dUWusG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edfe0f8e-a756-496e-a682-08dc58a4fff7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 14:54:47.5100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RO/BYVkezZ2aNHZxeOJJaRUJz+z2n7Tk0BvyLV8to8fEdIwC2nuVHRXYfBl5kcsq3X2qiqP7HvY4msDLiW10HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9167

Hi

On 2/15/2024 11:01 PM, Alejandro Jimenez wrote:
> The inhibition status of APICv can currently be checked using the
> 'kvm_apicv_inhibit_changed' tracepoint, but this is not accessible if
> tracefs is not available (e.g. kernel lockdown, non-root user). Export
> inhibition status as a binary stat that can be monitored from userspace
> without elevated privileges.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 10 +++++++++-
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad5319a503f0..9b960a523715 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1524,6 +1524,7 @@ struct kvm_vm_stat {
>   	u64 nx_lpage_splits;
>   	u64 max_mmu_page_hash_collisions;
>   	u64 max_mmu_rmap_size;
> +	u64 apicv_inhibited;
>   };
>   
>   struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b66c45e7f6f8..f7f598f066e7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -255,7 +255,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	STATS_DESC_ICOUNTER(VM, pages_1g),
>   	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
>   	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
> -	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> +	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> +	STATS_DESC_IBOOLEAN(VM, apicv_inhibited)

One use for this stats would be to help:
1. Determine if vm and/or vcpu is inhibited.
2. Determine the inhibit reason.

Therefore can we use STATS_DESC_ICOUNTER() instead of 
STATS_DESC_IBOOLEAN(), and show the inhibit flag from

vm_reason   = struct kvm->arch.apicv_inhibit_reasons
vcpu_reason = static_call(kvm_x86_vcpu_get_apicv_inhibit_reasons)(vcpu)

See kvm_vcpu_apicv_activated().

Thanks,
Suravee

>   };
>   
>   const struct kvm_stats_header kvm_vm_stats_header = {
> @@ -10588,6 +10589,13 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   		 */
>   		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>   		kvm->arch.apicv_inhibit_reasons = new;
> +
> +		/*
> +		 * Update inhibition statistic only when toggling APICv
> +		 * activation status.
> +		 */
> +		kvm->stat.apicv_inhibited = !!new;
> +
>   		if (new) {
>   			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
>   			int idx = srcu_read_lock(&kvm->srcu);

