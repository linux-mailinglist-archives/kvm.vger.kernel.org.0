Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB05D580EBB
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 10:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiGZIQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 04:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiGZIQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 04:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F734BF5B
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658823366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RVSIXNzjQoVTHDXGVJrlcwd4XgxxQrEbqImEYDf+0EU=;
        b=Jm/NFX14uaezeoFBpA2c9GCsKmQoVkxJSXNvNidKcJtcQgujiOw5zv1nXhOB7+J+cDRxap
        +mjRO5zqqmcHCgcHBOSin+jDF9iJqreNt4zVyTgv08rDbe3BSn4NJn1R9FDuOsbJy9cVIy
        k700buUmRmcp0gWlOxse9rwYWmGtw4Q=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-daSCMr3ZNveLEe4PcAvW3Q-1; Tue, 26 Jul 2022 04:16:03 -0400
X-MC-Unique: daSCMr3ZNveLEe4PcAvW3Q-1
Received: by mail-lf1-f71.google.com with SMTP id k21-20020ac24f15000000b0048a7a2e246fso2609762lfr.7
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVSIXNzjQoVTHDXGVJrlcwd4XgxxQrEbqImEYDf+0EU=;
        b=MYHHKx7L2OZEUfypdjikfsda46GllhitAvouDj+4nhHhn/6Fv3nkQY9Ooiqp8ftZ46
         0f9zDP2dK2lwwK8U/zCfwMVqxPd2g1sKbJolFSK0BPBtGOhKD6rKLPfjxjDKiQSsq6Zy
         xI3sXaERCsKaexjkF67rdazkAKK2UpFCOlyqpKk/VZk5m70Uahlhs5wXy9oC6cjUM9fH
         DR1Go0QjRaBjv8JudCmJwOcwzL3acyk21F4qCXtHdVI/cO6PtnxpfhFO5cIjed0q7JB7
         q9vr+VTS+3dSOpe4FUksiS0XbTeZqB8TJ12uhNUDnSxvlEuUumUURT9l35K6hXOevj11
         fYtA==
X-Gm-Message-State: AJIora/I3zUl/jW8JTYwYWZqV7X4/TIikPArMA+BnYLSH5LpzIOQsN0R
        suzAtNOaAd3Yg6IP5JzhNWlXHkae5PVzhZNHyR0klFlbYYcy3CEktirf1T3vyhvl/AlF+zO5GSE
        NtZ2BlCt6zucgrzWXJMdoKOMz+QTu
X-Received: by 2002:a2e:a289:0:b0:258:e917:36a4 with SMTP id k9-20020a2ea289000000b00258e91736a4mr5772403lja.510.1658823361435;
        Tue, 26 Jul 2022 01:16:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1upeX45sC3ZVZpeWm6exwDnsbpt+H6vEhu17jI/Y4XEAdb0Thed1wOgsWqpcPLBrzGrYsw+03BLfkIh2HQjhg4=
X-Received: by 2002:a2e:a289:0:b0:258:e917:36a4 with SMTP id
 k9-20020a2ea289000000b00258e91736a4mr5772390lja.510.1658823360939; Tue, 26
 Jul 2022 01:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <Yt8M2yxuZ3kZFySA@google.com>
