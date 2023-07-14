Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08BC753E41
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbjGNO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjGNO7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:59:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCB21991
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 07:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689346740;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzXAukTZdGWnOTB/+GT4ZdL7CULxJGloPmAknPVgqfk=;
        b=WJ+KdhYk4FuFnpDMuaaqVI8VClfN6TGv7pZTJ+50KpD5+1EZ/cwvBRkOItJchPlhIk8LP8
        gGUgh5ZMcpXBNUa0vFey7HpWz0H+fiO2mwN7lsRHWpNjAu6hXLhP49mA53suthj3qu5QUp
        1Fq0Kn3drUBEqWTijTSSEuMDg0oNhB8=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-Lff3yRDAM0yF49vIEAJYJQ-1; Fri, 14 Jul 2023 10:58:58 -0400
X-MC-Unique: Lff3yRDAM0yF49vIEAJYJQ-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-44361cc4b9aso355623137.0
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 07:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689346738; x=1689951538;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OzXAukTZdGWnOTB/+GT4ZdL7CULxJGloPmAknPVgqfk=;
        b=MOlrJ/g2cAni9weE+bCYKtzWMWg8pQRB26u9ADQM87qYqWvMegjOxyb5Odp6+NBHkR
         OMxt8N1b4pSncZJHaNw1UuvdM0JaGb2cBBuPIWZl8zbRX8nF5D9TxjHe2b/9IL3b5gbG
         dguhhG42+eMh5xo48QLIqOKYog7AR0VZKSMkK7/kbFDnxQxUrBzBYxAHIO/PgV7OuA8b
         fln+mVNYWZMagKaQVDiLHU1lbRe601dqfcDXZNC5y5c1FaJAKsiXU7IKHe7AsH//olfk
         ic9QqBwngN6lwiN7OLC31KP3QAIVPAiyTGVdZlmL+/tpUglKJ+4+LJCKA4aOoSq+Rcg/
         AdaA==
X-Gm-Message-State: ABy/qLZHvv2XtIZpCjFj6waOBztPplxbKEdf81tPPvzU/OjmL0+Zqeuf
        0HnjlFAa5lk/fnEMp72caasxjbbavQCS95XXQLfudbJNFU+fg6MuMyrZhFDs0rODR7gB0bifQQI
        jtTU9ZIwhkIfW
X-Received: by 2002:a05:6102:89:b0:443:687a:e518 with SMTP id t9-20020a056102008900b00443687ae518mr2246649vsp.35.1689346738346;
        Fri, 14 Jul 2023 07:58:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHtbML/klMWS+JD7BpSCOZLRnlogXLPpYlrhwPn3T/ZkH5MOKZJ9JbnXEMqJ0TSFh3DBPO+Sg==
X-Received: by 2002:a05:6102:89:b0:443:687a:e518 with SMTP id t9-20020a056102008900b00443687ae518mr2246630vsp.35.1689346738046;
        Fri, 14 Jul 2023 07:58:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u14-20020a0c8dce000000b00632191a70a2sm3994458qvb.103.2023.07.14.07.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 07:58:57 -0700 (PDT)
Message-ID: <32e49f7c-2382-fc1d-8725-a4edfbcde66c@redhat.com>
Date:   Fri, 14 Jul 2023 16:58:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 16/27] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-17-maz@kernel.org>
 <8c32ebdc-a3bc-aabe-5098-3754159d22cd@redhat.com>
 <86sf9rvmd7.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <86sf9rvmd7.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/13/23 17:53, Marc Zyngier wrote:
