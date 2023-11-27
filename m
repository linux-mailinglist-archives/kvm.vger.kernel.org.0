Return-Path: <kvm+bounces-2510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F307F9F69
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 13:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2B12B210FD
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 12:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9B31DDF6;
	Mon, 27 Nov 2023 12:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="RBEn9A1/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2103.outbound.protection.outlook.com [40.107.212.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093FAF5
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 04:19:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkGzKR1/mncyz7VEdGjxVbTIKXqf0e1q9Bp+NYLD4J7E1z/kgdXAEVMB08PQY3YInXJoyIt9R6CaacysZB5IPk2THOv1Kukx7f5tXfg2NickJi8bTiW+D/UlUGYduvniXvLxTCuRPyjdK3krsbBtg/aena8C5SrF652Dh1Fl/zKMSo/oZ1kuXjV1dp2WXxPu07yK2fMftAhIhfQXuHepzZWiOTD4KF0RsmcLaApUdZaQAAcV1oMpLavfLZe3UdNHzOlHTsiFsBJxcczRcFG5APiCEfrsy1mbuOGLC0c7rj1IB63UVx+YxkdScKYzEQKkUzAORGmgGuueQ4jjrhPDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgkiUHa5ikMKOa8GSJPP+fubo90LC40jJFcclA8dGgg=;
 b=dlfvoXfcMDJ8lw30o50WqDlUo6WKzIBUO+/JFDUMmoXzboqBEvHmuxPrdlMeU3fX4D+AfXTiQLlgujYdN+9Nt9h6d9OVdFPyUw2ZsSl2SZz5yZpJKN6Zcx8SZFrN5N569PDq30eXP/9PvhYjqcM25ij1uCP3lIEpsN2MVCif7fpPs+k9eE1luFFsbpoVxGXg1AmQyl+T2+6UKt5kq8LnFwdBbhVytNN9uFynajHDSMfeZhZ9lZAV9AlleypPsygkp+F4Wi4+cPy/OQM1q75YSvU/HwSZ4j+QnETZoUKwMLWZyTc8mHidbAceLODp3evNPnGJTYY0Z76omSojmB+kKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgkiUHa5ikMKOa8GSJPP+fubo90LC40jJFcclA8dGgg=;
 b=RBEn9A1/kGExJGq69Ghfjhv3u6FZ+Pr4uM5z0XGN4fGTwVzSUJ47gAFYRvWZjQl4MNnSfVjdFkdGKO5o6usnDrLcaIiP3ypTs6sZU17fGufN8hibxbGG5H0t2+5Tk/Pc3MPdFbZksOzGnjvEfvWZ6BX6eWWUeOJbIZUOGaT0Nzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 LV3PR01MB8534.prod.exchangelabs.com (2603:10b6:408:197::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.29; Mon, 27 Nov 2023 12:18:57 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 12:18:57 +0000
Message-ID: <d6ec3f62-72f5-4abc-afe9-150dd882ffdd@os.amperecomputing.com>
Date: Mon, 27 Nov 2023 17:48:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
 <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
 <86a5r4zafh.wl-maz@kernel.org>
 <134912e4-beed-4ab6-8ce1-33e69ec382b3@os.amperecomputing.com>
 <868r6nzc5y.wl-maz@kernel.org>
 <65dc2a93-0a17-4433-b3a5-430bf516ffe9@os.amperecomputing.com>
 <86o7fjco13.wl-maz@kernel.org>
 <e18700d4-061d-4489-8d8d-87c11b70eedb@os.amperecomputing.com>
 <86leancjcr.wl-maz@kernel.org>
 <9f8656c7-8036-4bd6-a0f5-4fa531f95b2f@os.amperecomputing.com>
 <86jzq3d007.wl-maz@kernel.org>
 <1fe79744-f8a4-466f-8f1a-32e6fab78be9@os.amperecomputing.com>
 <86fs0rctcr.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86fs0rctcr.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:610:32::19) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|LV3PR01MB8534:EE_
