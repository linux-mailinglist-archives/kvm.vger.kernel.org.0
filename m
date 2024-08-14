Return-Path: <kvm+bounces-24216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691BE952601
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89F6E1C21206
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E9614EC7D;
	Wed, 14 Aug 2024 22:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qbEK0fQs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5AE14AD0A;
	Wed, 14 Aug 2024 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675875; cv=fail; b=S6xDLxxxCzfo41wU+ioDkJiUC4at1fCShRTxwNFSdCsJmIu/S8udAh1eWRPmfjZyDMudZWCtvxRGoeL+d3wZ1Pc68uqPbeA5y4NayS0mk/mPfudXBjsmwBvIFT3lTXwcxBxggpsawbuqbrL3XZaf4OdUOhCKLmbYsnI2br5i6IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675875; c=relaxed/simple;
	bh=voLRmgwCSvvTFN7ADNuKdlww1amNSTgqdheboflUhV0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=ty8bPn1mA/kvtNR8AfE80S9xx3EO++t/YML1nYmkNYzEyrtlRbYv5bToZTJbfMyjzRAmqgJ/03oxptt87TdL1DxnaHNie60y4jUZrGhgiJP8G0usZ98oLq0Fk4b6EYrosuF1u8jR0tqXFOAb3eSN8bdY4OZBEULbgukdJ6em7o4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qbEK0fQs; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xEwgWCXpatXpTZISO8IMQzBXl4QAfYljykxcAdI9o1MCCTf/ZbGLNfnWeGhhJtG3DmQmZ/q1XmTEUV365RhrO6WHB3rQR7zjBAzrhdIUJuAMKJfH/qn6gSpR8p5rqKiJDQJW68EGtoFKN3JBwcET2HbPVW8hnDZlLP+8kh4rLWS47UIySKyawWmWZthbY5BNZlLqSLvhLi4+cbkfqJ2Rib0chFyhkhji4xrQwpx1dLBKoKXizVtH8LUKsGif/gFDR+x2o2ZImzj2OBfZgEsQhOPgSClbshBOc6VK+zlJatHnT6SzXhyOK+t/fRdIpXWTtXHeMRPoaemqBj/Q7ugWtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKHyXz/s097+NSed+5ZPnEd/g477R3QvRAoCNc2JuWQ=;
 b=a00iSPs9QyblEDRuvuoaMRIq2qG9Riq4U8Y1FangOPxDh9/bdgM2+p+sgBNOy4dIhJP5ljERIfB+sBCIxn+H+7DeWC/BdS7viSL2nIbHIn9EKZpS0sGtWkO2rYN/HPNiZAQnsQru8ZI9OnTkCtSj5sUWDjr+8UtgucOk68ubr3AimNxf8CWyAzYYHsebwwavBKB7FTB6lIlOVnI4EYCpTca5zZw7iTo9IJYv/QipOl6ZRfuzlJ0lboe4ZsN9P8Cr1nmdL34SoABGOrvslwJtZGx2LJKBUevg5NExR8Eog18lydAeEsfuPc0BYIZKQMMhZZ7A8lXN3dCxSUv6dlqlLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKHyXz/s097+NSed+5ZPnEd/g477R3QvRAoCNc2JuWQ=;
 b=qbEK0fQsxg/SsdTYaaoAcZV/9xmfJQZ/hlXFkYLUk6ADbynZuNR+VzL9/k8h1ZF/uaIpOkCoNPB3lw5Ptsa8SKvKY+6UWxW+4nc8t6KPt+S2dr12p2FIX2Q3VkAfObaK/+P/tzAQjUAtxKz55BFzdo5mdvJYXsOUSb+SURNw0Uo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Wed, 14 Aug
 2024 22:51:09 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 22:51:08 +0000
Message-ID: <07131427-8dc0-ed47-03af-86060fea3937@amd.com>
Date: Wed, 14 Aug 2024 17:51:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1723490152.git.ashish.kalra@amd.com>
 <e11d4bbb11008ab89982d889b1833e158b8ed6ba.1723490152.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO command
