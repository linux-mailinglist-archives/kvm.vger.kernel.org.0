Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC123EBA34
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhHMQj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234367AbhHMQj1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 12:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628872740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/XxhUQFWXy6zXss0bwZob8zlLwav1FMwUCDBU4JYgrE=;
        b=eJVoAAYWQMGcEMx79S+WnIm90tNWjIRUFiT3cCKKS1GRPaI8bLH41IfzV4f6YtfYT72DZb
        RGoPOLMZSzyQOu5NeSZGCaSCL9xZD7au4wxZr8yXuF4NbmVUArVLIDKSAFnfZTy7gaq+uc
        43R/IX9fky80fcLdpnIAUyCBXLuhVJ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-4AG3GBlKOn-1BGJe5baKdA-1; Fri, 13 Aug 2021 12:38:58 -0400
X-MC-Unique: 4AG3GBlKOn-1BGJe5baKdA-1
Received: by mail-wm1-f71.google.com with SMTP id y206-20020a1c7dd70000b02902e6a442ea44so4495707wmc.9
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XxhUQFWXy6zXss0bwZob8zlLwav1FMwUCDBU4JYgrE=;
        b=VmHvPFFTZFzG8BuGABFM42eIbbh4jlcwDAeul+So0yTy2GZcHeoAFb8FwOudrifu6Y
         J5o4iZsg9cWiLlPRAR/Us6iNYmE+X+vA5fCcPDP8GjOUb0i3Lj5uecWJWNOiO66Kjqha
         dyiN8jqK2g7S/tPKGqtRQn5x0Eh03HeJWLFu5BmDCHOg7MN879FAuMxyYas9QY0R3q4Y
         u08p83QKNMgKv9QlgXoJmWpxWfhCD/0SXuknQpBhSczH1kyRWUIvHKTAX8JXyWBEgCt4
         cNODJx8Zt3szSlQO5mp3GAs01Rf0LzNk+4Nv/9Pv0WPbCpd3CofuED694NdYosv03q1c
         zb8w==
X-Gm-Message-State: AOAM533EpnHwiz8OQlwGZd4agfcpuCpZNc2tdSjL88xih6goHynNFxlJ
        +Gvki9LBcnsLQcE5rPaaKyGJ3uCn2FfLPcqh5+pxPspASG/0qRKEzcM4P0mC75esBaO/bTEmkho
        gd7IdXZ8yAB+m
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr3484699wmf.145.1628872737633;
        Fri, 13 Aug 2021 09:38:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC6stTt1zfIk+HUVQG+yNxjf+4NlHQz9JRcodQI5y8z7vijkPCLwAnX/jxPPBjWVFF3V6GVQ==
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr3484685wmf.145.1628872737424;
        Fri, 13 Aug 2021 09:38:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w9sm1840071wmc.19.2021.08.13.09.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 09:38:56 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Don't step down in the TDP iterator
 when zapping all SPTEs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-3-seanjc@google.com>
 <CANgfPd8HSYZbqmi21XQ=XeMCndXJ0+Ld0eZNKPWLa1fKtutiBA@mail.gmail.com>
 <YRVVWC31fuZiw9tT@google.com>
 <928be04d-e60e-924c-1f3a-cb5fef8b0042@redhat.com>
 <YRVbamoQhvPmrEgK@google.com>
 <7a95b2f6-a7ad-5101-baa5-6a19194695a3@redhat.com>
 <YRVebIjxEv87I55b@google.com>
 <b08a7751-20c3-26fc-522e-c4cf274d9a6c@redhat.com>
 <YRaaIi9Go38E3mUh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0086ef77-ce5f-3e89-0cbd-b17d4dccaacf@redhat.com>
Date:   Fri, 13 Aug 2021 18:38:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRaaIi9Go38E3mUh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 18:13, Sean Christopherson wrote:
> On Fri, Aug 13, 2021, Paolo Bonzini wrote:
>> On 12/08/21 19:46, Sean Christopherson wrote:
>>>>> 	if (iter->level == iter->min_level)
>>>>> 		return false;
>>>>>
>>>>> 	/*
>>>>> 	 * Reread the SPTE before stepping down to avoid traversing into page
>>>>> 	 * tables that are no longer linked from this entry.
>>>>> 	 */
>>>>> 	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));  \
>>>>>                                                                         ---> this is the code that is avoided
>>>>> 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);   /
>>>>> 	if (!child_pt)
>>>>> 		return false;
>>>> Ah, right - so I agree with Ben that it's not too important.
>>> Ya.  There is a measurable performance improvement, but it's really only
>>> meaningful when there aren't many SPTEs to zap, otherwise the cost of zapping
>>> completely dominates the time.
>>
>> I don't understand.  When try_step_down is called by tdp_iter_next, all it
>> does is really just the READ_ONCE, because spte_to_child_pt will see a
>> non-present PTE and return immediately.  Why do two, presumably cache hot,
>> reads cause a measurable performance improvement?
> 
> It's entirely possible my measurements were bad and/or noisy.  Ah, and my kernel
> was running with CONFIG_PROVE_RCU=y, which makes the rcu_dereference() quite a bit
> more expensive.

It's one line of code and it makes sense, so I can certainly include the 
patch.  I was just a bit confused.

Paolo

