Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9DB62E4F7
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiKQTHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbiKQTHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:07:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776586A68
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:07:35 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o7so2494282pjj.1
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMKfx1XWJdsECghxNEdFj4rN8LAvihulr1vhxX9fplg=;
        b=nYyQO/LgWbggMUZ8dShi81p6oKepCHOdAiLITo6Q3QoDk/ceRQ2P9QZnZIMGVqzbhy
         F4WbzxVdqiSPxN3dpAIZ9DD0LVwPpPUC942kYzxwJc9ltUm3RkMgmRL5hsUnhgiEYE3M
         j+zMmQ8dCGeHwS5WQw1RUv5gNm8Pzq0TIe3nwqLVSLOZgkRrGgOULYe6+arKVk/5/i+o
         rkZqfpLgaJVXm2BixgxU46sRdIURF5BKDJWjM4zVICTSRy84qHjYp8ZKLRsv6m9BZg9g
         Z76S2Z2vjfR/1gZujTpLFk2r6YSfLaIh7iqlq35/DgnJ10VfcsZbl4gymKYa5G0dvEzs
         qcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMKfx1XWJdsECghxNEdFj4rN8LAvihulr1vhxX9fplg=;
        b=30x9ECnaeyD346MEHsFM5X++7vxoOcpIs3mdXzGLVY/TnrBmG6V6jik3vPa817r7t8
         W1Usc9yZguwQjBDNSWh5FCW4fwyi70ulsOxXAIDITDM0giZAFe9m9Cfp6DANv+joykoW
         IZYEY5Dy2bEtZXF7/qV4VIDvmWcUoIb3/EFgVi71Q2RX/LubEYngNdVBvo8Zt0ZKI0Fo
         +6+UmvYtguK7aE9Q2/b/dE1mKOjOHsC7R9CTh2hSRQtxAeLV9xRNL1trfr1q6ZgdKq4I
         zP2eEV1dkQxQ+mBLfIyTBnXrLnjq09rK03ExO8FyCOLGUAAp6/xwQkIVNaXxkgvPlL+0
         Ecaw==
X-Gm-Message-State: ANoB5plRyxwh4Te/nWWl92RCKm5Azglaa1/oLjq0vOUONGacnygw2JMc
        pNyshghdiW3F6UhhXb5fUhMegJGnNajfbA==
X-Google-Smtp-Source: AA0mqf6CmKJvpbtsqT0J3E7LDrFDV2TqlqRCm0HrW/cf+XEb7tnzQMjhgixS02w0GmLf7dBg+/leow==
X-Received: by 2002:a17:902:d711:b0:17f:8642:7cb9 with SMTP id w17-20020a170902d71100b0017f86427cb9mr3932653ply.174.1668712054459;
        Thu, 17 Nov 2022 11:07:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ce8f00b00172951ddb12sm1840344plg.42.2022.11.17.11.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:07:33 -0800 (PST)
Date:   Thu, 17 Nov 2022 19:07:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
Message-ID: <Y3aGcvJRMNnmCpMq@google.com>
References: <20221103204421.1146958-1-dmatlack@google.com>
 <Y2l247/1GzVm4mJH@google.com>
 <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
 <Y3ZjzZdI6Ej6XwW4@google.com>
 <323bc39e-5762-e8ae-6e05-0bc184bc7b81@redhat.com>
 <Y3ZpfU3pWBNyqfoL@google.com>
 <CALzav=eJ5ShR5d1hPNWZHcCyn8iHx7tYo9RC=wCMhnNEBnyyNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eJ5ShR5d1hPNWZHcCyn8iHx7tYo9RC=wCMhnNEBnyyNw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, David Matlack wrote:
> On Thu, Nov 17, 2022 at 9:04 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Nov 17, 2022, Paolo Bonzini wrote:
> > > On 11/17/22 17:39, Sean Christopherson wrote:
> > > > Right, what I'm saying is that this approach is still sub-optimal because it does
> > > > all that work will holding mmu_lock for write.
> > > >
> > > > > Also, David's test used a 10-second halving time for the recovery thread.
> > > > > With the 1 hour time the effect would Perhaps the 1 hour time used by
> > > > > default by KVM is overly conservative, but 1% over 10 seconds is certainly a
> > > > > lot larger an effect, than 1% over 1 hour.
> > > >
> > > > It's not the CPU usage I'm thinking of, it's the unnecessary blockage of MMU
> > > > operations on other tasks/vCPUs.  Given that this is related to dirty logging,
> > > > odds are very good that there will be a variety of operations in flight, e.g.
> > > > KVM_GET_DIRTY_LOG.  If the recovery ratio is aggressive, and/or there are a lot
> > > > of pages to recover, the recovery thread could hold mmu_lock until a reched is
> > > > needed.
> > >
> > > If you need that, you need to configure your kernel to be preemptible, at
> > > least voluntarily.  That's in general a good idea for KVM, given its
> > > rwlock-happiness.
> >
> > IMO, it's not that simple.  We always "need" better live migration performance,
> > but we don't need/want preemption in general.
> >
> > > And the patch is not making it worse, is it?  Yes, you have to look up the
> > > memslot, but the work to do that should be less than what you save by not
> > > zapping the page.
> >
> > Yes, my objection  is that we're adding a heuristic to guess at userspace's
> > intentions (it's probably a good guess, but still) and the resulting behavior isn't
> > optimal.  Giving userspace an explicit knob seems straightforward and would address
> > both of those issues, why not go that route?
> 
> In this case KVM knows that zapping dirty-tracked pages is completely
> useless, regardless of what userspace is doing, so there's no
> guessing.
> 
> A userspace knob requires userspace guess at KVM's implementation
> details. e.g. KVM could theoretically support faulting in read
> accesses and execute accesses as write-protected huge pages during
> dirty logging. Or KVM might supporting 2MiB+ dirty logging. In both
> cases a binary userspace knob might not be the best fit.

Hmm, maybe.  If userspace is migrating a VM, zapping shadow pages to try and
allow NX huge pages may be undesirable irrespective of KVM internals.  E.g. even
if KVM supports 2MiB dirty logging, zapping an entire 2MiB region of guest memory
to _maybe_ install a huge page while the guest is already likely experiencing
jitter is probably a net negative.

I do agree that they are somewhat complimentary though, e.g. even if userspace is
aware of the per-VM knob, userspace might want to allow reaping during migration
for whatever reason.  Or conversely, userspace might want to temporarily disable
reaping for reasons completely unrelated to migration.

> I agree that, even with this patch, KVM is still suboptimal because it
> is holding the MMU lock to do all these checks. But this patch should
> at least be a step in the right direction for reducing customer
> hiccups during live migration.

True.

> Also as for the CPU usage, I did a terrible job of explaining the
> impact. It's a 1% increase over the current usage, but the current
> usage is extremely low even with my way overly aggressive settings.
> Specifically, the CPU usage of the NX recovery worker increased from
> 0.73 CPU-seconds to 0.74 CPU-seconds over a 2.5 minute runtime.

Heh, that does change things a bit.

Objection officially withdrawn, allowing userspace to turn off the reaper can be
done on top if it actually adds value.
