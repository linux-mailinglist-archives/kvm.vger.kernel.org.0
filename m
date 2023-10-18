Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F3F7CDCAF
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjJRNHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjJRNHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:07:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC6511C
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697634382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDPf6ZClz1qisizpypkqehRk5MT7Q/Peay1tAP2fVMM=;
        b=F+SLyeE5aNBFLClh8JWCXJT4LEeB8jB+we1jiqG3JsvaAJxOPJ/50afzmIXsoOBDQAwI7E
        a7QjQKO+FqcrUeW6g47gmTlqtW7hVNYT51VwdfoKriwepuDLKsEwJoX0f7RbuX7oorz4wP
        TFIUaWG7a0iNuzYVRUHoddmEGuV0gl8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-zgQVru-GNvG49wGFKxfTvQ-1; Wed, 18 Oct 2023 09:06:20 -0400
X-MC-Unique: zgQVru-GNvG49wGFKxfTvQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b29ba8ec93so10665561b6e.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697634380; x=1698239180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDPf6ZClz1qisizpypkqehRk5MT7Q/Peay1tAP2fVMM=;
        b=HVBZJbz9xUt6zFroFhuRdDFtJf81rhFdTnxWk/oZMgIiJuqgeOEt06ZRqHUdrFFqmW
         Jl2mnroJScv2Vo7+Unvbs2O9FLH7A9B83Ua9wrTe639Oy0R1Jh+WDqkUM0xgxN6CmW62
         GjgX5YLnMmj9+L31zhVUtfRge5VIkE6rrz9JMs+jBH9XXqle+a+8kSHnSM/tuj4SUPAi
         LDjSVVHRSl9rfoUsk1MWqiq6TUsSV+Y5VS2cayKs1ztP6JpTIkFEdk3vH3fKzACEyStH
         +FN4yKzFWomDIK2KrzAjigtdWvhb2EgfrJlYH1ohWIa+S3AcYRx9AYKV2W70litpuiIu
         kVCw==
X-Gm-Message-State: AOJu0YxpUMtgCL4pGc2HDMxDBxhhHVeE0Yg5QKBPE+upv4vHB50AdLIG
        iCV1ExNOv+v6zao9wMCSquuqsP+n0uDOzFEZnYp71iVX1HddscZZFYFfGE2dr6pF6TXVl33l6+Q
        uYsEnmq9r0yHF
X-Received: by 2002:a9d:7651:0:b0:6bc:8930:a1d4 with SMTP id o17-20020a9d7651000000b006bc8930a1d4mr4729130otl.15.1697634380058;
        Wed, 18 Oct 2023 06:06:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF28cwHOtFQEM5xgFaOvInzipiKqUbKufB+2pe6ZuBmbmYYz/MbPBWWD8uzmf2D4Eu9+1qKxA==
X-Received: by 2002:a9d:7651:0:b0:6bc:8930:a1d4 with SMTP id o17-20020a9d7651000000b006bc8930a1d4mr4729102otl.15.1697634379644;
        Wed, 18 Oct 2023 06:06:19 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.189.211])
        by smtp.gmail.com with ESMTPSA id a28-20020a05620a16dc00b007778503ebf4sm1375071qkn.16.2023.10.18.06.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 06:06:18 -0700 (PDT)
Message-ID: <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
Date:   Wed, 18 Oct 2023 15:06:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark, Oliver,

On 10/18/23 14:16, Mark Brown wrote:
> On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
>> On 10/11/23 21:57, Oliver Upton wrote:
> 
>>>  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
>>>  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
>>>  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
>>> +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
> 
>> could you comment on the *DIT* addictions, what is it for?
> 
> DIT is data independent timing, this tells the processor to ensure that
> instructions take a constant time regardless of the data they are
> handling.

> 
> Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
> the main purpose here is to sync with the original.

Ah thanks. that's helpful for me to understand where this gpr-num.h
comes from. This could be documented in the commit msg though.

Something like:

adding tools/arch/arm64/include/asm/gpr-num.h matching linux
arch/arm64/include/asm/gpr-num.h

and syncing tools/arch/arm64/include/asm/sysreg.h with the fellow header
in the linux tree.

tbh I did not initially understand that all this diffstat was aimed to
match the linux arch/arm64/include/asm/sysreg.h. Now diffing both I have
some diffs. Doesn't it need a refresh?

Thanks

Eric
> 
>>> +/*
>>> + * Automatically generated definitions for system registers, the
>>> + * manual encodings below are in the process of being converted to
>>> + * come from here. The header relies on the definition of sys_reg()
>>> + * earlier in this file.
>>> + */
>>> +#include "asm/sysreg-defs.h"
> 
>> strange to have this include in the middle of the file
> 
> It relies on defines from earlier in the header.

