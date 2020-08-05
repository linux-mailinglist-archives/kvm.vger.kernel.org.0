Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CAF23D3A1
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHEVdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHEVdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:33:42 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A9AC061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:33:40 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so49390756ljg.13
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rIyqsViA7BL3pKliPq5CAFqWBbic5vPlTETbapM7g2A=;
        b=V2WyVIrtSVqPLpWmgi8P3tuCBEXpvvuXzdrdsF4OctE6jdckcUu5qXvU4y705WnZ/c
         VlzVENNF5EjIdnOjYuV6vM4hPHtwxZPXm70u3y2V6KlaJyg0rZodJCF4AFbXhflBAXZB
         Ut66yQbXuVWMQc/8ihfnxknxQBIKLfkmwonRvAtyjhrMlfcH6yhPViHdeV+6WkGONLBa
         cGLaVpQf1nFVdoUp1rdVXGxhO1H0U+R4BMGvRLZqDtbq/Cy8t190aM/saWENa5ZIqw63
         7otomZ6KZSUeUmYZKVoDFUR9TcKNg/UOCwPsREa1XY7kUnRy/xOaP66GoRwVSYsTcxAR
         B/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rIyqsViA7BL3pKliPq5CAFqWBbic5vPlTETbapM7g2A=;
        b=qFeeTZ/2V153umZkyr7uVn5jjGSHkRudwUhS3871wKlhwHQWBOxdSW48E4nwOwayOr
         w6i9y7nvSLdkZZTYFqja4UfSzcd6epoOEfKh4+Fw4lunyNnx7IvunvreIzxlLJ4lRlXV
         JVGujHRaT7pge8fqlRT4iPIe92DxpRPTAap6qkCY2Wqg+7E3nauI3kABNxfdk8DHNEA6
         SrImDpFfQtNOUFy7Rp9tMwDAf9K9nTDcF6Nemv3XNB+dEqMDFyIdP5w2TJVxWDPNGGFd
         O6gIFVF8/uh0uXBYdV+T4oO51hav47Y66SmMO+TmR8qzijlB3dvHeCFRj92hRywTq4Kz
         Eo3Q==
X-Gm-Message-State: AOAM531/CVNSvOFn9dmA7B9tLEVynAzzLQFQw97lBGmm4+6tDr/ap4gf
        e/YAlb+dnWDZ4sjUWJFL3UivOh3vLGGqGNSJzGyYIHVR
X-Google-Smtp-Source: ABdhPJzWwFmt6QR8QZGID5+oTFYVjIUMMyJOJDsDud2opa0L7Q14xfbV3ise56EAqPys1c2WAIQOPABzyEXZtM9IdCw=
X-Received: by 2002:a2e:90e:: with SMTP id 14mr2405661ljj.293.1596663216694;
 Wed, 05 Aug 2020 14:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com> <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com> <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
In-Reply-To: <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 5 Aug 2020 16:33:25 -0500
Message-ID: <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 5, 2020 at 1:46 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/08/20 18:06, Oliver Upton wrote:
> > On Tue, Jul 28, 2020 at 11:33 AM Oliver Upton <oupton@google.com> wrote:
> >>
> >> On Tue, Jul 21, 2020 at 8:26 PM Oliver Upton <oupton@google.com> wrote:
> >>>
> >>> To date, VMMs have typically restored the guest's TSCs by value using
> >>> the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
> >>> value introduces some challenges with synchronization as the TSCs
> >>> continue to tick throughout the restoration process. As such, KVM has
> >>> some heuristics around TSC writes to infer whether or not the guest or
> >>> host is attempting to synchronize the TSCs.
> >>>
> >>> Instead of guessing at the intentions of a VMM, it'd be better to
> >>> provide an interface that allows for explicit synchronization of the
> >>> guest's TSCs. To that end, this series introduces the
> >>> KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
> >>> userspace.
> >>>
> >>> v2 => v3:
> >>>  - Mark kvm_write_tsc_offset() as static (whoops)
> >>>
> >>> v1 => v2:
> >>>  - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
> >>>    indicate that it can be used instead of an IA32_TSC MSR restore
> >>>    through KVM_SET_MSRS
> >>>  - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
> >>>    synchronization heuristics, thereby enabling the KVM masterclock when
> >>>    all vCPUs are in phase.
> >>>
> >>> Oliver Upton (4):
> >>>   kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
> >>>   kvm: vmx: check tsc offsetting with nested_cpu_has()
> >>>   selftests: kvm: use a helper function for reading cpuid
> >>>   selftests: kvm: introduce tsc_offset_test
> >>>
> >>> Peter Hornyack (1):
> >>>   kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
> >>>
> >>>  Documentation/virt/kvm/api.rst                |  31 ++
> >>>  arch/x86/include/asm/kvm_host.h               |   1 +
> >>>  arch/x86/kvm/vmx/vmx.c                        |   2 +-
> >>>  arch/x86/kvm/x86.c                            | 147 ++++---
> >>>  include/uapi/linux/kvm.h                      |   5 +
> >>>  tools/testing/selftests/kvm/.gitignore        |   1 +
> >>>  tools/testing/selftests/kvm/Makefile          |   1 +
> >>>  .../testing/selftests/kvm/include/test_util.h |   3 +
> >>>  .../selftests/kvm/include/x86_64/processor.h  |  15 +
> >>>  .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
> >>>  .../selftests/kvm/include/x86_64/vmx.h        |   9 +
> >>>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
> >>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
> >>>  .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
> >>>  14 files changed, 550 insertions(+), 49 deletions(-)
> >>>  create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
> >>>
> >>> --
> >>> 2.28.0.rc0.142.g3c755180ce-goog
> >>>
> >>
> >> Ping :)
> >
> > Ping
>
> Hi Oliver,
>
> I saw these on vacation and decided I would delay them to 5.10.  However
> they are definitely on my list.
>

Hope you enjoyed vacation!

> I have one possibly very stupid question just by looking at the cover
> letter: now that you've "fixed KVM_SET_TSC_OFFSET to participate in the
> existing TSC synchronization heuristics" what makes it still not
> "guessing the intentions of a VMM"?  (No snark intended, just quoting
> the parts that puzzled me a bit).

Great point.

I'd still posit that this series disambiguates userspace
control/synchronization of the TSCs. If a VMM wants the TSCs to be in
sync, it can write identical offsets to all vCPUs

That said, participation in TSC synchronization is presently necessary
due to issues migrating a guest that was in the middle of a TSC sync.
In doing so, we still accomplish synchronization on the other end of
migration with a well-timed mix of host and guest writes.

>
> My immediate reaction was that we should just migrate the heuristics
> state somehow

Yeah, I completely agree. I believe this series fixes the
userspace-facing issues and your suggestion would address the
guest-facing issues.

> but perhaps I'm missing something obvious.

Not necessarily obvious, but I can think of a rather contrived example
where the sync heuristics break down. If we're running nested and get
migrated in the middle of a VMM setting up TSCs, it's possible that
enough time will pass that we believe subsequent writes to not be of
the same TSC generation.

> Paolo
>
