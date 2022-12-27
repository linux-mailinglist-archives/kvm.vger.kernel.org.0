Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE58265701C
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 22:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiL0Vty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 16:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiL0Vtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 16:49:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12A4B23;
        Tue, 27 Dec 2022 13:49:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8n9oYf6WwJdTuF/kxscRi1brvlgjzQgRK1gV0+osbsDPPPcUZXoQyXtRhaY84rqhYIZjVk2LeTZMbkG0w30n080xTtOZD0w5OWslN1NMY+SOHd5BViGAtZkmpvce0UNVg5W5zapz610Sjd/uh63IiAzx2fn2ptsvdFJiF1rD9djcufIEgA3cBwHx3jm3qC3KqTuOjnSjxmP7zUeqWVkrJZ9z2ARLEF/B2f1XvfMFXqwstBwk+qrwYdN1n8O6L8M9eCT851yUZW9rVBaYnu7fq7YrZ2dmeCVSBt59ZQgG0ifu6LkJupgD9Y7fgQMONcEU67GeJ8aEHxyTnHhWhdEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkemZj2jZDdu8KAJ1zNdQlK4krUuT7b5oSMTAoqs+CU=;
 b=CNIrLMZqGURSHLkN50TRAJqONBopOkL33USKcUyyJea8KGpQgRffOpmaXe7+WGqq3TCUPxXUvkqgRyVlbUQ4J5VF8x24Y5qcLodqsiiZwDQUhgKfxyD9CvSKhIhpISG+Dn7/ZUZJ3qHFlDLmtuErB1BxKUbJL9vqyU3OrjA4kSVq9VXMaxk4KLvnBQNl6FoIKnsy634VR7LbMKo2MLlg9RTxGVCmGlyqTow1M9VeBWfpdezKLFbejr8kciGTBboe6d0uR+3fz3SGjESc2lkiY68rFxLhZZ2dbIMH2y0GRM5qu4eAL4E6ekYQOwLM2ZHvfVs8pu2jHlRqjt9Ku1Q7Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkemZj2jZDdu8KAJ1zNdQlK4krUuT7b5oSMTAoqs+CU=;
 b=pwfYqiVF/jcMOlMo4qQcA8D/I9yNQvmVwfz/aceerf+KcWl0moclcBdeofQ7DT0piXwSM/TX3f/9lpuGjTbR0fwCp+4zcaxkr/ualEG/vOGZdCGbf70uNQQRXxtev7c1lPQSwx5YgF/R3cLFRzuWNXt45sQI9TcIHutZt3xj0z0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Tue, 27 Dec
 2022 21:49:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.016; Tue, 27 Dec 2022
 21:49:45 +0000
