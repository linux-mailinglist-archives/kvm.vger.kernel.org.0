Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA424869DD
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbiAFS1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242948AbiAFS0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 13:26:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC39C03327B
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 10:26:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso9602729pje.0
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 10:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HlaWOyLJWUxC/fcMDwyvfjC8xT8OixmJxKEiGSjvP78=;
        b=wnYu2Su9FUNALxqI5H57lVrouxwCAxjS9z9uEp0cHC5tBU9whcr8F+OGJwvsPlpB1c
         k0tlBUjFz2sOB95QW9wG2x3zBrquvqrafRV4ZkIkrk7JYXTKrRFdpUU12s84soPbOmwj
         wusCLLM5bU/UrpBMtNmJD1pknx6bc4ytVUxW//VVKqjZP3lZ840xYsfEEsmsE66OwnFl
         IUKqtEDsGGC89wRoLwE972yS+Yt/8aYGHJDswJxBt+QU9oHR2O7tDplNFVyvtErZKpGc
         mcGyO4buYHutNvSG9+Osf1VGUVgt0ywDZGZkJxfu7y2+lpd/ETIrYa6Qhj/lGlo00rDp
         A8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HlaWOyLJWUxC/fcMDwyvfjC8xT8OixmJxKEiGSjvP78=;
        b=go1kmvm/bInx7OD5jgyUQSpiqdXxRg+aMOARFqifMfzV3YjEKvazF33xPA+4KptVMh
         /w8s0pogKPTyi4ccyEJMfLsHgI6us+zrhcupGcIkdI049YPnA2M0zf1TO1SCRChSfxTs
         AYDVe9rf3PFhqJSJ90vYTMUpgbe//FLMoH+Ta9fBVYW6HXqknNspA3oxoBMISq9rlFW6
         fzF3wSl2kyknNwR2iwZ0Iq0XNlHdXnLdbJEgtwmUMSz7WpyOL86Xz2Qi1yc5KuAYAtCd
         aRoH8Nx4VSR3/NVODn6nloPWw8nT/pQLWzHBQESrrdfHxENoudcTExAAm/bg5EhnYWrV
         jfJA==
X-Gm-Message-State: AOAM533JDTr7f3ZWXglaLvhWL0dn/JEsLHqHArnOr8e3ioTelxpGYtTQ
        oI0Rc6aaALYdixAb+9oKVPrr+w==
X-Google-Smtp-Source: ABdhPJxoQ3eVXISS6TugVeDxoCB53qQ/yNRF/WUAW9yzPhsSj1SmdwcZJEgtVSWbLiTQugXVAbFPpA==
X-Received: by 2002:a17:90a:f316:: with SMTP id ca22mr11527272pjb.171.1641493590872;
        Thu, 06 Jan 2022 10:26:30 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id 72sm3129138pfu.70.2022.01.06.10.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 10:26:30 -0800 (PST)
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
 <3db95713-2f05-3c70-82b1-7e12c579d3e2@linaro.org>
 <875yqwvkm1.wl-maz@kernel.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <364fc879-4b13-cf37-53e0-628a843c7bfa@linaro.org>
Date:   Thu, 6 Jan 2022 10:26:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <875yqwvkm1.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 9:29 AM, Marc Zyngier wrote:
> On Thu, 06 Jan 2022 17:20:33 +0000,
> Richard Henderson <richard.henderson@linaro.org> wrote:
>>
>> On 1/6/22 1:16 AM, Marc Zyngier wrote:
>>>>> +static bool kvm_arm_pauth_supported(void)
>>>>> +{
>>>>> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>>>> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>>>>> +}
>>>>
>>>> Do we really need to have them both set to play the game?  Given that
>>>> the only thing that happens is that we disable whatever host support
>>>> exists, can we have "pauth enabled" mean whatever subset the host has?
>>>
>>> The host will always expose either both features or none, and that's
>>> part of the ABI. From the bit of kernel documentation located in
>>> Documentation/virt/kvm/api.rst:
>>>
>>> <quote>
>>> 4.82 KVM_ARM_VCPU_INIT
>>> ----------------------
>>> [...]
>>>           - KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>>>             for arm64 only.
>>>             Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>>>             If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>>>             both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>>>             KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>>>             requested.
>>>
>>>           - KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>>>             for arm64 only.
>>>             Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>>>             If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
>>>             both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>>>             KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
>>>             requested.
>>> </quote>
>>>
>>> KVM will reject the initialisation if only one of the features is
>>> requested, so checking and enabling both makes sense to me.
>>
>> Well, no, that's not what that says.  It says that *if* both host
>> flags are set, then both guest flags must be set or both unset.
> 
> Indeed. But KVM never returns just one flag. It only exposes both or
> none.

Mm.  It does beg the question of why KVM exposes multiple bits.  If they must be tied, 
then it only serves to make the interface more complicated than necessary.  We would be 
better served to have a single bit to control all of PAuth.


r~
