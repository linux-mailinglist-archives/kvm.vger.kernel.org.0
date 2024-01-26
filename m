Return-Path: <kvm+bounces-7238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E108583E4E0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FDFD1F22BDF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCAA51009;
	Fri, 26 Jan 2024 22:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gmp6me5v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FD50A9B;
	Fri, 26 Jan 2024 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706307080; cv=fail; b=phLJqTcmyz4JqbwceBrCvuWE+ueq6F0GBNcgGBOlVrXSw4otl2FYnoCuTS22sE2KBLjOHMZ8fZHzokcKCJHREB25jdilRAhNLmHJp+NZo0U3TOGYhLqGZQWW4KZBCXS+nUCfmXscH+ieEPzmwzt2Y60LFdO2bZUn0y+MtHe202c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706307080; c=relaxed/simple;
	bh=KaAqVIxioAWfLaxxgkDvI+w7m6OSuCDz75OpVr4pwes=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r7LMqWrkRGKeKrbBdQ19NFQRetSsSL63MolorUzHsCFh47YoUGi3CTJ1Z5G/XjAL006G3vHFYZs90eZiU6fV5vDi0yOSSssGPMVXX7pGcyXFvkK14yBsLhuKPOZdePSwoM8JulVlOg1Jq8CpybmVgkG5lfN8K2CAnrd/A+LsGd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gmp6me5v; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+Ocmiq0yNaIWjOEE5CAwWiv0E+myMi2mG8wA4EJZX8+Meb9IQk1ZHlJdLwMMkfFvH1YbJE2ChH8YGbJevZFHNGY4rX+TrqF8n19aLvvcoQYnp7ZRttgqmfHdXufy9CQibXCYMGbCoBCqafY07cEx7msysoGVoNIHdpPzgQwtQXl2RvHblONBxXuyG4zw4AAsgUxy5vSoai+rMp1vwSxS3JbO38CxjdZSmjdIF6YfJ2kD0WULlLz1o2bJI2JkAJBTwrYZ/SN4+9yoMkg6ZTJAnxzEmB6+jfGxNYStqK6nSTv6wvirdGOwzJjbJm23ysyWSPDJSptiMWBU/JTiIUSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAZNIsMrtlluLqeDHpluf5YDg9+gPi+AP4H7IIeGK98=;
 b=jqWSdrirGbnXjfsJAv/boXBpt3yzuHSw53i1C262GHV1rDql2mpzYWqZAkN3Pvye8yRzyQCPNQ25sIn5b8YBwAq/TX7SQ7ZtHQOmHV55zbw2lpvBWxYI8VdLNh2ns0JpkHhQNqUptPrwhi+yOntmdVozktiKmY98PylUQ7aUzu/zAxiIkZwJVxPY+pIbCw33OLX31FXMfJ/uE0i/jRjskmVt956h8o/GwfOkJPey+F1BottBeYB+k1qOH5rbd3/S6yUb9wdL89w7eq8P6ij304Fcaw00TIS6JlIUxHqKLkr/k2/H/jAR4VTdrIlW91fDKDEVtZEAC7iPaSeDYCAMVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAZNIsMrtlluLqeDHpluf5YDg9+gPi+AP4H7IIeGK98=;
 b=gmp6me5vZVFEcNr70QgNXDWEc5S508XsUdLabW8R2ogWFb9YurbGWWMf16zMZs//ddoDgqmVBWrsXnr8bb/LUN2dZW8K9k8hbWN9wMgCBlDkaNc8FRwV7LZH803PDlJL1dmi3BWblDupj3Dgc6BAELemTif8uZwDw7hXRWXNCl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CO6PR12MB5473.namprd12.prod.outlook.com (2603:10b6:303:13e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 22:11:16 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 22:11:16 +0000
