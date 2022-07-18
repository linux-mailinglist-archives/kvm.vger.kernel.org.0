Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC719578807
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiGRRFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiGRRFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FC62B622
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b9so11179385pfp.10
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGesJ3xfjvEZZZT4415xoctAQUbMYAHu9Vlt5BYorCE=;
        b=5JFtYGglR01I9DhQBYCwoYAMeOZTQ5L8KPmhPGIJtyk5rPeYbL3lmjLJsSbb84p7uH
         NNS434TKXVpsr10GmlK9T3Z57kMKBnRmYmC3RQ7etjgeeoGxZrfyeK8pexveK+5N1GOx
         GIe8eJafDVIRnMXuS2j5QcA92rrI0+7uI387VUsYMNRW3zIJedYiPPzwTlk8uH7x0RhM
         TuDiDsc8jvK3gz191+wq+q6khGXydS2lBedj0NvL1gTMN0vWumOn7hfcv7bAsv7uTHoz
         AQpvXVxFPnNxDCMIOoNVnf6r+YTqCpUro5bxYrH6KGilcyXIAtvAHifx/QmJpX2/QgKV
         Id5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CGesJ3xfjvEZZZT4415xoctAQUbMYAHu9Vlt5BYorCE=;
        b=xREMNDLFz+20UkQMa/i8wikV/bxyKO0EONnMwfDvmGlISmHzVlAlajI5Jzpt0IgEg4
         jDvO2bvIf4rXzD7xM75x10NptCK4sc/Exciv6Bb4TnDRBk3i8RdXGcwUDBoWN2hpYwRP
         cmAsRAa2pp/+PyEoxBAh4drat9Qwn0QgEqv2kmwJtfMIiLkvOMmxvE54wkpXpo8M8By/
         ciblFX/xoiOSY4llbD0MIoIUOgUkV3QOVslTh9h6AmxoIvuJ54pYoO3GJqVBLzdbCDmy
         uzpn2QHRXzCYhN4vtPHbZ/Ng8jr7WxDuq1csM8g+XmcMnZ7yZnGYWG+6MhpJsTwW66tb
         qBUA==
X-Gm-Message-State: AJIora+ITO28GqmxljOFdnNy+U1wNL75Ltq5kwPcscY8rd8mfBOETFAk
        3+vZnzqnDkLatEIcbX11ww6jQA==
X-Google-Smtp-Source: AGRyM1sZUAbOKv1l9BvJXO4uJ53bhkJoChfrjodGKmMwMpV0cMcmUqURMqfDyGhsUsFAGT0TeFFbgg==
X-Received: by 2002:a65:4906:0:b0:40d:dd28:448a with SMTP id p6-20020a654906000000b0040ddd28448amr24126209pgs.567.1658163943502;
        Mon, 18 Jul 2022 10:05:43 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:42 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC  0/9] KVM perf support 
Date:   Mon, 18 Jul 2022 10:01:56 -0700
Message-Id: <20220718170205.2972215-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends perf support for KVM. The KVM implementation relies
on the SBI PMU extension and trap n emulation of hpmcounter CSRs.
The KVM implementation exposes the virtual counters to the guest and internally
manage the counters using kernel perf counters. 

This series doesn't support the counter overflow as the Sscofpmf extension
doesn't allow trap & emulation mechanism of scountovf CSR yet. The required
changes to allow that are being under discussions. Supporting overflow interrupt
also requires AIA support which is not frozen either.

This series can be found at github[1] as well. It depends Anup's CSR emulation
framework[1] series.

perf stat works in kvm guests with this series. 

Here is example of running perf stat in a guest running in KVM.
===========================================================================
/ # /host/apps/perf stat -e instructions -e cycles -e r8000000000000005 \
> -e r8000000000000006 -e r8000000000000007 -e r8000000000000008 \
> -e r800000000000000a perf bench sched messaging -g 5 -l 15
# Running 'sched/messaging' benchmark:
# 20 sender and receiver processes per group
# 5 groups == 200 processes run

     Total time: 5.210 [sec] 

 Performance counter stats for 'perf bench sched messaging -g 5 -l 15':

       37209585734      instructions              #    1.00  insn per cycle
       37177435570      cycles 
              2740      r8000000000000005
              3727      r8000000000000006
              3655      r8000000000000007
                10      r8000000000000008
                 0      r800000000000000a

       5.863014800 seconds time elapsed

       0.569373000 seconds user
      10.771533000 seconds sys 

[1] https://github.com/atishp04/linux/tree/kvm_perf_rfc
[2] https://lkml.org/lkml/2022/6/15/389

Atish Patra (9):
RISC-V: Define a helper function to probe number of hardware counters
RISC-V: Define a helper function to return counter width
RISC-V: KVM: Define a probe function for SBI extension data structures
RISC-V: KVM: Improve privilege mode filtering for perf
RISC-V: KVM: Add skeleton support for perf
RISC-V: KVM: Add SBI PMU extension support
RISC-V: KVM: Implement trap & emulate for hpmcounters
RISC-V: KVM: Implement perf support
RISC-V: KVM: Implement firmware events

arch/riscv/include/asm/kvm_host.h     |   3 +
arch/riscv/include/asm/kvm_vcpu_pmu.h | 102 +++++
arch/riscv/include/asm/kvm_vcpu_sbi.h |   3 +
arch/riscv/include/asm/sbi.h          |   2 +-
arch/riscv/kvm/Makefile               |   1 +
arch/riscv/kvm/main.c                 |   3 +-
arch/riscv/kvm/tlb.c                  |   6 +-
arch/riscv/kvm/vcpu.c                 |   5 +
arch/riscv/kvm/vcpu_insn.c            |   4 +-
arch/riscv/kvm/vcpu_pmu.c             | 517 ++++++++++++++++++++++++++
arch/riscv/kvm/vcpu_sbi.c             |  11 +
arch/riscv/kvm/vcpu_sbi_base.c        |  13 +-
arch/riscv/kvm/vcpu_sbi_pmu.c         |  81 ++++
arch/riscv/kvm/vcpu_sbi_replace.c     |   7 +
drivers/perf/riscv_pmu_sbi.c          |  75 +++-
include/linux/perf/riscv_pmu.h        |   7 +
16 files changed, 823 insertions(+), 17 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
create mode 100644 arch/riscv/kvm/vcpu_pmu.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c

--
2.25.1

