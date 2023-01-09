Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB86662805
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbjAIOE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbjAIODt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:03:49 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2115.outbound.protection.outlook.com [40.107.93.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED677B2B
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 06:03:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsMDZwCoBM22qtZEvQQShb3zq2lc36HPM7tNN+7SGxRkey+XWOBQ7Wb7lrW1sicpWqin/fw4X/PGl6Fz7woUp46i/b9Z9kT2HYUTSA/dRtOBjTkeXMAS5AJn4YaKJDNuWnlS9zCDWPUaiagZvzMRWgpCVl/INohGR1eSqPiSi1hHaoRGxX/0GgJNCg6yL/tvzFOqcEI1vktsTC51GQHvxpWMz+xIezurP3Ga/00JMGLQ6SQ9MSSxoCPVY9EL6wHae4UjaB4jYlZv0EBfdqbB65RKbC6Wz+DvuSMcHCJym8R9Oof9iWxqDOEkCcGz7LzStTISHElCtXaxO8TTRMx71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sr3dVpBCftmLSlmwy9TG9Vx+Lo9ZmXVXhK5zNs34oXY=;
 b=XT54p07x9ICmOkBKyJfN2aLcgDylV6Oq/NfHasAxPey3eejUZXKRskXabIpKT26ppGFcOUCy9PDWECxcrzZDSAvuKNNvDffrhLjUdIye9fWklFbMnIqFxlVHlsCQWSNyb2/RZcPAoeEY+p9mcHcKNXGZRiIq0Wyos3eGLr5Sxw/P/4DuoI5DprVtUtuzRqxukXwUoukVX8r1LcD8f95kb+VTT7R+zcOPwO+ZprGUuULYruoc1zKsJLR6iJ7DYJ71t38mwqQA33UrT7nikicAEt40FG6/ealzfknozc1109KYk0R2bG44nhf9mi9vKfy0OyXSfdiGvPHSXNV34V4oLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sr3dVpBCftmLSlmwy9TG9Vx+Lo9ZmXVXhK5zNs34oXY=;
 b=SLgQ++4P1wb9FofXhoEfzrMo7wN26L832RfET4Sz0fetxq1/yduhzvK3yPZ3gGwqL648Va/Re5aIMvX1XAu4oQxasQ5tYSCgLMWGe3DGyrRT8tt2Nj4zZbKyzNpu5RPSDIvcYdcmR2VsR0RMLU2vMh/7hHJgZ5ylSqZ1vHxMfZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM8PR01MB7095.prod.exchangelabs.com (2603:10b6:8:3::11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 14:03:24 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 14:03:24 +0000
Message-ID: <3b357b3e-58d3-3830-220e-6a52ffb094fd@os.amperecomputing.com>
Date:   Mon, 9 Jan 2023 19:33:17 +0530
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
 <e1a2fabd-969f-d80d-09df-4562c8d5d342@os.amperecomputing.com>
 <86h6wzomad.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86h6wzomad.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0062.namprd07.prod.outlook.com
 (2603:10b6:610:5b::36) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|DM8PR01MB7095:EE_
X-MS-Office365-Filtering-Correlation-Id: f295908f-96ec-406f-8bca-08daf24a463e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVCWA/owuEH6TIDoRZ3m7dnVErTD947GGKZGsyX4o1RqfXofbPJ5VCr0cUzoy6NhG3NPe8aocHEisGr+FhlvXHjBLz1Ag7SM31biK50L0L0Qj02deUr8zb+b29FZDeUxHoI0QgcVF1l+eR9AxhTJbdWutyQiCJqBhoZqv3gxrVo5SBeCAloG7xWWZ23yt1KmX9ky/19thVXhjP11dC/BSz43Fo4KEpgMvUs8nhtUrbVeTx/pWXvLqt00OzLZFzMdrw8V84ETXRsl6y6syRlbLlZbxiO+PI0Uw6OShrs+Rn9IzRjFAGJ/K5UqV7WtSvk24IYE7QYLUu/b3MDxjTWkjk0CaNanmrTWhA2gTsFzrbiZ8LngsOqx5J+2RYH7zJCOyY1px4iZdwxk4XgAwSP3algxbKTE840N+9SvGqgLR1DPbpxUy0GB2ZUMpGgplM57grzUA1pbHT+b5bI7blRKiLxaeC7n/cxusMV8S/wFc70CwZNL/6OeiDF4HLwflr4p5EMlK8lSxTYvofTCyqRf2hkWOhBW9AVHVXJPDA5pfp65x1g8Rt3Xs5QrI04u0EabxMOOAkaJG26uhMLz9pY8e4pyjbSMLWFsW9IVQBvMf7tOlYfcOKF1k5MQx4SnOiDmdYlgI/eRTtGn4iWijDsdbzFnMPEsiO68vad7aPSpXtzTHg6DRHW4XccUjP+NANZjeXosAGVlWAscDB2sICRtTxk7jB11Dmg7EHFACCV++7w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(39850400004)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(66476007)(66556008)(4326008)(6916009)(8676002)(316002)(66946007)(186003)(26005)(6512007)(2616005)(38100700002)(31686004)(31696002)(83380400001)(86362001)(107886003)(966005)(478600001)(6486002)(6506007)(53546011)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVVEa0dhaytmRTNsTWc0QkNXUWdaZDlOSTVBaGVpZFVuMzBNZjFUYkFoRDN1?=
 =?utf-8?B?eDdLWjgrSGRxbSt2WDZ1aEphYm9mRlpKY25XckkvOStpVXI4QWVTQUQ0TzU5?=
 =?utf-8?B?cGJDaER3REg5a0J1ZDNncUdUdTJWOThsQjUzNFNoNWREb3p4V2hqeUtxaTNJ?=
 =?utf-8?B?a0NQbVJIcHpLdXNQbVQ0NXppSncvV0oveWhsT3AxbzI4eWs0K2p5MDloRDhI?=
 =?utf-8?B?T3A3bmRnWmZjeDI0NkdTNVh0dkp6bXNZc1RGVzMydnVZQktIdzkrMmFPbFgx?=
 =?utf-8?B?ZkFBSXVzSm8yRTBTb2haQzh0djJtQlQ5NnVQak5vV0ZiRlNYY1FPODBpWEp3?=
 =?utf-8?B?Vm9TU1J1OE1jdGJSbGRudWdlUzlpdFZSaHFxKzBHRVZSYTZLbitTY0xBNiti?=
 =?utf-8?B?azZ1MTlTVDZKK0J3ZXhpRnVsYjhpR3F6TTJMcXFiekRQQXJwVkdaVE9QVkVY?=
 =?utf-8?B?NmtLL2JCcjhnZHhzQXdjWnNuK05BZ0hGQTZIMzJQbGl0dHJpSlU5L21pbjUr?=
 =?utf-8?B?d0xzaHV6b2syYytEOUl1UGRBTUdNNnN4c256bUpNN2VzS28rbmJFWEZKR0lU?=
 =?utf-8?B?M1M2S1M1S2tLTENaVUZESGNsYUF6cHJ6Y044SGV1TGlOelA4cmhjNnBGU2Nh?=
 =?utf-8?B?azgzVjYvMkFyeU1POWk5a3pNbFRFNXZyM01mN081QStDK0I2QitSZi92T05w?=
 =?utf-8?B?RmNOcFpVZ3Mzbk1kWWpxZ0Ntb2JCYlJwWVZzY0gxM1ZMT0VEaVVPQ0lpdWlU?=
 =?utf-8?B?NzFuT0JqYTk2dnJUUXFtK1doWWZSR3BQWGZNbTkyOWtuTGtSV0c1Mi9TQm9a?=
 =?utf-8?B?WXUyc2tQdVkrNFF0TnJVcHBjaExXTUtLdjhlUElmTG51RTBOSXh5a2pnRmFu?=
 =?utf-8?B?NWtFblIzNkY4ekxPdUdxUWo4NWFKdDF2OTZlazNrWi9CWkJQbU5kWGpHL20x?=
 =?utf-8?B?RWV1WGFmMXRMcVY2dENFc2pOblIzVWFqTTJkeXBpZEhTZTA2RlhUUjNPUmk3?=
 =?utf-8?B?SlNLazlQNFVGTUFtM3dIT2IvWHRMbVVkQWJPTEJDSlRqd09GY2t1WjdWa2JI?=
 =?utf-8?B?Z0RlYUI2R2VsL3FOU2FnNnoyUTNZc0xkTW1tWW9VejFWRzgyb2N5K3JGR2tx?=
 =?utf-8?B?Q0Zxei9oRkZ3MU55VmVqRE9rRVp0WVE5Z2xSd1BmcmU2Mm05UGcrRlM4Vlhv?=
 =?utf-8?B?K3VnYjVJWGhWNkFZSkc1VFl3K2I5WStJbmY2YjgyT3NhQWVraEx5R201czB6?=
 =?utf-8?B?VG9lMCtFMXhQOWVVR0xPbGZBR29SL3RraENZQ1IwRkV0UGt1dVVVTW5rcFg2?=
 =?utf-8?B?RWNKdEk5V3Jrbm1td2pkSDBDRFFtMGNWV2dBNjhmUmtPWHZVWFhCc3V4YUti?=
 =?utf-8?B?MVBRbm1DenNZK252emI5ay9PV2JoOGF2YUFaSXRsSEk3MXV6UGtEcUI1UVNG?=
 =?utf-8?B?YkFSZ2MyQnBZdDlLY01QS2JBU0VObG5NUVZweDRaYU5OYmNSVVc3dVBlMGdp?=
 =?utf-8?B?cjBJRE90NzY0SEltVWhJTFhaRkc1bkdpR0ttL1VRdjZPbCsxcnlBQ2ZyOUk3?=
 =?utf-8?B?NlNDUWNRZ3RDdEt3N1BTemcyMjNYdGp5eU4yRkVoZFFkTWltUkUvZ1YwWTlI?=
 =?utf-8?B?N1Z6azNVYTFOZUN0ODQrUUV3WWo4UFFlM1UyellaNlpBdmF2QTJHakNKNVFY?=
 =?utf-8?B?NHJ3Z0FGQ0ZkMnhGU001UVBlakFWdUh0K1ZYbmtuRnplVE81Qk80dHhpZ3V4?=
 =?utf-8?B?cDVPQjVoRno5bjY2SXAwemo1alZnNWpCRldad2N3dXh2WU1aRHJtaDBVSU1M?=
 =?utf-8?B?M0JybTVwRHpXc3h6UXM1K05HMUx4bnYrSUtCK3NUc01nKzM0Nm9mQzZRUGZB?=
 =?utf-8?B?VzRoR09nNDUzK1JFdk9PWVRmRWhNS0g4NFNFNlc5NEFaQmRUenpZR0lFemtx?=
 =?utf-8?B?MWdnZFM1Q0xyK2ljZGFXVUxnVVdXcjNYR2h6QjhhdXhDWEE5R2xYUGNPd1lN?=
 =?utf-8?B?RzBUdWlmRmRrM1NNTEFrUlJ6T2E2bHBwdkQ5d0MwKy9LVUo4NEs0Rm5MZHJW?=
 =?utf-8?B?a2FpdS9BUTRmWkg1bDI1YXlLMmFUdlJCZzl2T2xkV3Brb3ozdGR6RWQwT3NU?=
 =?utf-8?B?cjJyaVdWSkp5MjhzdCt2RGlNM0ZZZm15N3ZpVWFQeWFYK09lQTVESWpLbldm?=
 =?utf-8?Q?Hg0zFpzcfE88Q1ZTp2eJ+4E=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f295908f-96ec-406f-8bca-08daf24a463e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 14:03:24.7758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHLlFZ7BXoal/GCmg5/HdiDM/oRH11lIoUz902CUYbt+CDtOZbamDdrfXtYTJjSZmnhsOCzxONiFZXG1/KkpqQAft+R1S2yhLQwr4oH0J/j9LDvq2f4rHzl7uhdLdDfS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09-01-2023 07:14 pm, Marc Zyngier wrote:
> On Mon, 09 Jan 2023 12:25:13 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 29-12-2022 06:30 pm, Marc Zyngier wrote:
>>> On Wed, 24 Aug 2022 07:03:02 +0100,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> From: D Scott Phillips <scott@os.amperecomputing.com>
>>>>
>>>> The timer emulation logic goes into an infinite loop when the NestedVM(L2)
>>>> timer is being emulated.
>>>>
>>>> While the CPU is executing in L1 context, the L2 timers are emulated using
>>>> host hrtimer. When the delta of cval and current time reaches zero, the
>>>> vtimer interrupt is fired/forwarded to L2, however the emulation function
>>>> in Host-Hypervisor(L0) is still restarting the hrtimer with an expiry time
>>>> set to now, triggering hrtimer to fire immediately and resulting in a
>>>> continuous trigger of hrtimer and endless looping in the timer emulation.
>>>>
>>>> Adding a fix to avoid restarting of the hrtimer if the interrupt is
>>>> already fired.
>>>>
>>>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>>> ---
>>>>    arch/arm64/kvm/arch_timer.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>>>> index 2371796b1ab5..27a6ec46803a 100644
>>>> --- a/arch/arm64/kvm/arch_timer.c
>>>> +++ b/arch/arm64/kvm/arch_timer.c
>>>> @@ -472,7 +472,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
>>>>    		return;
>>>>    	}
>>>>    -	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
>>>> +	if (!ctx->irq.level)
>>>> +		soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
>>>>    }
>>>>      static void timer_save_state(struct arch_timer_context *ctx)
>>>
>>> I think this is a regression introduced by bee038a67487 ("KVM:
>>> arm/arm64: Rework the timer code to use a timer_map"), and you can see
>>> it because the comment in this function doesn't make much sense
>>> anymore.
>>
>> OK, check was removed while rework in bee038a67487.
>>>
>>> Does the following work for you, mostly restoring the original code?
>>
>> Below diff too works and avoids the unnecessary soft timer restarts
>> with zero delta.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>>> index ad2a5df88810..4945c5b96f05 100644
>>> --- a/arch/arm64/kvm/arch_timer.c
>>> +++ b/arch/arm64/kvm/arch_timer.c
>>> @@ -480,7 +480,7 @@ static void timer_emulate(struct arch_timer_context *ctx)
>>>    	 * scheduled for the future.  If the timer cannot fire at all,
>>>    	 * then we also don't need a soft timer.
>>>    	 */
>>> -	if (!kvm_timer_irq_can_fire(ctx)) {
>>> +	if (should_fire || !kvm_timer_irq_can_fire(ctx)) {
>>
>> Now, aligns to comment.
>>>    		soft_timer_cancel(&ctx->hrtimer);
>>>    		return;
>>>    	}
>>>
>>
>> Shall I resend this patch as regression fix of bee038a67487?
> 
> I already have a patch written for this at [1], also getting rid of
> the soft_timer_cancel() call in the process (as it doesn't make much
> sense either).

OK, thanks.
> 
> Please give it a go if you have a chance (though the whole branch
> might be of interest to you...).

Sure, I will try this branch.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-6.2-WIP&id=effdcfa175c374a1740f60642d221ad2e930c978
> 

Thanks,
Ganapat
