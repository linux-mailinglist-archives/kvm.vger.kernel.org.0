Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35569487469
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 10:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346312AbiAGJCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 04:02:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236362AbiAGJCx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 04:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641546172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJchP5kOngEUoTXC4a4FHodWajBGnUqSRJ+6FN2eEDs=;
        b=UARAXL2MDoL12Oa9dzG96D49+6gCb3aiBKuzzeVGR7Bd4Bm3oYoZp0hfbH8fVhz/rXQC2B
        zfan5zdPAKO4oybo84iB0RCgUHvQw5UqD/ecLt2SKqUvbIr5Pa3+BRhZ90AGG/kKKbDRBZ
        5Y2WhUIRj1Vflld0rE7WeMr0If9wOKo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-dfyhX3uvPauxhFs6a0VmDg-1; Fri, 07 Jan 2022 04:02:51 -0500
X-MC-Unique: dfyhX3uvPauxhFs6a0VmDg-1
Received: by mail-wm1-f72.google.com with SMTP id r65-20020a1c4444000000b003478a458f01so901969wma.4
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 01:02:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CJchP5kOngEUoTXC4a4FHodWajBGnUqSRJ+6FN2eEDs=;
        b=hZkhtMyiLTmQd1IqEExKyTnnwpDp0OMR+W9T8vSpuGF9GylSGP+amOu0vJudI38U6V
         bEm9HPWsk9NW1J8Bz9xFAjKM8mCTA8JCU6VJoWsyv1EFDqrORJpPkEyjemPs4qdPCVU7
         gsq6e9aZgtSw4WwfTbfUk9TkNMLLxg2TSgEn6/KySBcmQ+hgRWUFsyzizl+Am50mtr/n
         5d/U39N+KcyUTVgwDW35zrwIAWSCnN/0YO5lsIWSt3RJ3bOkPuMmJZEtkor4pvYVvwNT
         d7ga+tHZRGuBeqjp+0qIkw33ZCiXFXKW3T/IOb+b8Rjt0emiY4mCBlP6b2lSD0uQmtHu
         tRuA==
X-Gm-Message-State: AOAM531fQHIM+LFjouG7/mcvLtv6yIPOs0xjahaDqF6rc6cP7iVEyem3
        Z2Z2W/3XyFRnh2Y8uD0vCi4MhsfaDg0VUlHY3Ge9BaevROGHZx4i1n9OJcp1IgsCsF/bk36M7H3
        r56W8axr9wS8M
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr54674601wri.616.1641546170584;
        Fri, 07 Jan 2022 01:02:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUgmSz+l/wRVwxeLTLElb+dNEm/Bi1KmSXD60E+b+hiSO3aMTKaLSf5ws/BZMiISGTJPusOQ==
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr54674587wri.616.1641546170411;
        Fri, 07 Jan 2022 01:02:50 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y11sm4159245wrp.86.2022.01.07.01.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 01:02:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <87o84qpk7d.fsf@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
 <87o84qpk7d.fsf@redhat.com>
Date:   Fri, 07 Jan 2022 10:02:49 +0100
Message-ID: <877dbbq5om.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> On 1/3/22 13:56, Vitaly Kuznetsov wrote:
>>>   'allowlist' of things which can change (and put
>>> *APICids there) and only fail KVM_SET_CPUID{,2} when we see something
>>> else changing.
>>
>> We could also go the other way and only deny changes that result in 
>> changed CPU caps.  That should be easier to implement since we have 
>> already a mapping from CPU capability words to CPUID leaves and registers.
>>
>
> Good idea, I'll look into it (if noone beats me to it).

(just getting to it)

On the other hand, e.g. MAXPHYADDR (CPUID 0x80000008.EAX) is not a CPU
cap but it's one of the main reasons why we want to forbid
KVM_SET_CPUID{,2} after KVM_RUN in the first place. I'm also not sure
about allowing PV feature bits changes (KVM, Hyper-V, Xen) and I don't
think there's a need for that.

I'm again leaning towards an allowlist and currently I see only two
candidates:

CPUID.01H.EBX bits 31:24 (initial LAPIC id)
CPUID.0BH.EDX (x2APIC id)

Anything else I'm missing?

-- 
Vitaly

