Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BB07A8880
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbjITPgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 11:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbjITPgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 11:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA48A3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695224112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbEajULXAP3Q61ZJXMcn4Q1zanKxjfVjx6/MpmB+S+M=;
        b=gamE6pqGKV9jugRBHLy668iVIC7sLnZ4GvC9YnfQV/okNiaIxUv0S2lhuyVKcspM8CZZ2V
        eXXt8V/C9zNV2bciazQX7XlJ42oXxK8Jo9BpXY0K09wItlXhKIQdRYukCEucM0wuPT0zGB
        fNaxMWlHzImwlD41fR4PpDwZ7LrBBXY=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-93voqrvkM0WvPZJRlT0MiQ-1; Wed, 20 Sep 2023 11:35:11 -0400
X-MC-Unique: 93voqrvkM0WvPZJRlT0MiQ-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-48fdc9282ffso2227025e0c.3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695224110; x=1695828910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbEajULXAP3Q61ZJXMcn4Q1zanKxjfVjx6/MpmB+S+M=;
        b=FYUDTkt4bHvCGnfQSzBGHA922qoet+jXno4Lkc3aNLZYyxIKKfYMXbXJIujRxnL7b1
         ZFTnE/Ea2XO27KZbVwlc01YU24CCnKCoE1xJy37hmhDZJ+EDszC9zOHuFJ19azYJ1fky
         sfJfaLX1wiQYMyAHpXXj1Gr4NjiIKT+ml/tiwRhs4qcD3elPb02J7IPihh1vXFxQmAq7
         kDiAXWPAaliHLVrPzpEeFtwa/WU0tG8CQVBEfsWA/bMsqbdis84JHaFyv506gayPxRFJ
         f70Q6gsRKyLbXb3XQYKdk4pyIV3liodOb+wECw24LyLvAg1Zhf0Ndeqg6Rfbo6A8yCyD
         wgrQ==
X-Gm-Message-State: AOJu0YyrcoQ/Excsn1iDTRSLqyDoEP9AKMVkDR82WShTR/J2DkmpZ/12
        Z/+Bxb2Qj2/lazZv+5cT6CWBZWVeyeoqIKaiAYGMPqK+UT5dswNedRd+uY+NNYt2UJjrIJhvEds
        lJEJsqn6AmZPzMsdK9I6TLWCXZcv6
X-Received: by 2002:a1f:48c3:0:b0:48d:ae0:c53 with SMTP id v186-20020a1f48c3000000b0048d0ae00c53mr2435527vka.10.1695224110611;
        Wed, 20 Sep 2023 08:35:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrqeuxLnw7a3TVRru2dys+V8MuVNfopw4/RA2QCIlYrxSxkdRdNdwkezCtFCwJhiTUcf4r2k5H1IPvt2BnnaU=
X-Received: by 2002:a1f:48c3:0:b0:48d:ae0:c53 with SMTP id v186-20020a1f48c3000000b0048d0ae00c53mr2435515vka.10.1695224110294;
 Wed, 20 Sep 2023 08:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230901231330.3608891-1-seanjc@google.com>
In-Reply-To: <20230901231330.3608891-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 20 Sep 2023 17:34:59 +0200
Message-ID: <CABgObfY90SJrOOKOwfm+-c2Ri4=V=_J0kgzBvphWGSDZ9gSc2w@mail.gmail.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 2, 2023 at 1:13=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> This is essentially v2 of the previous attempt[*], sans the fix for exect=
uable
> stack warnings (now fixed for all architectures), plus fixes for nVMX tes=
tcases
> related to 64-bit hosts (these *just* got posted, but it's not like anyon=
e else
> is reviewing KUT x86 changes these days, so I don't see any point in wait=
ing).
>
> There's one non-x86 change to fix a bug in processing "check" entries in
> unittests.cfg files.  The majority of the x86 changes revolve around nSVM=
, PMU,
> and emulator tests.
>
> [*] https://lore.kernel.org/all/20230622211440.2595272-1-seanjc@google.co=
m
>
> The following changes since commit e8f8554f810821e37f05112a46ae9775a029b5=
d1:
>
>   Makefile: Move -no-pie from CFLAGS into LDFLAGS (2023-08-22 11:26:00 +0=
200)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.09.01
>
> for you to fetch changes up to d4fba74a42d222d2cfdde65351fac3531a1d6f5c:
>
>   nVMX: Fix the noncanonical HOST_RIP testcase (2023-09-01 15:58:19 -0700=
)

Pulled, thanks!

Paolo

