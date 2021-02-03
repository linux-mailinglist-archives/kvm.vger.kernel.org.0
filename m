Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FA30E295
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 19:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhBCSd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 13:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232159AbhBCSdy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 13:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612377147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7Kj/iu1RRPsN/U0D5eoCVnquVK6zdSdB3X85PNeWrs=;
        b=GET7OWIYoab8XPU5waCWCfoPmTcR2/VBe7r1dtLrGxtE+0YgIVqM4BfRd5M6cVYE9FUMJl
        d5q/ADkFrsexY/+x/NYS2zv0nNKXh0xZA02o7nCz00GehOGCx5yMp1j+uZWewqoIo2KdsU
        WhCvdZKdZNpgGyQQIkNehy6ljYP9+Yo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-OQac3W62MHqKCqGyJKgbEg-1; Wed, 03 Feb 2021 13:32:25 -0500
X-MC-Unique: OQac3W62MHqKCqGyJKgbEg-1
Received: by mail-ej1-f70.google.com with SMTP id m4so250135ejc.14
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 10:32:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y7Kj/iu1RRPsN/U0D5eoCVnquVK6zdSdB3X85PNeWrs=;
        b=o1g7wN2r68etghPG7qWgBdfoYSyIsb7PI+4MsEWq6uXXfCgrkgbWdkE+8GukCGqi8s
         bZ7/h7Z8jJh3ve+iJT4Rhjf+s3dQY9Q2E6TbxL9Mgknt24ihQ4utrroYqysdizqCIX9F
         +bWvMkhIVtbL+FjG0zz0mbIMzn5hDb4+QfEVI5qu4gsU7fXjtU3IDJtvydO7EtIJ+EX4
         AcMuKzUR/1pceikjoLD9KHFCphL+SseDKf0H7z06KWSUD5IAdwbJvvaPW3gbXQfsPCE3
         wmTRq8Q/tE5k1evyOM8GBr8XLNSJ818gonqHlyo7mCCxVbbardBgXA8sSwV95I4tB/ye
         0uVg==
X-Gm-Message-State: AOAM5316w8tUu+e0HhkFTeWStElxFMWwRGLdfrcKFveLztq4N8ArTX1+
        2VZjLxzC60ussERlvjNWvogGpdAy0z4DsyuCRpPrEQv+dt8pKufhaOGj+4JkzeP6BFubwcpMPqh
        40Oul+QgQrIW+
X-Received: by 2002:a05:6402:104e:: with SMTP id e14mr4490714edu.316.1612377143952;
        Wed, 03 Feb 2021 10:32:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3qjXbqSfe3KuRrIZ5u6TMphYJ/AUj+jHjyXPdoqq+cU7Rh9zy30ng/IRgBuDMak1o1YNO0w==
X-Received: by 2002:a05:6402:104e:: with SMTP id e14mr4490684edu.316.1612377143776;
        Wed, 03 Feb 2021 10:32:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r7sm1352098ejo.20.2021.02.03.10.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 10:32:22 -0800 (PST)
Subject: Re: [PATCH v2 24/28] KVM: x86/mmu: Allow zap gfn range to operate
 under the mmu read lock
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-25-bgardon@google.com>
 <813695b1-bcfc-73ea-f9fe-76ffd42044cd@redhat.com>
 <CANgfPd9OTKUJfnuRtMguC7kBf1GZz5Ba0yT1ssX29YQ2Zm54aA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7104de85-0b01-a950-91f9-04fb3d5eb1be@redhat.com>
Date:   Wed, 3 Feb 2021 19:32:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9OTKUJfnuRtMguC7kBf1GZz5Ba0yT1ssX29YQ2Zm54aA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 19:31, Ben Gardon wrote:
> On Wed, Feb 3, 2021 at 3:26 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 02/02/21 19:57, Ben Gardon wrote:
>>> +#ifdef CONFIG_LOCKDEP
>>> +     if (shared)
>>> +             lockdep_assert_held_read(&kvm->mmu_lock);
>>> +     else
>>> +             lockdep_assert_held_write(&kvm->mmu_lock);
>>> +#endif /* CONFIG_LOCKDEP */
>>
>> Also, there's no need for the #ifdef here.
> 
> I agree, I must have misinterpreted some feedback on a previous commit
> and gone overboard with it.
> 
> 
>> Do we want a helper
>> kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm, bool shared)?
> 
> There are only two places that try to assert both ways as far as I can
> see on a cursory check, but it couldn't hurt.

I think there's a couple more after patches 25/26.  But there's no issue 
in having them in too (and therefore having a more complete picture) 
before figuring out what the locking API could look like.

Paolo

