Return-Path: <kvm+bounces-366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 181767DEC5F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB539281A74
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663F246B8;
	Thu,  2 Nov 2023 05:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QgHhjFQZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9C01FDC
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:39:36 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07AE112;
	Wed,  1 Nov 2023 22:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ina029EMEuC6CcfdUPfHeso/B6mxL6455jPAot3HXYg73a0ClQnXJ8/XjNeu8HHrvXcyGKAoM8cvwdaLvZZNqS101GztaorcmFrKUAKYQR34yvfpnYSUy7D4y9rAgIEoLyXBJJDAAON2wVKjDTxHWFP64g0ywaIkATauHNWf9V8akSMngGorCj4punk5DewkeBLV98iSMd4LpDs/I6CVyQoHnkHjVo74+4vqmvFnGnmN/ZI+r5AcMGwA4UX8T0HT+icAwbtKUoLrQYfSY/RxDy8Ay5ONT1MwnKD36KgkbaFU0YC4idIyTUV1cNv17VX4FaNyMJ2TrXtmqpbszEwVhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSBr375D73fMMePfj12ivKPHZF4zQlBak/s9sHEVSC0=;
 b=XEodKjFNVhbwLrNy0x1DNqtKGHSGCosCWH2CkIThg87IPZgDTPHe5M8pHbJDDBB6NWkn6dI5TBh2/IEkmlL9GsW+nV4C04/OPJnKmQGyIB7UWnztHnji3V4vHORjbeI57qev4i9N+v8h+CDJ1ktFkYaWn1sc9daBhcc6QA4E7GEeuuFeLSYYlB826LVefjJ7JxCPsLq6a1mVVYvYaVcQJXlglrJz1EZpiuNyUsdeMw67PECJ3tPCilsugn2RODpCW5PBJ/Ar4zCQf9tuMQ+yBXa7liPzOcHIzN+9VPbkXiQ33qF8JsK3jrvXjToa69YkQxHr5rh0VCHUxpqIywyZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSBr375D73fMMePfj12ivKPHZF4zQlBak/s9sHEVSC0=;
 b=QgHhjFQZSPKY6M+tj+23lkwjiw++bttajcz94HcB/8BxI1Gkf8ezZi/6tzVfYedn8EsPyjhdSuAU8LEwpv8F9ajmqBT02zDSWQ2FR2jCrx0m3ZVeHvrOZgU4ASdsu9bdiCTMYjLv/eZ2UcX6XLgd+h0UUtz6uQhk3A71M26+XSw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.28; Thu, 2 Nov 2023 05:39:28 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:39:28 +0000
