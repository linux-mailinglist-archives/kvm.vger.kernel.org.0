Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2748684C
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiAFRUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 12:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241633AbiAFRUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 12:20:36 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D070C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 09:20:36 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id x15so2950206plg.1
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 09:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UboDS31gi+6ezClBOANA8GrTYVa4ZNE97bilfoocy74=;
        b=n8ND/Yh2Aeh4upIOJUX6ItnoxdWH4/Fia63ZyKT+f9mMggMYBq+9LfDPbDYY6p6hKX
         zHSrMN2J9ulhYOs6eohgALG0aYLSdzT0x4fN0iTgAuxPFmeiJSW05vwzDiLtmUyDsz9C
         yCWEvtTzuR1o22D1y7a+jpQdXW5LsIpvs3bgtkWYLR6wwLr+p9FDdUDr99Wm984tpH7x
         0ATdeQQYJq/2e/0/o3sYf2qNZtTpVyGUn3jV8kFjk/c7SUjbPtaqt3XosRDBGK9Hp0Hr
         8q3I2+rE3Et28u7+6BdinfGw7WG70PnKcoJy/odrOJJ73K/AeulTRHnqjLQ3PUvXTeHm
         Givw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UboDS31gi+6ezClBOANA8GrTYVa4ZNE97bilfoocy74=;
        b=J2xBPPMzmVurOuKVb9ArNzAqFabMV6MCtlwrn7lafuvrRRh8VJfF/rLY4Ldm/3QGPc
         Xb8LX3EHPSJqtO1sfv3tdyvvKLpMtuIwNRWb34yEzqXEJgQPWho8PcEZHa8Zp2r3LhrP
         kCyqfIIE9TGZpo7s/xqc9OeP9a4KsSD1mWoY5p+DbEatiOepgHe2PP5YZQ5uInowCdlk
         daOdNsCMUNTwzSPEYw+jCD5pOpZJcqPlbCqUK/VaHE0QAB3Pjk7hcQgiBLDsrcMfNovr
         ScjH6dBAQtbYNALHcvJmhyqQG2tZY806qQ3NW/BfpYYSmMNN4Sm9FVjEKLakSY5uyUss
         Hdtw==
X-Gm-Message-State: AOAM5339qjNsjxsAzMtfx7EWXjOaEYZo3qbXYV1pKLaIsjBRsaMoIx4k
        1pIZl+NFnaxR50pzfEfywRNSkA==
X-Google-Smtp-Source: ABdhPJzlaKrZaIdz6LGH8kAr0gek22yp7m1zrUEHpl6K7zWOYBVHmwMbe6AvXQgA3sBeLh2fKPBozQ==
X-Received: by 2002:a17:90b:198d:: with SMTP id mv13mr11366930pjb.182.1641489635507;
        Thu, 06 Jan 2022 09:20:35 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id y3sm2890860pju.37.2022.01.06.09.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 09:20:35 -0800 (PST)
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220103180507.2190429-1-maz@kernel.org>
 <c5bedb8e-55e3-877f-31aa-92d59e5aba34@linaro.org>
 <87czl5usvb.wl-maz@kernel.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <3db95713-2f05-3c70-82b1-7e12c579d3e2@linaro.org>
Date:   Thu, 6 Jan 2022 09:20:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87czl5usvb.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 1:16 AM, Marc Zyngier wrote:
>>> +static bool kvm_arm_pauth_supported(void)
>>> +{
>>> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>>> +}
>>
>> Do we really need to have them both set to play the game?  Given that
>> the only thing that happens is that we disable whatever host support
>> exists, can we have "pauth enabled" mean whatever subset the host has?
> 
> The host will always expose either both features or none, and that's
> part of the ABI. From the bit of kernel documentation located in
> Documentation/virt/kvm/api.rst:
> 
> <quote>
> 4.82 KVM_ARM_VCPU_INIT
> ----------------------
> [...]
>          - KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>            for arm64 only.
>            Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>            If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>            both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>            KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>            requested.
> 
>          - KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>            for arm64 only.
>            Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>            If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>            both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>            KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>            requested.
> </quote>
> 
> KVM will reject the initialisation if only one of the features is
> requested, so checking and enabling both makes sense to me.

Well, no, that's not what that says.  It says that *if* both host flags are set, then both 
guest flags must be set or both unset.

It's probably all academic anyway, because I can't actually imagine a vendor implementing 
ADDR and not GENERIC, but in theory we ought to be able to support a host with only ADDR.


r~
