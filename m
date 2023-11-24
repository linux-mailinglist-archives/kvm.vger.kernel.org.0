Return-Path: <kvm+bounces-2431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 833277F73E4
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 13:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE743B21530
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 12:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C73928382;
	Fri, 24 Nov 2023 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="dK6EU82x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2107.outbound.protection.outlook.com [40.107.223.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C935D43
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 04:34:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnJhmRLvFoHF0KxEsBDMOvtwoE4G96mmq+JFiVmI3dvHP+m2IBCLUPTfxorfuucdL3qYnaPeAgR96fBZFIzug8wi/Gl5cBHdx/TH+twtylAHOsP3gcmJWqrbsZgDmP/vW/gmEgovQYvh1GmWilaXz1VD3jaK4GcHLlmxcC6wIQguSXZBzabShp7ti/fPHtP/6iR6ANf5dqvPjnboWrRjT2kV+EwxebcOCzjaynO0CLNlYDR5GnzhMLQRYQtrG7w/EeaHdAl3ntdjkmDdiI+ABp//mXzAb0YvTsZ7gfaVmjsjif3bQwteQcxoqUoeSDJTtXSKhX61i5DPvz20UhfOdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7t4JFaD5ole8c7IC67mlMr14CtK2b5R4rEwy+eZnys=;
 b=KIAo1WmsiAUGRj9NKgazPN2ptR5ltxf2l8aVXiVPxUI1XKx0iGLeYymV+mQI+7c22WPZOpJoKRgdBl6Wa2N3CGL+JN1PtMzAYr9itqyX+sQEhyo/RXwwJfLFRk3l3J2W10qZBMYh3jSYg8GxQd5v+QvFt3U7jVnGVHzoAJKIv00Lc4U77HES8OobelAmfufoANJTdwzi9BeMDmFFnCOMMp3HJylBkZjwf43VCHZse07UxgCwSHd2XjSJkadT2UneFDOEvZ2uURsnAwe3lYJeyGmokeYVbGKI9KXEp34+GHUkZ9f2G11osWW1TUx1CVFKI97SjTw54T4yMmTLj3M5ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7t4JFaD5ole8c7IC67mlMr14CtK2b5R4rEwy+eZnys=;
 b=dK6EU82xV0AgmvKAyNEFy4bY36x7iTADFr+bj15UWQmk260lQ9LndR8XHB/2f5+iGxOk5dQ+CVAUIVux4bWVYk5xGDHZnKI9guV9GsVzUzZu37Hm8eCOcI/kigxT1zRXqs77Zl/ZkeupIHsmWh5RuiBQYnCWByJWlNOy9ws3THk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB8192.prod.exchangelabs.com (2603:10b6:510:297::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.21; Fri, 24 Nov 2023 12:34:52 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.020; Fri, 24 Nov 2023
 12:34:52 +0000
Message-ID: <65dc2a93-0a17-4433-b3a5-430bf516ffe9@os.amperecomputing.com>
Date: Fri, 24 Nov 2023 18:04:41 +0530
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
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <868r6nzc5y.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0041.namprd18.prod.outlook.com
 (2603:10b6:610:55::21) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cc69c2-5549-448b-20eb-08dbece9c158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ntGciIEUUJT6qPfUCnOON3V2+DIInO87WXYIW4IlLAn6r7/wSYk3eOyo+Ml2M71HkkGJqm/Ze10s84WfdjqCy4wH6RowJiPd/+/taKG9NMg7yHd4u2c+TWOnWpNik+ZMtfhOYORo62ykEfDv7XZHgYqC22XHkmNjwAMftM5grbU0mK0HYb2rY7RVfH4ll2mDCTP6DRZb9LrVXaXcr+9SMCiKw08O1BPu3c0kSfWe5b7Vs6wbST311ZVcBDNCfLMGHEJq2f37/mv0B9KpCylCHqMrfSQzSo7t+qgfAScnuesy++bFOu2b+EA3yGjjRhOyWyAuj1jfZlwHxjq4Rroz8SeE6DfZoKi3xuJX8bisHQH7jVF01Hp9osuGCduYgajg9YoAcpD9/d+cGPDO1cQb7/5w0//i59Jvlve2mLsmsnT2CvxLARIlC1sFiTz8P6lVNijej1UX2A9zMM9xKEdOQv7Rri/yT1TNj1HUf20t/CDSd5ErgjABm8yO56yAESqJzUg7xYiv8z4R2PYJkNF0HMe6PG1duHXVcwLDwM6TUJL+HkN9t2HxxY+cTMtbDbl6+LhHoQX/IsiFimjw6ZtfriizvTVGjTxCOy5ZrTMozBU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39840400004)(376002)(346002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(31686004)(66556008)(66946007)(66476007)(54906003)(38100700002)(31696002)(86362001)(6666004)(6486002)(83380400001)(966005)(6512007)(53546011)(6506007)(2616005)(6916009)(2906002)(7416002)(316002)(478600001)(4326008)(8676002)(5660300002)(26005)(41300700001)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmlKVWx3V2tWWU54dGpJdXlXMGtMdE5COU5hTGZGdFBob0llOVRlSi9EYzJZ?=
 =?utf-8?B?WmR4a0psOEJWQjd1NWpHSWpCT2RuMFFJOWF6a1R5aHlTTlUray96NWsvZ00x?=
 =?utf-8?B?dmQ3bXVxTWNBMjJLQWx0b0dTQTNkV0VBM1lDSjdFQ2ZleWhHQzl6MWpmNTYw?=
 =?utf-8?B?eHNvVktGckhoWHErWmNlREwyak9rVjBFQWY0N2dsS0d4M3U2MmdjRjU4Rlli?=
 =?utf-8?B?akduS3ZTalJzM1ZWQXJpZVNmazZqT0k1SngxM0RwMkVtRmFHM2dvQ0Y2TVR5?=
 =?utf-8?B?NEEwTUNmQllsNnByWEs3MzNMcm9Ja3ZLUWtiT3NIUWFrR1JmT2JjY1dVVjZ6?=
 =?utf-8?B?K01vT21kbDFSczFlQjdrSTF0K05VZlVlcXovRmVXcWJaN3E4YW43dy9iR2Zh?=
 =?utf-8?B?c3VTRHZTdC9uMXo0SnVQSE9RQTM5SFpiS3Q1THJLd0RaMFEzNGVKaXVDUjVa?=
 =?utf-8?B?UWFQRDUyY2ZTc0U4THg1S3M5U1hrNGxJMkp0ZUMyNFRJUGg4OGJIYnZlMHdL?=
 =?utf-8?B?Tmk2eFNwd0ZYc3dpQ2NBL2oxTk1EYTBXVUVHU1BsK3BIa3B5MHF5Rng4WDhU?=
 =?utf-8?B?OFBBdWNzbmZWdXd4OGh6c1gvd3BqejVoTUJEaGlENU9BaDYwbk93WStXZThZ?=
 =?utf-8?B?SkFIRUQ4dnFtV3ZGd21GY3ZTb2hVZHhOQVhLYWpXeWw0NlFEYlByU3MvNDRX?=
 =?utf-8?B?eWZBVkdXcDNhSmJjZ2hDQ0szdjFiWTdxTlZJOFEzcFR3NC9XRHZvQUpkMVJa?=
 =?utf-8?B?RExKMjhxOUlDb3VEL2FlVjRTS3JIZU1ORnlRdmhaSXZvYWExU2w5RC8yYzUy?=
 =?utf-8?B?VmoyK293UUs0QmNwL3JDeVBNNTI5c0J4YzN4THNXZFZiOUZCelZkcFF4bUJi?=
 =?utf-8?B?TDZVYVFJMHdTb3JLclJiM1pSM3NYcmFmUkNCRjRCeWE4NUxtYmhHbyttZUxs?=
 =?utf-8?B?YlpYeEt1aW5RdzBBUGpDWDhsbkRYWG9YOWI3SGhHcUVlTzJ0MFlDS1hrN0Ri?=
 =?utf-8?B?RmltcU5TQnROdm5YOUczSGpzZHc2dHhnVnB6Y1pUK2QxY0VSY0QzTE0waFNL?=
 =?utf-8?B?c0ZySzc0VkJacE0rNis1cTJyeUV5Yi9FejNJb1ozVE1oOUV5bTFvL3RhRnpX?=
 =?utf-8?B?QzBMU0ZBK2xCZFpPL1lVN2dnSDJEbFRsWWF4TXUrcWJaaytobFZzamx2Z2sx?=
 =?utf-8?B?N2wxaFR0UUFKdWcyTVlOdld6UjVMNGtudGpORm96VHRJbzdQNUgvZXJnSWkv?=
 =?utf-8?B?RHFhcUtyTk1NVFh4eWVHUlhReHhqOUR2c05aVTVuZ3BRLzZiOFVaTEkrblBJ?=
 =?utf-8?B?Z0VnUTk5WWUxbVd4dmZINklWUzNsYzNJRXR4TjdZb2h5dUFOYlRjVnpWeFVC?=
 =?utf-8?B?cDN5RGlZc0V1WVRLT2xvakxWcGVZSzRJK1RQSHErNXVSQUpRNUVEeU4rbEZx?=
 =?utf-8?B?bFMzNlJDUitFRGpENHRSQUxnaSt5Q21sbGd4RjNWcTBKTU02UW5xdzdseEsv?=
 =?utf-8?B?TXZYR0h1OGlNalYzalBhcVJjYitEZ2xzNjhZaXNPVHkwQVJkZzhnUFl4N0ln?=
 =?utf-8?B?ME5JaThCQ0wxN1FmR2VnaUFEcmVna2RnaFpWTXB0QXVwTkxkaE55a3NVNTYw?=
 =?utf-8?B?RmFCWHNpZ1R1dndYUFVsa3FNa0xvMmNwem5mNlVUNHhiYVF0TzRHR1NWVTRW?=
 =?utf-8?B?UnA4S2xIVnlYakpUd2JHSUpKdkNGMGVsM2h5SzN3RC8rVjdhRFY1UWZyU04r?=
 =?utf-8?B?TCtoYXI5VXpiKzU1WkhnNGtNam43dnNBTVU0Rjk2YUU2R01CbGtPVXh1ZGM3?=
 =?utf-8?B?SDlxNTJteDhLU3BSd1BFSVlURjVTNEtXWWdHcGxmaXZzRkNqdmlYekNwS2cy?=
 =?utf-8?B?bG5mVExzMXlpc25OL1YwS3JTUzB1cnlMR3ZiZzBYajhFMmx6YXEyNEZRcGJw?=
 =?utf-8?B?cTBrOVRVVTVVazhua2tMY0JKUTcySVR6SGVvbndCNDRuOXEzT014OE9CRGVG?=
 =?utf-8?B?VXZGWElqdWl6QU1kR01MeHUzSUhzOHVkbG1CVlRoSC9RUmVTbzI5Z01MVVJG?=
 =?utf-8?B?dkF6MHNEWkVIa3Z5Q3gxd2krT2pRdVZYNVptVy92VzVCWW9XU1NrZkJVVFd4?=
 =?utf-8?B?R05WSlVtQjhKSlNtcFdrdTlEVm5oRXRkNlJtcEdtamgra3RKcDlwcGpZU2ZG?=
 =?utf-8?Q?tQP++tN2hZIaKyrtKik72Rtiq2ymZ28JOhevCPI2zZe5?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cc69c2-5549-448b-20eb-08dbece9c158
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2023 12:34:52.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnj/8ZgEgg8dD7Xia5ev0Rm2Wda69qWbNfsKnBkoCXLsYiGlyHsgRSCR9ut1pgXJLlDPvnJ5+4KBpYBUBUMOCoTlqzVFgbsBYwEDj93UpyBg3RLDXSIFNhSPN4JBDanN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB8192



On 24-11-2023 03:49 pm, Marc Zyngier wrote:
> On Fri, 24 Nov 2023 09:50:33 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 23-11-2023 10:14 pm, Marc Zyngier wrote:
>>> On Thu, 23 Nov 2023 16:21:48 +0000,
>>> Miguel Luis <miguel.luis@oracle.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 21/11/2023 18:02, Marc Zyngier wrote:
>>>>> On Tue, 21 Nov 2023 16:49:52 +0000,
>>>>> Miguel Luis <miguel.luis@oracle.com> wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>>> On 20 Nov 2023, at 12:09, Marc Zyngier <maz@kernel.org> wrote:
>>>>>>>
>>>>>>> This is the 5th drop of NV support on arm64 for this year, and most
>>>>>>> probably the last one for this side of Christmas.
>>>>>>>
>>>>>>> For the previous episodes, see [1].
>>>>>>>
>>>>>>> What's changed:
>>>>>>>
>>>>>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>>>>>    it without FEAT_NV2, and the architecture is deprecating the former
>>>>>>>    entirely. This results in fewer patches, and a slightly simpler
>>>>>>>    model overall.
>>>>>>>
>>>>>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>>>>>    is gone.
>>>>>>>
>>>>>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>>>>>    access.
>>>>>>>
>>>>>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>>>>>    than per-vcpu.
>>>>>>>
>>>>>>> - Fix the EL0 timer fastpath
>>>>>>>
>>>>>>> - Work around the architecture deficiencies when trapping WFI from a
>>>>>>>    L2 guest.
>>>>>>>
>>>>>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>>>>>
>>>>>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>>>>>    per-MMU VTCR)
>>>>>>>
>>>>>>> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>>>>>>>
>>>>>>> The branch containing these patches (and more) is at [3]. As for the
>>>>>>> previous rounds, my intention is to take a prefix of this series into
>>>>>>> 6.8, provided that it gets enough reviewing.
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
>>>>>>> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
>>>>>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>>>>>>>
>>>>>> While I was testing this with kvmtool for 5.16 I noted the following on dmesg:
>>>>>>
>>>>>> [  803.014258] kvm [19040]: Unsupported guest sys_reg access at: 8129fa50 [600003c9]
>>>>>>                   { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>>>>>
>>>>>> This is CPACR_EL12.
>>>>> CPACR_EL12 is redirected to VNCR[0x100]. It really shouldn't trap...
>>>>>
>>>>>> Still need yet to debug.
>>>>> Can you disassemble the guest around the offending PC?
>>>>
>>>> [ 1248.686350] kvm [7013]: Unsupported guest sys_reg access at: 812baa50 [600003c9]
>>>>                   { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>>>
>>>>    12baa00:    14000008     b    0x12baa20
>>>>    12baa04:    d000d501     adrp    x1, 0x2d5c000
>>>>    12baa08:    91154021     add    x1, x1, #0x550
>>>>    12baa0c:    f9400022     ldr    x2, [x1]
>>>>    12baa10:    f9400421     ldr    x1, [x1, #8]
>>>>    12baa14:    8a010042     and    x2, x2, x1
>>>>    12baa18:    d3441c42     ubfx    x2, x2, #4, #4
>>>>    12baa1c:    b4000082     cbz    x2, 0x12baa2c
>>>>    12baa20:    d2a175a0     mov    x0, #0xbad0000                 // #195887104
>>>>    12baa24:    f2994220     movk    x0, #0xca11
>>>>    12baa28:    d69f03e0     eret
>>>>    12baa2c:    d2c00080     mov    x0, #0x400000000               // #17179869184
>>>>    12baa30:    f2b10000     movk    x0, #0x8800, lsl #16
>>>>    12baa34:    f2800000     movk    x0, #0x0
>>>>    12baa38:    d51c1100     msr    hcr_el2, x0
>>>>    12baa3c:    d5033fdf     isb
>>>>    12baa40:    d53c4100     mrs    x0, sp_el1
>>>>    12baa44:    9100001f     mov    sp, x0
>>>>    12baa48:    d538d080     mrs    x0, tpidr_el1
>>>>    12baa4c:    d51cd040     msr    tpidr_el2, x0
>>>>    12baa50:    d53d1040     mrs    x0, cpacr_el12
>>>>    12baa54:    d5181040     msr    cpacr_el1, x0
>>>>    12baa58:    d53dc000     mrs    x0, vbar_el12
>>>>    12baa5c:    d518c000     msr    vbar_el1, x0
>>>>    12baa60:    d53c1120     mrs    x0, mdcr_el2
>>>>    12baa64:    9272f400     and    x0, x0, #0xffffffffffffcfff
>>>>    12baa68:    9266f400     and    x0, x0, #0xfffffffffcffffff
>>>>    12baa6c:    d51c1120     msr    mdcr_el2, x0
>>>>    12baa70:    d53d2040     mrs    x0, tcr_el12
>>>>    12baa74:    d5182040     msr    tcr_el1, x0
>>>>    12baa78:    d53d2000     mrs    x0, ttbr0_el12
>>>>    12baa7c:    d5182000     msr    ttbr0_el1, x0
>>>>    12baa80:    d53d2020     mrs    x0, ttbr1_el12
>>>>    12baa84:    d5182020     msr    ttbr1_el1, x0
>>>>    12baa88:    d53da200     mrs    x0, mair_el12
>>>>    12baa8c:    d518a200     msr    mair_el1, x0
>>>>    12baa90:    d5380761     mrs    x1, s3_0_c0_c7_3
>>>>    12baa94:    d3400c21     ubfx    x1, x1, #0, #4
>>>>    12baa98:    b4000141     cbz    x1, 0x12baac0
>>>>    12baa9c:    d53d2060     mrs    x0, s3_5_c2_c0_3
>>>
>>> OK, this is suspiciously close to the location Ganapatrao was having
>>> issues with. Are you running on the same hardware?
>>>
>>> In any case, we should never take a trap for this access. Can you dump
>>> HCR_EL2 at the point where the guest traps (in switch.c)?
>>>
>>
>> I have dumped HCR_EL2 before entry to L1 in both V11 and V10.
>> on V10 HCR_EL2=0x2743c827c263f
>> on V11 HCR_EL2=0x27c3c827c263f
>>
>> on V11 the function vcpu_el2_e2h_is_set(vcpu) is returning false
>> resulting in NV1 bit set along with NV and NV2.
>> AFAIK, For L1 to be in VHE, NV1 bit should be zero and NV=NV2=1.
>>
>> I could boot L1 then L2, if I hack vcpu_el2_e2h_is_set to return true.
>> There could be a bug in V11 or E2H0 patchset resulting in
>> vcpu_el2_e2h_is_set() returning false?
> 
> The E2H0 series should only force vcpu_el2_e2h_is_set() to return
> true, but not set it to false. Can you dump the *guest's* version of
> HCR_EL2 at this point?
> 

with V11: vhcr_el2=0x100030080000000 mask=0x100af00ffffffff
with V10: vhcr_el2=0x488000000
with hack+V11: vhcr_el2=0x488000000 mask=0x100af00ffffffff

Thanks,
Ganapat

