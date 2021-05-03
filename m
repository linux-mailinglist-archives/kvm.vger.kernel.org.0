Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756643720A5
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 21:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhECTmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 15:42:21 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:60929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhECTmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 15:42:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkOmA4MKkScNjFSkkgTUrf1MUlU5AJHPsJuOQz1PotirlbO35sAyrlbgxUrSwQGY4pFZHaZhuRneZ3EcSkjOkeugcQxC11OFn/SxSEsMrywARaeHRQooEpRFmhh+NDE89kfIjsnggEE8G53w7/Ox3WeAztFxEWbm8/dPloyLUrXMlLkPUbEl2U7VnBFyqUAL/q716lQRQ5iM3Gia22uGfl7lrMPC+iG73lAXsTrh5yah/TUqsRp0Rh9ttZA9XH3uMnFS+/CDZH130KW3mYUTmwu7R3DiJzFdIINXUhmbAhd96VcfACDD0JoLXuPQU8YDPcgsZV6D2WWRtqNOKdGKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFZx+BrRc0oBEyfrOnTHPQYaqR8AVJZ9edQR3f7shss=;
 b=GfjFW54DlTI/qVytUYBsrguWs5I6iEl/EVxpFn/kMZkVrhYQ4cKLvY33t/G3Xw3tbZCCEkxKkPY8MjvcwBrgJqnEAJhzOVMQs9gBwh40+VwuRWCiNYfDNdDBlhgoOfw8eI0aTMG4GVubHWYRwjmBW5rRhYlmuemhcSTkXBk7bFtzEfbv4yRQ5PG0oAnlb0xVIZ1D2kRn/E3WIUjRtDPb4IUWqvr540nMSddjC1vJOlXLfcdzu+P5YHQvK6jHdiigfkBoMs9vonUDOrSP5B1hqnRdAIHXfijREPOq8WdWmi/8mb2jRnFXLA70WpBUrHO1L5O3NDMPmmYiD9N8KmA1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFZx+BrRc0oBEyfrOnTHPQYaqR8AVJZ9edQR3f7shss=;
 b=u8auJOfRK2cTIVBWii//K4qg0Jx4NZIOKcvQhcHnFzjoAy0WBKzbE9+/Kth014b+CznFabaGlTdXE1lK0661sWOf3P++o6vzsKE0SbKh6ro4QfqcSemCErOZge1XPv1mqJ4viIB0HFRPXyhzUqIYNtKDw4Ucnzo6hrAXv+WdS+c=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.39; Mon, 3 May
 2021 19:41:24 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 19:41:24 +0000
Cc:     brijesh.singh@amd.com, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        Thomas.Lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Andy Lutomirski <luto@amacapital.net>
References: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
 <40C2457E-C2A3-4DF7-BD16-829D927CC17C@amacapital.net>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1c98a55a-d4d5-866e-dcad-81caa09a495d@amd.com>
