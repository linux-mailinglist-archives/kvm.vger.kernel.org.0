Return-Path: <kvm+bounces-11104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F38EF872E61
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 06:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B063A28B6E5
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 05:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC8CBA38;
	Wed,  6 Mar 2024 05:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="tdkp9yP5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2111.outbound.protection.outlook.com [40.107.220.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE351BC4C;
	Wed,  6 Mar 2024 05:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703083; cv=fail; b=fv7iz6BEav8PefufZr/+5yZT/xlhqHHNBAro9W35Po5s7d7+UVYf9BbWl//MUgMRlMYFfERO+VqlJ3AbzhXuMyAfEdGmm9av6aT/M7zZqri/+0NEDLtnqu9EGDfpux0L8OvW6TcVdd/CmlVTCGi2Ok1VakxLh39BNz3+tg8a+Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703083; c=relaxed/simple;
	bh=15ihCUMFyCFT+Q7/z8oQtBWCtN2GtMKp5V/oPbUKsbQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lj6Lz/4CrFx9TqCKSn5NK3DylO8gpKtPPRcQdyy7kDlGOShe0PTt4D1/ij+kgLISLJPhCKbuKh3CRQ4xqjhEeUjzrLADEPLJ0WzFXK5rXZ/v+MYv8JKxU3ecqXWlFK94VYuKXGpPVciw4ZWFU15w6uSyu/vMDiMLPcxbGqLPBTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=tdkp9yP5; arc=fail smtp.client-ip=40.107.220.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zgg3BKHsY1EWvLKiPSE9k1HPJB39nRZoLFHJpDCt/U62qG/kJmHqq5PCkTmEBAdgYAv7fqv0m/0yq7DxCJnDSxfnb6FWZE75fe+AxGJpw8s4AM3/PVvgIuIm2/05MZqDd+C7odRq1lZ1xIQw9XYDYhJmFggXsst2YXm82L65JL/QRRkaBcwMijUEIU/EY8D7/gX1ep/q24jPw4Edh3m8Yscz8GHcTivMv5uB1wkb0Vmp+XLoc07md2Cqk1rFAU5hlm3lqoHk2m7eKTsUiiYSOicwTVWun1itAabyOrt2Wd1H5UvhsGZNdhA6DfqLpYAc5SS3wmTiL7nkTzcLLxWBwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSsErPnPH5VnY3x+qIrHYfUqffNXqeBD9V4XaZqTjuk=;
 b=oMwH7EYFC+YvjIAUOteoBZVmDPhramH54EeF+BZuAomYCTL5uRoxonku2/AzKBc7M34ftkn5nrm8xL06wAkHvFUJcG0Cn4tuZPcyHJk4pb88Vhs/Ae7tYjfycgqNLtHWntrPy8aoyM/JekUgvBqgs0BZUgjGnJsFxQkJSkKWq6L8wwwz7a8xPpHEfVwiOBkMdgzBuxJG4LOx+3989RPisu4GdDVpO+zQW8XYOzpF9hCnIne6k9E/m5KYPC/xaUQvXzaAmvoYeXmiZ+82Z6+6ad1LBXXF9Cg78cyAPIg9xiQTjY86ZyKq46J3hgrVCYd9ziHBNQonp+WzK8aGyusksQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSsErPnPH5VnY3x+qIrHYfUqffNXqeBD9V4XaZqTjuk=;
 b=tdkp9yP5a6saQf7ofDcq5G/nZnshwd6IwTRnrTEa1iEpUf5AdZwyK3jqK1lZX4Y4OgdLf9phY55qlqd2MeTe45bNHk9hdaQqNb2RTYhZsWOOWoz7zXUjqnMMXkvbIeM+iGLWfDNJEhiblCrQHoJEWSAH92OLqhXq4dkFO3k0lng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB6119.prod.exchangelabs.com (2603:10b6:510:d::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.38; Wed, 6 Mar 2024 05:31:17 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7339.035; Wed, 6 Mar 2024
 05:31:16 +0000
Message-ID: <8e2ee8dd-4412-4133-8b08-75d64ab79649@os.amperecomputing.com>
Date: Wed, 6 Mar 2024 11:01:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 maz@kernel.org, darren@os.amperecomputing.com,
 d.scott.phillips@amperecomputing.com, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <Zebb9CyihqC4JqnK@linux.dev>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <Zebb9CyihqC4JqnK@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0034.namprd07.prod.outlook.com
 (2603:10b6:610:20::47) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB6119:EE_
X-MS-Office365-Filtering-Correlation-Id: f531f617-31cf-4534-1abd-08dc3d9ea554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GA8nJdZX8vSurkpzIGVWE9mcn3ZfmXbXmF26jsOMH7jtXvcOCeM4/kx7W99Y8vcsHNuhrEMxenbc9x91MyJxEG9zMvhxXhiTCQnfHLaeqQs4H59Mj6QDyWHlChkOnOntX1gEVrhlP76jIRuZO28RVuNLkW3jqUvoOywD0BtsH+8VK+bzw87mcmy0rTCn8kjd7ZVUqG7pMBQwfXKmb3KlHfhIv09IHDrOwOaagSHfg+5ScKRwp+oPwBa8gA6HQVTx/Ukeh7+DhnwuPvYq7pgA6CU9nqhq66eEkmgOufo5NNZoQmmB5Fjqc7pKZ2GcN6JS74BGBOyT3vAyksVdIugZTIRSB+SJF4PZZ8kltHzUI7O+qm+y2HePhk6z+xx7vq2qzyGrsBJkpMZM964+9xUjbzRisg6ImeCqpxzVonD4bKjbM2dt9t0euLJ/4eWggIF7yZA4IrrAssnTITGHDwOduTAwgiLFwrMm6nweJpAFBGiBpCRV3wKYCs9FiNeG/SBs2JbUCRkgZlz9pvmhwbs2ecPvTMWH+GbMdhaohucCOng6c0wiv0zsQTbUosTcKM3VZ6WmBBF0+WVpAjdZYAj1bXqQn71+E89PUMKckuFuW3N8zWQuH7Mevx4dfGHcSk8Mg8rD4kDuFGaiV0IXtHQrhFl2OEnmZkj5Th517X1uXMY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUtRaUtNM2NtbGo2ZTlsN0VGcmE0cWNpa0xPR3NqTXVwN21mNVlTU1c3NzJi?=
 =?utf-8?B?T2pLKzFpdUlMb2h0SzRhVnRveUxpVTZmaUxpc0VYb2gxZFI4cUVqS0Z6TGJ4?=
 =?utf-8?B?NHJ2Q0o4WGJETFNyVVhkU1VEMGljM01YcHdWZjhhWmRaVEw5aXowekpaK3Ni?=
 =?utf-8?B?TnZjQm0yaWVPalhuNzZUTnNCRG90ajlxaldtWVFSY3B4SmZxOHlTOXRkZEV6?=
 =?utf-8?B?dUkxblZhNWVUeDRTYWYraVhWczNWVWVSN3hRMTVYWlAzWHlrb3FhM1dzTEFL?=
 =?utf-8?B?emZtd0RnRTFKVk1yTHB2SFMwdCtkY0pEL3hMODBEQ1BLbzNWZmVla3MrV3l4?=
 =?utf-8?B?cmtvcm9KY3Z6cFFCeDlNNSt3aGJDV1pySnRXTDdUS3JwTHRhcGZ5ckgwSVJm?=
 =?utf-8?B?RTdCSDhEZVovcnJuekw5ZC9tNDhvYzVrb0xRWFpQY0NWS0hwWE9vc3pEM2JJ?=
 =?utf-8?B?MjJ5TTdQRGUwWWdyN0NXcE5yek1tMjR1eXJzSlVvcS9VelF3OGlIWFY4dlpS?=
 =?utf-8?B?RVhYRTJkSE5jWWp6WUhuKzZOZ2xTZjZwcXNlUGc0QmdwQkFBYTJYUUUrREpo?=
 =?utf-8?B?OFJ5NGlLeVdzUlV2eTg3QmdwOWQ5cFM4L3VtR3NjaEhMdE5JQitLSXN6dzRN?=
 =?utf-8?B?QzM3T2hqNjVHRURKdVNyejJjUG10Wi80elhVM3ZKWmNDeEVRMmZ1SXlSa1o1?=
 =?utf-8?B?RVJ5MDlhOHo3cDFEWXYvM2tRTHpYYU5QaVc2clZ5MmV4TTRyaG0wSVNxZUFP?=
 =?utf-8?B?aFk1b2NsSHc4bHFXeE9hTGNWTU51QVRFNkZtc2ZFb0RIMGRsRy9WcEFBV09o?=
 =?utf-8?B?eUFlQlc3S3VBVW5saVF5WUhsZmtzQkhhVlgxeG52NkRNMkZVbzNvNEE1Nysw?=
 =?utf-8?B?M2lTT1RJbzFzOWdHWEhETVpjZnFkaHIzVEFyazZBVndTM2VGc2lrU295ckZP?=
 =?utf-8?B?UGFiU1o0ak1UcU1KdEgyQkMrcHBrcXNtcEQxNUJDWVFzZlBpUGdxS3RGYjdI?=
 =?utf-8?B?NHN5MHFTVDlXNGlSYkNlWmtMYTJrRjEyQjRSVHRkL0V1enRNM21aT3FsQy9Z?=
 =?utf-8?B?Z0J6dDVXb2F6Qis1aVZqS1h5RTRIUW1Tcy81bENCZS8yUzBIR3doRmQzaDgy?=
 =?utf-8?B?MkdQRUYwTFVlaXMzemFRemYxbDBNZWxpQ28xZ2swdWo2SXdIS1ZwOHVXZlV4?=
 =?utf-8?B?aFdUWWgvMlp6UlFwcStHZytBUEpNb2hneW91UWJHTlRhWi9DUEkwRWVsbzlr?=
 =?utf-8?B?Y1gxYU11aWliV244bThUeUd1WGE5YVhZanBZSHVMOWhuYzJRZlk1VWxwekNj?=
 =?utf-8?B?UE9UM2FIN0VhZUR5MTdtbkI5dGZnVlJ2aU1IaTZOUksyVWNEZ0g3clpZd2Rr?=
 =?utf-8?B?YmY4aE5vM3JqVFRoL3p2UUtmZTFiT0EyN250VkhSZ3N2N0FVd3lSTlJxZGhM?=
 =?utf-8?B?TmNUcEpQZ20wcG5XdDdydW1rQmVpYkVxanowak54RXJsTElTUXRhc21iT1V6?=
 =?utf-8?B?cjJ0RVhTQ25aOWNpUkN1ZkJWYlFyRzRNWlFlamsxaExoOElOazJLbDFndTdQ?=
 =?utf-8?B?d2c5QkM5eDlWa2VUajY3eXJCa1lqT2Y5UUhoOHhMaEdVd0s2RTVxaDNlRWNL?=
 =?utf-8?B?eW1SVyt0N3FDVDZBVWRsS2V0M2NVa1Nlbmxha2tLbDJBS01mbzlzT1NlVWxr?=
 =?utf-8?B?eVFudWRkazl6T3Z3Zms0dGh6SzFDRUhiYnVqUG5hNTNFTHNQQ0tSSTJKZldP?=
 =?utf-8?B?Y3NNMDBjaEpZY3JrTkd5SmNZVzk2bFJtZWV5aWUzN281b2tGK3RPMnNqRFJL?=
 =?utf-8?B?ZEwzTmc3NTA3SlpYOUEvempKWlpHdGlTWWEvUm15djBTOWhKRFdwWnRFWjlC?=
 =?utf-8?B?MzRRLy9UaDRreXdTT3BxQU5CYjNkNXZGb3VjQlFNZlQ4blcyVTh5dTFxTkRW?=
 =?utf-8?B?WHRHNVlFUzNsNXdrYVl3SFQxTjZwSTJLcU1iZGdnSm1UMnlzTDZPeEZ5WUpm?=
 =?utf-8?B?c0ZhbHJTYWN3WHJzNXNHaGcxN1NxOXVBMW9KTHZoNXpjbC9FeWtpU2RrMWZW?=
 =?utf-8?B?T0d5emJaMjNpamRteVNldHYxcWRwUjdsV2ExOHV2d0o3d2Y1allOTjZOdjlr?=
 =?utf-8?B?Z09xV2J3OHFxMGFwUkJQMEhVMGxPZE1UdHZEZERlcG5XTFE0OUNJQklJakw5?=
 =?utf-8?Q?qULJK2Coyn3gWARCDF9O3AA=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f531f617-31cf-4534-1abd-08dc3d9ea554
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 05:31:16.8784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3VKAtUPAYu4SOZk6ki6D3fDVk4F6MJuf0lAMep6V4YikZ4/MmZUqQx98UUMthZsdt9qe05It6v4BLxNMVtbte18LUy5U7Dv5USY1QsTvo1D+HRCzHvq/YGsfDdUq3R7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6119



On 05-03-2024 02:16 pm, Oliver Upton wrote:
> -cc old kvmarm list
> +cc new kvmarm list, reviewers
> 
> Please run scripts/get_maintainer.pl next time around so we get the
> right people looking at a patch.
> 

Of course I know this script -:)
I didn't cc since I felt to avoid unnecessary overloading someone's 
inbox. I don't think anyone(even ARM) is interested in this feature 
other than Marc and me/Ampere. Otherwise this would have merged upstream 
by now.
BTW, NV feature development started way back in 2016/17.

