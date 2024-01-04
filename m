Return-Path: <kvm+bounces-5620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E3E823BC5
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 06:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 384441F26037
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5662A18ECC;
	Thu,  4 Jan 2024 05:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VX+H1pJ6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE218647;
	Thu,  4 Jan 2024 05:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke5ke3RQucadpohcwAcabBt7En+N2cg8Dd3OPkmv8MSnJ/9Iuu7mD6ze43L3mjWmwwYaYahxsfolJ21NRI5TqaeDdczqydKIPu8k4iaVDNR9d3M/9Yfmhyl6utgnxF0G27psmR6XKbIM8BexKx78mnp6vdkGEsSFIoK4AIhaYPNEi4m1ddHOovBVS5TvRYBKwiDqwpYxuuhtvSnsNCuoAdc8ak4YBi8yGyJwcWbneU6co12YE74NVIHxsKsTrKaYxme7LAr/xZhibc4DbUb0WWTusARmt6340qh6HWTVzHT4fUaf5w+S91nV8iScyOx1YFLipmh8BiUuOZmZ2qbuSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlBP/YYshUWyymQu9xUqbjsp8zuxwo1euyNF8oPKM8w=;
 b=fVmHeoiaohzJ/oh5/fdIMexqSSUFXxZtxHxO1/+k5iqJOWHnKZmWQe8Pe8J7mBXpIWvxXlER20pUOcDPabAfL56A3nklHyBMo2v9WhOZMvKCk5CYvEQpDZG5Fe5ulYn/PjblQNcxzvnRmymKzLfhUKq080GGfNvH4Lh4i2AzBA32BZ/roUtNvwqvmL/SOGC/ywEIBi7ioukz01CN9Y0K/MKZj2wzTs6UwF8HDzC58Qa2xEH46MWEDPTPcA5NcP+CWsmNxrfT/VzO/mAnQDx2v9oSxOH0XA+ULT1iCRRSV72hcMzNkGClKCXLVsg3zQmhKCExDmjHkhoFzpKQz74hUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlBP/YYshUWyymQu9xUqbjsp8zuxwo1euyNF8oPKM8w=;
 b=VX+H1pJ6Sir/9EWpHkcS1ftfy6Qz0iqYVAp3Pu7PSW0y/68zGMo4/E880jOrnrSEhm+SGb1yP2x4F+2mNT2rFay7q/rpwZJXmUps6FruK5InnVDt6XVnXobgqix4i7rhtLxseyXC4jbXw5jgY/+Ygh+8/KDr8rKk+QyHd0dOsSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CH3PR12MB8331.namprd12.prod.outlook.com (2603:10b6:610:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 05:28:27 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1d68:1eb8:d7dc:4b43]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1d68:1eb8:d7dc:4b43%6]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 05:28:27 +0000
