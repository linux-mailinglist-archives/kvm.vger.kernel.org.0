Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A435640D0C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiLBSYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbiLBSYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:24:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA9DC7255
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670005401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P84c+bfPSykX3YQiadeIHsZVz2UzMEmnzobF5uJ1pLI=;
        b=UC6RC9Tcbl7XkYqNIcEzFQTluYMTWRUkgCAFrg5mjzY5gszYTLVmAQKR5Bhuj/KfpJnckm
        R6jE2lJ5GdJ4RVgykgeJz3zbm+PXyPA9rNUrHP5helGi3Q4PuhvkWRFxe2yhkgi8w+ruI/
        BoRzdM+CcLkuFaIFK8inAFHHuOr4mt8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-fLw4o_pePcaflv-tWzWLnw-1; Fri, 02 Dec 2022 13:23:20 -0500
X-MC-Unique: fLw4o_pePcaflv-tWzWLnw-1
Received: by mail-wm1-f72.google.com with SMTP id z15-20020a1c4c0f000000b003cf6f80007cso2238034wmf.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:23:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P84c+bfPSykX3YQiadeIHsZVz2UzMEmnzobF5uJ1pLI=;
        b=dQhUNj+uA/5Up7FW79+5f2q3oWz6PJuaXeQwYCBaHlLDJOu4mUtN+ZJbE4Du+fj+AS
         D2+ClaJQ88n7XWsSn4no9OMrDgJC9ylSE6pvywON9+hrM3rM4/PXEcIdYMfoDZLNvqV0
         XiRZawoCneJ9oXdCH19WvUYD05VyPcUwYkLy28EgkVRao5kYzapyeAyZPoYmRbk4edLs
         NTFJlaXXcDduGFF9HI4Sihzc9cqH/3OkKbuPvdGVfKUwktQ+srNjF9OsLKRgvDET63nh
         4zK+JYUkoSLX7o9oLzUeh6eOv87Rq6qqPXW56BFssVv5Uc/ninufJD6E27C9tP5XZhF2
         FKjg==
X-Gm-Message-State: ANoB5pn6V/FNkNbJ/mEbcG3fPHNla1ibTsa8W4S2iFGd8Vnd25XFJ9ZS
        dZHYY1f0BcGZ61w4lqUL9ISS6gU8y8feggNrMNq5xKlq+gy0H492JzgMBKHplCviIqR8VT/xcUw
        6fnh2LfkFs8PO
X-Received: by 2002:a05:600c:414d:b0:3d0:878e:6fed with SMTP id h13-20020a05600c414d00b003d0878e6fedmr2684214wmm.150.1670005396554;
        Fri, 02 Dec 2022 10:23:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ce8iPe1eG0lC8Hd032B6FnUH8YAiPhO90ACJEtpgSAmnJV++j8/y61/KMnH5cyF16TO0mfw==
X-Received: by 2002:a05:600c:414d:b0:3d0:878e:6fed with SMTP id h13-20020a05600c414d00b003d0878e6fedmr2684196wmm.150.1670005396315;
        Fri, 02 Dec 2022 10:23:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z10-20020a05600c0a0a00b003c70191f267sm15411305wmp.39.2022.12.02.10.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:23:15 -0800 (PST)
