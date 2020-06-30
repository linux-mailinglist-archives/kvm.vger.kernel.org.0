Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2ED20F8BD
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 17:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389711AbgF3PoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 11:44:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389654AbgF3PoP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 11:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593531853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+7JZMmEMWPm9TcnXCXFzCXeXPgv7LEiZobSQGLUt4c=;
        b=f2pW6/Hb86atlptqhqikgNm+JaXgRxlhWJkciSdY8USd5/AR3zDuDFRJOGustYh9C+JZbu
        2H2BF0T9IQUk1+P/duubVqPX8tq5WF5ZCWbspnK+9x9gJV4ZsBhciOYiEp8HQG+6hQWTqE
        3Nanxr2jx0uD6Fq+sVI0VHZezFXA5v8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-JnFv8AOzO6mC0mN25W1Rnw-1; Tue, 30 Jun 2020 11:43:57 -0400
X-MC-Unique: JnFv8AOzO6mC0mN25W1Rnw-1
Received: by mail-ej1-f72.google.com with SMTP id h26so13325639ejb.5
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 08:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g+7JZMmEMWPm9TcnXCXFzCXeXPgv7LEiZobSQGLUt4c=;
        b=mJvFsU0vJXG7XBOkmXaxjG2dmuYBA/YUD4/uxpGUzlAcc+dJpRToiNDafW2VhN5urK
         b2s8uRFe8+sdgumJkQM4TiPSv0Rb52gaGVEHNdFo5vRivrEgvdb4lK2PODtWPVi3Pd9p
         re2Nd4JmbjQMrv6XUEu8xjsgGn8yir9Lx4jAC1LtJujz3EA9NInqe6k9X/kVl4F9lpv7
         w7kMCfT2itMdGwH3H774aTCzwiQIFpsjNh8tNUIW3SbnA6no5oosdacaF8rMu3Vdej2Y
         JuShBdSjZxwCXfDEfDDpuZGTdUESEFnRZUDUlLiHWgHXv4Jeex07/WbfX5gW8eDLTArx
         i8RQ==
X-Gm-Message-State: AOAM530W2flNv3iduGkKW+9jxs78FdX98z1+vy0ld1VMtRXPUpeVcS8a
        +AniOcc3bMksMUfgq3OhB8xUSPb0l0Q7qa1PCd+jBANoAeIax7KOjKUj9jUXAlv0ivhPXu07pLT
        bfAGedrh8oxcS
X-Received: by 2002:a17:906:6a14:: with SMTP id o20mr19371692ejr.128.1593531836504;
        Tue, 30 Jun 2020 08:43:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwN5020D0g4+WwC4BExYGDMsxQNa0UsSFFuaNfKIVU9PWBDqP5EAnwkz46NPYCIlmVoziF18w==
X-Received: by 2002:a17:906:6a14:: with SMTP id o20mr19371673ejr.128.1593531836311;
        Tue, 30 Jun 2020 08:43:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w18sm2247913ejc.62.2020.06.30.08.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 08:43:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200630152529.GC322149@redhat.com>
References: <20200625214701.GA180786@redhat.com> <87lfkach6o.fsf@vitty.brq.redhat.com> <20200626150303.GC195150@redhat.com> <874kqtd212.fsf@vitty.brq.redhat.com> <20200629220353.GC269627@redhat.com> <87sgecbs9w.fsf@vitty.brq.redhat.com> <20200630145303.GB322149@redhat.com> <87mu4kbn7x.fsf@vitty.brq.redhat.com> <20200630152529.GC322149@redhat.com>
Date:   Tue, 30 Jun 2020 17:43:54 +0200
Message-ID: <87k0zobltx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 30, 2020 at 05:13:54PM +0200, Vitaly Kuznetsov wrote:
>> 
>> > - If you retry in kernel, we will change the context completely that
>> >   who was trying to access the gfn in question. We want to retain
>> >   the real context and retain information who was trying to access
>> >   gfn in question.
>> 
>> (Just so I understand the idea better) does the guest context matter to
>> the host? Or, more specifically, are we going to do anything besides
>> get_user_pages() which will actually analyze who triggered the access
>> *in the guest*?
>
> When we exit to user space, qemu prints bunch of register state. I am
> wondering what does that state represent. Does some of that traces
> back to the process which was trying to access that hva? I don't
> know.

We can get the full CPU state when the fault happens if we need to but
generally we are not analyzing it. I can imagine looking at CPL, for
example, but trying to distinguish guest's 'process A' from 'process B'
may not be simple.

>
> I think keeping a cache of error gfns might not be too bad from
> implemetation point of view. I will give it a try and see how
> bad does it look.

Right; I'm only worried about the fact that every cache (or hash) has a
limited size and under certain curcumstances we may overflow it. When an
overflow happens, we will follow the APF path again and this can go over
and over. Maybe we can punch a hole in EPT/NPT making the PFN reserved/
not-present so when the guest tries to access it again we trap the
access in KVM and, if the error persists, don't follow the APF path?

-- 
Vitaly

