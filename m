Return-Path: <kvm+bounces-11062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5D2872696
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B7471F29002
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DC414A89;
	Tue,  5 Mar 2024 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="XAlwp1RD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B74C1400B;
	Tue,  5 Mar 2024 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709663623; cv=fail; b=XHBrGshuPgXUXFHo03aAc00cP2NaXxqBpYTnB0w6HLGxBB0VaoMfaCq+OU/n8XzDoH2nh2u0jX8pudsw0OiTHDi+0AhS3dsoEJHuWPlEilrHI5aPYyGpLLJRt0LIBo3NJSDYFGxS/FNWQxQ4n6hSO6T1cyWCOHVQJNEtMqqoQWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709663623; c=relaxed/simple;
	bh=uWNN44xG4hKzQ4Bgard/kObj2Sgx5RwC3/37agVIg+k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t+YtWMpIgx61toOgrbJuouvWIIl65nK/D8TKeFkQ944TMecHsBtWWGxzxnA/1HcQQFed2gYAeIIFqB2efgcThjRHSk+XjDm5NfwZliYI0T4Drlzf2R1+sD21ertmFnQWWqI6oALYJiXJWeq3Uy/sCXzlVXZq8pA3YGIxhUhQJRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=XAlwp1RD; arc=fail smtp.client-ip=40.107.94.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0ROqdSzxBDe6hhsTZ/1V11ZLQzJAkGhWkp/fJgZrGt2K4v0RIWOEFdjlXEFsTuQNBJBczercuaNf6hLicxiHc05UeI9cz4D7IfOC6VD0wsvnX82TVJSWX+9TJtoYBJqFHjZ8UckdcaDFzqFEKDDlEmH5z5hnXHPVa0iRxRu4fQPcO5dab3DMdH0J0O5WLNbic2/pH9cVlRTqtLEuDpWPlbdPe22gkYdDeu1psUey0k0LFSpTlKCmsgYwvIE0LnfENd0S+7lnWJiCepdYsGJbYioCS8sq0YeRmqReUZCHP5JNZJfP1edVSTEX3lXv9cbdHqn99XkJOb8qK45C03Iuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSVMZT8DbS1W0kwkXANDc/oL3vHR5wydzxwSXAk4FZw=;
 b=SZq8NYuXvquqOdoOMoBLk+auTz7UhEpB5zgXCAVbAAYhORVD5K1d2+erBP8rwsM15B3oPawMWF5G9AXXD7bc2cg+LoSNh0uyeU1oIPIvWICdzgoEI5MPWRdYtFrRDoi9JrJ4KsHx7u8SgQa+IX918/bmd8ricwk/6Hg8D9pHLfWcFs7B2+ij0nr+rWpCnpJMohKp360jgZafjC8T1YRxFZ95/GLkHOzQRo/msXAlOcp/CdVY/LIzgBBDCT7TwVgTtDeQ9Y6lnmnKlQG+ASx/6oAx7xmrJY/JXkXusmVAj/jf/Q7QMS4c8ztd2vApj2oTApouUCrydl2XWcbhWJDNkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSVMZT8DbS1W0kwkXANDc/oL3vHR5wydzxwSXAk4FZw=;
 b=XAlwp1RDMN391hOk4CqXoLexoJeGZkgJMPVoHvI2eQBZhtj0q2sO1kAa47yDWNIfu6Cw94o/01Tc+CK7s4OXPdlXR0DWN5umFDLCeP8GC/VdmGW6RTxaErbDJQNUm4cQ9v1ixTua3CH4zHvwio/pB/SoP17pbd2k5V/3f66jXAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SJ2PR01MB8435.prod.exchangelabs.com (2603:10b6:a03:560::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.38; Tue, 5 Mar 2024 18:33:37 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 18:33:36 +0000
Message-ID: <2911d04d-a785-4d60-9a8d-be0d2cec21de@os.amperecomputing.com>
Date: Wed, 6 Mar 2024 00:03:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU
 tables.
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, darren@os.amperecomputing.com,
 d.scott.phillips@amperecomputing.com
References: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
 <86sf150w4t.wl-maz@kernel.org>
 <6685c3a6-2017-4bc2-ad26-d11949097050@os.amperecomputing.com>
 <86r0go201z.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86r0go201z.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:610:11a::10) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SJ2PR01MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: bc04545e-b5fa-4fcc-4dcc-08dc3d42c547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b0SZ5Bjl1wkbMz8H8aKMO6/O6Zc6p4eDnSkOdUyYiiayMpMSt+IurRO7+zFrmcf9B9si7upwvVfVWlkGF2oVuHKJt9Nm0ZZxp/NWTUqRTD7kwZbg7w/qJfUYaHkTMQQgLpgLj4OKP5l22Bjo4PhhqGMbyOsdyznnA6oo5mC6Zq2Wd3LKvGF9YzlR8jz5c/x+yh69tsdj01SEv1Vi9lDRn/aTdp7RAlRvnRO+pLrRXKlC+JhfoztBicQ3Q48lbXdviKt5efmAQmbFV4gLKEq0/6x5BdNDkAMcO5bRSZd2I3dmzECnF3Ppo3eM2jlYm0EMxyJdZj3m62xb+DCLryzdyeFUxYomavRDey1a5YltpZxnMkZ6JCGjtQ6XUlegrnZKBSPJe9+A02ZakbmAO+jsgVVNuqDMmjsf7ls1W5d4eDTDpINv+ovvg7lmRrw5J+agSGw9MXEd04YMwRm5ySD6moMUdXJPJlNCmkzxiBdB1DFfK1PmwkUP4959PTXV70J4dxtq+V0MGlKyKsOpIvlgju4F5oKgWXFC75u7Dlso4pAIeC/v+RMke8Jwea+oVigGuQZokdK2Uw6UwlTSW0RxuNtq1Xl7839PJAJnFVldw7w9Xg9Qsdt+I5Po1b+XYnSJPjnhYPaoIqkEtnE10VzbLAGH2y+mW25UdTDJd6ohbmg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0JMcDkzcW5lOUlVRFA3cjhlVW5nN1k1SlNqMUNKMVd5eWlqSnk2cWI1TkxW?=
 =?utf-8?B?WkV0M1g5emR0L1R3em5VVUNOOVFjbDVySXFtUXdSY2lvZU5uS0hJZkNtaGEr?=
 =?utf-8?B?cXlVdzZxQjVOQ3ZuS25yaFB1dmVGK1k4VXdvcC9Cd0dJSCtWeVhGejN5UUtS?=
 =?utf-8?B?ZzY4eHZPZjI0QUVOTjJPVlE0QjY0Z1FLeDVDUjVvRnBVdnB6N1ZwWkQ4bUVo?=
 =?utf-8?B?VWRRc1dtcEpGQ1Mxa05KT2pNbXgwUmxEYUU4V0dvNVZFM3phSFJmclo2YVZk?=
 =?utf-8?B?aFQvNzY3UG9lOFR0RTdYeVozek1sMEhkT3VqUUJqUXNyeTJVQTlrT21OL3dG?=
 =?utf-8?B?WVk2eVdzY1hqaTFicks1ZDlXRnA0bkZjTC9ncjEvc2tYeGhLVkV6SHBpdVhX?=
 =?utf-8?B?UGxXeUJ3aFVzV0xwRW1IYnRnTXE1azRoVUp3YXQzckFTK01pc3VXRm1nRFR3?=
 =?utf-8?B?VHY1OVFZWWNuTHJFM2JiNVJ3VmFVbVpxeHBhQkNDdStaOFVtMW5VMDlDdjZk?=
 =?utf-8?B?TlFpRUR6ZGdTTHJNbE5YNjIrZW1CRFE3YnUwYUJBYXllYmVEWnNwZU43NXdR?=
 =?utf-8?B?WTNuVk9tZTg3TUNLejNTcTJiRTh5TTh4VkhnSW5QQ1JWaStLRkhFS0hTNWdE?=
 =?utf-8?B?SjU3cm1oTk93ZFJCc3YzSlRKNFJPdGdGYnVOWkFrS2x5VERxK1NvRGViU1I2?=
 =?utf-8?B?NkRjMnBEdzB4NzVYUjZ5ZTV1czVZQnJaeWZIanM5MndDVGk0SXVDNzB6WlBv?=
 =?utf-8?B?RnBwNGJ0OWdydHpJZVVBU2RFNmd5NStkNmRzN3FyRVU2YWk3S0xEL2l6ZUZj?=
 =?utf-8?B?Ym1XN1lWSzRFRE1pZUdaZ2J0U3lNZEtucXoxNlEyZS9icmpWODgrVUlXK1ZF?=
 =?utf-8?B?S0Y0T3o0a2dlNmJGckRjZXdtMVJySGJnTkhlZGVEZ0hOam1jSVhUbkNOcnY5?=
 =?utf-8?B?RzFMVlVaVGxCWm55cE4yeFFOanFFa3hxMnBXYTRDMldJN2xhcnI0VUtpVFR2?=
 =?utf-8?B?SldVdVVPM0VObHRzZW1lSVJONHNVZnNtWlU2UHpyRVlSSkE3MWxCTjNXWWoz?=
 =?utf-8?B?Rk1IdStJNEZHV05PTWlPbWUzVmlZQkpVelY0bnREdGwvRWpYOFdJSXkvSDRM?=
 =?utf-8?B?U252RmpDazdwVDdjYVZxSUt0SGptSGlnTysvY09OaUNsTFd6VWtUVEhnQWFK?=
 =?utf-8?B?MGptZDh1S2tEVFJscXpxQzd0aDdMckJnVEdESkxiSnNFbStDNk8xRWhyNXc1?=
 =?utf-8?B?SEkyQWV6WXNTR2R3NjdIY2IvSUtkYTVmblBhTkhqdWpWaXJEZ3U0YjFhMkwy?=
 =?utf-8?B?TmdZOGZUYVVzeGVpK3huSFN3d0c4K01LZzZaeFhyemx2SGNITWxSNkRNbzFl?=
 =?utf-8?B?UW53c2xCbElEcmEzTHBLeWg5UHJydFM5NmNQRkkyQ0ZuOEZXTk1OaUFhUUJy?=
 =?utf-8?B?Um1QMW5wWmczck1BUE12L0FzenZpSTFXRGJDM0N3T1J6elFkNUVBbGNpeW5t?=
 =?utf-8?B?d1p3STVWT2JyVGJzaTBWN1hiTEszUDVUUWUxOVVMRWFtUDJmbllXTFNUMyt2?=
 =?utf-8?B?bDVDc3QrcTZ3OHBDeEZOblZlUmZrK2dobDdHSG5QWVFyYWZ5N043Y2xzb0dk?=
 =?utf-8?B?RWVSUEI1TkdqWWNtQW5kM3FZSVh4cjFTVTg2WndqczZPbnJuUzhLTnRDOTln?=
 =?utf-8?B?R0kwM2lrbEFBVnpFb3BxQmJwMUNadDFEUktrMlBOVk5YVVFPakVTSVFML3Q2?=
 =?utf-8?B?Q1pqUWxUN2p2QkJoT0o5NFloWWJtK20vT0JsK2VzT09yK28wRjIrQ0paSmpB?=
 =?utf-8?B?TUZjdzEvRzd3QkxuMWI5dVhQM1lmM09ITk1MQXlzclZpblErUGNQRHVSMEJ5?=
 =?utf-8?B?aFc1ZEJHYUh0VlBvajhqaVJFVEFzZmE1YTNSS2pNTFBIdmRVaXJ1RjVZMW1j?=
 =?utf-8?B?UW9lckFaK1kyNWJXTmtyQXl2dW1TK1NldkJiVkx1aE5neUl3YlZuSmlJWi9T?=
 =?utf-8?B?QnlPbmpodkFETUxUbGxrVXNIbnlLdkpXb3lrb3JGNWtWMVh6eE9uREF0T3N5?=
 =?utf-8?B?MTJMblZFTEN1MUc1NlZ3T21KQTVVcUhjeE1vUWg4dXBsQ2x5U2NSNTZTb3pn?=
 =?utf-8?B?NzRPZ01xcTIveTZDUzJBV2VscnJ3cW5GK0g2aTYxblZjckY2OWlnZkZDU3RY?=
 =?utf-8?Q?82H1xY2KEpGiZTKUX0uJY5BWNFX/cZ6JelMfD0706sih?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc04545e-b5fa-4fcc-4dcc-08dc3d42c547
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 18:33:36.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdcOT5zYht1Si63JrpxwJbjz0qRMZmIxhXBrn6Rgj5S0NKBbT7IsfWjO6jEdBcI+/OPIe92bdy0dULchg5cPyjqWaMxtSxk/Xtqn8EQJsUtmF37DcVIfnZFwPiYLnhB7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8435



