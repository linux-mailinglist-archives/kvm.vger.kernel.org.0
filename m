Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6B3B1B2D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFWNeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:34:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230449AbhFWNea (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624455131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NauHAI0CHbhsa2fGusxRfVa5/FAzeCMJVSm7zm9WPEI=;
        b=PJtkOEjmSFK/nbHjZE+SaVqIUPR0KnMjkd8idKMf7l4lKLO4xH33U606E9T1uvCpAdPNe0
        Kt7mhFtvR83eBMqkf2xyxnexqOTd7tnw3ZRtK9cjKa4wa0OHAbTV1A5eA7DWVdIFj8zRUo
        a5m7azRfSzxznl0R6yOcyBrXa+SQQHU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-wEY7kf5mP4CC0K2oxeTRdw-1; Wed, 23 Jun 2021 09:32:10 -0400
X-MC-Unique: wEY7kf5mP4CC0K2oxeTRdw-1
Received: by mail-ej1-f71.google.com with SMTP id ho42-20020a1709070eaab02904a77ea3380eso992727ejc.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 06:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NauHAI0CHbhsa2fGusxRfVa5/FAzeCMJVSm7zm9WPEI=;
        b=oGwM6FcUByJwT19vL52rnLFBqIuFOw2QbfbkX6ynmvSmbLh2wE+yOle2+gVGwdQ1lu
         JfmNVSQLx7ZBl4esk5dKO2ybKmOpLVMFBEVbmNZLPuDXfADEa92mq7sETWKsGOc78YBZ
         JcoGWDfTRucNI6C4yrzdX9m6TRAQ26yXEyvivblu0oJpuAwQtQtsJi68f0P5HGpDpdIn
         SkvzXBQxLKpoa9AFuCl669l6+cQiPqOixJ1POHcdCq3s30McuaPX38tbTSZaOW5EE6sD
         KaA55Hob3+NNz2qUqb7iqLGiYb04xPV4IDToWxqc/u10w8IeGfy/EJUU0Yler71zp1jh
         4f7A==
X-Gm-Message-State: AOAM531QEm+ZLQA9YqINeTIPY0kqr/cZ7V4hQuYujlmA8PEbYHoXm4GS
        +9u5n0JuFBajaxqM5EsueW/soTkH5FDcsNBrqKkr7QQICKtUeIb+x4bc/cxCEwU0KvlTnQjwrsK
        ogRiXG4mYJXuGmq+toeSnvVujEF55KjJKcvwo6aQhBBzpOwB60sxKsPqY+304I6qO
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr12403190edd.71.1624455129162;
        Wed, 23 Jun 2021 06:32:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCxfF2up/YZIVS08yHiIq6GoxMXVkJxXwH+FOJDnRGGAPn2YQd1WvYES2tGXE+a/KsBItaoQ==
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr12403149edd.71.1624455128934;
        Wed, 23 Jun 2021 06:32:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o20sm34087eds.20.2021.06.23.06.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 06:32:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
In-Reply-To: <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
 <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
Date:   Wed, 23 Jun 2021 15:32:07 +0200
Message-ID: <87pmwc4sh4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2021-06-23 at 16:01 +0300, Maxim Levitsky wrote:
>> On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
>> > On 23/06/21 09:44, Vitaly Kuznetsov wrote:
>> > > - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
>> > > is that smart. Also, we don't even seem to check that L1 set it up upon
>> > > nested VMRUN so hypervisors which don't do that may remain broken. A very
>> > > much needed selftest is also missing.
>> > 
>> > It's certainly a bit weird, but I guess it counts as smart too.  It 
>> > needs a few more comments, but I think it's a good solution.
>> > 
>> > One could delay the backwards memcpy until vmexit time, but that would 
>> > require a new flag so it's not worth it for what is a pretty rare and 
>> > already expensive case.
>> > 
>> > Paolo
>> > 
>> 
>> Hi!
>> 
>> I did some homework on this now and I would like to share few my thoughts on this:
>> 
>> First of all my attention caught the way we intercept the #SMI
>> (this isn't 100% related to the bug but still worth talking about IMHO)
>> 
>> A. Bare metal: Looks like SVM allows to intercept SMI, with SVM_EXIT_SMI, 
>>  with an intention of then entering the BIOS SMM handler manually using the SMM_CTL msr.
>>  On bare metal we do set the INTERCEPT_SMI but we emulate the exit as a nop.
>>  I guess on bare metal there are some undocumented bits that BIOS set which
>>  make the CPU to ignore that SMI intercept and still take the #SMI handler,
>>  normally but I wonder if we could still break some motherboard
>>  code due to that.
>> 
>> 
>> B. Nested: If #SMI is intercepted, then it causes nested VMEXIT.
>>  Since KVM does enable SMI intercept, when it runs nested it means that all SMIs 
>>  that nested KVM gets are emulated as NOP, and L1's SMI handler is not run.
>> 
>> 
>> About the issue that was fixed in this patch. Let me try to understand how
>> it would work on bare metal:
>> 
>> 1. A guest is entered. Host state is saved to VM_HSAVE_PA area (or stashed somewhere
>>   in the CPU)
>> 
>> 2. #SMI (without intercept) happens
>> 
>> 3. CPU has to exit SVM, and start running the host SMI handler, it loads the SMM
>>     state without touching the VM_HSAVE_PA runs the SMI handler, then once it RSMs,
>>     it restores the guest state from SMM area and continues the guest
>> 
>> 4. Once a normal VMexit happens, the host state is restored from VM_HSAVE_PA
>> 
>> So host state indeed can't be saved to VMC01.
>> 
>> I to be honest think would prefer not to use the L1's hsave area but rather add back our
>> 'hsave' in KVM and store there the L1 host state on the nested entry always.
>> 
>> This way we will avoid touching the vmcb01 at all and both solve the issue and 
>> reduce code complexity.
>> (copying of L1 host state to what basically is L1 guest state area and back
>> even has a comment to explain why it (was) possible to do so.
>> (before you discovered that this doesn't work with SMM).
>
> I need more coffee today. The comment is somwhat wrong actually.
> When L1 switches to L2, then its HSAVE area is L1 guest state, but
> but L1 is a "host" vs L2, so it is host state.
> The copying is more between kvm's register cache and the vmcb.
>
> So maybe backing it up as this patch does is the best solution yet.
> I will take more in depth look at this soon.

We can resurrect 'hsave' and keep it internally indeed but to make this
migratable, we'd have to add it to the nested state acquired through
svm_get_nested_state(). Using L1's HSAVE area (ponted to by
MSR_VM_HSAVE_PA) avoids that as we have everything in L1's memory. And,
as far as I understand, we comply with the spec as 1) L1 has to set it
up and 2) L1 is not supposed to expect any particular format there, it's
completely volatile.

-- 
Vitaly

