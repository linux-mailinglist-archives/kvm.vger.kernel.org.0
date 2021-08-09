Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458B63E3F0E
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 06:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhHIEeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 00:34:21 -0400
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:17258
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232887AbhHIEeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 00:34:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msCGC2Qxyn3NCPNFvkHS3fDGYQjMXkLrnpJz4h8vfZzvjxFP4QkD40crhdPOYIt3XcXaYEjmpfN3dePFwJiwGEUl1zD7JZ+X53Gl+9MY1QCAd87Y8g+Z2A/3DPh6DTua5QUwJncY1j9P9JDEwHm5tMbXlYUFYXfzC8NntDwODvy7V+4g2QVl8cwzJLVpBRDloH3o9oYFxKllhHFkvuP8m90WpuytFvasCtxaqKBUm0w1IcbRokB1n3PfiXZXn9uBjaeJvv96rpB92zOfXW9+Rz8Zzes7oBEKdb3a56zgIIo/PIrJKsc2FWrm9kEB4tzcvoaYCHt7rozVxIrzjPq6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFPM4xA8zre0oiXrTLsXtphegHsQYNrAOmyL+Zgfht4=;
 b=lgUEE2MIlSa3BNtutHvhBw78r7FKKvIhYWhkFIzGsNUzSwne87+MdVcJ3RvfJPvmr5ZOX+KjiAuCZfKf+403KxZhLDOCKYZtu/Gil+eDnPMB+iERIaCWfYDZ3TRJ9IThAcZlfTBb/uCssRLaetv4QfKlJ0AUqI+A8myn4086kdYuVajZX+nw2xJ6ch18KdghMrHcYJtTu8b6OoUQL6lIVr27AVlHfCZmrIVcZEZAWrV5K/wAIOI94L8R+lVvJrvDF5yUEN7UraswpzCnoA9Vy9oHKCrTSOH7/K0w7quj1f+wT5h5QyjJADTIlrHEWBvXpeHf5xxQ0TgB90zOZYAM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFPM4xA8zre0oiXrTLsXtphegHsQYNrAOmyL+Zgfht4=;
 b=EuI15Tex+Mvrk7KUDm76n0kHZ0AqzJDQ0we1AXvLVa1sSm43i/XD2uQhiNNeg0xLH2lG6d0DRQtwR22Ov6d//ffOHrl8jbsm6BGGJMdxz9l90Ka1sbjgV5sGj79aMjxJMEqytm6WGANVDij/aRABbrx+23VBeTRXwaPzHDn9PRs=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from BN6PR1201MB0194.namprd12.prod.outlook.com
 (2603:10b6:405:59::20) by BN6PR12MB1170.namprd12.prod.outlook.com
 (2603:10b6:404:20::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Mon, 9 Aug
 2021 04:33:49 +0000
Received: from BN6PR1201MB0194.namprd12.prod.outlook.com
 ([fe80::9ab:d10c:1fb8:7d5e]) by BN6PR1201MB0194.namprd12.prod.outlook.com
 ([fe80::9ab:d10c:1fb8:7d5e%10]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 04:33:49 +0000
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
Date:   Sun, 8 Aug 2021 23:33:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0028.namprd07.prod.outlook.com
 (2603:10b6:803:2d::29) To BN6PR1201MB0194.namprd12.prod.outlook.com
 (2603:10b6:405:59::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.10.87] (165.204.77.11) by SN4PR0701CA0028.namprd07.prod.outlook.com (2603:10b6:803:2d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 04:33:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 630d8ff1-7c6f-47b8-18b6-08d95aeee19f
X-MS-TrafficTypeDiagnostic: BN6PR12MB1170:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1170489000A87BF0C12032D5CFF69@BN6PR12MB1170.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHUu8Dx+s88HReDbUq60I+7e3XGsGh8CJS6akLLMqs3Jfv6V2UWJiK3nnD4OJDvYVmOzLHCLDJQEE5rfDsi3CACAh38DJt7yKRKIQkbejgzI1AG59ueF5h3FAHvRnGR+FlsTPqpAXjCS2Fq/Bjceu9OJZ0v/8Qja3kCUFWQ77spAFBSjJmm/oBcVQyz0zTcHjoCPb4oVL0o4IsCybheCvOQXdfT5/vqXeE41WxP5tRtoFhxjBTpKgcj+ECHXqjGbto4ssuE+lu1Mi1RzQoirslvdf9WienqMm0DdA6Q/BR5LodZgfYhQttKy3nI1DxwrJPFoUxh0t2xLWad5hpaHiI92Ho/JqyLX5Ozl0jj5rtXsLl5OvNk9oCKPS3bjEvYWoGYCgnO3mFXrquPxIdOLgnsnBbIDRFCsA8QYAGVnftBHnAwdVczUEP+kX0ZQ/2m1+8VLU7TmdoQYVAcaWBUKHj2HngtaJiwAXte8H2CJyPoStxXTMyWZ1FIaJ3/r/a3bPHBiwjgn/AAFlortDR9OpsucytAMUgayMROGWeSIXrKG6oSdRwkWlIl/RspbxBpXbAG5EYRv1JEFfC3ao8umB3CjCSe2Cb/5ne+1M1lr2bOt7uAmwZ3u3/YVr4nfJ6ebgtQNnebbz53ajAXeSqSQtjzRAvMQkQrZyGcD+mPzUSBicWqkXfDNKxXszx6Gkzc7WFGG4xKA8snMZCDG/9y0izy+9/EMVaRNVCpKHvtxbVvHfkZDd1Ar74VB1v9myxVAZB7epJtyaLxF7q82ic13gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1201MB0194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(52116002)(2906002)(66476007)(66946007)(66556008)(4326008)(6666004)(5660300002)(38350700002)(38100700002)(36756003)(86362001)(7416002)(6486002)(31686004)(26005)(186003)(316002)(8936002)(478600001)(16576012)(4744005)(8676002)(2616005)(53546011)(956004)(31696002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c09xZzZLcWlBRmFGQ0NId2xTaXNESEhPaFFYMk5OaDVXVjBWSE9TeU9jZENn?=
 =?utf-8?B?a3ZGWGhZR0ladTliOEVxYUwrTFgzSGVBamVEUEl5QUM0dGFVclBkNGx6b1dJ?=
 =?utf-8?B?NTA3eTVlQmkwV3hOSXM0YzRzTkVTZGF0YnVxOThhWVRxRUN0aS9LU3l5R1VH?=
 =?utf-8?B?ZnY3ZHZPTTgxQUViZXF1YWJPOEMwSVB3THpjRjM3eXRkRTI2TEhiUFlpc2V5?=
 =?utf-8?B?KzcwMEdRVkt3aUwvaEdjQ1hNZWREYXV0bGErM2hxaFNUS04vbEdaaGdhODJs?=
 =?utf-8?B?cXF5VjREdFFkNCtDbDE0b0UxbXVITkFtemJRWnJNWmtzcnh3cHBnZWVIKzJD?=
 =?utf-8?B?Sml3T0dhcG1ESTNOeUxvOFk0S3RxNWRlWXlsNlpCbFNKRmFCVHJYczc1eDRU?=
 =?utf-8?B?T3VKNnQrMXpObnpkV095UXdRSC8vMHBNcUxhVllvcVQ5RFNlRGpPdXZHbWZI?=
 =?utf-8?B?dkthMGlvbFBIc2hSRzU1Wnh5M09qZ1R2eVZBcEs5bzFvZ0NwUEQrbEFTQU9G?=
 =?utf-8?B?QVNDcnZ1VUNGQVRpZ3lPdHQ3eUFLQUFHanMxZFVHSWM1bW1CbVF6a1hRbDF1?=
 =?utf-8?B?OVNSTTBlM2o0SVo4NTVMZ3Y1VWpjZzJiUkYyNFJDRTVXSU83dnk2U3k5dU96?=
 =?utf-8?B?Y1ZhZG8xREF3d0ZkNUpRa2NrS0FKRUtjUjI0M3plN2d1NjMwRlZIRldXWnNt?=
 =?utf-8?B?dDN1SXV3dWVIcWN3dFplekVRVWtJYjFaWjlkS0htMmtsMHh1dFZ1ZE5LdC9p?=
 =?utf-8?B?aEtRem5SczQwdHM5Z2YrUFREbHprOUhOSlY3Zi9MSElFUk5GWHkvYXBybGhh?=
 =?utf-8?B?UkNLKzJEZ0pSdDVXK1FsUHF0NkNwMURTbXRPb2dRajdMQTlVUVZQYThwdFhk?=
 =?utf-8?B?bGc5R2puRHBkdHZvSVR2c0puTHNqRG1FQkkybVBranpWdUh2VitQeFZuWlBG?=
 =?utf-8?B?elU1SjhxUUNiMmIzbkNnK0xQc1Q5amw2YjhUVEd6ZGVoZHh6ZlpFRlhKZVRX?=
 =?utf-8?B?MWc2ditkWllLVnZyb3dpOGlaenFXT1l0S1E3V3hKYkZoYjI3WjBSand0K1Ax?=
 =?utf-8?B?bTFCY21tTU1VYy9PYUkrWXZGLy94WHdnNmVkMWZkWnFVVlRyL1VneXpQeWJG?=
 =?utf-8?B?eFdFcFo5L3U3YTJ4RW5GTkhGbEU5SnY2K3hsR1Y1T0drUE5RVUxKSlJ2b20x?=
 =?utf-8?B?V3ltQ1ZLcWczSnRuOTUwd0FRVy9LNzBiUSs1VVplQUREc0RlRHl3dEduVWND?=
 =?utf-8?B?bi93Vjk3L1YrMndZT2xlbXFEbysxTFhCenFQVGVzV3pYdkxKWFdVc05lcWVt?=
 =?utf-8?B?TUVXTUxaM2I5RURnUHF0ZUgrREppbnBuWGxBTVBJQURwMStkbjNwbEZGdU1y?=
 =?utf-8?B?czhEcVBWMVpiVG9GZVVkbm5KTjdscEIySWtQWTgwOE5naWNHSldRMlRYWFVq?=
 =?utf-8?B?TkhMdEpTUHBpU0Y5aTFMdExyWS9ueGNPQkVhTzRMcEhpc1dvdnhFakd1Uzh4?=
 =?utf-8?B?TTNoVk5JRWVUMTF4aUJjT1lEK1V0R0ZuemtsWnhGMWVIT1Bmc1FiVWJOS0sz?=
 =?utf-8?B?OU9YUHlqTVI1ZXpLMUFmRVRlenNkQnRyY2ppZ1dRTmpRLzl2YWhlWmc3c2k1?=
 =?utf-8?B?V3dlRmlGbzJQMmdRWEVNait0T2JCSjRtNFAwaWJVa3Y2d0hsOXJKeWo5N1dy?=
 =?utf-8?B?eGJoOCtzRjE4UVA5SjRCakM5VmxRTElQV3VHWk83OXpPNjUrRzhGS0NkaWVk?=
 =?utf-8?Q?2O8Hi2K2o3M2VKb8D5y/NetHkLueYTQpN4jqTeR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630d8ff1-7c6f-47b8-18b6-08d95aeee19f
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1201MB0194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 04:33:48.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vfc6bQ5u9EQgTgfBEUYWnrtBv/3v0lPzZNpCwbzYiIQmHy9X4BNZl1ZLTbb+aEUK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1170
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/8/21 11:27 PM, Yu Zhang wrote:
> On Sun, Aug 08, 2021 at 11:11:40PM -0500, Wei Huang wrote:
>>
>>
>> On 8/8/21 10:58 PM, Yu Zhang wrote:
>>> On Sun, Aug 08, 2021 at 02:26:56PM -0500, Wei Huang wrote:
>>>> AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.
>>>
>>> Sorry, but why? NPT is not indexed by HVA.
>>
>> NPT is not indexed by HVA - it is always indexed by GPA. What I meant is NPT
>> page table level has to be the same as the host OS page table: if 5-level
>> page table is enabled in host OS (CR4.LA57=1), guest NPT has to 5-level too.
> 
> I know what you meant. But may I ask why?

I don't have a good answer for it. From what I know, VMCB doesn't have a 
field to indicate guest page table level. As a result, hardware relies 
on host CR4 to infer NPT level.

> 
> B.R.
> Yu
> 
>>