Message-ID: <7c6ac714-7ed8-0106-2e45-d1ca3055f39b@redhat.com>
Date:   Fri, 2 Dec 2022 19:23:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 0/9] tools: Make {clear,set}_bit() atomic for reals
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20221119013450.2643007-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/22 02:34, Sean Christopherson wrote:
> For obvious reasons I'd like to route the this through Paolo's tree.
> In theory, taking just patch 5 through tip would work, but creating a
> topic branch seems like the way to go, though maybe I'm being overly
> paranoid.  The current tip/perf/core doesn't have any conflicts, nor does
> it have new set_bit() or clear_bit() users.
> 
>   
> Code sitting in kvm/queue for 6.2 adds functionality that relies on
> clear_bit() being an atomic operation.  Unfortunately, despite being
> implemented in atomic.h (among other strong hits that they should be
> atomic), clear_bit() and set_bit() aren't actually atomic (and of course
> I realized this _just_ after everything got queued up).
> 
> Move current tools/ users of clear_bit() and set_bit() to the
> double-underscore versions (which tools/ already provides and documents
> as being non-atomic), and then implement clear_bit() and set_bit() as
> actual atomics to fix the KVM selftests bug.
> 
> Perf and KVM are the only affected users.  NVDIMM also has test code
> in tools/, but that builds against the kernel proper.  The KVM code is
> well tested and fully audited.  The perf code is lightly tested; if I
> understand the build system, it's probably not even fully compile tested.
> 
> Patches 1 and 2 are completely unrelated and are fixes for patches
> sitting in kvm/queue.  Paolo, they can be squashed if you want to rewrite
> history.
> 
> Patch 3 fixes a hilarious collision in a KVM ARM selftest that will arise
> when clear_bit() is converted to an atomic.
> 
> Patch 4 changes clear_bit() and set_bit() to take an "unsigned long"
> instead of an "int" so that patches 5-6 aren't accompanied by functional
> changes.  I.e. if something in perf is somehow relying on "bit" being a
> signed int, failures will bisect to patch 4 and not to the
> supposed-to-be-a-nop conversion to __clear_bit() and __set_bit().
> 
> Patch 5-9 switch perf+KVM and complete the conversion.
> 
> Applies on:
>    
>    git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue

Queued, thanks Namhyung for the ACK!

Paolo

> 
> Sean Christopherson (9):
>    KVM: selftests: Add rdmsr_from_l2() implementation in Hyper-V eVMCS
>      test
>    KVM: selftests: Remove unused "vcpu" param to fix build error
>    KVM: arm64: selftests: Enable single-step without a "full" ucall()
>    tools: Take @bit as an "unsigned long" in {clear,set}_bit() helpers
>    perf tools: Use dedicated non-atomic clear/set bit helpers
>    KVM: selftests: Use non-atomic clear/set bit helpers in KVM tests
>    tools: Drop conflicting non-atomic test_and_{clear,set}_bit() helpers
>    tools: Drop "atomic_" prefix from atomic test_and_set_bit()
>    tools: KVM: selftests: Convert clear/set_bit() to actual atomics
> 
>   tools/arch/x86/include/asm/atomic.h           |  6 +++-
>   tools/include/asm-generic/atomic-gcc.h        | 13 ++++++-
>   tools/include/asm-generic/bitops/atomic.h     | 15 ++++----
>   tools/include/linux/bitmap.h                  | 34 -------------------
>   tools/perf/bench/find-bit-bench.c             |  2 +-
>   tools/perf/builtin-c2c.c                      |  6 ++--
>   tools/perf/builtin-kwork.c                    |  6 ++--
>   tools/perf/builtin-record.c                   |  6 ++--
>   tools/perf/builtin-sched.c                    |  2 +-
>   tools/perf/tests/bitmap.c                     |  2 +-
>   tools/perf/tests/mem2node.c                   |  2 +-
>   tools/perf/util/affinity.c                    |  4 +--
>   tools/perf/util/header.c                      |  8 ++---
>   tools/perf/util/mmap.c                        |  6 ++--
>   tools/perf/util/pmu.c                         |  2 +-
>   .../util/scripting-engines/trace-event-perl.c |  2 +-
>   .../scripting-engines/trace-event-python.c    |  2 +-
>   tools/perf/util/session.c                     |  2 +-
>   tools/perf/util/svghelper.c                   |  2 +-
>   .../selftests/kvm/aarch64/arch_timer.c        |  2 +-
>   .../selftests/kvm/aarch64/debug-exceptions.c  | 21 ++++++------
>   tools/testing/selftests/kvm/dirty_log_test.c  | 34 +++++++++----------
>   .../selftests/kvm/include/ucall_common.h      |  8 +++++
>   .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
>   .../selftests/kvm/x86_64/hyperv_evmcs.c       | 13 +++++--
>   .../selftests/kvm/x86_64/hyperv_svm_test.c    |  4 +--
>   .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  2 +-
>   27 files changed, 102 insertions(+), 106 deletions(-)
> 
> 
> base-commit: 3321eef4acb51c303f0598d8a8493ca58528a054

