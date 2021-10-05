Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A7442346D
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 01:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhJEXYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 19:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbhJEXYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 19:24:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B18C061753
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 16:22:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so3185902pjw.0
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 16:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m9g1k9Ehzl1bBmOmbWpzyKu2OyGll8ZVrGgmYjaqKjE=;
        b=ZIXQVqDEleqlMYOYE8uyt64quzfw6t8FTgHIuUhAHUDISyRE68TkMoPXMMRiF6NhgE
         tyBIPNPPMf6X7CJTThWKSbFivxu3YrfhaEoHq2drD1s1buw2/SIXLRGA400pzo5sRHPh
         Uz1UQAx5ddWS//cm5eTEkyKyuvPWo/godhOsZO+cR3Eefx5NtmbhW6EoeU1tDpkEF4kc
         MncY7RrrhHgnY5cGUVeNLxYfjEvmyreLg4ng8tMz/J/HgipgOdbvqOIJ6j9S+8Hd0U55
         tKhPvBCWpCjkTIrzg726M+RlwwrOil+exphV18o1hY1/pYezgiQIZYPUeRZpHkSJCk14
         8exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m9g1k9Ehzl1bBmOmbWpzyKu2OyGll8ZVrGgmYjaqKjE=;
        b=35B1vus9Ogcyh6VRn7HzrA8S0Kn2g8VlOy6cdK2FblC4JTEk2mT5mq/wbd1xoch4sH
         fjG0OYa1yqO5MBg6qp/W15hA6TATZtSpCxe5rkLC2tR9obrF2rcG64KPwtPpshbxTlVN
         1fencgPawZqxMnGtm5CK9w96/4QlCqNgj9pPfr7i62Wh2ApFFa319bzii1u3I46d3NTM
         mxm8M1UXl5FoX+4JYL2fmqS1xcFiPz65wxXLJyDgsAXPeRnRx7LUhQ5awgzMu2ZCrimn
         Vqs+O3l4dKNOUBpcKOBQxrAmB1tJxZsREzwQ084qRpZUqOcAXOS9hlocI49k9D1i6XuE
         gvvg==
X-Gm-Message-State: AOAM530TI5R7lXJxwmJwCDTQxqI2nHX0PD01VfcMbksMlzGcIu2KPSrx
        sBRlyfhrGyb3WW8t7zfkv38dqA==
X-Google-Smtp-Source: ABdhPJwyQhPgShiqttAUsRHbTH8ZbAVZVoV1yQSiPJiQAz0Fwbu5xjkjFsUIIMYSUurj8K/27RAc3w==
X-Received: by 2002:a17:90b:1e4b:: with SMTP id pi11mr7089504pjb.179.1633476139217;
        Tue, 05 Oct 2021 16:22:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 17sm18642181pfh.216.2021.10.05.16.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 16:22:18 -0700 (PDT)
Date:   Tue, 5 Oct 2021 23:22:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YVzeJ59/yCpqgTX2@google.com>
References: <YS/lxNEKXLazkhc4@google.com>
 <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com>
 <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com>
 <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com>
 <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com>
 <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021, Jim Mattson wrote:
> On Tue, Oct 5, 2021 at 1:50 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > >
> > > > > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > > > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > > > > > >       You also said, "This is quite the complicated mess for
> > > > > > > something I'm guessing no one actually cares about.  At what point do
> > > > > > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > > > > > -- I couldn't agree more.
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > > So, Sean, can you help converge our discussion and settle next step?
> > > > > >
> > > > > > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > > > > > the proverbial rug?
> > > > >
> > > > > Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> > > > > hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> > > > > unreasonable for VM-exit statistics, so maybe I've got a warped
> > > > > perspective. I'm all for pedantic adherence to the specification, but
> > > > > I have to admit that no actual hypervisor is likely to care (or ever
> > > > > will).
> > > >
> > > > It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
> > > > working correctly, both now and in the future.
> > >
> > > As far as CPU feature virtualization goes, this one doesn't seem that
> > > complex to me. It's not anywhere near as complex as virtualizing MTF,
> > > for instance, and KVM *claims* to do that! :-)
> >
> > There aren't many things as complex as MTF.  But unlike MTF, this behavior doesn't
> > have a concrete use case to justify the risk vs. reward.  IMO the odds of us breaking
> > something in KVM for "normal" use cases are higher than the odds of an L1 VMM breaking
> > because a VMREAD/VMWRITE didn't fail when it technically should have failed.
> 
> Playing devil's advocate here, because I totally agree with you...
> 
> Who's to say what's "normal"? It's a slippery slope when we start
> making personal value judgments about which parts of the architectural
> specification are important and which aren't.

I agree, but in a very similar case Intel chose to take an erratum instead of
fixing what was in all likelihood a microcode bug, i.e. could have been patched
in the field.  So it's not _just_ personal value judgment, though it's definitely
that too :-)

I'm not saying I'd actively oppose support for strict VMREAD/VMWRITE adherence
to the vCPU model, but I'm also not going to advise anyone to go spend their time
implementing a non-trivial fix for behavior that, AFAIK, doesn't adversely affect
any real world use cases.
