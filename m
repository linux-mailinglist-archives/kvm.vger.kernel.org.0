Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0B266257A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 13:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjAIMZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 07:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbjAIMZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 07:25:26 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2103.outbound.protection.outlook.com [40.107.101.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9541B1E3
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 04:25:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHpDvp4bU4OTCH0CbfC5QXErstMWCjaZuJ48aLjat6SmIFcPqNxlzO3HO8P+dRyjduQTue70TSNiGJYe+HxiwIOD6qY0cFXU3mMkzDE7Im2TCI5wV/9FJ4wDSFoX+Y5+sguwAW7fy/AWHrAsXR5QpY7oMfdQJ58+MNOLxe8Zpks77Cjb5YYlR4+Gwra5NbOhh1cKRbq3m7UUa/xKfF7BCU/xdwfMeMsJdQsct7cD+hek7M6/x0APiFQzM9t9CuvmFnD/4BsyGFPCbbVMcpgyWlzHpov33Rjw2pBr3r/uwIgq/2HTLFYlhJ8H50Iy/buaHNcrqCubdQwrNTDqqv8NcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDqfQeEx9Fl431+e5UlsGNVR4B8TwrEqLLQLel3vd3g=;
 b=W8JBWFWtczKVLP/hiq8YSv0zasKMgVlvkoBUi2qhIex/GTmsrxLyxEqoWsjssCmRn10jYnvZ9VcVtG8ry4fyaDsh1i11LGvaQ0KD+UCmvUq2MpizYPnHPfYFkl3RvDzCOi/TtN6lp4e5rrEW7K5mjjxBdVQr56u0QOSHl9SH801jr8Q0mU2bkrRuKO8nDvzfeA0Lfa69vioGrNAswvK9glbudYjrDvH68D3DcGt0xhbMWPQPArmvtHDQHmkrr+YIVLNTZMlccKwYjwmioH4JXwQRdGLqYSl9lEZnRV3sQNN+jozAAV3X9qT3bkHwJpaQgOcez/k5/74FVwo83p4q8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDqfQeEx9Fl431+e5UlsGNVR4B8TwrEqLLQLel3vd3g=;
 b=rMQ0y5qgFIKZJDwwJLwzZjNQ8Z7s4bymFw0GU6algBwnv/wTjm45npxTuS4CYCrPEloSbvYCGdKjC0FMwkxrvM1zYJJQadtfsiXwwfB5TjBuL5ZzFOevQSHkLgd83CO+qZULcPLk/EyaAd5mD2fkXg72q9KZ95Z+ES3CU0GUYyo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 MWHPR0101MB2894.prod.exchangelabs.com (2603:10b6:301:30::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 12:25:21 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 12:25:21 +0000
Message-ID: <e1a2fabd-969f-d80d-09df-4562c8d5d342@os.amperecomputing.com>
Date:   Mon, 9 Jan 2023 17:55:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/3] KVM: arm64: nv: only emulate timers that have not yet
 fired
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <20220824060304.21128-2-gankulkarni@os.amperecomputing.com>
 <87zgb6e54o.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87zgb6e54o.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:610:74::18) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|MWHPR0101MB2894:EE_