> Hey Eric,
>
> Thanks for looking into this, much appreciated given how tedious it
> is.
>
> On Thu, 13 Jul 2023 15:05:33 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 7/12/23 16:57, Marc Zyngier wrote:
>>> Describe the HCR_EL2 register, and associate it with all the sysregs
>>> it allows to trap.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/emulate-nested.c | 475 ++++++++++++++++++++++++++++++++
>>>  1 file changed, 475 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>>> index 5bab2e85d70c..51901e85e43d 100644
>>> --- a/arch/arm64/kvm/emulate-nested.c
>>> +++ b/arch/arm64/kvm/emulate-nested.c
> [...]
>
>>> +	[CGT_HCR_TPC] = {
>> modern revisions now refer to TPCP, maybe worth a comment?
> Absolutely.
>
> [...]
>
>>> +	SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
>>> +		      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
>> in the spec I see this upper limit in the FEAT_FGT section. Out of
>> curiosity how were you able to convert the sys reg names into this Op0,
>> Op1, CRn, CRm, Op2. Is there any ordering logic documented somewhere for
>> those group3 regs?
> If you look at the sysreg encoding described on page D18-6308 if
> version J.a of the ARM ARM, you will find a block of 56 contiguous
> encodings ranging from (3, 0, 0, 1, 0), which happens to be
> ID_PFR0_EL1, all the way to a reserved range ending in (3, 0, 0, 7,
> 7).
>
> This is the block of register that is controlled by TID3.

OK thanks
>
>> I checked Table D18-2 and this looks good but I wonder if there isn't
>> any more efficient way to review this.
> Not that I know of, unfortunately. Even the pseudocode isn't enough
> for this as it doesn't described the trapping of unallocated regions.

OK
>
>>> +	SR_TRAP(SYS_ICC_SGI0R_EL1,	CGT_HCR_IMO_FMO),
>>> +	SR_TRAP(SYS_ICC_ASGI1R_EL1,	CGT_HCR_IMO_FMO),
>>> +	SR_TRAP(SYS_ICC_SGI1R_EL1,	CGT_HCR_IMO_FMO),
>>> +	SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
>>> +		      sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
>>> +		      sys_reg(3, 1, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 2, 11, 0, 0),
>>> +		      sys_reg(3, 2, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 3, 11, 0, 0),
>>> +		      sys_reg(3, 3, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 4, 11, 0, 0),
>>> +		      sys_reg(3, 4, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 5, 11, 0, 0),
>>> +		      sys_reg(3, 5, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 6, 11, 0, 0),
>>> +		      sys_reg(3, 6, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 7, 11, 0, 0),
>>> +		      sys_reg(3, 7, 11, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 0, 15, 0, 0),
>>> +		      sys_reg(3, 0, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 1, 15, 0, 0),
>>> +		      sys_reg(3, 1, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 2, 15, 0, 0),
>>> +		      sys_reg(3, 2, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 3, 15, 0, 0),
>>> +		      sys_reg(3, 3, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 4, 15, 0, 0),
>>> +		      sys_reg(3, 4, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 5, 15, 0, 0),
>>> +		      sys_reg(3, 5, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 6, 15, 0, 0),
>>> +		      sys_reg(3, 6, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_RANGE_TRAP(sys_reg(3, 7, 15, 0, 0),
>>> +		      sys_reg(3, 7, 15, 15, 7), CGT_HCR_TIDCP),
>>> +	SR_TRAP(SYS_ACTLR_EL1,		CGT_HCR_TACR),
>>> +	SR_TRAP(SYS_DC_ISW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CISW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_IGSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_IGDSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CGSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CGDSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CIGSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CIGDSW,		CGT_HCR_TSW),
>>> +	SR_TRAP(SYS_DC_CIVAC,		CGT_HCR_TPC),
>> I don't see CVADP?
> Me neither! Good catch!
>
> [...]
>
>>> +	SR_TRAP(SYS_SCTLR_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_TTBR0_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_TTBR1_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_TCR_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_ESR_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_FAR_EL1,		CGT_HCR_TVM_TRVM),
>>> +	SR_TRAP(SYS_AFSR0_EL1,		CGT_HCR_TVM_TRVM),*
>> Looking at the SFSR0_EL1 MRS/MSR pseudo code I understand TRVM is tested
>> on read and
>> TVM is tested on write. However CGT_HCR_TVM has FORWARD_ANY behaviour
>> while TRVM looks good as FORWARD_READ? Do I miss something.
> You're not missing anything. For some reason, I had in my head that
> TVM was trapping both reads and writes, while the spec is clear that
> it only traps writes.
>
>>> +	SR_TRAP(SYS_AFSR1_EL1,		CGT_HCR_TVM_TRVM),*
>> same here and below
> Yup, I need to fix the TVM encoding like this:
>
> @@ -176,7 +176,7 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		.index		= HCR_EL2,
>  		.value		= HCR_TVM,
>  		.mask		= HCR_TVM,
> -		.behaviour	= BEHAVE_FORWARD_ANY,
> +		.behaviour	= BEHAVE_FORWARD_WRITE,
yes matches my understanding
>  	},
>  	[CGT_HCR_TDZ] = {
>  		.index		= HCR_EL2,
>
> [...]
>
>>> +	/* All _EL2 registers */
>>> +	SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
>>> +		      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
>>> +	SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
>>> +		      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
>>> +	/* All _EL02, _EL12 registers */
>>> +	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
>>> +		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
>>> +	SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
>>> +		      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
>> same question as bove, where in the ARM ARM do you find those
>> ranges?
> I went over the encoding with a fine comb, and realised that all the
> (3, 4, ...) encodings are EL2, and all the (3, 5, ...) ones are EL02
> and EL12.
Oh good catch
>
> I appreciate that this is taking a massive bet on the future, but
> there is no such rule in the ARM ARM as such...

yeah that's unfortunate that rule is not stated anywhere
>
>>> +	SR_TRAP(SYS_SP_EL1,		CGT_HCR_NV),*
>>> +	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),*
>>> +	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),*
>>> +	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),*
>>> +	SR_TRAP(OP_AT_S12E1W,		CGT_HCR_NV),*
>>> +	SR_TRAP(OP_AT_S12E0R,		CGT_HCR_NV),*
>> according to the pseudo code NV2 is not checked
>> shouldn't we have a separate CGT? Question also valid for a bunch of ops
>> below
> Hmmm. Yes, this is wrong. Well spotted. I guess I need a
> CGT_HCR_NV_nNV2 for the cases that want that particular condition (NV1
> probably needs a similar fix).
NV1 looks good. There NV2 is checked
>
> [...]
>
>> CIGDPAE?
>> CIPAE?
> These two are part of RME (well, technically MEC, but that an RME
> thing), and I have no plan to support this with NV -- yet.
OK
>
>> CFP/CPP/DVP RCTX?
> These are definitely missing. I'll add them.
>
> Thanks again for going through this list, this is awesome work!
you are welcome. This is cumbersome to review but less than writing it I
suspect ;-)

Eric
>
> 	M.
>

