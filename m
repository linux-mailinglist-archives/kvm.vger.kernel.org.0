Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AEA563CD9
	for <lists+kvm@lfdr.de>; Sat,  2 Jul 2022 01:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiGAXoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 19:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGAXoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 19:44:11 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2567B35271
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 16:44:10 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w83so5570230oiw.1
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 16:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jIxffP7lS6UhWOO9lVKxTqWwvB1Ai0ugY8fECrKU2ME=;
        b=nGN0eAtp7y9gHwM1weJlPFXjDE2ULoX1XW4R2kaR8yJHNr1FnpmDyIpWYDsQxwaTdH
         r2K6/ZUTzVgNbnSrKZVPI9OfUCb85kh4KYrv7dmYSyfczzyFgpe/rujm4EsymOXF4PyA
         q0jEH/90bRkI+JbMOr0jrZOLH6AknijgmTX1g79Gh1P3GZ3GW7LbbttoFg70L9bOJ8FX
         IQg4JAVzHPygIgbvQ61QKNXCj+N0FMv4Qqqcd3xiMm3fbUJjt6GMbJ6wMVRCERqm3Do6
         DYEZHwQmGNN5Un17GmNgiNeKK6kCOGSAhsl3zYuj6Au+96dZpFtwxUvV4CL83lHQYaz7
         KfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jIxffP7lS6UhWOO9lVKxTqWwvB1Ai0ugY8fECrKU2ME=;
        b=CTOr1L6AshGm5rlzrGpo5pCQ3b90a0or6qAVJYW2rIU5w/uCRv66JPKh9UWrbSp+qp
         kdHnMyGXemuI0oUAMB+naA7QAj1niSzE4GfUupSoDV09zMfxa6QgeuycRSj6LcLZ1h35
         if1t/mCwU9IxqvYlulqwrrwDo4yVGTzlX0vED3ps+2AX0zrGP1W/IgVNi4qoyQ+DxxHW
         H4wAOAegApQ5uuh+tKnwVWEMSWyxDJuvWT0V7UYYTo6hoDPweGqyusVfxVIbMuFEpZNN
         h4z8BZRqJuU/ZXqB0ElcaS9Rnmyy4ISJ3/73gBrtTq850nrAtMeiRnAUMs7fhw2WgIjS
         cgNg==
X-Gm-Message-State: AJIora/c7z3hr3E2g4HIL0iFrPpS5i5S3pV37GeJjAEeTkwP8R737pPP
        dJgcpYqFNBdscGIAM8ueUZzc5v7HA9c2kHYuCdjzIg==
X-Google-Smtp-Source: AGRyM1vMVGqeh0kobsUXsu0kXDtKYn8Rq0fdzhb+gjbLmKvoB3Xlqn5hHsVV8uFeP56GBsWEx2LfqGyTBUvTx+qMnZI=
X-Received: by 2002:a05:6808:3089:b0:32e:f7fd:627d with SMTP id
 bl9-20020a056808308900b0032ef7fd627dmr9984219oib.181.1656719049308; Fri, 01
 Jul 2022 16:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com> <20220606175248.1884041-2-aaronlewis@google.com>
