Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C221C782D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 19:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgEFRnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 13:43:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728049AbgEFRnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 13:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588786990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhdwUniA0k/r3WuJ+qaLEpoMFa2i+Z0K0lrLkgzyvNU=;
        b=Wp8YWI5gJwtjerxjsil65sf51CrvhbJYGh7zMeesYcgBuKU045fNq8n4IMDFxrVImHe6Lw
        A1LAJvii7Txuzd6WIq9hQS66G17sHixdKlsf11NsVvE9o5sqJD/hyggKWuEFO0RoKVgg/k
        dhaIJWl2uCm6MalqoNQv/2X65yRIOyM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-aio_gNv0O9i1JpSq0IGusA-1; Wed, 06 May 2020 13:43:09 -0400
X-MC-Unique: aio_gNv0O9i1JpSq0IGusA-1
Received: by mail-wr1-f71.google.com with SMTP id o6so1714694wrn.0
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 10:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UhdwUniA0k/r3WuJ+qaLEpoMFa2i+Z0K0lrLkgzyvNU=;
        b=CNedaHr18kqlq8klYBSKBPw8ck/+YP1155llOZBxHGHOnUosJWVU4f2TSIgvXFEHMT
         fQs0DaqJX3Ji/PUgBKC4m17LuwfLzAfi0ZxW/LWFO7EV1tEhPWxFkoVlrBAI95Dmv2jT
         cWKeZpyDr4qITtXaqg2nHBKcvaNqC7l/MBy7PoBUmBYBjf+J4hKvzk+SJyHtwg9GF5Tg
         bJD4liMN3HFwD8QvbgnTO/ttCnFNuZdNphQ6TVTGBcdep04VScwt4b/h6sHizf5roEmK
         MOJ5U5XPGrrBmgGPnwjbiEZV326sKa//qaBpvo73RyNItqHMxaG9SI8y1EbgFFztBbNn
         Cozw==
X-Gm-Message-State: AGi0PuYysmdVeFR811AmIZbYsSXCQHEFvIAYwY993w+q7H8hZNmhyd0s
        iUUymr7XataA82CidoPYZUf37m7eb++Oh+G5cYPAvDY3hXAvobEF1nQ9Eq1KXdD+JKA1s1Rc9NR
        yXDymjCMW/P39
X-Received: by 2002:a1c:6784:: with SMTP id b126mr1810444wmc.1.1588786985082;
        Wed, 06 May 2020 10:43:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypJgOdkBzfvecqbqWkHcYB4goeAu3qZSlDwzX3Js/XiQfCud1sAQ0kCPUY6u6dJj1iBnivDBIQ==
X-Received: by 2002:a1c:6784:: with SMTP id b126mr1810428wmc.1.1588786984789;
        Wed, 06 May 2020 10:43:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id n25sm4044272wmk.9.2020.05.06.10.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 10:43:04 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending
 interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20200505232201.923-1-oupton@google.com>
 <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
 <20200506152555.GA3329@linux.intel.com>
 <1f91d445-c3f3-fe35-3d65-0b7e0a6ff699@redhat.com>
 <20200506164856.GE3329@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1504a56e-4ccf-b000-ea9d-4c029c42eff2@redhat.com>
Date:   Wed, 6 May 2020 19:43:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506164856.GE3329@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 18:48, Sean Christopherson wrote:
>>
>> Can you think of something that can go wrong if we just move all
>> requests, except for KVM_REQ_EVENT, up from vcpu_enter_guest() to
>> vcpu_run()?  That might be more or less as ad hoc as Oliver's patch, but
>> without the code duplication at least.
> I believe the kvm_hv_has_stimer_pending() check in kvm_vcpu_has_events()
> will get messed up, e.g. handling KVM_REQ_HV_STIMER will clear the pending
> bit.  No idea if that can interact with HLT though.

That wouldn't be a problem, because you'd get out of HLT if needed via
stimer_expiration (and then stimer_notify_direct->kvm_apic_set_irq or
stimer_send_msg->synic_deliver_msg->synic_set_irq->kvm_irq_delivery_to_apic)
which is called from kvm_hv_process_stimers.

Paolo

