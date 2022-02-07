Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682A54ACD14
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbiBHBFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245405AbiBGW7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:59:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38B30C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644274790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bnau9CF87D4QKdmu69lAwZ00eJ3tC98GJMWAAtS2j3I=;
        b=V2fAgqEjwAXNkeRiGGbGpT4yidoE4VzkGAX8mcE73qhhXA9OJwkMq//xS15R0K/uLIDoi6
        hLhkwjlzIsM65oCBC4o2wvI/CYEmu4LMYGVZXFRalZCifMQSBm+oPogf9bYrxAs40oEN1W
        YUztRrjT/DRm+Vryk4K2E5uKDtaSVdc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-blhR21xmMK6uyaqu2rFelQ-1; Mon, 07 Feb 2022 17:59:48 -0500
X-MC-Unique: blhR21xmMK6uyaqu2rFelQ-1
Received: by mail-ed1-f71.google.com with SMTP id n7-20020a05640205c700b0040b7be76147so8647245edx.10
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:59:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bnau9CF87D4QKdmu69lAwZ00eJ3tC98GJMWAAtS2j3I=;
        b=5pqFiAcFhUS/QUye29ss9ygJnVhBS7qIxrTnOcKo3rbeCQB/TC0TiF+jkmOlwqthAj
         ymmauRwBwaQPSQWPyn65/uqoUSV/w+OWtBTZQNq+rSY57MjJBwXb4HfOlnw9cvHn2Pep
         vmC56lAsGBK6AQaJYHIKZS93ULoXdCpR2QA05rRnDAumxeeyo0gn+hOVkaemJhdTNCFv
         AmQjv4cveFJAY+3cUO5X7sR16DxItKJMyces4OpoesKzbcypPdRqUMuZvHtW3dqblaAZ
         Zlz+3RWgH1he62D/b/ZU09eWtOKCjPa+/3cgxLx6I9a69ADTng/LXFXZ2E4chEvWiGtt
         4tWQ==
X-Gm-Message-State: AOAM5303wWSgV39/aLt7Lw3otHKgL36kyq60FuBgS0TUQ6LFtppfqU2/
        OgnbbI0AW/gcjZnDJHtdvbSkH05aZ1LPBeFdxQk8R1gNZtphmVgAdNtQnuvEGAewFpGZBoVMwBf
        sC/8UTp7xYFah
X-Received: by 2002:a17:906:9be4:: with SMTP id de36mr1454948ejc.228.1644274787601;
        Mon, 07 Feb 2022 14:59:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8MWWraIY8T3/LyKPGWgEowe7FNqRNvfwZuGjrKHYEhXBRtbBb3xXR2xxiJSYMAdjMBIKuSA==
X-Received: by 2002:a17:906:9be4:: with SMTP id de36mr1454932ejc.228.1644274787439;
        Mon, 07 Feb 2022 14:59:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cz12sm833369edb.30.2022.02.07.14.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 14:59:46 -0800 (PST)
Message-ID: <2b1d142e-e06c-3f38-32f5-d14de7dca289@redhat.com>
Date:   Mon, 7 Feb 2022 23:59:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/2] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
Content-Language: en-US
To:     Leonardo Bras Soares Passos <leobras@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220205081658.562208-1-leobras@redhat.com>
 <20220205081658.562208-2-leobras@redhat.com>
 <f2b0cac2-2f8a-60e8-616c-73825b3f62a6@redhat.com>
 <CAJ6HWG7DV-AeWyXxGwMMV61BejcCdpTc=U+4U6eY4gx4hfhP-g@mail.gmail.com>
 <8bf8ba96-94a8-663a-ccbf-ffeab087c370@redhat.com>
 <CAJ6HWG5sD06=ZMtrcSJ+O3ZH0xVeR7gC8+9o5hq+evXh43Vn_w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJ6HWG5sD06=ZMtrcSJ+O3ZH0xVeR7gC8+9o5hq+evXh43Vn_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 23:45, Leonardo Bras Soares Passos wrote:
> On Mon, Feb 7, 2022 at 6:00 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 2/7/22 21:24, Leonardo Bras Soares Passos wrote:
>>>> With this patch,
>>>> we have to reason about the effect of calling KVM_SET_CPUID2 twice calls
>>>> back to back.  I think an "&=" would be wrong in that case.
>>>
>>> So, you suggest something like this ?
>>>
>>> vcpu->arch.guest_fpu.fpstate->xfeatures =
>>>          fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;
>>>
>>
>> Yes, but you need to change user_xfeatures instead of xfeatures.
>> KVM_GET_XSAVE and KVM_SET_XSAVE will take it into account automatically:
>>
>> - KVM_GET_XSAVE: fpu_copy_guest_fpstate_to_uabi -> __copy_xstate_to_uabi_buf
>>
>> - KVM_SET_XSAVE: fpu_copy_uabi_to_guest_fpstate ->
>> copy_uabi_from_kernel_to_xstate -> copy_uabi_to_xstate ->
>> validate_user_xstate_buffer
> 
> 
> Ok, I understand how this replaces patch 2/2, so no issue on that.
> 
> About patch 1/2,  you suggest that instead of fixing what we save in
> the regs buffer, we fix only what we want to return to the user when
> they call KVM_GET_XSAVE, is that correct?

Yes, exactly.

Paolo

