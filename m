Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E128E3E4A73
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhHIREM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 13:04:12 -0400
Received: from mail-bn1nam07on2076.outbound.protection.outlook.com ([40.107.212.76]:58497
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233265AbhHIREL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 13:04:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVG+CK+HwvZc/i+wXy44Ek+ujpqv1HJZ1nsFx+NtpHBFbuqz6flzpjfmrcSVvAlAqzzKqCPVooUDItlVmVEJ5FoYrPRfBaRoMUqNXsPw4s/gcyMF6nP/6pbq3/fLxLa4UYhpy8E1ZZSlHQ/x9d1i2SRJBiT9F09mB4rGRy0MWgCNwVcjG2Tf10NyvAIlSZJJEcXlkjXKOo7gwCVw6dMbErO8w3tzprV5dmBNFYEGJHDUCI4tm0LxKY9he6Tummzty+fUILBpd6OTwJ46NV43QESS3YxCwIslNx2+uNqHGtH0LBPuU3fY/Yzax8fz6HwIaeTwW2jhzGFRfPCaM6WxEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5v1a2gehKOpexdL4ayIoEKPRO8p4CJ7ein6k1pfdQYg=;
 b=dArsREfEwFEXDatGMVJkoXRLJRpLBiW5bs2xVpsz3r41PddiMbchItFUCyN50zxJfvu4y5tPj4QL/A2oyni7UdqZo6Wy8OF1BVVI9ZruLxWHkZX4bCPgv0de7XcNgDDaOdk2Ae7r7Tcd0ORxmG3b2xHZaNXz3MqobzI0ijj8ChAWp0GNCFqOABay4c+eJlgswCALEkYaEja/Bkl1P2B4whADWtJOSSS6tsSoZqf/RZKUupDlaHvDlMphHgsI1rHSFz3Wy47LdCA4Cwcb3IHTKK8qJ4gfqXC/BbHGj21qdXiY1aWAXJ7jntMVWK5DRWFcqI5FjDBMEohxAUjFl7tGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5v1a2gehKOpexdL4ayIoEKPRO8p4CJ7ein6k1pfdQYg=;
 b=FhhB6c0bQjnNBZ8O+8IWCzHKsJCfZwUf0KLnoBrVk6jUO7W2NC8H/cf1WXG3IVQH1I3fzHmBK4a7wqHN/+6MLCvxFoGUH9vPTUB1q33UrT7SRfj5Tz+PPIhfM9g0StyCEzLsU41U+dBFHKLYBUuCzP/b6OIYrNh+NuQqsHUWeqs=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 17:03:48 +0000
Received: from DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d]) by DM5PR1201MB0201.namprd12.prod.outlook.com
 ([fe80::7410:8a22:1bdb:d24d%6]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 17:03:48 +0000
Subject: Re: [PATCH v2 2/3] KVM: x86: Handle the case of 5-level shadow page
 table
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-3-wei.huang2@amd.com> <YRFG+NDkjVK0myDn@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <52fe9c7d-a97b-06cc-570a-ba2d83f26d7c@amd.com>
Date:   Mon, 9 Aug 2021 12:03:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YRFG+NDkjVK0myDn@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:805:ca::29) To DM5PR1201MB0201.namprd12.prod.outlook.com
 (2603:10b6:4:5b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.84] (165.204.77.1) by SN6PR16CA0052.namprd16.prod.outlook.com (2603:10b6:805:ca::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 17:03:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1011b8f4-66cb-45d7-bc74-08d95b57a781
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0107954DFD5F0CE24A3F6963CFF69@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9sXNXBWfO3Kd7uou9MjK5A+uD6H34D0Ck831RpvRvk8+VyDZlYi6G0OhDa6O1PD5rVU/2fEWok8G4FOR7D6GDaaoVmet8brf2BqJOTYvSiqUGHCFxC13YYfl+5erxkt2AxWHWc6picrM6H7DXbmE5JuX2dxQLu6qbHzq7um5r21CRbbrSH8os4hvMe3MSLle2YCaqBNas/F54gkgpSooHFfewAH6IV/jovXBWDmgtBReWaYFP98kP6WN0GQGnpwKTwwqZ5U6OZTYjZxIDO+6JfY8qp7eKHl41M+dItQd4Vt40XxyzrGQU05V/Th/gxKg5nw8o3Hac2qNfQowmTim/SedwsPuzz0WyApNe3Zq0k8OjBZkt9T+knnxztcjVmvmIaie3av6uPoKRFpNWXLIjkTtpt0OEjgsv6QPr1i5iylCVqUToDLCTGgiFRzh99mOid4LrlYwL9fT3KnmrB5OHip5Rpt9+vDg/Rpx2EkPxuKkQOt6H2yHEDWxT0KWCO+ZBDjCY39OrqIw3Ql6j/ZvtNWj5ixZXuqIwvnM7dyFq+TYQ2xS+srOqUBOn3X3XECS2mKrkx/lXHqGqY9i+sMi85/3T7ZZPZH4BuZbp90YT40ah4P81gHcKgsKkkKZ8JMZ52TEW+pnYgLesEt2nutjc6UJXMLclIdmSvvFfM3bUldp5zStUbSAd4vVNH0oypQht7vsVCmcqPifIR9Oza2kHhES5ik9r6lPnPTJ/mk2GJPgWaZNfI5NvX4OfB7t8L5q7j+YZePmLk1U2aeuBr2Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(66946007)(86362001)(66556008)(66476007)(16576012)(6916009)(31696002)(8936002)(316002)(478600001)(38350700002)(38100700002)(4326008)(956004)(5660300002)(8676002)(2616005)(52116002)(7416002)(36756003)(31686004)(6486002)(186003)(26005)(53546011)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1kzWnUzMEkvdURvWWlLNy9aYjJvQ2tERDMveVdLWGhvUDZwdDhnanN4Ym1i?=
 =?utf-8?B?TzYxaWlDSWZ0VmtlN0N3U0VnV3FPRlAwSERTdHluRWtNakFpY0s4TVovN2pR?=
 =?utf-8?B?ekNaaTBNcWJBUDdtZUhMRFV1aURqZEdhb3k2UFdseDlTcDBQbUVhVzFxb0hl?=
 =?utf-8?B?bjZkMDdvNU81ZUNuUHVlZGI3Tm5CRDJ2bHlONlk5bVlGNG55clZBM2RCK0w1?=
 =?utf-8?B?bmJvaUhqUElrWkp2UjJhRGp3WXZXTkM1MC9EbEtYV0kzZm5hMDVCSnloL0Y4?=
 =?utf-8?B?K2ZHZ0xFRDFiNXFPQTAwWlFVcXRYSnBBcUJFeCsvY2k5M2F6L2pxdFlNbTla?=
 =?utf-8?B?aEJtUmhwbEF1aVFGemZLOCtVaGRUeGpwYXl5aHhSencrb3FscnYvR1NrRnR4?=
 =?utf-8?B?SU9Mc1JtREZEMVJxTWp2UGtDYVl4YitoZmdVcXJBelJTUHdsbkRSTmYyQnB4?=
 =?utf-8?B?NWNpanFDUWoxSmtTYlBpSXVkdlcvRlNPYmsyKzNoRXB0TTBzVDlsWkJONEY1?=
 =?utf-8?B?TWpNbXF2UnlDMjk0WXdBZlR4ZnZ4citvZDh6L2p0K1BEa3RVU2FQbTBRRDZn?=
 =?utf-8?B?Z1ZuTW1PWEtlUDRlUm5LMWlXdWlxVU9Tb3g3eW9sUUp2WWEvM3YzUVdlUXU2?=
 =?utf-8?B?b2pGTTBnUEw4WXRyTldpcHpIbDJyWURzcUVvNno5ZkU4cXhqeDRMRzlLeHJm?=
 =?utf-8?B?SlpVeEJIcDh5cW0vdWhydXVuUjFaN285Y3QxbmZKZFZ3a05MTzJYbkdsY0lI?=
 =?utf-8?B?bEFEdzNmKzl1WFBFd0dKQTl1TlBjVXRRUXorTnZOQzZEMXh1ckhEWTFkNzVW?=
 =?utf-8?B?c01Bc1QxUWxHZHdMTGRlWFdRdi84Vy9DbDk3RklNZm5ybElMMXEyc1RZSlov?=
 =?utf-8?B?a3RYUDBvNHdsODlYMVovdTZnN2VnWkF0U2dnaE1wblFrckpXb01RWG1vS01q?=
 =?utf-8?B?eW5veUQxcE1VdVVkZWZjUkZydjFDSVdjanpBaDdERk1oQUxyVE1KTFpiaElF?=
 =?utf-8?B?eVg3aE1DTjZCN0FmN0RpbnlyRXpmcWp4a2FZeFk2UVpRMThBeWVWZ211N0hV?=
 =?utf-8?B?Y1JiWHUxVzVWOUR4TkppcHZmN1RWZlFTZ21QbE5vUWh1d3VZMEVaTGc4MDgw?=
 =?utf-8?B?d2NzU1hYUDR4VlpaYWlWNmtvU0hjR29EVmxvTDBRN2t5akI5N3k0T0VlT3M4?=
 =?utf-8?B?TzNGeXM4N055NWgwdVdRcEY5NEJXd0VjTFRGTTdHOXhHRnBvZThCaTJVYkQx?=
 =?utf-8?B?ZG1kRDBNVk5mMndVRm5xMEJVRUJaTjgvR3FvZTY2Y25oTFpZTWxzMkpOTkp0?=
 =?utf-8?B?MHJ1c0l0ZnY0cnVwRTNSRFdCNzRvUW5RNWkzY05YcFlHbFdoNXQ0SjAyUFVx?=
 =?utf-8?B?OGNmWVBvMGRTQSs3Z2RZM2w4N3VOb0xPSnU4YThUSG94d3lmMWFFaW9RTnMz?=
 =?utf-8?B?VW9ESlVPb1I5c3MzQkxPTTBiektLVWFjVWtZM2RTYUlUVUYzcDUxTG1xK212?=
 =?utf-8?B?bkVTU3FER1ZHVDhGZWJOUXFKKzFvMENSQy9EQVpManRqMVpvWDBHS21jZ0FL?=
 =?utf-8?B?T1c5U0x1SUdGWm1jL0xLZWV5RllCenRudC9hR1ArUC8zTGQ3UWsyUGZKU2Ns?=
 =?utf-8?B?L1RYbnRVbHVoUjNjbEhaU2E1NnAzcGR1bU5rdmtZVzk5QTJvOVpsM1o4TU9B?=
 =?utf-8?B?bUMrSldOT0kzVFV2VlJuZ05KanJRdnhQOXFoSEpmRzFZdTIwT2xJZW54Y0pq?=
 =?utf-8?Q?e8+5WLJr6vgxv3fqQYFMnATXD7GzPPKyjQ6CHBq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1011b8f4-66cb-45d7-bc74-08d95b57a781
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 17:03:48.2174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aP8hzMQ+JETK+UeTAgMSUPugpYfwc/tT1hlE2RDkjMv+qSndBfDV7FazEtjITRXZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 10:17 AM, Sean Christopherson wrote:
> On Sun, Aug 08, 2021, Wei Huang wrote:
>> @@ -3457,10 +3457,19 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>  		mmu->pae_root[i] = root | pm_mask;
>>  	}
>>  
>> -	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
>> +	/*
>> +	 * Depending on the shadow_root_level, build the root_hpa table by
>> +	 * chaining either pml5->pml4->pae or pml4->pae.
>> +	 */
>> +	mmu->root_hpa = __pa(mmu->pae_root);
>> +	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
>> +		mmu->pml4_root[0] = mmu->root_hpa | pm_mask;
>>  		mmu->root_hpa = __pa(mmu->pml4_root);
>> -	else
>> -		mmu->root_hpa = __pa(mmu->pae_root);
>> +	}
>> +	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
>> +		mmu->pml5_root[0] = mmu->root_hpa | pm_mask;
>> +		mmu->root_hpa = __pa(mmu->pml5_root);
>> +	}
> 
> I still really dislike this approach, it requires visually connecting multiple
> statements to understand the chain.  I don't see any advantage (the 6-level paging
> comment was 99.9% a joke) of rewriting root_hpa other than that's how it's done today.
> 

I can change this part in v3, unless different comments from other
reviewers.

> In the future, please give reviewers ample opportunity to respond before sending
> a new version if there's disagreement, otherwise the conversation gets carried
> over into a different thread and loses the original context.
> 
>>  
>>  set_root_pgd:
>>  	mmu->root_pgd = root_pgd;
