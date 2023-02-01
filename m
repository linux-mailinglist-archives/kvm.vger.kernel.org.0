Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560C46871A0
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBAXM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAXMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:12:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631076DFC8
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:12:53 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cq16-20020a17090af99000b0022c9791ac39so3838584pjb.4
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9tAtzjeHojtEDtxt65Up2XJCtorJ5dH8vJi//jm5SK8=;
        b=T5Tvgujc1usQ+DzfONjL8+ISjVZg2pmf9LFbeyRSHWmvMSr+3r665WHmzPqgbCnRnK
         PYyz9R9udgjzNstYKj7xREH6oiZmyB8YbcCRHXEgBC74F9KuIbHpHuiwq6m28A08m+To
         bfyGwkqJc8412Q6k2kXjX3YT5KWUns6MZfuGHvzZ53CPEzojRhge1w6k7jlo2w2+XSR1
         SJIeN8cukKxDFLD4Lo8KL6VQ1RjSz3YqSd3qpk8wWkcKW2F+Zk9aSn9KiNFREusHTuTj
         /His0UCRUwS2oNFkhqZkCdi6UzJmECRsgnGqyqxJdfjvrP3F/Bfthrk/mHYEmzG1XOqH
         SoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tAtzjeHojtEDtxt65Up2XJCtorJ5dH8vJi//jm5SK8=;
        b=r27Gtf67jyOSydJC+D5XVWv2EPINaMl1NGIMKc96Wul7I6HvxMGySXGm3bTcjUE2TZ
         7jy2BZgQ3E9Jxbet1E51431SsamQmDCUJAqF3XVeiKSE4bot3H9S/82tdMnxWMaiIXUG
         z07FiYq1FBVPXpW7SSA7lNKZmKEgfDziEablr0VPZAF50m0OMCGpZcVJVpYacdlqiBnu
         //+7WlO78x84s7bXuYCCC9weJB0F0CPNu2VZmgXSNlH9JqlDnZkLDZ/QQ3LNC0WvcQWw
         +AUsZDbPw54d/lxnbtDtEcsvPzcxVncJBPFjuzdSCez7O8e5/TnVrlA86wEN1SujM/Zg
         G+/A==
X-Gm-Message-State: AO0yUKXpx9qHXxItIPBZWp9P6H5ukOSEb5v2/YCMObwQUAx+Y9R7UfIh
        Zh2mSeYkGLpcwblMoqnqLNlkXw==
X-Google-Smtp-Source: AK7set81x9SFPlR2xt2LL3p/gzp9UDd4QwKeSPV35HuGWe1moKyUrZEQddhquz69J42M/1OcHdR4Nw==
X-Received: by 2002:a17:90b:3ec3:b0:230:3af9:183 with SMTP id rm3-20020a17090b3ec300b002303af90183mr337135pjb.20.1675293172782;
        Wed, 01 Feb 2023 15:12:52 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:12:52 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 00/14] KVM perf support 
Date:   Wed,  1 Feb 2023 15:12:36 -0800
Message-Id: <20230201231250.3806412-1-atishp@rivosinc.com>
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

1. PATCH 1-5 are generic KVM/PMU driver improvements.
2. PATCH 9 disables hpmcounter for now. It will be enabled to maintain ABI
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
https://github.com/atishp04/linux/tree/kvm_perf_v4

TODO:
1. Add sscofpmf support.
2. Add One reg interface for the following operations:
	1. Enable/Disable PMU (should it at VM level rather than vcpu ?)
	2. Number of hpmcounter and width of the counters
	3. Init PMU
	4. Allow guest user to access cycle & instret without trapping
3. Move counter mask to a bitmask instead of unsigned long so that it can work
   for RV32 systems where number of total counters are more than 32.
   This will also accomodate future systems which may define maximum counters
   to be more than 64. 

Changes from v3->v4:
1. Addressed all the comments on v3.
2. Modified the vcpu_pmu_init to void return type.
3. Redirect illegal instruction trap to guest for invalid hpmcounter access
   instead of exiting to the userpsace.
4. Got rid of unecessary error messages.

Changes v2->v3:
1. Changed the exported functions to GPL only export.
2. Addressed all the nit comments on v2.
3. Split non-kvm related changes into separate patches.
4. Reorgainze the PATCH 11 and 10 based on Drew's suggestions.

Changes from v1->v2:
1. Addressed comments from Andrew.
2. Removed kvpmu sanity check.
3. Added a kvm pmu init flag and the sanity check to probe function.
4. Improved the linux vs sbi error code handling.
 

Atish Patra (14):
perf: RISC-V: Define helper functions expose hpm counter width and
count
perf: RISC-V: Improve privilege mode filtering for perf
RISC-V: Improve SBI PMU extension related definitions
RISC-V: KVM: Define a probe function for SBI extension data structures
RISC-V: KVM: Return correct code for hsm stop function
RISC-V: KVM: Modify SBI extension handler to return SBI error code
RISC-V: KVM: Add skeleton support for perf
RISC-V: KVM: Add SBI PMU extension support
RISC-V: KVM: Make PMU functionality depend on Sscofpmf
RISC-V: KVM: Disable all hpmcounter access for VS/VU mode
RISC-V: KVM: Implement trap & emulate for hpmcounters
RISC-V: KVM: Implement perf support without sampling
RISC-V: KVM: Support firmware events
RISC-V: KVM: Increment firmware pmu events

arch/riscv/include/asm/kvm_host.h     |   4 +
arch/riscv/include/asm/kvm_vcpu_pmu.h | 110 +++++
arch/riscv/include/asm/kvm_vcpu_sbi.h |  13 +-
arch/riscv/include/asm/sbi.h          |   7 +-
arch/riscv/kvm/Makefile               |   1 +
arch/riscv/kvm/main.c                 |   3 +-
arch/riscv/kvm/tlb.c                  |   4 +
arch/riscv/kvm/vcpu.c                 |   7 +
arch/riscv/kvm/vcpu_insn.c            |   4 +-
arch/riscv/kvm/vcpu_pmu.c             | 627 ++++++++++++++++++++++++++
arch/riscv/kvm/vcpu_sbi.c             |  72 ++-
arch/riscv/kvm/vcpu_sbi_base.c        |  43 +-
arch/riscv/kvm/vcpu_sbi_hsm.c         |  28 +-
arch/riscv/kvm/vcpu_sbi_pmu.c         |  85 ++++
arch/riscv/kvm/vcpu_sbi_replace.c     |  50 +-
arch/riscv/kvm/vcpu_sbi_v01.c         |  18 +-
drivers/perf/riscv_pmu_sbi.c          |  64 ++-
include/linux/perf/riscv_pmu.h        |   5 +
18 files changed, 1029 insertions(+), 116 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
create mode 100644 arch/riscv/kvm/vcpu_pmu.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c

--
2.25.1