On 05-03-2024 08:33 pm, Marc Zyngier wrote:
> On Tue, 05 Mar 2024 13:29:08 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 05-03-2024 04:43 pm, Marc Zyngier wrote:
>>> [re-sending with kvmarm@ fixed]
>>>
>>> On Tue, 05 Mar 2024 05:46:06 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> As per 'commit 178a6915434c ("KVM: arm64: nv: Unmap/flush shadow stage 2
>>>
>>> $ git describe --contains 178a6915434c --match=v\*
>>> fatal: cannot describe '178a6915434c141edefd116b8da3d55555ea3e63'
>>>
>>
>> My bad(I would have been more verbose), I missed to mention that this
>> patch is on top of NV-V11 patch series.
>>
>>> This commit simply doesn't exist upstream. It only lives in a
>>> now deprecated branch that will never be merged.
>>>
>>>> page tables")', when ever there is unmap of pages that
>>>> are mapped to L1, they are invalidated from both L1 S2-MMU and from
>>>> all the active shadow/L2 S2-MMU tables. Since there is no mapping
>>>> to invalidate the IPAs of Shadow S2 to a page, there is a complete
>>>> S2-MMU page table walk and invalidation is done covering complete
>>>> address space allocated to a L2. This has performance impacts and
>>>> even soft lockup for NV(L1 and L2) boots with higher number of
>>>> CPUs and large Memory.
>>>>
>>>> Adding a lookup table of mapping of Shadow IPA to Canonical IPA
>>>> whenever a page is mapped to any of the L2. While any page is
>>>> unmaped, this lookup is helpful to unmap only if it is mapped in
>>>> any of the shadow S2-MMU tables. Hence avoids unnecessary long
>>>> iterations of S2-MMU table walk-through and invalidation for the
>>>> complete address space.
>>>
>>> All of this falls in the "premature optimisation" bucket. Why should
>>> we bother with any of this when not even 'AT S1' works correctly,
>>
>> Hmm, I am not aware of this, is this something new issue of V11?
> 
> it's been there since v0. All we have is a trivial implementation that
> doesn't survive the S1 page-tables being swapped out. It requires a
> full S1 PTW to be written.
> 
>>
>>> making it trivial to prevent a guest from making forward progress? You
>>> also show no numbers that would hint at a measurable improvement under
>>> any particular workload.
>>
>> This patch is avoiding long iterations of unmap which was resulting in
>> soft-lockup, when tried L1 and L2 with 192 cores.
>> Fixing soft lockup isn't a required fix for feature enablement?
> 
> No. All we care is correctness, not performance. Addressing
> soft-lockups is *definitely* a performance issue, which I'm 100% happy
> to ignore.
> 
> [...]
> 
>>>>    +static inline bool kvm_is_l1_using_shadow_s2(struct kvm_vcpu
>>>> *vcpu)
>>>> +{
>>>> +	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu);
>>>> +}
>>>
>>> Isn't that the very definition of "!in_hyp_ctxt()"? You are abusing
>>
>> "!in_hyp_ctxt()" isn't true for non-NV case also?
> 
> Surely you don't try to use this in non-NV contexts, right? Why would
> you try to populate a shadow reverse-map outside of a NV context?
> 
>> This function added to know that L1 is NV enabled and using shadow S2.
>>
>>> the hw_mmu pointer to derive something, but the source of truth is the
>>> translation regime, as defined by HCR_EL2.{E2H,TGE} and PSTATE.M.
>>>
>>
>> OK, I can try HCR_EL2.{E2H,TGE} and PSTATE.M instead of hw_mmu in next
>> version.
> 
> No. Use is_hyp_ctxt().
> 
> [...]
> 
>>>> index 61bdd8798f83..3948681426a0 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -1695,6 +1695,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>    					     memcache,
>>>>    					     KVM_PGTABLE_WALK_HANDLE_FAULT |
>>>>    					     KVM_PGTABLE_WALK_SHARED);
>>>> +		if ((nested || kvm_is_l1_using_shadow_s2(vcpu)) && !ret) {
>>>
>>> I don't understand this condition. If nested is non-NULL, it's because
>>> we're using a shadow S2. So why the additional condition?
>>
>> No, nested is set only for L2, for L1 it is not.
>> To handle L1 shadow S2 case, I have added this condition.
> 
> But there is *no shadow* for L1 at all. The only way to get a shadow
> is to be outside of the EL2(&0) translation regime. El2(&0) itself is
> always backed by the canonical S2. By definition, L1 does not run with
> a S2 it is in control of. No S2, no shadow.

Shadow, I mean nested_mmus[0] which is used(first consumer of the S2-MMU 
array) while L1 booting till it switches to NV2.
As per my tracing, the nested_mmus[0] is used for L1 after first ERET 
trap while L1 is booting and switches back to canonical S2, when it is 
moved to NV2.

In this window, if the pages are unmapped, we need to unmap from the 
nested_mmus[0] table.

> 
> [...]
> 
>>> What guarantees that the mapping you have for L1 has the same starting
>>> address as the one you have for L2? L1 could have a 2MB mapping and L2
>>> only 4kB *in the middle*.
>>
>> IIUC, when a page is mapped to 2MB in L1, it won't be
>> mapped to L2 and we iterate with the step of PAGE_SIZE and we should
>> be hitting the L2's IPA in lookup table, provided the L2 page falls in
>> unmap range.
> 
> But then how do you handle the reverse (4kB at L1, 2MB at L2)? Without
> tracking of the *intersection*, this fails to be correctly detected.
> This is TLB matching 101.
> 
> [...]
> 
>>>> +			while (start < end) {
>>>> +				size = PAGE_SIZE;
>>>> +				/*
>>>> +				 * get the Shadow IPA if the page is mapped
>>>> +				 * to L1 and also mapped to any of active L2.
>>>> +				 */
>>>
>>> Why is L1 relevant here?
>>
>> We do map while L1 boots(early stage) in shadow S2, at that moment
>> if the L1 mapped page is unmapped/migrated we do need to unmap from
>> L1's S2 table also.
> 
> Sure. But you can also get a page that is mapped in L2 and not mapped
> in the canonical S2, which is L1's. I more and more feel that you have
> a certain misconception of how L1 gets its pages mapped.
> 
>>
>>>
>>>> +				ret = get_shadow_ipa(mmu, start, &shadow_ipa, &size);
>>>> +				if (ret)
>>>> +					kvm_unmap_stage2_range(mmu, shadow_ipa, size);
>>>> +				start += size;
>>>> +			}
>>>> +		}
>>>> +	}
>>>> +}
>>>> +
>>>>    /* expects kvm->mmu_lock to be held */
>>>>    void kvm_nested_s2_flush(struct kvm *kvm)
>>>>    {
>>>
>>> There are a bunch of worrying issues with this patch. But more
>>> importantly, this looks like a waste of effort until the core issues
>>> that NV still has are solved, and I will not consider anything of the
>>> sort until then.
>>
>> OK thanks for letting us know, I will pause the work on V2 of this
>> patch until then.
>>
>>>
>>> I get the ugly feeling that you are trying to make it look as if it
>>> was "production ready", which it won't be for another few years,
>>> specially if the few interested people (such as you) are ignoring the
>>> core issues in favour of marketing driven features ("make it fast").
>>>
>>
>> What are the core issues (please forgive me if you mentioned already)?
>> certainly we will prioritise them than this.
> 
> AT is a big one. Maintenance interrupts are more or less broken. I'm
> slowly plugging PAuth, but there's no testing whatsoever (running
> Linux doesn't count). Lack of SVE support is also definitely a
> blocker.
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

