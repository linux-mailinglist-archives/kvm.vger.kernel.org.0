Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0154B20F930
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgF3QM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 12:12:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731482AbgF3QM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 12:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593533576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u1woKrpm36qH+9CniD7td2Wx/FFa6jfnW3kyhHa0B0Q=;
        b=O5tboyelkrvDSzr6LyoFXPBuCOHt+vZMtX+GnV5pIp8lco8wF9K6MQ7cszv42tnOFyQO0A
        QwCCi2nQf+lAyscpedqJhPD+OL7K5pN/0LLQNVgIODLaVBzSM3jVInUTT33thBXX9xz3wH
        h6jiUwdEhB0C/3axIdD3Ld0w+HmwlGk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-ZjKULD6dPi2VEmfB19Q20Q-1; Tue, 30 Jun 2020 12:12:52 -0400
X-MC-Unique: ZjKULD6dPi2VEmfB19Q20Q-1
Received: by mail-ed1-f69.google.com with SMTP id o3so17345622eda.23
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 09:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=u1woKrpm36qH+9CniD7td2Wx/FFa6jfnW3kyhHa0B0Q=;
        b=osdsM3jdsgohJMbBa08ufPK6w3VMgjJKS6QMBEZjDNnoSUmV/tMUFIseQ1ZIJLfh+m
         IqBwEBUvjdOOWCesSrFEjkSeblke0+0jz0jTrXVbtkTNFTzeMmq9va0LP4yrCgjaGGXH
         vYLMcGdmEVKmAd4C+fW2vqpOkfoOhXdyjCaymG3RGr0tqf50JMm1atptYod5jLeyQicB
         B3asFGguRqNj9D+xOcnxaeF1n88kLXksPKIiLB5Ep+T8h4oTCvCy9lQIxCupdw1gOQnX
         iL+qvhUGZz/QMKYeUyrY1WPJHWmM4wOKg8h+Kgt3s6a0xR8rsGIGZn0fYb+PLnHKpFut
         Mzcw==
X-Gm-Message-State: AOAM533At72grkJxChmSm0ReJdaRrlC6rETBuBXsdpdsIwSA7P7M4vHr
        EDYv24SKCkgGkPrk3aICZvwwBFCury8deHYn+pSGNXGCrgd051uQRiOnsYiHrDyYVF2w2RPQmRT
        uwmK1GzEmAYHq
X-Received: by 2002:a17:907:4003:: with SMTP id nj3mr17335435ejb.278.1593533571103;
        Tue, 30 Jun 2020 09:12:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrXJV58SJMMKQpUR9XNOoA+68L5q628xqNC2yIic4jjctjd1dDysXqe9CRG1wN7CCTA25XBQ==
X-Received: by 2002:a17:907:4003:: with SMTP id nj3mr17335420ejb.278.1593533570875;
        Tue, 30 Jun 2020 09:12:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w24sm3311717edt.28.2020.06.30.09.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 09:12:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200630155028.GE7733@linux.intel.com>
References: <20200625214701.GA180786@redhat.com> <87lfkach6o.fsf@vitty.brq.redhat.com> <20200626150303.GC195150@redhat.com> <874kqtd212.fsf@vitty.brq.redhat.com> <20200629220353.GC269627@redhat.com> <87sgecbs9w.fsf@vitty.brq.redhat.com> <20200630145303.GB322149@redhat.com> <87mu4kbn7x.fsf@vitty.brq.redhat.com> <20200630152529.GC322149@redhat.com> <87k0zobltx.fsf@vitty.brq.redhat.com> <20200630155028.GE7733@linux.intel.com>
Date:   Tue, 30 Jun 2020 18:12:49 +0200
Message-ID: <87h7usbkhq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

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
>> and over. Maybe we can punch a hole in EPT/NPT making the PFN reserved/
>> not-present so when the guest tries to access it again we trap the
>> access in KVM and, if the error persists, don't follow the APF path?
>
> Just to make sure I'm somewhat keeping track, is the problem we're trying to
> solve that the guest may not immediately retry the "bad" GPA and so KVM may
> not detect that the async #PF already came back as -EFAULT or whatever? 

Yes. In Vivek's patch there's a single 'error_gfn' per vCPU which serves
as an indicator whether to follow APF path or not.

-- 
Vitaly

