Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C233D3DD
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhCPMaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 08:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231699AbhCPM3x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 08:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615897790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gkTTCBa5ii5g51WozdEnj/wZnvb/3VbtbUjq6fWySaU=;
        b=N0fECqCvVorqmh5ni5KPYGIhyqWj6YTa96XRqJmenG685VlZgNKrBfXqGOdVqjwdRqBctt
        r60LusAi23OEBlynX+bZEQJg55zgGavYowSK1hCzXanQQ8kn6t7p5RHeusBzgoNzEW+bi6
        ghvPR8qDaMCS1YxHLD7ySyScw/lMfNU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-Gh_FJVEMOZeg2etllbQS5A-1; Tue, 16 Mar 2021 08:29:48 -0400
X-MC-Unique: Gh_FJVEMOZeg2etllbQS5A-1
Received: by mail-ed1-f71.google.com with SMTP id i19so17611087edy.18
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 05:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gkTTCBa5ii5g51WozdEnj/wZnvb/3VbtbUjq6fWySaU=;
        b=uQNbyxm65hCc9QpFmVFXIY0VvjcByFg3WOUYBwTPUPydHk43EIeP9e4YvHaIj45arG
         f7bR+usGu3WHK+etfaxxb4ENrBSo7fTvbGM/kxH8uWeilAB/T7KxG41offTrBuMoIhEO
         GevBKcpLgQFh3riWJ8VmKlr2LjV9Xabf3PtX5fHjbEDKICybrWT+bVRQr83f8XNnRw+e
         7VXYWsDmMh2zCu67vN6sUp19WoCBwtOs3NMqgtdYAG07asiROF6Ckse/Vzgc1BFwDWzL
         I/TNw5XYeoJQcxvzDAMc8ptVqAx2oNfOcHg5IUXQBn01ZIrbP4WvZJJzb9AQUuUbwqih
         4WuQ==
X-Gm-Message-State: AOAM533On7vUscE81msba68xtVu24O4SZ8FFcWXV4hsj7H0q1W6K32C1
        EwTo9xfEmo5005WuFXVTzWHbmHnHVK6R0F0AOM19cGzJbVfNLL8xn5TwaAB2J+gh1kOmI+FCLU1
        oFVEGw4FVz8rX
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr28990861ejf.431.1615897787597;
        Tue, 16 Mar 2021 05:29:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvpd5gXHLNVGtG4X6/v4l4vPq20TXSDgA5kMPTfbxhChTW32Ck9Jyq03xxhcLiRNwOiEJWxw==
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr28990845ejf.431.1615897787429;
        Tue, 16 Mar 2021 05:29:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gb22sm980558ejc.78.2021.03.16.05.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 05:29:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
In-Reply-To: <92bccdca-b6bb-5c09-c5a1-5c75e5a3887d@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-3-vkuznets@redhat.com>
 <6b392d7e-8135-53a9-9040-f6f5e316c6cb@redhat.com>
 <87im5s8l9g.fsf@vitty.brq.redhat.com>
 <92bccdca-b6bb-5c09-c5a1-5c75e5a3887d@redhat.com>
Date:   Tue, 16 Mar 2021 13:29:46 +0100
Message-ID: <877dm78eo5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 15/03/21 16:55, Vitaly Kuznetsov wrote:
>>> I think we should instead write 0 to the page in kvm_gen_update_masterclock.
>>
>> We can do that but we will also need to invalidate
>> hv->tsc_ref.tsc_sequence to prevent MSR based clocksource
>> (HV_X64_MSR_TIME_REF_COUNT -> get_time_ref_counter()) from using stale
>> hv->tsc_ref.tsc_scale/tsc_offset values (in case we had them
>> calculated).
>
> Yes, we're talking about the same thing (invalidating tsc_sequence is 
> done by writing 0 to it).
>

Yes, 'hv->tsc_ref' is a 'shadow TSC page' which almost always caches
what's in the 'real' one. One notable exception is that after migration
our cache is out of sync until the first successful
kvm_hv_setup_tsc_page() call.

What I was trying to say is that we not only need to write '0' to the
'real' TSC page but also invalidate our internal 'hv->tsc_ref'. Anyway,
I think we're in a violent agreement here, v2 is coming with this change
after I'm done testing it.

Thanks!

> Paolo
>
>> Also, we can't really disable TSC page for nested scenario when guest
>> opted for reenlightenment (PATCH4) but we're not going to update the
>> page anyway so there's not much different.
>> 
>

-- 
Vitaly

