Return-Path: <kvm+bounces-13871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8FA89BA85
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 10:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8605E1F22986
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 08:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4028539FC1;
	Mon,  8 Apr 2024 08:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cQ3k0ZzT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2095.outbound.protection.outlook.com [40.107.236.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89D2A8DA;
	Mon,  8 Apr 2024 08:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712565808; cv=fail; b=N6KeHRpE1D4XWq9qh+a6fVkQkK+5VaI8TfxBfsWuRs2uFXjBZnPEKbjO+iRJ+Oq4k5zsjCZU3k4MoSHRIvCyxH/pDUFYU3gQrl3fC4TfXO7eg5l3YftTq+apjIXNKP+uTk9YagdgECkt83Q36dppg3PEs9ENCPmWGVx+eDQjaNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712565808; c=relaxed/simple;
	bh=6lIqZuHBV1YRTmjLpoGP8s3rN26mEBXYQJem7o3WVOY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mm2AA3ibgbQ7jOhQyUrnGY7Px+WX10ORxwOakHkyTHu57dIorbo5fcGyueQ+IHNGsIGbaFtfmf1QPoev5HkHV8HIHqrWNzw0ViNp5Kw0jzErjS5PlVA9Ed5l1tKPxWbkecG4PWrWSrRLdgtAudDH+nILsohODuD9Ey/D00nleJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cQ3k0ZzT; arc=fail smtp.client-ip=40.107.236.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKYv4IsepqckQ9HxUf1gclikXAtIh1cQmZNYaOTELA9tiOrxLd00PKAQuKStT6/jiEidg5NA0znUjH0vYjtVnfE+AxYLDVwRc8HWS0HvwRU4NV9ntb2VL3cA8T8Mj+NNzm2PwnRKGLAUqoCxbd79XChOU0/L2yOt8ODR2obFr1Y76yorFVY7wPg0u76A677NZ8JiJh2B6LXfvajluKqIEcQwcSN5a+VFE1fSH6myOIUglivmjnKTVL07Kg1zVlLbUnJMWXB8QuwU7jt5C9waC5D94CWB55PFGIWRDgcoRpWpTvvIBGnSsYOCFEiz51cuIB5uViQuWpKIWm//H5wP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAqnrhvvUlTviXfZ2vkxXgeuyJukZ4bmMYL5KYZ9f6A=;
 b=l7WtH8f7SiVH6R7HFvr75VZdpcaqYmbNcvDLRdUaPd0A7sX8o04r952ulmCqo4Oh5iYKhHC/vt8PuFfcx4kUVuQ5KkPBraZGW074E1T+1ZYbVVMktemzsH2U0GNppdBZ8+DWxs/fontlnSbtE2FkN32t7Yqx5v8PDYZkzwaaKKXUPzYxtjou9JXlMWm+GVH7mLXNK8X+T/R+Fv2Lk4/0vGLoSnRwCOIQ6zySHWrLPMt3eYdUqO1vIug7i2vpjbIGrnrNfjY8W5J8cR4ZMccjCFeK649gzxWmK916tbVkcPVkuEIuggujSlktT8cikjj56Dpiilrhya9q9NuapLC32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAqnrhvvUlTviXfZ2vkxXgeuyJukZ4bmMYL5KYZ9f6A=;
 b=cQ3k0ZzT5TqMMHNDTGp2ipBOvYO3oSh2vANlEsm5MHpdLM/QOsZi5sSc19il/dqOwZWDcbUgu8WeCW1K/vcNvOJ5AUvEQBTuGzBRvIsmtL78/wBx2k9c4AwfZChnRoHK+PJoEEkNU/PrUipV9EpVThPXtFNy364+2PQhGUopT4s=
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB8012.namprd12.prod.outlook.com (2603:10b6:a03:4c7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.46; Mon, 8 Apr 2024 08:43:24 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 08:43:23 +0000
Message-ID: <39de903d-384c-4e4d-b020-3f9f0c7c2c0e@amd.com>
Date: Mon, 8 Apr 2024 14:13:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: x86: Print names of apicv inhibit reasons in
 traces
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
 suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vashegde@amd.com>
In-Reply-To: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0154.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB8012:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9vLccw4/YIEyKFeehFy+YksgzDzi+EXolGWQT33zWay9gNmStjfUg2ST9N5SMh591/9wO26Xx9m5PP6fYvGbQJ076WZaqsoRD3aSu/kcr0qC9RjyfSgdgi/TKt62C8LXEreLV+Z+8ukEoIEvzARwKc28W8B1X1Rh8m2wfmIm3YYBh1h3aQbGvg/G3YNOqGawP3x2G9sggymwfjrdDdbSn8p6//O2rbF0X40Puq0CSrLJpqbXFeOv0s7xoKtpJwcmcCc08QipSjBma/uQjwKlXYMA5hVwDA2Y3hrgD6kfeZv/wVBt0huJ/MXjxuNTyqWa/cEKNOsLIleC85dJbuYLSnZaUL3/PMp9ePjtgyEpp/rf+eqolhxy7e5joi/Ts3ykWDDqo1pM+JrVcmz7odQOmMLkjn61+HErOzluBwFCjxVgQRkO5XvEanje6co0PKWvNnJnzp0behLxGjze2cwe7EaC933AeE6I255epbHbX740YpoEoMLe8ykTtBPEaAsZGBggpEdOJC/r9JoBtrAI6PeJFGaX4BJwvakt+zv0ZehxHgiaJC+qspRoAOqhZTbf6MKFWZF1vU9cA3VaKJFrv5kG/FKT+TwR+wD4i79YFxRSLVrfIZkQTBs8iceJ53Lp6qigZTXbK78ue4iJzkb/F30SI5yVj4YS/Ow+jiwpl04=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlhrNWE2U2kvVkpoQnRhc1RlM3NsNTN4NzgydXMxeHBWVkxLVzNBdVV5c0F5?=
 =?utf-8?B?OGRKZDVLUkJMT3B0cys1UEpXNW9weWt1YnRFVTdsZjBDeTA4dU5XMllRaWhG?=
 =?utf-8?B?bHlaY3gzUnhBamMzRi8wMG5NVVpnNk9LLzVQKzBIRlFjeTUvVmpPcDk1WVEr?=
 =?utf-8?B?TUo2RUt6Rm9ESS82TzhtMG1NQ1NrbnZ0WjlMRTJsRmJuYmJHUlRuWDRGbUlI?=
 =?utf-8?B?UjRGbnNaWE16QVgrVUk3eUpWbXhZUWZRRnR0UlZVTDZpL1kzV1FheEk3N1FQ?=
 =?utf-8?B?R0NOWkViTGhLSHo2N2J1Si9TY2lmMGxTL2JrQTJBeVBvaEd0disyaU9lUHEy?=
 =?utf-8?B?K3lQTVM5N2ZseXFzb0JiWW91R1Y5L0JQcVUvYzJudDZENy9mWW1oSjZadFVW?=
 =?utf-8?B?SWJnMklHMkFZUlVmVklpYWVUWXNnV29IRzlTK3hCRWpXRUVQS1ppYWdTdC9B?=
 =?utf-8?B?SUlNWDY0eW5Vemg5U1FGUlZURjF4MzhuRTByR1RsaWhDRGwwelhsdkNuSXk3?=
 =?utf-8?B?T3pKTXYrSzZvVitrZDRDcmR5aTUzZ04vUitRY2lUNVpNV1hwTHQ3RUtTWngx?=
 =?utf-8?B?YmdkRWltRzBaa2wzeHB4ZHM2aEV0cDBVUHJ3dEtUM0Y4dENvbVQ4U0J3cWpy?=
 =?utf-8?B?d2VLNHVLamJWK3JvZ1YvQzNPa1B3WUthSkpURHR4VXZpY3JMekFiWE9oQ1h2?=
 =?utf-8?B?aW9OaG9LNWxhbWtQUGFjYjdaWGRvdGszbTk0eXZSR1NrYVc4NmhQVXc3WjBs?=
 =?utf-8?B?VzMyUkFnRWd4aUh3Sm5INlk1aUtQNjJQMVVETk9aOGNvNXBTbFQzbmRQdHZV?=
 =?utf-8?B?M3R4SVJSTEVROHZVMG1IUTlkNzAwV2l2VVJyQ2QxWnRiWG1nQ2c4eSs4NWZv?=
 =?utf-8?B?SmJVdFdJUkN3Z0hncXBxOHNGa3RkZ3RmeWw4blZ6emhoN25Ic1BKUGJXOEFu?=
 =?utf-8?B?RUtYZEdCSGErUEJMbVVjSjFLeXJ6eWdEWDA2ZitmaG5mdmRnWFJrZStKd0Nq?=
 =?utf-8?B?RzQ5SVhvVFFlK0dZWFZWUXUvcHczZDhUMEp6cVJrS2hDdlZBd2xFalZ0RzNw?=
 =?utf-8?B?TFNVUTEvQ01iMFhhTE1EcDR6WmtjUEl6cnVjNElVazRZdTFnS2hJVE52VGhh?=
 =?utf-8?B?VlZzN1pxL1F0d25WUi9hT21qalAzREp4aDVoL0NzQmZXbnVrcHVMbTgydVpz?=
 =?utf-8?B?UTQzT1VWNVFabEIvc01makdyWWxIb2sxWGlsUE1sSitZYXdmLzIzYVNKMkxV?=
 =?utf-8?B?cW9aUFJpU0Rvbm9KRkxNMUlCK2l0LzFvcjFQL3VIYktOVTNLM0pmNUREcFlS?=
 =?utf-8?B?Y3JqajRNM3IyVStJNDdIRjFRbGJwUmhvYTNGTjBQUERGTFgxQ3g1WXFacUN5?=
 =?utf-8?B?T1dPM2VLbWRJVEpGMXJtbkpDUG1SVlB0SlBLeDhudEMrdTBiRkN5THhJQ0Z3?=
 =?utf-8?B?S0JSVlZKR0NKd2UybWQwb0ZTZHFobmJBaVVlcXgrMFZhdUFHUVJORTBRak9Q?=
 =?utf-8?B?N0pKbHlFZmdzM0hzTGs2TGJ1anlJamR5M1l5SFZHbVNZY0NzN2hUdWdVWFFY?=
 =?utf-8?B?L3pONGVkdHE3cjhYZ2lNQVozd2lleVlqOEhLck5EU3UzcFloSmNNUFpPZDg1?=
 =?utf-8?B?clR3bFJ2UExoUVVoalkvdHphZXJkS0Z6cncwcVVWeGdhZFVsTmJ2ZC9DRm9o?=
 =?utf-8?B?NkF2T0NYSThXeXo5RW85bXNMVDdvSUkvQ2NrUTFjTHBxWU1kUEttbjd6S29N?=
 =?utf-8?B?VnltUUs5aytMMGlnZ1dRQVlLeFdEVzBhQ1M5S3FjcHNTUUlMQ1VYTGJua29q?=
 =?utf-8?B?R1lBZ2h1ODRzbWhNOGtOREFaSnBRN0FHbjNBbG0rc2t3c1dJd3YranpOK3p3?=
 =?utf-8?B?SHowbkQwUnNESlNpaURHZFZsVkdLL2FlWnlDbllBMUhsQWdOUG93cWxjMG5P?=
 =?utf-8?B?dThGRUlCTzNuZklRZWFjTjlsTHkyZU5sbVROdjFvOW1lSEMxRGdyS3NPY1NL?=
 =?utf-8?B?cWFQMWY2bnFULzd3QVZJMTBMR2lZblZaeWhjekkwTEloeHozcWdxRU42aVdn?=
 =?utf-8?B?SVhHUnU2QkI4UExQeUY1OXJCZWR4M0VCUm9HdkVZVENLd21RZi9KWEdSRFdo?=
 =?utf-8?Q?Kp0BAlR+TlTBqqLdyzXDOgr2M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fda206d-8b9e-4f93-fa18-08dc57a7f345
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 08:43:23.8328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X96r2EOU4A+AeGlZl0DFAV+adzwE1ANkQGufuy3Ou3FdsudSFuAzfyS5/NJ1TE91QRyvrzR8kemojBtf9Cdnvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8012

On 2/15/2024 4:05 AM, Alejandro Jimenez wrote:
> Use the tracing infrastructure helper __print_flags() for printing flag
> bitfields, to enhance the trace output by displaying a string describing
> each of the inhibit reasons set.
> 
> The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
> value, requiring the user to consult the source file where the inhbit
> reasons are defined to decode the trace output.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

I have reviewed and tested this patch on AMD Genoa system. It looks good 
to me.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> 
> ---
> checkpatch reports an error:
> ERROR: Macros with complex values should be enclosed in parentheses
> 
> but that seems common for other patches that also use a macro to define an array
> of struct trace_print_flags used by __print_flags().
> 
> I did not include an example of the new traces in the commit message since they
> are longer than 80 columns, but perhaps that is desirable. e.g.:
> 
> qemu-system-x86-6961    [055] .....  1779.344065: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4 ABSENT
> qemu-system-x86-6961    [055] .....  1779.356710: kvm_apicv_inhibit_changed: cleared reason=2, inhibits=0x0
> 
> qemu-system-x86-9912    [137] ..... 57106.196107: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x300 IRQWIN|PIT_REINJ
> qemu-system-x86-9912    [137] ..... 57106.196115: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x200 PIT_REINJ
> ---
>   arch/x86/kvm/trace.h | 28 ++++++++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b82e6ed4f024..8469e59dfce2 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1372,6 +1372,27 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
>   		  __entry->vcpu_id, __entry->timer_index)
>   );
>   
> +/*
> + * The inhibit flags in this flag array must be kept in sync with the
> + * kvm_apicv_inhibit enum members in <asm/kvm_host.h>.
> + */
> +#define APICV_INHIBIT_FLAGS \
> +	{ BIT(APICV_INHIBIT_REASON_DISABLE),		 "DISABLED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_HYPERV),		 "HYPERV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_ABSENT),		 "ABSENT" }, \
> +	{ BIT(APICV_INHIBIT_REASON_BLOCKIRQ),		 "BLOCKIRQ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED), "PHYS_ID_ALIASED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED),	 "APIC_ID_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED),	 "APIC_BASE_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_NESTED),		 "NESTED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_IRQWIN),		 "IRQWIN" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PIT_REINJ),		 "PIT_REINJ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_SEV),		 "SEV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED),	 "LOG_ID_ALIASED" } \
> +
> +#define show_inhibit_reasons(inhibits) \
> +	__print_flags(inhibits, "|", APICV_INHIBIT_FLAGS)
> +
>   TRACE_EVENT(kvm_apicv_inhibit_changed,
>   	    TP_PROTO(int reason, bool set, unsigned long inhibits),
>   	    TP_ARGS(reason, set, inhibits),
> @@ -1388,9 +1409,12 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
>   		__entry->inhibits = inhibits;
>   	),
>   
> -	TP_printk("%s reason=%u, inhibits=0x%lx",
> +	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
>   		  __entry->set ? "set" : "cleared",
> -		  __entry->reason, __entry->inhibits)
> +		  __entry->reason, __entry->inhibits,
> +		  __entry->inhibits ? " " : "",
> +		  __entry->inhibits ?
> +		  show_inhibit_reasons(__entry->inhibits) : "")
>   );
>   
>   TRACE_EVENT(kvm_apicv_accept_irq,
> 
> base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4


