Return-Path: <kvm+bounces-8745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC258560F3
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F16F11F210B7
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F05712C542;
	Thu, 15 Feb 2024 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yu6JbR2q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72CF12BF3A;
	Thu, 15 Feb 2024 11:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995265; cv=fail; b=SDhc9UZ2GysYYqAjzTb1v7ayHqG0BldRTiaGaCTgAmAc0RKyY3l5Ga9/fyY5MysaXfdQk+bFGEpfPOY8eyaNh0GqbSpEpWQbRWt9TpeCzwY2BIVzE7SnopH+KuOddGZL2bsGbLlnP5lLg5KoiVZGVZlIRW22P1C2eu60iVZqM5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995265; c=relaxed/simple;
	bh=U0AxQqD2NKi2616s+n048DN0ps2o847kFtkBRj8PRKs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DbbkQY44zVNcOam0xwWxu/W6BfKTpsXC0tDgT3mQWHTvFuBfWayvHdU6EqbuthHNBjJd34tA30hnp7Nj4/xAh3rLU3rY6j+Jiz42d8cmsw4Ucog2nysYzcIMBN8zS1L3nmfXWBfopfBwt9G628kzVPYIX1OiVunpeHu/Q3f3uhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yu6JbR2q; arc=fail smtp.client-ip=40.107.220.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPalYEu4vo9xvD2Zpv3iw50CcI6viYyCU5qVs0R/ETFzYU1qsVCeQiNp8AVpXoWwXjn3CPCIc3HNCdnKkMR7QFBtC9HSk2eteHBGeuCIC0dromFP9pFc5mtdhAdv14FzqTOuaA3RyhaqPQ07phTIeVyEwRdSMZNaUmSNLRLUBs6mJf01PMiHL8OIppjBh+Pd6WUiQGYiTGJhwC/nVa77fQf1Lo8loHN7SBJaWu+btwtMmpO0F9kplsyB2iHPpb2JuvlI5deS+YdL5/KLTXYv/M6lAkpBJiCEX+eM8e9w3NIBdlNA/q5eU8wnFdgR6nxgiNbK3pTgU+Kb/6jUvozsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShcgKAhqpCncT3ssk46CKTn0zLMWbyCW+zcEhmYKbfo=;
 b=Ntgu+UXwObjK6PE0K11ZmvmOBvSLsNqA9nJM4F9YTjQfKIsrRGh7deO+/eRkScBzAaWwsKnORLGj047FeVWt+l8g1bRLRAyL0cJSkqEhSdXeCs9VCZQ1aqSa+XTFDbz8z0h6Wps5oMx2JmWnS0ND48F1OkAQZZJvWy1pNgz56hzcLBUniUIwRqrUfep7vEkTSdYnVe6cfKS+4x2wc3GIXZWj4Wr7sFxSCdJzyDR6NnvEpxJUbYEJjAjzDgWJH/8V6exC+dqdLDThv2hLJM4lI76oihVwjr8F7ODbZbKBbHwZLYQvRtbuUfuK9pGiQ58MZ3TdCB9F6tOJEJrJOSrDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShcgKAhqpCncT3ssk46CKTn0zLMWbyCW+zcEhmYKbfo=;
 b=yu6JbR2qZtcOGXdomdcoJMaygoSwBY5F5I5+DW/Ux6w/x0Xxzz4ydU/IgH7+fym7XJi3+cTvEcOBTgMfmjoPXPG498+44PxnZYafZT/N7NkUADb69k1DZ2KADvoWxrrfnVb0Yo6lW43lCSdI/4ILNDoiT8c+ONCSL1xDW0kD02s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB8972.namprd12.prod.outlook.com (2603:10b6:610:169::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.29; Thu, 15 Feb
 2024 11:07:38 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::c167:ed6d:bcf1:4638]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::c167:ed6d:bcf1:4638%7]) with mapi id 15.20.7316.010; Thu, 15 Feb 2024
 11:07:38 +0000
