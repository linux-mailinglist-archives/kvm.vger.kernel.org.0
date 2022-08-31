Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00C15A8679
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 21:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiHaTMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 15:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHaTMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 15:12:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D43CD83D9
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:12:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso188489pjh.5
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=iddXjcGX4OLtSyWppt8oJ6EdWZijCYZujWCWS7DqmEc=;
        b=qkTfYfrrpXLmJZC1jVUujD709HvbEDJSseqN7rhP4nq5uPOGT7TYff6HQ91pGUjwwn
         k/oQc1okiOi2djY6y3SyWAHmFrnSMXwBKAU4g7RisNfyDpJgeYuRWCKHPIuJYpgNfM1E
         0pa78CqNnii0KnGImCjYVUWMPsCz40e5HXCPRqQ27TtgN0ZNYQhLbbS3/eE9XCRKpbrq
         IE2yzUaIVismewVuW6BMKd3tsCCL3DvPwKV0ZpwujB51VZU4jcDQf+wbGu7omtMvLqzI
         LBngoU6RtPD2tVi9jWIIrMuffN0vRzXxgxfpE+xnqUvLqxZE7XSQfeaEOim+PODG7b51
         2gvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=iddXjcGX4OLtSyWppt8oJ6EdWZijCYZujWCWS7DqmEc=;
        b=cx+Zq3bCoXqjCFFn3q2swvJy0N6AG0G9hys4RWKmDMILHSrtjTtBsY8b5u/tND6ENs
         d2K+r9sj3cejhPdZ+i3x6MGSmcUFN4fBwHa0YgpNXaOjYtEMSbOOFlt7Aaf/99SiJs8M
         AM+9MWZCgw6+lPCHbqLXXYQ7yRyDgZLjT11ZhVVf4We0Vt4gjXMrCq2rVAMJxIA3tIpW
         DStfLw4T27iqPzao2VayhiUa8DIE4lMRI0ygde+UeMW7pTaAYJe3ivyu4DZa1GTj9seS
         SqLy0z++VFwp7ksc0TDpHqEHKERleZkpOGeWAZbjxYiJ5r+AqgiTWMizz5M82XeBChOt
         MTug==
X-Gm-Message-State: ACgBeo0vc+921Edmf0vDp9/Rm3RO+LMjV5kL1cSrNK2umTfDaTOgk+e/
        JG7Igr6ajKUcm0hlAbIwbFn0bI/tOcZzMg==
X-Google-Smtp-Source: AA6agR4tC0o1bnljB1WKXww3mMQilcVt7Vw89+r/7sAV5FpqaSo+T1g6DgjkIEwKHmqMJwTNVlEcAg==
X-Received: by 2002:a17:902:db07:b0:175:42e2:37f2 with SMTP id m7-20020a170902db0700b0017542e237f2mr4381848plx.13.1661973138930;
        Wed, 31 Aug 2022 12:12:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z15-20020a634c0f000000b0041d9e78de05sm3663627pga.73.2022.08.31.12.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:12:18 -0700 (PDT)
Date:   Wed, 31 Aug 2022 19:12:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
Message-ID: <Yw+yjo4TMDYnyAt+@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
 <Yw+MYLyVXvxmbIRY@google.com>
 <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 16:29 +0000, Sean Christopherson wrote:
> > On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > > Leaving AVIC on, when vCPU is in x2apic mode cannot trigger extra MMIO emulation,
> > > in fact the opposite - because AVIC is on, writes to 0xFEE00xxx might *not* trigger
> > > MMIO emulation and instead be emulated by AVIC.
> > 
> > That's even worse, because KVM is allowing the guest to exercise hardware logic
> > that I highly doubt AMD has thoroughly tested.
> 
> Harware logic is exactly the same regarless of if KVM uses x2apic mode or not,
> and it is better to be prepared for all kind of garbage coming from the guest.

Right, I got twisted around and was thinking x2APIC enabling of the guest was
reflected in hardware, but it's purely emulated in this mode.

