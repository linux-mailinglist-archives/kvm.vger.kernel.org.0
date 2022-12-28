Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A8658696
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 21:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiL1UBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 15:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiL1UA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 15:00:58 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAFCF58F
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:00:57 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id o8so8689514ilq.6
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y/T/jK3z7t9FcrBI149LgjuMzHi7d8aNsFjY+zQENqQ=;
        b=HGPW8zffhEmYsCCYVTGEVaSbHzw3EmUQTBToSHiV74redtjp6oNxm9VChaFQSg/ope
         nm/9Cw8hmsQp+2lWxK6Wsfc4J4hdU+5EZRkHU4U6i883gk6MRe8qO8uy8SKrsS27pgtm
         zNeR2UL5yKkE17e94hxEJOND0JotpIzFN+2AMj63GB0h0oZysPiZMI/z5TKhN1ijFLtv
         kBB+jyYIaOtY3W0SFAhmtxXsVr5hqtNYoM0cjOtVAb+Eo4vIcgZZax3ZUqcqO9dCzj20
         yD3gPltzhbOSyAXSShNVvjMel+yLNFHoC9Wjk4XA6Gakdb3XTMuqcboVvIEFmCEATtLG
         rGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/T/jK3z7t9FcrBI149LgjuMzHi7d8aNsFjY+zQENqQ=;
        b=gwpHo/gb5rz1GHBy2R8mlZFFcNW7H+VHE/c3qM1aYsx8V6YA46O4BbcJCDikFVEQsC
         O7IgmJWDYBUo4hMBhuMsYY0BdTuMQIkikMlVBltIj8RtaKGfntkiiiacv8pFW3LJ6Kda
         oUZcCeuc0XfHLWA4Zu7fwKKz10z4PofuZ2Kx20aKBSPKkEs8aTLvh7q/+xgnT2tR3dhE
         Wd14Bl4k0dj9xV2I7BRIjFg9lu1JCAcxLjjhDPaAQ51cRRB/e3k7vt5l8VDDwLq8MFKA
         OYwSm4tXe/uxUSc9i8suu8cSZfoimuVFbeNchfvNcKaJRu+jUMs7YXTBamvUuNTI5+zD
         ItFQ==
X-Gm-Message-State: AFqh2kr48L9kZc74t+hkZLwFY5iDJ1pA2FnNBi6aLjw4aNihMQQUflUs
        xBL0td/iVSvFmqtNrbEqgj1rAgw0+vSKJTO4nSUr6w==
X-Google-Smtp-Source: AMrXdXsi4/jorXgfytcsg+s3dv1QtBdtuMhAPA+Z83odavbwghHmrxYcykDxV3n5KhkMRQk/wvVpwopHyfL3U2J0Azk=
X-Received: by 2002:a92:dcca:0:b0:303:26c0:e1fe with SMTP id
 b10-20020a92dcca000000b0030326c0e1femr2308558ilr.102.1672257656834; Wed, 28
 Dec 2022 12:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-5-aaronlewis@google.com> <cd594bd5-8f71-7d49-779a-2a19a99a1e5d@gmail.com>
In-Reply-To: <cd594bd5-8f71-7d49-779a-2a19a99a1e5d@gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 28 Dec 2022 20:00:45 +0000
Message-ID: <CAAAPnDGBHLskANDDrwvK7VdGp-08J6Lc8KfAUKds-CqCh_1mnQ@mail.gmail.com>
Subject: Re: [PATCH v8 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

> >
> > It is an error to have a bit set outside the valid bits for a masked
> > event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
> > such cases, including the high bits of the event select (35:32) if
> > called on Intel.
>
> Some users want to count Intel TSX events and their VM instances needs:
>
> #define HSW_IN_TX                                       (1ULL << 32)
> #define HSW_IN_TX_CHECKPOINTED                          (1ULL << 33)

The purpose of the PMU event filter is to restrict events based solely
on the event select + unit mask.  What the guest decides to do with
HSW_IN_TX and HSW_IN_TX_CHECKPOINTED is done at their discretion and
the PMU event filter should not be involved.

Patch 1/7 in this series fixes a bug to ensure that's true, then the
next patch removes events from the PMU event filter that attempts to
filter bits outside the event select + unit mask.  Masked events take
this one step farther by rejecting the entire filter and returning an
error if there are invalid bits set in any of the events.
Unfortunately legacy events weren't implemented that way so removing
events is the best we can do.

> >
> > With these updates the filter matching code has been updated to match on
> > a common event.  Masked events were flexible enough to handle both event
> > types, so they were used as the common event.  This changes how guest
> > events get filtered because regardless of the type of event used in the
> > uAPI, they will be converted to masked events.  Because of this there
> > could be a slight performance hit because instead of matching the filter
>
> Bonus, if this performance loss is quantified, we could make a side-by-side
> comparison of alternative solutions, considering wasting memory seems to
> be a habit of many kernel developers.
>
> > event with a lookup on event select + unit mask, it does a lookup on event
> > select then walks the unit masks to find the match.  This shouldn't be a
> > big problem because I would expect the set of common event selects to be
>
> A quick rough statistic about Intel PMU based on
> https://github.com/intel/perfmon.git:
> our filtering mechanism needs to consider 388 different EventCode and 183 different
> UMask, prioritizing filtering event_select will instead bring more entries.

I don't see how we could end up with more entries considering the
pathological case would result in the same number of filter entries as
before.

How did you come up with 388 event selects and 183 different unit
masks?  Are those all from the same uarch?

>
> > small, and if they aren't the set can likely be reduced by using masked
> > events to generalize the unit mask.  Using one type of event when
> > filtering guest events allows for a common code path to be used.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst  |  77 +++++++++++--
> >   arch/x86/include/asm/kvm_host.h |  14 ++-
> >   arch/x86/include/uapi/asm/kvm.h |  29 +++++
> >   arch/x86/kvm/pmu.c              | 197 +++++++++++++++++++++++++++-----
> >   arch/x86/kvm/x86.c              |   1 +
> >   include/uapi/linux/kvm.h        |   1 +
> >   6 files changed, 281 insertions(+), 38 deletions(-)
> >
>
> ...
>
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 312aea1854ae..d2023076f363 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4401,6 +4401,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_SPLIT_IRQCHIP:
> >       case KVM_CAP_IMMEDIATE_EXIT:
> >       case KVM_CAP_PMU_EVENT_FILTER:
> > +     case KVM_CAP_PMU_EVENT_MASKED_EVENTS:
>
> How about reusing KVM_CAP_PMU_CAPABILITY to advertise this new cap ?

The purpose of KVM_CAP_PMU_CAPABILITY is to allow userspace to adjust
the PMU virtualization capabilities on a VM.
KVM_CAP_PMU_EVENT_MASKED_EVENTS isn't meant to be adjustable, but
rather advertise that this feature exists.

>
> >       case KVM_CAP_GET_MSR_FEATURES:
> >       case KVM_CAP_MSR_PLATFORM_INFO:
> >       case KVM_CAP_EXCEPTION_PAYLOAD:
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 20522d4ba1e0..0b16b9ed3b23 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> >   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> > +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> >
> >   #ifdef KVM_CAP_IRQ_ROUTING
> >