Message-ID: <75e89b22-da66-4585-b82a-4e381c960b77@amd.com>
Date: Thu, 15 Feb 2024 22:07:30 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240209183743.22030-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0021.ausprd01.prod.outlook.com
 (2603:10c6:10:31::33) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB8972:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a22227-3912-49fa-7bc9-08dc2e1651c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xzql6U27H0TX9tcL+hxGdog0RpJzeEgwnIro4y8ZlWWFfnc6wfOnxGh5ySl/gMMEnm8DhV9Wsc0np1UdffA7V4bbXEeCfDYHCe4F1jpR06Uh5p42jcwBEZIg5qDGjkkX2kxF1hxC55NayYG66XOwsg9rYyvuUUCsUBn742c8DbREoJ/ZyAKmbTpVfxf5az4wJNdeFwVwQkC2sUFC1Q+79amlaauYNJsJ9nvulHxqa1nmO7SEOZpuuGXHt07qP3Ij4tFcedjjQiqEPFqmCVP1oLAhmchku8h2DRVoVkXRZGKYQMJSvF17Chs8eR3QiAeikEKBzHq/oE2++WCeWc8PvrwEybTCYpI6+XRu149PH+L8Ed1INmqWN34XIVRclQBCf8FfjAB3MbHn3UVNari2sV13XyDfMF3qG6S7Xszh3pjkZq0QpTIPmPq4WB1os9JpkFUGO/63qdXDiC8e9Aymyv/kxHUdigL7fLafEucLXtnAXCV20WN0g78V7ANSxkWxLCbikuNws6s1FbeyCzmaiEG/3hVKqFMTmmpP3zaXVj8s9/V1PnmOAV06eONSFgc6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(366004)(396003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(31686004)(8676002)(26005)(8936002)(38100700002)(4326008)(41300700001)(36756003)(31696002)(2906002)(4744005)(5660300002)(2616005)(66946007)(66556008)(316002)(66476007)(478600001)(6486002)(6506007)(53546011)(6512007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXQwLzBrM1cxZjJBZGVER3N2cm5Wd1YzVi82QlRmcHk5T05HZ3JaL3U1cEZO?=
 =?utf-8?B?VE54d1pVM1F3b2sxMmVyc0wzS2Vldm9SNmlLSURkem43Y3F4RDVZc2RUNFVE?=
 =?utf-8?B?Mm82bW1wV0JYNC9NcVJGT3J1QUJOelRtemdkZ2RNK2svWmV2ZkdRUkt0STVU?=
 =?utf-8?B?NzhUV3BIM0M2MTJGOHNYZmIwUjZta3hMZTBETTFMRHdjR3VHK3RxMHdSbW5r?=
 =?utf-8?B?UDJYRzdiWTZvZmg4am10RFBiRFBOTVIxNCtLSHp0Zk5ISkpheVU3ODlmcUZt?=
 =?utf-8?B?WncxcStJaDZWV2dmWmFNZVBHWm84TFJGT3NzR1lZMlJIb2ZyRmtWSWVQR1pM?=
 =?utf-8?B?dmFGYnZwRDR2c3VKVGppbUdqQ3NCZ1ptb1B2cHdkVmI1cHB2ZFFRTEN3UGtY?=
 =?utf-8?B?TTVicEczTGRKRTRnRVE0VE9VYzZJMm5NTkdJTGRET3IwTTlYeFRWNDdLMVpK?=
 =?utf-8?B?N2QzbGpHTjdyRlJlVm9meDZIa1M3V0tzNTNqakpDTHpEaENBbGdCdk5NZVVN?=
 =?utf-8?B?WVJFcjhzWEpVbHNnZjNRSEt6YUk0OHZGWEthWXhSQkNOZExDQllEd2x5ZXp1?=
 =?utf-8?B?aGlTOXdobFhkNHFNL01zZ1Rva3lCNXBKK0l5R3Rtc2lTM1ZpOUhNbHQ1Z3lw?=
 =?utf-8?B?NUhlS2RyOG1lWkd5MmFlRzVVV1Iwa01JcmhuVk50WEtmejI2OU1DZHNNVEpL?=
 =?utf-8?B?V1UxazVnRVRyUThyL01TVldxYnYxcFpMcmlLSlNWVUFGYjYzcTVLVENXcks3?=
 =?utf-8?B?RXdJSmVwUTJNWUhHdDdZRDhpczNlSWladWlSYkxMZjF2UkMyeDdPU1JlZXhF?=
 =?utf-8?B?alN5WldDSHNWSWw0dGZneWRqVVNaR0gwc1o0bEJBMHRuVWdBYnYxbXRsYVVv?=
 =?utf-8?B?T0pXY1djeEJvak8zUTlHVi9WOTNSd3hlY1RWU01NRjhvSXZRbldjQjVSelJI?=
 =?utf-8?B?U2cvTFkxcExDeUUwb2FzU1dyeE5MRVVFNk1obnBUQ1NLNG5CaDFJZ3Q1TDgz?=
 =?utf-8?B?SzNsL2tHUUkzbG96WUt0bWRZYXZ2TFcrbDFVVW1mRVE0bm9LcVBMa2JtUHR4?=
 =?utf-8?B?N1hzSzEyemxNa21WeWlQdVE1ejBnOTRvNFBlVkxVQzQ0a0I4QXA3VVFZMEpv?=
 =?utf-8?B?M3JOSnROd2wveHVQNWd6blFvTzB4NWtISFNxR2o4dWNtcmMrNWxqYyt1SGp4?=
 =?utf-8?B?N2Z5U3luQitjcjhhSTRmL3VKZ2ZaUjl3VkNRNDJieisyaUJVTlRsLzJlYzRu?=
 =?utf-8?B?ZVUzZVBIbndaTklmRGhiUDZtNS9GMkNMTWhXWDJCR2NscEdwVUxRMDMxUGZE?=
 =?utf-8?B?b2xKL3JUaUNJVUdvcGh3M3VTYzEzUno0SXRhMG1DS1dBVVZXOFpUTi9jQStT?=
 =?utf-8?B?UlNNZVU4R2p5OWR5ZCt5SjVIQ2dLaHAzVHMxb0VCd3ppMFZCdy95dVVPWTZX?=
 =?utf-8?B?dW5QTFpVWjhBYU9qY1dPQjU5WXhoUWhjQXlJQUt3SHFYeXFORXZ5T1MyU0E1?=
 =?utf-8?B?Uzh2cGpRRnFvREMycmFBQXVJb1daUWpwZFdWVlR1ZFFDMVlpRmVzNmlGVWRO?=
 =?utf-8?B?TURPcVFWbFNEUkd4b3dMbHdpamtXT3ExNE5HUkh4ZmlDTWM1NlA4aG9XWmt1?=
 =?utf-8?B?ajNtRmtxZHlrVTAvRlM4TDFYNlVQVThvRjFiMm5QRGRHS0dELzM1MWxQalBN?=
 =?utf-8?B?OGdVbEdRRTU4NVhiMXhvR2xPVVhSa0JtdXdxNk85cTVrRHhUTm9Qa3lWT0VN?=
 =?utf-8?B?R1FMN3pxYzN3UjlKQnJmZC9GWWN1U0VmTVNCZUMxbjQ4QjN2SHd3MzF6UzlW?=
 =?utf-8?B?MmRpOC92emVNN29jTzFVZW5BeTFvaisyZ3VCSitZZ2grbnRtUVU2MnRQbjh3?=
 =?utf-8?B?bmJtTW5VOW9rWE84a2JWYzBFZE0wWkdPVDJJRlo4SmoxZlRqb3h0REZsQXdP?=
 =?utf-8?B?N1h0V2ZHUlVQanppRCt3OXhSTWlhVmhSR1U1NjZnQ2EwZi9rVHllRU9GQk9D?=
 =?utf-8?B?cHYvYlN1WTNtZUgxaTE4YXJmU044WWEyMVV4ZWFCUVJUb244d0JnMGhUdW5M?=
 =?utf-8?B?MDdtblh2YmxYUVNtQzVqTk1UTWxLeCsvYWhkYjdpUlcwK3dWZTNhWWZQdTMr?=
 =?utf-8?Q?gsTH3EYlEWGZjyHBo4GEzALQ9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a22227-3912-49fa-7bc9-08dc2e1651c1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:07:37.8668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2UAtwuM0RrZ1z+zWGLgMOfuG2NpeSljInDFcUWdGraJxkPxtfcsLhxPv0e2Q2nApVIZXaZ/vuVsoJ83bsrfEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8972



On 10/2/24 05:37, Paolo Bonzini wrote:
> The idea that no parameter would ever be necessary when enabling SEV or
> SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
> already a parameter whether SEV or SEV-ES is desired.  Another possible
> source of variability is the desired set of VMSA features, as that affects
> the measurement of the VM's initial state and cannot be changed
> arbitrarily by the hypervisor.
> 
> Create a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,

a typo here: KVM_MEMORY_ENCRYPT_OP.


-- 
Alexey