X-MS-Office365-Filtering-Correlation-Id: 9487b292-807a-4628-3858-08dbef430739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ef64s2VHDQuWyDjlHiySJ2jnnyKF7BWeaSzFB8oAseqEI2OzTgXP8YhYCw5dD9A3T8ZOEXSxm9fOCJDNsLKr7EAMD0RsQ2NHOCeZgO1AoXbb/hvK3rBMCpuFXavlv/1CF01MwQMV0QHfSgrSUF9hJPetcd8nAFf5NkyIeYOFuGUHf8NeKWKS0X/lBDnsOAYFCXP08XgTsN7Ut5MohaOEMQphCf9kw2lWl+tCYEL7/yPUdaiEaNOGVV/uR/qKbf68q302y8Lc3SfTaZ5JhK3rSfyX5TgcnFPob5AkXtbDjYgqc3XS86eXf0sJsfCreS5XerJvkpynBIl2pvqc4R4bSbBHKduP1F//PWFhZyMW0JHLgjxkuRIYtuyBq5ke7wzCYWHp2i1xgbEj1b3JUvWbq8OEijPg8iLPn2VSjWk+HUJEZ3TNga3b9HNyFwRnH/mtJTRl8LMbeRDYKXSX/aSbn49VMrww0/vMmYXh0fKsHdt8UwVIDRxks3lmDHzbOmxIM6aNmljRf+hm3oMjPDGTjPWPxolZlz/yVDxqQTW/jfvMyEwjVsFhQWCjarJ7MS6ktQaS0LBWeL3QGHG80ZM0R7wPdlybxcs+jFXJrmHqOCiLyAqqP/CFgCN72dBygX9V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(346002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(83380400001)(38100700002)(86362001)(31696002)(6916009)(316002)(54906003)(66946007)(66556008)(66476007)(41300700001)(8676002)(8936002)(4326008)(7416002)(5660300002)(2906002)(31686004)(6512007)(6506007)(53546011)(2616005)(478600001)(26005)(6486002)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1dsRTJJbmc1QVlkUzg2Z0VMbjRMbm5jRnBoL1h0cUxoeEF4ODl1SFYzVlp6?=
 =?utf-8?B?b3ZHdnFGNy8ydzcwTTJMSjA1bkluV3NpOUxaQlZIcTFLQnVMS2FJcEgvaEgx?=
 =?utf-8?B?dy9NVUZEaHlVMmNCOWxaWFc4VE04bFR3Q1hQSVdwZVE2VUtyVC9FSlNqNzh6?=
 =?utf-8?B?U3FoL2tsQm8xYk84TUluRW9za3g1L3BKVmFrdEhpNThNaGttcnpVZnIzdlF5?=
 =?utf-8?B?d0Y4WlpocGw1L3YzU0RVdW9na0UyazFzSjA5djVVN3RweGJUZVJOTGVuY3c3?=
 =?utf-8?B?a3JqWlFsRGtTajN0Wk8vbkdvT0JNVFRZbDBzcnpxRlVGUk5SWFRDbGROVTdm?=
 =?utf-8?B?cW93ejQwSitXKzY5ZWpEU0x0dXhSNWhmNTM0Q1U1ajByb1FTeVhtTDJQOHV2?=
 =?utf-8?B?YTZjcktZdUluZVZrS0xCRk91NkxjRSs3UWxLeEgwclEvcDlrL1dOcmtxUC9i?=
 =?utf-8?B?dm5YMzNPQndqazY0MUpUUEZtZHNjOU91Y1cxYjZDUG9USFlOZVB1OU1senJD?=
 =?utf-8?B?bmNRZXVNdTVjalhicXJGb3lJdzNqMkpyU2RHanFaWTJSQUpOK1pmcUp3Nkk4?=
 =?utf-8?B?cVBzVzc5emRnWDV0blRpWDZhQmE2UDZzLy9OeHhzenRtNUVodGl5V3EzYTRP?=
 =?utf-8?B?Tng0bVVnQWFJUk0xbElsUUdOVExkN3p1OEFoOWhWYVB1UGkwbXZhbWthUmxp?=
 =?utf-8?B?d2hvaWkvWC9vZzI5WC9sNTE0U2xFSmRvbHp1RlB0UTRSNHovSFQxajYzUlhJ?=
 =?utf-8?B?ZG1ZbU0xY05xNVc5eU93YU1wblhlQ3BYdjZuN1A5RlNNWG5YYm4zT3lvVUZO?=
 =?utf-8?B?MEpxaXIrSWdTczlGQllnUjRBRkxmOWJiL3AxUXl4RnZENkVMOEZlb2tsTXVD?=
 =?utf-8?B?a3JLb1hUcVFsVG5hcWpRN1Jqc05pTTFyYmVpSWVTZkp4S0cxKysrenN4ZlUr?=
 =?utf-8?B?WEZTOCtJUkJ6anVZRkVtYUVMdjR2Z0lQUzFrWUlGZnRpc1grRnIrS3YyT3ZB?=
 =?utf-8?B?cStGYkwzTG1mZUlUQ3V2cEFRZmVEbXhEcDdGampMQ2xPRFhVQ0J1U1NGN2c1?=
 =?utf-8?B?QStxZ0pGelViblA4VGxDL0V6YVRvQ2JwaGM4czJFMzVJbXVXL3N1blk5VlZm?=
 =?utf-8?B?eFhVOFpyZUM1ZjJ4OWlObWpjbm1acHo3OWYzV0MrOHdiZGtVNGU0eS81cEN0?=
 =?utf-8?B?Z0UvQ1d1dy9NMTBhS25UczZId0piaTNnK3ZpWjhUS0FLYXo0ZzZlOFZnWWZG?=
 =?utf-8?B?R0JOM3hPZmRUd201UW5KenZGdlc0Vkkwa2xWa1NHaEk5cWZuN3Y1Kzk0MURa?=
 =?utf-8?B?TTR3QUc2MW90cHI4cDdlZ2VQL0cwcFFhRUxEWUxPSkVoak51WXh6eHNDWTky?=
 =?utf-8?B?TCtmczF0UWFiVCtGMkhIWDEzaXVnaDF1WkZQQjlTRCs0Tlk5S2JxYjB5N3NX?=
 =?utf-8?B?RmtMMXM5Wll1ODhydngwcU14d1FwdThRTFJOZUU4UnJINml4VGxzaCtlOWpt?=
 =?utf-8?B?MzhrYTV6WmdPNlZnUjVrWDNTMzJTeHNLQnF5aVplZStUNnp3WmJoNWZtajdS?=
 =?utf-8?B?dGd6L1FpTTRTSzJiT2MvWWhqL0Z4cUpFTDRDN28xRjJ5NU11aFgvZnFmaDlO?=
 =?utf-8?B?N1dnVGxBT3FuZHJCbXI2WmI2NDVxcjY3anRpMHJpVUVGNGRZWFB3N3V6QWFz?=
 =?utf-8?B?SXg3WGhCSHAyNksxUnRtZnprRUMzbFljUG5jbUxIbTVrcHJwZ3dsMllvdUhx?=
 =?utf-8?B?TnNxTGgyS25PeVZUNzAyc2FYM2dtZVg5ekpnSCttVkF3SGhwTWppdmFHL2dL?=
 =?utf-8?B?QzM1Y1pjMk16SkNIbENBbE9ERERuclFPN1VHdW9pVDUxZ0lTYlloODRGN2JQ?=
 =?utf-8?B?VThhd3lSZWpvSS9TYVRlZGcwSHBMVm0zUUlqNWxxTnRuSDRUQTBueUpLWDZJ?=
 =?utf-8?B?cmRCUU5KRSszSTVTT0lQTGNoWndCS05OcHc4SnVPcXVublpVd2pBV1RoUmlH?=
 =?utf-8?B?MUkzd0VaandxeXdOWktwVWhLNFlDa2RnMlFUWXRjbVNsaTNRM1dVL29nVngr?=
 =?utf-8?B?YnBJajJWN1JVV3RJYU1uUitjU2huR1pWUnhqWitJNTRBYzNVSXhZUWMrOUNj?=
 =?utf-8?B?dFpyemI2TS95MG0ycE1JeklEOHV1VHVUa2lWU1BCWWhmTDYwbDhiQUpLK3Q3?=
 =?utf-8?Q?RAW3YNIkzQj4pQi5tTTs9jYaONpPmPyHERaMJGwtvwnl?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9487b292-807a-4628-3858-08dbef430739
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 12:18:56.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hcRcmUWvwuWINEcW8zGMvgh4mJiPjheoxJFZTLlU3/xjXM3y/06ji2Cg5nijqam150yf8+kmS/ma+9hy+cE1KzBNOWoiKcvRz8q0X2M3mlaL6kncvXFYD+qnVfvNMnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR01MB8534



