Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A278F1C6
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346892AbjHaRWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjHaRWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:22:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC5EE56
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693502479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5ihbe2qTC6uch1t/qIXZzqoZwaG2lkOtp1kFU9R+nc=;
        b=Sa+liagyXZhmwn8c38NqbbHw+2tT+5Hk93tGmHYgU7HaLjHGbWffZp8AL75HSwVtnlhAs7
        fQjZ4WdBQyYoiXAmRuvipJEDtLp3NYCfh5KAc+sOemiIkvoh0PrnUvNAbJAUb/AdjB7bnn
        1rSXwOxaCPemt2Oeie6mqGZ3AnrfGNI=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-q6z_cmdvOQKjLlCGMkc6Uw-1; Thu, 31 Aug 2023 13:21:18 -0400
X-MC-Unique: q6z_cmdvOQKjLlCGMkc6Uw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-793eb54966dso764552241.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693502476; x=1694107276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5ihbe2qTC6uch1t/qIXZzqoZwaG2lkOtp1kFU9R+nc=;
        b=dZlbBvrlcg0WLpUHcGj24yBNsbK3sc9rhLyNsz398rO1+cXD4aRQdu8CSyvnpT8rm+
         NTs3Xdo7QAfES6qvAI9nDvIUKBzkqAbP4d9J3mt8vJ9GQ/eI32LwKFyLO+mH7fxMI6tV
         38lx8vjIizOIAZnUz51w7SqgEBeSCf6NS3YUOpe2oPK40orRkgVQ0H7Sb1JFpjY/6/7K
         yfsMzxu+Xy+ZfIsjunuIM2ga1cqxOECboNsR7qYljZGIqnLQxy6Qjxdy/R3T8Qf6BcK9
         0W6KYnKngutk5YDFDWNYhuLTTevhFBsodkNLjjCXviDAXGtUPVaozQzbU7ZmRqWiwNga
         tHRg==
X-Gm-Message-State: AOJu0Ywy3f1H4P2ZiDb/2rzAK2TbtVXgFmQBOIanLxd+1U4vWTa1+pad
        uM+qHfJ45JfAk/FPM2ufxn63g53Wexg3l08qawoTdcWOxZxU0yvdaqRusunZCOBWSuFATfQMK+H
        fFF5Vg8gpnvb5x720y3z26veoHSu9
X-Received: by 2002:a05:6102:1627:b0:44d:38d6:5cb8 with SMTP id cu39-20020a056102162700b0044d38d65cb8mr2545713vsb.10.1693502476619;
        Thu, 31 Aug 2023 10:21:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs+mbUS5NE26ISkhybGfDTutaH6kFzg59Egfkkek6y5vyxXPwTlpehqQzdzWtF6fUOJ+pEB8e8oPp6WIMLA54=
X-Received: by 2002:a05:6102:1627:b0:44d:38d6:5cb8 with SMTP id
 cu39-20020a056102162700b0044d38d65cb8mr2545707vsb.10.1693502476338; Thu, 31
 Aug 2023 10:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-6-seanjc@google.com>
In-Reply-To: <20230830000633.3158416-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:21:04 +0200
Message-ID: <CABgObfbJ1r_ipaQ7v2HWCR5E39YdLR20oh2QFCFa-uOH3AA+RQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 2:07=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Selftests changes for 6.6.  The big highlight (and really the highlight o=
f all
> the x86 pull requests IMO) is the addition of printf() support in guest c=
ode,
> courtesy of Aaron.
>
> Speaking of which, the vast majority of this has been merged into the s39=
0 tree,
> i.e. if you do the s390 pull request first you'll already have most of th=
is.
> The immutable tag I created has waaaay more stuff than was strictly neede=
d by
> the s390 folks, but I forgot to create the tag earlier and I wasn't sure =
if
> they had already merged kvm-x86/selftests, so I went with the approach I =
was
> most confident wouldn't throw a wrench in s390 or delay their pull reques=
t, even
> though the result is rather gross.

Pulling this first for exactly this reason, thanks.

Paolo

> The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b57=
4c:
>
>   Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.6
>
> for you to fetch changes up to c92b922a8c526e1bb11945a703cba9f85976de7e:
>
>   KVM: x86: Update MAINTAINTERS to include selftests (2023-08-25 09:04:34=
 -0700)
