Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBE7285007
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJFQkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 12:40:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgJFQkC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 12:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602002401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZq/ugQXX37ZRTJVEGnH97uzahmABbjl+3yxJ1I9FfU=;
        b=OmIpYAZ1Q5cDw0X/QQ3LU2LwwywGkIaFgGpOXH2R0mqC96yt83T8SyQ1JKxlJ/g8jH0+2r
        l690KheZc9OJm/errkZOaloT19Q87UdQa1ly9Qhbw+gjxvaeoeAYuRZoo2aAHFSMdYOapr
        R9CqdVK15iO2Y/bDG63lzaj10uAVHY0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-waI6kBzGM1G3eJO68oLZnQ-1; Tue, 06 Oct 2020 12:39:59 -0400
X-MC-Unique: waI6kBzGM1G3eJO68oLZnQ-1
Received: by mail-wm1-f71.google.com with SMTP id v14so1326189wmj.6
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 09:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eZq/ugQXX37ZRTJVEGnH97uzahmABbjl+3yxJ1I9FfU=;
        b=OoSvJuiDbOSuH3JTjNU2KyI9lKVrOcGQmhJEkk8AlnFDnUhVxbr9JSVrzhXz90aHpK
         Ngi7oaA8gwCN8xx4HTzg+8vNmMphh2fbKQaPkrJPXbGmzAX7bwMWaBV1jAzPqCTGDrAP
         naf+WAUwYT6My8QOtt+xKV3euKmiBPNIkXSac25V1vMZb6g8+t9jD4X1ctabSKUzsY1i
         57+WcY18jjlI71gP3TaSoxja97A4kjqAqpDgR5c3rdd+6p75SY2meY7zgbUw8AAmKeKf
         vaFb0f640Q+EDfjzgXKvJaDp/ch2Ym+ROb5P6SMVyLhSRPv5VKEHhGRWkZESFQ2F/ZAN
         YhKg==
X-Gm-Message-State: AOAM530y7jTeQN10fhMtgMyFrxRPQwrXbFRuK0vmlq2mDT2Xnmbd3zBd
        /HYmpW18lLtzukVj+8WKsvuwaYzajFT6LH3kFGCdux6SBmD5ZVVqVay+kBZ/fZvumsz298zEOxL
        /SAfiGL5xANjC
X-Received: by 2002:adf:fd8c:: with SMTP id d12mr5888678wrr.283.1602002398408;
        Tue, 06 Oct 2020 09:39:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkn+x9uLOTXwjY97PQeZXiZ4aMpmcJByl8AxljM3Y1KHeda0+L7iWpgFH7Cbq0UknWMthlcA==
X-Received: by 2002:adf:fd8c:: with SMTP id d12mr5888654wrr.283.1602002398113;
        Tue, 06 Oct 2020 09:39:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z13sm5007403wro.97.2020.10.06.09.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 09:39:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
In-Reply-To: <20201006161200.GB17610@linux.intel.com>
References: <20201002200214.GB10232@redhat.com> <20201002211314.GE24460@linux.intel.com> <20201005153318.GA4302@redhat.com> <20201005161620.GC11938@linux.intel.com> <20201006134629.GB5306@redhat.com> <877ds38n6r.fsf@vitty.brq.redhat.com> <20201006141501.GC5306@redhat.com> <874kn78l2z.fsf@vitty.brq.redhat.com> <20201006150817.GD5306@redhat.com> <871rib8ji1.fsf@vitty.brq.redhat.com> <20201006161200.GB17610@linux.intel.com>
Date:   Tue, 06 Oct 2020 18:39:56 +0200
Message-ID: <87y2kj71gj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> > So you will have to report token (along with -EFAULT) to user space. So this
>> > is basically the 3rd proposal which is extension of kvm API and will
>> > report say HVA/GFN also to user space along with -EFAULT.
>> 
>> Right, I meant to say that guest kernel has full register state of the
>> userspace process which caused APF to get queued and instead of trying
>> to extract it in KVM and pass to userspace in case of a (later) failure
>> we limit KVM api change to contain token or GFN only and somehow keep
>> the rest in the guest. This should help with TDX/SEV-ES.
>
> Whatever gets reported to userspace should be identical with and without
> async page faults, i.e. it definitely shouldn't have token information.
>

Oh, right, when the error gets reported synchronously guest's kernel is
not yet aware of the issue so it won't be possible to find anything in
its kdump if userspace decides to crash it immediately. The register
state (if available) will be actual though.

> Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> into the guest is not an option.  

Not even #MC? So sad :-)

> Nor do I think that's "correct" behavior (see everyone's objections to
> using #PF for APF fixed).  I.e. the event should probably be an IRQ.

I recall Paolo objected against making APF 'page not present' into in
interrupt as it will require some very special handling to make sure it
gets injected (and handled) immediately but I'm not really sure how big
the hack is going to be, maybe in the light of TDX/SEV-ES it's worth a
try.

-- 
Vitaly

