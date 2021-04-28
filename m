Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E337B36E114
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 23:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhD1Vmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 17:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhD1Vmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 17:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619646112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/v4ZNp/t+nbs+oINjnStizm6FqJH+orku1bF/7PUqww=;
        b=cMwvXnfUr57c68LBeuVokSii1kuu3N3j8L9JOpzAY9VkAhzxj4j5tdV/s59pO14lwcCex6
        uiO6Tx+EoX7qETbXpxuNTiRvAVqehutwsIPH3TM2pbdSkzjYmSGgKJVYJkOim9G95v3t0K
        0ta+j8eSEtsphFIZQysA4cSpX0ODyXc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-5300reXqOhuEH-YAtLP-iw-1; Wed, 28 Apr 2021 17:41:50 -0400
X-MC-Unique: 5300reXqOhuEH-YAtLP-iw-1
Received: by mail-ej1-f72.google.com with SMTP id s23-20020a1709069617b02903907023c7c0so2541789ejx.0
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 14:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/v4ZNp/t+nbs+oINjnStizm6FqJH+orku1bF/7PUqww=;
        b=kRisU9DEAwR0AD+EwhBz1IQA8SDhrZu4hpEnGEZ/wlQIzubg91E9HDXDWZKHHyksLC
         fv9lwdPxJ8ir0hpP3tacKqfqdxsrQzMcZSZ4oTHBDZCPuLCbh/Lwx+S9jfhXkDT0gGIS
         x9EhDsS9i784rC49MNKkSk44lmBAAit5BgMRFbWa5BL2rdx7R2gVThEQiiLZ5QyoQ+s4
         XkPsSwf4+nnRV+CHiodKhvrIbItBHbpz9upNZIxUwWWa2srLz+4lZ+wYAEXa2MNYqzN8
         oxTuKED/o/Or22jqR92zMX0khqg/fMSxv9mn6VqqZi7711BfMavEglEiDQgQ1KBzshMH
         sbjA==
X-Gm-Message-State: AOAM533u2QDOxvODr183yOc9Uj62m23n/fauD2IiEjh/OMOyg0HBxUkz
        0S3fO5F6FiXVKAWG3Ax1W0L9GLXywWLaP2FhLyLk8YbrnBlcy0pW3L85DLBooHH+NYIzcpngaYs
        QnKMb3hs9pMOK
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr14652845edu.90.1619646109792;
        Wed, 28 Apr 2021 14:41:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJeT8jZKUCPuU3YCSZ5nBJlLlCjlR3d1gsNbygte6vsS9V5m8sz6NcZ0dd5mK7qLGGSbQ64w==
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr14652829edu.90.1619646109630;
        Wed, 28 Apr 2021 14:41:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id z4sm734735edb.97.2021.04.28.14.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 14:41:48 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com>
 <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
 <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
Message-ID: <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
Date:   Wed, 28 Apr 2021 23:41:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 22:40, Ben Gardon wrote:
> ... However with the locking you propose below, we might still run
> into issues on a move or delete, which would mean we'd still need the
> separate memory allocation for the rmaps array. Or we do some
> shenanigans where we try to copy the rmap pointers from the other set
> of memslots.

If that's (almost) as easy as passing old to 
kvm_arch_prepare_memory_region, that would be totally okay.

> My only worry is the latency this could add to a nested VM launch, but
> it seems pretty unlikely that that would be frequently coinciding with
> a memslot change in practice.

Right, memslot changes in practice occur only at boot and on hotplug. 
If that was a problem we could always make the allocation state 
off/in-progress/on, allowing to check the allocation state out of the 
lock.  This would only potentially slow down the first nested VM launch.

Paolo

