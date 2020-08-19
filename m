Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C704B24A877
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 23:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHSV0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 17:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHSV0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 17:26:12 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5D6C061383
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 14:26:12 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id v6so20235828ota.13
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nIUorchxEqSUbrKFSXauXIdexeZ+y78f0sS0GWpnDMU=;
        b=sACXdxPyni7vFFPMXlG14vAyrsQ90Tzwn5qsmxLoYZtf+qU+nGF5JvdDQYNRRoDuZO
         Kdi+LQIkpqVrO3VICfaF0IHleMBXVxC2ptqvIukbkJcKIyqVl8CslrKIRek2ZK/MD2cG
         6uR8RacEpULjcicv4UhibrqMJ4v1cIjjGTf+2VZXALVYwnC1VJcO+4wqI4HwFcEzkF6h
         wePJKUDBmOqtCZqOPSa0rSbJ4WSqzky0hac6zBBcPKiIC/0m4sGrXfHDPu4dxNXe6e39
         pbMCs17AzP8t8Nc1EYOxFXRKzKuc84XtOSMC+5GlUBnHnAs1AEi0r8EupqomGOjLAjPc
         Ss0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nIUorchxEqSUbrKFSXauXIdexeZ+y78f0sS0GWpnDMU=;
        b=EYv3W2BcUDiqBV4q0EzJfEsGlk8UN3OMQuRTrHD988vtzsSl4Vkhkbg8H5aLg1DI2j
         8W379p5KRdBWzYge+wXT1IUuXJZMeZxNE219iaIUdEoTpP8U1tuEnx92sURlkTxy1e0P
         7OoLMo+lwDP/aOyrSctNuXtn762MgARvBd8qgLBKHU0+orSdMyAEwhi3Tr10qatw6wOU
         TncishpkghqWDJoHo344QK9APMKqeLQlwUbviUFGGWjycl4qexjfj9e0KCK+aQlkZNai
         3hThqu3S9TjBzZvT7WKkyyG24JTUj9/LUPIEazjE4iWRPGe339DWMfieqi3DBMrmYMCc
         VWPw==
X-Gm-Message-State: AOAM5330PbrjFd8RT8Ezik9Bw9Ecj3NSLFDwoC+ROCMjPFB0/rBC6ZL+
        V5o1Rm5SnGkm/7ZT9nJ3Nr0xJ4rukSgv/IHhyoVtAQ==
X-Google-Smtp-Source: ABdhPJzDEhYWtgbxFIoNbIl6nvUXg6m1nwP+Cma508GkraFee4w2YnO9D79RG930cyfq42GIoecoDC3qxMMYBsZFJeo=
X-Received: by 2002:a9d:ae9:: with SMTP id 96mr19469993otq.241.1597872371444;
 Wed, 19 Aug 2020 14:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200803211423.29398-1-graf@amazon.com>
In-Reply-To: <20200803211423.29398-1-graf@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Aug 2020 14:25:59 -0700
Message-ID: <CALMp9eRHmhmKP21jmBr13n3DvttPg9OQEn5Zn0LxyiKiq2uTkA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Allow user space to restrict and augment MSR emulation
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 3, 2020 at 2:14 PM Alexander Graf <graf@amazon.com> wrote:
>
> While tying to add support for the MSR_CORE_THREAD_COUNT MSR in KVM,
> I realized that we were still in a world where user space has no control
> over what happens with MSR emulation in KVM.
>
> That is bad for multiple reasons. In my case, I wanted to emulate the
> MSR in user space, because it's a CPU specific register that does not
> exist on older CPUs and that really only contains informational data that
> is on the package level, so it's a natural fit for user space to provide
> it.
>
> However, it is also bad on a platform compatibility level. Currrently,
> KVM has no way to expose different MSRs based on the selected target CPU
> type.
>
> This patch set introduces a way for user space to indicate to KVM which
> MSRs should be handled in kernel space. With that, we can solve part of
> the platform compatibility story. Or at least we can not handle AMD specific
> MSRs on an Intel platform and vice versa.
>
> In addition, it introduces a way for user space to get into the loop
> when an MSR access would generate a #GP fault, such as when KVM finds an
> MSR that is not handled by the in-kernel MSR emulation or when the guest
> is trying to access reserved registers.
>
> In combination with the allow list, the user space trapping allows us
> to emulate arbitrary MSRs in user space, paving the way for target CPU
> specific MSR implementations from user space.

This is somewhat misleading. If you don't modify the MSR permission
bitmaps, as Aaron has done, you cannot emulate *arbitrary* MSRs in
userspace. You can only emulate MSRs that kvm is going to intercept.
Moreover, since the set of intercepted MSRs evolves over time, this
isn't a stable API.

> v1 -> v2:
>
>   - s/ETRAP_TO_USER_SPACE/ENOENT/g
>   - deflect all #GP injection events to user space, not just unknown MSRs.
>     That was we can also deflect allowlist errors later
>   - fix emulator case
>   - new patch: KVM: x86: Introduce allow list for MSR emulation
>   - new patch: KVM: selftests: Add test for user space MSR handling
>
> v2 -> v3:
>
>   - return r if r == X86EMUL_IO_NEEDED
>   - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
>   - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
>   - Use complete_userspace_io logic instead of reply field
>   - Simplify trapping code
>   - document flags for KVM_X86_ADD_MSR_ALLOWLIST
>   - generalize exit path, always unlock when returning
>   - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
>   - Add KVM_X86_CLEAR_MSR_ALLOWLIST
>   - Add test to clear whitelist
>   - Adjust to reply-less API
>   - Fix asserts
>   - Actually trap on MSR_IA32_POWER_CTL writes
>
> v3 -> v4:
>
>   - Mention exit reasons in re-enter mandatory section of API documentation
>   - Clear padding bytes
>   - Generalize get/set deflect functions
>   - Remove redundant pending_user_msr field
>   - lock allow check and clearing
>   - free bitmaps on clear
>
> Alexander Graf (3):
>   KVM: x86: Deflect unknown MSR accesses to user space
>   KVM: x86: Introduce allow list for MSR emulation
>   KVM: selftests: Add test for user space MSR handling
>
>  Documentation/virt/kvm/api.rst                | 157 ++++++++++-
>  arch/x86/include/asm/kvm_host.h               |  13 +
>  arch/x86/include/uapi/asm/kvm.h               |  15 +
>  arch/x86/kvm/emulate.c                        |  18 +-
>  arch/x86/kvm/x86.c                            | 259 +++++++++++++++++-
>  include/trace/events/kvm.h                    |   2 +-
>  include/uapi/linux/kvm.h                      |  15 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/user_msr_test.c      | 221 +++++++++++++++
>  9 files changed, 692 insertions(+), 9 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c
>
> --
> 2.17.1
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>