>
> ----------------------------------------------------------------
> x86 fixes, cleanups, and new testcases, and a few generic changes
>
>  - Fix a bug in runtime.bash that caused it to mishandle "check" strings =
with
>    multiple entries, e.g. a test that depends on multiple module params
>  - Make the PMU tests depend on vPMU support being enabled in KVM
>  - Fix PMU's forced emulation test on CPUs with full-width writes
>  - Add a PMU testcase for measuring TSX transactional cycles
>  - Nested SVM testcase for virtual NMIs
>  - Move a pile of code to ASM_TRY() and "safe" helpers
>  - Set up the guest stack in the LBRV tests so that the tests don't fail =
if the
>    compiler decides to generate function calls in guest code
>  - Ignore the "mispredict" flag in nSVM's LBRV tests to fix false failure=
s
>  - Clean up usage of helpers that disable interrupts, e.g. stop inserting
>    unnecessary nops
>  - Add helpers to dedup code for programming the APIC timer
>  - Fix a variety of bugs in nVMX testcases related to being a 64-bit host
>
> ----------------------------------------------------------------
> Like Xu (2):
>       x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
>       x86/pmu: Wrap the written counter value with gp_counter_width
>
> Mathias Krause (15):
>       x86: Drop types.h
>       x86: Use symbolic names in exception_mnemonic()
>       x86: Add vendor specific exception vectors
>       x86/cet: Use symbolic name for #CP
>       x86/access: Use 'bool' type as defined via libcflat.h
>       x86/run_in_user: Preserve exception handler
>       x86/run_in_user: Relax register constraints of inline asm
>       x86/run_in_user: Reload SS after successful return
>       x86/fault_test: Preserve exception handler
>       x86/emulator64: Relax register constraints for usr_gs_mov()
>       x86/emulator64: Switch test_sreg() to ASM_TRY()
>       x86/emulator64: Add non-null selector test
>       x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
>       x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
>       x86/emulator64: Test non-canonical memory access exceptions
>
> Maxim Levitsky (8):
>       x86: replace irq_{enable|disable}() with sti()/cli()
>       x86: introduce sti_nop() and sti_nop_cli()
>       x86: add few helper functions for apic local timer
>       x86: nSVM: Remove nop after stgi/clgi
>       x86: nSVM: make svm_intr_intercept_mix_if/gif test a bit more robus=
t
>       x86: nSVM: use apic_start_timer/apic_stop_timer instead of open cod=
ing it
>       x86: nSVM: Add nested shutdown interception test
>       x86: nSVM: Remove defunct get_npt_pte() declaration
>
> Santosh Shukla (1):
>       x86: nSVM: Add support for VNMI test
>
> Sean Christopherson (21):
>       nSVM: Add helper to report fatal errors in guest
>       x86: Add macros to wrap ASM_TRY() for single instructions
>       x86: Convert inputs-only "safe" instruction helpers to asm_safe()
>       x86: Add macros to wrap ASM_TRY() for single instructions with outp=
ut(s)
>       x86: Move invpcid_safe() to processor.h and convert to asm_safe()
>       x86: Move XSETBV and XGETBV "safe" helpers to processor.h
>       x86: nSVM: Set up a guest stack in LBRV tests
>       lib: Expose a subset of VMX's assertion macros
>       x86: Add defines for the various LBR record bit definitions
>       x86: nSVM: Ignore mispredict bit in LBR records
>       x86: nSVM: Replace check_dbgctl() with TEST_EXPECT_EQ() in LBRV tes=
t
>       x86: nSVM: Print out RIP and LBRs from VMCB if LBRV guest test fail=
s
>       runtime: Convert "check" from string to array so that iterating wor=
ks
>       x86/pmu: Make PMU testcases dependent on vPMU being enabled in KVM
>       nVMX: Test CR4.PCIDE can be set for 64-bit host iff PCID is support=
ed
>       nVMX: Assert CR4.PAE is set when testing 64-bit host
>       nVMX: Assert that the test is configured for 64-bit mode
>       nVMX: Rename vmlaunch_succeeds() to vmlaunch()
>       nVMX: Shuffle test_host_addr_size() tests to "restore" CR4 and RIP
>       nVMX: Drop testcase that falsely claims to verify vmcs.HOST_RIP[63:=
32]
>       nVMX: Fix the noncanonical HOST_RIP testcase
>
>  lib/util.h                |  31 ++++
>  lib/x86/apic.c            |  38 ++++
>  lib/x86/apic.h            |   6 +
>  lib/x86/desc.c            |  43 +++--
>  lib/x86/desc.h            |  48 ++++++
>  lib/x86/fault_test.c      |   4 +-
>  lib/x86/msr.h             |  11 ++
>  lib/x86/processor.h       | 137 +++++++++------
>  lib/x86/smp.c             |   2 +-
>  lib/x86/usermode.c        |  38 ++--
>  scripts/runtime.bash      |   1 +
>  x86/access.c              |  11 +-
>  x86/apic.c                |   6 +-
>  x86/asyncpf.c             |   6 +-
>  x86/cet.c                 |   2 +-
>  x86/cmpxchg8b.c           |   1 -
>  x86/emulator.c            |   1 -
>  x86/emulator64.c          | 105 +++++++-----
>  x86/eventinj.c            |  22 +--
>  x86/hyperv_connections.c  |   2 +-
>  x86/hyperv_stimer.c       |   4 +-
>  x86/hyperv_synic.c        |   6 +-
>  x86/intel-iommu.c         |   2 +-
>  x86/ioapic.c              |  15 +-
>  x86/memory.c              |  60 ++-----
>  x86/pcid.c                |   8 -
>  x86/pmu.c                 |  52 +++++-
>  x86/pmu_pebs.c            |   1 -
>  x86/svm.c                 |  17 +-
>  x86/svm.h                 |  11 +-
>  x86/svm_tests.c           | 429 +++++++++++++++++++++++-----------------=
------
>  x86/taskswitch2.c         |   4 +-
>  x86/tscdeadline_latency.c |   4 +-
>  x86/types.h               |  21 ---
>  x86/unittests.cfg         |   7 +-
>  x86/vmexit.c              |  18 +-
>  x86/vmx.h                 |  32 +---
>  x86/vmx_tests.c           | 170 +++++++++---------
>  x86/xsave.c               |  31 +---
>  39 files changed, 779 insertions(+), 628 deletions(-)
>  delete mode 100644 x86/types.h
>

