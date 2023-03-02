Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29FF6A891E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCBTJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCBTJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:09:09 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C19119683
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:08:49 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l1so102818wry.12
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kPp/zsqm6mdPFLwh5srr7CQkmjUrttysHZTn7bFGWpY=;
        b=B4c014FNbB/hoC/PNtD/BsvPW66lpvE1aC++xgER9MIoaj+eu9kbnu8mLABTy+3Yz1
         zJ0Vy0CEWsJCzrPA8X7/rZ1M+0eGFGdJ6zB8tJtP4kGg5BeQJxNcSA1vlYbL/tB1fLjY
         /45i432dlaJmfD1DEOG1LgFdMfFG8i6l8CEhJuQ/LA4+FIFF6fgEZFFhT0abWDl0JXAi
         S/luV4w/2tdYu/Xt9gmhe8SPohHLGamIdcJN66Pn3/rxtns8s73VT9alXZvoZBPe6YpH
         LxfAdmBa19oZLAMsYFu/zW5nW2cCF6827xbDc1iTkwFryqwUWj0fpfSyJrX/cRHbwmo3
         o6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPp/zsqm6mdPFLwh5srr7CQkmjUrttysHZTn7bFGWpY=;
        b=FEiE66tBYK6JxwdjhsyucJrZOBoMINAVzRZaDgPHum2vjFyxySgqNsrSAjtGkBM2S+
         amxxjSL3MLZvjmxlt1nsSBjGul4tGShQAtDDMCV8OBFemgXJDradB+RK2bNRIW5mqMZ9
         gszaMwXCX756D5O5LouzkA5so675f7wMGIPcxwLXqVhBQKRibUX+9PNwCqjqPgZfPQE6
         tr+c1resG9IK0JvFvqMh/n5nIwJxJYv54SHKW9/LLULi35Tg+VclNQozyMmZUcXN9ZYb
         orODuitLLcgB4Ho59Xxl3vujdYrlU2grVls34mLBcSM6O7HE2gj0wKPnIcfSoIt92+nK
         w4Jg==
X-Gm-Message-State: AO0yUKW9xcQQ5RxscdQB1C4xCuIT7FKrE4iy5WFp5EdkrWH/H6WPH5u8
        QXrr7RcuSr/gfYMhQjDOf8pkFg==
X-Google-Smtp-Source: AK7set90A4peKHOfeMuDzh3k8oevAVkOV3qefEklUxb2APqbzv7vxT2HRM6yiKGIOngNFQp00MHmeA==
X-Received: by 2002:adf:dc47:0:b0:2ca:9950:718 with SMTP id m7-20020adfdc47000000b002ca99500718mr8166180wrj.52.1677784127465;
        Thu, 02 Mar 2023 11:08:47 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id z6-20020adfd0c6000000b002c55efa9cbesm154762wrh.39.2023.03.02.11.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:08:47 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 93EAA1FFB7;
        Thu,  2 Mar 2023 19:08:46 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 00/26] gdbstub/next: re-organise and split build
Date:   Thu,  2 Mar 2023 19:08:20 +0000
Message-Id: <20230302190846.2593720-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was motivated to sort this out while working on my register API
which is target agnostic but ran into the weeds when trying to link up
with the gdbstub. This was due to us building gdbstub for every single
target we support due to a few ABI sensitive bits that require CPU
specific information. This series does a bunch of surgery to break the
monolithic file apart into its constituent parts as well as simplify
the headers to users can avoid bringing in more dependencies than they
need.

I had hoped to go all the way and conditionally compile syscalls only
for the two ABIs (32 and 64 bit) unfortunately I was unable to the
appropriate meson-foo to make that happen.

This version is mostly just minor clean-ups and tag updates including
a few extra code motion and checkpatch cleanup patches. The biggest
change is replacing the probe shell script with a slightly smarter
python one and adding Mad's accelops patch.

The following patches need review:

 - gdbstub: split out softmmu/user specifics for syscall handling
 - testing: probe gdb for supported architectures ahead of time
 - gdbstub: only compile gdbstub twice for whole build
 - gdbstub: clean-up indent on gdb_exit

Alex Bennée (24):
  gdbstub/internals.h: clean up include guard
  gdbstub: fix-up copyright and license files
  gdbstub: clean-up indent on gdb_exit
  gdbstub: define separate user/system structures
  gdbstub: move GDBState to shared internals header
  includes: move tb_flush into its own header
  gdbstub: move fromhex/tohex routines to internals
  gdbstub: make various helpers visible to the rest of the module
  gdbstub: move chunk of softmmu functionality to own file
  gdbstub: move chunks of user code into own files
  gdbstub: rationalise signal mapping in softmmu
  gdbstub: abstract target specific details from gdb_put_packet_binary
  gdbstub: specialise handle_query_attached
  gdbstub: specialise target_memory_rw_debug
  gdbstub: introduce gdb_get_max_cpus
  gdbstub: specialise stub_can_reverse
  gdbstub: fix address type of gdb_set_cpu_pc
  gdbstub: don't use target_ulong while handling registers
  gdbstub: move register helpers into standalone include
  gdbstub: move syscall handling to new file
  gdbstub: only compile gdbstub twice for whole build
  testing: probe gdb for supported architectures ahead of time
  include: split target_long definition from cpu-defs
  gdbstub: split out softmmu/user specifics for syscall handling

Mads Ynddal (1):
  gdbstub: move update guest debug to accel ops

