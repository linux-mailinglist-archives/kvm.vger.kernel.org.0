Return-Path: <kvm+bounces-3973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B30880AF78
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 23:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F7B81F2140B
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7136159B6F;
	Fri,  8 Dec 2023 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WPEWk8Gi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD3E1718;
	Fri,  8 Dec 2023 14:10:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGR3dn4amyXAj61tWdRUTk4iDDGOSSMZtRO3u08GIzazZ+xOF01Nca3+16FGKD5Zqws42e5W1CcGRg5YqxeAcl4rjP849RG/sUatnmauDJEbjeWpBx+ZNxy8wVmnTuCPXIwkX9YRy4vIrtzi5T1Kcsv2TYXwXd9OkZwYiBb/8j7Kf6zq0FNmk8CgDE8TuRCh2fvQDHFitjlbg+ZqXFFhidXgoop+3SwQxb6E7KgUvH86NERqHmxj/YI25ni7x9rP5X3UDdix586ezrfo4FzqnVNMLHcB/qIxJ3UUFFs3vOzTyXOFV2fmvO00sSFXNB3HPPIWuhKhkXYLsxyQTp2aZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrYVSg00RUAeD6n4ef919rE9BHN1l7P7nXd3UWK0teo=;
 b=mjjFBNZS1uAakUv3X27jOqGz15TcMYoZj5DJs3hqbQGjUpwwittiwVrEO1sGKi7yX4VY3qsGVSIBYj2z1a2KefC32MPRPDJimu8IwY4DKcVwbvHgvj0YGsJkKmvJ/C58yS8VA3kPr0BGxst+TerGgzz/4wiM+wzQ+dWknWo0nJhlmhHsV1xi8tKCEoRq9v7xidVeL+C/BENYKKuX45L8+/8vqjqKqwoy1AIDO/+YVWf9i0Jg9ngSbSnAkY2zx8Qz0auS/I9r+W7wUDpZ0aIJYeiegM4uqBEsSfwyvj05qqhsTxkI0/QbqaBB4QaOa1rq3tSVkLccau294WjOA2s3VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrYVSg00RUAeD6n4ef919rE9BHN1l7P7nXd3UWK0teo=;
 b=WPEWk8GiYUVCPI+/QKzwWsX892kS9H47WQKLwukSUpNfujrkvXDCh3dkuD2kdrCxIc/hWyxCtmxCyZ/zEJ9l8M32a3OmJP13VzzHQ0Tl3HAlSNRdQBalWTjA6QPbFQz4fyR4c6wxGPCAmRtjFR1dZlANFXhNSNYZZyQ+ewB7ch8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB7346.namprd12.prod.outlook.com (2603:10b6:806:299::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Fri, 8 Dec
 2023 22:10:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 22:10:28 +0000
Message-ID: <b54fdac3-9bdf-184e-f3fc-4790a328837c@amd.com>
Date: Fri, 8 Dec 2023 16:10:25 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Michael Roth <michael.roth@amd.com>,
 kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-17-michael.roth@amd.com>
 <0e84720f-bb52-c77f-e496-40d91e94a4f6@suse.cz>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <0e84720f-bb52-c77f-e496-40d91e94a4f6@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0132.namprd11.prod.outlook.com
 (2603:10b6:806:131::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: 3017723f-6eca-4c0a-d907-08dbf83a7c59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DxhH1C+ppUnrbnmLbnXQqqWVeUyPpFqjQ25Hoqm+x4FxAPnwnvk0uaejSSCd7ZtuGC+INIIumLYEmcNSEBwGA+CGdW9eyXOAqaESZVwUguOCCFPte5WeSl7+3MP+5dy9rLC6nne6MBxnGeA5+QmAONSpARS8bzTz7CvOyF63tuZrUVvWSLMpX94wy2L/1FVWhkEiZqRhFphDW1OeMhnIj9hVxAgGEdqrNnX7OPFsAOkfkO7CIKOG4SdXa2DBfrxdWvOiAtkX4LGZfVVrelmlBZx71QTWGUXgRccuSfuPMQ9Wo8q80x90CRiFoGpI3AtsY+B53qCsfHraHKwULyDL5h5SefN8qTdxOsBvYpkVojD5BLsfof1TOuRiNJpgqap0hPxZ8sIWUH3YdiTp4z84w3uajxTcmhRRMUhn2dd/zVh9RThMzEgNJdKR6gFDDyh7ZXMkTI7zQt3S5eF4sYxAZEiv3ervXQskrWQzX1FJqXf3za+DFeIt8Td1eoGVu8B0CfsaDcAgie6MYrIqt6E/RTnTWzDFBrN2mTfyd+4DAGVZhnVzOMppIEx5l8fhKNxZvFhG3WRyx+JhanmYeZXcTEqEnJTC7VGvvPmrovshahiHNX2Pl7yb2Fn5eULuAS4Ai9mBJDeuvw0bpNWQul91pQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(41300700001)(36756003)(38100700002)(2616005)(86362001)(31686004)(26005)(83380400001)(7416002)(5660300002)(7406005)(2906002)(6512007)(6506007)(478600001)(53546011)(31696002)(4326008)(8936002)(8676002)(6666004)(6486002)(110136005)(316002)(66946007)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTg4OWhtdnNseUg3alNrcUZDVU95bnlrRnFVTXhzR2Z2bHJhWkdlMVFWWDlv?=
 =?utf-8?B?MDQ2Z3lSdFRyY29FNEI2bThZUjF3UHFWdEJaMTdvN29ZMytoYjhSRm5xZjlU?=
 =?utf-8?B?cytQMlFqbTVEZzJ1U1NSUmNLMGhJQ3pyRUlCWVRUeDA2amFCdEVJeDh3Uldk?=
 =?utf-8?B?YXZHOTFwOU5LQWRWWGRud3ljMWxFaFJsTEc3VEJacEZkamJIVWFocHR3aVFj?=
 =?utf-8?B?RGNreklhN1RROHpjNmJUMi9XTGM5MitTQ3ZaN0MvbHllcklabGhMcEthd1NS?=
 =?utf-8?B?dnd4MllrOUxaR251dlVUMnMvS09yWmtjSDM4T1I2eWV6Mmw3eXliN1VTU2NS?=
 =?utf-8?B?SW5tK1R1Zitka1oxYmNjeS9uVU0rQktCVTRGWHpuRjVjVFczVUVKWDk1Z2FH?=
 =?utf-8?B?RldkNTBBa1JrUjJqZWwycEhqU05hdkE1S0xFM2dRSWw5MDdBc3EwV0w2bHFN?=
 =?utf-8?B?RnI1Tncwdno2c0JGUjR3RWtGMEVsWjlQMWErTWlpMEZHa2ZFMlUzVWhnMDZj?=
 =?utf-8?B?b1JGS0lHL2FjRy9GVWdCMHZYalBSVC9xcTIrMndQN3k3ZHFVK1h0SzBydGtu?=
 =?utf-8?B?OTdaa1psOFlRK053ZSs3MVRpVlk0UTBNL3NBSlhLUWdtTVVNK2xJNW0wS3Q0?=
 =?utf-8?B?SGtCNkVGdW96UjdpdCs3cnk2VUtNUlVxaXlzNk45dmZweTlLVkI3d0Y5Z09t?=
 =?utf-8?B?T2drcSswOUtQUkRRUisxQUE2OVZwOUkrQzQwcC9FbXNuTENrM05zVm1xcmlw?=
 =?utf-8?B?MGZtTk9wRXFUWHZEbit4UVNDd0t0WlZldDMwaTJvZ29KQmUvYUErWFE3MU1Y?=
 =?utf-8?B?dEtJcVNpUGdSdnBIUzYvNHY1YnIwK0RKUkc1N3BVR0p6TzZxbG9kc05tSkNk?=
 =?utf-8?B?dlZjb25Za0ZjY3RhUTFVWjg2UTh0ZWxWZ3M1S3d4VTM4RzJXK3pRSC9vNEEv?=
 =?utf-8?B?RjlsZlNKRTE0SDAzK21Sa0h1eWNSUmFOZHFPRmYzdnhIM0hxUy9HdGFkUXhR?=
 =?utf-8?B?MGVUbDQ0clFVYk1nZW9ZcXp0dTF0RkxvM083eExUUTVJeklqcFpGa08zWnpm?=
 =?utf-8?B?Q0V0TUhIQTFqa01rQktrN1dlb21iUzZWSzhuN0lSTkcvdUJadHBkbG9NWVFs?=
 =?utf-8?B?YVJmK2o4elliQ3NUUUlrUENveXZVK3dRSzRBYW4yR3ZkQWNUYW92UjU2eHBN?=
 =?utf-8?B?bkVSMUJENkloTG1iVjFiMHVQVXJYL3VHSkppV0FGdS9DZWxObFRETU5sY3JU?=
 =?utf-8?B?WityQUZJWm85Z3lwUWRsdTQzVE5zWXdWZGQ0cW80M1NGcm5XQllvR3VNRHd1?=
 =?utf-8?B?alJLdW00UjlKRTBuRnUrazdGWGtZMXZoMW1sS3ZDRk55ZkJQRDdIUXA1VFlV?=
 =?utf-8?B?T3NLSWQ0V0RIWXNxanh1cnFxZ1BPbFV1MzUySndDVDloZ2o3bWlLcWNSRG9O?=
 =?utf-8?B?TkptQ3Y3TkJuVVhETVd0MWRIWW1JVjlmSGtWYjVNV1pWQWVIZG1QZE9mTWVE?=
 =?utf-8?B?cUJyZElzUXFMNXFzSTQ1RTIrQmsrbDF6ZFVIYXJtcHFmdjVDbXZ4a3haOVAz?=
 =?utf-8?B?ZCtuVnFMeDdYTkdlN1d6UG1NaXFabVpnNU0yRDM5ZnN6c1hGdlAwSWUxSmlV?=
 =?utf-8?B?QkR5d0l1bEwrYllvT2VUOFV0KzNMQWJDQldHQ2VqMTBiU09NZHF3eEFyUTJo?=
 =?utf-8?B?aFBMalJ0cjBUa0VlNXQySWdYTEpTczhEVmlVa3hMN011UmpRczQ3cU9kMyts?=
 =?utf-8?B?dmllUXBVRG5UekZNbFVuVTlJUC9wN01qSjZ6Rm5QNEpWUFZiQ0J3dEd1aGlI?=
 =?utf-8?B?T29XSXVocGJJaUZzdERUODVGdkpNR09zcDdic3RLbUpzVkdFQlhzbS9rRUli?=
 =?utf-8?B?RVl2RmYwOVRwdHN4T1BwS0hVVHM0RXFDWjMveUQ5WEN5RzhmdmdrSnAxSzZ6?=
 =?utf-8?B?eFNUTVNud2JXUThTN3I3ZlRWWVNFeVU5ZTRSVEEwY2ZkSGh5Z0dmL1E3QmIv?=
 =?utf-8?B?YS9jTHZiWnJxN1BBVjA2Q1UrbE1uQWRtMG1WQllvZ3B4ZVFIZ2l2NjZIVjlI?=
 =?utf-8?B?WEtxaDB5MzJhZUZRTzI2YkJ6cncyTzg0UGl0N2RYdkM5dlhPQllqREJCTDJI?=
 =?utf-8?Q?ZgzkJt2R3VlR1LibR6PlzCfGL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3017723f-6eca-4c0a-d907-08dbf83a7c59
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 22:10:28.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRPX3edCEuOCxrxCeMZXmLR4xQE668A7AfiCaQNhX1FcpMfa75ZEmb8RzU2lLojxpM+17g5Agvt/PHyDR54rzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7346

Hello Vlastimil,

On 12/7/2023 10:20 AM, Vlastimil Babka wrote:

>> +
>> +void snp_leak_pages(u64 pfn, unsigned int npages)
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +
>> +	pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn, pfn + npages);
>> +
>> +	spin_lock(&snp_leaked_pages_list_lock);
>> +	while (npages--) {
>> +		/*
>> +		 * Reuse the page's buddy list for chaining into the leaked
>> +		 * pages list. This page should not be on a free list currently
>> +		 * and is also unsafe to be added to a free list.
>> +		 */
>> +		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>> +		sev_dump_rmpentry(pfn);
>> +		pfn++;
> 
> You increment pfn, but not page, which is always pointing to the page of the
> initial pfn, so need to do page++ too.

Yes, that is a bug and needs to be fixed.

> But that assumes it's all order-0 pages (hard to tell for me whether that's
> true as we start with a pfn), if there can be compound pages, it would be
> best to only add the head page and skip the tail pages - it's not expected
> to use page->buddy_list of tail pages.

Can't we use PageCompound() to check if the page is a compound page and 
then use page->compound_head to get and add the head page to leaked 
pages list. I understand the tail pages for compound pages are really 
limited for usage.

Thanks,
Ashish

