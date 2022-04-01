Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861D04EF7A2
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349353AbiDAQQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 12:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350510AbiDAQN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 12:13:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B16CD303;
        Fri,  1 Apr 2022 08:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxfaL1NTm+dmgH3TM9Dbw2/kaeOrjHUgCdrk8rhtnRGLE/FlMzfuvFHDviknPS9NU3eSrx+/lVNlO0KvRv9zpKQKhfuT0K+L5ost/zy2S2H4lpQlThyVGNlbAiiZWgWF/LBd0/bK1ODHs99obZ/DuNiRni1XDhTOiBz1aRCw8K0ItWE7QGjlEOhDtT1DYkGlqGk+gQg395P2edYWubCJojvfvpkvlxndJ/EvzO2ougr1m8pXywleCR0dSipv5etFuT7X5rCxBoL7q1NLiP2kR6R+zbWvzhFQAnUbYV4MU4w6Au2VjGK3wP1zjsugtHHQaOJFGRN1wlRvH2/spA4cUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYYuW2q0FeeSJQNUPL06Tty5wYOslgn5uc4yEpu7swg=;
 b=g7bEbHNC5/Wt8luMdjSHQfAFM6Bq4ardcbhStvU6781WMTbONWDdDAh2o5c/JnmXur5L15KhlDtxhI1YBHDjPHa66DS3ddYoNqDJbcnihPQ51Mtd5ShUAknUYpSMKqmXLRmpCLCiZvfU4xIG90wtmolJBJ4JdC6SZK+1gfIj+v9jDNsJKqC5/Ga4+MSsfMtuMzkaXFnyMAO7nHTttTVPdUn7ima2gstZCdoB8Ag7+O6y96raHsfneZkXICvxcPuGjkQ7nvRx2SHrj4epFIhoN41Cn8VJMTaQirYVCzkdFbgF23mOygi1BxUSp2NbAXTEYCuHoFGhKmOW2ctXli7MXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYYuW2q0FeeSJQNUPL06Tty5wYOslgn5uc4yEpu7swg=;
 b=o0ApAh8+02/PJNnGCWJiZu24yETPAcY3YHjGGIicYOJn3pcIBoP156Gr7Ic50WYaQu9vvnXwmcjb23Lu06srpwfR7uSvWmbyTXv+771aFCIEA2rOj80R/vC3MC7TLhVHhvFuFJHzrDVE+3M/rLA6kJ09Q+umtWMWtIH9riog5XM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BL0PR12MB4755.namprd12.prod.outlook.com (2603:10b6:208:82::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.29; Fri, 1 Apr 2022 15:39:45 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b%3]) with mapi id 15.20.5123.028; Fri, 1 Apr 2022
 15:39:45 +0000
Message-ID: <fe90faec-a320-c203-67f9-7de74e50b513@amd.com>
Date:   Fri, 1 Apr 2022 21:09:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com> <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
 <YkSz1R3YuFszcZrY@google.com> <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com>
 <CAMkAt6px4A0CyuZ8h7zKzTxQUrZMYEkDXbvZ=3v+kphRTRDjNA@mail.gmail.com>
 <YkX6aKymqZzD0bwb@google.com> <a1fe8fae-6587-e144-3442-93f64fa5263a@amd.com>
 <YkcSDeJDHOv+MZA7@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YkcSDeJDHOv+MZA7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::13) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0ab4bee-808a-49ae-fad1-08da13f5d8a0