In-Reply-To: <Yt8M2yxuZ3kZFySA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 26 Jul 2022 10:15:49 +0200
Message-ID: <CABgObfYc6sgwzF8ykauuhTxqF-=FMkvtApNLTgYnK-ypQtA-bw@mail.gmail.com>
Subject: Re: [kvm-unit-tests GIT PULL v2] x86: Fixes, cleanups, and new sub-tests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Mon, Jul 25, 2022 at 11:36 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Attempt #2.  Only difference is the addition of two patches[*] (effectively just
> one when all is said and done) to fix the x2APIC+INIT+SIPI SVM test bug.
>
> [*] https://lore.kernel.org/all/20220725201336.2158604-1-seanjc@google.com
>
>
> The following changes since commit 7b2e41767bb8caf91972ee32e4ca85ec630584e2:
>
>   Merge branch 's390x-next-2022-07' into 'master' (2022-07-21 14:41:56 +0000)
>
> are available in the Git repository at:
>
>   https://github.com/sean-jc/kvm-unit-tests.git tags/for_paolo
>
> for you to fetch changes up to f7b730bcac4432f9ea239faeb963392d1854b9b0:
>
>   nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4 (2022-07-25 13:20:29 -0700)
>
> ----------------------------------------------------------------
> x86 fixes, cleanups, and new sub-tests:
>
>   - Bug fix for the VMX-preemption timer expiration test
>   - Refactor SVM tests to split out NPT tests
>   - Add tests for MCE banks to MSR test
>   - Add SMP Support for x86 UEFI tests
>   - x86: nVMX: Add VMXON #UD test (and exception cleanup)
>   - PMU cleanup and related nVMX bug fixes
>
> ----------------------------------------------------------------
> Jim Mattson (1):
>       x86: VMX: Fix the VMX-preemption timer expiration test
>
> Manali Shukla (5):
>       x86: nSVM: Extract core functionality of main() to helper run_svm_tests()
>       x86: Add flags to control behavior of set_mmu_range()
>       x86: nSVM: Build up the nested page table dynamically
>       x86: nSVM: Correct indentation for svm.c
>       x86: nSVM: Correct indentation for svm_tests.c
>
> Sean Christopherson (23):
>       x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate file.
>       x86: nSVM: Run non-NPT nSVM tests with PT_USER_MASK enabled
>       x86: nSVM: Add macros to create SVM's NPT tests, reduce boilerplate code
>       x86: msr: Take the MSR index and name separately in low level helpers
>       x86: msr: Add tests for MCE bank MSRs
>       x86: Use an explicit magic string to detect that dummy.efi passes
>       x86: apic: Play nice with x2APIC being enabled when getting "pre-boot" ID
>       x86: cstart64: Put APIC into xAPIC after loading TSS
>       x86: Rename ap_init() to bringup_aps()
>       x86: Add ap_online() to consolidate final "AP is alive!" code
>       x86: Use BIT() to define architectural bits
>       x86: Replace spaces with tables in processor.h
>       x86: Use "safe" terminology instead of "checking"
>       x86: Use "safe" helpers to implement unsafe CRs accessors
>       x86: Provide result of RDMSR from "safe" variant
>       nVMX: Check the results of VMXON/VMXOFF in feature control test
>       nVMX: Check result of VMXON in INIT/SIPI tests
>       nVMX: Wrap VMXON in ASM_TRY(), a.k.a. in exception fixup
>       nVMX: Simplify test_vmxon() by returning directly on failure
>       x86: Drop cpuid_osxsave(), just use this_cpu_has(X86_FEATURE_OSXSAVE)
>       nVMX: Move wrappers of this_cpu_has() to nVMX's VM-Exit test
>       nVMX: Rename monitor_support() to this_cpu_has_mwait(), drop #define
>       nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4
>
> Varad Gautam (10):
>       x86: Share realmode trampoline between i386 and x86_64
>       x86: Move ap_init() to smp.c
>       x86: Move load_idt() to desc.c
>       x86: desc: Split IDT entry setup into a generic helper
>       x86: Move load_gdt_tss() to desc.c
>       x86: efi: Provide a stack within testcase memory
>       x86: efi: Provide percpu storage
>       x86: Move 32-bit => 64-bit transition code to trampolines.S
>       x86: efi, smp: Transition APs from 16-bit to 32-bit mode
>       x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI
>
> Yang Weijiang (4):
>       x86: nVMX: Use report_skip() to print messages when VMX tests are skipped
>       x86: Use helpers to fetch supported perf capabilities
>       x86: Skip perf related tests when platform cannot support
>       x86: Check platform pmu capabilities before run lbr tests
>
>  lib/alloc_page.h          |    3 +
>  lib/x86/apic.c            |   16 +-
>  lib/x86/asm/setup.h       |    3 +
>  lib/x86/desc.c            |   46 +-
>  lib/x86/desc.h            |    5 +-
>  lib/x86/processor.h       |  455 +++++++++++--------
>  lib/x86/setup.c           |   81 +++-
>  lib/x86/smp.c             |  150 ++++++-
>  lib/x86/smp.h             |   11 +
>  lib/x86/vm.c              |   22 +-
>  lib/x86/vm.h              |   10 +
>  scripts/runtime.bash      |    2 +-
>  x86/Makefile.common       |    2 +
>  x86/Makefile.x86_64       |    2 +
>  x86/access.c              |    8 +-
>  x86/cstart.S              |   48 +-
>  x86/cstart64.S            |  127 +-----
>  x86/dummy.c               |    8 +
>  x86/efi/crt0-efi-x86_64.S |    3 +
>  x86/efi/efistart64.S      |   79 ++--
>  x86/la57.c                |    2 +-
>  x86/msr.c                 |  113 ++++-
>  x86/pcid.c                |   28 +-
>  x86/pmu.c                 |  116 ++---
>  x86/pmu_lbr.c             |   35 +-
>  x86/rdpru.c               |    4 +-
>  x86/svm.c                 |  219 ++++-----
>  x86/svm.h                 |    5 +-
>  x86/svm_npt.c             |  380 ++++++++++++++++
>  x86/svm_tests.c           | 3365 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------
>  x86/trampolines.S         |  129 ++++++
>  x86/unittests.cfg         |    6 +
>  x86/vmexit.c              |   12 +-
>  x86/vmx.c                 |  141 ++++--
>  x86/vmx.h                 |   31 +-
>  x86/vmx_tests.c           |  136 +++---
>  x86/xsave.c               |   31 +-
>  37 files changed, 3170 insertions(+), 2664 deletions(-)
>  create mode 100644 x86/svm_npt.c
>  create mode 100644 x86/trampolines.S
>