X-MS-Office365-Filtering-Correlation-Id: 563e06a0-5349-4220-f8e9-08daf23c934a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +b31jItOSkYdn6tMLgDkHCbvbPBELRiF4vEa5Iua8EWHz0RHbFSaX+GsNh00EpmU2CRbFd8nGMvhz7poobDWrftn8pM3dsDndqp/43+NBGM8BGYWZsyeLHnQ3yh9tgjc+hqAxxppX/YO2JPp4RlmO8HnVWQZJSWxLsZjnaOdu+5LhqYmq/YQ8J4PmjTSutBV1V1Mwl4veHt9vbn9eAqxntLO2FeNXVcZiHN1dgUb8T/BMsaokeTk36RxJZL7gLvRqu3VpcNcz2X4biApo7bAgS7fv1DBsbNUlvYGQdgcpeAD52OYqt7byjiz3A1ED+Zr4r4+5eoxxAnu4psc/ho48Q5ZFk8AfU6IrtQVs087h9HlY9ktgrnXqqmtJ+x7AwuXFfEelcvsPpilYCyMYTFsPRf4W+R9KH+NoeZEoN+k5zi8EE7KEu7xA11YGrKHC2k+ow3jvg2bYrGlDaLot6DS/YppxbkitlZ/Q/6vuJXhiNnkFLJKPjD0w4rJqp4LjEskU82F1zPkjQbNbJKKQusH1H7AOJkGOI2cWlDIuo71C0Ymz4wCpeNaJ6yrJ2wFD3fuNhw6p6W0d0l3PqsZ0xkpdolwnJ7Juh31IVdKWIrizDOKXHND1q21xXShUI4lorHGecHZWTJOEyiatBoZynep3thjJzeg3y87Q9n3QwPfT6Eb+8Mhr9YjIFIq13hZ5mV3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(39850400004)(346002)(451199015)(6506007)(53546011)(2906002)(6486002)(478600001)(6666004)(107886003)(6512007)(26005)(186003)(31686004)(316002)(2616005)(6916009)(66476007)(8676002)(66556008)(66946007)(4326008)(41300700001)(83380400001)(8936002)(38100700002)(5660300002)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlQrQjdZZ21ieFpONk5LMmNOaWczRFRBTTJjWmFiVFFESnA3REJsUENDaTRo?=
 =?utf-8?B?VUgrZGlhUU5vZmhBeFVDQUllMmYyeS9LNzRMR0trUmY5YXRWa2hIRXRnV3oz?=
 =?utf-8?B?aStuWjRnUzlBVjBXUllJK01zK1dDNnRhRDg0Wktjd1N2WkF2NjVuaG11cjZz?=
 =?utf-8?B?R0prdUFxZ3VGeC9vaXJjNmc1OFh3dHl0N2tIOVpvYldJYUd5eWJmM0Zxd3VN?=
 =?utf-8?B?N1JvMThrMERORHVEaVFRVndnWXNSb3ZkOFVVbEM4anNMOVFJLy9ISjhrT1Bz?=
 =?utf-8?B?aVp6eUtRK3BUNjdGR09ieXFGOFY1dFRTZlJBaXVGK0V5SjMvcDBiekRGQ1By?=
 =?utf-8?B?VlgxRCtYUk8rMnluUUxQQzRrOTQ3elVKMGdZc2pqS2xLTjl6QzBJeUFySURn?=
 =?utf-8?B?aTVqM1NQR2wzaFk5amQ0TjdUN004dEhIemxNSTFSeUQ3aWVBblBtdUx1WTMy?=
 =?utf-8?B?WmNtMEFvK2poMG9mYUhTSzlwYlh4bWgxTGo3TjNFQitrTjRDeFZ5cXd5YTJL?=
 =?utf-8?B?OVRrNG03dk4wVlVObTI0eVBnR1laWnNyRXhxTENITFFXaVJEN3BGU2JwT2xn?=
 =?utf-8?B?NXFGR25kcVJLOHlkUlpSOXc1OXRqV2JOc2kxUERpdVY0QkRoQkV6S1BQWDNu?=
 =?utf-8?B?cGxqS2RSSFZpc0E1anpUMVk0YS9BVFY2V1RwamJ6djdFaFp3QlZQeDVzZFBq?=
 =?utf-8?B?VmFYczFOb0pVUkF0VkFEdEs4cHY5TmZnRGxoMWVWUklVUHZxN1dFK3JVSjVP?=
 =?utf-8?B?N0puU0lzWnFXR042SWlYYXBQbW81dnBGUlhuMmpPbUdpaGxiandWT1BFTEZN?=
 =?utf-8?B?YVJYeVd2Z0NLVFVyNGx6VW0rTVlvbHVJcGYrMkhYVTVKTEs2azducFd0SmVh?=
 =?utf-8?B?TlZvdjF5eEdkV0h1Q3lSWndIQVNHVnJqVmVpZEFML1Vnc3R5QVMrQmZkcFNh?=
 =?utf-8?B?SHdxWnNhaUxuRHcrTFhjR1FlRy95YXltbHo2NFNGUGdvQ1JWZmtUVmR4Rm9D?=
 =?utf-8?B?YUtSMEllRkJkd2tnN2FOSDM3RWJqUzNzdWRpb3RraGU4bW5zd3pKNStMLysw?=
 =?utf-8?B?emQ0bmxicVIzNGVQN0dRbHgyRzQ5aHRRSnVMQm9CYkpjTUlmTDFjKzBKMzhy?=
 =?utf-8?B?bjdBakZnUVgvVVdidjMwcUVNY2FHcXhscEx3K0p6NTgrUVZDVXBzR3dEdXlO?=
 =?utf-8?B?WkdsbHMzSWMxUXRlOVF0eCtveExTem11bUl1cVFKTnlFc1Vrb21ITlBid2Zs?=
 =?utf-8?B?TXJLVzJ4WUExdVk1VU5vTUVGcWh3bHEwRmlxdWRXVG40Q1dxQVVTQ1YxVVdk?=
 =?utf-8?B?NVlLQTZiNmRnMkNJSnh3NERpaW9rUm9FSEFkenBNWWJtT00rZjEwQkhhSURG?=
 =?utf-8?B?a2ZkZmQ1M1Z4TzJVZEhiM21UMjNEMkR0NGthbzJjWVFOaldicXNXQzNZdnZu?=
 =?utf-8?B?TTZCUkxmQ1pSWk1WZ2RiT0VJaVpxbUMrRUpCMDB5NGZ1UW9PTU51VE1jRk5S?=
 =?utf-8?B?aW0xL1RvQ0ZhTGpuTkR2T3JHc1d3VGo2L0VqZE10K3FRd3RRTnAwRHB3OG5Y?=
 =?utf-8?B?WjNodm5xYXdNcjF3Q1N5U3Y3bmlJNitSQmZsVUw1ang1a3hSbVRic2dCVHo5?=
 =?utf-8?B?ank0cEg5WWZKaEhUMVd3NjhIcmV3dXdYWG00TmplcmVGSVV0VFhCSHpaZ21Q?=
 =?utf-8?B?akFFSkdzbnVxUHJvcjJwUDRGK0NxTVZsS3g5WGRObGpLZHZyNjB0STdpbHhP?=
 =?utf-8?B?dW9oMmd4aCt0NnpzUzBudzgzT1g5SGFJbEdXMk14VU5WY2NyN3VxdDFpOXJr?=
 =?utf-8?B?TUk1NDNnMVNGK0x1VkQ1eXY5MVJ6TlFhdUtMSzJBODhaN3JiNTQyampHT2ZS?=
 =?utf-8?B?aTB0Tkh3NjNudzkyazhaVVV0VDRDY1Rib0Jid3RNTXRNdW9rZ2VBNWMvWFVp?=
 =?utf-8?B?NTdhUW9KU21IUGpoS2JSVmUzNkEvNUw2TVlVTWpET1BjTUk1cWxHUzY4MlZy?=
 =?utf-8?B?TG5nVis4Z2R2SzlqWVM3SU9Fc3Z3TlRoNzRlaDRJajZrZ1Q2dVY1eW9wKy9u?=
 =?utf-8?B?NkdKQkhVRytxL042Q3BIYXhnSjJpL2JiOVFjRmZTL3JIaTRocjlvZnpIZEF4?=
 =?utf-8?B?ZnNIUTZQMGxvY2hIcllrNWxyZWlNblRybStrLzdxS0xxelRLUUIvLzRKaXV0?=
 =?utf-8?Q?JPLrFKymauiQL7MtcdWf1BE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563e06a0-5349-4220-f8e9-08daf23c934a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 12:25:21.1344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2r56Ccf1w+uWNj6Uc6LkJDIvhjyiQvETEDDAoBOz0xwWkolMUOwssqz+fCydN0mEMQmsAGLLksrrXVNqjYI5n7A+Czh3bgIjiXcbxiAGsdGjccXp84U9PeFLFMsv5H9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0101MB2894
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 29-12-2022 06:30 pm, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 07:03:02 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> From: D Scott Phillips <scott@os.amperecomputing.com>
>>
>> The timer emulation logic goes into an infinite loop when the NestedVM(L2)
>> timer is being emulated.
>>
>> While the CPU is executing in L1 context, the L2 timers are emulated using
>> host hrtimer. When the delta of cval and current time reaches zero, the
>> vtimer interrupt is fired/forwarded to L2, however the emulation function
>> in Host-Hypervisor(L0) is still restarting the hrtimer with an expiry time
>> set to now, triggering hrtimer to fire immediately and resulting in a
>> continuous trigger of hrtimer and endless looping in the timer emulation.
>>
>> Adding a fix to avoid restarting of the hrtimer if the interrupt is
>> already fired.
>>
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/arch_timer.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 2371796b1ab5..27a6ec46803a 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -472,7 +472,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
>>   		return;
>>   	}
>>   
>> -	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
>> +	if (!ctx->irq.level)
>> +		soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
>>   }
>>   
>>   static void timer_save_state(struct arch_timer_context *ctx)
> 
> I think this is a regression introduced by bee038a67487 ("KVM:
> arm/arm64: Rework the timer code to use a timer_map"), and you can see
> it because the comment in this function doesn't make much sense
> anymore.

OK, check was removed while rework in bee038a67487.
> 
> Does the following work for you, mostly restoring the original code?

Below diff too works and avoids the unnecessary soft timer restarts with 
zero delta.
> 
> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index ad2a5df88810..4945c5b96f05 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -480,7 +480,7 @@ static void timer_emulate(struct arch_timer_context *ctx)
>   	 * scheduled for the future.  If the timer cannot fire at all,
>   	 * then we also don't need a soft timer.
>   	 */
> -	if (!kvm_timer_irq_can_fire(ctx)) {
> +	if (should_fire || !kvm_timer_irq_can_fire(ctx)) {

Now, aligns to comment.
>   		soft_timer_cancel(&ctx->hrtimer);
>   		return;
>   	}
> 

Shall I resend this patch as regression fix of bee038a67487?

Thanks,
Ganapat