Message-ID: <0321430a-8666-4017-b791-127484c2b17e@amd.com>
Date: Thu, 2 Nov 2023 11:09:16 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 12/14] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-13-nikunj@amd.com>
 <cfc9f863-dc07-7c23-7621-d2dc115651bd@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <cfc9f863-dc07-7c23-7621-d2dc115651bd@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 016afbda-d7e0-43be-ff3a-08dbdb661475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zgNsFhULMoaYOjhJyo/mtXeJjzMiYqw4hLi/heTc3dzOyzU/Vi5a4ZLOtaf2KxnvM8TErJajG+dFi3GvlLBM17lC58LyyuRiZFdec+/Qge7221DG9QRRNPsc9bE09LA1lDjWZ3sIRgHAJUX+OfkRFkdDAFoVY42VoaiGacH079W/f6E8Y3fXZ9aKEyijQqGUZ2fGtc58wNFz3leAcg5ZjKjvv+Nwmiot9i3Y+qgwstvFTWAW59nQZjac8y90tekB6FBAN5RXdpxBE7ccpssOsxzr6XvFXO/krcrbWUoaTKn76crorLFEz/IukgmqVdnijkmyMPHFmujbdww3Le+eRYKYFwV8nGm5Jrt33HTkN4fvNQuGZszGnChtvIkCD9Mtx3WllX9dkHlMeZQZtaEPvaacUoFHu6YHIS+JPfz0v0rKqRhXPGwjqcC1H7Ew4jANOk3hJ2q38XuoIJTy3XcHCnQgj756Tq1Xm/nbJXVNktzLHw/IFDqJFarMhexd8+BsbiTSUPjhawP57P6UN1BZGd6fs2JV1zXfi03/Zoymh0lboGUOAIxG608015MqYiMFId0Sfdqf2HsOVk3SaRWQaR6fNGp2N/kZTUAcHieTtmZBa/RLmogU1MhjB+qHUYHdnFkHZO4YGTPUDPSFAiDCTA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(346002)(39860400002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(66476007)(5660300002)(31686004)(2906002)(41300700001)(478600001)(66556008)(6486002)(6512007)(6506007)(6666004)(53546011)(66946007)(966005)(7416002)(26005)(2616005)(83380400001)(3450700001)(316002)(8936002)(4326008)(8676002)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnUyV0N6L2cxR1RldlhrWFFYMFExaGZWNFhpOENzOXozNGE3QkhZOFBoeUZ0?=
 =?utf-8?B?czQxMkloNkdYMm11dTYxZGwzRFFDTG9aL0pkb2JpTldNdEN0VTl1YnRtVnZ2?=
 =?utf-8?B?SkdVUDVmZHpsdWtSUFFhdXVQOHNraG9BanZCclg0TEc5YXJvOUtEekxIc0hm?=
 =?utf-8?B?TncrV0VISlRJTlRuemt0Q3RwZk1rdDFEM2c5Nzh1dWNzWm4yUGpJVW9yaFlM?=
 =?utf-8?B?dHJwZ3VUajhNc1orcmYvRWxOeUJmbXFhOVBWMGErUmVnR2pKaHBMYitHS282?=
 =?utf-8?B?TzFNVmpFd0ZsKzRXbUJjNEpDVHdjb0cwZzVvekdZcytJd0FwUUowTVhXUXli?=
 =?utf-8?B?dzUrWC9ZQ3lCdDRhZkJMbGwvbWVLbm1HMVYvcVFLVXl1djZNQ1ljL1oxSytF?=
 =?utf-8?B?ZHZpZnVRWjhMdFhnTmRYQ1NFNis2NmhqdVZ4T0ttVUx3RXlOeDFncDQyaEdL?=
 =?utf-8?B?NkxMYUxndXhreHB1d3JwVlNEb0VzYWpibEFlZ0JwSElXNlFRR1BONWk5VE9Y?=
 =?utf-8?B?UVFCRklZaGN4N1BkcUxPOVJVdkVpWWRyNjc3aEtlRHlZdDBJb2dHWEJUdDF1?=
 =?utf-8?B?U2ZTMnZ5eHFOODJWTllpZGVhb0sxa2dyY2tENm1sd2czYWljeGNkcnRBTlZk?=
 =?utf-8?B?YU05MG0veXkvR0NIOTVvcmd5aS9NdzIwaVpkMml2ajczbVorb2hPV0RING52?=
 =?utf-8?B?R3FXNHR2YzNpN01uS1NtSGFveUQvMVVxWEMxQ1RXNzVvRTBPWERkL0p5TmVs?=
 =?utf-8?B?SXhENVZIaDJaS3NSNjJNbFhsY05GQkZUSlBqZ1h5bk0zdWNCamo2YWVHRFZh?=
 =?utf-8?B?bDdNbjZFYUFPUklhLy9FWVYxTHRwTUpUUElDZ2tLZ0ZUMkZDK0NRR3FrUEw4?=
 =?utf-8?B?S2p3NVU3V3Npc2h6RWpxUGZMVXNSVjgrU1dYMSt5ajczNGlVemptYkliSWIy?=
 =?utf-8?B?UlllS09aMko0MFdEZWZXK0dlb2dwcGJtY0tnempMeWo0M3lRd0gvTk9kSnB4?=
 =?utf-8?B?Vkg2SG0xb3kzU043TFM5empzZ1dTeVRtUHlJN2VtamJScGdVUitvOFRTQ0pp?=
 =?utf-8?B?OFE2cjZOc2JrUG01U3kvZld3NWRCQ3owaSt4Mzhhb2tuM1J1MXhVdW5xa0Vy?=
 =?utf-8?B?bHlCSDlaeXByR2hrTnlKbUx5OVg3RjYwb2x0a0VlVHRQYnFxMDhaS1BCaWFZ?=
 =?utf-8?B?dUpyTnFqR09JaDljZjJtUnIrdjlrL002M1kvZStNODhLaUNKWDVqRHdZcmlo?=
 =?utf-8?B?cy90QytVNlYxSEJ1Wi9HRy9XK25IdlBMTjZGU2Z5cWpIbVNxcVRFdU50ZzlX?=
 =?utf-8?B?SHVHUlh6MXlVN1NoQ2RnTHppV3h0UzdmYmd2UlFLTmRQb0JDL0c2UmlVSkpU?=
 =?utf-8?B?VGhqa05YNE9EQ2pYeUlGanovOGE5T3Z3RE4zak9DTEhPZG54ZGw5TFdsRDFT?=
 =?utf-8?B?Z3Z1S0I0Y05VS0IzZFc5aHQ2MjBtMFh6a3lLS0VEMHZJUmFwZGZyVDYyeEph?=
 =?utf-8?B?bndkelM1aFRZRXI3Uk9jL0t6NW53Q0IyN2hJTlV6Y2ZDdkg2allocnRzK0Rh?=
 =?utf-8?B?aUx0MDk2UXZqVTNnWFRkTlZiNGdwU1JoaC82WmJXRTZhYnpxbGJMYWRpcmFz?=
 =?utf-8?B?TlRzSERaejRaQkcyd3pGYnBtWDcwaWd3aXZ1ZllkaGlYM1VsbERCaEtCMlor?=
 =?utf-8?B?V014RzFBVW44YkpwUWhWNWx4RGhKektVU1FiMGpZdTdvMWE3dWQ3WDNITktk?=
 =?utf-8?B?YjluLzk1YW1uSXBlZENhSGMzK0d2MVlOaktYdlc0Tzl5aitRWjBIU2svZUNH?=
 =?utf-8?B?MnE0bHZzWjZYWkNiK1h1aUlHOTRxYjBtMXFIbmJaSTBUbGx3Q2tJYU1vUnVM?=
 =?utf-8?B?SG9lb0xkS3VmaWoxZTdhUHZ6UHV0OTIrTDRUY2pOeU5UMUVkY0ZHQmlVajcw?=
 =?utf-8?B?TXdJdVplUEZVRS90UUJJR3dFSFN4UDY0NVBKbGJZb01PcUVCYXUycGdxRjNU?=
 =?utf-8?B?ZW16WWVlTjViaW5jekZiY2p5ZFZkQ0MxQ2o5endkMFcvSGV2b1FvUEVGQ3JS?=
 =?utf-8?B?YUErTjc3S3NDMFA3VzIxaCtlQXh3cEZ6UGpEYUF2b0RNM1c2bnYvKzhJSnlH?=
 =?utf-8?Q?9eYgSyn2X4u2htXAfhDkdcCzm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 016afbda-d7e0-43be-ff3a-08dbdb661475
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:39:28.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc0XUpf0vqeVGEGvnPbE7U+V8vAFtwBZ5DmixoN3tQcneQuCtZuz/2T8fkQWnzUTi5IAM9AujGScZrKpCKhW9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972

On 10/31/2023 2:30 AM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
>> The guest kernel will fallback and use Secure TSC based clocksource.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/kernel/kvmclock.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index fb8f52149be9..779e7311fa6f 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -288,7 +288,7 @@ void __init kvmclock_init(void)
>>   {
>>       u8 flags;
>>   -    if (!kvm_para_available() || !kvmclock)
>> +    if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> 
> And is setting X86_FEATURE_TSC_RELIABLE, as Dave Hansen suggests, enough
> to prevent usage of kvmclock?

No that wasn't sufficient. kvmclock was always selected before SecureTSC even when X86_FEATURE_TSC_RELIABLE was selected.

> 
> There was a discussion here:
>  https://lore.kernel.org/lkml/20230808162320.27297-1-kirill.shutemov@linux.intel.com/
> 
> Thanks,
> Tom

Regards
Nikunj


