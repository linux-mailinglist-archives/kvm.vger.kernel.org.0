Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574CB7C4D32
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345054AbjJKIcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjJKIcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:32:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C9BA;
        Wed, 11 Oct 2023 01:32:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-53829312d12so1439418a12.0;
        Wed, 11 Oct 2023 01:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697013137; x=1697617937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhlpYCq8UhMnYE8PfyYAVaTa4aIotqxL5V962HJLzwo=;
        b=lVnO26uXKJaY5W78bBKUu2939U/iPRFYm06o3qxMtq4N9didWliZxXjHO6tXe0HHEB
         2ZGEY+6DAwdLEFylPLYpLH8s4n7/fnjacGdet+jxP2KbCc+m3qq8qIpeAxq++rOf1dwo
         rWOz3jUFJRgnvYmGhpuoFAtgI37WyXpJw7X3RfHlIsLB4mHmGtvvSsYfUZ0l7HdTp1ff
         NJQPYemfcKeAZOp+4Pu/Eh8YQbd1/X/5EVZqLzKxIirYG4JRwFK76YiiZmLNXeAaZhFj
         AUguWW4LMMwpfIr+Kecel/MEseq0aN200giVhGz7hOfBKiTwQkonwnqE6LU/ej190x1w
         KVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697013137; x=1697617937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KhlpYCq8UhMnYE8PfyYAVaTa4aIotqxL5V962HJLzwo=;
        b=bdKFNiZnUUC6O9it0H0rPj4qrO0V7GIoNgVzOj1U9Mxal1heGjXmBQ3h9czSzL4HQ/
         luXZTH6lnDvDWGhhFiTGNt7WUu3QF5yMIEQLhwSMsc5xdVALCfYde6fdLX3KwWay3CW/
         vPvl9SipbyIEdL0QDSoDsSHDquwTHc044L5WqHqfz+O5zhkAesTpNH8Z0H6oGcPyaJOt
         On7MAMh6751IyplyXSeDzm5gVkuIt98jFcnBA5J4JNNfs6lzNS/rqSu2zseQ3jPrg3WU
         jFBYwL1YQqKxxs705kZ0RRnuldYWGOs2gzs+kMmAlcLsA0kv+nvt75URHBP60n07HIlz
         qzMw==
X-Gm-Message-State: AOJu0YwqDD3xIA0hvZnynlvyKba0ln1uUXeUAKX1LZN+ZzZv8RsjT51f
        lQIzcj7Fen78zfExpFNx5gDFW/Vn5VWxf6nZiXw=
X-Google-Smtp-Source: AGHT+IHnMjOlpb4cyO9fuhNSexg5LxxVPS/tIpe0leEOoQ0E0cFjtAIjSkDgfjWEUSStKzDJPhT/4NQWGKXz1DdOIsA=
X-Received: by 2002:a05:6402:3228:b0:53d:e91b:7158 with SMTP id
 g40-20020a056402322800b0053de91b7158mr532567eda.0.1697013136648; Wed, 11 Oct
 2023 01:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com>
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Wed, 11 Oct 2023 16:32:05 +0800
Message-ID: <CAFg_LQUhQxT750aOWu3DahqzLD62hpf_EfJvDXFtCQ581t48Eg@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] KVM: selftests: Test the consistency of the PMU's
 CPUID and its features
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

Jinrong Liang <ljr.kernel@gmail.com> =E4=BA=8E2023=E5=B9=B49=E6=9C=8811=E6=
=97=A5=E5=91=A8=E4=B8=80 19:44=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> The KVM selftests show advantages over KUT in terms of finding defects th=
rough
> flexible and varied guest settings from the KVM user space.
>
> This patchset tests whether the Intel vPMU works properly with different =
Intel
> CPUID.0xA configurations. It also provides test scaffolding and a suffici=
ent
> number of PMU test cases to subsequently offer adequate code coverage of =
AMD
> vPMU or Intel complex features, such as LBR or PEBS, in selftests.
>
> These patches have been tested and have passed all test cases. AMD relate=
d tests
> will be completed in the future, please consider merge these patches befo=
re that.
>
> Any feedback or suggestions are greatly appreciated.
>
> Sincerely,
> Jinrong Liang
>
> Changelog:
>
> v4:
> - Rebased to e2013f46ee2e(tag: kvm-x86-next-2023.08.25)
> - Separate AMD-related tests.
> - Moved static arrays to a new file lib/pmu.c and used more descriptive n=
ames
>   like intel_pmu_arch_events, intel_pmu_fixed_pmc_events, and
>   amd_pmu_arch_events. (Sean)
> - Clean up pmu_event_filter_test.c by including pmu.h and removing
>   unnecessary macros.
> - Modified the "anti-feature" framework to extend this_pmu_has() and
>   kvm_pmu_has() functions. (Sean)
> - Refactor guest_measure_loop() function to simplify logic and improve
>   readability. (Sean)
> - Refactor guest_wr_and_rd_msrs() function to simplify logic and improve
>   readability. (Sean)
> - Use GUEST_ASSERT_EQ() directly instead of passing the counter to ucall =
and
>   back to the host. (Sean)
> - Refactor test_intel_oob_fixed_ctr() test method. (Sean)
> - Avoid using half-baked helpers and optimize the code structure. (Sean)
> - Update variable names for better readability and consistency. (Sean)
> - Rename functions to better reflect their purpose. (Sean)
>
> v3:
> https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com=
/T/
>
> Jinrong Liang (9):
>   KVM: selftests: Add vcpu_set_cpuid_property() to set properties
>   KVM: selftests: Extend this_pmu_has() and kvm_pmu_has() to check arch
>     events
>   KVM: selftests: Add pmu.h for PMU events and common masks
>   KVM: selftests: Test Intel PMU architectural events on gp counters
>   KVM: selftests: Test Intel PMU architectural events on fixed counters
>   KVM: selftests: Test consistency of CPUID with num of gp counters
>   KVM: selftests: Test consistency of CPUID with num of fixed counters
>   KVM: selftests: Test Intel supported fixed counters bit mask
>   KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
>
>  tools/testing/selftests/kvm/Makefile          |   2 +
>  tools/testing/selftests/kvm/include/pmu.h     |  96 ++++
>  .../selftests/kvm/include/x86_64/processor.h  |  42 +-
>  tools/testing/selftests/kvm/lib/pmu.c         |  38 ++
>  .../selftests/kvm/lib/x86_64/processor.c      |  14 +
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 431 ++++++++++++++++++
>  .../kvm/x86_64/pmu_event_filter_test.c        |  34 +-
>  7 files changed, 623 insertions(+), 34 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/pmu.h
>  create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
>  create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.=
c
>
>
> base-commit: e2013f46ee2e721567783557c301e5c91d0b74ff
> --
> 2.39.3
>