> Software logic, I can understand you, there could be registers that trap differently
> in avic and x2avic mode, but it should be *very* easy to deal with it, the list
> of registers that trap is very short.
> 
> > 
> > > Yes, some of these writes can trigger AVIC specific emulation vm exits, but they
> > > are literaly the same as those used by x2avic, and it is really hard to see
> > > why this would be dangerous (assuming that x2avic code works, and avic code
> > > is aware of this 'hybrid' mode).
> > 
> > The APIC_RRR thing triggered the KVM_BUG_ON() in kvm_apic_write_nodecode()
> > precisely because of the AVIC trap.  At best, this gives a way for the guest to
> > trigger a WARN_ON_ONCE() and thus panic the host if panic_on_warn=1.  I fixed
> > the APIC_RRR case because that will be problematic for x2AVIC, but there are
> > other APIC registers that are unsupported in x2APIC that can trigger the KVM_BUG_ON().

> > > From the guest point of view, unless the guest pokes at random MMIO area,
> > > the only case when this matters is if the guest maps RAM over the 0xFEE00xxx
> > > (which it of course can, the spec explictly state as you say that when x2apic
> > > is enabled, the mmio is disabled), and then instead of functioning as RAM,
> > > the range will still function as APIC.
> > 
> > There is no wiggle room here though, KVM is blatantly breaking the architectural
> > specification.  When x2APIC is enabled, the xAPIC MMIO does not exist.
> 
> In this case I say that there is no wiggle room for KVM to not allow
> different APIC bases on each CPU - the spec 100% allows it, but in KVM it is
> broken.

The difference is that KVM is consistent with respect to itself in that case.
KVM doesn't support APIC base relocation, and never has supported APIC base
relocation.

This hybrid AVIC mode means that the resulting KVM behavior will vary depending
on whether or not AVIC is supported and enabled, whether or not x2AVIC is supported,
and also on internal KVM state.  And we even have tests for this!  E.g. run the APIC
unit test with AVIC disabled and it passes, run it with AVIC enabled and it fails.

> If you are really hell bent on not having that MMIO exposed, then I say we
> can just disable the AVIC memslot, and keep AVIC enabled in this case - this
> should make us both happy.

I don't think that will work though, as I don't think it's possible to tell hardware
not to accelerate AVIC accesses.  I.e. KVM can squash the unaccelerated traps, but
anything that is handled by hardware will still go through.

> This discussion really makes me feel that you want just to force your opinion
> on others, and its not the first time this happens. It is really frustrating
> to work like that.  It might sound harsh but this is how I feel. Hopefully I
> am wrong.

Yes and no.  I am most definitely trying to steer KVM in a direction that I feel
will allow KVM to scale in terms of developers, users, and workloads.  Part of
that direction is to change people's mindset from "good enough" to "implement to
the spec".

KVM's historic "good enough" approach largely worked when KVM had a relatively
small and stable development community, and when KVM was being used to run a
relatively limited set of workloads.  But KVM is being used to run an ever increasing
variety of workloads, and the development community is larger (and I hope that we
can grow it even further).  And there is inevitably attrition, which means that
unless we are extremely diligent in documenting KVM's quirks/errata, knowledge of
KVM's "good enough" shortcuts will eventually be lost.

E.g. it took me literally days to understand KVM's hack for forcing #PF=>#PF=>VM-Exit
instead of #PF=>#PF=>#DF.  That mess would have been avoided if KVM had implemented
to the spec and actually done the right thing back when the bug was first encountered.
Ditto for the x2APIC ID hotplug hack; I stared at that code on at least three
different occassions before I finally understood the full impact of the hack.

And getting KVM to implement to the spec means not deviating from that path when
it's inconvenient to follow, thus the hard line I am drawing.  I am sure we'll
encounter scenarios/features where it's simply impossible for KVM to do the right
thing, e.g. I believe virtualizing VMX's posted interrupts falls into this category.
But IMO those should be very, very rare exceptions.

So, "yes" in the sense that I am openly trying to drag people into alignment with
my "implement to the spec" vision.  But "no" in the sense that I don't think it's
fair to say I am forcing my opinion on others.  I am not saying "NAK" and ending
the discussion.
