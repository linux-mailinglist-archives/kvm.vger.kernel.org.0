Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6979C2F6A8A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 20:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbhANTIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 14:08:30 -0500
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:32353
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbhANTI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 14:08:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7nBjs8YAc3ktoHmjZTVyUqhx39S4S8mIuQ3mAzw9mfwZ6GI5tlZ22W5wqkIQDE8T+vjmpXWH3qK3whQ4d1KbMKZDm2Olz7eiGxzxGHVDkrZL/NBjjHElqSevLLsmfQkjE/QqLESnQmLJh78B9F+3CCOWmF4Me3qFJCBtd9wPBeNjuBs4rpKx5pqG0iCe+zi6fi9yS69iQKIknl0VvdjGPvqtG/PxruGE6FHqNq8TufyQskqvLlj23NWDnS4+jpYIFQFuOJ8nIycVmKdaNFLk301EtLzWl8KQlTPhgdNWr79fWVYQxpETYHAHB0xsdNuO72MjMORbIFEZs/4T3AQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKXOHib0Xu5C62Mbf3JYrwtG5JUry16kjRdDLCbTwOQ=;
 b=MzNWkxj6Vu8wPTgb/VspnXpXaAHLzrutwLK9vF25MSn40431L5AodcYv9M5twEPOvPwQocWKXfis3M6QZ/f4f+wYTgR8wRN0f2aKJoojxgtq6XdF1QOtnatUV2avN9r4xJLg6I/V0cL22gUQlQ5JzyYTfg+LU9N/d5ZuXvkncj8sSRq+sJ+TWOGlyM0uFlov3e6Vc7tEltQZpeSHkHjR2lc7Q9pYlOmPT8yGY7vcZiCjo/jL/Vdzjcu3SWdSdy2vj8BdzDk3BQdIGCMGd/SFIjvw/erouPYW+n/K9R+gOluzYTIRR2d8JZbpgM/hgANoOdid5NMTTseVg+uWkHlecw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKXOHib0Xu5C62Mbf3JYrwtG5JUry16kjRdDLCbTwOQ=;
 b=YZGa3ojuX0jRiUR7HylItXTlu2HlkjiKGu36khK22ZLAQSsIEYzxSeX8u8gYoVg9yNQo0sONt282P057M7p97JFoiEMX5VLhubRVObiVWxNL5iCQSK55qNgTXWUBKO7XBPy02DkZuWJMpPSg0zGMoz8gwM68lPFO3j7u67DM9IA=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2780.namprd12.prod.outlook.com (2603:10b6:5:4e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Thu, 14 Jan 2021 19:07:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 19:07:35 +0000
Subject: Re: [PATCH v2 03/14] KVM: SVM: Move SEV module params/variables to
 sev.c
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-4-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ffbdc356-765a-80b7-64c5-aee0f0c02b31@amd.com>
Date:   Thu, 14 Jan 2021 13:07:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0124.namprd11.prod.outlook.com
 (2603:10b6:806:131::9) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0124.namprd11.prod.outlook.com (2603:10b6:806:131::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 19:07:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb36c833-0868-432a-12f9-08d8b8bfa761
X-MS-TrafficTypeDiagnostic: DM6PR12MB2780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2780C8F4BDC26CD259A29876ECA80@DM6PR12MB2780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KVL8oAqiOVdaSR2haoeuFONHQigOHX+2KxZL9l2Gzd4nObjgp6Ri3a3m8b7drPJy9N6nqhzPdZ8ofwl2yKRx27aIA7sAggznS6x+MEIyLn4UjHRcYHPyFV+cX+cgu8X/vU5CJ+Qpw8P2xjLQsfxoZ+JelhckCafmVVxjQET2i+uj/de5wHLykONrMDUpnYPxx4t9+7/f4B6xctgIjCB0c8lMJvszSp6TOZRKEcXV2HrF/I7SFCGLEDn9CvTtIPmaW7u2UJSvd1bcJPkvLjqnxR/gTrnQKdW4Ya/lgd9BE/83S2i8VRWQFgMyOogVgVPIbmjNAAD9ZLkxERW+CY8mKlqSDh3z7MLyf0TAeRSZ3euaDNoYXkZdg9DYs9gQ5zX5NvOx9HToWxXbhWXCZnIUHKceQWHv+QIlJid64fg+cavQjTyg4uzpiMaHo8wFPd4BZhNSfcSu0HeNDs9ZrUTdjHe6Mvu0ceHzK1LTNcyx53I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(8676002)(36756003)(956004)(2616005)(66556008)(6506007)(478600001)(83380400001)(186003)(26005)(53546011)(7416002)(4326008)(66476007)(31686004)(8936002)(54906003)(316002)(6486002)(66946007)(4744005)(110136005)(6512007)(2906002)(52116002)(5660300002)(86362001)(31696002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L05oYnFwdHM1YmVqdS9sd3FoTHV4bHM2ckxvK3NBZC9xOWFHVENmRklsdkxG?=
 =?utf-8?B?eU9QaTJrVzJ4ZTZhbExnNUIxOEtOeFpGVE5BdTloRzY4L0wxeFBpdEpWZWNB?=
 =?utf-8?B?Z0t6elhWOW0rU0h5SW51Q0h2NmlmRXZHNGVyYnZMTnorUHp3ZHdJYXVpdDJV?=
 =?utf-8?B?TFdJZzkrRmFOdk93ZjdTdHZkZkx1MkZSUFI4aVoyamtKQXZNMk5EMU0zODRK?=
 =?utf-8?B?WmNwMllGOHVXbHo2dTlGdjJNdlpBZllJaElQcGFJaWRxb3hKSGpDSG1jWTJv?=
 =?utf-8?B?SDJEMmZabnEzV0hTbkNBRUMvV3JkOTc1aTlvYUszVDBpYXN4cEJRQ1IwdFdo?=
 =?utf-8?B?THgyWGxMeWt6cW1QbTkvbkpmcUtaOWQrV0NrckltT2tpVmV4STRlY1FLYnUw?=
 =?utf-8?B?RDYxZXEyQWI5YWZiNk5wS1JrelFVY1doNUdjei9kc3N4KzZSc29XVS9VTEFw?=
 =?utf-8?B?M2E5UGN1L1VQUkh2K3ZPTHN3eWFZOFNXQWEwaCtXRTBYblNNOERpQXlOeFFz?=
 =?utf-8?B?cWk4T0owemV5SDhWSldaRHJpNm8zY1A4eXlRZnhzelY3c1ZsbnM2aGVaNEZn?=
 =?utf-8?B?NTc4aFRDVVpjeVovN0RER09JVUF6VW5obzQ5R3RvS1Z3ZmVLc1U4Z1VSVG5h?=
 =?utf-8?B?VHZ4Z1AvRFZ2RjRkSTI0ZWtLSjhhZ2xTRW0wVy9NM2VDQy9ySFZnbzVUeW12?=
 =?utf-8?B?dGpSTVhRVU5kcUtramRRZGJKZC8ySFNmNWJ0cllwTkMrMlVHYWw4aGZDRjkx?=
 =?utf-8?B?c1V5T3FYMTJLNlR4dEFBa241Sys1WmlJVFR6TmQ0Vmt2eGJUNVRQR0tuaHAv?=
 =?utf-8?B?Z1U5SVRzUk1jOXlVQjFObjVFRHhXSmVYUk9yOWR3ait5UnBDT0tyVEFUd1l3?=
 =?utf-8?B?TVBpWFl6Wk5yMmk0OGpwK1AxTjJlR3JuOUVIZ2hWaytlZTVNeUppVDJtMW9F?=
 =?utf-8?B?K3NXSWhPMkM2NHZnanpKbkRjNk9TNnpwMmlkOVZDa3dvUWgybVVjZzNROUht?=
 =?utf-8?B?bnVXVHFtK1hrRStKZXpDTTFSdVlKRXQrVS9MdDRocXBhekJ1SlEvemgraWky?=
 =?utf-8?B?cEduOFIrdmVJdmlvVTl3RUZGZGQ2Mmw5OHJ1ZHRzMjJ5R2FPcHZYTHF6bWVh?=
 =?utf-8?B?cnFMWHZ0TlBjdjZBc3JsUFdwcmZaSkdaaW8xRkR5QlpCR3RNbXlKdFFpanNY?=
 =?utf-8?B?QkdldEZWbFdhS3UxTExZTk52Z1ZJVHc3N0tXbzVROSswVDRJTHBlcEpoeVdK?=
 =?utf-8?B?ZGlMZkpDajFrV0l0ZHYySW1acFRwMUJaNzcwOFhTb3cyYXprK3htc2h2MmEw?=
 =?utf-8?Q?qF3B4+rLmdVUcDGlJDI93ycmcNUiMH6nlF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 19:07:35.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: bb36c833-0868-432a-12f9-08d8b8bfa761
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuqwIXzs+T4G0REbTZMD2t8QnM7wIGtf4vaCxMBzJpDBgKrHBKY06U3xlW4DBHZEpbo/N48STqwl5106qUcksA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2780
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Unconditionally invoke sev_hardware_setup() when configuring SVM and
> handle clearing the module params/variable 'sev' and 'sev_es' in
> sev_hardware_setup().  This allows making said variables static within
> sev.c and reduces the odds of a collision with guest code, e.g. the guest
> side of things has already laid claim to 'sev_enabled'.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 11 +++++++++++
>   arch/x86/kvm/svm/svm.c | 15 +--------------
>   arch/x86/kvm/svm/svm.h |  2 --
>   3 files changed, 12 insertions(+), 16 deletions(-)
> 
