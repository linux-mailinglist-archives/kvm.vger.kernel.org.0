Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466A364DF2A
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 18:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiLORBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 12:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiLORBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 12:01:15 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C554D25E89
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:01:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 17so7567191pll.0
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qx+V0HqoGlECsFSjn8+kKGYij8Unq8RFOTIoeLkQqAQ=;
        b=WZQXttZyILm2FtfOQTdSxF4+l7eAT9OOLhvMed/ku0pv/3kGzRZB4o8NNG2v02zWFN
         fagBkxAG6+UvXOnYtV8Jgm7HB8xik9lQ+iJAncmqh2VjKjrieJMFXPagnVPu8dnzqbr+
         0eAx2hqQe3Y/tbMeBggbIPePlmUu8ApFm+/hCgi+FBpmlFlyVvlEKTrGbBa727FdLn2f
         UFCBwNTAonW6bcQXv6dc0+G4xpmoj5YzygeHPlRXo1xx3eKosznF7obEewjhjocmxrPl
         vmt/2erJr3c8CrnPGS3R/FoejHxONTpgeuVvPa+B3CGqPdxjnr6NC5BByjCQOmRiSpVF
         MhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qx+V0HqoGlECsFSjn8+kKGYij8Unq8RFOTIoeLkQqAQ=;
        b=dMo24o03LpnPiDxBOq5/ov3tK8LGXS3NnKaWPIAAdJRBL65QaemhroEw8cbvNgNK0V
         UMyVkSknVvpJBlUyaJPgn2tMtBCPNbOxUXKj4wGH7v5F7HwSYfsoiXf80abOn/y5SGHF
         Jd3l5zv7dKd9DmVWJD7jhdU/mYK6nX3l7vvDYhlQnaREc7mAWO2X9C80ewvu+k6j0IyM
         4BwO02+Fuzz/gJ3NJF3oLmZJ9tpxolP+6HHe4jBCzmpUEBJEGAyKbceUR2Ce9IY5ye1Q
         VJGC1wbd6c+EZvLriyuEUHkpLWO5BHSXt39+sQy6HYuA1AqdZdS0N3RQsDOtzo19ZwxB
         63xQ==
X-Gm-Message-State: ANoB5pmWodRsdYlBmty0DsjYT+qu5aMuqkxk3Ht5Bxu5svcTW2DpoBDK
        lcS3Q9d4F/+uyFbfxI148LQalw==
X-Google-Smtp-Source: AA0mqf5TkLz3QZ1wHVXjlDJpRXfvkaXq+tzppq0b/+DN8W04g5Gzmus0QFBMg0gMnAl+4LQ8Y6HeMg==
X-Received: by 2002:a17:902:b083:b0:18c:d9df:a4b5 with SMTP id p3-20020a170902b08300b0018cd9dfa4b5mr26407596plr.7.1671123673271;
        Thu, 15 Dec 2022 09:01:13 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b001897bfc9800sm4067449pll.53.2022.12.15.09.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:01:12 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v2 00/11] KVM perf support 
Date:   Thu, 15 Dec 2022 09:00:35 -0800
Message-Id: <20221215170046.2010255-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
also requires AIA interrupt filtering support.

1. PATCH1-4 are generic KVM/PMU driver improvements.
2. PATCH8 disables hpmcounter for now. It will be enabled to maintain ABI
requirement once the ONE reg interface is settled. 

perf stat works in kvm guests with this series. 

Here is example of running perf stat in a guest running in KVM.

===========================================================================
/ # /host/apps/perf stat -e instructions -e cycles -e r8000000000000005 \
> -e r8000000000000006 -e r8000000000000007 -e r8000000000000008 \
> -e r800000000000000a perf bench sched messaging -g 10 -l 10

# Running 'sched/messaging' benchmark:
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 7.769 [sec]
                 
 Performance counter stats for 'perf bench sched messaging -g 10 -l 10':

       73556259604      cycles
       73387266056      instructions              #    1.00  insn per cycle
                 0      dTLB-store-misses
                 0      iTLB-load-misses
                 0      r8000000000000005
              2595      r8000000000000006
              2272      r8000000000000007
                10      r8000000000000008
                 0      r800000000000000a

      12.173720400 seconds time elapsed

       1.002716000 seconds user
      21.931047000 seconds sys


Note: The SBI_PMU_FW_SET_TIMER (eventid : r8000000000000005) is zero
as kvm guest supports sstc now. 

This series can be found here as well.
https://github.com/atishp04/linux/tree/kvm_perf_v2

TODO:
1. Add sscofpmf support.
2. Add One reg interface for the following operations:
	1. Enable/Disable PMU (should it at VM level rather than vcpu ?)
	2. Number of hpmcounter and width of the counters
	3. Init PMU
	4. Allow guest user to access cycle & instret without trapping

Changes from v1->v2:
1. Addressed comments from Andrew.
2. Removed kvpmu sanity check.
3. Added a kvm pmu init flag and the sanity check to probe function.
4. Improved the linux vs sbi error code handling.
 

Atish Patra (11):
RISC-V: Define helper functions expose hpm counter width and count
RISC-V: KVM: Define a probe function for SBI extension data structures
RISC-V: KVM: Return correct code for hsm stop function
RISC-V: KVM: Modify SBI extension handler to return SBI error code
RISC-V: KVM: Improve privilege mode filtering for perf
RISC-V: KVM: Add skeleton support for perf
RISC-V: KVM: Add SBI PMU extension support
RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
RISC-V: KVM: Implement trap & emulate for hpmcounters
RISC-V: KVM: Implement perf support without sampling
RISC-V: KVM: Implement firmware events

arch/riscv/include/asm/kvm_host.h     |   3 +
arch/riscv/include/asm/kvm_vcpu_pmu.h | 108 +++++
arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
arch/riscv/include/asm/sbi.h          |   2 +-
arch/riscv/kvm/Makefile               |   1 +
arch/riscv/kvm/main.c                 |   3 +-
arch/riscv/kvm/tlb.c                  |   6 +-
arch/riscv/kvm/vcpu.c                 |   5 +
arch/riscv/kvm/vcpu_insn.c            |   4 +-
arch/riscv/kvm/vcpu_pmu.c             | 585 ++++++++++++++++++++++++++
arch/riscv/kvm/vcpu_sbi.c             |  56 ++-
arch/riscv/kvm/vcpu_sbi_base.c        |  45 +-
arch/riscv/kvm/vcpu_sbi_hsm.c         |  22 +-
arch/riscv/kvm/vcpu_sbi_pmu.c         |  86 ++++
arch/riscv/kvm/vcpu_sbi_replace.c     |  51 ++-
drivers/perf/riscv_pmu_sbi.c          |  62 ++-
include/linux/perf/riscv_pmu.h        |   5 +
17 files changed, 963 insertions(+), 94 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
create mode 100644 arch/riscv/kvm/vcpu_pmu.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c

--
2.25.1

