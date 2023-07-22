Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E0375D9F1
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 07:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjGVFNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 01:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjGVFNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 01:13:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF501731
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 22:13:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+z3Ym3Qml1bJeOl93vLlvTQLnGZyn7mvdb3BR8gjiGtL1Ek3UW8YwGLFOE+pBgM1I9w3s1v7RGzJ2+euoEimbDzR6tYhsQHLlZ0v5cO7YEYfQStEfOX3u8fMva3Rp8Ib3cvei8+FUOM+cR2l9lr6tc5l+q+6e45jaLPD4bQlwchUNTDt4BJTci1fz9K9gtmnO5/6KeqwIVMLblvdbp7faIdJDhEeZaf5wtcU7UHeRc9bmPK5xHSQMfQ3hH2avEgmmT+WBbp5rSsMMF0SSZY5SvDTGJeeExk0h3+Dd/elltrYBWZj8baofeDu3EPg3r5vtePJ8vnvvebI3shJYniqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFpUJQav3YRJEk6YoySUpHZM3dyvDo3eHj4Im2nWPYY=;
 b=M9xP0n1Zga4o9Cd/zwBFxLKzE7jeHAVo4W5zuL57wpSRiEhleijl8PLrmMOOhecmL3Jzj4yQO3NoIXKj6tln2V93464t9RIwzZcgQsY7Q2/VTyjw4C/A5LcicBFAD6AibSAQ+I0a6BRzl6WrOWVYQJMkXqYLKLKQ5FIAsxX+pJzq8flpjm5/NQA/GB2WLgknUJKIY5Hg/GmSYtrSYVSSyYYUNaRpiBxv+GpiuA8BAd+yckSDJhFNUWwSRVHlRM8UZfmZT+LF6wotDM36NZ9yrtY0FS/j2tBRj4IEPv2ZUD2tE8XPK9/0SBWsBjdo36T+6jJYZv8uWw7JHRfiIm/a5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFpUJQav3YRJEk6YoySUpHZM3dyvDo3eHj4Im2nWPYY=;
 b=oI7yztaLHsMY7/Ir/ZddQ6aT6LHqMNFhlWhwbMKwnFWOMGDNdep2Ibt74cCeaa7f1iGhOMJfMA9anvxQm6BBE2PaU77LFVvVjb1X3oukAM7Ei0PCPdi+8SgMXDoBfz2tAZxkP7EtewWcHcTEqHbRQyPWLh7y2Psl6Pbt6jY6yis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 PH7PR12MB5783.namprd12.prod.outlook.com (2603:10b6:510:1d2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.23; Sat, 22 Jul 2023 05:13:26 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::6f26:6cea:cd82:df23%3]) with mapi id 15.20.6609.026; Sat, 22 Jul 2023
 05:13:26 +0000
Message-ID: <d7f3f017-0e03-d2fc-6a6c-661e0ef72b35@amd.com>
Date:   Sat, 22 Jul 2023 10:43:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB
 save area
To:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230717041903.85480-1-manali.shukla@amd.com>
 <b6f80cd4-acf7-bc87-087d-142e8c54b098@amd.com> <ZLVXtqlOfJsGKMYW@google.com>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <ZLVXtqlOfJsGKMYW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::8) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|PH7PR12MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: 618b2d2b-c709-4f6a-7dbc-08db8a7260f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrcpNhjbx60g67E449fBC8wcnJ8zi+bHETVOAnQoN49je1gcQPJtAHFpMClETRnJjuWFV+EUFiWUKPoxEdQZ5Qi/M27oDW3G3SUgqUDY1TOthsjt+ChmpRc6fDb1gs7BHkEJt+Pilk94RYHksul/Bw4Rxhq0jwD6G3COWmm2UwmyvW8sTaJ6rHLWBiIGcHzaBf2VFsL8fgwHxDg+3ZLkr4am7uRN5+6WTe5xqiZEU4XCedJ7hqFLswqpK1UAq3Ch+h+Wz6YLtUjwFgGTCcVx5Vk6Xug7mHwEmHHoyCEN8BjDLqQp2SRaKnxhkFCuYbyuAPE577tjekNhMjIMkL/z2+PCA72Gysuyi0BrzJNZzOZslef05JErBZpb+D7dt4zxI1sHjszK7hey2nWYyOsAS8NF8NxqH5k31UeWdsgY9FxOeqZX4KTnZuJk11ONg0frru2I6xSbl/pzTfItcfzf7VPsHClLThy9CY/uA+HHBtzZPozLp0kSWaooPYoh8Tv8zKhQjgFxmIIWAPX8xo3EJTddR331jPLv81Sbn25/lLatMKWzPPVxrFKvUVJdXCvCMf4lhH5DV1ybCCjGTF06mCzpmbLb9cvtzm4sE508B4OP7LhBXUsNQOGoQsuvETb3OWVgtL7CeuR0kCHwSpEZ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(31686004)(478600001)(6486002)(6666004)(110136005)(186003)(2616005)(31696002)(36756003)(86362001)(2906002)(26005)(53546011)(6506007)(6512007)(66556008)(6636002)(66946007)(4326008)(316002)(41300700001)(66476007)(38100700002)(44832011)(8676002)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVpIdUpiREVaRm1nb2NqZjhCaTlRSW9jN3diOEo5NHc4L3Q1cm9zdmswYm5F?=
 =?utf-8?B?aVhzeXpQOG5VTmlLaDlLaXNJWERJdU1mdHlRMjNZUUYwdkRNd3NUKzluQXV2?=
 =?utf-8?B?dE1kRENMRVZSUGZ4UGp0NjhUTFRuM1MwdHhrQVlpTi9WYlp6c1lNamlpeVhK?=
 =?utf-8?B?S0hvakFRdHpEZ2RTRk5Kd1hRV0ludDROcWF4bTEwZGFSNVgyOWtQUnJRS25X?=
 =?utf-8?B?WHpNWEo3ZDRIekUrUXhwL056NHYzd0VMcUk4N29PM1BkWksxZXd3RjJ6QldM?=
 =?utf-8?B?aTY2SWFLdHBVMmhqR2hGRHJBT1FVelNPWW5vS3NRb3VJSDc2aDNBRHoycGNi?=
 =?utf-8?B?ZkJBV3dSb1JzZnl4c1JlN2NhV1JmWnV0WnZoN0JsSXlvYnNDVnZ0OW51T2FP?=
 =?utf-8?B?QnBzWHlBN0xRZDJSVG9WTHBXTGIyY1VDNUdwZFdUSUpYVVlZcnhjbjZGSkxm?=
 =?utf-8?B?VEhaQUcxWmRLdWwwbE13SGFtd2hFU29ORG5RZldDZjM2MmVDRVY4SlZVZVAz?=
 =?utf-8?B?aTMvbENCWjBJTkFVMnFPQ002L283WEtkbUNXYWhoaXhUR0E1bFQxeXVJdzAy?=
 =?utf-8?B?UlhTUEJjdUhPWlZyTlhyb3dsM21OaVczVk03V001YkJQMm5hQ1JMcFRLRDZV?=
 =?utf-8?B?ZjVwYy9GbkVERlJEZ2JrMGRnRnlQQ0lmZTd2WDkvRElNQUNrK2FYd0Z2dnBQ?=
 =?utf-8?B?Mk5NajRnNWR4U2gzOXQrVE9qbnZoVG51NU1TbXhFMUZCTjZvbkJCV2FkNWh2?=
 =?utf-8?B?cWZDMlo3dlBWd3ZHRzdodC90emhKaEFSSWthRmx2WU41d2ZGR1JhcDZrS09S?=
 =?utf-8?B?aDVxMjB2cU9odDR5OVh4NWpYSEdoZEpPamhBeHF5N3A3Qko2ZFNNcUk0L1cy?=
 =?utf-8?B?dk41WXdvRjJRaUNHMno4bm5Ub0RJQXUrczJ6cDdJNnpkem5JdWcyWHVTVFY3?=
 =?utf-8?B?eFBlSlUzQWlvNHN0eVozaDJwQlU0alJjTnl3N2d5L1o5T1N2UFVBdElwMndX?=
 =?utf-8?B?amtqd242bDl2YS9hb1pRd3c5WFYxMDc3bDVaWGNZZnBUaUFDem9RMk1UNjJq?=
 =?utf-8?B?aEtDTEpWZ21OQ0VYcUVucXFUVktoRDF3V0dST2dNWm96cmJzYUJucm1RWVZR?=
 =?utf-8?B?cXpSVnNqU0E3YmVWSGNNdmxqZy9tWUpRRW5MQmFobVlIbk1tUXBIS2wwWXJo?=
 =?utf-8?B?YTA2YzJzYS9QcDV6Z1YwM3BmZDNpOTdIOVNLM05ZVkFLYlJIMGtmV01vZkhQ?=
 =?utf-8?B?UzI2eU1yNDBTQ1pYMFpxQXlnb1BERU9RU3BqWnhvQUZITU01YTNSbTVkUUZk?=
 =?utf-8?B?NW1ja0YvOC9zZSs5VEZFT3hlZTlEWHFTS095MWMwZ3RwLzBQVTdZTC9KSno1?=
 =?utf-8?B?OHBpNFRqdkNDWnFzejVlckVmOFl4dUd3UDRWZU51dU5ScWxPZm1vUC9lVkpJ?=
 =?utf-8?B?ZjRyRGYxcGJEN3BsWWVmN2xEWGUzNzBtTUVvWWdLTlAwdVA3aGxTUmhiQlI0?=
 =?utf-8?B?b01mTTJJS3BuMFNNY240ejRFL1pTZkZtVkRzdVMzTTQ3OHZyczdJVWF2QWU0?=
 =?utf-8?B?UGp4SmhqQldBKytTNWtOSVF4dEc3NWtFcXFvc2Q2TitlcE9IWkhMTmxYTmFN?=
 =?utf-8?B?ci9NYnYrSDBlSC9GSXZqV2VxZXo4NjIwQzV3N2pGQ2R6ajJ5WXdJN21SaVdm?=
 =?utf-8?B?RHV3Qzkzb3Y4NEhQOWJiOU9GVEVLY1V2czVXTlNZdllMOGV6TU1KZnpjYk56?=
 =?utf-8?B?VjZGVzRnMzVMbi9LMEdoZHZPUlAvSDR0c0cyRnJDQnp3b2FUUnhiczVQcG41?=
 =?utf-8?B?S1JDTURJT2tqT3p0YU4rM3JZaWZRUUNDSzZrZ2pXVkJWdGNydW5FdUdCakdz?=
 =?utf-8?B?Nkp4UFlUSnRTZHNVN0F3TTRaeXcwL3RVeE5WbDd1ODhxMHRReDgzR3MvV0xV?=
 =?utf-8?B?SGNrWlk5WDdzcm9EMlh2OExGY2NiSWowbFlpRDlLZk8xcE1sZ0tvRzBGZTRz?=
 =?utf-8?B?M0xJMi9WTFFBekNZelE3MjB1UGtVU1o2QXRrTkVEbnhPTVc2b0EzRWV4MHA2?=
 =?utf-8?B?NUhOWVhzeVhzSmFJRHhnbGk0em0yWlpHTEpZRkhYNXF3elk1M0tqR1RJTmJC?=
 =?utf-8?Q?fi852YJE0WQ79zT06ExZ+CxrI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618b2d2b-c709-4f6a-7dbc-08db8a7260f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 05:13:26.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pq0zdSf6Smwh0pPjbwxtR5eU5MiNGA6umuyc86gyld8V2ZqR8Tog7c/nZcp/krPe3sJZduCSd+uj1S0lWtHGPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5783
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/17/2023 8:31 PM, Sean Christopherson wrote:
> On Mon, Jul 17, 2023, Tom Lendacky wrote:
>> On 7/16/23 23:19, Manali Shukla wrote:
>>> Correct the spec_ctrl field in the VMCB save area based on the AMD
>>> Programmer's manual.
>>>
>>> Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved
> 
> Nit, either just "spec_ctrl" or "the spec_ctrl field", specific MSRs and fields
> are essentially proper nouns when used as nouns and not adjectives.
> 
>>> area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
>>> in VMCB save area.
>>>
>>> The Public Processor Programming reference for Genoa, shows SPEC_CTRL
>>> as 64b register, but the AMD Programmer's Manual lists SPEC_CTRL as
> 
> Nit, write out 64-bit (and 32-bit) so that there's zero ambiguity (I paused for
> a few seconds to make sure I was reading it correctly).  64b is perfectly valid,
> but nowhere near as common in the kernel, e.g.
> 
>   $ git log | grep -E "\s64b\s" | wc -l
>   160
>   $ git log | grep -E "\s64-bit\s" | wc -l
>   8334
> 
>>> 32b register. This discrepancy will be cleaned up in next revision of
>>> the AMD Programmer's Manual.
>>>
>>> Since remaining bits above bit 7 are reserved bits in SPEC_CTRL MSR
>>> and thus, not being used, the spec_ctrl added as u32 in the VMCB save
> 
> Same comment about "the spec_ctrl" here.
> 
>>> area is currently not an issue.
>>>
>>> Fixes: 3dd2775b74c9 ("KVM: SVM: Create a separate mapping for the SEV-ES save area")
>>
>> The more appropriate Fixes: tag should the be commit that originally
>> introduced the spec_ctrl field:
>>
>> d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
>>
>> Although because of 3dd2775b74c9, backports to before that might take some
>> manual work.
> 
> And
> 
>   Cc: stable@vger.kernel.org
> 
> to make sure this gets backported.
> 
> No need for a v2, I can fixup all the nits when applying.

Thank you for reviewing.

- Manali
