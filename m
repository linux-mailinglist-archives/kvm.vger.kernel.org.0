Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F54422F84
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhJESBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 14:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhJESBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 14:01:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9464C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 10:59:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c29so224428pfp.2
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 10:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FxQLMgGRO5NBtnXquaGOaBTErWmCv8I3xPuDWnsxNMk=;
        b=F/KUJ9KxvEsNAjAVArIa0Y5aSmAOz+aJizqcj2pzEi4qJIqB2IFX721Kul6kz5kLAk
         PjBMso41i9Y9+C/F9DiS0p0+oXBsCty3RDqZgqbbk7JhDkLpNWOLMaod+AkU5w9M+bQh
         cSfoLqKsr8fsu/q1vGLM4OQ5i2bsABFIVw50jOA9V4SdE69T//VGievgTDNSkz6g2FW5
         ywFBo7aaXTXuQ0enIhO0C0qldeh8b+ZZe9mX7VhIYvJ3wPlBe+8MO3iGtw7PPNpB941P
         D8jfduAnnYVRFUx6RNBNINJHbqpFo28BSGzUxp9S1zGzPVklF+6nc0d5dIpaHnKuaJ4a
         fduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FxQLMgGRO5NBtnXquaGOaBTErWmCv8I3xPuDWnsxNMk=;
        b=EiZr3u1ahqaAwv8WVlwG1ErZyinl0MV2n+c4jG1SsIVb/yeVGo8sCBj4hYoB9927hl
         J54trSQmTEaHwE39ukBPShSbJ+i5upXlog8Fy55KxgzF88t2xdhR/Slan/dswKQtrXE7
         TiVlyCmFAJj8y4czAg3/S2ScTekDRA7vI4kut7vD6aGmlXOI4RmIe535OT5h9e69Wjwi
         j4nIUP5Thhn5vzqCQEyfU2aURZ0qT0kitYbYzmvArTzBdRsHeNf+lsLNTocKm/iMih2U
         Cc5cKZi5mPbaeiB7xM4dgmZPrmtyZNgS0vGClo6Z/eLYQpL80XECxJW/MHxkhpcUYtL1
         9PGQ==
X-Gm-Message-State: AOAM532HRI3oXK7FkYXmxrNWAbU7YD3mf0iQuIjUXR0DGe3fAWvFwr/p
        bFQ9mYJnIVca0J4/3BtrjEVm+Q==
X-Google-Smtp-Source: ABdhPJzvVlqiWZpWASSuAm/r4Q17GWyjK/l1ppJ7hO/LiK5cR5a8MOruJ6kp1JRzp7Z0vC/UvOK+HQ==
X-Received: by 2002:aa7:96e3:0:b0:44c:83be:19bc with SMTP id i3-20020aa796e3000000b0044c83be19bcmr4103166pfq.37.1633456759988;
        Tue, 05 Oct 2021 10:59:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d9sm17876808pgn.64.2021.10.05.10.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 10:59:19 -0700 (PDT)
Date:   Tue, 5 Oct 2021 17:59:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YVySdKOWTXqU4y3R@google.com>
References: <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
 <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com>
 <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com>
 <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com>
 <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021, Jim Mattson wrote:
> On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > >       You also said, "This is quite the complicated mess for
> > > something I'm guessing no one actually cares about.  At what point do
> > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > -- I couldn't agree more.
> >
> > ...
> >
> > > So, Sean, can you help converge our discussion and settle next step?
> >
> > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > the proverbial rug?
> 
> Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> unreasonable for VM-exit statistics, so maybe I've got a warped
> perspective. I'm all for pedantic adherence to the specification, but
> I have to admit that no actual hypervisor is likely to care (or ever
> will).

It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
working correctly, both now and in the future.