>
> ----------------------------------------------------------------
> KVM: x86: Selftests changes for 6.6:
>
>  - Add testcases to x86's sync_regs_test for detecting KVM TOCTOU bugs
>
>  - Add support for printf() in guest code and covert all guest asserts to=
 use
>    printf-based reporting
>
>  - Clean up the PMU event filter test and add new testcases
>
>  - Include x86 selftests in the KVM x86 MAINTAINERS entry
>
> ----------------------------------------------------------------
> Aaron Lewis (5):
>       KVM: selftests: Add strnlen() to the string overrides
>       KVM: selftests: Add guest_snprintf() to KVM selftests
>       KVM: selftests: Add additional pages to the guest to accommodate uc=
all
>       KVM: selftests: Add string formatting options to ucall
>       KVM: selftests: Add a selftest for guest prints and formatted asser=
ts
>
> Bibo Mao (1):
>       KVM: selftests: use unified time type for comparison
>
> Jinrong Liang (6):
>       KVM: selftests: Add x86 properties for Intel PMU in processor.h
>       KVM: selftests: Drop the return of remove_event()
>       KVM: selftests: Introduce "struct __kvm_pmu_event_filter" to manipu=
late filter
>       KVM: selftests: Add test cases for unsupported PMU event filter inp=
ut values
>       KVM: selftests: Test if event filter meets expectations on fixed co=
unters
>       KVM: selftests: Test gp event filters don't affect fixed event filt=
ers
>
> Michal Luczaj (4):
>       KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
>       KVM: selftests: Extend x86's sync_regs_test to check for CR4 races
>       KVM: selftests: Extend x86's sync_regs_test to check for event vect=
or races
>       KVM: selftests: Extend x86's sync_regs_test to check for exception =
races
>
> Minjie Du (1):
>       KVM: selftests: Remove superfluous variable assignment
>
> Sean Christopherson (33):
>       KVM: selftests: Make TEST_ASSERT_EQ() output look like normal TEST_=
ASSERT()
>       KVM: selftests: Add a shameful hack to preserve/clobber GPRs across=
 ucall
>       KVM: selftests: Add formatted guest assert support in ucall framewo=
rk
>       KVM: selftests: Add arch ucall.h and inline simple arch hooks
>       KVM: selftests: Add #define of expected KVM exit reason for ucall
>       KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
>       KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSE=
RT
>       KVM: selftests: Convert ARM's hypercalls test to printf style GUEST=
_ASSERT
>       KVM: selftests: Convert ARM's page fault test to printf style GUEST=
_ASSERT
>       KVM: selftests: Convert ARM's vGIC IRQ test to printf style GUEST_A=
SSERT
>       KVM: selftests: Convert the memslot performance test to printf gues=
t asserts
>       KVM: selftests: Convert s390's memop test to printf style GUEST_ASS=
ERT
>       KVM: selftests: Convert s390's tprot test to printf style GUEST_ASS=
ERT
>       KVM: selftests: Convert set_memory_region_test to printf-based GUES=
T_ASSERT
>       KVM: selftests: Convert steal_time test to printf style GUEST_ASSER=
T
>       KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSE=
RT
>       KVM: selftests: Convert the Hyper-V extended hypercalls test to pri=
ntf asserts
>       KVM: selftests: Convert the Hyper-V feature test to printf style GU=
EST_ASSERT
>       KVM: selftests: Convert x86's KVM paravirt test to printf style GUE=
ST_ASSERT
>       KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest =
asserts
>       KVM: selftests: Convert x86's nested exceptions test to printf gues=
t asserts
>       KVM: selftests: Convert x86's set BSP ID test to printf style guest=
 asserts
>       KVM: selftests: Convert the nSVM software interrupt test to printf =
guest asserts
>       KVM: selftests: Convert x86's TSC MSRs test to use printf guest ass=
erts
>       KVM: selftests: Convert the x86 userspace I/O test to printf guest =
assert
>       KVM: selftests: Convert VMX's PMU capabilities test to printf guest=
 asserts
