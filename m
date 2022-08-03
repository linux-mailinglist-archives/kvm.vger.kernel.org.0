Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C012588519
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 02:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiHCATV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 20:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiHCATS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 20:19:18 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102A925C78
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 17:19:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z19so14934790plb.1
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 17:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nDpU8F4w37LYcotVtuXi06SKnn7zR4QOY+/excmFPgc=;
        b=psG8frsMFn52Dg/49v4PhTZMMYynQzeRNL125zx+UveMHd+OhYXrEfvkLBjUAA4EXk
         Lm20iu/etz2KISa7ulTKGVkWAOQGAYyWxyuLfuDN/1TJkhbjvWZWmPmdZ7gLlgV+4eee
         52GDWN6ORjndclXFldLoFY9Fo4G74UUdtgyzZKEyDb8OozTLORYr0lgUsU3iFn4WWnac
         x567AmWZ2NmurNNg0Tfihb8T1AlmyvgefhjKbEABqtgJUAuP0e05iZu9X2Isd/AEWWzD
         YF4bZtzMgOa74mBzJ35Py8ASkJORKCWGIADMhag5czf1LsMlNlpK1LOBn7eGLbiN/195
         pDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nDpU8F4w37LYcotVtuXi06SKnn7zR4QOY+/excmFPgc=;
        b=mJSODAQmKg0UfUt2IXt5b4VHgaAvluBZScx+E/KiOszKYys40OStBA4YGZzPKc3Nmq
         RTKRhr18B7Xdd5QTs+txRzpZX5F5Hok6vdukm1BeI9cnMJEvRBfIKycqZmILNxqXlmZx
         lR5vX7vRrIdDx8P0NnRfR87z+oMJ5zfP5v+YsiG/B2ANFjF1LcmW8KVFylJBopq7wvUa
         WfLMftLBn6xNpEAVj83QnrbS2rvj6b6kxPbdGC7i28t74imHEDvT+wxNpq4FhdCpRKvh
         hAHECsgTCfcQvFV8r9w7xhu7lOZWDwJQ1goK+mOTfyj1dHbRiwXgC4kXONSc5PjxRDpb
         2AKA==
X-Gm-Message-State: ACgBeo1Bjc16rCRnp4UeBZMFrs1Ec7t9sZRQt1FtLs372VleGXVYEvun
        YRDvA7VB6uu4PscHy8z/DeM5N5Q1zFCV6HPGvOeW9A==
X-Google-Smtp-Source: AA6agR5eqlbqsE7IRNm6Z3B2mnLlUr+2LpAuiLR/h7NBZPZ9R6f8K73/TivudZm+/tC2rXxqTpAiViNeTiqCj19KEXM=
X-Received: by 2002:a17:902:988a:b0:16e:d52a:cce4 with SMTP id
 s10-20020a170902988a00b0016ed52acce4mr16886484plp.127.1659485956065; Tue, 02
 Aug 2022 17:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com> <20220709011726.1006267-2-aaronlewis@google.com>
In-Reply-To: <20220709011726.1006267-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 2 Aug 2022 17:19:04 -0700
Message-ID: <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Fri, Jul 8, 2022 at 6:17 PM Aaron Lewis <aaronlewis@google.com> wrote:
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
> match value (ie: unit_mask & mask == match).  The invert bit can then
> be used to exclude events from that match.  For example, if it is easier
> to say which events shouldn't be filtered, an encoded event can be set
> up to match all possible unit masks for a particular eventsel, then
> another encoded event can be set up to match the unit masks that
> shouldn't be filtered by setting the invert bit in that encoded event.
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

