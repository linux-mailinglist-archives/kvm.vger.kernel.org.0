Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8761B490920
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 14:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbiAQNCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 08:02:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42117 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229563AbiAQNCf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 08:02:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642424554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AmxLgMKtM2xp64rnq5p7GdtgJriOCMkjmIrcQ5U3IJY=;
        b=XPNJvkIl9PsohOH9aUUxHI0QJCDWaqTiv0hlNp4376duwoV7qWI3/wWlOHR6ou5Ox3/adE
        1Qtj06Ghi1eINq7BiUKkJ3IpXv4EKVKH7W0mwDfpbE5VJRAu60NuGZy2GoHhxFkCRvqLC8
        UzfOoFLZWMP5qF/zbhx2NOSCkd55IEw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-hBRaWyO1M3SWxDv66jrOuQ-1; Mon, 17 Jan 2022 08:02:33 -0500
X-MC-Unique: hBRaWyO1M3SWxDv66jrOuQ-1
Received: by mail-wm1-f71.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso11260734wmq.6
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 05:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AmxLgMKtM2xp64rnq5p7GdtgJriOCMkjmIrcQ5U3IJY=;
        b=1azJz0sPsmCAeerA1fHUGl0oDha5gn7iLXw+HuRkHZnpDxZosC3vEVRYpiLLjYTBnK
         x8T5yitQPnk8tX9p34C8DDMlTwPp0+iszPoawTfVAAzP7SvDACryfAvj9Qr5w2k5zLK8
         R4FyFEGTU1bIoZ2QKZ0tnMcGqbEpdFcComzu0SaoFMISVbGEqp4mVp0eFu7uhpAo7ZVS
         fR+DBBwDEjeguRUeI+SGFoeO/+r3qBdZa6xU03yeQ3OtKgCTfi5EdWfEuEKH8UMuev3S
         in28lEQeVguBoeuhTs9XvFoSVRh9Cd8LUgsYWDAj5Tp0K2TC7WvBwfnrLnFbY60AKxGJ
         b8iA==
X-Gm-Message-State: AOAM533OZ8vL8LqzakUFdrN2QXc3mjg/V7hpAdpeVK4IuETOE6ZwlADo
        da49+fM1+ob9XeJoMqjeP2+3GDcAwodSfoepngwA3E2s7zLZak6rAAndXZ4GDkUCMIkc5XLMmac
        pQDhVcz9SGR8o
X-Received: by 2002:a5d:5147:: with SMTP id u7mr13730985wrt.687.1642424552696;
        Mon, 17 Jan 2022 05:02:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5gUyIT+6hmx9at0BIXTQZgqi8LBV9qiFylH3MqPMb8FTU5HuKtAntofElkn6GwInqCUKmTw==
X-Received: by 2002:a5d:5147:: with SMTP id u7mr13730964wrt.687.1642424552481;
        Mon, 17 Jan 2022 05:02:32 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id az29sm9867067wmb.31.2022.01.17.05.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 05:02:31 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <517e8b95-e336-8796-6657-c0f8d554143a@redhat.com>
References: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com> <20220114095535.0f498707@redhat.com>
 <87ilummznd.fsf@redhat.com> <20220114122237.54fa8c91@redhat.com>
 <87ee5amrmh.fsf@redhat.com> <YeGsKslt7hbhQZPk@google.com>
 <8735lmn0t1.fsf@redhat.com>
 <517e8b95-e336-8796-6657-c0f8d554143a@redhat.com>
Date:   Mon, 17 Jan 2022 14:02:31 +0100
Message-ID: <87zgnuldlk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/17/22 10:55, Vitaly Kuznetsov wrote:
>> No, honestly I was thinking about something much simpler: instead of
>> forbidding KVM_SET_CPUID{,2} after KVM_RUN completely (what we have now
>> in 5.16), we only forbid to change certain data which we know breaks
>> some assumptions in MMU, from the comment:
>> "
>>           * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
>>           * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
>>           * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
>>           * faults due to reusing SPs/SPTEs.
>> "
>> It seems that CPU hotplug path doesn't need to change these so we don't
>> need an opt-in/opt-out, we can just forbid changing certain things for
>> the time being. Alternatively, we can silently ignore such changes but I
>> don't quite like it because it would mask bugs in VMMs.
>
> I think the version that only allows exactly the same CPUID is the best, 
> as it leaves less room for future bugs.
>

Ok, I hear your vote) Will prepare v2.

-- 
Vitaly

