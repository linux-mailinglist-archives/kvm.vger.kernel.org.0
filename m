Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5B607DF2
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 19:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJURvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 13:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJURu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 13:50:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2E5275DDD
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 10:50:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h12so3094591pjk.0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 10:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdQVvxh/D4PbcURR4EnVNhyGztTcewiCaPhCdQoFyIs=;
        b=k1nOFp8yp3mtb4PfoSJ9DFXoKwqhsFYNwc18cFOOm8exHthjpAJDCa3mGHGZ746YZs
         s+rd8rfVU3Sj4gRgWsPxeaQGu5EaLpPT5cEfhUO6rtqjiVsn+LfN5LH5UbrklIs2/Ipl
         x5Mdwlpm1pwsdZ8d2sHuc//Z0PbTnJH84klYp64Ns+KqDUEkJ3ibeyNo6q4JD/RtaFVu
         WHtBq2kpKGv/l6uljqbGRIDXQrwirm8wbTDuo6nw+iWZPiIMr4RbyrY986gzWJqEjPkA
         TxuiHNZE9SxgNNDeBQ4T1CDrD7GOrTnO7CFaPcwxo/F4klf8h/ZokgPru/VadoEEpfnL
         0IwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdQVvxh/D4PbcURR4EnVNhyGztTcewiCaPhCdQoFyIs=;
        b=oCtoOhQSi7qMz3/G6GGglSyzIQCQJlEejLSELrqWD5VBhcEiu37XfquC4LOT/6vPlR
         S7MxQluvHEW7vI4DSch+ZnOJz9FbcgIfikpRbbFRkiJXUPf8wKrQeCaOPg8mCKroVqSK
         8sKfolz4QRoXfkTIJ+eyeEwGiO0VTrtg5o/Nrk8M1hAjlN81y/ZsyN+vu3xlrxM/rHBk
         c6iwwLYhWe0O7TTkev01NtMNzppzw0xKC3rmYf6ysd47LbO3H+EM3bVfeVzJNyO9nJfX
         WG2W0in+Dgy9IOr6add51+jDcTWGKJqbJwng5jFMIUz4R/DjiAaOIUmnlN+XRfjYPUle
         QDWA==
X-Gm-Message-State: ACrzQf11Ob2uuat6Clmq8bR/yJozPg0HXmADTbQ3kArhZz8QAfb/mlYG
        RDtFFTxx6DivgoGIEOC2iuPjRM05f0Z9eQ==
X-Google-Smtp-Source: AMsMyM4pJLhmAkopDaWvBlUFI5HTmeuhBhwtUs+YXpmR7aLZm5UhxXkgevgPhPLrA2pMSYe7v2FMmA==
X-Received: by 2002:a17:90b:1806:b0:20d:a753:7d4b with SMTP id lw6-20020a17090b180600b0020da7537d4bmr23929044pjb.160.1666374653881;
        Fri, 21 Oct 2022 10:50:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090a990300b0020b2082e0acsm1880013pjp.0.2022.10.21.10.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 10:50:52 -0700 (PDT)
Date:   Fri, 21 Oct 2022 17:50:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Y1Lb+bfaO1Y+skUD@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com>
 <Y0Q9ZFGQf1On/Cus@google.com>
 <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com>
 <Y02VRyrVu2Fh3ipS@google.com>
 <CAAAPnDFqkkEzixJGn39CqrZoAUBo8MbK7j1VorWT0U4cTSwSCQ@mail.gmail.com>
 <CAAAPnDGvnC4uP5Q_yio+m8Q-cu+5anZTLwYRpro9E+W=U5gcTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDGvnC4uP5Q_yio+m8Q-cu+5anZTLwYRpro9E+W=U5gcTA@mail.gmail.com>
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

On Fri, Oct 21, 2022, Aaron Lewis wrote:
> Here's what I came up with.  Let me know if this is what you were thinking:

A purely mechanical suggestions, but overall looks awesome! 

