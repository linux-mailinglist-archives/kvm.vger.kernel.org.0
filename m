Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30EFD9F9
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKOJxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:53:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727171AbfKOJxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 04:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573811632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=VfPhzc/maEXZzvkDf06ywFkFZv+/n3R0swKHKSpHAlc=;
        b=LI18gV9/NsY0yIKVj3V/x2UbHNFfjvohVqX8wui8uMEzlqZa97EebprCmGRCMIfmcvH6Yi
        O5hJFDSKxXdCabQDvyzznTafKL9jIuScMqHRTIq/Zhc4iqDZACVojW36jkFFH1OPOH5BRF
        GvG7y2nBjbuJ+IlL8R0V7SF4y7pwdgE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-ZYj0up1rMpuUTGBZY4gYNQ-1; Fri, 15 Nov 2019 04:53:51 -0500
Received: by mail-wr1-f69.google.com with SMTP id y1so7427077wrl.0
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 01:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eymq3b7ydcIM89h37n65cChs3UWTbSxzDMk310xy+30=;
        b=RnNXcXOYVh6UeBsDEEU3zlJZy5Uaht1eRgqASvJ/WJYqwOLMKSLK8aRX26dplHtbqn
         AocordMhPQ7qBtGbmD1N+AJFjxwQP+cfLTjKj1r7No7d3VnJQ8rN/hcb9ncFvi4k7Zo+
         mdD/vy7CoexcLnkY9hNBVAczyr52mu038FwcU746uH/UzMs67DR862dk1K64wgvUE4a5
         5ZX2bKLAEtj9dDDd4GhlBqsHmApD6DzNHq2f6T6DUgYqYnkP7qoDW9GJblovw3bm2TS7
         sAVh+0tszl2nILOKhojvEamMI3PD+MKSjfdZmbxewnw48WgoZhVt6sIhDaQDsUReImaK
         1x9A==
X-Gm-Message-State: APjAAAUDE9dGw+7o0tBJY452MwGl3Nazjrur6AoqVYYLXsIZe43lkXRb
        JQcpb6pfozwlZwqZxBewubEv9HF6nmbaL7DqVgb/1oFNAp2yT5M1FOTY1TOvyFZWOxAUSnJnaKY
        rASkunErOv2kw
X-Received: by 2002:a1c:5415:: with SMTP id i21mr14132779wmb.120.1573811628612;
        Fri, 15 Nov 2019 01:53:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyec7Jfx96MkL1zPAgkrylroOMA35Po9TtmFR6CgMEl2oS5u/guWUnBBsycEqcw5mzWPv0AhQ==
X-Received: by 2002:a1c:5415:: with SMTP id i21mr14132745wmb.120.1573811628336;
        Fri, 15 Nov 2019 01:53:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id q5sm8696065wmc.27.2019.11.15.01.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 01:53:47 -0800 (PST)
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when
 CONFIG_KVM_COMPAT=n
To:     Peter Maydell <peter.maydell@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm-devel <kvm@vger.kernel.org>,
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
 <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com>
 <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
 <CAFEAcA92a0t7p+gmHn9d5FU0_hiG2BvGN79uCzjAkFwVd8LqOQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e5314617-e490-02d2-3e80-c6d9ee6eb3cb@redhat.com>
Date:   Fri, 15 Nov 2019 10:53:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA92a0t7p+gmHn9d5FU0_hiG2BvGN79uCzjAkFwVd8LqOQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: ZYj0up1rMpuUTGBZY4gYNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 14:28, Peter Maydell wrote:
> On Thu, 14 Nov 2019 at 13:22, Marc Zyngier <maz@kernel.org> wrote:
>>  From 34bfc68752253c3da3e59072b137d1a4a85bc005 Mon Sep 17 00:00:00 2001
>>  From: Marc Zyngier <maz@kernel.org>
>> Date: Thu, 14 Nov 2019 13:17:39 +0000
>> Subject: [PATCH] KVM: Add a comment describing the /dev/kvm no_compat
>> handling
>>
>> Add a comment explaining the rational behind having both
>=20
> "rationale". (Isn't English spelling wonderful?)

Oops, noted this only after sending the pull request.

Thanks,

Paolo

>> no_compat open and ioctl callbacks to fend off compat tasks.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>=20
> thanks
> -- PMM
>=20

