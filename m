Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AA369FB8
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbfGPAKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 20:10:47 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44871 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbfGPAKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 20:10:47 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so17095718edr.11
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 17:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TuRNoOkVfCigw2Wuxe3UI/VXS3zxgaiTK+rQEL9mkw=;
        b=X/lLfEmtOPhgzR9DUEsjJjuG5SasTk1hdZSopvddMrr6Vcm9O8K8p7MrHX42jSHP8I
         Rx/Dz3masCIvmwkN0lqgILNwGErRuEgGdySqyRkXWvOptFRMuQlYczwmrv6x8l9FsLrn
         jeVytrwjfkWoYAhOjvEQq1Cghv3JWsinNOb4fHC/YVMwiLkU0+tRq+zSnSLanJsRM/Iu
         vzhL25p9JSKEeFDa9fWyu1Zc0IdiRFh8TBDQT+MQwu+AZ+smN8mpE2Ewqa5Y3t8VZoJ1
         ZSTTE4XITYetKccfa/zD40BA4iEyKgTzpaHb4c1Jx/ojjt7dWSqTLWN4gU6CBGwkm5kk
         sj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4TuRNoOkVfCigw2Wuxe3UI/VXS3zxgaiTK+rQEL9mkw=;
        b=rVTkKzVvcn84hp4+B0BgKBIwgHcBTdtMqZGlfI4qBkaW2oicRRQaqmB6mxsi1pLYFv
         HXwP11pTYm+gRTMp7VN3FmtnfRC4qNPpVviBxsPTq6ZqFvTKk5s9FMyud5ymJC+Gm7XK
         pioBpWaMCxeT2G30aOWUPMlooOrM99o3cqEUGouTVvjxrIW2oe3GI03Wt8hghHZ6vTcF
         9qdoeQu9IjqU1fFlHdHMw8NXknrefzewVMFftcL61904vrwTrY8ZZjGtvjIOfbIazsVm
         qBvzgyARLxTDlBGT6Pd6Gpvdq4TT9Ooh0tZFlURq6Ur068dTF/Bs6oM3qNaVdpiJZJSA
         anAw==
X-Gm-Message-State: APjAAAUXa1CbQwV7MuDNEiIJxEpfqqnu16ZmwR7EsD9o8lHTNvjV7NHh
        PiNKe1MzoayISkD9WIubH2fhqCXh5dj87Lccdw3nDw==
X-Google-Smtp-Source: APXvYqx/gW5mUFTFQ2dxFq7BZJg+MSLr0owyUAdpNjN8J5d0UL6/bimFkuLU5MbxXB1DVPLAD3VhWbGpUg1L4udN49E=
X-Received: by 2002:a17:906:d7ab:: with SMTP id pk11mr22960862ejb.216.1563235845844;
 Mon, 15 Jul 2019 17:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
 <5D27FE26.1050002@intel.com>
In-Reply-To: <5D27FE26.1050002@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Mon, 15 Jul 2019 17:10:34 -0700
Message-ID: <CAOyeoRV5=6pR7=sFZ+gU68L4rORjRaYDLxQrZb1enaWO=d_zpA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I think just disabling guest cpuid might not be enough, since guest
> could write to the msr without checking the cpuid.
>
> Why not just add a bitmap for fixed counter?
> e.g. fixed_counter_reject_bitmap
>
> At the beginning of reprogram_fixed_counter, we could add the check:
>
> if (test_bit(idx, &kvm->arch.fixed_counter_reject_bitmap))
>      return -EACCES;
>
> (Please test with your old guest and see if they have issues if we
> inject #GP when
> they try to set the fixed_ctrl msr. If there is, we could drop -EACCESS
> above)
>
> The bitmap could be set at kvm_vm_ioctl_set_pmu_event_filter.

intel_pmu_refresh() checks the guest cpuid and sets the number of
fixed counters according to that:
pmu->nr_arch_fixed_counters = min_t(int, edx.split.num_counters_fixed,
INTEL_PMC_MAX_FIXED);

and reprogram_fixed_counters()/get_fixed_pmc() respect this so the
guest can't just ignore the cpuid.

Adding a bitmap does let you do things like disable the first counter
but keep the second and third, but given that there are only three and
the events are likely to be on a whitelist anyway, it seemed like
adding the bitmap wasn't worth it. If you still feel the same way even
though we can disable them via the cpuid, I can add this in.

> I think it would be better to add more, please see below:
>
> enum kvm_pmu_action_type {
>      KVM_PMU_EVENT_ACTION_NONE = 0,
>      KVM_PMU_EVENT_ACTION_ACCEPT = 1,
>      KVM_PMU_EVENT_ACTION_REJECT = 2,
>      KVM_PMU_EVENT_ACTION_MAX
> };
>
> and do a check in kvm_vm_ioctl_set_pmu_event_filter()
>      if (filter->action >= KVM_PMU_EVENT_ACTION_MAX)
>          return -EINVAL;
>
> This is for detecting the case that we add a new action in
> userspace, while the kvm hasn't been updated to support that.
>
> KVM_PMU_EVENT_ACTION_NONE is for userspace to remove
> the filter after they set it.

We can achieve the same result by using a reject action with an empty
set of events - is there some advantage to "none" over that? I can add
that check for valid actions.

> > +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
>
> Why is this limit needed?

Serves to keep the filters on the smaller side and ensures the size
calculation can't overflow if users attempt to. Keeping the filter
under 4k is nicer for allocation - also, if we want really large
filters we might want to do something smarter than a linear traversal
of the filter when guests program counters.

> I think it looks tidier to wrap the changes above into a function:
>
>      if (kvm_pmu_filter_event(kvm, eventsel & AMD64_RAW_EVENT_MASK_NB))
>          return;

Okay - I can do that.

> > +       kvfree(filter);
>
> Probably better to have it conditionally?
>
> if (filter) {
>      synchronize_srcu();
>      kfree(filter)
> }
>
> You may want to factor it out, so that kvm_pmu_destroy could reuse.

Do you mean kvm_arch_destroy_vm? It looks like that's where kvm_arch
members are freed. I can do that.

Eric
