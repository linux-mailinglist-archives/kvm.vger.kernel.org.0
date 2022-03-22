Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62524E48AC
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 22:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiCVVyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 17:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiCVVyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 17:54:38 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A73FD13
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 14:53:08 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h63so21804755iof.12
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 14:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vFNCv1Vr8OvmekoRzH2yHEY7eWdQSFzGbQ/jVxFV1Pw=;
        b=OwafGION9XNx5iJ+FIpHViBiUPmoZ4FjliC+4m74XYApqdlZkuEyNjNSuEBX80a2fc
         WR631sMh6E0R6J/z1xoc0Vkadt69+gPoAM9ThCFaFHI0MiTDL0+kDJW+ScuH6hLGmfFm
         IeVEVChB6N0yIJ2JaZ36TMpHGouMok+8eGrNHudhH0Ai0zap/v1kpkKq3aWlHe10UFas
         4+HUb82cG8o9XeyIiLqBqomSUiIDALmFgu9I8FjR7aG//80U5Uzt0yYmz5r7nsLdPKmi
         1E6wj18dqIjApDGjaKy0vfH5SBGnKgIjGH/0vFl+RgQi3TPazXCf38cN2aFAmR2/iFJO
         4Y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vFNCv1Vr8OvmekoRzH2yHEY7eWdQSFzGbQ/jVxFV1Pw=;
        b=nLJ4PnXkOJ84lnX5kqR+KQllft29LZ+NuBfm1lZxltUAFF8lR2ZUIjncJsMDWolYyr
         GaCaSxmN39olw/PAN5ziTC2LgevOM8knkVACOM8U/RREgFB7JDI0DHuEw95KOrwqVBJg
         /OAQTM5UTie+qfgCQXvrYF5WbHSTaVqzRwPgmxULiz/pHi/UlvT6QQpKEbkRI1DNgVQ+
         OGFu8Uy32geSm/WaYns+/zkbVUTQyUoXdqH3e4+qrwzc4L/WY+4e4luWujLrVN5TVMIZ
         DOqzvIHYl2NPKRGsKkseBwTlR18xUH6brdQ0xXXCuzG6mwp8zpbPys5cugKhswvrctBT
         OVww==
X-Gm-Message-State: AOAM533j+Xspa3ZK6LdD4K09fwLD+6SEGHnH3G+j0bhkZfNH9MD3DjwR
        G6+ECku+nNenjkEPEhp1HMJSTQ==
X-Google-Smtp-Source: ABdhPJzqLoix+c4kCfNCNxaGtlND7oeZuiJRxIXaRuZLrlLTmLRL3k5AMD85MQoZt0kZXWq6tXnKsA==
X-Received: by 2002:a05:6638:3285:b0:31a:25de:93dd with SMTP id f5-20020a056638328500b0031a25de93ddmr14376470jav.248.1647985987523;
        Tue, 22 Mar 2022 14:53:07 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id q7-20020a92ca47000000b002c7cd3d102fsm11915692ilo.68.2022.03.22.14.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:53:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 21:53:03 +0000
From:   Oliver Upton <oupton@google.com>
To:     "Franke, Daniel" <dff@amazon.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjpFP+APSqjU7fUi@google.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
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

Hi Daniel,

As we're venturing into the realm of timekeeping and he has noted
the evils of virtualization several times, I've CC'ed Thomas on this
mail. Some comments inline on the ongoing discussion.

On Tue, Mar 22, 2022 at 07:18:20PM +0000, Franke, Daniel wrote:
> On 3/21/22, 5:24 PM, "Oliver Upton" <oupton@google.com> wrote:
>  >  Right, but I'd argue that interface has some problems too. It
>  >   depends on the guest polling instead of an interrupt from the
>  >   hypervisor. It also has no way of informing the kernel exactly how much
>  >   time has elapsed.
> 
>  >   The whole point of all these hacks that we've done internally is that we,
>  >   the hypervisor, know full well how much real time hasv advanced during the
>  >   VM blackout. If we can at least let the guest know how much to fudge real
>  >   time, it can then poke NTP for better refinement. I worry about using NTP
>  >   as the sole source of truth for such a mechanism, since you'll need to go
>  >   out to the network and any reads until the response comes back are hosed.
> 
> (I'm a kernel newbie, so please excuse any ignorance with respect to kernel
> Internals or kernel/hypervisor interfaces.)