Message-ID: <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
Date:   Tue, 27 Dec 2022 15:49:39 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y6DEv4QuvIfwWlCW@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:610:4e::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: aaa87af2-6b8d-4f55-4515-08dae854446d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4s/yevOIvgkSfN/bq7VUtm1+xdq7KiTUB18668PYlAb8JcxMyEUXJe5z1Ba/THyh3+eu0MdLq9nwZXkQfToaYhyfmAWY60Mu+UR6rjOs6Sy8t2wraIfp+BSXchecxlGY0oyaNpXxtMTCHSrOMhTwFMNyujDzGXz81qI7tYNxHkNN7QYztHmQ7RcoqGe0KS4dHFFbmJDg2Ye3ZM37EI8rnpYnQrHL6dKpG2XEyDEJV7o0f5pIdJ/waDnTCRDjT6b8d93bChdWDFYFcQ+Y94zTZK5z4RKi3yqGDJSopVm9wy8L/1fnBHjuFEun46PWs6B3ytXwjUII3X5I+f//vxu53PRcKKusAoW4zi2OH9yZiH0L6dfYZwDkeNgtzMxncq9FdS6XPrCJfbIfeTv70E12Iue5TJGIdD2HTHqM3lxUS5FY+dNg4nRY5MS89vNZhgrO/X8ZhZReGd4wf1rrp3Cf7Jd0CmfzsdvD3Kl4jEPtTO348F7aq9b4XTT9pmPWJYHKY8Jy8G4GEe4pXRNeYMYjGdNuMkmqTh4pZgkIVyS/bqlLrkcoHFXLLjJjUjhDLsYBrBiIARHWSADYcFMalAzYu1EHVXgG9OJj3aA9nN3Sxyowz8nEpWKnUvDXO+FB2keQ5o0WiCIdwWnqd+wDKom3rZUGSWdQ/DMKDFp8qAtfoF/gO29HFNrdE8/vTrcX8fJtBPw0Twg+IuD/NpGz6kiM31s6YU4vmxYVO4KOiY4wk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(4326008)(8676002)(66556008)(66476007)(66946007)(478600001)(6636002)(6506007)(53546011)(36756003)(2616005)(316002)(6486002)(38100700002)(110136005)(7416002)(7406005)(26005)(6512007)(186003)(5660300002)(4744005)(31686004)(31696002)(86362001)(8936002)(6666004)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDR5dTF1alBmRGVqK28zTnZjVWtUWmdoMGJucEFOUWQ2aWYya0t1MHAzTVJn?=
 =?utf-8?B?Nlg3VlB5ZTVkdzdJWUQzMjcxcUZKSnJLSkpzc3RVS3RQVEFCUURKRGMycmFt?=
 =?utf-8?B?M1FmQm1zWGdxSENxa09hNjdTR1RTdkplaGY5dmhvbVpDMlI4eFduS2tMS1Jm?=
 =?utf-8?B?aGlIcmFUa3FGZFFoS3ArNW5uUzdVK21tZzQ2NXU5VEMyVENwQmZFNnNzZkxS?=
 =?utf-8?B?MnMvdWExb3dhTmR5dFlrdlRPTi9Ka1VFdEJxUDFXaEZXdTdPQ0VrV2g0QjVv?=
 =?utf-8?B?MjIxejhxckljVDJBOFpYVEtieHkwV1RMVFY4M3cvODlWYWlIL1FrR29vUDBi?=
 =?utf-8?B?b3Z3bHE2S0VNa0NRamhlUnZ6TFl5NmlNUUltUnNmQTZuVnJ4Vkk2SDR3TmI2?=
 =?utf-8?B?cmp2bmxLb3VYbWF0Z0JEaEJjZm9JWXpQNjEzQVBqbEVKYUJjK3VpZWtSQUcw?=
 =?utf-8?B?aG1xbW5WVE94aW4xaU84YXFLSElpYk1zak5rZEVtSWhMczJDd25EZzFJOFAx?=
 =?utf-8?B?MW82d3FwdG93d0xlTmJGNjZjTnVnODQxenJGbXNjVEZHeGhiaVFVN0loRUVq?=
 =?utf-8?B?M05LK2thWUJTVlFndWRjRmpiRTdyYkN6QTFiY0xjRVlMaU5kci94cGZsMnBS?=
 =?utf-8?B?VlJoUGlVTUxiY25VRjBMQ2s5cXFnYldTblpBeUlJK1RXeHFnY3RVUXNmWjdX?=
 =?utf-8?B?YUpiaS8vL0tkMGcvdm1ZTUxyc2UxNUhEb0ZiT0t5SmRKUjd3VEx2VTRNa2hP?=
 =?utf-8?B?ZEF2ZzlUMTdFajlWWThLMGNVTksrTjkvcDhobjdkUzZSMXk2MWdVZE9VcTM3?=
 =?utf-8?B?dlRyN2FLL0tPc2h6UWhWR3owWHA5aTVjSUdjVE01STZBQ0RxZ0JYcmNLR1Rm?=
 =?utf-8?B?aW1qTlBvOFRnc3NpRXBVbkxJRWVpQTczNFcydE1HbG9sRUozSFQ2blMrNmJQ?=
 =?utf-8?B?M2JCdHBYL0pTaHNPUHZoNnBqRUM4dDBhMzBiQWgrVzBvYjVtSUppUHN3bHMz?=
 =?utf-8?B?b0Q1MDIwaVRJVzNoUVhJVHVSYWFzQXQzTE51WklLQWd4cEtMdE0rVWJNMkNt?=
 =?utf-8?B?bjQ4NUZLc2lPVXM0M0ptVTVudy9aZmdvWmZpQ3d2dzdldm8zbitndGxRcWFv?=
 =?utf-8?B?QmZ0aENzeS9DYVNmTmxFY1V1a0tqUzlmTzRjTkh0aTVGK0VnYklCcHQ2NkFD?=
 =?utf-8?B?b1JHSXJ2MnJyVWF5NWZIWHFVTmkva3lEd3VTaWVWUEdLdStaZmpXSCtvUFdK?=
 =?utf-8?B?QU1lNldpTmpUNVdXRE1VdnM3bXFQTENCc3RQaEVwczdoVEx5YmpSMEh2Nkxs?=
 =?utf-8?B?Qmk0QTliM0h0K1ljdTFoamZiTTVqS2p1S2YrWmlaMXRXME1zTXNVMkI1QmUz?=
 =?utf-8?B?T3BLS2pJS0dOczdGeWU0RS9DMUJTeUNOVk1tc0xadXV4WENpdUhTZy9tbi9j?=
 =?utf-8?B?MmZwVVJySzQwaU52QzB2WnAxODJ6cVc2Tm9uQXZVT2xyNE5oUkU5ME1tdHRT?=
 =?utf-8?B?YTJUWW5uN3M1WU9kcUVmTWlFbkNCRUZkUUh2aGJPKzJOMXRuMVE1aW5yYU1r?=
 =?utf-8?B?UjNnRGRBNHRvSCttM2FOcDVXOWhOSjhVeFlNMUduZWpwRTcwcEgzcEdSMW94?=
 =?utf-8?B?cDRXeG9WUjZnZmk5WVo0NG43RTAwUDdVZmZPaTREajcyQlIvMVplRUo5dW9N?=
 =?utf-8?B?UUQrc3ZoQkxubXR4cHZpL2h3cTNmOWIvSWFYVzZWa2xHV08rWTRhWlV6dnlX?=
 =?utf-8?B?c25PNzN2Myt0TlpvZmNITElUTVdYRWloMEJWWUJYK2ZrVFFBTy9pZW5Qc3p5?=
 =?utf-8?B?MnNQb2pOYTFGb0UxVVlNSUM0bWlabUlKN1B0eFlHQ2Y2bk5hNmNBbkRIcDhN?=
 =?utf-8?B?ZVlEWi9jUlI5THFVUE5xMmlBQk1TRG56UGFsR1J3aFJJQkVEVjQxeTc1UEU3?=
 =?utf-8?B?M0tzTFRkVkt2YU1VTVM5R0tPelBaRVNwSzhHZGtiU1V4NEZ0Y3QzT0pZckZC?=
 =?utf-8?B?UHhtVUVBMlFPVDZmem5hR0p3M0R4MzQ4dTVWODEra1V2ZVUwakVyL3pRV1lC?=
 =?utf-8?B?REtWS1cydXk5Si9YTkN2V0N1RUtpcVpyZXNGaHZ4Z0xpRVAvV3pqOGFVTHRO?=
 =?utf-8?Q?9oTE3SMbuasgJqRAb1GXwtbUX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa87af2-6b8d-4f55-4515-08dae854446d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 21:49:45.1755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGdiphVww4IuC7yXm4+Pdk1p7JdNoYlXXfUvLNMtgafGe22PI2F0ihDN1Z3dF7NI0pimDF9+ZA5ws5UP/qxWBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 12/19/2022 2:08 PM, Borislav Petkov wrote:
> On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
>> We implemented this approach for v7, but it causes a fairly significant
>> performance regression, particularly for the case for npages > 1 which
>> this change was meant to optimize.
>>
>> I still need to dig in a big but I'm guessing it's related to flushing
>> behavior.
> 
> Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> 
> Don't you need to flush when you modify the direct map?
> 

Milan onward, there is H/W support for coherency between mappings of the 
same physical page with different encryption keys, so AFAIK, there 
should be no need to flush during page state transitions, where we 
invoke these direct map interface functions for re-mapping/invalidating 
pages.

I don't know if there is any other reason to flush after modifying
the direct map ?

Thanks,
Ashish