Message-ID: <e0d349f4-0267-b339-313c-09dcafb14a71@amd.com>
Date: Wed, 3 Jan 2024 23:28:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] x86/sev: Add support for allowing zero SEV ASIDs.
To: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc: seanjc@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org
References: <20240104024656.57821-1-Ashish.Kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240104024656.57821-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0027.namprd05.prod.outlook.com
 (2603:10b6:803:40::40) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CH3PR12MB8331:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ffd919-b467-4e7e-2a67-08dc0ce5facf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2yhc97CGfOWW4k+VqdaxDNUrZ/Os9Z73MZA7fiMIw6DpTIwZRkS7Fbni4y9rz7B+kuzuWStTbOhsSzvFhUglmCK5FkJSjNMYdfWx/PdKb607CKzMf1Smq36ZDtZGpvBVRlBRmMCk5yD0CA5ebItGcn+x+TnnDrod8MCudLblvOg0yu/5tduxoolLOTcPXMX584Iyq1KbDVAgZR+SjvHRSAprJzWdHhkVu8KuSuDHsV8lf9wADZZn2zjRafGq6+Vq0Wk9umDNUAhqk6TrbvVXz1Ogbx/fSkhN51Cdlwn43Mu5tXFpvbkrLBPd6UPvCZ+tsg00YoapTZM8eaSfYTpkmkThjhEgngAmXI+Vj1HoJmgCCI56Y4Y1kMdhoYjCpILyxRVirGGQpd89Z7t0in4JdynICidDMKjLKxogVGqvN6TF3MJ26IXZ6/AYNcRG6RFGVJOyP7JyuYHc0+FaNwBJ8DqnEANyBau/bs6iKiTWF/qze88WbNIfRtYsCLf4o/xDCmQRY8SfQljbc7txkCPPodGtZ6aiRGbffQMcX7gEYfjMf4XyQxPxZLldyYnnpZ9hcjmWWHIcG2O2/fHB8dc81/OkLCavd/b857WcMyVUwE+ieg/gWpzTzXPLddYO7MhzeIOG6PuAmIVGiuSZuuai0A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(396003)(136003)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(2616005)(26005)(6666004)(478600001)(6506007)(6512007)(53546011)(83380400001)(7416002)(2906002)(5660300002)(41300700001)(66946007)(6486002)(316002)(8676002)(4326008)(66556008)(8936002)(66476007)(31696002)(86362001)(38100700002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFlZV1ZUZFcxV3l5VXZIbXZjTnpmeHF3TzBzWFdFcFBCRGs2S3B1S1BheWhD?=
 =?utf-8?B?M3VXdE5PTEV3TFNKM21yQ0hxZkd5U2RzRUZWNHA3ZUpEMm01YjY0LzNYd0d4?=
 =?utf-8?B?UVI5VkVxZ0N1UDh3T2MyV2dPaXo1dWVXcUp2MUgwaUx5VFR3L3c4QThxNjBa?=
 =?utf-8?B?SGZKNUxEWUVEOTU5b2xFQjNmOUNBci9wL01KRkxkdWtpdkNPN0p2bzFMcTI3?=
 =?utf-8?B?dnRwYk9aWnJXWUNoZnN6WWVpOThpNDFkZXpmNzhkZGptNEh3bFNvakQzSU9K?=
 =?utf-8?B?SnArYi9GcXYrMHo3RWdGajBFTUtFRnNZUEl1dkZPMWQ4dmRLUGNlZVY3ZTZ0?=
 =?utf-8?B?Z1pkQjRNaGZzaU5NWWdKaXM0RnZqSkN4NDJjenQyS1FKQjI1bC82Yi9rNkFK?=
 =?utf-8?B?K1oxQ1ByNm1DY0hhb2lVM3M5cEk3UDRwTC9hSHZJc3Exc09JRjdSM2ZrQ3hO?=
 =?utf-8?B?SHZTQXJRb2tsQm03bEVHQ084OEdhdER5cjhacGVNcUljeWp4TnIvN0s2VVFw?=
 =?utf-8?B?aEZYOENGeGpEK1dsd0tJN0JIbGcrb2c3ckhNRWJHMWFiYXZYN3UxWkxoM2NX?=
 =?utf-8?B?UzRsZ1FJS2tKM283VXJ1YXBudDU0MGY3MWhpNVp6c1drellOREVjQ3FBU2Jz?=
 =?utf-8?B?MzRSVG1YYklkNGRleStkY1JNVFM3dGUrUFFoMTlDY3lJVmRNSk9tVHJSMDdC?=
 =?utf-8?B?K0JQQWJRczVBNEhLa3lzTEN3VmN3WHRqWXU3K21TR20rSVlUdXAzbjNaS2dM?=
 =?utf-8?B?dkFHR0ZyNVpOS0wyWHdmU04zdG1GMVkvS0tYYy9BMUR4VUxlQU5SSGZ0eERZ?=
 =?utf-8?B?VFJUekhKdkpqaFNkL0k1Y3c4VDNBL1ZrTjdxeXE4SzdBaXg5ZWlVVDVYNFZM?=
 =?utf-8?B?cnJDeUk5dTIxb0dRazQwTzNMTm90OGFqUnJHWVk5Y1VWY2tvRkFXZStmUHR2?=
 =?utf-8?B?UElMY3BreDRLekp1bTFCa1BJalE3aXZyYmtFK0VmN2dxaUU2VXh1OURkdGlN?=
 =?utf-8?B?RzFUNld4ZS9xUEZ3TmVPWkdSY2Y4UDI2WXdRWGRlTG4wV1RldkJUMXFjV1pM?=
 =?utf-8?B?dk4rb2t4RGJ4VFBkN1JjUUxQS2tHMzNVNWxROERwRnp5QTRiWXZOV3dGdi9p?=
 =?utf-8?B?ZCtPUC9BT1Axb1NuQ2J3Y2t1R2xrZmZXemFVNkNSYlgvRWlOVStodCtZcjZR?=
 =?utf-8?B?K3hqdG5paVR1dHBqSHpUKy9MN09LQ1FiZ2xLNVVac0lCcDFpNEpvYUg5bnBB?=
 =?utf-8?B?OUdVSno0NGQ5SnU4TXY2ZlF1WisxOXMvRXU1ZVRKWW5ZRlNVbkVId2drdjlV?=
 =?utf-8?B?Nk1ENWo3dVBEaHFlSlRETW5Qb3NEZmNNQ25PQ3hOOG0rK0VDQjhoTVZUUUx1?=
 =?utf-8?B?WG5pQ2NMRENUZk1OVjRTQ0pXRGI2U0ZneTJCSGV0UHZ4cXFOSXdlczA2ZWJk?=
 =?utf-8?B?MTdwY0twSUgrQjhaNGF2bzBRZ0FrTUxoY3hxMUVGM0lwQktRdXdHV3FHT0dX?=
 =?utf-8?B?RmVIWFFyWUlCQklsVVl6SGNFNVBQaGhGSDFZSTlKMkxXOHB5cnFYMjU5d2l4?=
 =?utf-8?B?R1J2SDlLNzB3bHJOa0theFlUV0ZzRFp4TUVJcUJBU1ZXc1k1Uy9QS3RvT21V?=
 =?utf-8?B?ZUwxd1BCOUYwSjIyQUF2eVBKMFB1ZVpkTGkzL0wrWlAzT1l3Z3F6SHJpNFNu?=
 =?utf-8?B?OEdvWTJqL0d1Q21hRENYMkNlTldRaU5FOXg5dTVOSTEveUZKRG9Ld0ZpN2g2?=
 =?utf-8?B?U0RRRWJrMmNsUHJhb2FURTdweWJPYjUzN0UvLzZvcGNvRmlhelBaN0lkTTkx?=
 =?utf-8?B?QU1XY0JBV3doT1AwaGcxNkNLZFkyMFpJeUNybXM2SDMrbnN5dVpQU2Q5MDVQ?=
 =?utf-8?B?dkRheTRHVU9RRk9HQ05oSDAxNzJ2d1JnNlRqdFZNVEs4Kzc1SnlkZGJrTjN5?=
 =?utf-8?B?MEZkeUM3YW5BQ0JLajE3RXpHQTlCL3A4aGsyZWRSZzlMTlovQVUvS214VWh5?=
 =?utf-8?B?WC9kd1gyNHpsSnZteG1uQVpXWm5ZQVQvd3FrSk16ZnFMUXRvelAxRzdnY2l3?=
 =?utf-8?B?bWV1MlpZVVovdUQxYzZNSjBGVFFwM3llMEg0cTZ5Yy96RkphY3FsNmtHMi9i?=
 =?utf-8?Q?7REMEKDIx4Nk1wXhliD+3KuiS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ffd919-b467-4e7e-2a67-08dc0ce5facf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 05:28:27.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwOL6MPiGurIK1DipN/B6KFeaZ270FKc2E2fZI+dq8VYs27xtBK57C7uop6rGp9ui/EOSB00REgg9jbxVBpWXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8331

On 1/3/24 20:46, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Some BIOSes allow the end user to set the minimum SEV ASID value
> (CPUID 0x8000001F_EDX) to be greater than the maximum number of
> encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
> in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.
> 
> The SEV support, as coded, does not handle the case where the minimum
> SEV ASID value can be greater than the maximum SEV ASID value.
> As a result, the following confusing message is issued:
> 
> [   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)
> 
> Fix the support to properly handle this case.
> 
> Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Cc: stable@vger.kernel.org
> ---
>   arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++++++----------------
>   1 file changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4900c078045a..651d671ff8ae 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -143,8 +143,21 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>   
>   static int sev_asid_new(struct kvm_sev_info *sev)
>   {
> -	int asid, min_asid, max_asid, ret;
> +	/*
> +	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> +	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> +	 * Note: min ASID can end up larger than the max if basic SEV support is
> +	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 */
> +	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> +	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> +	unsigned int asid;
> +

Remove this blank line.

>   	bool retry = true;
> +	int ret;
> +
> +	if (min_asid > max_asid)
> +		return -ENOTTY;
>   
>   	WARN_ON(sev->misc_cg);
>   	sev->misc_cg = get_current_misc_cg();
> @@ -157,12 +170,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   
>   	mutex_lock(&sev_bitmap_lock);
>   
> -	/*
> -	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> -	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> -	 */
> -	min_asid = sev->es_active ? 1 : min_sev_asid;
> -	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>   again:
>   	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>   	if (asid > max_asid) {
> @@ -246,21 +253,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	int asid, ret;
> +	int ret;
>   
>   	if (kvm->created_vcpus)
>   		return -EINVAL;
>   
> -	ret = -EBUSY;
>   	if (unlikely(sev->active))
> -		return ret;
> +		return -EINVAL;
>   
>   	sev->active = true;
>   	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	asid = sev_asid_new(sev);
> -	if (asid < 0)
> +	ret = sev_asid_new(sev);
> +	if (ret < 0)
>   		goto e_no_asid;
> -	sev->asid = asid;
> +	sev->asid = ret;
>   
>   	ret = sev_platform_init(&argp->error);
>   	if (ret)
> @@ -2229,8 +2235,10 @@ void __init sev_hardware_setup(void)
>   		goto out;
>   	}
>   
> -	sev_asid_count = max_sev_asid - min_sev_asid + 1;
> -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +	if (min_sev_asid > max_sev_asid) {

Shouldn't this be: if (min_sev_asid <= max_sev_asid) ?

You only want to do the misc_cg_set_capactity() call if you can have SEV 
guests.

Thanks,
Tom

> +		sev_asid_count = max_sev_asid - min_sev_asid + 1;
> +		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +	}
>   	sev_supported = true;
>   
>   	/* SEV-ES support requested? */
> @@ -2261,7 +2269,8 @@ void __init sev_hardware_setup(void)
>   out:
>   	if (boot_cpu_has(X86_FEATURE_SEV))
>   		pr_info("SEV %s (ASIDs %u - %u)\n",
> -			sev_supported ? "enabled" : "disabled",
> +			sev_supported ? (min_sev_asid <= max_sev_asid ?  "enabled" : "unusable")
> +			: "disabled",
>   			min_sev_asid, max_sev_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",