I think there is some confusion in the documentation and the code
regarding what an 'eventsel' is. Yes, Intel started it, with
"performance event select registers" that contain an "event select"
field, but the 64-bit object you refer to as an 'event' here in the
commit message is typically referred to as an 'eventsel' in the code
below. Maybe it's too late to avoid confusion, but I'd suggest
referring to the 64-bit object as a "PMU event filter entry," or
something like that.

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 21614807a2cb..2964f3f15fb5 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -522,6 +522,14 @@ struct kvm_pmu_event_filter {
>  #define KVM_PMU_EVENT_ALLOW 0
>  #define KVM_PMU_EVENT_DENY 1
>
> +#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS (1u << 0)

This can be BIT(0).

> +#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
> +               (((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
> +               (((mask) & 0xfful) << 24) | \
> +               (((match) & 0xfful) << 8) | \
> +               (((invert) & 0x1ul) << 23))

Please convert the masks and shifts to GENMASK_ULL().

>  /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3f868fed9114..99c02bbb8f32 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -197,14 +197,106 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>         return true;
>  }
>
> -static int cmp_u64(const void *pa, const void *pb)
> +static inline u64 get_event(u64 eventsel)
> +{
> +       return eventsel & AMD64_EVENTSEL_EVENT;
> +}
> +
> +static inline u8 get_unit_mask(u64 eventsel)
> +{
> +       return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> +}
> +
> +static inline u8 get_counter_mask(u64 eventsel)
>  {
> -       u64 a = *(u64 *)pa;
> -       u64 b = *(u64 *)pb;
> +       return (eventsel & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
> +}

In a raw PMU event, this field is the counter mask, but in an event
filter object, it's the "unit-mask mask."
> +
> +static inline bool get_invert_comparison(u64 eventsel)
> +{
> +       return !!(eventsel & ARCH_PERFMON_EVENTSEL_INV);
> +}

You can drop the !! and parentheses. Scalar to boolean conversion does
the right thing.

> +static inline int cmp_safe64(u64 a, u64 b)
> +{
>         return (a > b) - (a < b);
>  }
>
> +static int cmp_eventsel_event(const void *pa, const void *pb)
> +{
> +       return cmp_safe64(*(u64 *)pa & AMD64_EVENTSEL_EVENT,
> +                         *(u64 *)pb & AMD64_EVENTSEL_EVENT);
> +}
> +
> +static int cmp_u64(const void *pa, const void *pb)
> +{
> +       return cmp_safe64(*(u64 *)pa,
> +                         *(u64 *)pb);

Nit: join these lines.

> +}
> +
> +static inline bool is_match(u64 masked_event, u64 eventsel)
> +{
> +       u8 mask = get_counter_mask(masked_event);
> +       u8 match = get_unit_mask(masked_event);
> +       u8 unit_mask = get_unit_mask(eventsel);
> +
> +       return (unit_mask & mask) == match;
> +}
> +
> +static inline bool is_inverted(u64 masked_event)
> +{
> +       return get_invert_comparison(masked_event);
> +}
> +
> +static bool is_filtered(struct kvm_pmu_event_filter *filter, u64 eventsel,
> +                       bool invert)
> +{
> +       u64 key = get_event(eventsel);
> +       u64 *event, *evt;
> +
> +       event = bsearch(&key, filter->events, filter->nevents, sizeof(u64),
> +                       cmp_eventsel_event);
> +
> +       if (event) {
> +               /* Walk the masked events backward looking for a match. */
> +               for (evt = event; evt >= filter->events &&
> +                    get_event(*evt) == get_event(eventsel); evt--)

Replace get_event(eventsel) with key.

> +                       if (is_inverted(*evt) == invert && is_match(*evt, eventsel))
> +                               return true;
> +
> +               /* Walk the masked events forward looking for a match. */
> +               for (evt = event + 1;
> +                    evt < (filter->events + filter->nevents) &&
> +                    get_event(*evt) == get_event(eventsel); evt++)

Replace get_event(eventsel) with key.

> +                       if (is_inverted(*evt) == invert && is_match(*evt, eventsel))
> +                               return true;
> +       }
> +
> +       return false;
> +}
>
> +static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
> +                                    u64 eventsel)
> +{
> +       if (is_filtered(filter, eventsel, /*invert=*/false))
> +               if (!is_filtered(filter, eventsel, /*invert=*/true))

Perhaps you could eliminate the ugly parameter comments if you
maintained the "normal" and inverted entries in separate lists. It
might also speed things up for the common case, assuming that inverted
entries are uncommon.

> +                       return filter->action == KVM_PMU_EVENT_ALLOW;
> +
> +       return filter->action == KVM_PMU_EVENT_DENY;
> +}
> +
> +static bool allowed_by_default_events(struct kvm_pmu_event_filter *filter,
> +                                   u64 eventsel)
> +{
> +       u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> +
> +       if (bsearch(&key, filter->events, filter->nevents,
> +                   sizeof(u64), cmp_u64))
> +               return filter->action == KVM_PMU_EVENT_ALLOW;
> +
> +       return filter->action == KVM_PMU_EVENT_DENY;
> +}
> +
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  {
>         u64 config;
> @@ -226,14 +318,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>
>         filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
>         if (filter) {
> -               __u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> -
> -               if (bsearch(&key, filter->events, filter->nevents,
> -                           sizeof(__u64), cmp_u64))
> -                       allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> -               else
> -                       allow_event = filter->action == KVM_PMU_EVENT_DENY;
> +               allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
> +                       allowed_by_masked_events(filter, eventsel) :
> +                       allowed_by_default_events(filter, eventsel);

If you converted all of the legacy filters into masked filters by
simply setting the mask field to '0xff' when copying from userspace,
you wouldn't need the complexity of two different matching algorithms.

>         }
> +
>         if (!allow_event)
>                 return;
>
> @@ -572,8 +661,22 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>  }
>  EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
>
> +static int has_invalid_event(struct kvm_pmu_event_filter *filter)
> +{
> +       u64 event_mask;
> +       int i;
> +
> +       event_mask = static_call(kvm_x86_pmu_get_event_mask)(filter->flags);
> +       for (i = 0; i < filter->nevents; i++)
> +               if (filter->events[i] & ~event_mask)
> +                       return true;
> +
> +       return false;
> +}
> +
>  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  {
> +       int (*cmp)(const void *a, const void *b) = cmp_u64;
>         struct kvm_pmu_event_filter tmp, *filter;
>         size_t size;
>         int r;
> @@ -585,7 +688,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>             tmp.action != KVM_PMU_EVENT_DENY)
>                 return -EINVAL;
>
> -       if (tmp.flags != 0)
> +       if (tmp.flags & ~KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
>                 return -EINVAL;
>
>         if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
> @@ -603,10 +706,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>         /* Ensure nevents can't be changed between the user copies. */
>         *filter = tmp;
>
> +       r = -EINVAL;
> +       /* To maintain backwards compatibility don't validate flags == 0. */
> +       if (filter->flags != 0 && has_invalid_event(filter))
> +               goto cleanup;
> +
> +       if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
> +               cmp = cmp_eventsel_event;
> +
>         /*
>          * Sort the in-kernel list so that we can search it with bsearch.
>          */
> -       sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
> +       sort(&filter->events, filter->nevents, sizeof(u64), cmp, NULL);

I don't believe two different comparison functions are necessary. In
the legacy case, when setting up the filter, you should be able to
simply discard any filter entries that have extraneous bits set,
because they will never match.

>         mutex_lock(&kvm->lock);
>         filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
