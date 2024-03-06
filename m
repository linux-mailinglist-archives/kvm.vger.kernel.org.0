Return-Path: <kvm+bounces-11149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C509C8739EC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C09528AEED
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C44134750;
	Wed,  6 Mar 2024 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="vkkJGBJ3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC18780605;
	Wed,  6 Mar 2024 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709737047; cv=fail; b=NvXXBOCJYpFZOvjvQuDZUgJs8kMy24lxuAkwCUVaJqztggJ3I0xnstnqz5kJTlt7zcLr7Tl+2/k7DjmpqTGCfDgE7/u/Dsq26ocf3rRG8hgC0nPkDaEI8gwNePChbBIbmr9M275Cm4AfRW9+84iksctLFY107NYu4qP2JK1++5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709737047; c=relaxed/simple;
	bh=GXALoYvBstTL3GEs6DjzQdBQ7oWnPz+UUle1dyuUTOs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CUy9JHZgjwxvSJ1iBdsiqxfApFvflfaDMiA4suZGBuruScv0u/FLPwAIeDMibPiMGdoY8KdJbKpE7alD7C3eCCIxF8uMtgiCwDWt8qP5JrFAAhW8bY3Scdwg1xSDMxfu2iNwR4PQUKzsH1afZ0/foPQCA94cCD5+PGICKFdVm+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=vkkJGBJ3; arc=fail smtp.client-ip=40.107.236.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOT5gbr6tzzvQXzDUXIHPIyVFDYa1J6iUma5MlHwXAAArq1DcCcISa6XdREIohJm6fFGO0QLm0zzGaO4bP8gKZZzJhcta9uJLlqqJTJbSJk4KzLpxIe+lJvJb4UDASpwlzbKTdJeIaQZVwl08IKjDcMsuRopn9rUF+u6aV6t2f6YN+xcDUzv+J5YmA3mIzqsP+M4cE9ue+316lqS6GnIkoXvAihfSmqm/XcTRsjcf/qa22LXVXEu759U5hczoI0ZLptVVI1GKDNZgGdoozbHQmcrw00+0aigLzlKIM9ZZzb8A9nIMboKO9iGVQ8+aVy/vb1/C+qcOTtrodFKuaH2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtOQnnAgNYmB1uUbffZwnEDbbOe+NH1H4HP3RFmqM9o=;
 b=JYIxtkCJBNOvk0pbDv4fy/LcxbD6RFXSt6VPXNKa+9nqP+hdo1/0mtjghLgAvkLksB4FvJ7LGsA3PW3GbsgAyes8oR/zmXtRvCq3uDdh6s8Xxl5Kr2QaomzNM/Sskg6H3xvKbWRD19hqtfy4+eMWt44fXGC8rSNEF4rluGsLqD9sxj2zUaavcYyGBcMzQwpIsMKTNyvyUSwQD9WbMKdVkpsfobwhjvQcH/a72b252zEXK9FLEyN7zY9RAH0jvolvidM2NE4wM8AJ7sI3nj3rEhzyHRYeiD2afNAIkaB5ROzf8clISgGWToxb8s24VxGqmmTDVtSEJ+iQhrFNEm5CLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtOQnnAgNYmB1uUbffZwnEDbbOe+NH1H4HP3RFmqM9o=;
 b=vkkJGBJ3WW134E+TJ+kRWvwfyoJR91SQ7Cf/HG9DuPb16Z4idaLhxIMadPz0VvKovqfdMKIxzUcJS4mACjmEKYtxL+ht/Y29Q8gumDNZojFbbzIASEkG/yCw54fLyD4X1iJdCql4lt+dKoS6NvsI4gSf9THhIaEH6PL1TjxH/Ps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA0PR01MB6489.prod.exchangelabs.com (2603:10b6:806:ec::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.38; Wed, 6 Mar 2024 14:57:23 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7339.035; Wed, 6 Mar 2024
 14:57:22 +0000
Message-ID: <b473a3f9-17a3-4d53-a477-cce008e1def0@os.amperecomputing.com>
Date: Wed, 6 Mar 2024 20:27:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, darren@os.amperecomputing.com,
 d.scott.phillips@amperecomputing.com, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <Zebb9CyihqC4JqnK@linux.dev>
 <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
 <86plw71o41.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86plw71o41.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0044.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::27) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA0PR01MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 35053a5f-acd8-4170-798e-08dc3dedba7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tAUrKGI5TaF6uBmeNITR6wr5e7zyOIkKLdgEH8K9Oo8d26yLq7xD02z/uDrUIOH6TgejK1KZURDgquk8egLXvDDOUGKsp9RrIyvj4/SMeji2eplivQy+q9vEUvN2mhYKeluVqfY0Tc57xEPwMh68AJHGkOBuDWOgzYu1/O0/da42de/XPjNWEx+mc9YOBn29BaHyEfN450SJt1sDBDDR8yJCU4wB2Ptb+YRrORAQYVL/e5cy1mUbqPCLSd8VbYIuQ+YiWNg5QWdaxHZ7nridPexTDOcCfgTfdgdtaCPlAt0rWKnZHuw3GJgwm9aPhX765L6+7qRVre91ytHfuD4Q5qR259yMMVsj1C5p1XkmqA9/5VMcyZn55nXt8wv+32qQxCIn39DslDD070Dax6XPSu7e1l6cXdd+ALnqXAGawrPQL1cFgrUFwp+6dlt1e+liqyz2BNLxSPXp2uh5bmtidDSty2EgzqmyYHtkYpFwe+ns7ZE3ARxcT44znpx4gTDMvMGUkc8vW4EqFFFjJ6PlSKNFyck0zZ8KoKLAgzscRyGgSXBae8Pq7ehUPfIJFBOfhRTredEsNbT9nDu3XBoj/5Z3PBK1a2BzLRiBI7a9a899FwDHF4NJOlTG/4siMFE/rBp/opjXEbL7CQah21mbtv8Vlv6HPwLHzdbRbIQzDC8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXdIT0hkS3ZqU2hhcmQ5L0JZcEZzKytoMnd1NGlFSTQyL29WdXRUK0gyR2Vl?=
 =?utf-8?B?eHJJOEpRQklid29iVktWL2lpd2NNQWxLMVU3OFBWRHBFSnYxZXcxSUZCM05U?=
 =?utf-8?B?YU5XTWxkS01VTWRJblBxVnNqSlV0NThpSGNwRGk1MkkzYmgxS3lYa0pPaWlh?=
 =?utf-8?B?YXh6aEs3YmJGZW1UMmJmWGZMZVJsUXhLb1FiVXZvOXRPbDB2Q3JMU1ZEaUlE?=
 =?utf-8?B?WkR0SnU4aFQxaUZyNGJ2RW9UV09XRFVrOGI3c2gxVUp2SlZxZlVGcHhKUHV1?=
 =?utf-8?B?Tit4bzJGeXlBK0tyVlB4b3FEKzg2NnpyY016MDd5SjFCdnlqdi9OZEhISWly?=
 =?utf-8?B?a0t5Yy9vWGNHYmc4ZnBrNnpXSjZrU1lzT3Bhck5QdSsrVS9WZFA0MWcyTUI5?=
 =?utf-8?B?MW5yRmZrNitWTU1EZG10SEw3dUtnMWZBamFpdE13MnRhRDIvMnVWWXo1eENW?=
 =?utf-8?B?aGp5endaOW9hWm4xdTFwM29Fdjl0UFo2LzNtdkpsMTR4S2ZkYXUvL25teU92?=
 =?utf-8?B?ZWtub3I2QS9rS29kZUhHSXFLSUEwNWVoRW1mRi9MODVlR0JNQU04M1NNYnYr?=
 =?utf-8?B?ZVZzbXQyazZ5eE1oN2lzOUxVM29GOW5Ma3NnM1hiVHpjbWtIVmFEUStvclA0?=
 =?utf-8?B?MmpkeTdoVzk4RHUzSDY2Slh4QXBUdWdyNXA0NTJOYXVyRXlxdVl3bkRTMlc5?=
 =?utf-8?B?MEI4K2t1RVl3QWdqQ3RoQkRUTmppVytzMENyODh3YnZqSFRwNmErN2RxUDVu?=
 =?utf-8?B?ZGtRTG9Lbng5dkJzZnV2eGJVbW5QNkpDV2VFT2YyQU93d2ZXZG5CUGhRM3Rn?=
 =?utf-8?B?UTlUYS9qVWpYRC84QUtMZHdCdStsSG5LbzUvYzVpMEVPYll0WmN1ODB3VjBx?=
 =?utf-8?B?SEJkSkg1LzJvWWM1emZMekhNdHZHRi9QR3MraFpsQVhUMWhtS2xaaGNaMEh5?=
 =?utf-8?B?UXBuSUFMZFRHaFlRMWlxYlc1OXZMNE5oamZwR1ZvWlhteTR4RTQ0eUFWR2da?=
 =?utf-8?B?TnpZak9DSXVSa3hRWlUxSTFUZC9DY0FDR1AzejJFa1NWQ2NYM2t5aDlLMTR4?=
 =?utf-8?B?cTc1cXpSb1Z6dkpKaGc1bnZldi8xNzJVVkNNa3VwVys5QlNiU2ZPMmx5L0FW?=
 =?utf-8?B?Rm0vc2dZdDhuWUkzTERsdzRrVG9ISFAvV0U5ak1LdG1paUNKYlFySUJDdmta?=
 =?utf-8?B?Zkg5dGR3emJrRmpkeG5ESGNvV0NFUkN1b002RjRuM1V1MkpneTBHUWx1aWdy?=
 =?utf-8?B?Z0w4a3RodUJ3YmY0TGJ1UWRhOHByWmpzMWhTNXRJSmc3RUQveTB0aDZzVFFR?=
 =?utf-8?B?NkFIdFlUMFRjbW5kVWEvNFQ3L1FrWUt4OFg3VGFiMkZ2OEFQYjJCN3lKVVFN?=
 =?utf-8?B?Y1pHVDZiTlVUbmlXL0xiMytuZmlnOG1RdFcrZ3ZTQ3JBbUV5NzAwclltVjdE?=
 =?utf-8?B?allrQklEaGZwZ2RWQm81elFqQUlRVEFWMUpHcE5sSW5mNmUzUVZkclJHOGJK?=
 =?utf-8?B?RHJoZmJ1ZkpXcnJ2SDJ2cGVZWHgvUzhPNkgzcGZIVmhEN2RhcmNBMnJHLy9o?=
 =?utf-8?B?QTUrWTdIaEttU1ZuTTdNckNIS2dXQVE2M1VZZVFaV2JiUDBrSXBuK1dEaXBJ?=
 =?utf-8?B?Nzd0YUxkY0J5R0ZuQThjaVdMUjhHeTFheUl5YmpDNFB2c3R1RG5xUmE1Tm44?=
 =?utf-8?B?clhFbTdlNi82YldsbjRKOHM5U1NTUUk4M2hlS2hScElPdy81NlJTZG9Cdnpx?=
 =?utf-8?B?a3NyTVJhTUg0RFkyeE5VUEJhMzJiSWtlVG5MMnkzSmJoQ281SlNaM0tseXBB?=
 =?utf-8?B?b09Nemw4enJaODMxZGFrUWhBRGMvbjlKM1dROUtGY2hpakhPSnErRnVhZFZk?=
 =?utf-8?B?YnZHMGlidDJYT2cwSUQ4R0J5WjdYWkI1RGtxRkFrTWNlci9QUVhPVjFEK003?=
 =?utf-8?B?alhhdUVmU243MjJTdGg2c2E1MWkvYXg5SWx3dE1raTBDK0hFUVFPNGRyZlFS?=
 =?utf-8?B?bkxpOFh0dnVMZXBYeG9TdzltZVBaUmluMlhVdnFyRnZjZU9ZbXFSeHBtbGhU?=
 =?utf-8?B?VThNMUV2K1JrZGlnY3RaSVFUelV1RVZtYThYUktDTkxBSEthaDdCVkRReUp3?=
 =?utf-8?B?RUNrc29jT3hEUlBtSjhpdTNvMEVPdE9WdTcrSHNwYWh3M2RJekpqVWRQVjB2?=
 =?utf-8?Q?4ajW1odYLQQGIvypTG4s9tE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35053a5f-acd8-4170-798e-08dc3dedba7d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 14:57:22.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHcnov6hThZjnnm/gie7r9ufSrRVyHriEXnrOa7woriK9CVqmIdzKZhzt5j3RP5A2q1B2hV6nXPOB06abWg5CCSCMUWCNeqk1SAsQijUN0lUdbDMP1bVDlkTUiwpvvXF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6489



