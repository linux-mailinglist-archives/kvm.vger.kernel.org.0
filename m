Return-Path: <kvm+bounces-14168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FDE8A0314
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2C702838AE
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562A3190668;
	Wed, 10 Apr 2024 22:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O2NJv27O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2138.outbound.protection.outlook.com [40.107.94.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE83168DC;
	Wed, 10 Apr 2024 22:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712787276; cv=fail; b=Y7emuZ1oMKCH5B8utgaS7CoSuK9r8cuJTgtYc79Bl6Aq96+TS04Fs5uwwOc8cUrQzCu1h076mKCD9qfzEQQ78Sk7fnREIfR3K6AReAOR44x0n0biTzL6EgqOMjLnpk9MbBQq1fwvyPr0Jx4ukNt8A+SDMTBo0rD1DtfjfXhhMXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712787276; c=relaxed/simple;
	bh=P2KArS8Jc1Is63tOmqxz4pBy68nDOqZm9dwPMkHd+/Y=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=T8tmC8qw++AdSznFzPNRxRXzebD1twDD/xnxcSE55xK4kqVdt0tX6IWDJdNr2qwOZo2fC5Ap8Dq3q2aETijvyI66lR5+AY5AZJ3tWTWVcBaTyRqGMmKC7JyDrYdxv1uL/mHxJb5KPPlta6QZZMZs2G/3IYY9BWAgB0CsjOUHEEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O2NJv27O; arc=fail smtp.client-ip=40.107.94.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbcNLcAguQpmFlIIQ2a+au6hKRqm4I4zrhWzV0jxB3+oCffWdKCXV0aQhXE92ZaHeQzmfjb0YgbfFdL7tcrHT3kDxSB+M/XXLlIOZLafa03MRFkFoVso9dXwv/n3o0xIhLGibBNmlWlkQ3K7B1lsU16jj8gCxsoXvcABBslU2+02u5ei+9ydrmg/SsEsAqlLLgHYQxt/FNk+RARWS86HDp9dyVSSrrDRxDoVjyBDeIot/gmrxU2ilIJ/7KVOAwSh379Gvxe5E8iDWc5X10OmQ74mqFFr7QYLDj2HtfD4mzpfot7JHHhBWH/ACP/5ex74sOGoY33ow2xZp55+j6n/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPwrgdURNdnWwxTClsHh/l10by57f3DRAL0QLO5tXu4=;
 b=h5gQdWVDvNsVYzUAfaMTTr7bVPzh3eib9tUsZyj7CQkQ6w3e6xWMR+4wlzrJFb64miSciGXhQ7ow0d5ZO0Sjt3gzEi2+gknsATSd6SoEw2K8q//9LhyHTodiejGUccubKyIdHDvaOH0JeTxCZVfHd/c/nEPxDrVj/a9aWWEdpFF3VMofduKFP1zw7Gb0QaCYd2JQr1gGGr7PLs1OhpTTtIZyqlbhqCljT5UkC/P6rFy8u2y5SL5NYpo3rVc3JkAd+HzQzni68Dj/ni+ped23DkY+7+78f0El+nkUeaSnDUWYEwQleYtyeHANuHCjNwDkBlLNz7Tr1px2qxPaZBJuqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPwrgdURNdnWwxTClsHh/l10by57f3DRAL0QLO5tXu4=;
 b=O2NJv27Oj4KWW+StkWwk4fKsI7lv3kV3LBvvp+M5tgd+O6iDCPIVgLJYPkFDgqviZZWjOWGZ9u1MCDqOiPyt8788ObSZzBTUf3ZhnHtTiWNRnd4AChjexQE+sc0V1/3Yo3uouxWInsf68zQvdXE56LK5t4C62L26aO8H/Xm6wTM=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB6660.namprd12.prod.outlook.com (2603:10b6:510:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Wed, 10 Apr
 2024 22:14:31 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 22:14:31 +0000
Message-ID: <14943670-54d7-2255-61ae-046e23e58585@amd.com>
Date: Wed, 10 Apr 2024 17:14:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-27-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v12 26/29] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
In-Reply-To: <20240329225835.400662-27-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0067.namprd05.prod.outlook.com
 (2603:10b6:803:41::44) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB6660:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QMsNGYl7GzGp0LedrukVfvmMTzeXvVfmhFwi/pGITUCZaR8O5vPdm1bEy7ApdsM++t25DQ82EEc9UmayNqfIa8U9vLXC9Nh8ZhRDsm602XhbNvDrJwV7aOlAea1p28XkDeQRNTNaeVvYB9gsEfoWkLWFR+n498ouO+TRNi/SiYJ8gEJzaOq845zwPP4h7eB/kxRH2WP0Layg9JmVjSaKrQB0c1P4V4RCYrUMzaYaoH8iBpDuAgsAwpB31XF/GJlt7DKt1XiJUkhEvJ88205sfGi3dlv9jWToc2xDyP/rTpWdi88Nj2HLoLtY1jDmKooELxeum11EkqldOiBnS+fqRaIS+8HNhmzSJGbIfPgN7d9fp43TTa8k2iJ08yZ4oxlGncYPlnxLHaGM9ROdkPhZODWxJLeDCZ/2YjeM81P60fXVc8Zz/9aXyt2WxGZIWB836mXe3nt1Lt+SMoYr3rPx1BVaHX3jUxuC71VHx8WUGITtcgmXnyU/gwaPd4hf5PE+E0ejzek6PPkYeh0GU1L1NsCAXgkqb94O+NURemznEKT2C8wNprebv+qtwgsM1rWvm5cveJNktDbKDcYRAXYZ8DAYtncTCMmJkVCw9SQa0PMCr5/fjZug6U7b1uV3hBs3X71HAGKbgShd++CsKgYOYot7VPuabR2UwdGKs26KUmM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RElwbGE1Nko2UFJDL0I0RU1sYUtLdDRaTll5aTVqUXNmVytBTVFHczhSNkt6?=
 =?utf-8?B?eGI5M2tOak1SUjBlUndOZzdLK095TVNTN1g3d1llN3YybWZya3NzdGhpZnB2?=
 =?utf-8?B?MjVFNFp5UDVxa1phVDFKeWppejlVdmxpV0VzNzhaVG9UWE9RRlI2aExncU5u?=
 =?utf-8?B?NXlVTnpXZ3cvNDZuNk5GNWE4SkFUREtPZVY3c2VNZ3BwVHBPVlFFelZycnh6?=
 =?utf-8?B?eGc4dzNMa0tHemlUY1VjZTNMWmlhWXhRRDY2SXFzTGVoZk5sTUNEemhObVYx?=
 =?utf-8?B?VThHRDF0akMwb2FvcGdoL1lsMTBkSWR5TkFKYjZkR0RNaFM4TzNxSnRiTTh4?=
 =?utf-8?B?dzNVaXFzVmhCN1VyOU8weGgyNFhVMGRWMVVpTEpVWHhYQ2pyb1M2alh1clVq?=
 =?utf-8?B?UGwxcG9BQThqYyt5cGtmK09KanhRK0VNczB6Y1NxdnRaZCtNUFBFbWtxWlNH?=
 =?utf-8?B?cnF5N3JWQ1VkTEFmMGlXZVZaQTlPZWp5QUVkQUsvTlFFSjBhZmJvWnBTRTJh?=
 =?utf-8?B?RUtDMkJQYWRFU09FSm1pdXh6Mk1CSGw1dlhlaUF2UGZVenhSUHJVS0p0UEVV?=
 =?utf-8?B?VWJ1dGFSdjhDVmx6Z21oMElVM21uREsvSk9QMGlzTWNvc3oySWczTDlTUWd0?=
 =?utf-8?B?Z2RlKzRUc0xLUDZNazBIR3FQSlM2WEc4RGtlc1h6TFNtaXlkSCt0VlVVVk15?=
 =?utf-8?B?ZGh2YSsyUk93NlFzM3BLL0NFcDN4SE5BVmVwNU5BNzNzWjQ5ckZyeGZEbUVL?=
 =?utf-8?B?L3FkalMzVTkrblo2c3NTRFRSSWtoQ2lEZm5OUXlmem5zcWthWUk3OWUvY2Qx?=
 =?utf-8?B?UlVldE56cjhqVFlQVGRIRkFJRzBHWUxNQmozbmIxTDdLVXY2elRSdFBWVHJK?=
 =?utf-8?B?TC9NbGUzbFFSVU92TmFUSG1Db2RKV3ZlV3RrVy9uTUJxbUExWUEvbnZLYkZr?=
 =?utf-8?B?K2Z3YVZ2OEVqT3lwZ0JBaXpvb01WVzNKM1lUKytMM0dCY0MzT1NIUDl1c3h2?=
 =?utf-8?B?VDI5SWN0dkY1aXZYKzNudVBEZjVYNW5LZDRBaUErcStKMFZKTTVQb3AvN0pP?=
 =?utf-8?B?czBWb2QzNnFuNmtrT2NwVnVwZGx0SVAvUDA3WC9mSVhlRHFXdGF1dGt1VWhX?=
 =?utf-8?B?Q2F2ZWlPaUQ0RFNveDY1Ym9jSTh0UWM0OFhwWk1FaUZPTVFGUnN5ZitPM2l3?=
 =?utf-8?B?Z1RCc29Oa3lDTnlEZnUvL1BjYVZrbnVicEtld3VGdUh3V2xoMmJXTFNjNGpT?=
 =?utf-8?B?Rlc0cU1QWkQ5RHFMQVFYY0ovS1BLdEUrTEZ3em03RFc2eCt6a0Z3RTY4SlhX?=
 =?utf-8?B?REZ2bjFCZ1kzZXV4NmxFcHNZRDdLMTdUaEN3a0RHcUpiOUxvNzA1NURONFV6?=
 =?utf-8?B?c1VTSnJHWGZ0MDZVZ0M1WVZsMURidXhJRXBxNlhMeGszS2k3c3dxWFFwNEM3?=
 =?utf-8?B?a3ZLdG1aQjNxREtQY3MyVDIyeVJSemNyMDFZalF2S29IbmRWbHJ5ekFHKzh0?=
 =?utf-8?B?NUdPYUc2QUZjbTM5ZFpqV3ZSaVRacXZBS2FOMXVneit6bUdpNzFGTDMxbzYw?=
 =?utf-8?B?Y1NUK3o1eHIyWS9QbU9nRnorS2hYSlhoREVuSkhycDFHcTU4YW5adUNaZENI?=
 =?utf-8?B?OENyY2ZvRnZLT2g1MThZTFJmQkQ1VEFCYWszMXRFU1N0NTFuZk5JK0wrRGUv?=
 =?utf-8?B?OE04ZUc0alNJNk43UDlaVVJGTVVXWnBLMytXdlc2NTV6UlZCOTJCZlRETDI1?=
 =?utf-8?B?d29GVkxLK3llSWhVNjNqSjk5VTdoam85bWY4a05zSzBrdDF2TmV6T1drN05W?=
 =?utf-8?B?WkRrR3pCN3VROHhDWXgvcXRzRlRoYTMyMW4vRllwK3FiM1U5cklPWHpLdTRi?=
 =?utf-8?B?SjdmTGtOWENZRnZ4amVZV1Z3Ykh5VVpiZTlkQmNNV2NDc0plakJIYmJGNHUy?=
 =?utf-8?B?YTd5d0lsSDBPYk4zZTZOMFFIWjVOTGdFN0poVXkzQjhzZjlkK0szWWRrZDVZ?=
 =?utf-8?B?SDV2Mm5Yd2Y0MEdVNGdicHA1Y0RhaGRpUGc5QXNGZmppODdDaTB2WnhPYkNV?=
 =?utf-8?B?SFp4YXZObkZSZ2hpVUJFTUdMRU1LWGorREpOMlNVdjlGOVJnd3RXNEd6eEVq?=
 =?utf-8?Q?8NxOm3C6xHs4awO03WlduKdvp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424bf5e8-a767-4c86-149a-08dc59ab988f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 22:14:31.5077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VxzO3qKox5Z4m2YImK9V/grU1qJFynNsw3jWuolbxSV0lEOi+O1JSEsQm3pZUCKun5g06bTdCq4vnPXFXCp7Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6660

On 3/29/24 17:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of GHCB specification added support for the SNP Guest Request
> Message NAE event. The event allows for an SEV-SNP guest to make
> requests to the SEV-SNP firmware through hypervisor using the
> SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.
> 
> This is used by guests primarily to request attestation reports from
> firmware. There are other request types are available as well, but the
> specifics of what guest requests are being made are opaque to the
> hypervisor, which only serves as a proxy for the guest requests and
> firmware responses.
> 
> Implement handling for these events.
> 
> Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

You need to add a Co-developed-by: for Asish here.

> [mdr: ensure FW command failures are indicated to guest, drop extended
>   request handling to be re-written as separate patch, massage commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

One minor comment below should another version be required, otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c         | 83 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/sev-guest.h |  9 ++++
>   2 files changed, 92 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 658116537f3f..f56f04553e81 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c

>   
> +static bool snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_request *data,
> +				gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t req_pfn, resp_pfn;
> +
> +	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))

Minor, but you can use PAGE_ALIGNED() here.

Thanks,
Tom

> +		return false;