Welcome :-)

> We can have it both ways, I think. Let the hypervisor manipulate the guest TSC
> so as to keep the guest kernel's idea of real time as accurate as possible 
> without any awareness required on the guest's side. *Also* give the guest kernel
> a notification in the form of a KVM_PVCLOCK_STOPPED event or whatever else,
> and let the kernel propagate this notification to userspace so that the NTP
> daemon can recombobulate itself as quickly as possible, treating whatever TSC
> adjustment was received as best-effort only.

But what happens to CLOCK_MONOTONIC in this case? We are still accepting
the fact that live migrations destroy CLOCK_MONOTONIC if we directly
advance the guest TSCs to account for elapsed time. The definition of
CLOCK_MONOTONIC is that the clock does not count while the system is
suspended. From the viewpoint of the guest, a live migration appears to
be a forced suspend operation at an arbitrary instruction boundary.
There is no realistic way for the guest to give the illusion that
MONOTONIC has stopped without help from the hypervisor.

> The KVM_PVCLOCK_STOPPED event should trigger a change in some of the
> globals kept by kernel/time/ntp.c (which are visible to userspace through
> adjtimex(2)). In particular, `time_esterror` and `time_maxerror` should get reset
> to `NTP_PHASE_LIMIT` and time_status should get reset to `STA_UNSYNC`.

I do not disagree that NTP needs to throw the book out after a live
migration.

But, the issue is how we convey that to the guest. KVM_PVCLOCK_STOPPED
relies on the guest polling a shared structure, and who knows when the
guest is going to check the structure again? If we inject an interrupt
the guest is likely to check this state in a reasonable amount of time.

Thomas, we're talking about how to not wreck time (as bad) under
virtualization. I know this has been an area of interest to you for a
while ;-) The idea is that the hypervisor should let the guest know
about time travel.

Let's just assume for now that the hypervisor will *not* quiesce
the guest into an S2IDLE state before migration. I think quiesced
migrations are a good thing to have in the toolbelt, but there will
always be host-side problems that require us to migrate a VM off a host
immediately with no time to inform the guest.

Given that, we're deciding which clock is going to get wrecked during
a migration and what the guest can do afterwards to clean it up.
Whichever clock gets wrecked is going to have a window where reads race
with the eventual fix, and could be completely wrong. My thoughts:

We do not advance the TSC during a migration and notify the
guest (interrupt, shared structure) about how much it has
time traveled (delta_REALTIME). REALTIME is wrong until the interrupt
is handled in the guest, but should fire off all of the existing
mechanisms for a clock step. Userspace gets notified with
TFD_TIMER_CANCEL_ON_SET. I believe you have proposed something similar
as a way to make live migration less sinister from the guest
perspective.

It seems possible to block racing reads of REALTIME if we protect it with
a migration sequence counter. Host raises the sequence after a migration
when control is yielded back to the guest. The sequence is odd if an
update is pending. Guest increments the sequence again after the
interrupt handler accounts for time travel. That has the side effect of
blocking all realtime clock reads until the interrupt is handled. But
what are the value of those reads if we know they're wrong? There is
also the implication that said shared memory interface gets mapped
through to userspace for vDSO, haven't thought at all about those
implications yet.

Doing this the other way around (advance the TSC, tell the guest to fix
MONOTONIC) is fundamentally wrong, as it violates two invariants of the
monotonic clock. Monotonic counts during a migration, which really is a
forced suspend. Additionally, you cannot step the monotonic clock.

Thoughts?

Sorry to revisit this conversation yet again. Virtualization isn't going
away any time soon and the illusion that migrations are invisible to the
guest is simply not true.

--
Thanks,
Oliver
