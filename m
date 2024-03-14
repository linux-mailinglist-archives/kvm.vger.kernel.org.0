Return-Path: <kvm+bounces-11794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5FB87BC3A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 12:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE6A21F21C92
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 11:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88296F517;
	Thu, 14 Mar 2024 11:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dz4kb4ps"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2596F060;
	Thu, 14 Mar 2024 11:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710417111; cv=fail; b=XNro5cP74F+ynTicpGq1OUH0cSoKdAOMMbjnn/Ifo0w6iGZg4ECYPdU3Rq7rxb6iRmlzzJcXzqCzzUdLIil6W0A8mtkmc8/rU5ueKzNaqh36816yqlzRar7ZAo58zdVZ9fc2/Q1nzgbOCXpz8g675DfR04UuXR2FaUyccY3pAhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710417111; c=relaxed/simple;
	bh=+YGwuRBObJ7WrUrBwf/tQnCLPpCYGAUuzvOnIeVSL8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BlWaZtHru28/rJNyMQSRl5QH6sfHa+dr07+v80eOwaQfnqtxUKYJ2L5WbtKj0tmJKUBBHriYMRqYznNrlFLm1Pb9SefgC2uuyFSNTAnO+YxLt160bHbO1cmHkKVr4Isor0ONvFxJcbgBopX6CXUw23+FW0VKUsOqsUQLaOkCS8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dz4kb4ps; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLme0Va0b9oWzI8fqK+5tlBFPqJo7J8iUPFP7eeJXgqtA0vBe4KjVuLMvSV9UmuNtm2XVlLzq3VkrnoPIQvW5ajKJapnzkNiEkHdDpZrivpHRGBkIF3GjM1qJ3IwilCspGXWLAvQUoxpW4xqaPaWXRalHYoDdgxjyZg5B+k1MdSvb04B00WLXW5KtWQoFGNLab/EocBKWCE8CIZMUI6FVa/e8iwU/joZlFXQI0SVzT07JQrRCTYxgI5m+S0d/0dhxafLuyZ1zstsHwKUtaWNo2gZ2ppICfsV/IRZ8JW4Sh0fHMURvkeXwc0ZrB7nI7RUN4ti2VzQ/3HN72BbXglcRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0R5C9HvTm5nWMo1LvD/6YeJMx3C5f2h0XRv8b/3T3PY=;
 b=SDLl1bEm7hZ9ZCR7HqrdaJdE1QLKc9gRG62B05r76C6EYdMjdJaZIzwMjpZlADn2Ash/niDRETUMu+8T/u1rM3mGvtrI2y0fT+/nJVBgdYKi8QMFIvULDvNcW+g0TpBVeDSp7XvBdA4G6/DuRCKfrETf9+vbwpOBDPkpLLVjDokSmlrbw8v01FgrCbnSZBgKMd7+9yJpgH0cayd9n7cQPL8OjRn4HSshZQ4/krfunW7mEmIJK5lIsPj6I60oY0dGe9dhuqQDrtG9cykJmffBu3maMyQs8EImMAVGZogh93dPpC8fOfiWu7Fd6HzbWvRXYxZqAMBSBGy6cQ/JeTkhQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R5C9HvTm5nWMo1LvD/6YeJMx3C5f2h0XRv8b/3T3PY=;
 b=Dz4kb4psZqxgG8lPo/J3lnNhZo5PbOiKsAKbyQ8qKe789eTJOzPnIR2CnvbPCvrzmlrw+oyBb8zXUlz4FaAJsHk3v9lO/jhgXM/iw2AFnV8cdTcX5itEkOjgMOKxdQAz+L0g8a42/o/zEho2IVY7X2Glu/bdLjC7vrubrzfw2ns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM6PR12MB4233.namprd12.prod.outlook.com (2603:10b6:5:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Thu, 14 Mar
 2024 11:51:47 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::f2b6:1034:76e8:f15a%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 11:51:47 +0000
Message-ID: <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Date: Thu, 14 Mar 2024 12:51:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240229025759.1187910-1-stevensd@google.com>
 <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
 <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com> <ZfGrS4QS_WhBWiDl@google.com>
 <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com> <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f2::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM6PR12MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: b72d2beb-2126-48f6-2324-08dc441d20ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zNBGcOLLGvGOMkQUDLBwq4UCe+m7fKDsLtQXkDBTjyN6SX6VJ2CPjniSyGrCmOkw7oasOoTndh8Y6SJevdHVWRgCuUuMcSTi769wH4Fypat4WCogKAezOyVeKRMll0iha4dZ68IQBhUBxdQYhGgi/K3v4i2HpY/iY2aK1cmn9UeyHo9kI8x8HE0BHW3My3xll76kk+JJn6w0acGGF5NtOZ+R7dlyInOeVnt+S2rRAbOZ6x6bmOdZ3+nFUGNGRe3b2UhXm06i3c9ICtV45oQRq0X8HCIdiL/p3nV3TiaVo5bGOBkEjlSCH3qvWaDp59xEXDT+B3+gEvJlMVzhVEjzVcmbMsbIaOfXoE2A20OBkJ7645HsrjjvfY2UetpU0mF+XGXX+X5ucLqyT/ZqFmbVMgwYrf5X8Lin4xXsjZjs1acShGx/3JSHWcrfCnhHegh1TvZCLSOJJpmeC1JRfEUGm4MM39Q7ohKei+ihRAdZVeKaPveIyoTN2C0mIAvtnmwpPQde1foq3mVh3/N6ZNMMMVPqtZP3B6cbBmWEE+/dlitYuBnLj5kyzSJemWfs6kcUIZu5pbyWYicBcrJyK3CSV9GRuqBu6aJ3y+hfn06mGho=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXo5RnIxa0c3S2VtRC9Cb1grdDcxYUpOeFBpSlFqMTY2d0dMWithZGdyaWZJ?=
 =?utf-8?B?c0twMUtIeUlQZkgxYzF3akd2dmcrNTBiU0E4TmxybGFtdnZybWpReEZBWlR2?=
 =?utf-8?B?c3lFeW9LK2NqVEdmNHYybXh0R1Vtbi8vanZGM3dzNWFZd0J2M0VsaExSYTUv?=
 =?utf-8?B?K0lLdGM1YnNnYmo5SHJnL0FZemJpK1llY2sreGQwSTViNVBIUjE4NkFpNG1o?=
 =?utf-8?B?YzZyWE9LVVkxc3VrdnJvRkIyUkV5VFVhejg3czcvQ3MrVmo5VE9MQTVQd3lK?=
 =?utf-8?B?akJlYXVLN0YrRHJ5UXovWUtORFZGYmtxWERlUlBQTUhJdDlOL2F6UStmNCsy?=
 =?utf-8?B?cUU0Y0NCWkswT2xIVU94WElhN25UbnEwaVlzYXBvaGRaQThzcmt6bUdrQXJq?=
 =?utf-8?B?SDVKUmkwNWlpY1FXVTRHZUdJRkZoTldkWE9VelNmaStPTDV4bzJlYzNqRzIw?=
 =?utf-8?B?NlArb3JnTVpadzRSM1I5eWZtckkvb1lhY1hWTWtibTZWcW52bm5rbVlPczlw?=
 =?utf-8?B?R0poTTRVVlpkVWRCZmhIZlVhQjZZemIwaThiWCtrbzFnM2ZqUUdtQXR2TUZV?=
 =?utf-8?B?dm0rMDg3U2RLUFVzb1VraWxuOFh2V1hkQTZmdnF2czJoT29pQUM4MGlqejNI?=
 =?utf-8?B?RTlyZjJ3Zm1HanlGb25FV2U1YnBncFZXU0kycmpBUlhpUk5sSGFiRW1sSjFN?=
 =?utf-8?B?bm5BTmpyMFR2Z0FjMnBBZUtWeDBvenNCK2ErSnVHL01UWVpNc0xRNjJtd2ZG?=
 =?utf-8?B?TzAxcVFhMkE5aUdIOTdlcGE4NDZiNDQwNm5xSTVLRlcxWVRqZDNEUG9NTk03?=
 =?utf-8?B?WDg1SEJyWWsvTCt6b3FFMjlhY1VSbGxHWFVjbG5NUHhjdXRiSm9HOVAxbWxm?=
 =?utf-8?B?clcwS3FhRFZ2dmw4Mld4N2dxQ254OVFScGN0MXdQUnhiTDRJMFZwVkJWWExq?=
 =?utf-8?B?Nk9WUCtpRW1PdW4rY2RBdlRjVExnOE1TdlpBVXY5TEZLd0RKcFdXek5GZ2JL?=
 =?utf-8?B?ZVlycG1ib2o1UnJiYlNYK3QvTFVXY1FBUmJhdW1EYngzN0tDYW9weVJabEQv?=
 =?utf-8?B?UWZCK1lLSGdQMFgrM21QczYvbXJqZUVKMDdMUGlBNURvMmJFNlFwUjB6enE1?=
 =?utf-8?B?OEdPSkVMRFZrbVBXZWN6Y0cxR1lrSEZJamYzMzNta0FybUJsenhSYXNRVEk0?=
 =?utf-8?B?amRQZUVWN0Y4a1c3SHBnVjk1NW42MUFGcmREcmRsWHBYSldDQlFidDNVRk1H?=
 =?utf-8?B?cFcwQTFXbDhWc1oybkxPNFFCUU5XdC92YmYxbjZKN2QySlgyVnJIU2NRdDVP?=
 =?utf-8?B?WXM4dVBqMG9ERGhRYmdjMjMvZEhRWWgvUmVGUCtNYTA3NVJjRElHMzArbCs0?=
 =?utf-8?B?dnZadXBLeHZ6Z3V0cDBLSlozdkxyUVJFdnBRUmNoZVdpRExqZTd4UERVdGlT?=
 =?utf-8?B?L1hEYzRZUGU3VTJvTDVGZnBtZ2NpZUpHcVZDMmJSeTc5UzVPMmpQakUrS2JT?=
 =?utf-8?B?bWIrdDN5c1l0NjJiRSt3NEZBQ3FyT2kwSVVITHpBak5RZ1hjb1JNQjRIbElo?=
 =?utf-8?B?czBPOGRTTE1XdUpWTXczSWRMQ3Zwb2lhZy9xRWQwWHZQamJsbWIweWRqNWlG?=
 =?utf-8?B?MS9xQU1nRVdaNkNCSUNsQXQ0N3dmUXhteDBuTmpXdFJCZ1dGL3dVQytRRHVk?=
 =?utf-8?B?OW5ydHZESmxMMXJiaFBrMVRtQys4S0paU3p4WjdoZ1JsYmpMR2ppYTlSWGhJ?=
 =?utf-8?B?SHVSVDBCOSs1WUVzaE1OVmJZWWtFdkJYc0RDa1N0QjJ1cU1MODhvSXROelJy?=
 =?utf-8?B?RkZMaWxodHpZdE1XdHYyVkpOY0RJTVo4Vm9BUlJidmJIeUNCczViNG1PVDFL?=
 =?utf-8?B?M0ZndU1qM0NCT2ZLQTdVT1Bjb3JrYmtPQUhuVTFleFJPY3o5WEhDOHl1OGN1?=
 =?utf-8?B?SHRpV3k4RzdqRElyRURzMldUYjJJMlJoWkdtaWp2RVE5NFBWNURKa2lHY2lQ?=
 =?utf-8?B?dkpZVWxmSURFVmFzNDhsUEhFWkE0NDBrM3B0VUhMb2ZpYm40a2NEYXlLZ2Mr?=
 =?utf-8?B?TUVEWEhnL3ptLzRDNkp1WkI1eHhTdTlpbzZKVHI2cUU1RlNMQnRwS3FPYmJE?=
 =?utf-8?Q?KoYK/NORlT5zWVSC63TliCpL6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72d2beb-2126-48f6-2324-08dc441d20ad
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 11:51:47.5023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCIbB9ekzAUTinHRPMjzBcS5Bsh7QUNjcxd1cF7aHyITg0Cdm1o7jtVCM1ZUMv5X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4233

Am 14.03.24 um 12:31 schrieb David Stevens:
> On Thu, Mar 14, 2024 at 6:20 PM Christian König
> <christian.koenig@amd.com> wrote:
>> Sending that out once more since the AMD email servers have converted it
>> to HTML mail once more :(
>>
>> Grrr,
>> Christian.
>>
>> Am 14.03.24 um 10:18 schrieb Christian König:
>>> Am 13.03.24 um 18:26 schrieb Sean Christopherson:
>>>> On Wed, Mar 13, 2024, Christian König wrote:
>>>>> Am 13.03.24 um 16:47 schrieb Sean Christopherson:
>>>>>> [SNIP]
>>>>>>> It can trivially be that userspace only maps 4KiB of some 2MiB piece of
>>>>>>> memory the driver has allocate.
>>>>>>>
>>>>>>>> I.e. Christoph is (implicitly) saying that instead of modifying KVM to play nice,
>>>>>>>> we should instead fix the TTM allocations.  And David pointed out that that was
>>>>>>>> tried and got NAK'd.
>>>>>>> Well as far as I can see Christoph rejects the complexity coming with the
>>>>>>> approach of sometimes grabbing the reference and sometimes not.
>>>>>> Unless I've wildly misread multiple threads, that is not Christoph's objection.
>>>>>>    From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@infradead.org):
>>>>>>
>>>>>>      On Sun, Oct 1, 2023 at 11:25 PM Christoph Hellwig<hch@infradead.org>   wrote:
>>>>>>      >
>>>>>>      > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
>>>>>>      > > KVM needs to be aware of non-refcounted struct page memory no matter what; see
>>>>>>      > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
>>>>>>      > > non-reference-counted pages").  I don't think it makes any sense whatsoever to
>>>>>>      > > remove that code and assume every driver in existence will do the right thing.
>>>>>>      >
>>>>>>      > Agreed.
>>>>>>      >
>>>>>>      > >
>>>>>>      > > With the cleanups done, playing nice with non-refcounted paged instead of outright
>>>>>>      > > rejecting them is a wash in terms of lines of code, complexity, and ongoing
>>>>>>      > > maintenance cost.
>>>>>>      >
>>>>>>      > I tend to strongly disagree with that, though.  We can't just let these
>>>>>>      > non-refcounted pages spread everywhere and instead need to fix their
>>>>>>      > usage.
>>>>> And I can only repeat myself that I completely agree with Christoph here.
>>>> I am so confused.  If you agree with Christoph, why not fix the TTM allocations?
>>> Because the TTM allocation isn't broken in any way.
>>>
>>> See in some configurations TTM even uses the DMA API for those
>>> allocations and that is actually something Christoph coded.
>>>
>>> What Christoph is really pointing out is that absolutely nobody should
>>> put non-refcounted pages into a VMA, but again this isn't something
>>> TTM does. What TTM does instead is to work with the PFN and puts that
>>> into a VMA.
>>>
>>> It's just that then KVM comes along and converts the PFN back into a
>>> struct page again and that is essentially what causes all the
>>> problems, including CVE-2021-22543.
> Does Christoph's objection come from my poorly worded cover letter and
> commit messages, then?

Yes, that could certainly be.

> Fundamentally, what this series is doing is
> allowing pfns returned by follow_pte to be mapped into KVM's shadow
> MMU without inadvertently translating them into struct pages.

As far as I can tell that is really the right thing to do. Yes.

> If I'm understand this discussion correctly, since KVM's shadow MMU is hooked
> up to MMU notifiers, this shouldn't be controversial. However, my
> cover letter got a little confused because KVM is currently doing
> something that it sounds like it shouldn't - translating pfns returned
> by follow_pte into struct pages with kvm_try_get_pfn. Because of that,
> the specific type of pfns that don't work right now are pfn_valid() &&
> !PG_Reserved && !page_ref_count() - what I called the non-refcounted
> pages in a bad choice of words. If that's correct, then perhaps this
> series should go a little bit further in modifying
> hva_to_pfn_remapped, but it isn't fundamentally wrong.

Completely agree. In my thinking when you go a step further and offload 
grabbing the page reference to get_user_pages() then you are always on 
the save side.

Because then it is no longer the responsibility of the KVM code to get 
all the rules around that right, instead you are relying on a core 
functionality which should (at least in theory) do the correct thing.

Regards,
Christian.

>
> -David