On 06-03-2024 07:03 pm, Marc Zyngier wrote:
> On Wed, 06 Mar 2024 05:31:09 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 05-03-2024 02:16 pm, Oliver Upton wrote:
>>> -cc old kvmarm list
>>> +cc new kvmarm list, reviewers
>>>
>>> Please run scripts/get_maintainer.pl next time around so we get the
>>> right people looking at a patch.
>>>
>>
>> Of course I know this script -:)
>> I didn't cc since I felt to avoid unnecessary overloading someone's
>> inbox. I don't think anyone(even ARM) is interested in this feature
>> other than Marc and me/Ampere. Otherwise this would have merged
>> upstream by now.
> 
> You're wrong on a lot of this. There is quite a significant interest,
> actually. But in the fine corporate tradition, not even my employer
> can be bothered to actively contribute. These people are waiting for
> things to land. I'm happy to make them wait even longer (I'm paying
> for my own HW, so I don't owe anyone anything).
> 
> The architecture also wasn't in a good enough state for the support to
> be merged until very recently, and it still is broken in a lot of
> respects.
> 
>> BTW, NV feature development started way back in 2016/17.
> 
> And? Cc'ing individuals and lists is basic courtesy, I'm afraid.
> Please don't leave people in the dark.

Sure, My apologies, will not skip in future!

> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