> static int filter_sort_cmp(const void *pa, const void *pb)
> {
>         u64 a = *(u64 *)pa & (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
>                               KVM_PMU_MASKED_ENTRY_EXCLUDE);
>         u64 b = *(u64 *)pb & (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
>                               KVM_PMU_MASKED_ENTRY_EXCLUDE);
> 
>         return (a > b) - (a < b);
> }
> 
> /*
>  * For the event filter, searching is done on the 'includes' list and
>  * 'excludes' list separately rather than on the 'events' list (which
>  * has both).  As a result the exclude bit can be ignored.
>  */
> static int filter_event_cmp(const void *pa, const void *pb)
> {
>         u64 a = *(u64 *)pa & KVM_PMU_MASKED_ENTRY_EVENT_SELECT;
>         u64 b = *(u64 *)pb & KVM_PMU_MASKED_ENTRY_EVENT_SELECT;
> 
>         return (a > b) - (a < b);
> }


To dedup code slightly and make this a little more readable, what about adding a
common helper to do the compare?  That also makes it quite obvious that the only
difference is the inclusion (heh) of the EXCLUDE flag.

static int filter_cmp(u64 *pa, u64 *pb, u64 mask)
{
        u64 a = *pa & mask;
        u64 b = *pb & mask;

        return (a > b) - (a < b);
}

static int filter_sort_cmp(const void *pa, const void *pb)
{
        return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
                                   KVM_PMU_MASKED_ENTRY_EXCLUDE);
}

/*
 * For the event filter, searching is done on the 'includes' list and
 * 'excludes' list separately rather than on the 'events' list (which
 * has both).  As a result the exclude bit can be ignored.
 */
static int filter_event_cmp(const void *pa, const void *pb)
{
        return filter_cmp(pa, pb, (KVM_PMU_MASKED_ENTRY_EVENT_SELECT);
}

> static bool filter_contains_match(u64 *events, u64 nevents, u64 eventsel)
> {
>         u64 event_select = eventsel & kvm_pmu_ops.EVENTSEL_EVENT;
>         u64 umask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
>         int i, index;
> 
>         index = find_filter_index(events, nevents, event_select);
>         if (index < 0)
>                 return false;
> 
>         /*
>          * Entries are sorted by the event select.  Walk the list in both
>          * directions to process all entries with the targeted event select.
>          */
>         for (i = index; i < nevents; i++) {
>                 if (filter_event_cmp(&events[i], &event_select) != 0)

Preferred kernel style is to omit comparisons against zero, i.e. just

		if (filter_event_cmp(&events[i], &event_select))
			break;

>                         break;
> 
>                 if (is_filter_entry_match(events[i], umask))
>                         return true;
>         }
> 
>         for (i = index - 1; i >= 0; i--) {
>                 if (filter_event_cmp(&events[i], &event_select) != 0)
>                         break;
> 
>                 if (is_filter_entry_match(events[i], umask))
>                         return true;
>         }
> 
>         return false;
> }
> 
> static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *filter,
>                                 u64 eventsel)
> {
>         if (filter_contains_match(filter->includes,
> filter->nr_includes, eventsel) &&
>             !filter_contains_match(filter->excludes,
> filter->nr_excludes, eventsel))
>                 return filter->action == KVM_PMU_EVENT_ALLOW;
> 
>         return filter->action == KVM_PMU_EVENT_DENY;

Might be worth using a single char for the filter param, e.g. 'f' yields:

static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *f,
                                u64 eventsel)
{
        if (filter_contains_match(f->includes, f->nr_includes, eventsel) &&
            !filter_contains_match(f->excludes, f->nr_excludes, eventsel))
                return f->action == KVM_PMU_EVENT_ALLOW;

        return f->action == KVM_PMU_EVENT_DENY;
}

> static void setup_filter_lists(struct kvm_x86_pmu_event_filter *filter)
> {
>         int i;
> 
>         for (i = 0; i < filter->nevents; i++) {
>                 if(filter->events[i] & KVM_PMU_MASKED_ENTRY_EXCLUDE)a

Space after the if

		if (filter-> ...)

>                         break;
>         }
> 
>         filter->nr_includes = i;
>         filter->nr_excludes = filter->nevents - filter->nr_includes;
>         filter->includes = filter->events;
>         filter->excludes = filter->events + filter->nr_includes;
> }
> 

...