>       KVM: selftests: Convert x86's XCR0 test to use printf-based guest a=
sserts
>       KVM: selftests: Rip out old, param-based guest assert macros
>       KVM: selftests: Print out guest RIP on unhandled exception
>       KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
>       KVM: selftests: Reload "good" vCPU state if vCPU hits shutdown
>       KVM: selftests: Explicit set #UD when *potentially* injecting excep=
tion
>       KVM: x86: Update MAINTAINTERS to include selftests
>
> Thomas Huth (1):
>       KVM: selftests: Rename the ASSERT_EQ macro
>
>  MAINTAINERS                                        |   2 +
>  arch/x86/kvm/x86.c                                 |  13 +-
>  tools/testing/selftests/kvm/Makefile               |   6 +
>  .../selftests/kvm/aarch64/aarch32_id_regs.c        |   8 +-
>  tools/testing/selftests/kvm/aarch64/arch_timer.c   |  22 +-
>  .../selftests/kvm/aarch64/debug-exceptions.c       |   8 +-
>  tools/testing/selftests/kvm/aarch64/hypercalls.c   |  20 +-
>  .../selftests/kvm/aarch64/page_fault_test.c        |  17 +-
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   3 +-
>  tools/testing/selftests/kvm/guest_print_test.c     | 219 ++++++++++++++
>  .../selftests/kvm/include/aarch64/arch_timer.h     |  12 +-
>  .../testing/selftests/kvm/include/aarch64/ucall.h  |  20 ++
>  tools/testing/selftests/kvm/include/riscv/ucall.h  |  20 ++
>  tools/testing/selftests/kvm/include/s390x/ucall.h  |  19 ++
>  tools/testing/selftests/kvm/include/test_util.h    |  18 +-
>  tools/testing/selftests/kvm/include/ucall_common.h |  98 +++----
>  .../selftests/kvm/include/x86_64/processor.h       |   5 +
>  tools/testing/selftests/kvm/include/x86_64/ucall.h |  13 +
>  tools/testing/selftests/kvm/kvm_page_table_test.c  |   8 +-
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c    |  11 +-
>  tools/testing/selftests/kvm/lib/guest_sprintf.c    | 307 +++++++++++++++=
+++++
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   6 +-
>  tools/testing/selftests/kvm/lib/riscv/ucall.c      |  11 -
>  tools/testing/selftests/kvm/lib/s390x/ucall.c      |  10 -
>  tools/testing/selftests/kvm/lib/sparsebit.c        |   1 -
>  tools/testing/selftests/kvm/lib/string_override.c  |   9 +
>  tools/testing/selftests/kvm/lib/ucall_common.c     |  44 +++
>  tools/testing/selftests/kvm/lib/x86_64/processor.c |  18 +-
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  36 ++-
>  .../testing/selftests/kvm/max_guest_memory_test.c  |   2 +-
>  tools/testing/selftests/kvm/memslot_perf_test.c    |   4 +-
>  tools/testing/selftests/kvm/s390x/cmma_test.c      |  62 ++--
>  tools/testing/selftests/kvm/s390x/memop.c          |  13 +-
>  tools/testing/selftests/kvm/s390x/tprot.c          |  11 +-
>  .../testing/selftests/kvm/set_memory_region_test.c |  21 +-
>  tools/testing/selftests/kvm/steal_time.c           |  20 +-
>  tools/testing/selftests/kvm/x86_64/cpuid_test.c    |  12 +-
>  .../kvm/x86_64/dirty_log_page_splitting_test.c     |  18 +-
>  .../kvm/x86_64/exit_on_emulation_failure_test.c    |   2 +-
>  .../kvm/x86_64/hyperv_extended_hypercalls.c        |   3 +-
>  .../testing/selftests/kvm/x86_64/hyperv_features.c |  29 +-
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |   8 +-
>  .../selftests/kvm/x86_64/monitor_mwait_test.c      |  35 ++-
>  .../selftests/kvm/x86_64/nested_exceptions_test.c  |  16 +-
>  .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 317 +++++++++++++++=
------
>  .../selftests/kvm/x86_64/recalc_apic_map_test.c    |   6 +-
>  .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c |   6 +-
>  .../kvm/x86_64/svm_nested_soft_inject_test.c       |  22 +-
>  .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 132 +++++++++
>  tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |  34 +--
>  .../selftests/kvm/x86_64/userspace_io_test.c       |  10 +-
>  .../vmx_exception_with_invalid_guest_state.c       |   2 +-
>  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |  31 +-
>  .../selftests/kvm/x86_64/xapic_state_test.c        |   8 +-
>  .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |  29 +-
>  .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |  20 +-
>  56 files changed, 1389 insertions(+), 468 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c
>