Date:   Mon, 3 May 2021 14:41:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <40C2457E-C2A3-4DF7-BD16-829D927CC17C@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0061.namprd02.prod.outlook.com
 (2603:10b6:803:20::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0061.namprd02.prod.outlook.com (2603:10b6:803:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Mon, 3 May 2021 19:41:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe58b1f1-80e3-4718-69f3-08d90e6b6f1b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415065DDFA5F34602EE0114E55B9@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5413KHLzgeSk39GdwlyzYexmoCuShaiiBuhPKS5e96aP3QV7baPvrVItuZaLcD3lHywq7qy06Tdrtv3OOB9jr9RYB6RBPP/2y97jAdVXgioE+Wv/ugXofYsz2YLquG05IrVsHvfEKR+g/HktD+mICJbdRgP8kbw+/8E1O0X1feDWKLe6/eV+dKTw9lc1FZKm/RNRceFYfIzo8PpQqm6mrJfKoIcReBKCO7vhJ+3kpte1usBYBMeQIN4SZVC+667pqogDMygdwcRhE4qfMzqTqeqcoDxMyBWEuue9sWgl2zAhj84Z5mtoQaUmZYGZs5rbxiQUPUpbNn0+Goc0XWjRBtIWfbPFYdQfZ9WQnS5CiOj2sIEboqwRN0C+CAYx5uUICSGhJXYXIm0Qe3/2NqT8uXJ6ATcLGKCsS6S3fR38cSO4O4pTCSRTHgSRDMKV/T1+CFTj35uqclerj0paov+6wlaRqP6kRKSVrE5lah6dWujtMnRxHTRpmagR7jzQ3MO7fI30mHgO+5zKTBo7JVBOELYDEsBoJ7l94TF+KuQW6+i2/t/KYEaPPEr8RRMnWbDkel4MeOR8Q5cPuJrXKq6PgDnjuQfCKxI66LOvGnZCEEkodnoEeXeSSolmtwsUCDwROqAKokEoymYCfsTCNZF7NNVTkgx+9YOi9I8JzMFq08rwdy7bVnTOZkNoSr4dOxN4TfnQu8m9WicU+KtMIz0u+mVEjF0QEZ/FZnm9+uSVyZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(44832011)(316002)(478600001)(31696002)(8676002)(8936002)(6512007)(5660300002)(4326008)(7416002)(36756003)(52116002)(6486002)(2616005)(956004)(86362001)(16526019)(186003)(2906002)(66556008)(66476007)(38350700002)(38100700002)(66946007)(53546011)(26005)(6506007)(83380400001)(31686004)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZUdHTVZPTVNiV0ozcW90c2pxZzZXV3pWSmlQL1hIUlNuTlQ0bUpOK3RSVUpq?=
 =?utf-8?B?a3BzZVdFR3B2bG9ySjZYY3F3NGdodFRBUVFqUUlrdjR2TUwxdlkxTFRxNkVv?=
 =?utf-8?B?bWIvakNveGNKUklzWXhZQU9TdURGcU1pcFozclJLYTQyT3FScktEbU9PWHBj?=
 =?utf-8?B?M2ZCVTdzeG1XUXF1b1l1WHhXNHdQbGVJZ2ZTZUJkSzZwZ3VhQnhmVWptNk4w?=
 =?utf-8?B?R3R3a1BQVXR5TXpXNTJXYkFaNzBpeFBiVG10NGl0aW43aFpKQlBJMThFc09O?=
 =?utf-8?B?TGIwMnZGY3AwMWxmU0YrZFJkM2xUQlhuMndDdnRqa01RSVdkbUdUUm9CK010?=
 =?utf-8?B?dnBBazQ0YmpSSHJhaUZ5N25WMUJKeFkzNzJ3eGpBaGhQbS80czY1V2JXU0Ny?=
 =?utf-8?B?SHYrWUllMjl4TGtMaWtuZ25KcmxEZGZGVFErVnkwTDhGQ1puaUZlYThDbHdX?=
 =?utf-8?B?dlVSNVBBczJXYkxDUlVpVlFJTDgvNHZPeWdKRHE4d0Z6cFZSbnZrdGZlR0Jr?=
 =?utf-8?B?Z1dqb0FMN25mSHJ4VFFFNUEwOThjUXIvMHZmOWNWV0RLRjlpeElGbUtvcFVr?=
 =?utf-8?B?MDZaYlllQ2VTVU82SU5HaEJTSFA5UkZpdnA5ZjRLd292MGI2U1ZxcjVDYmNi?=
 =?utf-8?B?ck5xc2FibktPalBzZ1FDaGFTZmsrTjJ3ZS92VGdkUU9LN0RXNHgzVS9NaXVm?=
 =?utf-8?B?K3JBOHArK2hBcjVMOEpBdUp0WDkzT3QvQit5cWRFREpnK3VWd2lCK2I4c0N2?=
 =?utf-8?B?NzA2eVZhbGxvM3o4aVdHK2FrWUFvUEU0UDY5U3YyZEJpNWpmMGxXS2pybzZ0?=
 =?utf-8?B?OEFmS0NMS3pNUC9xUWFsbW5aSE1icC9vMnEvbzk0Rk1LeS8xOXQ5UGh3M3l3?=
 =?utf-8?B?QmJvK0NYN0d6dklocUM1VjlaQ0pZbjEyWkJQbjBTZldIUkNXU2R1eDVzUFVW?=
 =?utf-8?B?M1N2S2dkdmpaVDBYVFBFNVdGWWpWSmIwV0VZQzVMcjhZNEdUYVhURERxTURj?=
 =?utf-8?B?Y1BiUjgzampyeU5FZmE1WklSNWdUSDl5WHdhcTYxV0F4MElTWDVKQnRFRmFj?=
 =?utf-8?B?VFhSQTMzN0djb1k0Tnd6ekpJVVNLOWR2RjRzcmtjSWpUMVBtOE0wWUhNYnEy?=
 =?utf-8?B?THVKcmZ0MEhsazFOc0Y0dlQ2d0RDNk1RSHRwc3I2bFRaWDRiZzVXUTgyN0c1?=
 =?utf-8?B?MEhxVlpUakw1TlMwcVBHaDY1czd2SlJ4UTRMZ0tpQXk1UlpvYUVpR3RuZjVa?=
 =?utf-8?B?T2VIZEE0MmQvS1doNVNzOElIaEFHUVQrdEZLcUREbHpPTFJVR0w0UFFIa0VX?=
 =?utf-8?B?QlRyZ3drdzhJOHZwcDMxY0FEUDhCemNVL2NrUUkyQkRlclBmc3ZUdkRIamNz?=
 =?utf-8?B?TmVvSG5ETm96bEplN2VwNkt0QUNocC82UlBoenlWL3BDQTVVZDZQaHVCaGIv?=
 =?utf-8?B?RWJMcmhFdGs0N1AzKzFJUk9Dc2R1Y21VaFVrckdPWXJpWGkxZWxhVGRwSkk4?=
 =?utf-8?B?LzlBVWlsUWtWZ0ZiT1dZTW1mZEhGalJpOCtBODAwK2orSnArdXM2SE1BK3lj?=
 =?utf-8?B?cXN6cVQxREZzanl0L3pkZXJGcE1oUjI0U0xWQjluS0xuQXNiMTlHVG1jUnJv?=
 =?utf-8?B?KzVQN1VLbzg4dnplM2RvTG41Zk55bkY1K3liS2NlNmNZMlQwZ2xUOUlIWDNF?=
 =?utf-8?B?VXFKQ0R3QUhsVHZQS2lROEYwOE0zUWVUUEJxM0VtNXRMWWtRemtuOW1vTmtk?=
 =?utf-8?Q?jqOf6dOTKpKU6DbRNHMFqYW5yyoWr+9E8SGJ7jM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe58b1f1-80e3-4718-69f3-08d90e6b6f1b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 19:41:23.9741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpN/X2kiGezPyqcNskUip3Q1AEluAeYd3xA2fYnejYTTX5FRmfFxvUbJ4oLJYNB85SJ/enSgrAgHupUFDtKVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/21 12:40 PM, Andy Lutomirski wrote:
>
>> On May 3, 2021, at 10:19 AM, Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> ﻿
>>> On 5/3/21 11:15 AM, Dave Hansen wrote:
>>>> On 5/3/21 8:37 AM, Brijesh Singh wrote:
>>>> GHCB was just an example. Another example is a vfio driver accessing the
>>>> shared page. If those pages are not marked shared then kernel access
>>>> will cause an RMP fault. Ideally we should not be running into this
>>>> situation, but if we do, then I am trying to see how best we can avoid
>>>> the host crashes.
>>> I'm confused.  Are you suggesting that the VFIO driver could be passed
>>> an address such that the host kernel would blindly try to write private
>>> guest memory?
>> Not blindly. But a guest could trick a VMM (qemu) to ask the host driver
>> to access a GPA which is guest private page (Its a hypothetical case, so
>> its possible that I may missing something). Let's see with an example:
>>
>> - A guest provides a GPA to VMM to write to (e.g DMA operation).
>>
>> - VMM translates the GPA->HVA and calls down to host kernel with the HVA.
>>
>> - The host kernel may pin the HVA to get the PFN for it and then kmap().
>> Write to the mapped PFN will cause an RMP fault if the guest provided
>> GPA was not a marked shared in the RMP table. In an ideal world, a guest
>> should *never* do this but what if it does ?
>>
>>
>>> The host kernel *knows* which memory is guest private and what is
>>> shared.  It had to set it up in the first place.  It can also consult
>>> the RMP at any time if it somehow forgot.
>>>
>>> So, this scenario seems to be that the host got a guest physical address
>>> (gpa) from the guest, it did a gpa->hpa->hva conversion and then wrote
>>> the page all without bothering to consult the RMP.  Shouldn't the the
>>> gpa->hpa conversion point offer a perfect place to determine if the page
>>> is shared or private?
>> The GPA->HVA is typically done by the VMM, and HVA->HPA is done by the
>> host drivers. So, only time we could verify is after the HVA->HPA. One
>> of my patch provides a snp_lookup_page_in_rmptable() helper that can be
>> used to query the page state in the RMP table. This means the all the
>> host backend drivers need to enlightened to always read the RMP table
>> before making a write access to guest provided GPA. A good guest should
>> *never* be using a private page for the DMA operation and if it does
>> then the fault handler introduced in this patch can avoid the host crash
>> and eliminate the need to enlightened the drivers to check for the
>> permission before the access.
> Can we arrange for the page walk plus kmap process to fail?

Sure, I will look into all the drivers which do a walk plus kmap to make
sure that they fail instead of going into the fault path. Should I drop
this patch or keep it just in the case we miss something?



