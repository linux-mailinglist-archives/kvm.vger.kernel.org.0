Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528184A6E2B
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 10:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbiBBJxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 04:53:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231217AbiBBJw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 04:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643795578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJYm0PPuSG5P58MkxPI9TQ7TBw2y3cTWuDQw+JeYdYw=;
        b=EtZu8DeTc666Qq5QyJfzqpPnS6xd1vHTWiKsocZQgPOMBD+RuntzGrZ1kWIiETJ7N5U9As
        Em6AnLHGr5Pe26Bzp4yBe0NcOUCOaq17aGv3j2w1WDqa1UWAWCCaDRjkfco+RsClQhrQup
        PqnnWcESTQZM8lnY/RgtixRCSrNZeVA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-k2LJcKlMOpKuVeQITGfR2g-1; Wed, 02 Feb 2022 04:52:57 -0500
X-MC-Unique: k2LJcKlMOpKuVeQITGfR2g-1
Received: by mail-ej1-f70.google.com with SMTP id m4-20020a170906160400b006be3f85906eso1979476ejd.23
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 01:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FJYm0PPuSG5P58MkxPI9TQ7TBw2y3cTWuDQw+JeYdYw=;
        b=Uf/eDJwbCoZexu6gYKu5bwH8wzR9bTtQVAkWKO3a7CDMAOy3SEhe7yX2D7dcjqNH3M
         8uYuDFfRrR5Zg7y5D8YyTv6zZ8MmrEpUiMdiXoRybJG0MOn5KZrDZ6FcprhHJNaw6c7v
         1+Ngg6SE8UBOX07BgcQzbUS4pb2gh/NBD9xTqG0SzisO6yeM1PYrmXUy6/erSGt6IP7/
         /i604SlagojrdQ0ddQ/ht25jRb3n2z1VhXOGXcl9F+kUNRb5ipWOOlX7T5FIBDRl6FRe
         ZZWoc4/PIEkmEfHi9/S/5DVRWYDTVHM5lvAN8oFyhwCf/OBq4JuRQN+ynQnA+HtsqodH
         ahkA==
X-Gm-Message-State: AOAM531AGr2PSAAK9zgTho7tdNnMNF6rNFcACyja9jpBQsGSmrC6Nfwn
        AffkkEo6z4lwjKVsKG0NfWKIp+6S0VOxIyuwG1X0xIwK3UD7GpAlz1HtzprKMKQX5eEueiQhrzy
        nGdK5T9v1tA0F
X-Received: by 2002:a17:906:2e8b:: with SMTP id o11mr24527493eji.241.1643795576724;
        Wed, 02 Feb 2022 01:52:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5VEKcGjjuFf8IKMzODHl6ryi4f2cI9jzsIHgMrjlJYrW0OM0f6beiwbK4bDQ9FfeMUIgxjQ==
X-Received: by 2002:a17:906:2e8b:: with SMTP id o11mr24527474eji.241.1643795576522;
        Wed, 02 Feb 2022 01:52:56 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id dn22sm4575465edb.80.2022.02.02.01.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 01:52:56 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap
 for Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
In-Reply-To: <ebd368c8-5c2a-dc5b-203f-f058f68b7825@redhat.com>
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <35f06589-d300-c356-dc17-2c021ac97281@redhat.com>
 <87sft2bqup.fsf@redhat.com>
 <66bcd1bf-0df4-8f02-9c0d-f71cecef71f4@redhat.com>
 <87o83qbehk.fsf@redhat.com>
 <ebd368c8-5c2a-dc5b-203f-f058f68b7825@redhat.com>
Date:   Wed, 02 Feb 2022 10:52:55 +0100
Message-ID: <87leytbnns.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 2/1/22 19:58, Vitaly Kuznetsov wrote:
>>> Hmm, it fails to compile with CONFIG_HYPERV disabled, and a trivial
>>> #if also fails due to an unused goto label.  Does this look good to you?
>>>
>> Hm, it does but honestly I did not anticipate this dependency --
>> CONFIG_HYPERV is needed for KVM-on-Hyper-V but this feature is for
>> Hyper-V-on-KVM. Let me take a look tomorrow.
>> 
>
> It's because, without it, the relevant structs are not defined by 
> svm_onhyperv.h.  Go ahead and send a new version if you prefer

Should be fixed in v2. I still think it makes sense to keep this
KVM-on-Hyper-V and Hyper-V-on-KVM separation as it's really confusing to
an unprepared reader. There's still room for improvement in nVMX I
believe but it's orthogonal to this nSVM feature.

-- 
Vitaly