In-Reply-To: <e11d4bbb11008ab89982d889b1833e158b8ed6ba.1723490152.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0184.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5cce82-281b-4239-b2c1-08dcbcb39642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	J6/W2QkUPleB+ywoPQ2CSz0jRlYLyXsZquD4nM6m1MUdhicHlPkjqNcZsOK7+hPeuYT/I5xGEuC+UQiW1pW9HzuutJMIs5/rYP4UFUxswCHf5Fm2rXa+/kXGG+K8t4G6NACUSQMSxU/ixFiDwhM+e0SWnPfrB89/EE86fcOxyowo1wo7AEZmAaKHhBguESzrwUbpzeDFUEAqtcIAjRwz1cXbn4G5aXpdUapTRUkti1Zn58P3mz/p3rFSbW/tM+jUXVK8q+WR9DH8OaMc4ECrRh/xP+XCulvQZAnbXZr4GZN10KheZhqW0vjLN6KCNADZnpEulmeNLmYAxF+fxy7UFMn433G9MfePbN65hJ4Pr1J1haXSalTGhEMfu9XR4y+cbp/WoZTKjGLiVp6EronJlv0iFmO7+nPPw/bIcsIZShgM2bKregok2hnI75zDEhBFKoMYzrLZr7hzwCw/2XcdL/qLXS/TAx202WKqWVfq/2EavLWu3QkngKn8S9qvhz6opD++NV6Wt5AyxQYvQI6I5I9+04f1dl2vz+9L1rRWih9t2qjrKgsDqitzH1jX4LIeeVhsOi+TyG1jOZkIBR3SjVi2FNcER0BP7e5soESc68qmMDR9Kn1DjEko83cVWRiZ5LzYo9skE3ydogXh4YRfedkRKtTMExQYiNhD2MYQ+44=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmN6dnVsT1NwRUxiSmE1R1pCWEZVVzAyRm41dDBVTWd4RjBweXJJQTRNNExN?=
 =?utf-8?B?ZXhKQk42UTJVWlpzbVVEeXFyZHlCeWM3cFJyK2ZxR0ZoODNwYUZkMXN0K2JR?=
 =?utf-8?B?N1hpdUg4TXZXYlFqWTUzN1dDcjFKbWJDaXloOWs3YU9OT3FPUXdNQXNrYXVC?=
 =?utf-8?B?OXJpbklBaUI3eUlqZklPTWhMMXd0RnYzQ21HZWhwUzBLLytZeHVhNmk1UGpM?=
 =?utf-8?B?S2dCN1M2RWRiNFh4SnI2VnltbTA5RjVrQ0lJdDh1NWlkeFdBamwyZ24wdW00?=
 =?utf-8?B?Qkg2blVXQjR5Q05DOVFTdjg4RExISmVGeDdUTXJGWmgvbEFHa1RqTU5OcDBt?=
 =?utf-8?B?UWMwTy9BcTlUeE9xaU90aGtZZW1HNWdpR1E0VXFKMENNbVpRZE5pckZKY2RW?=
 =?utf-8?B?eWRZeVRzWFNEWnNXSjMrZ2UvcmJ4d1Z0c2tzY2t3SDhER3JkcyswdStURVNq?=
 =?utf-8?B?Mnc3Wkd3em9EQlE0cjJLclpQQ0FHUWJMUGpTL0xoajlzRVJGVDFLWUJyaWV2?=
 =?utf-8?B?Z0owZTRJKzB0RXRPT050eENQbjhCVVZEMnJWTitKNXpnT2kwb3BySXZ6VXpa?=
 =?utf-8?B?cUlwT3lGYTBpQzRnazFUdC9yL2dKK2VMcm50bHJ6WkQ1M1FqTjh6K0FEbm1D?=
 =?utf-8?B?cjlUdmZIV2l4L2QvTDM1K0FpY05YMVp4WFNuZTdkWmZDYXhlcEdLNnM5MWlt?=
 =?utf-8?B?TzdBWkFCTUI2QXhhd3dSSjIzWjBtbzVJMWxESUJYMDVuZ04rM3dkS0VGSEpl?=
 =?utf-8?B?QWZ6M0xrVEtmeHpWZFdrcFFXRVVFRFdxRU9QUjV1Nyt3dDhjZnZyM1d2RUZL?=
 =?utf-8?B?NFlMWFNhUjB5NjFyMkxqTHNzUkpQMGFJaEg4VmRvTHkvNnZQUnZGWEg4eHJk?=
 =?utf-8?B?amYzMThJbmJGQUVOdmx2SWdvT0ExdGJhMUdESXUyZjcxS1k3VEhBcEtxcTFO?=
 =?utf-8?B?Nmp4czRTWFZqY2hwZEF1U3RrdnNOSzRIRmo2T3NYaW9MaUtpeHRKZDNHbzB4?=
 =?utf-8?B?U0haN2krbUdhU2FRSDNnTDRGVFRDQTVmT3kvVjIzZTh4WGVGanEyQnB4ZVU3?=
 =?utf-8?B?Y1ZKT3pZMlN1c0svN092aG9odThMMVdzYjFXTWh0ZHhJOUJUc0JKMTR0Wm4z?=
 =?utf-8?B?NnZUK0haWFVUSkdHdVBjYm1QaElhUUJsMUo2NFM3bGFIM09XMWovRDFabGJu?=
 =?utf-8?B?WXRDTUxWMWFkRzFWSVFOeXB1TW1QU3l6TjZ4RUtqV0o2djRyVHlaR3pXRm1J?=
 =?utf-8?B?azJqWGpWWTVKampFZnRwVWVmMDZTcW9jalh6QWk3YW5oN0VKSExuSGk0aWRy?=
 =?utf-8?B?SG0wZDJvUFJ1cmZjL3BWTVlTaXJKZHFTeDIyWGEzR0NmZVZrbzVseGxpTUo1?=
 =?utf-8?B?RStEc3RFUXhmZ0ZhbVAwZzVNLzJoZlNCdWhtV2JZTFVNYVYzYitFQ01US0ZU?=
 =?utf-8?B?Z2RuQmJveW01ZzUydWhvMHVXb0RJRjBpQmN3eTV5dmptT2MrSjZpRm9XbHpw?=
 =?utf-8?B?ZlVHbWRBck1CSzkzK0VnajYySitZV2c3ejBXdmdROXJrR20rOURCcGQ5ODNU?=
 =?utf-8?B?R21hNUdQbnU1WXlGNUtrRTdwMEZOb1lGZ1hTbTIwd1pvekhwMW5tZjVUUzE0?=
 =?utf-8?B?YS90MXdwdEptd29NemhrL2lyaUtRa3NsbVg2SjFDaHlhZHJ6ejBNS0FrTGM0?=
 =?utf-8?B?MFkrZ0xWQ1c5ckxoaTlNVEV0eURzZVJlNGxOMG9CVHhBSTNjK0RWSDVYQkhC?=
 =?utf-8?B?Tis4MERsZ0dFK2VTS2V3UnJKd0t4UWZ4Rno4dm4xcFAzNCsyemFPcWduTmZv?=
 =?utf-8?B?N0U4WFlPcGhWeEw3d2VuakZYZ0pMMU5OdWJuYlZZbm1Yd3g3WlhjUk5HTllP?=
 =?utf-8?B?NFpqeFhkQlJSVzJlZzE0R0tzRVhkVExSalkvaDRwMUlWdlVQY1hKYUtTbmRo?=
 =?utf-8?B?TVNoRzRaVFVUTVd6UThxbTAzbUF4ODBiU3NXUkdSMU9LT3pUTENTWnYyYzNP?=
 =?utf-8?B?VUFrQ2pXMElSRmZNcGNEMHhLbDRDczY2RWdQYXl5VDdTU1J1T1BNZExLcjZX?=
 =?utf-8?B?V2lFQU9aNU0yMUFRTEVrKzZCOEx2KzJhRkVpNHkydXRadmhpOXd4anIxU3hu?=
 =?utf-8?Q?5qw5G1R2loy9LI29zCQJdt5gR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5cce82-281b-4239-b2c1-08dcbcb39642
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 22:51:08.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ILAPDcq2ZC7XTAxGvbnIOkodg5Hn0VKg7RDAudkECIB8fX93xuFtb4pQ21hygoVb5CjICE7NThdaFkuhvaufA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847

