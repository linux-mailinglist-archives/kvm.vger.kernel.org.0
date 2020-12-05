Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894D52CFD52
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgLESbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgLESbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:31:10 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A557C061A4F
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 10:30:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id t4so8520446wrr.12
        for <kvm@vger.kernel.org>; Sat, 05 Dec 2020 10:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WWqB20MHAs7UMnoS0Q6wgVRoNx/aV34/MkacRhfSd2g=;
        b=FqjMFY35Kb8fRgveJIbmJSEnngdTQVOSCs+4B3cuDi3ZkfsNiNGumRrAf8+yrzjVGy
         arUYkhjkyxJdWdkV4eZluhd419jR1LaVgbv4cS0hX2RkpkMXAjWqYk0JG4mHEffhBcPv
         GjYH3w169U7ENGBN2eXElYELND23Ow+AuFRmtwQaIH5PXytG4F/RRe4lCukoJuiDcN3S
         64qRm68NomRD6Cg+1HvMAxjzf6ilu+0vxQropPGcSU8CGHbeu3RBkyQwGpquWbJlBlm7
         5Se6Yw5x3tKgErPatWIsYmWdJeGWIa9MA5a0iqjkHprgq5FMYHWi6sh73m2QQ+If625c
         47VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WWqB20MHAs7UMnoS0Q6wgVRoNx/aV34/MkacRhfSd2g=;
        b=ljZoAlbupNY6d66PZvQ5t2sBqkCTQyXL5ZIODcd5K6m7rJvJ2gZH+Ou/lmVNfZ6Meq
         72dqUSU5Zg0jdgwtsUlSxOvoTqEPYWGwZCTvNyaf+Ap+Z+WaxIyfVEREzqqMkpRJcjgU
         OnZ7rRQ3Wa6Z3+BVs7ouI7c6dI3RS85rVooxUEcaC8KnzolIRn7XAMPlHqT0cv97vPIz
         b4OD6EwgdOGfBYVArnELEZScmXOcD/qzov7IP5dAFGHcYwKermbY4sMQqWWjB8lXjfD7
         icuWFO7wtSqSqCr41BRSp1a8zMam7YVOR4YDperd4FsJwywVwRVqFWQavAe+QdctKaHw
         uqYA==
X-Gm-Message-State: AOAM532bJGRsey62ZYGzjpcl8mAjE66AleglFJSaGGyAlMpWYhxy2jY5
        yCpiZWDRR4c/lnH6CVDEPdBuHQ==
X-Google-Smtp-Source: ABdhPJx/HpX8LbNHK0WAMgBXImoLA/JSSutGQfKGJfblyYzGcfa5RRxbrXAYyzeokwA/L1EWySoLug==
X-Received: by 2002:adf:fdc7:: with SMTP id i7mr9400942wrs.398.1607193022694;
        Sat, 05 Dec 2020 10:30:22 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:8165:c1cc:d736:b53f? ([2a01:e34:ed2f:f020:8165:c1cc:d736:b53f])
        by smtp.googlemail.com with ESMTPSA id h20sm7581744wmb.29.2020.12.05.10.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 10:30:21 -0800 (PST)
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To:     Marc Zyngier <maz@kernel.org>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
 <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
 <ef43679b6710fc4320203975bc2bde98@kernel.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <1ff86943-3f58-b57c-b3db-c3a92af79d2b@linaro.org>
Date:   Sat, 5 Dec 2020 19:30:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ef43679b6710fc4320203975bc2bde98@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 05/12/2020 19:22, Marc Zyngier wrote:
> Hi Daniel,
> 
> On 2020-12-05 11:15, Daniel Lezcano wrote:
>> Hi Marc,
>>
>> are you fine with this patch ?
> 
> I am, although there still isn't any justification for the pos/lsb
> rework in the commit message (and calling that variable lsb is somewhat
> confusing). If you are going to apply it, please consider adding
> the additional comment below.

Ok, I will do that.

Thanks for the additional comment

  -- Daniel


>> On 04/12/2020 08:31, Keqian Zhu wrote:
>>> ARM virtual counter supports event stream, it can only trigger an event
>>> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0
>>> changes,
>>> so the actual period of event stream is 2^(cntkctl_evnti + 1). For
>>> example,
>>> when the trigger bit is 0, then virtual counter trigger an event for
>>> every
>>> two cycles.
> 
> "While we're at it, rework the way we compute the trigger bit position by
>  making it more obvious that when bits [n:n-1] are both set (with n being
>  the most significant bit), we pick bit (n + 1)."
> 
> With that:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> Thanks,
> 
>         M.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