> static void prepare_filter_events(struct kvm_x86_pmu_event_filter *filter)
> {
>         int i, j;
> 
>         if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
>                 return;
> 
>         for (i = 0, j = 0; i < filter->nevents; i++) {
>                 /*
>                  * Skip events that are impossible to match against a guest
>                  * event.  When filtering, only the event select + unit mask
>                  * of the guest event is used.

This is a good place for calling out that impossible filters can't be rejected
for backwards compatibility reasons.

>                  */
>                 if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
>                                           ARCH_PERFMON_EVENTSEL_UMASK))
>                         continue;
> 
>                 /*
>                  * Convert userspace events to a common in-kernel event so
>                  * only one code path is needed to support both events.  For
>                  * the in-kernel events use masked events because they are
>                  * flexible enough to handle both cases.  To convert to masked
>                  * events all that's needed is to add the umask_mask.

I think it's worth calling out this creates an "all ones" umask_mask, and that
EXCLUDE isn't supported.

>                  */
>                 filter->events[j++] =
>                         filter->events[i] |
>                         (0xFFULL << KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT);
>         }
> 
>         filter->nevents = j;
> }

...

> -       /* Restore the verified state to guard against TOCTOU attacks. */
> -       *filter = tmp;
> +       r = -EINVAL;
> +       if (!is_filter_valid(filter))
> +               goto cleanup;
> 
> -       remove_impossible_events(filter);
> +       prepare_filter_events(filter);
> 
>         /*
> -        * Sort the in-kernel list so that we can search it with bsearch.
> +        * Sort entries by event select so that all entries for a given
> +        * event select can be processed efficiently during filtering.
>          */
> -       sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
> +       sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
> +            filter_sort_cmp, NULL);
> +
> +       setup_filter_lists(filter);

The sort+setup should definitely go in a single helper.  Rather than have the
helpers deal with masked vs. legacy, what about putting that logic in a top-level
helper?  Then this code is simply:

	r = prepare_filter_lists(filter);
	if (r)
		goto cleanup;

And the helper names can be more explicit, i.e. can call out that they validate
a masked filter and convert to a masked filter.

E.g. (completely untested)

static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
{
        u64 mask = kvm_pmu_ops.EVENTSEL_EVENT |
                   KVM_PMU_MASKED_ENTRY_UMASK_MASK |
                   KVM_PMU_MASKED_ENTRY_UMASK_MATCH |
                   KVM_PMU_MASKED_ENTRY_EXCLUDE;
        int i;

        for (i = 0; i < filter->nevents; i++) {
                if (filter->events[i] & ~mask)
                        return false;
        }

        return true;
}
static void convert_to_masked_filter(struct kvm_x86_pmu_event_filter *filter)
{
        int i, j;

        for (i = 0, j = 0; i < filter->nevents; i++) {
                /*
                 * Skip events that are impossible to match against a guest
                 * event.  When filtering, only the event select + unit mask
                 * of the guest event is used.  To maintain backwards
                 * compatibility, impossible filters can't be rejected :-(
                 */
                if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
                                          ARCH_PERFMON_EVENTSEL_UMASK))
                        continue;
                /*
                 * Convert userspace events to a common in-kernel event so
                 * only one code path is needed to support both events.  For
                 * the in-kernel events use masked events because they are
                 * flexible enough to handle both cases.  To convert to masked
                 * events all that's needed is to add an "all ones" umask_mask,
                 * (unmasked filter events don't support EXCLUDE).
                 */
                filter->events[j++] = filter->events[i] |
                                      (0xFFULL << KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT);
	}

        filter->nevents = j;
}

static int prepare_filter_lists(struct kvm_x86_pmu_event_filter *filter)
{
        int i;

        if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
                convert_to_masked_filter(filter)
        else if (!is_masked_filter_valid(filter))
                return -EINVAL;

        /*
         * Sort entries by event select and includes vs. excludes so that all
         * entries for a given event select can be processed efficiently during
         * filtering.  The EXCLUDE flag uses a more significant bit than the
         * event select, and so the sorted list is also effectively split into
         * includes and excludes sub-lists.
         */
        sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
             filter_sort_cmp, NULL);

        /* Find the first EXCLUDE event (only supported for masked events). */
        if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
                for (i = 0; i < filter->nevents; i++) {
                        if (filter->events[i] & KVM_PMU_MASKED_ENTRY_EXCLUDE)
                                break;
                }
        }

        filter->nr_includes = i;
        filter->nr_excludes = filter->nevents - filter->nr_includes;
        filter->includes = filter->events;
        filter->excludes = filter->events + filter->nr_includes;
}