On 8/12/24 14:42, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides host and guests a programmatic means
> to learn about the supported features of the currently loaded firmware.
> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
> Instead of using the CPUID instruction to retrieve Fn8000_0024,
> software can use FEATURE_INFO.

Expand on this a bit. This should state that host/hypervisor would use
the FEATURE_INFO command, while guests would actually issue the CPUID
instruction. The idea being, that the hypervisor could add Fn8000_0024
values to the CPUID table provided to the guest.

> 
> During CCP module initialization, after firmware update, the SNP
> platform status and feature information from CPUID 0x8000_0024,
> sub-function 0, are cached in the sev_device structure.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 40 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 +++
>  include/linux/psp-sev.h      | 31 ++++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9810edbb272d..eefb481db5af 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1052,6 +1053,43 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static void sev_cache_snp_platform_status_and_discover_features(void)

How about snp_get_platform_info or snp_get_platform_data. If anything is
ever added to this in the future, the name won't have to be changed.

> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_snp_feature_info snp_feat_info;
> +	struct sev_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	int error = 0, rc;
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		return;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);

This command is being called before SNP_INIT_EX (for now), so this is
currently safe. But you should probably guard against it being called
afterwards by checking the SNP state. If the SNP state is INIT, then
bail or use an intermediate firmware page for output.

> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,

Block comments in this directory start like this:

	/* Do feature discovery...

> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (!rc && sev->snp_plat_status.feature_info) {
> +		/*
> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO

Ditto.

> +		 * command to handle any alignment and page boundary check
> +		 * requirements.
> +		 */
> +		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);
> +		snp_feat_info.length = sizeof(snp_feat_info);
> +		snp_feat_info.ecx_in = 0;
> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
> +		if (!rc)
> +			sev->feat_info = *feat_info;

Above, you go directly into the sev->snp_plat_status field, but here you
allocate memory and then copy. Any reason for the difference?

> +		kfree(feat_info);
> +	}
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -2395,6 +2433,8 @@ void sev_pci_init(void)
>  	if (sev_update_firmware(sev->dev) == 0)
>  		sev_get_api_version();
>  
> +	sev_cache_snp_platform_status_and_discover_features();
> +
>  	/* Initialize the platform */
>  	args.probe = true;
>  	rc = sev_platform_init(&args);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..11e571e87e18 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,9 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct sev_feature_info feat_info;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..d46d73911a76 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -812,6 +813,36 @@ struct sev_data_snp_commit {
>  	u32 len;
>  } __packed;
>  
> +/**
> + * struct sev_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
> + */
> +struct sev_snp_feature_info {

You should be consistent with the other names and call this
sev_data_snp_feature_info.

> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SEV_SNP_FEATURE_INFO command
> + * @ebx: output of SEV_SNP_FEATURE_INFO command
> + * @ecx: output of SEV_SNP_FEATURE_INFO command
> + * #edx: output of SEV_SNP_FEATURE_INFO command

s/SEV_//

> + */
> +struct sev_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
> +#define FEAT_CIPHERTEXTHIDING_SUPPORTED	BIT(3)

How about SNP_CIPHER_TEXT_HIDING_SUPPORTED.

But, this shouldn't be defined until you use it.

Thanks,
Tom

> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