X-MS-TrafficTypeDiagnostic: BL0PR12MB4755:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB47551F80C1B50FFC799543E1E2E09@BL0PR12MB4755.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeglIF9kSlZCmZ4YO1g6HKjvNyDdvYSrNNeKtM/VNO+JBK3mVl1Z+h351I7Htz0StpYTt5Y1gNlzb1XmRf5tzYHUYeSlXBhQeRXtggF6GcHCPUekrEuLg0rcN6gg2Adb+e7Gx/pQ8tCmdtfU+uX7C9TN1k4fevKzKcPyRYZJUiOsQij888FY4yrzvjuhC/vkhDyH4hBpZeaKDmSbBPVpmlXkekVifcJeOccLHBYiZVscdtGIsxJ9oJ+4EpcT8VHx4iMT+zpWSfQG2Dks7/aIAvn1aMQvBBb2Cm6hXiepiXb81IzfeajsDezrjETCrllxmXjhNHdGgJBHsGLnLRJbgeiKC0K6CITzmEb0NsjKb+NuYoIOhxj4EehJ4dChmM+k5T94fSmobFH2szsHWyjVd6OYgcXrlyJVIffCW4wji1bBXI6Xl16A+akx36XF2VkQUVTsx/tJkN6vQHMYsFrAvxDrRWGoIwd1wdnU+73xJCk5tUDTKbPrb9QqGGcS13pwC450wds6kMLWPrxvHI8gH4bIIJn3HM+4wsH3TIdgWKzIicsdixllywQ7u4IlErSwTYmHDFOka/Atc0EvUFT2dwzrTFUJqcdMbKDzPY/0UaNI1fbhfBBQ9vNzmSr64e2QmSBF50mCcc4mEzJm6udBrZLCQKYjWqg/L9PWhNonzy0klfCydotfBnswv/j//fw1xgObmd2L4reStpjlNUbOhWs1OpdYO3U3HthPqgzOfnplFAMjLllxmOPW8r6dWjVd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(83380400001)(26005)(186003)(2616005)(66556008)(8936002)(8676002)(66476007)(316002)(6512007)(53546011)(31686004)(31696002)(6506007)(36756003)(66946007)(6666004)(2906002)(38100700002)(6916009)(54906003)(7416002)(508600001)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vzlwa0tGZnNRWHgxdFhlQVRhandJUnY1NjhsbUhiOEdsVU0wWFhGQXR5cEFy?=
 =?utf-8?B?ekhrZFRtSDZNQWx6bVBXVytRUzBMSktKODUzOUplS3ZHWlZrWVFoMm5Mblhn?=
 =?utf-8?B?MTF4aUxRa0ZTZUsxVk9ZL1g2T3FEVStkeFVHVFhoREpsVlY5QUQybXlKbHMr?=
 =?utf-8?B?SUdkbkJBQXNmM3Yvd2hPUHd0dDhCNGJvNWNvMVhTTDZORmRXeG1zbGRLSXho?=
 =?utf-8?B?UG56dUtyT1ZVeXJncDdrZ2Y0Q3dMbExJdE1GMTBUWWp3cDJoNXNmdXZsOUpG?=
 =?utf-8?B?OFozTy9XQmJ5VDQ4MG5jQ2ZLdUZYLzR2YmY3OUUySm1hZC9ZMHI5SVFmYlhx?=
 =?utf-8?B?MitFbm5SKzZRQkw0TnhvMlkxdTI3bjFzOU9WaTY1RFc1bTBpdjBObWRiU005?=
 =?utf-8?B?Unhad290TTFOUGFlZnBTQURkOVBUekRLU3A2T1M0VHdpbVVuaTJ4L3NyUUl5?=
 =?utf-8?B?bjRvSmlMNGJKdzRUZWxoc2JHWUM4bkVreGZVQW0rVmxIOEZJbldCU2pYei9Z?=
 =?utf-8?B?M0JNSTlhZ3JBN1JLZlhaWjRUSkRlSGRFeTFLbHNIVDRvbi9nVnlqNlpmVlBU?=
 =?utf-8?B?b3hZM0tPNnRYekxNaXdLeWRjYVM1VGtzSDV2SDdXc0xsMjRwNlZNTjg1aUtx?=
 =?utf-8?B?UzgyZ1BOeVZ1KzBpMkxjREFxMjBGVDBJcFB0SXM3Sk5uN0FDUFZWWUJWZUJJ?=
 =?utf-8?B?YjExRGhuV0EzNDB6QjhIQk1GRUltUGN5eW5vTkNJWGZRTU13MWZPREZ4OUNV?=
 =?utf-8?B?cWszNFRXaktMRzE0SGdLWFE5RllNaTNqSEpJdEVwTVdNeWM2MitCcGQxaXdU?=
 =?utf-8?B?cG1TaFFIZ3hqUWQ2MDBvVXk2b1Zobnh4ZlI1Q0NoSDNlQXJva3ZjWC9oY1Zz?=
 =?utf-8?B?SWh3b1UvSHV5aTVoVzdzUlpSUnF2enE0YWJyT205OUVoMUZyeWFDNUZrNmE3?=
 =?utf-8?B?a0ZtbGMxV0VGNWxKZVNHQVlFd1Z4cDlTNGltK2tkUXdnczQ2UXNIQU5tandM?=
 =?utf-8?B?c05IVGV5enIrODM5ZnZqYXpVeU8zUEtNdFlJOVNYd2U2dkR2WUJPdVR0ZE1u?=
 =?utf-8?B?NUpHVnhTbG9wR1RGcnZNMDlJYzBmUmRRdXNMWkY4OGRucVFQTkgxN0NZMG5j?=
 =?utf-8?B?WW4zcUJ1YksvUGI0Y29PN3dydmlkUUpBNUtHS3B6YkdrTGZHbFh6cE1abCsz?=
 =?utf-8?B?NzAvS2psS0twYWswTDhYNFVjQ3cvaEFyV2NBRzVnWEJFd0tuSmhDUEx1ci9P?=
 =?utf-8?B?Q0I1OGlIeHRvYUlteFBIUFBIMEhnTjdNM1VtVDJhY3RQQ2tmUTFaTWl4QUtP?=
 =?utf-8?B?ZDl3OVVEOW1FYWVKNDFaQlVZMXh4N2tSR3ZrRXZFTnVCbkN1aFdjMDk4SUkz?=
 =?utf-8?B?N2NTa014OTFzWHBUTUo5MTRxcmJ5dngvdkRXL3JydEdubTh5cUdvUWhqcE82?=
 =?utf-8?B?andkN00xYWRSMGJsZ3RrUFQrNFErVGtuOU1lajBtZG9GS0phaHA3SHJUQlY3?=
 =?utf-8?B?cVdBYWY2K1JZUTJDNC9aUTFKN2pNS3JJU1dRSk1QYTFyT3NFTFFOLzlZL0Zr?=
 =?utf-8?B?dk1ISmpIZkxHcjRuV0daZFJWMkNnY0RjQjNNU0J4aWdwaW90VUFtMjg2V0VT?=
 =?utf-8?B?QjgzVFA5M0pvRGRJSVNqQTdXNjZRYjZUQ0VrM3JYWVZQQWs4TGZ5MDdFakFJ?=
 =?utf-8?B?Yy9Ud0RndHA0TytpWEJ3bW5UeUtNM2JEQ2lsK2J3ZWdpZWRBYjJGTVdFNlB1?=
 =?utf-8?B?UDdrUm1CMG4vUm84NTNrQ0hxQ2ZTR0JiVTlLU29ScFU2bXNsUlFBNXdsTUxw?=
 =?utf-8?B?K0ZIUVJGekVYRXJBQkZQcGNTR0J1OVQwUjZxbTFxVFAzc3lWWFdnamxzRDhx?=
 =?utf-8?B?eVRITU94UFVXQXJWTW5uUnZNQUV2L3NzMThaN0J0UlhSRjRwOHdheDk4cGh5?=
 =?utf-8?B?eUQ1eTFOUGpqM3FhZ0dqU2dHR2VidWZaYW5vS1FUSk9EK3Noc3QvVHhydnk0?=
 =?utf-8?B?aDBVaGorMEcyR0xmdTY4UzNDeFREUzVLbkk5ZWEwY2FvWjdSRnNMSWMvazBW?=
 =?utf-8?B?cHpwRzJ5bU94K1RwZlNBMk9XM1F0am5EcVdqaG9wUUQvZWRyUjRUckdHWjBr?=
 =?utf-8?B?SFU4ak1YN2dKTVVxNTAyamd1MnhXVlJSY1RQM2lZSGhmMFFobW1HVk16cEV2?=
 =?utf-8?B?WnVUN0tSajVMSUZRL25CNXlrbzI0RnZteDlTYnNodTVhWkp2d2hkNnRObUlC?=
 =?utf-8?B?ZWQ2aHMyWnUwMzJxSlArQmNiYjF4bTN3bGk1UWE3TzkxZ3N5WXdYek9nR2ZD?=
 =?utf-8?B?VkQxOTNrZzFqUTdUeGYzTW5GRXY3MUNvRTVvVGRTWmx4SzQvRjZHdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ab4bee-808a-49ae-fad1-08da13f5d8a0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 15:39:45.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsMCSLi2JnH1vFBAxEXWi1f8o0L934rOr3R+J32lyBz0/O+kxgtE4D3eifZtxcdo82Co8eU/wNV4/80yw0pNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4755
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/1/2022 8:24 PM, Sean Christopherson wrote:
> On Fri, Apr 01, 2022, Nikunj A. Dadhania wrote:
>>
>> On 4/1/2022 12:30 AM, Sean Christopherson wrote:
>>> On Thu, Mar 31, 2022, Peter Gonda wrote:
>>>> On Wed, Mar 30, 2022 at 10:48 PM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>>>> So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting
>>>>> KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared
>>>>> pages to the hypervisor, this information can be used to mark page shared/private.
>>>>
>>>> One concern here may be that the VMM doesn't know which guests have
>>>> KVM_FEATURE_HC_MAP_GPA_RANGE support and which don't. Only once the
>>>> guest boots does the guest tell KVM that it supports
>>>> KVM_FEATURE_HC_MAP_GPA_RANGE. If the guest doesn't we need to pin all
>>>> the memory before we run the guest to be safe to be safe.
>>>
>>> Yep, that's a big reason why I view purging the existing SEV memory management as
>>> a long term goal.  The other being that userspace obviously needs to be updated to
>>> support UPM[*].   I suspect the only feasible way to enable this for SEV/SEV-ES
>>> would be to restrict it to new VM types that have a disclaimer regarding additional
>>> requirements.
>>
>> For SEV/SEV-ES could we base demand pinning on my first RFC[*].
> 
> No, because as David pointed out, elevating the refcount is not the same as actually
> pinning the page.  Things like NUMA balancing will still try to migrate the page,
> and even go so far as to zap the PTE, before bailing due to the outstanding reference.
> In other words, not actually pinning makes the mm subsystem less efficient.  Would it
> functionally work?  Yes.  Is it acceptable KVM behavior?  No.
> 
>> Those patches does not touch the core KVM flow.
> 
> I don't mind touching core KVM code.  If this goes forward, I actually strongly
> prefer having the x86 MMU code handle the pinning as opposed to burying it in SEV
> via kvm_x86_ops.  The reason I don't think it's worth pursuing this approach is
> because (a) we know that the current SEV/SEV-ES memory management scheme is flawed
> and is a deadend, and (b) this is not so trivial as we (or at least I) originally
> thought/hoped it would be.  In other words, it's not that I think demand pinning
> is a bad idea, nor do I think the issues are unsolvable, it's that I think the
> cost of getting a workable solution, e.g. code churn, ongoing maintenance, reviewer
> time, etc..., far outweighs the benefits.

Point noted Sean, will focus on the UPM effort.

Regards
Nikunj
