Return-Path: <kvm+bounces-11160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B512D873C30
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CC671F22EF3
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7420B137917;
	Wed,  6 Mar 2024 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JPYOSE/S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B25F853;
	Wed,  6 Mar 2024 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709742408; cv=fail; b=jB/OSYH4MQDR2lp8iDemqjbRQDNukTL/kCJuPVQCQMROvE40QTxHWzx2H9fo8mC6UzZEkv772f1r2oJPotG0ObtQ7ahHJc894WULucszbd3lxP9l6e8j38vnvE6gnhnlnx1/sym5ms/aQ2hBmsMXK2QIxYmZtQADrsgt8yXOAns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709742408; c=relaxed/simple;
	bh=AR0aSMQAsnh/HWJrilP8CedF9anZw168GsnXMVfMU1Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MLG18IOosmWrJBzocxFEhCfV4xXd44J880psrPhBnAXKT9bnny3dLg8Q8zK9ELZaLlj+mzr7M+1te2jcaDKdjJrz92kAES9fGSgYfemqYZJevFvRvGo5sbivzQoBEUA8xbkBCxtibJ6rupipo3XqvI9CVpKqYAN/AYU4red0xJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JPYOSE/S; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuoVcgKC+AJ11hDfdr/MTFFLROTgfjyI/f3fmGTm+gygV2styAsCK106gAVLhbvs8NteEh+jUkhx2lj20Z57p+8hW8cTMu6TlIXVb5jMtTodh1wWA08e0yNuvOMUIg0GAdARFiFpCFIhNRm+CSVvvtq2JgNE/ILI4ItX/5zewdegMqiC89vi8sAkF6a9y6/uDFpp0G81roIeKsubfWYrPveDH3OXs6/sPJ9420VM3WF9oKdMedIC8sor/p/ugr5stRyoZ2PnPGtnotRkj5DDaifZ1xb1+onJ+Zzlz2DEROuUW4KAsJcLPugQNsunHFA8u9bwGM/8eZDty3Xr/0jjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaKdIxJAjCqzfKQMWjCXprbeVh33oeyiG2RoPv8mhbQ=;
 b=CQl13uN5yY5qf7g0YWjRxXfn1FC5arFHYB/5U3WAdHpKok6gWLDqlQsSi59IS+wKx5eV/gV+YJX6HGnVbhQhNHn7ZL+qbIKfEGhOaJw6kaVAo9ZvvlbKjPBtdw4TtC4Xz/+aXOQ19JGgxK7oYUddpG7i1dMXUjq7YIQrLjFslYiTynJfuGalHN1FmCFAgICiOSGLssitQNtzFAtVDFzamwG3h7vCLGlcpQ2J/7nuTexx2ieQ55OAQcJbwlycsK+xLTqj4wzBtFc4WEOVO6WyfajwdzzojxU8bkc59pvFtD9KUz6FWEWrEBqdlHb5kNOpFRygulB+ez2vpbHQIUL+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaKdIxJAjCqzfKQMWjCXprbeVh33oeyiG2RoPv8mhbQ=;
 b=JPYOSE/S5JYEc1YcoMJUSLDf/BsE+dVPfABAK5/0XAU8uI3yPewAiNNrmq262y5UGdeG8rAg52iUz0DF0PoDYpfGyTc5YiEK9aD/UezS4ZQcWa8hfzbbYla63mE8Q5lDRmU16JimQhukv0emoPfj+7OJ3RyN8fSWtu8VZyQb4zY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM4PR12MB6375.namprd12.prod.outlook.com (2603:10b6:8:a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 6 Mar
 2024 16:26:44 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7362.024; Wed, 6 Mar 2024
 16:26:44 +0000
Message-ID: <76744e4b-361d-43ae-9a52-6a410ed57303@amd.com>
Date: Wed, 6 Mar 2024 10:26:42 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, pbonzini@redhat.com,
 tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
 <ZeYK-hNDQz5cFhre@google.com> <edd86a97-b2ef-49e6-aa2b-16b1ef790d96@amd.com>
 <Zee2ogAOl8cR4vNZ@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <Zee2ogAOl8cR4vNZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:5:337::29) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM4PR12MB6375:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fad50d0-2a19-419c-38ca-08dc3dfa3670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JWTaicmSYqORMj5+mvgkI8YFJaR6WAOT9Jn6Lhrl9Z4SN10HTNRMalPQ9MKdpmSx6sTomEWuqudrGpUoHYCxVoLyjgLlK/6uOCma8/fqxr2KCXmSOair0cLZLvDSfybcg1id5q98HZ9fwXlSBCvFLeiz7iXkxQa6iC4ExFEws7bNMb0wWHWyE0xu/Kv/3e9FxG9u/TyeEZ062U4TbzwpRAxxxf/W8py5BHT0juMbhLiIbUnHFL6ObAkt9eXPeNd/K9GeHuZ2W6GIsInxxWI0xumPTgTFNr8wfXeEAqpd3e5pwY1B8ZawXCFFV9ZWnOlxlFS0QjvtOZSVRJgjOja+TKjI/2S//IXUgl8YUEgVnG8W2+bA++jjwOvhGc21t9ioIkMQiI5Sk2zUabi0GChovzEHACTVxyUOszKLM+dhANQgzS54L3lKkI8YqvAyt2W0XeiWIxsmVMf8IIfCCW40Nvz4Y2FTTchZKgtQ7R0rn1vdN6g7nALGcegpA6oYAtFVC0PBHYoDx1k5ghNrejAdUUE53z89uqAHHiAB4DFr+ZM5QW2EiHFMk/IAIyrEBBNkT8dFHyi6PfkRv0qbar6rLYxsua3e9L/rhoYrKTtcUHeps0bLgC/KJUBUG7KKLh8YTisNKfKRVgWG54d51JyElcPraq4AbqPLqQpMpal/+K4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STFoSmFQY2x5WjdvQ0RseFVmMlhNamxBNFJWUFFFek9RcWQ1VFcwZkpZYnZk?=
 =?utf-8?B?UDZCVzZHdTJGcmhQS3M5dWd1YzVqeGlqbXBOTDBZQ3dXR2pxYmtMVE9hcGJG?=
 =?utf-8?B?MHJ1MXJQejRHUFJVeVc3SGxqQUpLNUFoQ0c4UFhRb2VjdXpZSm5PN3c5bzAy?=
 =?utf-8?B?Q21nQUhDbG1QdFZFL2luSDRKVW9renkrN3hWeFdqZ2NLdzR2YURUM3BsYngr?=
 =?utf-8?B?U3pZMmF5WEJvOE5YQkltOEwrL1BTUFJuTU83MThxS0t3ck95VVkvR2YxcnFq?=
 =?utf-8?B?akdYNFk1T1Ixdkh3b00vUjJNODFnNk50a3JranJLNzArSWU3K0NLY3RQR0xD?=
 =?utf-8?B?aUxENHdCMmgzZDhHaXBPT0RiT1JLRUZXS2Z5am1nQ01OR3U5NkhhQXVmcmJm?=
 =?utf-8?B?czA5blUyVWl6WDRyZXFaV3hxZDVUaG9VSllYZG5sVTdzN04vcmttcGpqYkN5?=
 =?utf-8?B?K1BLWVh3NUV3ZDUwZUxOVHJMem9UK3lpMVZyNmY4VzNZMnhkV0dBMXRFUGRw?=
 =?utf-8?B?WnRGV0ZhMkp4WFVid2pDSE1HT0hISDNITFRuMCtJTnZ4eldoVHRIWjhZNm1k?=
 =?utf-8?B?dzh2VFRzaU5LazJaRjFLTFBhblo4M1E0eDlUMlBQQUNjUlNPU1NWMlRFSnUz?=
 =?utf-8?B?NEhZODg1M3RrbE1Ca3FWYkEzT2tUaDQ3R0VabzlPTVpDUXZoV21lYTZrZVU3?=
 =?utf-8?B?YXlocDkzWTBQOWV0ZDN0UVN5VW5TY0lNZHJlZzBWMHFuUVNEUGRJMzViclVC?=
 =?utf-8?B?RnVHa09UNmtlKy9HM1FrZmNRWW9ENTlRRzNIS2NPYlhSSEFhaVNzTDRRVVdz?=
 =?utf-8?B?bUFlUDc3VnArKy96WDZGM1dIK0tjUGhuVElOWmdXZEQ3RUQ1QUNUWHBWQkVv?=
 =?utf-8?B?YkJ6M1J2alp5MS8zTnM1ZEJJK2lzSU5TZFdpSGRDZThKMVNtSko1b1NCQjAw?=
 =?utf-8?B?dVRXOUIwWWF5WDcyUS9kSkZUZnVVUG52bWxXeGQvbHgwNy9JTzE0ZTNJdUpn?=
 =?utf-8?B?WG1pamJWY004K1lhTVhIVWd6RHNkbXhxNk5YQUFtc1NiOVpQNzlGVjloVnho?=
 =?utf-8?B?UGN1V1VJbnZ4N2dtREw5Vzd0ZHZoZyswOHNhanZEeWJEa0tsYXhRYzl4RkZE?=
 =?utf-8?B?em9pRGtHckFWM0JpVDlMWnZ0aDV1UkhjQkdkSnpxdUNzczBtMjNKV3ZwWnlv?=
 =?utf-8?B?MnJhUnUydE50S0lTenR3eGpncWJOZWlObTk0bGpHakFWbkNiT2xEODJCYTc2?=
 =?utf-8?B?dlZmbkpNSjRYN1BkSVhLalNWYlNBMnl4RTgxZi9rL2ZJdW8vWmdNU3pwN3JC?=
 =?utf-8?B?a1EycDVia2M3ZzNaM1JYNmZwQmUwR0ZGOEgzOFIybXlHZFF3d1JrWUh4SFhB?=
 =?utf-8?B?eTNZcWpDeFNKVE5EMUo1SDdsQTlrcERINVNUSmRzMUFGRXc3Y0ZmQlFJL3J3?=
 =?utf-8?B?VkYyOTgvVHVQTmJqRXRST1RXVlRVSTN0ckk0dlNkS204c1FPTnBTWUV2KzdQ?=
 =?utf-8?B?eTlNRm13aXZwZmNCL050RFhWRGcrWkhReEdubndPaTRMWnN2L3YyQlJ4NUk1?=
 =?utf-8?B?N2VjcFBVUDhGcHJ3VUIwd2hOUmtocTg5U0hLOG15UGpxRE1yMDJDYnF1Wmox?=
 =?utf-8?B?elp0UHc4NUM2OERzL2EyeHFUS1pITDMzckRhWXpHMEtUL3RMQlFNTmFCMU9j?=
 =?utf-8?B?REFmOVVKRnBwTkxvcGdBQTk3aGRSek8wUGZ2eXBXSVp3RU03MjhzekV6amg4?=
 =?utf-8?B?Q0xLY1RJUTM3cENPb0w5UFlOL28zWW9Pby8zZFJ2ZFVyM3JHMTU1L3RlV1Zo?=
 =?utf-8?B?UDB1Q1kxRjZPSnhFZE91eTV4enlaRkV4dEdVWjZ4MUZCdWtSalJDVjhNTFRx?=
 =?utf-8?B?TG5LRmxBRWJWbVY3Q3FIbFR4blNiM0lvbU05OHV2cWRGQVl0R0h3bHNPUjZU?=
 =?utf-8?B?V0NOcDJWSFA3VFFaTFFiNWloV0xYcnFzTUZVOWZ5blBKN1ZxVkZ4ei9jQ0pK?=
 =?utf-8?B?c3VwNmRIV1dWYndobkJBbXREUUlNd28yekNIaExCTXNRSGp5TGowMTZzTFNv?=
 =?utf-8?B?VHlub3NrcVBFV2ZOUWtKQjN0V3RMRlArVFQ4Qkc5eW8ybW11VEx1eWF2SkhZ?=
 =?utf-8?Q?BL2b3Hxza8NMLvq8Fn/FqFBtZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fad50d0-2a19-419c-38ca-08dc3dfa3670
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 16:26:44.5681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0DLIAi1G6g6B2ENA/iPNC2WgqoB+rSIH4yIiSHb/8XA7R0Vwce0o6l5wvDUEhPLvp1DdJSPlxiXKzH+0RtGdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6375