Philippe Mathieu-Daudé (1):
  gdbstub: Make syscall_complete/[gs]et_reg target-agnostic typedefs

 MAINTAINERS                                   |    4 +
 configure                                     |    8 +
 gdbstub/internals.h                           |  214 ++-
 include/exec/cpu-defs.h                       |   19 +-
 include/exec/exec-all.h                       |    1 -
 include/exec/gdbstub.h                        |  208 ---
 include/exec/target_long.h                    |   42 +
 include/exec/tb-flush.h                       |   26 +
 include/gdbstub/helpers.h                     |  103 +
 include/gdbstub/syscalls.h                    |  124 ++
 include/gdbstub/user.h                        |   43 +
 include/sysemu/accel-ops.h                    |    1 +
 linux-user/user-internals.h                   |    1 +
 accel/kvm/kvm-accel-ops.c                     |    8 +
 accel/stubs/tcg-stub.c                        |    1 +
 accel/tcg/tb-maint.c                          |    1 +
 accel/tcg/translate-all.c                     |    1 +
 cpu.c                                         |   12 +-
 gdbstub/gdbstub.c                             | 1655 ++---------------
 gdbstub/softmmu.c                             |  613 +++++-
 gdbstub/syscalls.c                            |  221 +++
 gdbstub/user-target.c                         |  283 +++
 gdbstub/user.c                                |  433 ++++-
 hw/ppc/spapr_hcall.c                          |    1 +
 linux-user/exit.c                             |    2 +-
 linux-user/main.c                             |    1 +
 linux-user/signal.c                           |    2 +-
 plugins/core.c                                |    1 +
 plugins/loader.c                              |    2 +-
 semihosting/arm-compat-semi.c                 |    1 +
 semihosting/guestfd.c                         |    2 +-
 semihosting/syscalls.c                        |    3 +-
 softmmu/runstate.c                            |    2 +-
 target/alpha/gdbstub.c                        |    2 +-
 target/alpha/sys_helper.c                     |    1 +
 target/arm/gdbstub.c                          |    1 +
 target/arm/gdbstub64.c                        |    2 +-
 target/arm/tcg/helper-a64.c                   |    2 +-
 target/arm/tcg/m_helper.c                     |    1 +
 target/avr/gdbstub.c                          |    2 +-
 target/cris/gdbstub.c                         |    2 +-
 target/hexagon/gdbstub.c                      |    2 +-
 target/hppa/gdbstub.c                         |    2 +-
 target/i386/gdbstub.c                         |    2 +-
 target/i386/whpx/whpx-all.c                   |    2 +-
 target/loongarch/gdbstub.c                    |    1 +
 target/m68k/gdbstub.c                         |    2 +-
 target/m68k/helper.c                          |    1 +
 target/m68k/m68k-semi.c                       |    3 +-
 target/microblaze/gdbstub.c                   |    2 +-
 target/mips/gdbstub.c                         |    2 +-
 target/mips/tcg/sysemu/mips-semi.c            |    3 +-
 target/nios2/cpu.c                            |    2 +-
 target/nios2/nios2-semi.c                     |    3 +-
 target/openrisc/gdbstub.c                     |    2 +-
 target/openrisc/interrupt.c                   |    2 +-
 target/openrisc/mmu.c                         |    2 +-
 target/ppc/cpu_init.c                         |    2 +-
 target/ppc/gdbstub.c                          |    1 +
 target/riscv/csr.c                            |    1 +
 target/riscv/gdbstub.c                        |    1 +
 target/rx/gdbstub.c                           |    2 +-
 target/s390x/gdbstub.c                        |    1 +
 target/s390x/helper.c                         |    2 +-
 target/sh4/gdbstub.c                          |    2 +-
 target/sparc/gdbstub.c                        |    2 +-
 target/tricore/gdbstub.c                      |    2 +-
 target/xtensa/core-dc232b.c                   |    2 +-
 target/xtensa/core-dc233c.c                   |    2 +-
 target/xtensa/core-de212.c                    |    2 +-
 target/xtensa/core-de233_fpu.c                |    2 +-
 target/xtensa/core-dsp3400.c                  |    2 +-
 target/xtensa/core-fsf.c                      |    2 +-
 target/xtensa/core-lx106.c                    |    2 +-
 target/xtensa/core-sample_controller.c        |    2 +-
 target/xtensa/core-test_kc705_be.c            |    2 +-
 target/xtensa/core-test_mmuhifi_c3.c          |    2 +-
 target/xtensa/gdbstub.c                       |    2 +-
 target/xtensa/helper.c                        |    2 +-
 gdbstub/meson.build                           |   35 +-
 gdbstub/trace-events                          |    4 +-
 scripts/probe-gdb-support.py                  |   88 +
 target/xtensa/import_core.sh                  |    2 +-
 tests/tcg/aarch64/Makefile.target             |    2 +-
 tests/tcg/multiarch/Makefile.target           |    5 +
 .../multiarch/system/Makefile.softmmu-target  |    6 +-
 tests/tcg/s390x/Makefile.target               |    2 +-
 87 files changed, 2470 insertions(+), 1799 deletions(-)
 create mode 100644 include/exec/target_long.h
 create mode 100644 include/exec/tb-flush.h
 create mode 100644 include/gdbstub/helpers.h
 create mode 100644 include/gdbstub/syscalls.h
 create mode 100644 include/gdbstub/user.h
 create mode 100644 gdbstub/syscalls.c
 create mode 100644 gdbstub/user-target.c
 create mode 100755 scripts/probe-gdb-support.py

-- 
2.39.2

