Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACCC57D300
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiGUSM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiGUSMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:12:24 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFC631385
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e132so2360245pgc.5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFNoGkEpqZ0ZZUn8QgTK9f9e2SF2KokqJRLIpbyDvaQ=;
        b=JU3qmK3RlD4+t2a2ZSOXCURgt6cpux/CQIb7FIcuLolQvk7dnHol5Fry4fHI1+giDD
         wVZkCIEK7AIgn7/38SrgEtN2oZsnU3vyFW4DRP0PZYxy8KhWxE3sGuOeqrjA1st4DQnT
         /8FjXj/LP4kqsWxgEYAQuU84OSKy+9i8QQRqap+0NjHqRkTDtBLOhPCcvGK3BKrUL8we
         8sMLWQdap+IgT6f24XjJdio9YuBk7/nm4GYgz9dO61wXDu4oumueqv8s3bDetE0C6lMR
         Xf0FkulJPHdvyi2jdXUcqFZ+vVvD+HjqOng0OgpJVj4qL3yxA2lU6sUKwQ4TnQsUmtj6
         EMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFNoGkEpqZ0ZZUn8QgTK9f9e2SF2KokqJRLIpbyDvaQ=;
        b=L1ipngiSa56CrJWau8kdMWebhqfAmgijdJ3BOdW62j5Pkwz6dRJuiI7zgzROqgqh9k
         O5nX618RsALhKMGPZ0vhOcYx8Pnn6sObMatUuiYhL1+9doslkTQ5sK1Qt4i8oDE1SKUQ
         qrNGDOi3PCyIGc0qw7scoXmZ5GJua9NgHSSBwKKnsPLknu9nhuhLxWhJQeVtTATS3LEG
         9n9zQjVMouvj5qdVJUH+SG8PGoyH6fpNWFsu5/Qz0oEVTtf3TsMpW96maoZeUItWD2IW
         P/C+eMhlIKs7qPOCmwCGVrQO29yzdq1ZF0R3GJ5Nb6SMTraPzd2YbfkS2FTjognI0Uc9
         srbA==
X-Gm-Message-State: AJIora9IhiPhL0ImCGEvp6uqJ4A8QsnFFeyFWkwukRfQI67+T06UF4/Q
        rY67LbhOY42v81QPALw6fprhrgKCRvwdrA==
X-Google-Smtp-Source: AGRyM1sweUen+aNGv5VBOyhlZwmXMBcK/5AdbKESfeVg7uhbOBZIOOmnsphwW8Pr3CHtTNuxyptDPQ==
X-Received: by 2002:a05:6a00:450d:b0:52b:84ca:9509 with SMTP id cw13-20020a056a00450d00b0052b84ca9509mr17520079pfb.74.1658427142864;
        Thu, 21 Jul 2022 11:12:22 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm617358plm.89.2022.07.21.11.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:12:22 -0700 (PDT)
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
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v6 0/4] Add Sstc extension support 
Date:   Thu, 21 Jul 2022 11:12:08 -0700
Message-Id: <20220721181212.3705138-1-atishp@rivosinc.com>
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

Changes from v5->v6:
1. Moved SSTC extension enum below SVPBMT.

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
[2] https://github.com/atishp04/qemu/tree/sstc_v5
[3] https://github.com/atishp04/linux/tree/sstc_v6

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
arch/riscv/kvm/vcpu.c                   |   8 +-
arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
drivers/clocksource/timer-riscv.c       |  24 +++-
9 files changed, 184 insertions(+), 8 deletions(-)

--
2.25.1