On 3/5/24 18:19, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Tom Lendacky wrote:
>> On 3/4/24 11:55, Sean Christopherson wrote:
>>> +Tom
>>>
>>> "KVM: SVM:" for the shortlog scope.
>>>
>>> On Fri, Mar 01, 2024, Zheyun Shen wrote:
>>>> On AMD CPUs without ensuring cache consistency, each memory page reclamation in
>>>> an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
>>>> performance of other programs on the host.
>>>>
>>>> Typically, an AMD server may have 128 cores or more, while the SEV guest might only
>>>> utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
>>>> to specific physical CPUs.
>>>>
>>>> Therefore, keeping a record of the physical core numbers each time a vCPU runs
>>>> can help avoid flushing the cache for all CPUs every time.
>>>
>>> This needs an unequivocal statement from AMD that flushing caches only on CPUs
>>> that do VMRUN is sufficient.  That sounds like it should be obviously correct,
>>> as I don't see how else a cache line can be dirtied for the encrypted PA, but
>>> this entire non-coherent caches mess makes me more than a bit paranoid.
>>
>> As long as the wbinvd_on_all_cpus() related to the ASID flushing isn't
>> changed, this should be ok. And the code currently flushes the source pages
>> when doing LAUNCH_UPDATE commands and adding encrypted regions, so should be
>> good there.
> 
> Nice, thanks!
> 
>> Would it make sense to make this configurable, with the current behavior the
>> default, until testing looks good for a while?
> 
> I don't hate the idea, but I'm inclined to hit the "I'm feeling lucky" button.
> I would rather we put in effort to all but guarantee we can do a clean revert in
> the future, at which point a kill switch doesn't add all that much value.  E.g.
> it would allow for a non-disruptive fix, and maybe a slightly faster confirmation
> of a bug, but that's about it.
> 
> And since the fallout from this would be host data corruption, _not_ rebooting
> hosts that may have been corrupted is probably a bad idea, i.e. the whole
> non-disruptive fix benefit is quite dubious.
> 
> The other issue is that it'd be extremely difficult to know when we could/should
> remove the kill switch.  It might be months or even years before anyone starts
> running high volume of SEV/SEV-ES VMs with this optimization.

I can run the next version of the patch through our CI and see if it 
uncovers anything. I just worry about corner cases... but then that's just me.

Thanks,
Tom


