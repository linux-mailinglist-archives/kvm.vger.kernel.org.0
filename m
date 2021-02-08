Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2060A313B16
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhBHRiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 12:38:25 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:50862
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234958AbhBHRgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 12:36:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVNP4tl6t6DLbYLcpSP/jYwKaOKKFQXCHqtePT9hfgnO9i1NI3o0xxLy2MjclqETEmfUzTzOmtwgTBj0lO5i/9WpeIyfc/HltTa4wMHLxisDLyIys2bNn10QWmq+qUIVa/R4evRG+rYM0kkX2JzXvgYEz+6NIVycjNk5ioyRGtv9+hbn/hGvdQE4ikEE7NtP8ZUV0VFjoZtQt+UNt4EV8ucqpJCTFB3YIFDazIqMXFTT8C1+apfn2fccknjfLICL9MjkDZXZiPKFA52cx2nTzsNhwkf3G0hN6Y8F3CN36b2R3f0UkmHqn3lRL3BJNuMppZ2yGq3C+2wLWLKxTSzlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq8DSiVPMgTRArBwiItzjhQPJKxYqBKKjkS62CpYT6k=;
 b=eVOdiJzhTua4vJMiDRQ61lCZ8pDrCVomKQYym20X6Wz+lJPkS8Fz1PscJjCGnuJN2OIbuUz4hvPIsEeh124ITpFlp6/bamWXVAUhQ6/5h+iwPhKr1MeSYALE1GhQmZUGlSL6vgk7N0umaBEwJX04iT9t6IQZZwMvluj41qzTVZwPOPyal2sArGs5o7/4P2s9e4O8xh+1pT+aJP9QnKIULKUcvJE5qPmw4wstWZaBYIZWntzkwuA2+wt0QhFXfUcIUaZ8bk6/9TxuqTo1YItzhOfKDN+GWipu/KNysCGLafaAczVJiLVYOamlt4wjDIoQl/TYb4qaGfZJCCzDHLT1hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq8DSiVPMgTRArBwiItzjhQPJKxYqBKKjkS62CpYT6k=;
 b=naNhZKHjLKjDE87MGjjfUcIQmdztXUKZrjf4GLmGnQIJxBNdroHOTdb7YLMBLMdQlbBPaChQc4ToBNewjJGzOdoM2G9PGETa0vYjtSRvON9OOdqYCVeA+Smj9sOAvxXNQNKscuqi9SOV+kmjuxO4H6PIQvVexGhOLkstLJZrfec=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1867.namprd12.prod.outlook.com (2603:10b6:3:10d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.23; Mon, 8 Feb 2021 17:35:49 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 17:35:49 +0000
Subject: Re: [PATCH v6 0/6] Qemu SEV-ES guest support
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <9cfe8d87-c440-6ce8-7b1c-beb46e17c173@redhat.com>
 <6fe16992-a122-5338-4060-6d585ca7183f@amd.com>
 <f4e12261-c3e3-8934-5fd7-79fd30eccfe5@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <405f8f00-9c80-3f63-bcb1-c6e0cf6439bf@amd.com>
Date:   Mon, 8 Feb 2021 11:35:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f4e12261-c3e3-8934-5fd7-79fd30eccfe5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:805:106::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR2101CA0011.namprd21.prod.outlook.com (2603:10b6:805:106::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.0 via Frontend Transport; Mon, 8 Feb 2021 17:35:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 658cd661-a88d-43cb-2e11-08d8cc57f912
X-MS-TrafficTypeDiagnostic: DM5PR12MB1867:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1867C09BE2BBB07902A887F6EC8F9@DM5PR12MB1867.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9k9gu+Oq8ACgC0nIZYiPR9xMza3kwzoxUAP/4ql1Kuoa+esaJAmb3W2lUmCFdqSwZ8eB0uF3v/RJ8rgQIGIPYk0j05RoT4x2W2aNtqNOda8iWjsTGi0qu4HxQ79G2jDJWzmM4u6rbeXW0MFframHJ1z6EMRwEDDJ34B7H/XE88WHjFK3+AIn3XkxMjANkbv7Dy29iXSlpNqChlBpXXa1KUGsE5su8e4Ttu729iNWQblBRxyCh0LXO0/RKd+Mt8h/zTHy/J/SXMMZZyOhUyaDZ3ZsJTgXI1npNxfeM54iEu8PDx+shN+tbPlm+yiIp5/yI2Qx56x9soP9qfk01w7tN0jVOOjWtLMQ9AH4wKF8K6340Ef/OVGA7G7k+3G1zvPDzvLoVEwlGb3KOABQ38H1FjtU8kocT1bnS7S9AD0YTsq+w4AKJVmyVDVqWd57mRR7r5oKYlXDTtrzn6rA5gKxuqYQqzbYiwht+kVy5EtCsL4ZcoDslf0CuTBXHiOvY1jrL5UIhYZN5i/uSJFvBlqZFO1Gnrw9CqcXmTjNybm/HoHzdq3q13TzoPK2q5653t1UOh2shYkO582PTCWYOeVXOKBQc/FhZSv0zhP+chl6K0uYoNjDl2+tcxbsQM0L/5iGaA94q/ZSb3A71qGSl4DNChaMQbqSpKrHPbhd+GkLHveJZGp6NSSc/0/PhIdKwh8c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(83380400001)(316002)(110136005)(86362001)(54906003)(5660300002)(8676002)(6506007)(31686004)(53546011)(31696002)(6486002)(4326008)(478600001)(66556008)(66476007)(16526019)(66946007)(26005)(186003)(966005)(2906002)(52116002)(8936002)(2616005)(956004)(45080400002)(7416002)(6512007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZFY1Q0tiS0UxRUxBRkhSR0lzMFIyWnU3aGhXWEJHSHBPTXgrcnNXRExYV2Vx?=
 =?utf-8?B?dHhBbU91TlV4dE9lRFFBN2RTbTdmOElMaVoxdFBBcGd5QnRyWEQxTFR2ejg1?=
 =?utf-8?B?MkhhUDQxSW9uaStlSGdia0F6c2Izb0kwU085RHlZeDdYdWhoWE5peStMck90?=
 =?utf-8?B?eW1jVXdwMlhHWDdZN3FnMTlNSG9Kd2RLdU9WejFvMnhnc2lJMFdJTHRoZzRJ?=
 =?utf-8?B?UVVMdmpPa1Y1RVNUT0ZZckpiYWMzRTVDNUpsMGxnYW1lWGVkdFlDcFY4QnlK?=
 =?utf-8?B?bGZ1eFIwcmw2Q2hrSWMvOXdYVDZaTjI2aFJIa0NRTDVVc0RLUTVxY0loU1Nm?=
 =?utf-8?B?VHFvemRTUXA1cjhMQ3VlMmo2N0xjSXcwTTJtcFozZ0dRazdIWHpJREJkTEMw?=
 =?utf-8?B?OHRvS3F1MDVDOUNDaTJtdURIM0pXT2JxMmw4MnhjdjlRZWd5NjZXcFpQNUNr?=
 =?utf-8?B?S0RxS2lHa1JRVzRVTlRPd1ZPdWtvUjVJRlFtTWhQcEVXU0xZa1NRRDVGN2NM?=
 =?utf-8?B?OGhadFdaNWJZWlF4WDJURFRmaXNCaFp2am45ekdmeEVQQi9NVlhScXBCZWda?=
 =?utf-8?B?WEFpbWR1REJjeW1BWGpqaFZRS2M4aGJNUFlyeXNNbVpZOUhJejk1SFZTRHVn?=
 =?utf-8?B?Q0kzTmYvS0hkZzRIN3hBSWRsSktiL2w2TjkwLzFrWlE0UC85VklISDZMU2Q3?=
 =?utf-8?B?eG9SUnZkUEhqVVhwTko4U2kyc2VRc2VXcHRFMWRvT2JoMXllYkFaMlh3bUpM?=
 =?utf-8?B?RmlsM0R3Q3lNaDFxMkdObldlWWtPK2FQWWNYajl3amxNNFp2VXRQSFN0SlNi?=
 =?utf-8?B?dUhQMXBaNVB4R2o2VFdKemR4bXR2dGdhTDhzUFlhemxJaDBySWRhUmZqTUk3?=
 =?utf-8?B?TnpLL2VReVY0Z045MXlxTG9qa1hjdER0ZnhNYk8xc0dsQm0xZWtPQVh6anVT?=
 =?utf-8?B?bTJyeWtsSDVNMlc2TW5jeS9DMm9lZW1iV3A1Yk1CazhoUC9YVlZpYjUwYVRx?=
 =?utf-8?B?YXFnTU5DcFZDUS9UbmdJa2dtUnZrY3hieERnZU5DNTNtMmVhdFFaVGZqMmJ3?=
 =?utf-8?B?U1NwRWV1YUFaMDJOVTYzc202VTBTNUhDUHZsV3BwYkpzLzFBNUpnZlhDMmVy?=
 =?utf-8?B?aU1uYURUTldrc0xsbTZIK1BxWFpKZ0Q2Q0h1bnd6TVc0M1dDNWsreS9zcDBT?=
 =?utf-8?B?eHZtMm9mUnZoeEdlNHQxRnNoZTVFVmVyaWZoOGlEeWFXVE11TFoxZ1hjUG9a?=
 =?utf-8?B?VEFsbGlNZ21MWjZNdStybllWKzNDZE1NaER2ODdKS3NaclpMN1R2L1pUK2lm?=
 =?utf-8?B?dnMxdld3U1dwendoSWpwZDIrQjFLMEl4UVNKRVJFNHhRU0dwR0pjZEJtYmZ4?=
 =?utf-8?B?R2RXd2Q5ZndTRkxQQnprVUhCbGc5alJuays3UGtIb0R3WU5qMW1OSFNUbHVt?=
 =?utf-8?B?ZllWV2FteWZnQk1zN2graGp6K0RUM2hZcUFjY3ppam82UTlaVXpNOXZOcGsy?=
 =?utf-8?B?cjAvOVVhVDVWQ2kwd09mMENwQTdkK1d2WjNxYk9lbHUvOEVUaDlsZWRhMnZm?=
 =?utf-8?B?SmdCZjgvU1ZRYlRSeVkrbGd6dnl3cEFhNzhVbDI3MjFFUGg5NkhEaDRsTWYz?=
 =?utf-8?B?Q3lWWnBPR3RoQWdTZ213NEMydkpwYUlvV0RtejhIR09zOC8ydThkUVBLdUkx?=
 =?utf-8?B?K0xESUJVbTRhUkp4aGFPOVY2QzdPWXh3MXhPL1h5SEg2a1NJT0h4UHJ2SnR6?=
 =?utf-8?Q?yAUBuxl6K6my8NibM3y5goiQodYrHo5eyUxUMPv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658cd661-a88d-43cb-2e11-08d8cc57f912
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 17:35:48.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVJMsQlkLrPukiF16N4eUzv+JBGXTb0gwWPcsNkznEMty2EjyCyiJQLSwYEbOUdaAQHFWjuy5ewXIZD3mPzFFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1867
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/21 10:31 AM, Paolo Bonzini wrote:
> On 08/02/21 16:48, Tom Lendacky wrote:
>>>>
>>>
>>> Queued, thanks.
>>
>> It looks like David Gibson's patches for the memory encryption rework 
>> went into the main tree before mine. So, I think I'm going to have to 
>> rework my patches. Let me look into it.
> 
> I was going to ask you to check out my own rebase, but it hadn't finished 
> CI yet.  Please take a look at branch sev-next at 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.com%2Fbonzini%2Fqemu&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7C0fd806ab779a47c04fb508d8cc4eef45%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637483986711396809%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=kxzVD%2FwGNrU0zIhZjxyA0XCDtyycPW%2FROsvs3BrlkJE%3D&amp;reserved=0 
> (commit 15acccb1b769aa3854bfd875d3d17945703e3f2a, ignore the PPC failure).

Everything looked good from a review perspective and AP booting worked 
without a hitch, which was the main area effected.

Thanks for taking care of it!
Tom

> 
> Paolo
> 
