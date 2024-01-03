Return-Path: <kvm+bounces-5597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FC682370F
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 22:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 836D71F252C0
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 21:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B701D699;
	Wed,  3 Jan 2024 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LbVhpjqq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5C1D698;
	Wed,  3 Jan 2024 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7qa7cng4hy4SfH0/Sl/KbS47Hpv8o40RZLkQSZ1C9SlI6tu9TrZ0oVCO2+tvZhwbp3Yq7dlGYGhmeSbJqC/fyWtIiXbTNaTYu0psFuFurcKhBgXC7V8aDm5iboNIyzJLgMCjk0WbmV8Jz+RiIe/4oEUmVxH/BbDXh5y3mDeaxBakVNHxKkG/rraaZ51WbewUEkIiPDJG590Mxdz9KIKmvMeFXtsByQ9AobpomRR8DcnbXYSN4fBowOg2eJaXG033xwAurHG1MJJNrJRZyszt1sNhQZLm0Dh4eGhB8QLCXT1Hs8R++gPnlu68yp2ZcBux18btzK/IBuQqokrS23jCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlh5DB8xxCpxE/VpcAxFHuetaMFKLyv/sGYd7yayp1g=;
 b=X8bANwNQPlm3zJMPCceuz667To3aLdjtW5qHnB3LLZoB5aEYBCM1NB+eYsWcz1PgFb2SOMDkFO1kgxqsJkjaNPhhzPd5ie1HzeblsUQpht0ZXk+ShZWiIPvCdAUVf12fvru8CouDySna1Q6ep40l16WfWc1vQD/18oZmeg3JIPQtJEBtey8YPe5aa84vt5kVn0GwQ7doYh70wfZtHFJpjtDzGRTGdSyHKUwTE/IlSCwL2GhpM4KQ9iQotDc6d6ZSGfCr8kDRo/wdi1+f16XtVPDeX62LN8cae4V8F7c3vBPnOCmEn9HYoOnh1kp2LsqNzDfCfksQciAkYr3M3UPEpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlh5DB8xxCpxE/VpcAxFHuetaMFKLyv/sGYd7yayp1g=;
 b=LbVhpjqqpL0T1gnltfV1Z8cpwIy/LGs1euN3quw4AN02TeguoFZLiQccWiMbcuSkA8EkqvHYMF3POOhRYYp6DcdkDTUKXNrbPJ8Mk3Ws+PKjOrr8KWxQtO/U9dfDCBPEhRw0lgZ1AEIVncavBHT+YzqqoJvUbuajLzB5qczPo1E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB7810.namprd12.prod.outlook.com (2603:10b6:806:34c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 21:22:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 21:22:53 +0000
Message-ID: <864b9717-46d2-4c1d-a84c-0784caf952f3@amd.com>
Date: Wed, 3 Jan 2024 15:22:51 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sev: Add support for allowing zero SEV ASIDs.
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 joro@8bytes.org
References: <20240102232136.38778-1-Ashish.Kalra@amd.com>
 <ZZSqkm5WNEUuuA_h@google.com> <b82bb32b-3348-4c18-b07e-34f523ae93b5@amd.com>
 <ZZXNXNZkCW8e1G5i@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZZXNXNZkCW8e1G5i@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0009.namprd05.prod.outlook.com
 (2603:10b6:803:40::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 0449d4f4-f2cb-4acc-7f92-08dc0ca225ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	azST7i81FlsEeZ7O3n8NxbOOx6J4V7E6b5JG3/ev9vHw9kBM8JL8RhFhNL2SZfeQ7l1tBpewoP+1WVmHfap/nm3vyCA3HiYIW3+AoYI6OuhiTKMgCQtz2ib5Hpbr7Ok5otb6QMWlLOym6VPxm5ovK0PefBz8f35QN5QXYd6Im6xc7VUaZnKA+47iKhuIF1i2R+nJRApiWdP8SUJ5lVczVvPIIvn/Sd3sRwQkl5JWcFnOwJTfJgqPIKd/94n/ASy1YBsXj6lPSh6o/GOt7kRmD/1jsfQ1jlGYnNt6z4rUQf6eYUwdIRNzyl6YHSmA+KRjRPe916+d/m9RIacwxTaRH0v+iEFXag5Z7Q+J3c7p8RY486LEuz4hA1/AFZf6wViAm5pU91OLJoJGTIFI0stfpgnWkWs3Umas0VzyMB1G7mHtbeadcTfYn64L17r3aTfQq22nSyDyru2OkgpmfzNpFPerEacrJcuMm6ivI1txPx2WAtS+2FUJaV5ix/r5fNtggCd6sXlbHZv73mEUMzH22uPOC6pZ6R973aXig+/3eBb1sbxhmK6BS9evHo9qR2rl6+Efj5iGsZGSMKZmP1Rz1nduSPI2lK42ipiNWqLJhwuX4FPkRVhxoSkubWvCQgXOf2BjyQrXPvZkPTBMisQFPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(136003)(366004)(376002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(26005)(41300700001)(83380400001)(38100700002)(2616005)(2906002)(4326008)(8936002)(5660300002)(316002)(8676002)(7416002)(478600001)(6916009)(6506007)(66946007)(6486002)(66476007)(66556008)(53546011)(6512007)(86362001)(31696002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWZEc2pZaWh5UTBLZUZRa1RZQmlaWVM0MFVkODdGS3c2YTY3ckRTdDhUemR6?=
 =?utf-8?B?elliZnc3dnRLZXd4cnh4aUliakdpZmptZ0VObEFYSjlobm9zQitFdGhTREJ2?=
 =?utf-8?B?aU1VMVpMRTZoQ05MMnNkbEZlVm4wYVgwOTBES2hSUVNBaUZ6VXVnMkRtM2hl?=
 =?utf-8?B?OEhZV2NuSTVkMUdRS3Q4OWN1c0k2akV1V1k3L3J0eVFaS05sOTNUS0xCajYz?=
 =?utf-8?B?MkxGYmRrdVFjUTZVWnJIU1lVRzdOYm5STjNuTU41OWRSVnlnblJhcGZpcVFF?=
 =?utf-8?B?TythcEdiZ0RZNUc4TGtmU3AyT3B0ME5WbEtEOGVXU25xY3VmaGpiRWNUMHpF?=
 =?utf-8?B?VFFETGp2QUdFNEdxN1NocVFOaWZQVXltTjRrQXpmSFUzc0R5VXdCTExDSHB1?=
 =?utf-8?B?dFJPL2lxMUZYbWdyL0djUmFzcjBUemJ0bjBWU2ZuOUFtbHhmS0w3ckJJcHJX?=
 =?utf-8?B?M3pxMkJXR0NWRUVta2hKemJmUHJzMG1vdXBOZW9qaElTbnlhaS9iUnFyK0Ew?=
 =?utf-8?B?eHVCQnVBRHpyd21EK1EvUnd4TjhQWkp2WC9NK2kyekJFWUZ3YXJMWUlyMWZ1?=
 =?utf-8?B?bkg2cUN5aG84d056dm5uSzZ2dTl3NlRmQkRFeXdHMENWeGhOc1RmTlNya1li?=
 =?utf-8?B?VktSM1J1NStDSEpuWXlLYTZOUEJCR3ROQ3puK0tMaVJsOS81MkFYaW52amht?=
 =?utf-8?B?eEw4WE5KajNtRzJzYndxOTR3aGF6cDRDSGw5MDhzZTZ5NFBTSnZWZHlOOTRa?=
 =?utf-8?B?VzlKK2xyME96UkhkbGtnaTVlVjhEdkpreXZVOUpnTlJwRlM5TnlrUVVkMloz?=
 =?utf-8?B?c1phcStibnlGelJLRlNoNkVoSFg1RWFJNFBsSDZ6UHJVNlVJSjNLTkZndHAw?=
 =?utf-8?B?RlIrUDhSZlViN1hkdEJXMlMyUzBib015NGdjWEZ0UTFNQ1JTSFpPL0lCZ2Nu?=
 =?utf-8?B?MldrS2oxSDk0ekY4WmFWbWZTSXJnL0RQTGR0MmE5cERZVUZyNjV5UDVPdmc0?=
 =?utf-8?B?bU9lclg2VkZDSUFzd2R1REdVMDlMeldTM3F6ZzE5QTlyUXYwUXpKdkxZbTYr?=
 =?utf-8?B?WUhybkN4OVJLcit4Z0drQS83Y3ZSZUtFTkNWMm42a3FMUy91b0VwalQrZis5?=
 =?utf-8?B?TE0yZGVpSHU2ZGhudjR2Wk5OekxyMHhVVUJhNFhXbE1ya1lqdjlaZE9qbStC?=
 =?utf-8?B?bjZZNUhHNllxV0VTOGhpYjdTY21hOU1BcG9vWUowYnErNDZSR0tTY052T0ZJ?=
 =?utf-8?B?dXdINkpHRUsxeFdJMHZDdmg0MlIyYXJKSXY0RXNtUFRMYW52bEQ3QnlWL0dr?=
 =?utf-8?B?RVNHZVVsVWZWVjlSNm4xQ05ENzdFY3FITHpFQkJQK0czQTQ2OGZTbXZaOWpm?=
 =?utf-8?B?aVFlQkRjdzUxeVcxZGhHTVdUTDlxRjBjOXR4M3Q2SlR5Lzl0VG1vQXgwMkls?=
 =?utf-8?B?SEF6LzNmcmd3VVk5V0dsU1JhTGtKTk1lQzhuZWE3K3kwbDVOb2FvMkg5TEsw?=
 =?utf-8?B?L0RiVTJpdkRTM2N1aVkxNm9Cc0FDVXIwTFdGZ0J1R0VOQUplUFRPU1RNSmwx?=
 =?utf-8?B?akd1ME9CdVRtR1R2bzFtckhDdkNJT1B1dG5BbUh1U2YxekFjdGFXbjFkbTJZ?=
 =?utf-8?B?NTNhM3N1TVdpSjJ4ODQrZ3k2TnpXTElMaUdGNjNRcUJSMXRaV3BYRjhxd1NQ?=
 =?utf-8?B?OUpjVzgybHJYTUx3ZW9CNWtOeFQrVFJDbEhkQjVGN204N3d5c0QvNVFoN25z?=
 =?utf-8?B?cjhkcTZ6SDNiS0JOUFVGVDFYZ1UxU0dxQy9qd2gxUFhaR21TQ0hBQjdzMFRh?=
 =?utf-8?B?YWpUYmdQQWJGWlprdFd1TEdCRFJveHNDcXpsUkxiMVZ0L1U2SG5pYWdZQnVD?=
 =?utf-8?B?bTE4dmh3TGdLRkFkSDlvWDBxdHlGdDNRY0hkaEZLcSt3U1pxQjNQc2d1VStv?=
 =?utf-8?B?ZStiSm0xTkwxVE9zTklCckpOL0NVQTQvU2t4K1ozTFpBWWlObDJZMkxDMS9W?=
 =?utf-8?B?VGUwYWNXSU5lZDZpbjhlYlJ5YW5PWVVrR0ptcFNwdFN5eDRxVzdNY2pEbm1F?=
 =?utf-8?B?Ymc1dk5KbWtqZC9ucXpBTDJpSDQ3bE04cWFpZHQ5USt4TGI2ZTJlS0N3NjZi?=
 =?utf-8?Q?Cb2yvcwuWZh9u8rdtMbD7cOel?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0449d4f4-f2cb-4acc-7f92-08dc0ca225ae
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 21:22:53.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Quv9dHdWho7imK7K7NibSrjB81NshF42tFHlHpLp5ZzoRZP9YIeiIJMLtFfIWJePuE+lGLFceY0Ahb/IMNCvzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7810

On 1/3/2024 3:10 PM, Sean Christopherson wrote:

> On Wed, Jan 03, 2024, Ashish Kalra wrote:
>> Hello Sean,
>>
>> On 1/2/2024 6:30 PM, Sean Christopherson wrote:
>>> On Tue, Jan 02, 2024, Ashish Kalra wrote:
>>>> @@ -2172,8 +2176,10 @@ void sev_vm_destroy(struct kvm *kvm)
>>>>    void __init sev_set_cpu_caps(void)
>>>>    {
>>>> -	if (!sev_enabled)
>>>> +	if (!sev_guests_enabled) {
>>> Ugh, what a mess.  The module param will show sev_enabled=false, but the caps
>>> and CPUID will show SEV=true.
>>>
>>> And this is doubly silly because "sev_enabled" is never actually checked, e.g.
>>> if misc cgroup support is disabled, KVM_SEV_INIT will try to reclaim ASIDs and
>>> eventually fail with -EBUSY, which is super confusing to users.
>> But this is what we expect that KVM_SEV_INIT will fail. In this case,
>> sev_asid_new() will not actually try to reclaim any ASIDs as sev_misc_cg_try_charge()
>> will fail before any ASID bitmap walking/reclamation and return an error which
>> will eventually return -EBUSY to the user.
> Please read what I wrote.  "if misc cgroup support is disabled", i.e. if
> CONFIG_CGROUP_MISC=n, then sev_misc_cg_try_charge() is a nop.
>
>>> The other weirdness is that KVM can cause sev_enabled=false && sev_es_enabled=true,
>>> but if *userspace* sets sev_enabled=false then sev_es_enabled is also forced off.
>> But that is already the behavior without this patch applied.
>>> In other words, the least awful option seems to be to keep sev_enabled true :-(
>>>
>>>>    		kvm_cpu_cap_clear(X86_FEATURE_SEV);
>>>> +		return;
>>> This is blatantly wrong, as it can result in KVM advertising SEV-ES if SEV is
>>> disabled by the user.
>> No, this ensures that we don't advertise any SEV capability if neither
>> SEV/SEV-ES or in future SNP is enabled.
> No, it does not.  There is an early return statement here that prevents KVM from
> invoking kvm_cpu_cap_clear() for X86_FEATURE_SEV_ES.  Do I think userspace will
> actually be tripped up by seeing SEV_ES without SEV?  No.  Is it unnecessarily
> confusing?  Yes.
>
>>>> +	}
>>>>    	if (!sev_es_enabled)
>>>>    		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
>>>>    }
>>>> @@ -2229,9 +2235,11 @@ void __init sev_hardware_setup(void)
>>>>    		goto out;
>>>>    	}
>>>> -	sev_asid_count = max_sev_asid - min_sev_asid + 1;
>>>> -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>>>> -	sev_supported = true;
>>>> +	if (min_sev_asid <= max_sev_asid) {
>>>> +		sev_asid_count = max_sev_asid - min_sev_asid + 1;
>>>> +		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>>>> +		sev_supported = true;
>>>> +	}
>>>>    	/* SEV-ES support requested? */
>>>>    	if (!sev_es_enabled)
>>>> @@ -2262,7 +2270,8 @@ void __init sev_hardware_setup(void)
>>>>    	if (boot_cpu_has(X86_FEATURE_SEV))
>>>>    		pr_info("SEV %s (ASIDs %u - %u)\n",
>>>>    			sev_supported ? "enabled" : "disabled",
>>>> -			min_sev_asid, max_sev_asid);
>>>> +			sev_supported ? min_sev_asid : 0,
>>>> +			sev_supported ? max_sev_asid : 0);
>>> I honestly think we should print the "garbage" values.  The whole point of
>>> printing the min/max SEV ASIDs was to help users understand why SEV is disabled,
>>> i.e. printing zeroes is counterproductive.
>>>
>>>>    	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>>>    		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>>>    			sev_es_supported ? "enabled" : "disabled",
>>> It's all a bit gross, but I think we want something like this (I'm definitely
>>> open to suggestions though):
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index d0c580607f00..bfac6d17462a 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>>>    static int sev_asid_new(struct kvm_sev_info *sev)
>>>    {
>>> -       int asid, min_asid, max_asid, ret;
>>> +       /*
>>> +        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>>> +        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.  Note, the
>>> +        * min ASID can end up larger than the max if basic SEV support is
>>> +        * effectively disabled by disallowing use of ASIDs for SEV guests.
>>> +        */
>>> +       unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
>>> +       unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>>> +       unsigned int asid;
>>>           bool retry = true;
>>> +       int ret;
>>> +
>>> +       if (min_asid > max_asid)
>>> +               return -ENOTTY;
>> This will still return -EBUSY to user.
> Huh?  The above is obviously -ENOTTY, and I don't see anything in the call stack
> that will convert it to -EBUSY.

Actually, sev_asid_new() returning failure to sev_guest_init() will 
cause it to return -EBUSY to user.

Thanks, Ashish

>> This check here or the failure return from sev_misc_cg_try_charge() are quite
>> similar in that sense.
>>
>> My point is that the same is achieved quite cleanly with
>> sev_misc_cg_try_charge() too.
> "Without additional effort" is not synonymous with "cleanly".  Relying on an
> accounting restriction that is completely orthogonal to basic functionality is
> not "clean".
>
>>>           WARN_ON(sev->misc_cg);
>>>           sev->misc_cg = get_current_misc_cg();
>>> @@ -157,12 +169,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>>>           mutex_lock(&sev_bitmap_lock);
>>> -       /*
>>> -        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>>> -        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>>> -        */
>>> -       min_asid = sev->es_active ? 1 : min_sev_asid;
>>> -       max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>>>    again:
>>>           asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>>>           if (asid > max_asid) {
>>> @@ -2232,8 +2238,10 @@ void __init sev_hardware_setup(void)
>>>                   goto out;
>>>           }
>>> -       sev_asid_count = max_sev_asid - min_sev_asid + 1;
>>> -       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>>> +       if (min_sev_asid <= max_sev_asid) {
>>> +               sev_asid_count = max_sev_asid - min_sev_asid + 1;
>>> +               WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>>> +       }
>>>           sev_supported = true;
>>>           /* SEV-ES support requested? */
>>> @@ -2264,8 +2272,9 @@ void __init sev_hardware_setup(void)
>>>    out:
>>>           if (boot_cpu_has(X86_FEATURE_SEV))
>>>                   pr_info("SEV %s (ASIDs %u - %u)\n",
>>> -                       sev_supported ? "enabled" : "disabled",
>>> -                       min_sev_asid, max_sev_asid);
>>> +                       sev_supported ? (min_sev_asid <= max_sev_asid ? "enabled" : "unusable") : "disabled",
>>> +                       sev_supported ? min_sev_asid : 0,
>>> +                       sev_supported ? max_sev_asid : 0);
>> We are not showing min and max ASIDs for SEV as {0,0} with this patch as
>> sev_supported is true ?
> Yes, and that is deliberate.  See this from above:
>
>   : I honestly think we should print the "garbage" values.  The whole point of
>   : printing the min/max SEV ASIDs was to help users understand why SEV is disabled,
>   : i.e. printing zeroes is counterproductive.

