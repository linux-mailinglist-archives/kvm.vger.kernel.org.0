Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8AC434A91
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhJTLzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhJTLzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 07:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634730778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=md6wseW4nKv43qwTyrvUKbOKTU4WhQgMwCNTnn5vDB0=;
        b=KL7xG0+sF12p3fynk9CEk/gTIZGvm2NpU5H0DangBe0aXoVhHuc9YiICIz69XEhXGN7OMo
        s7Yd2DjGq3T8peWRcAkYXUgJNZBMPThIPW2pGjgSpLt6rHica6WGsZ3bksu5+Tss2X+MQC
        36TL0MH5WuUvsISQwn8KQAaCu352lB4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-v9nCYp_xOc6zZCfSNImlFg-1; Wed, 20 Oct 2021 07:52:57 -0400
X-MC-Unique: v9nCYp_xOc6zZCfSNImlFg-1
Received: by mail-ed1-f72.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so14057293edj.21
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 04:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=md6wseW4nKv43qwTyrvUKbOKTU4WhQgMwCNTnn5vDB0=;
        b=QUHfhl6pH7G3ke5W+zRSj0sSu/taNKALw/7xdfrA8verdtxQNQo6Iy+oN2dfeRpewf
         S/OsQ+pDo8D+cG9ryd4YToFvuJbxUeIuJNH9suJyHPjITPY9wLgj0kfrLrsLUZtv7gVq
         b497tRWVizlpzzJz7ytQnDW3PxZSfbIoiViQmZ1s3239Dxn/R1xD+PG7RAgrNfYVqHCI
         8qRl348/qn2ZTROHJd9wczXyzlMv3vCh5//AIhia8KwEbpI5EDzSa2G0XLdBnf4WptM2
         Jv5y4fr2XldXtsKP0lbPXTgUJHuYJ9/BVvP89VNG+FIRGXdOOgG0sTRpcUJ+NLVNAcjV
         kADA==
X-Gm-Message-State: AOAM531pvdAIOzsyPiFQTQwouBu+EY3bwd/1E13jBItyny0p4b4NaG/Y
        0PSaHuFGHrnTdqlNxf1+Zai5JWW9fxBpmV1aymTEjy0Iqz/3iRl1YVCsqOFo1K94hYXTvBqeuPG
        FD7qK+JzjRiNm
X-Received: by 2002:a05:6402:2682:: with SMTP id w2mr62050631edd.185.1634730776398;
        Wed, 20 Oct 2021 04:52:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEHlkY+zrUlsfZmGMYZ1ZdlpS11MY+5q8Tp6ouqm3u+9nV1VMgWWV08Y6PxiXXh5HnogMNMQ==
X-Received: by 2002:a05:6402:2682:: with SMTP id w2mr62050610edd.185.1634730776219;
        Wed, 20 Oct 2021 04:52:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j3sm942846ejo.2.2021.10.20.04.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 04:52:55 -0700 (PDT)
Message-ID: <98a72081-6a2b-b644-d029-edd03da84135@redhat.com>
Date:   Wed, 20 Oct 2021 13:52:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is
 needed
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20211020110638.797389-1-pbonzini@redhat.com>
 <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 13:17, Peter Zijlstra wrote:
> On Wed, Oct 20, 2021 at 07:06:38AM -0400, Paolo Bonzini wrote:
>> In some cases, rcuwait_wake_up can be called even if the actual likelihood
>> of a wakeup is very low.  If CONFIG_PREEMPT_RCU is active, the resulting
>> rcu_read_lock/rcu_read_unlock pair can be relatively expensive, and in
>> fact it is unnecessary when there is no w->task to keep alive: the
>> memory barrier before the read is what matters in order to avoid missed
>> wakeups.
>>
>> Therefore, do an early check of w->task right after the barrier, and skip
>> rcu_read_lock/rcu_read_unlock unless there is someone waiting for a wakeup.
>>
>> Running kvm-unit-test/vmexit.flat with APICv disabled, most interrupt
>> injection tests (tscdeadline*, self_ipi*, x2apic_self_ipi*) improve
>> by around 600 cpu cycles.
> 
> *how* ?!?
> 
> AFAICT, rcu_read_lock() for PREEMPT_RCU is:
> 
>    WRITE_ONCE(current->rcu_read_lock_nesting, READ_ONCE(current->rcu_read_lock_nesting) + 1);
>    barrier();
> 
> Paul?

Wanpeng, can you share your full .config?

Paolo

