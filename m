Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB63B489EE4
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiAJSNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238835AbiAJSNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 13:13:17 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C11C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 10:13:17 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r7-20020a05683001c700b005906f5b0969so15931464ota.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 10:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCOEFDLZBS+/9rJrWV/7tVxv/zMpTonWQ+Qpoz14kZ8=;
        b=cYb0SBfF8xNxq4k/lKVKn6C16kNoEHZ3B7TflcGZU21dmff1lVhtXYQ8s9rMUD6jLb
         MNeS7mmVfuSySopk10ask/LoN6+UEv6HBnV2QZZU6CQtYZaQMUBgks6Ws2m0m3uo4kCz
         rwiyiH/mIrQJmGFF5OEUUmnfFzWZQu4n0W7cVx0w8dqbPU6kQIfG2/JXH/StghzCB0TS
         5MF9i1ZMo0SsJj8Lu0ssZgXWkXVNlCkbel/V24VrZntAtInwJq506fs3BMQ/3iLrxZT8
         lYeeA/N6kAk6bvqCiE6d3dmfoPfjBQgxB9Ob4zOnfgqPn/PoVAt/KBu5ntgdicl4+oqn
         58iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCOEFDLZBS+/9rJrWV/7tVxv/zMpTonWQ+Qpoz14kZ8=;
        b=rZMAHh6iq5sUhaNk7lnDRXmCOrsYXBvOSxEvn/0OEoIYdDLxiq9BIHSdeH9hxVc4j0
         uMOocsLbOBqFxs+IbCXqeYNOqo0mku6Ot0n2BftBpq6SiAQ0y+FvYbH0ZofuwOTEUNNW
         I47C12GUnsPg9NZ/XXLpZK97h0DwNdDyj3WaHkg14hVRUS7YMLjuXpfkR3N/Ufo+I/Br
         IsulSfDTy/zniRs5Oo7qJSnPZkIKg0004HXbuWB5Z1DCUPwUvNmm/UpiLz0+4SaqvDRM
         P/N1Hot9wzUaLVghmffSOs10f4hQvR3/yO8RPEb+L29w1naRvD5BV9UKYIoV8aIw/IKK
         i0vQ==
X-Gm-Message-State: AOAM530Dt78y0zse/jDMJAUcHEXZleBtwnxelm94RZHKIj7ie3RV7+Hv
        UKxotkAL6vyoqZ5fSAY80EUisew6YN1XsNbzNrpC2A==
X-Google-Smtp-Source: ABdhPJyO+gQvi8giHxiS16yONlN2DWtp3iP2akxfkBWJtJ36f7p+e+BClAfVuy1s7UryroEWgyBgjFdnHZ0A6e2RR+8=
X-Received: by 2002:a9d:f09:: with SMTP id 9mr745557ott.299.1641838396713;
 Mon, 10 Jan 2022 10:13:16 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com>
 <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com> <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
 <CALMp9eR3PEgXhe_z8ArHK0bPeW4=htta_f3LHTm9jqL2rtcT7A@mail.gmail.com> <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com>
In-Reply-To: <a2b6fb82-292b-f714-cfd7-31a5310c28ed@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Jan 2022 10:13:05 -0800
Message-ID: <CALMp9eQbiqjf_MMJP9Cc9=Ubm7qKv88BXtu3=7z8ax9W_1AY4Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 9, 2022 at 10:23 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 9/1/2022 9:23 am, Jim Mattson wrote:
> > On Fri, Dec 10, 2021 at 7:48 PM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>>
> >>> On 12/10/21 20:25, Jim Mattson wrote:
> >>>> In the long run, I'd like to be able to override this system-wide
> >>>> setting on a per-VM basis, for VMs that I trust. (Of course, this
> >>>> implies that I trust the userspace process as well.)
> >>>>
> >>>> How would you feel if we were to add a kvm ioctl to override this
> >>>> setting, for a particular VM, guarded by an appropriate permissions
> >>>> check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
> >>>
> >>> What's the rationale for guarding this with a capability check?  IIRC
> >>> you don't have such checks for perf_event_open (apart for getting kernel
> >>> addresses, which is not a problem for virtualization).
> >>
> >> My reasoning was simply that for userspace to override a mode 0444
> >> kernel module parameter, it should have the rights to reload the
> >> module with the parameter override. I wasn't thinking specifically
> >> about PMU capabilities.
>
> Do we have a precedent on any module parameter rewriting for privileger ?
>
> A further requirement is whether we can dynamically change this part of
> the behaviour when the guest is already booted up.
>
> >
> > Assuming that we trust userspace to decide whether or not to expose a
> > virtual PMU to a guest (as we do on the Intel side), perhaps we could
> > make use of the existing PMU_EVENT_FILTER to give us per-VM control,
> > rather than adding a new module parameter for per-host control. If
>
> Various granularities of control are required to support vPMU production
> scenarios, including per-host, per-VM, and dynamic-guest-alive control.
>
> > userspace calls KVM_SET_PMU_EVENT_FILTER with an action of
> > KVM_PMU_EVENT_ALLOW and an empty list of allowed events, KVM could
> > just disable the virtual PMU for that VM.
>
> AMD will also have "CPUID Fn8000_0022_EBX[NumCorePmc, 3:0]".

Where do you see this? Revision 3.33 (November 2021) of the AMD APM,
volume 3, only goes as high as CPUID Fn8000_0021.

> >
> > Today, the semantics of an empty allow list are quite different from
> > the proposed pmuv module parameter being false. However, it should be
> > an easy conversion. Would anyone be concerned about changing the
> > current semantics of an empty allow list? Is there a need for
> > disabling PMU virtualization for legacy userspace implementations that
> > can't be modified to ask for an empty allow list?
> >
>
> AFAI, at least one user-space agent has integrated with it plus additional
> "action"s.
>
> Once the API that the kernel presents to user space has been defined,
> it's best not to change it and instead fall into remorse.

Okay.

I propose the following:
1) The new module parameter should apply to Intel as well as AMD, for
situations where userspace is not trusted.
2) If the module parameter allows PMU virtualization, there should be
a new KVM_CAP whereby userspace can enable/disable PMU virtualization.
(Since you require a dynamic toggle, and there is a move afoot to
refuse guest CPUID changes once a guest is running, this new KVM_CAP
is needed on Intel as well as AMD).
3) If the module parameter does not allow PMU virtualization, there
should be no userspace override, since we have no precedent for
authorizing that kind of override.

> "But I am not a decision maker. " :D
>
> Thanks,
> Like Xu
>
