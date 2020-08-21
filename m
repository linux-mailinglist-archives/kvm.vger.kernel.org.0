Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7BF24DF3E
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgHUSRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 14:17:15 -0400
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:51937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbgHUSQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 14:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLqhigfTDjYgokNDlFcGxOjaQ0tdqHsjdE2zicsdDR4FmZ680Ibo9PScopbxBYTcNZT/mV6KFVOq3vOLTUGnl+GZ99BJm3NZmVpf+wQ/cCF/GHaqTN7WrlZ4wrIC9Cg3JR9KDaxpfb23NnidfBsrokcI/fi83s7UW+6v8O2bLpd7MIN4xDCp5fxGZSL4oegedjt74uFB5WZxuVD5cAjc02VH3UZRkwDSWBIhQLwZJnn9eScDFUrg9P16f1GTmfCrFnyRfj1vFMc3hDxCjJSwxvYfJ6TZwX2ycI6jnGRpMfHmuaFOAcr1qvUhRqQfIjP+ylQ6Acd5wbbwb/nkfGe9OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAOenYf6BZOCC/u6lRLqD5C5sYT8WjffGH5R4eG9Axg=;
 b=hijXaYSky0yRORcIJ5Tn4Z0ol7zZ0xbRQA811ZtgIZlYfPGmZBjVyV+M9ukvfWo3wCML6Gbfy48WIBZP2S9l+/nM1t9r2lqZhRQP2HQZAYmKtw4gyUOSyaW9ffVmNDjjwOHfmGB5LKYDxQCBySZVbiFtdNPLJxkM+RVUL7JcYuJSstIFsvDoPRmqPmo15Hvg6Xnp3+kG3wFU5EbrK0NO5Jzzm+wZ2Tcvh4ux7QgiPP6900L8+B42V8rPSBOfhqR2a7VtavzYeQXt16VaOmkwlaaRQkCAaMAez4rR4td6BCBPJ3y5xhCjB+uhQ/bPOvEYyANNN0tWBOEmt5AnPTaa5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAOenYf6BZOCC/u6lRLqD5C5sYT8WjffGH5R4eG9Axg=;
 b=1P2HhwKVX7ByC9xpX5iHLbBRDV+WWPz8g6b8XgMx/6npRlD23VqHeaBybQj87ykoRz2P41oEnDI3AGu9VqhW5NXkadndxbfJBJnwi0/9hSdqNdE/pp55LZX3aGBNvGAJbeBCl5QeBq6+L5Fxg2YsgfHNrMVQdH4KBLOrH3L35H0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3610.namprd12.prod.outlook.com (2603:10b6:5:3a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Fri, 21 Aug 2020 18:16:48 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Fri, 21 Aug
 2020 18:16:48 +0000
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
From:   Eric van Tassell <evantass@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <Brijesh.Singh@amd.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>, kvm@vger.kernel.org,
        bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
 <20200731202502.GG31451@linux.intel.com>
 <3dbf468e-2573-be5b-9160-9bb51d56882c@amd.com>
 <20200803162730.GB3151@linux.intel.com>
 <775a71bb-bd1d-ff34-a740-e10a88cc668c@amd.com>
 <20200819160557.GD20459@linux.intel.com>
 <fdead941-6dec-ec97-5eea-9461b7e5d89a@amd.com>
 <20200820235900.GA13886@sjchrist-ice>
 <a1783d94-658f-45da-1b03-eecb2db36e6f@amd.com>
Message-ID: <7cdff28a-3d80-d3b0-a951-5873962981d8@amd.com>
Date:   Fri, 21 Aug 2020 13:16:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <a1783d94-658f-45da-1b03-eecb2db36e6f@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:3:103::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.128.53] (165.204.78.25) by DM5PR12CA0069.namprd12.prod.outlook.com (2603:10b6:3:103::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 18:16:45 +0000
X-Originating-IP: [165.204.78.25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4e77f96-d519-4430-209e-08d845fe5e14
X-MS-TrafficTypeDiagnostic: DM6PR12MB3610:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3610EC60B760563DA346ED5FE75B0@DM6PR12MB3610.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsIbDULtfh3bwB1CDg6r20XEoMYM+jOl15IlZdnS3xYBBv2djq+t13mfd/GtQXoW0eo7CitO8GzmnMY+eVNlHfTwj8sUpiGNDDYWBhU9Zm2ZOIXN//PDOwCQwYj8/jmOvUxG9YmDkEMiUgJXlnpTqgsDVo/oqQHesAvN1ai6ZTxwjyB0Ae5jOHdfeUa85XFdGnlrd0K4SPwY+ST9ZJF75dHjpoQXhaUliPw01ldQumx9Bem912TDMOpMY58meN4ix4E967hOlaAATs/9De2GKxbxHaUGHrc7h1e0uY3+pyccsJ5t7AvQiiPzVY6ZrtW9VupM80Uo0yB7GE2bgBWDtY0SVB9ys7RveZeYsel+6DAM1k3NN8tYyqkS/B4snVtg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(316002)(2906002)(8936002)(2616005)(478600001)(7416002)(956004)(16576012)(4326008)(8676002)(54906003)(16526019)(52116002)(6486002)(26005)(186003)(6916009)(53546011)(66946007)(66476007)(83380400001)(31696002)(66556008)(31686004)(36756003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o7SwuHJE7uQHNSPnGXYtnpO+kMRlH6Cu3uwSUyYnPEmLAz3xCUgFPGpkVDhUT+KPrY8JPpVwRelwmxMu1SZ0pxN+j2gKjvr/I8DcWOx54JNhs9AWD+fQmJF6Cjv5vajho2I0Po5L6bcbPsdPz7VTG+K4/++uv5ijPMYXaOf4c1l2//FJ162GQi5JFnmzKgSrwn4jd3ZSMjDoSHS57nIKEM0NCq5+lSaMRv6O/wrGntCGLVHv8i/KwT2lEODkkOxiAipVIVGVNtQHvRNJj9Efns9ZHJSVipWjnsGeeGcwYeqJkFXaBgdStd/2fqnnQYqOlDSn0V63uXN0DH4J3aXxuUEtNIP25W0Aht+O7ctgit5n8df9vLf/r10ITjGbiHPnm2jT647GMNYAqJKiSS/f0OXEbsf1WtjjQqLrPFU3evD9PThMvIzOilkL1rdrVx0qFgcKFvmnqGNlxIhWn2uaqoP+4GPwVDibmSBrq72/DgVbufYdpwP915jKreGa9tE2/+8xRhBL1x0Hho70vyrmmEw07+kZ+4TVlw4bZEOvrawE5I7dJ8Hd2XlcfLnsxVrg8ihriJbw7ZcV06R0HW8KygrVfnhUbHfsk1F0XMlFe1ZocSKdaANCs0VD94MaK+KdOyHSWNLbHCUrWhK6wuxS7Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e77f96-d519-4430-209e-08d845fe5e14
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 18:16:47.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pp/v447o+6Dq5h0+VuypTwyPbBPWOl8J85yrpF8289TNkosfweOFivAAf4cXIdMmqZV5Y4bkyPqJxcYGFnWSqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3610
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/20/20 7:36 PM, Eric van Tassell wrote:
> 
> 
> On 8/20/20 6:59 PM, Sean Christopherson wrote:
>> On Thu, Aug 20, 2020 at 12:05:00PM -0500, Eric van Tassell wrote:
>>>
>>>
>>> On 8/19/20 11:05 AM, Sean Christopherson wrote:
>>>> On Wed, Aug 19, 2020 at 11:03:48AM -0500, Eric van Tassell wrote:
>>>>>
>>>>>
>>>>> On 8/3/20 11:27 AM, Sean Christopherson wrote:
>>>>>> On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
>>>>>>>
>>>>>>> On 7/31/20 3:25 PM, Sean Christopherson wrote:
>>>>>>>> On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
>>>>>>>>> Improve SEV guest startup time from O(n) to a constant by 
>>>>>>>>> deferring
>>>>>>>>> guest page pinning until the pages are used to satisfy nested 
>>>>>>>>> page faults.
>>>>>>>>>
>>>>>>>>> Implement the code to do the pinning (sev_get_page) and the 
>>>>>>>>> notifier
>>>>>>>>> sev_set_spte_notify().
>>>>>>>>>
>>>>>>>>> Track the pinned pages with xarray so they can be released 
>>>>>>>>> during guest
>>>>>>>>> termination.
>>>>>>>>
>>>>>>>> I like that SEV is trying to be a better citizen, but this is 
>>>>>>>> trading one
>>>>>>>> hack for another.
>>>>>>>>
>>>>>>>>     - KVM goes through a lot of effort to ensure page faults 
>>>>>>>> don't need to
>>>>>>>>       allocate memory, and this throws all that effort out the 
>>>>>>>> window.
>>>>>>>>
>>>>>>> can you elaborate on that?
>>>>>>
>>>>>> mmu_topup_memory_caches() is called from the page fault handlers 
>>>>>> before
>>>>>> acquiring mmu_lock to pre-allocate shadow pages, PTE list 
>>>>>> descriptors, GFN
>>>>>> arrays, etc... that may be needed to handle the page fault.  This 
>>>>>> allows
>>>>>> using standard GFP flags for the allocation and obviates the need 
>>>>>> for error
>>>>>> handling in the consumers.
>>>>>>
>>>>>
>>>>> I see what you meant. The issue that causes us to use this approach 
>>>>> is that
>>>>> we need to be able to unpin the pages when the VM exits.
>>>>
>>>> Yes, but using a software available flag in the SPTE to track pinned 
>>>> pages
>>>> should be very doable.
>>>>
>>>
>>> The issue, as I understand it, is that when spte(s) get 
>>> zapped/unzapped, the
>>> flags are lost so we'd have to have some mechanism to, before 
>>> zapping, cache
>>> the pfn <-> spte mapping
>>
>> The issue is that code doesn't exist :-)

looking at the suggested approach.

> 
> let me look into that and discuss it in our team meeting
> 
>>
>> The idea is to leave the pfn in the spte itself when a pinned spte is 
>> zapped,
>> and use software available bits in the spte to indicate the page is 
>> pinned
>> and has zap.  When the VM is destroyed, remove all sptes and drop the 
>> page
>> reference for pinned pages.
>>
