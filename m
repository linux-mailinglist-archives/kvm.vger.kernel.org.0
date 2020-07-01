Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB4E2105DD
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgGAIHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:07:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728497AbgGAIG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 04:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593590818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kO3FhtcRdUCD2T/2dvT7E4BtzYPqfAKbnmCLMMGWuv8=;
        b=BhpxkcWFhH1dDD9++AeG6UwrBe5zq2lyAWEaPgS+TsiyGXFBFkhWzAYSD636EqKgf3ijk/
        cvd/vXbX7BGpaMEdwjxTr2Kf96ZCD2gU7YnOFM3PO64Mu6GuA1PkkZ4lD/1jISd3yWaMlN
        FI0GKCQa4DzMqDDQbtBusaqqjDi8cOU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-1Q5agaUAOLaJUzAEbdZyKw-1; Wed, 01 Jul 2020 04:06:54 -0400
X-MC-Unique: 1Q5agaUAOLaJUzAEbdZyKw-1
Received: by mail-ed1-f70.google.com with SMTP id dg19so18878490edb.6
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 01:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kO3FhtcRdUCD2T/2dvT7E4BtzYPqfAKbnmCLMMGWuv8=;
        b=D+2LDwlAbR2CEz+7zVwgxIndNQaOt8SJwsDHX4blngJHU9FefsZ8yUDsonnfWbTd0B
         /1wKT/DzXc4xUwbka7by1fro6UITxPWebwt+OYFPKKViv9rJFSwa+/eHy0DIzBzO+hkk
         Y0tKA0qjDf8B0+damPp4PK3fXwFpAcq7QdfZtCSGhZt6IUjk9K/DdSNrqXlNBBMKmiOg
         1k/G754zuRkXKpy3vj7pN3q0gfhmb0LTjnAvp1xZCJMLOy6fWPtd+OMDO66344uWctD8
         FNOzKRP6NaOu5dJZlkLH8054byYrPNOWAWbuoPtvztrfH0kVsyqyiLz87LuXOSDZZTkk
         HwzQ==
X-Gm-Message-State: AOAM530skBon972RQC+7dLhnYwwgC3dFyJ6tXmCxfu5J46GvEW8E5ecm
        ThZFaADWlHg2UhrV8WUqRAMIZ7CDJTgp4I48HqCebVT17isREDgCSJHk48HYAHMiJGo8nCBDFo1
        F94SNN7zAubsM
X-Received: by 2002:a50:f384:: with SMTP id g4mr26484653edm.205.1593590813512;
        Wed, 01 Jul 2020 01:06:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym7w7ayeemI+OJq6fBltA9j9TRv+bcySq7fBe3+w3surB27xebJp8+fpDWhMbJo7073orxBA==
X-Received: by 2002:a50:f384:: with SMTP id g4mr26484633edm.205.1593590813248;
        Wed, 01 Jul 2020 01:06:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d22sm3992889ejc.90.2020.07.01.01.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:06:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200630182542.GA328891@redhat.com>
References: <20200625214701.GA180786@redhat.com> <87lfkach6o.fsf@vitty.brq.redhat.com> <20200626150303.GC195150@redhat.com> <874kqtd212.fsf@vitty.brq.redhat.com> <20200629220353.GC269627@redhat.com> <87sgecbs9w.fsf@vitty.brq.redhat.com> <20200630145303.GB322149@redhat.com> <87mu4kbn7x.fsf@vitty.brq.redhat.com> <20200630152529.GC322149@redhat.com> <87k0zobltx.fsf@vitty.brq.redhat.com> <20200630182542.GA328891@redhat.com>
Date:   Wed, 01 Jul 2020 10:06:51 +0200
Message-ID: <87blkzbqw4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 30, 2020 at 05:43:54PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Tue, Jun 30, 2020 at 05:13:54PM +0200, Vitaly Kuznetsov wrote:
>> >> 
>> >> > - If you retry in kernel, we will change the context completely that
>> >> >   who was trying to access the gfn in question. We want to retain
>> >> >   the real context and retain information who was trying to access
>> >> >   gfn in question.
>> >> 
>> >> (Just so I understand the idea better) does the guest context matter to
>> >> the host? Or, more specifically, are we going to do anything besides
>> >> get_user_pages() which will actually analyze who triggered the access
>> >> *in the guest*?
>> >
>> > When we exit to user space, qemu prints bunch of register state. I am
>> > wondering what does that state represent. Does some of that traces
>> > back to the process which was trying to access that hva? I don't
>> > know.
>> 
>> We can get the full CPU state when the fault happens if we need to but
>> generally we are not analyzing it. I can imagine looking at CPL, for
>> example, but trying to distinguish guest's 'process A' from 'process B'
>> may not be simple.
>> 
>> >
>> > I think keeping a cache of error gfns might not be too bad from
>> > implemetation point of view. I will give it a try and see how
>> > bad does it look.
>> 
>> Right; I'm only worried about the fact that every cache (or hash) has a
>> limited size and under certain curcumstances we may overflow it. When an
>> overflow happens, we will follow the APF path again and this can go over
>> and over.
>
> Sure. But what are the chances of that happening. Say our cache size is
> 64. That means we need atleast 128 processes to do co-ordinated faults
> (all in error zone) to skip the cache completely all the time. We
> have to hit cache only once. Chances of missing the error gnf
> cache completely for a very long time are very slim. And if we miss
> it few times, now harm done. We will just spin few times and then
> exit to qemu.
>
> IOW, chances of spinning infinitely are not zero. But they look so
> small that in practice I am not worried about it.
>
>> Maybe we can punch a hole in EPT/NPT making the PFN reserved/
>> not-present so when the guest tries to access it again we trap the
>> access in KVM and, if the error persists, don't follow the APF path?
>
> Cache solution seems simpler than this. Trying to maintain any state
> in page tables will be invariably more complex (Especially given
> many flavors of paging).
>
> I can start looking in this direction if you really think that its worth
> implementing  page table based solution for this problem. I feel that
> we implement something simpler for now and if there are easy ways
> to skip error gns, then replace it with something page table based
> solution (This will only require hypervisor change and no guest
> changes).

I think we're fine with an interim cache/hash solution as long as
chances of getting into an infinite loop accidentaially are very slim
and we don't have any specific latency requirements. Feel free to forget
about PT suggestion for now, we can certainly make it 'step 2' (IMO).

-- 
Vitaly