In-Reply-To: <20220606175248.1884041-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Jul 2022 16:43:58 -0700
Message-ID: <CALMp9eT3U+kLJTJJ_QP66LQPTQywVTuxucx=7JU74Xb7=xeY0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jun 6, 2022 at 10:53 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When building an event list for the pmu event filter, fitting all the
> events in the limited space can be a challenge.  It becomes
> particularly challenging when trying to include various unit mask
> combinations for a particular event the guest is allow to or not allow
> to program.  Instead of increasing the size of the list to allow for
> these, add a new encoding in the pmu event filter's events field. These
> encoded events can then be used to test against the event the guest is
> attempting to program to determine if the guest should have access to
> it.
>
> The encoded values are: mask, match, and invert.  When filtering events
> the mask is applied to the guest's unit mask to see if it matches the
> match value (ie: unit_mask & mask == match).  If it does and the pmu
> event filter is an allow list the event is allowed, and denied if it's
> a deny list.  Additionally, the result is reversed if the invert flag
> is set in the encoded event.
>
> This feature is enabled by setting the flags field to
> KVM_PMU_EVENT_FLAG_MASKED_EVENTS.
>
> Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_EVENT().
>
> It is an error to have a bit set outside valid encoded bits, and calls
> to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in such cases,
> including bits that are set in the high nybble[1] for AMD if called on
> Intel.
>
> [1] bits 35:32 in the event and bits 11:8 in the eventsel.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  Documentation/virt/kvm/api.rst         |  46 +++++++--
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 +
>  arch/x86/include/uapi/asm/kvm.h        |   8 ++
>  arch/x86/kvm/pmu.c                     | 128 ++++++++++++++++++++++---
>  arch/x86/kvm/pmu.h                     |   1 +
>  arch/x86/kvm/svm/pmu.c                 |  12 +++
>  arch/x86/kvm/vmx/pmu_intel.c           |  12 +++
>  7 files changed, 190 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..4e904772da5b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5017,7 +5017,13 @@ using this ioctl.
>  :Architectures: x86
>  :Type: vm ioctl
>  :Parameters: struct kvm_pmu_event_filter (in)
> -:Returns: 0 on success, -1 on error
> +:Returns: 0 on success,
> +    -EFAULT args[0] cannot be accessed.
> +    -EINVAL args[0] contains invalid data in the filter or events field.
> +                    Note: event validation is only done for modes where
> +                    the flags field is non-zero.
> +    -E2BIG nevents is too large.
> +    -ENOMEM not enough memory to allocate the filter.
>
>  ::
>
> @@ -5030,14 +5036,42 @@ using this ioctl.
>         __u64 events[0];
>    };
>
> -This ioctl restricts the set of PMU events that the guest can program.
> -The argument holds a list of events which will be allowed or denied.
> -The eventsel+umask of each event the guest attempts to program is compared
> -against the events field to determine whether the guest should have access.
> +This ioctl restricts the set of PMU events the guest can program.  The
> +argument holds a list of events which will be allowed or denied.
> +
>  The events field only controls general purpose counters; fixed purpose
>  counters are controlled by the fixed_counter_bitmap.
>
> -No flags are defined yet, the field must be zero.
> +Valid values for 'flags'::
> +
> +``0``
> +
> +This is the default behavior for the pmu event filter, and used when the
> +flags field is clear.  In this mode the eventsel+umask for the event the
> +guest is attempting to program is compared against each event in the events
> +field to determine whether the guest should have access to it.
> +
> +``KVM_PMU_EVENT_FLAG_MASKED_EVENTS``
> +
> +In this mode each event in the events field will be encoded with mask, match,
> +and invert values in addition to an eventsel.  These encoded events will be
> +matched against the event the guest is attempting to program to determine
> +whether the guest should have access to it.  When matching an encoded event
> +with a guest event these steps are followed:
> + 1. Match the encoded eventsel to the guest eventsel.
> + 2. If that matches, match the mask and match values from the encoded event to
> +    the guest's unit mask (ie: unit_mask & mask == match).
> + 3. If that matches, the guest is allow to program the event if its an allow
> +    list or the guest is not allow to program the event if its a deny list.
> + 4. If the invert value is set in the encoded event, reverse the meaning of #3
> +    (ie: deny if its an allow list, allow if it's a deny list).

The invert flag introduces some ambiguity. What if a particular event
matches two of the masked filter entries: one with an invert flag and
one without?

> +To encode an event in the pmu_event_filter use
> +KVM_PMU_EVENT_ENCODE_MASKED_EVENT().
> +
> +If a bit is set in an encoded event that is not apart of the bits used for

Nit: "a part"?