On 27-11-2023 05:15 pm, Marc Zyngier wrote:
> On Mon, 27 Nov 2023 10:59:36 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 27-11-2023 02:52 pm, Marc Zyngier wrote:
>>> On Mon, 27 Nov 2023 07:26:58 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>>
>>>> On 24-11-2023 08:02 pm, Marc Zyngier wrote:
>>>>> On Fri, 24 Nov 2023 13:22:22 +0000,
>>>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>>>
>>>>>>> How is this value possible if the write to HCR_EL2 has taken place?
>>>>>>> When do you sample this?
>>>>>>
>>>>>> I am not sure how and where it got set. I think, whatever it is set,
>>>>>> it is due to false return of vcpu_el2_e2h_is_set(). Need to
>>>>>> understand/debug.
>>>>>> The vhcr_el2 value I have shared is traced along with hcr in function
>>>>>> __activate_traps/__compute_hcr.
>>>>>
>>>>> Here's my hunch:
>>>>>
>>>>> The guest boots with E2H=0, because we don't advertise anything else
>>>>> on your HW. So we run with NV1=1 until we try to *upgrade* to VHE. NV2
>>>>> means that HCR_EL2 is writable (to memory) without a trap. But we're
>>>>> still running with NV1=1.
>>>>>
>>>>> Subsequently, we access a sysreg that should never trap for a VHE
>>>>> guest, but we're with the wrong config. Bad things happen.
>>>>>
>>>>> Unfortunately, NV2 is pretty much incompatible with E2H being updated,
>>>>> because it cannot perform the changes that this would result into at
>>>>> the point where they should happen. We can try and do a best effort
>>>>> handling, but you can always trick it.
>>>>>
>>>>> Anyway, can you see if the hack below helps? I'm not keen on it at
>>>>> all, but this would be a good data point.
>>>>
>>>> Thanks Marc, this diff fixes the issue.
>>>> Just wondering what is changed w.r.t to L1 handling from V10 to V11
>>>> that it requires this trick?
>>>
>>> Not completely sure. Before v11, anything that would trap would be
>>> silently handled by the FEAT_NV code. Now, a trap for something that
>>> is supposed to be redirected to VNCR results in an UNDEF exception.
>>>
>>> I suspect that the exception is handled again as a call to
>>> __finalise_el2(), probably because the write to VBAR_EL1 didn't do
>>> what it was supposed to do.
>>>
>>>> Also why this was not seen on your platform, is it E2H0 enabled?
>>>
>>> It doesn't have FEAT_E2H0, and that's the whole point. No E2H0, no
>>> problems, as the guest cannot trick the host into losing track of the
>>> state (which I'm pretty sure can happen even with this ugly hack).
>>>
>>> I will probably completely disable NV1 support in the next drop, and
>>> make NV support only VHE guests. Which is the only mode that makes any
>>> sense anyway.
>>>
>>
>> Thanks, absolutely makes sense to have *VHE-only* L1, looking forward
>> to a next drop.
> 
> Note that this won't be restricted to L1, but will affect *everything.
> 
Ok.

> No non-VHE guest will be supported at any level whatsoever, and NV
> will always expose ID_AA64MMFR4_EL1.E2H0=0b1110, indicating that
> HCR_EL2.NV1 is RES0, on top of ID_AA64MMFR4_EL1.NV_frac=1 (NV2 only).

OK, Even I was thinking the same instead of the work-around/trick, then 
I felt it is still needed since the L1 may be any distro kernel and it 
may not have code to interpret/decode ID_AA64MMFR4_EL1.E2H0.


Thanks,
Ganapat
> 
> 	M.
> 

