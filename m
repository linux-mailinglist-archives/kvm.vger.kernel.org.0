Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D44EFC5F1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfKNMMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:12:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726115AbfKNMMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 07:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573733552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jr2zCjSeTDmz5TVrhby4FrqE0YdmHvDexM2VAIzxcOo=;
        b=AJR+Eag4I7g+wWK21jG2gGlOEx4zj6nsUuuTUxEn5DY67+oH1Ln5+f9sKMMhWayifMOI4+
        vyL0DJ9UqDf5dTEgUisAgW4s4N3fy66jovQ2qJYCtdIdJq2Rjxb1y/77MTr1f+1fy/NbBi
        zro2xVZh4JItuG2sy2VT1NzhPcAkNI4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-BWNWmG3UMc20_qXBNB0q6Q-1; Thu, 14 Nov 2019 07:12:31 -0500
Received: by mail-wr1-f70.google.com with SMTP id q6so4295181wrv.11
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UQ2TSHMjz1U5NvkcvVppTAW2BaOTPx1u0hnGdhH/G/c=;
        b=JiM8+9j2LAn5R91BtNxIjK0oGBUbybg19CKRG1iOAirZld85iduAh6v3FzXhRUkHtB
         0KhWUHpF+VTaMU6TUV12VPytL+3dzaqas8ia9mwsGy26/YYcZNAf/TSQAQGd/muzQu1Z
         BhRyXE9JhSCQTFptTNla4VCJJ6MPdijGanGfA6+CL1yH9/Nshi4Fq6+ZOGYfUjttprF0
         OOebpbRaDY6kjZysuRkDDOelFNGYtE1lJIOpn1PR8kACd6k/k/mjT8NtmcS6ajq9XHX+
         dvMg+llcTJvlP12UrXdo9K7nT/QyU3Mi8lEdw04Vz50OT0ID8ryM3V/UZma5tOsiNXPZ
         ULfg==
X-Gm-Message-State: APjAAAUBe97e8Xz0derGcwT+HjDVCyhDJMURuoEeRhnBPEwnSsHPmIpj
        xAxNfMo+dPd7fgZ+0s+EXKX8PvCKp/FkISYF/TKXoIhRR1L+w1ERnt7vM9Y9BYeH4UNNmO90Yjj
        4s8qDLlWmQgdJ
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr8175481wmc.113.1573733550542;
        Thu, 14 Nov 2019 04:12:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNdXww1bYBQYn6ucuPbLpCLv584anjwuql/H7HXTh/H7RPDbyU0VH3+jG0ORcEyEHuPAtfVA==
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr8175443wmc.113.1573733550212;
        Thu, 14 Nov 2019 04:12:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id u203sm5877284wme.34.2019.11.14.04.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 04:12:29 -0800 (PST)
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when
 CONFIG_KVM_COMPAT=n
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20191113160523.16130-1-maz@kernel.org>
 <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
 <CAFEAcA8c3ePLXRa_-G0jPgMVVrFHaN1Qn3qRf-WShPXmNXX6Ug@mail.gmail.com>
 <20191114081550.3c6a7a47@why>
 <5576baca-458e-3206-bdc5-5fb8da00cf6d@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com>
Date:   Thu, 14 Nov 2019 13:12:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5576baca-458e-3206-bdc5-5fb8da00cf6d@de.ibm.com>
Content-Language: en-US
X-MC-Unique: BWNWmG3UMc20_qXBNB0q6Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 09:20, Christian Borntraeger wrote:
>=20
>=20
> On 14.11.19 09:15, Marc Zyngier wrote:
>> On Wed, 13 Nov 2019 21:23:07 +0000
>> Peter Maydell <peter.maydell@linaro.org> wrote:
>>
>>> On Wed, 13 Nov 2019 at 18:44, Christian Borntraeger
>>> <borntraeger@de.ibm.com> wrote:
>>>> On 13.11.19 17:05, Marc Zyngier wrote: =20
>>>>> On a system without KVM_COMPAT, we prevent IOCTLs from being issued
>>>>> by a compat task. Although this prevents most silly things from
>>>>> happening, it can still confuse a 32bit userspace that is able
>>>>> to open the kvm device (the qemu test suite seems to be pretty
>>>>> mad with this behaviour).
>>>>>
>>>>> Take a more radical approach and return a -ENODEV to the compat
>>>>> task. =20
>>>
>>>> Do we still need compat_ioctl if open never succeeds? =20
>>>
>>> I wondered about that, but presumably you could use
>>> fd-passing, or just inheriting open fds across exec(),
>>> to open the fd in a 64-bit process and then hand it off
>>> to a 32-bit process to call the ioctl with. (That's
>>> probably only something you'd do if you were
>>> deliberately playing silly games, of course, but
>>> preventing silly games is useful as it makes it
>>> easier to reason about kernel behaviour.)
>>
>> This was exactly my train of thoughts, which I should have made clear
>> in the commit log. Thanks Peter for reading my mind! ;-)
>=20
> Makes sense. Looks like this is already in kvm/master so we cannot improv=
e
> the commit message easily any more. Hopefully we will not forget :-)

A comment in the code would probably be better than the commit message,
to not forget stuff like this.  (Hint! :))

Paolo

