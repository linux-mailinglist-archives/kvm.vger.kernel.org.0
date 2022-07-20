Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D79357BE57
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiGTTXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiGTTXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:23:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A744F6A4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:51 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 70so17350907pfx.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rYEr3CWt7D7LyMtY/KQgoEUMdbBRKLvSXoaIBCH+uKw=;
        b=cLeXtxL8A5i621Cmtp30NZvRnlsHMqasoKAmiUkbkF7I0nbcvXY6dMOsi5Y4pV0Gq7
         1juMoXyZpG0y0mr0OhpOxILnIN1rzdAUY1MyhEZnvwUCCakmVX/71WAxPnYWdAuS6lPU
         F/UORxjj8kDmIcUxUd8U4DkDKDQ088ny+3HqPkhHuAbS4zdTDhd0evOV6HoWXwOzrHet
         XPOmiopRaQ060l0zDHisuHeO3XlR+Tu5iKZp6sqvD5fUn4y55jMOGAs3fwyPIGkgSw8L
         cXdUH+6IbINv3hwQWjKyB9GYr6xcoYAPy6Q6ZbdTGBiRpoUgDHEJAongyM74ELEKOaBN
         jqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rYEr3CWt7D7LyMtY/KQgoEUMdbBRKLvSXoaIBCH+uKw=;
        b=GrsgR9+9UqY22gzX9W/2QvRwMCtYdiK3k8hnfCaWFoKr4UuaJ7YvSmsuo18IVO8Gx9
         0G2MIb2s1EG9Ob1/fuwrbNYl0K6TZiqNmPyFt0H1wMsw5jnK4MenfN5uvGixyMm/GPNv
         tBgZw1vr2DsLLJECCCEojjUX3gBpH/SpVvQ+JiXmO+TfBJptVC2uvqFO2ur1CsPx9qOB
         2Q3YR84D7wJShPLFWvatx+zgkz9enoSHjQHrEOeIJqDtRYgNw9PNporDTw2cVLq2RGe8
         yU054HuEFDqOBhHWz+jr5dHeUxcCosEXZ7M9nikz2PidLs/s9EW+5biq1BE3QTDV9k1c
         Ia8w==
X-Gm-Message-State: AJIora9Z5PO2EoLAhU3rBYvSchRWYOeQUOWdgo+8KbG8Eg+nk88lz67R
        ld5SGGk+sd6BoglB6eJ4LK4tKQ==
X-Google-Smtp-Source: AGRyM1s3OS9Pbf3tyCbJjBgXJVlqnxlUxUxjW0UMafJ5PdPCVGnrourOUYb1hAv4WKDpNnGR7GKvZg==
X-Received: by 2002:a05:6a00:22d5:b0:52b:af2:9056 with SMTP id f21-20020a056a0022d500b0052b0af29056mr39885946pfj.80.1658345031222;
        Wed, 20 Jul 2022 12:23:51 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b0016d2e772550sm219902pli.175.2022.07.20.12.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 12:23:50 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Liu Shaohua <liush@allwinnertech.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v5 0/4] Add Sstc extension support 
Date:   Wed, 20 Jul 2022 12:23:38 -0700
Message-Id: <20220720192342.3428144-1-atishp@rivosinc.com>
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

This series implements Sstc extension support which was ratified recently.
Before the Sstc extension, an SBI call is necessary to generate timer
interrupts as only M-mode have access to the timecompare registers. Thus,
there is significant latency to generate timer interrupts at kernel.
For virtualized enviornments, its even worse as the KVM handles the SBI call
and uses a software timer to emulate the timecomapre register. 

Sstc extension solves both these problems by defining a stimecmp/vstimecmp
at supervisor (host/guest) level. It allows kernel to program a timer and
recieve interrupt without supervisor execution enviornment (M-mode/HS mode)
intervention.

KVM directly updates the vstimecmp as well if the guest kernel invokes the SBI
call instead of updating stimecmp directly. This is required because KVM will
enable sstc extension if the hardware supports it unless the VMM explicitly
disables it for that guest. The hardware is expected to compare the
vstimecmp at every cycle if sstc is enabled and any stale value in vstimecmp
will lead to spurious timer interrupts. This also helps maintaining the
backward compatibility with older kernels.

Similary, the M-mode firmware(OpenSBI) uses stimecmp for older kernel
without sstc support as STIP bit in mip is read only for hardware with sstc. 

The PATCH 1 & 2 enables the basic infrastructure around Sstc extension while
PATCH 3 lets kernel use the Sstc extension if it is available in hardware.
PATCH 4 implements the Sstc extension in KVM.

This series has been tested on Qemu(RV32 & RV64) with additional patches in
Qemu[2]. This series can also be found at [3].

Changes from v4->v5:
1. Added RB tag.
2. Changed the pr-format.
3. Rebased on 5.19-rc7 and kvm-queue.
4. Moved the henvcfg modification from hardware enable to vcpu_load.

Changes from v3->v4:
1. Rebased on 5.18-rc6
2. Unified vstimemp & next_cycles.
3. Addressed comments in PATCH 3 & 4.

Changes from v2->v3:
1. Dropped unrelated KVM fixes from this series.
2. Rebased on 5.18-rc3.

Changes from v1->v2:
1. Separate the static key from kvm usage
2. Makde the sstc specific static key local to the driver/clocksource
3. Moved the vstimecmp update code to the vcpu_timer
4. Used function pointers instead of static key to invoke vstimecmp vs
   hrtimer at the run time. This will help in future for migration of vms
   from/to sstc enabled hardware to non-sstc enabled hardware.
5. Unified the vstimer & timer to 1 timer as only one of them will be used
   at runtime.

[1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
[2] https://github.com/atishp04/qemu/tree/sstc_v4
[3] https://github.com/atishp04/linux/tree/sstc_v5

Atish Patra (4):
RISC-V: Add SSTC extension CSR details
RISC-V: Enable sstc extension parsing from DT
RISC-V: Prefer sstc extension if available
RISC-V: KVM: Support sstc extension

arch/riscv/include/asm/csr.h            |   5 +
arch/riscv/include/asm/hwcap.h          |   1 +
arch/riscv/include/asm/kvm_vcpu_timer.h |   7 ++
arch/riscv/include/uapi/asm/kvm.h       |   1 +
arch/riscv/kernel/cpu.c                 |   1 +
arch/riscv/kernel/cpufeature.c          |   1 +
arch/riscv/kvm/vcpu.c                   |   7 +-
arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
drivers/clocksource/timer-riscv.c       |  24 +++-
9 files changed, 183 insertions(+), 8 deletions(-)

--
2.25.1

