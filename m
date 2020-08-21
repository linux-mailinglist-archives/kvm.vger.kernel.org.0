Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B238524C93B
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 02:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHUAgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 20:36:22 -0400
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:64347
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbgHUAgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 20:36:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oz5LAKwI+uMIwYGrvMhopD1KsByoG6ioAWea5MNdqOlpj2KyPpyc/ytkGPyaGsMjzoYEUEEKVfGuO1T1JtWrB7/Nsub6KlBqtD6zvWc+7L/dsKn3SulpVOuDaZFm2DAmAXKPhtFV0VBvZ4iL9vTuLPl3Mg4x0mevEYeBwdKD6M1Ow5NKpfBATBtkB65QAV7OXagurrqqPKWGqV4kifcJu2WT3qxpyk3lG/yLROFXtUXacQtS56vc8OaeuMrEUvI8VPBeTKFqGn2XHq2Aj5hMbR0tA7Y+Bof5HegXDVHeB/+jtmG3HIfthCXF4AXjDPCFBuOF+VYjN88cJ4TWTAIjuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfNhvpTrQYwG90Lqj9WzgdUgr3/JnuoJNRB2t51f5XU=;
 b=YQqvavQO+MUUhymS/WVhPBHpyT0VwAE+ZpiRDqiawkZ05SO44mKx50z/bDG+CXa7R+fZ5XkVf+vcmpTQRGQvPE5QqMAnwrK4T9KUfPcoKvOsUfZBjwY2ZHYU7xKAskY0ZrGWd9t5h8qC7VqGQvVF4C8RtM6Ytr5U8iQpSLlBbKFRXHd3OZXBc583JhEr/Nd2KIPafVOm7Yws0ipJwaMtoayDd9U5sL34eR/bMvGxa+ppt920BK4ljchD2ORiCmKcKAhwvwwLyefj/x3cwfMRkurmsDqOaXQSSNq+FPeYhAAQ5VorBe36wLwQY+MJPf7+ploqmIyNpeRnz9EBtLBxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfNhvpTrQYwG90Lqj9WzgdUgr3/JnuoJNRB2t51f5XU=;
 b=0veigtTXKNgT6SYoHNKB6Y3MkWy5dX9aG1uyNs9GaapNJxXL2dB/Y33R7DdFFu4VinI5abX4KMq8lYyll0+VBHxUaGWQ5d3kWJ/HUExZ2VaK+puRjuFR+jxQMP5/MMds57kf/5RmwQxjv/zseJxG/E4ds29czoerYIJyo8NSoLM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2841.namprd12.prod.outlook.com (2603:10b6:5:49::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.26; Fri, 21 Aug 2020 00:36:14 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Fri, 21 Aug
 2020 00:36:14 +0000
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
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
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <a1783d94-658f-45da-1b03-eecb2db36e6f@amd.com>
Date:   Thu, 20 Aug 2020 19:36:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200820235900.GA13886@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) To
 DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.16.211] (165.204.77.11) by SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 00:36:12 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e05e1a9-b785-4696-a7cb-08d8456a35a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28419DA66E9A69A4D4CE9F47E75B0@DM6PR12MB2841.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMB9+/z0kwC4w7FJy43975D8E53NTswgKEXsOiISPH++Nmp4B6Fi4sEDwxEH0YDODxeYQ8HuF5LAH8M+tthWdiMYf/FOEbGGKXLipfgrBuyBFUh/l9xODI3aqlWYM1uz13A1bL8anbAqBy5et3fCDq8GingMBdeZZiccGAfZ+lU1LvoxnDmBB0jpB/0YCW4/gbazWhJMyZR4YWP1OqEMpuvNnM0ZohCWlhbaXjdNyRhJ0CcYs0Nklj33eNo9VmaWeYCYPoW26G7sLTM3jJAWWHphsDssV0fh1dQYYfopmVS89vE5QzMDAl2az2sZwpp3UM0BgN0XS+6AX/hg4CFGTN/4ZIq5StWvKYZmJ0xk4vlUAbumaIx9TjasjHr+qZdQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(478600001)(16526019)(52116002)(66946007)(6486002)(186003)(66556008)(5660300002)(4326008)(2906002)(66476007)(26005)(53546011)(36756003)(83380400001)(31696002)(16576012)(7416002)(54906003)(6916009)(31686004)(8936002)(8676002)(316002)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cKkykR6GRZX9JEUJ72ZHxQuT7Jg+dqMY9a6VOeuG8Y7B/pHpVIImyNOXWZq31Tgs4Hn+geAa7gtEW303u2TCVsYABuOyS6aAhaVJgdN+bx4s46EFZcXafIM3ei0LFBJhbmK1wRPW18+ur2GbV998WpOe5Zh0hN+SqwbwSrFdXhznQYRPKICzBxfI+/xPc4jgiP5Q1ZeELDN7OFdLB9BQ2ekYRDJJ1eBBajSW8JFU8GRYc7yZtSrSOqYlS+Dq3bq2euy8u/ruPTNklCsbyr+CIrY8SeXKCeFT0U4ltf8yxIMoPpiqIES6fA+pKhyu82YEg/E48sEO1CMuDN4jmCzTlJoBhX74smuaslN+CfJ+x6/I0Rr794vECkGgHt94h2uX7oHUp6jr9TghMSVQbTF8+Sg3eXmBGVQsne3xfA65A5NRu7sz3bWoHVcej828Mf8rKp5sHhb8VaqBkM1SOF1mWth5wxO7KYdNE99QaOp7kYkohuUOzHr+K3m/izeFR0fD9u3Yq9UHj9gA06SLRaS8zVqN4E+wVlRG+xGE+BkI5RnwDWlr2lcMb9htGo1du1u4npQFhgyVtSqYgdmSpLCZMd2RRwTZqaNNzuTcYGrV6xQvbc/cp/Fgd4LYhIPpAjcqY1l1Q35BedTzCduR8c2bLw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e05e1a9-b785-4696-a7cb-08d8456a35a3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 00:36:14.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iQx5yR3ctQu8+pbAyshsOcZWeHQk9fHeJngV+i1K7fMFQx9A3Ui7qh3MYg6fG+Hf2/TBdnfB8t2qcb7yJWorg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2841
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/20/20 6:59 PM, Sean Christopherson wrote:
> On Thu, Aug 20, 2020 at 12:05:00PM -0500, Eric van Tassell wrote:
>>
>>
>> On 8/19/20 11:05 AM, Sean Christopherson wrote:
>>> On Wed, Aug 19, 2020 at 11:03:48AM -0500, Eric van Tassell wrote:
>>>>
>>>>
>>>> On 8/3/20 11:27 AM, Sean Christopherson wrote:
>>>>> On Sun, Aug 02, 2020 at 03:53:54PM -0500, Eric van Tassell wrote:
>>>>>>
>>>>>> On 7/31/20 3:25 PM, Sean Christopherson wrote:
>>>>>>> On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
>>>>>>>> Improve SEV guest startup time from O(n) to a constant by deferring
>>>>>>>> guest page pinning until the pages are used to satisfy nested page faults.
>>>>>>>>
>>>>>>>> Implement the code to do the pinning (sev_get_page) and the notifier
>>>>>>>> sev_set_spte_notify().
>>>>>>>>
>>>>>>>> Track the pinned pages with xarray so they can be released during guest
>>>>>>>> termination.
>>>>>>>
>>>>>>> I like that SEV is trying to be a better citizen, but this is trading one
>>>>>>> hack for another.
>>>>>>>
>>>>>>>     - KVM goes through a lot of effort to ensure page faults don't need to
>>>>>>>       allocate memory, and this throws all that effort out the window.
>>>>>>>
>>>>>> can you elaborate on that?
>>>>>
>>>>> mmu_topup_memory_caches() is called from the page fault handlers before
>>>>> acquiring mmu_lock to pre-allocate shadow pages, PTE list descriptors, GFN
>>>>> arrays, etc... that may be needed to handle the page fault.  This allows
>>>>> using standard GFP flags for the allocation and obviates the need for error
>>>>> handling in the consumers.
>>>>>
>>>>
>>>> I see what you meant. The issue that causes us to use this approach is that
>>>> we need to be able to unpin the pages when the VM exits.
>>>
>>> Yes, but using a software available flag in the SPTE to track pinned pages
>>> should be very doable.
>>>
>>
>> The issue, as I understand it, is that when spte(s) get zapped/unzapped, the
>> flags are lost so we'd have to have some mechanism to, before zapping, cache
>> the pfn <-> spte mapping
> 
> The issue is that code doesn't exist :-)

let me look into that and discuss it in our team meeting

> 
> The idea is to leave the pfn in the spte itself when a pinned spte is zapped,
> and use software available bits in the spte to indicate the page is pinned
> and has zap.  When the VM is destroyed, remove all sptes and drop the page
> reference for pinned pages.
> 
