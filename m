Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDD63E8E6A
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhHKKUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237016AbhHKKUv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628677227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzNKS8jqyPAaVafnIpkch354MYvVZeHaPB5KNR7T5Mk=;
        b=FBWbZrp/iJXw5k8I2C39ygAiNCX9Eknw+iFNsaepLQQCKXnkmjMcaeBleglk98jPNe7WwA
        4qeHRqHs8roqrA14WYUiJcwLHPXnfcUrMTAdY7xBoz9eNwhgVWMNL7j/2NFP6yry6KmZSJ
        ATSHuwIo4XP/4fkaDudGIMUBH435ipc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-d4lcOL2nPsGuo8seYuN9CA-1; Wed, 11 Aug 2021 06:20:26 -0400
X-MC-Unique: d4lcOL2nPsGuo8seYuN9CA-1
Received: by mail-ed1-f71.google.com with SMTP id dh21-20020a0564021d35b02903be0aa37025so986109edb.7
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 03:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vzNKS8jqyPAaVafnIpkch354MYvVZeHaPB5KNR7T5Mk=;
        b=nzrb2U7sVhL7hP7J0a/VhG9vJck7/WsjaAhK2bKq2X29COMCaHM9CAgvc3dlMu97Pi
         QFgDC5z5CoxGhs2MLgBPSpBEeUW4S66uhkZGZP140iEgj+P7YupRxoODdgXymukaPIeL
         D6BRitPruuXxKr5az/cfvnpxYGTUmkS4V420LUWaCYWriG33A7GDJb9pUZdDCozivoAK
         LULNzNvjuLhqv2tbGXZy4mM6HzsKeauJfgzhxYwDg/mLegTLaZNyf9C9LzEd0rqawu6q
         CQ6nIkd32rnEsgXO6gK94HWL0+mkT12gTVd5sQoFze5Xp/QWOqqh7XViLx7f/+qXmlCM
         +YEg==
X-Gm-Message-State: AOAM533G3iOOMrg+8WA2tv0C17hm7+3+WREjJtRrEbHr3r0iHmZjkFCM
        FEWWS1ZNG6VTR/nJyNxuMmcKC8Murn7so9zwaddZc222SDLW9pYQSWJJgzsVNENOh3KqnBXHY1y
        eKwJsAmV9o/RI
X-Received: by 2002:a17:906:4894:: with SMTP id v20mr2827814ejq.207.1628677225536;
        Wed, 11 Aug 2021 03:20:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXkrdffhPe4tXy3ltmqSJ6w5dqsU7sFWQYmUfpZ2KuloIV5wPgIeCZgjPaG/bAnd/2u6dxIw==
X-Received: by 2002:a17:906:4894:: with SMTP id v20mr2827802ejq.207.1628677225342;
        Wed, 11 Aug 2021 03:20:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f8sm2120747edy.57.2021.08.11.03.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 03:20:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20210810223238.979194-1-jingzhangos@google.com>
 <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5183cb08-f739-e6a6-f645-3ccbe92d04d8@redhat.com>
Date:   Wed, 11 Aug 2021 12:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/21 00:56, Oliver Upton wrote:
> What if the statistic was 'dirtied_pages', which records the number of
> pages dirtied in the lifetime of a VM? Userspace could just record the
> value each time it blows away the dirty bitmaps and subtract that
> value next time it reads the stat. It would circumvent the need to
> walk the entire dirty bitmap to keep the statistic sane.

Yeah, that'd be much better also because the "number of dirty pages" 
statistic is not well defined in init-all-dirty mode.

Making it a vCPU stat works in fact, because mark_page_dirty_in_slot is 
only called with kvm_get_running_vcpu() != NULL; see 
kvm_dirty_ring_get() in virt/kvm/dirty_ring.c.

>>
>> +               if (kvm->dirty_ring_size) {
>>                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>>                                             slot, rel_gfn);
>> -               else
>> +               } else {
>>                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> +                       ++kvm->stat.generic.dirty_pages;
>> +               }
> 
> Aren't pages being pushed out to the dirty ring just as dirty? 
> 

Yes, they are.

Paolo

