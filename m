Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73A34F8C7
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhCaGaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 02:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232805AbhCaG3s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 02:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617172188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KsBkRz/pehE5Lrr3mHu0jJhAfh1UXjetDU1Y6wyJ97E=;
        b=UgKKJUxHDMdW7xEG635Pcaw/cciJeSD4CDJlHYTfAS5v40POXuI2rg7IFmS8JOG5jh7EPm
        lpr+9FQ8EHS4LBlMdaS0BDqBTMorH2PrZMZESBLh4pZuT2H4lr7CvF8L0Ek25pPHAUKwBm
        ZCE1aDbBtSDXRkTxZ2pgifEpT8TmyvA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-0KdozZrROKiP3Ji2M-Vspg-1; Wed, 31 Mar 2021 02:29:46 -0400
X-MC-Unique: 0KdozZrROKiP3Ji2M-Vspg-1
Received: by mail-ed1-f69.google.com with SMTP id bm8so573410edb.4
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 23:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KsBkRz/pehE5Lrr3mHu0jJhAfh1UXjetDU1Y6wyJ97E=;
        b=t9g3V4/+ID+M+9L8zOZiWm+G+HW+BhOE0CGUUSe7WrcmNtuA0iY7N/r39ehI6YETXO
         214e3/Vk3bRUROmmIXqEkruYSXd6u5KcC07zx5dYIxGMk1zrVfnwIrpSHm5nfxXpmMb4
         CUlA0tDyprGdaKt/C/YZjkd5BKYv9YebiG60/UZsvz3mNNr/0Jx3cVNeR5KDR2y4yc81
         Rc16CkLwKr7qWTMY/c9ZkpmL93yjeCKuZcU/sSsf/UAAjOvPs9kDMWqiFXdm77EHt2sF
         acEnvHxI/+2M3YlQHP9lEWFx9ukVcuImMMsgV6SF6KqDkLwPQPMfUilZNqfK1N9l3+y3
         8NqA==
X-Gm-Message-State: AOAM533sdFLA/iUUCjsfj5g9+++2vrn49Gen/Poy8dAaoe5pH6V6sLz3
        DvGcQPlSB+ZunSgnIJjZ+9FweJyG7saBCb1Az9AchbPgsgWedrbLxly4wPRtdp869rigSbaVBhv
        TCjCkLUqjcEuj
X-Received: by 2002:a17:906:2ac1:: with SMTP id m1mr1855426eje.472.1617172185000;
        Tue, 30 Mar 2021 23:29:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzE+Fgj7SYZNfyH5TFY8mu0yKgA/ECBrO+uxDJZf/9zIwyHuu0IZY7dMNFih5VSCFIjJnd3Q==
X-Received: by 2002:a17:906:2ac1:: with SMTP id m1mr1855416eje.472.1617172184870;
        Tue, 30 Mar 2021 23:29:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o20sm741619eds.65.2021.03.30.23.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 23:29:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide
 maybe-negative 'hv_clock->system_time' in compute_tsc_page_parameters()
In-Reply-To: <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet> <87ft0cu2eq.fsf@vitty.brq.redhat.com>
 <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
Date:   Wed, 31 Mar 2021 08:29:43 +0200
Message-ID: <87a6qju97s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 30/03/21 16:44, Vitaly Kuznetsov wrote:
>> We could've solved the problem by reducing the precision a bit and
>> instead of doing
>> 
>>   now_ns = get_kvmclock_ns(kvm);
>> 
>> in KVM_SET_CLOCK() handling we could do
>> 
>>   now_ns = ka->master_kernel_ns
>> 
>> and that would make vcpu->hv_clock.system_time == 0 after
>> kvm_guest_time_update() but it'd hurt 'normal' use-cases to fix the
>> corner case.
>
> Marcelo is right, and I guess instead of a negative system time you 
> *should* have a slightly larger tsc_timestamp that corresponds to a zero 
> system_time.  E.g. instead of -70 ns in the system time you'd have 210 
> more clock cycles in the tsc_timestamp and 0 in the system time.
>
> In the end it's impossible to achieve absolute precision; does the 
> KVM_SET_CLOCK value refer to the nanosecond value before entering the 
> kernel, or after, or what?  The difference is much more than these 70 
> ns.  So what you propose above seems to be really the best solution 
> within the constraints of the KVM_SET_CLOCK API (a better API, which 
> Maxim had started working on and I should revisit, would pass a 
> TSC+nanosecond pair).

I'm leaning towards making a v3 and depending on how complex it's going
to look like we can decide which way to go.

>
> On the other hand you'd have to take into account what happens if the 
> masterclock is not in use, which would make things a bit more complex 
> than what you sketched. 

(I really wish we establish a plan to get rid of !masterclock logic some
day ... )

> If guests probably do not look at the 
> system_time and just add it blindly to the result, then treating 
> system_time as signed as in v2 is the easiest.

-- 
Vitaly