> On Mon, Mar 04, 2024 at 09:46:06PM -0800, Ganapatrao Kulkarni wrote:
>> @@ -216,6 +223,13 @@ struct kvm_s2_mmu {
>>   	 * >0: Somebody is actively using this.
>>   	 */
>>   	atomic_t refcnt;
>> +
>> +	/*
>> +	 * For a Canonical IPA to Shadow IPA mapping.
>> +	 */
>> +	struct rb_root nested_mapipa_root;
> 
> There isn't any benefit to tracking the canonical IPA -> shadow IPA(s)
> mapping on a per-S2 basis, as there already exists a one-to-many problem
> (more below). Maintaining a per-VM data structure (since this is keyed
> by canonical IPA) makes a bit more sense.
> 
>> +	rwlock_t mmu_lock;
>> +
> 
> Err, is there any reason the existing mmu_lock is insufficient here?
> Surely taking a new reference on a canonical IPA for a shadow S2 must be
> done behind the MMU lock for it to be safe against MMU notifiers...
> 
> Also, Reusing the exact same name for it is sure to produce some lock
> imbalance funnies.
> 
>>   };
>>   
>>   static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> index da7ebd2f6e24..c31a59a1fdc6 100644
>> --- a/arch/arm64/include/asm/kvm_nested.h
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -65,6 +65,9 @@ extern void kvm_init_nested(struct kvm *kvm);
>>   extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>   extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>>   extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
>> +extern void add_shadow_ipa_map_node(
>> +		struct kvm_s2_mmu *mmu,
>> +		phys_addr_t ipa, phys_addr_t shadow_ipa, long size);
> 
> style nitpick: no newline between the open bracket and first parameter.
> Wrap as needed at 80 (or a bit more) columns.
> 
>> +/*
>> + * Create a node and add to lookup table, when a page is mapped to
>> + * Canonical IPA and also mapped to Shadow IPA.
>> + */
>> +void add_shadow_ipa_map_node(struct kvm_s2_mmu *mmu,
>> +			phys_addr_t ipa,
>> +			phys_addr_t shadow_ipa, long size)
>> +{
>> +	struct rb_root *ipa_root = &(mmu->nested_mapipa_root);
>> +	struct rb_node **node = &(ipa_root->rb_node), *parent = NULL;
>> +	struct mapipa_node *new;
>> +
>> +	new = kzalloc(sizeof(struct mapipa_node), GFP_KERNEL);
>> +	if (!new)
>> +		return;
> 
> Should be GFP_KERNEL_ACCOUNT, you want to charge this to the user.
> 
>> +
>> +	new->shadow_ipa = shadow_ipa;
>> +	new->ipa = ipa;
>> +	new->size = size;
> 
> What about aliasing? You could have multiple shadow IPAs that point to
> the same canonical IPA, even within a single MMU.
> 
>> +	write_lock(&mmu->mmu_lock);
>> +
>> +	while (*node) {
>> +		struct mapipa_node *tmp;
>> +
>> +		tmp = container_of(*node, struct mapipa_node, node);
>> +		parent = *node;
>> +		if (new->ipa < tmp->ipa) {
>> +			node = &(*node)->rb_left;
>> +		} else if (new->ipa > tmp->ipa) {
>> +			node = &(*node)->rb_right;
>> +		} else {
>> +			write_unlock(&mmu->mmu_lock);
>> +			kfree(new);
>> +			return;
>> +		}
>> +	}
>> +
>> +	rb_link_node(&new->node, parent, node);
>> +	rb_insert_color(&new->node, ipa_root);
>> +	write_unlock(&mmu->mmu_lock);
> 
> Meh, one of the annoying things with rbtree is you have to build your
> own search functions...
> 
> It would appear that the rbtree intends to express intervals (i.e. GPA +
> size), but the search implementation treats GPA as an index. So I don't
> think this works as intended.
> 
> Have you considered other abstract data types (e.g. xarray, maple tree)
> and how they might apply here?
> 

Thanks for suggesting the maple tree based lookup, I will try it in next 
version.

>> +bool get_shadow_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa, phys_addr_t *shadow_ipa, long *size)
>> +{
>> +	struct rb_node *node;
>> +	struct mapipa_node *tmp = NULL;
>> +
>> +	read_lock(&mmu->mmu_lock);
>> +	node = mmu->nested_mapipa_root.rb_node;
>> +
>> +	while (node) {
>> +		tmp = container_of(node, struct mapipa_node, node);
>> +
>> +		if (tmp->ipa == ipa)
>> +			break;
>> +		else if (ipa > tmp->ipa)
>> +			node = node->rb_right;
>> +		else
>> +			node = node->rb_left;
>> +	}
>> +
>> +	read_unlock(&mmu->mmu_lock);
>> +
>> +	if (tmp && tmp->ipa == ipa) {
>> +		*shadow_ipa = tmp->shadow_ipa;
>> +		*size = tmp->size;
>> +		write_lock(&mmu->mmu_lock);
>> +		rb_erase(&tmp->node, &mmu->nested_mapipa_root);
>> +		write_unlock(&mmu->mmu_lock);
>> +		kfree(tmp);
>> +		return true;
>> +	}
> 
> Implicitly evicting the entry isn't going to work if we want to use it
> for updates to a stage-2 that do not evict the mapping, like write
> protection or access flag updates.
> 

Thanks,
Ganapat