Message-ID: <47bbe1e6-e9c6-cff8-987e-e244581f689b@amd.com>
Date: Fri, 26 Jan 2024 16:11:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v7 06/16] virt: sev-guest: Move SNP Guest command mutex
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-7-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231220151358.2147066-7-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::14) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CO6PR12MB5473:EE_
X-MS-Office365-Filtering-Correlation-Id: bfe73e8e-8166-42e9-afea-08dc1ebbb734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U4To2KAPJKiE46qTtvf8bKb/MJmZuHuQQ7yL0ZibYpd+4UUltwFukibToqbTmX1OMUbWBd+PgR4wNPsVFb71haHV56WaCxCLCphnwM079j934QgnI50eTDJ0DFrusXiWJf4Vl6Y2meUUiiAulmxPm0pOogaRm+rYY0zpJ7DckBnAQSPqpYcbKodIR5LpzuYG4abTioZlDsk1AByC8x7aMUQ1kyRzvYIOxFjYrxKJCekdnjXsJhSp1KL+LEJt6tCXkcXmjPke+Zw+UYbxJhvK5QniwyWYaoBpY8nivoXlKukmb0XLRo5oUz9k8TX2wN/CWAGnfvfiVU2cl/Y/+/sVSpdZJIHydp4qTwJ36rWcplRLhRT9i/ZiwiFRhzi5Ze4VVw6I/sIygvnqHQyXuLi8Ck6FIyq4gq/e4JH03bp5WkXCwvHPCeIWaxKlcnK9kibsCbUGa+uTuvwqPSSNJzlyDsSGk3QLZGE7u7JGZt0hcd02yJLLm+35GmZlFUNOSHwdfE/xVvDgbrsIcrP7GyWP22ZugMTK0YU73dsGW6vBwDTsnOwxGCJ3lgKdEQZes+RpwhWqXWoIok7/9GYgCdbzUh+5bgYq2KouLLzjANtI6RPVYA0h4ymKoKa93iTdWVESudhblj5UqcIzCxAz25tDjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(39860400002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(478600001)(38100700002)(2906002)(86362001)(31696002)(36756003)(41300700001)(316002)(66476007)(6506007)(66556008)(6512007)(5660300002)(66946007)(53546011)(6486002)(6666004)(83380400001)(2616005)(4326008)(7416002)(8936002)(26005)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmlFeGF0N3pic1RvUC96VGk2ZzhxV2xDMFJ1VTRKVGc3SCtndFRuTExmNEJW?=
 =?utf-8?B?cjdsWEsycG9qdkR0Mm5wcnRaYmJ3Q0ZYZE5TM3BoZlBWTEt6THJMOWVsamFD?=
 =?utf-8?B?dk5RLy9NUEsraXFPSVRjMFdFV3ZvaXd1N1Vwd0NzcnR6aUJIZ3Z5bDlNUEI3?=
 =?utf-8?B?TFlTVVMxb1ZtQ0tPTnIvUGN1dkE0eE5JQ1lmQkxtak1YeHZ0Ym5UY2JSN09l?=
 =?utf-8?B?OUZyOExWNUVFS1dNUjFkV3Qwa2gzbzFEV29Jb0F2Zmc3NWJvaXlyNHRrTEJM?=
 =?utf-8?B?WW5XK2twdjJZaFgvL2pOam1CeXplZEVtU0dybWF5ejhXMmVCUnpoQ2o3RHpF?=
 =?utf-8?B?Q0pTdElYS21CbHRBL1Yva3lkdjk3Q0ZjQjhFK1RTbm4vTkRuT1NzaDQ3b3hz?=
 =?utf-8?B?SE83ZlR5VmpkK25WSFU5ZTgrVm91Q0hzTlA2OFBtbE03VHN5ZGlnNGkzUHNI?=
 =?utf-8?B?d09GQWZkd1ZNNDhnbU5TTk02ZCtoaEpkN1ZjbElnako0cS92OWFGdUlvZnlz?=
 =?utf-8?B?K1VwUDhwZkxRNENoSExmZ3VUdlpycHozQ2VldDdPL3d4Nm1zZ0pPVkVnUkgx?=
 =?utf-8?B?UTJ2Ly9pMWhqUmRCd2t5MFZzUkJYa3hGUVYvZzBBODRHNjFCRGpFM2Y2R1NX?=
 =?utf-8?B?a2FpajlYTHRRWTl0ZmlNc2h0S1J2eE9PeE4yUlRPc2JMRFlRaHdIV0NoQW9W?=
 =?utf-8?B?aWNhTVpHZytTZFROaS9TeFJhcnpFTll5b29QWGQ0NEExNFZ3QW1nNUJmZ2pj?=
 =?utf-8?B?cTQwWmJCNlR6VUc3T2pWdGRjSmpOVi9qbmcrTUJOTTBnS0lHQXV5MjhialVj?=
 =?utf-8?B?Ti9PeWJ0L2lHc2I0VGs4M1RnRmtSOXMwNW1ZQlkrRVE5Y0JxZU92bEtBQlU2?=
 =?utf-8?B?VENQdmgzS015ZGI4dEN0RWJ5Y3o0eWJRMzNPRGF2eTdIbG9UR1ZyQ0hnczVG?=
 =?utf-8?B?RXlQZ1p6RHp6dGFtVi8ranFWT0dnWTV5SU5YcnRqUFVzSzNvaDFmakJPV0dh?=
 =?utf-8?B?SndhV01zalMzMUc4SUhCMVZJRDFWdDk0N1RYQllzZ21nOC9Uc2hibzVTYlhr?=
 =?utf-8?B?dmtmekRkOG5oc2V6YlcyODM0MXBBaDE3WVMwbStXTVRFd0YxMnYwN3YxRnRC?=
 =?utf-8?B?cVhPVUltWDJJTU5uUWdFMFJNSXhQeENHdzZFK1JMdGplV0sxdERTMHpUYVRl?=
 =?utf-8?B?SGtYV3ozNWttZnY2dCtaL3hHOGw2UW85R2FGVXFBYW02anAyMGhqUldNTkt6?=
 =?utf-8?B?ZFRveHY2VEE1VFRkU3Uvd2hmT0lTUjMwZ3kwcjlxU3MzWklTeWNpSEhGNjhw?=
 =?utf-8?B?ZXRnbGsvejM3amF3cUhTVk9rQzRRTnUvbnlyc00xbThDNHZza1RvMW9Dc2Fa?=
 =?utf-8?B?bkcyOWdDSWRJVGRSVmtQM2JIbnkwaE50TDJNVHBIVmROcTFkSGtncmUzbFpD?=
 =?utf-8?B?YmNndkFvYkJLOUEzc0tnQ2RmbG5Ta1M0WTcwdkJEQ1ZmWWhEZzd6VlFsaDlY?=
 =?utf-8?B?aWwyUmxidWhYNWloQTg2WFp5ZlhMRDVEeUxiak04MGFuVkhiZ3g5dzVhaWla?=
 =?utf-8?B?aVpKSkxTVFRtdENBSG1jUnFsSTdmQjZxY2l4dmhVMld6T0lQQ1F5RzNScUtB?=
 =?utf-8?B?cVJqM01IVEIvZjhlcllFMVZTR204OGFLUHB0cUpQaERaempqTzhBRkJFclhP?=
 =?utf-8?B?SDVIcUxHMlc4TUxOS2g1U09IMWRPU1lLQ2s0aFVTbElPRHUyTTY5bDdVdU5G?=
 =?utf-8?B?dU1TOW9zTVhUUWVIT2M3NEJuV0tpd1dVYkw0eTJrVHlqbCtMQ0R6S2RkK0VO?=
 =?utf-8?B?VzNVQlF3Q1ZTSnBFa09zeGxvdDBHcnlqcjlydmc3RnhaYnUwNGQ5TWd5alg2?=
 =?utf-8?B?dmVTTjhSYU1SVlQrNGFYSGEyRi8wMkFlVjcyU1JlVWRDSW9wUW1KZTdJZEwr?=
 =?utf-8?B?OUVmMVkvbm9weldNRXp4VGxPNWx5TjN4TFFEMUMxWE1mK3hKaGQ2cHZBQVZK?=
 =?utf-8?B?cUdpa252dGlCMlN5QWxzWXZCYXFEY1U3OW56UDgrcFR3L2N1QVdXcjM4d0Nz?=
 =?utf-8?B?VzFySUpWUWQybWZVbXJVREMvcHc3NVNNRHZOak4yZ2lpUGt4MGRVZ3NMZSs2?=
 =?utf-8?Q?Rejrh5PKeAVJkXgYRn7eybAO7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe73e8e-8166-42e9-afea-08dc1ebbb734
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 22:11:16.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNMKJCz2aF0c3VNIyUUxmWYGbFIcn5YClSVKdc6Pz/ctF0MWJ8lNnOFuA2njULt1agCrkORt5CohQJJlYuUPVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5473

On 12/20/23 09:13, Nikunj A Dadhania wrote:
> SNP command mutex is used to serialize the shared buffer access, command
> handling and message sequence number races. Move the SNP guest command
> mutex out of the sev guest driver and provide accessors to sev-guest
> driver. Remove multiple lockdep check in sev-guest driver, next patch adds
> a single lockdep check in snp_send_guest_request().
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/include/asm/sev-guest.h        |  3 +++
>   arch/x86/kernel/sev.c                   | 21 +++++++++++++++++++++
>   drivers/virt/coco/sev-guest/sev-guest.c | 23 +++++++----------------
>   3 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
> index 27cc15ad6131..2f3cceb88396 100644
> --- a/arch/x86/include/asm/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -81,4 +81,7 @@ struct snp_guest_req {
>   
>   int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>   			    struct snp_guest_request_ioctl *rio);
> +void snp_guest_cmd_lock(void);
> +void snp_guest_cmd_unlock(void);
> +
>   #endif /* __VIRT_SEVGUEST_H__ */
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 6aa0bdf8a7a0..191193924b22 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -941,6 +941,21 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
>   		free_page((unsigned long)vmsa);
>   }
>   
> +/*  SNP Guest command mutex to serialize the shared buffer access and command handling. */
> +static struct mutex snp_guest_cmd_mutex;

You should probably use:

static DEFINE_MUTEX(snp_guest_cmd_mutex);

That way you can avoid the initialization in snp_init_platform_device().

With that:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> +
> +void snp_guest_cmd_lock(void)
> +{
> +	mutex_lock(&snp_guest_cmd_mutex);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_cmd_lock);
> +
> +void snp_guest_cmd_unlock(void)
> +{
> +	mutex_unlock(&snp_guest_cmd_mutex);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_cmd_unlock);
> +
>   static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>   {
>   	struct sev_es_save_area *cur_vmsa, *vmsa;
> @@ -2240,6 +2255,12 @@ static int __init snp_init_platform_device(void)
>   		return -ENODEV;
>   	}
>   
> +	/*
> +	 * Initialize snp command mutex that is used to serialize the shared
> +	 * buffer access and use of the vmpck and message sequence number
> +	 */
> +	mutex_init(&snp_guest_cmd_mutex);
> +
>   	data.secrets_gpa = secrets_pa;
>   	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
>   		return -ENODEV;
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 9c0ff69a16da..bd30a9ff82c1 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -63,9 +63,6 @@ static u32 vmpck_id;
>   module_param(vmpck_id, uint, 0444);
>   MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
>   
> -/* Mutex to serialize the shared buffer access and command handling. */
> -static DEFINE_MUTEX(snp_cmd_mutex);
> -
>   static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
>   {
>   	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
> @@ -115,8 +112,6 @@ static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>   	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>   	u64 count;
>   
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>   	/* Read the current message sequence counter from secrets pages */
>   	count = *os_area_msg_seqno;
>   
> @@ -409,8 +404,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>   	struct snp_report_resp *resp;
>   	int rc, resp_len;
>   
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>   	if (!arg->req_data || !arg->resp_data)
>   		return -EINVAL;
>   
> @@ -457,8 +450,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>   	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
>   	u8 buf[64 + 16];
>   
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>   	if (!arg->req_data || !arg->resp_data)
>   		return -EINVAL;
>   
> @@ -507,8 +498,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	sockptr_t certs_address;
>   	int ret, resp_len;
>   
> -	lockdep_assert_held(&snp_cmd_mutex);
> -
>   	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
>   		return -EINVAL;
>   
> @@ -604,12 +593,12 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>   	if (!input.msg_version)
>   		return -EINVAL;
>   
> -	mutex_lock(&snp_cmd_mutex);
> +	snp_guest_cmd_lock();
>   
>   	/* Check if the VMPCK is not empty */
>   	if (snp_is_vmpck_empty(snp_dev)) {
>   		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		mutex_unlock(&snp_cmd_mutex);
> +		snp_guest_cmd_unlock();
>   		return -ENOTTY;
>   	}
>   
> @@ -634,7 +623,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>   		break;
>   	}
>   
> -	mutex_unlock(&snp_cmd_mutex);
> +	snp_guest_cmd_unlock();
>   
>   	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
>   		return -EFAULT;
> @@ -724,14 +713,14 @@ static int sev_report_new(struct tsm_report *report, void *data)
>   	if (!buf)
>   		return -ENOMEM;
>   
> -	guard(mutex)(&snp_cmd_mutex);
> -
>   	/* Check if the VMPCK is not empty */
>   	if (snp_is_vmpck_empty(snp_dev)) {
>   		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>   		return -ENOTTY;
>   	}
>   
> +	snp_guest_cmd_lock();
> +
>   	cert_table = buf + report_size;
>   	struct snp_ext_report_req ext_req = {
>   		.data = { .vmpl = desc->privlevel },
> @@ -752,6 +741,8 @@ static int sev_report_new(struct tsm_report *report, void *data)
>   	};
>   
>   	ret = get_ext_report(snp_dev, &input, &io);
> +	snp_guest_cmd_unlock();
> +
>   	if (ret)
>   		return ret;
>   

