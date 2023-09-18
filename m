Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0117A4F4C
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjIRQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjIRQiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:38:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A144B3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:09:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-52fe27898e9so5461757a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053360; x=1695658160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R37K2a/Smepsc2iyIaDJqnazCMcEJOOAaYAXmsK0XT0=;
        b=XGsyrNMUYh74ccQisEZGdYH00pr+SirbulPY0LWeYMNQjNKE2D7xVsAyb1j9vFyDOO
         YuLu/kMoQ1xtY44qynndyEemka3DrYP1xvPhs9JvGTEBA1kgQPy78LuqQP8AOkAwgHPX
         Je4Vj9TpVmuU8a3sYwYp0uL7v81PW9hXQ1lPUw3GyUy3vuDMz1FTtIsXHW4raNLoRqIz
         VruPaXimOOCenxjcixu1z4tXjuRuyETfz8h2ZqFhopzhFRKHzZY5AlaiA+sLf5KJRB8o
         QuI8ZephY3tlsJa2F7AGrMHXo78GwWIUZj/Gni1NyJfpOw8YZdHgVNW1dqEy6UK/iogg
         otsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053360; x=1695658160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R37K2a/Smepsc2iyIaDJqnazCMcEJOOAaYAXmsK0XT0=;
        b=YwlDWubUJCYO+O7QPhIhSdDjiusHhEpZWcuDa1C9qKXgH3QoxPdZ0GSNvuW9KPDskn
         ngUOG38omvN7cGces/OeOKbx1rdziG33vlEVDRTNU0JyPL+Ld8vmPgyZO5sG0sPu6Vhl
         Gk6eveepgnB8idHWgtjRijHFumCPyoFcRNgFDgd4twEeZfKbkkZFgjNbuRASXx2vDMYH
         uQMWBZu6Lzy4hfsnF2zMZujL4uFPyMH4lYmro9Wnv49cNbvhYZndm+GqZDTzTMgk6JBR
         9CDZCaXswCuSxuvp+9P0iF04BgYJik+HiYhmI0CCZAzxvd+i3QexccybqA/TFvnLPXXd
         Q0yw==
X-Gm-Message-State: AOJu0YxymPjUK7FnWfn8IOGPkrgrcXxZMjLt9NGzY6uMinTdTACinh5U
        zz0/9yvPGRCWc88GLu+RMclpGyhOloo9ZNSzOLheR7Wt
X-Google-Smtp-Source: AGHT+IHGtyYBQwLAMwFhSgR4DVjVUaGUpdsvPj2BatAS0H6me1yGIyefW0SsMEvxluQ7CDP796y45Q==
X-Received: by 2002:a17:907:a0c6:b0:9a1:cb2c:b55c with SMTP id hw6-20020a170907a0c600b009a1cb2cb55cmr6526293ejc.35.1695052978973;
        Mon, 18 Sep 2023 09:02:58 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id rl20-20020a1709076c1400b009adc81c0c7esm5428731ejc.107.2023.09.18.09.02.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:02:58 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 00/22] exec/cpu: Call cpu_exec_realizefn() once in cpu_common_realize()
Date:   Mon, 18 Sep 2023 18:02:33 +0200
Message-ID: <20230918160257.30127-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

TL;DR: This series factor duplicated common code in CPUs
DeviceRealize() handlers out, moving as a single call in
cpu_common_realize().

In an effort to have most of:
- CPU core code independant of accelerators
- CPU core code target agnostic
- CPU target code independant of accelerators
- and cpu_reset() called automatically without having to
  rely on global QEMUResetHandler,
I'm working on the core CPU code, unfortunately touching
files in all targets.

I suppose them term "exec" used in various areas of QEMU
started from what we call today "accel[erators]" [*]. So
cpu_exec_realizefn() can be read as cpu_accel_realize(),
or "generic code where an accelerator realizes its internal
fields on an abstract (target independent) CPU".

This series moves a common pattern used in all target's
cpu_realize() handlers to the common cpu_exec_realizefn().

Some optional code is used to check CPU requested features
are compatible with the accelerator possibilities. We
extracted this code as CPUClass::verify_accel_features()
handler. Better name welcomed :)

Some targets were calling cpu_reset() *before*
cpu_common_realizefn(), we moved it *after* (since RESET
shouldn't happen before REALIZE). I still have to audit
each target to confirm there are no side effects.
Besides this cpu_reset() change, the rest should be
relatively trivial to review, still I'd like feedback
from the respective target maintainers for the "move HW
creation after vCPU one" patches.

Regards,

Phil.

Follow-up: Make cpu_reset() accel-agnostic and move it
           to cpu_common_realize() (not trivial due to
           KVM run_on_cpu() calls).

[*] If Paolo/Richard confirm, I might post series renaming
    various APIs s/exec/accel/, because various headers
    meaning aren't clear to me.

Philippe Mathieu-Daudé (21):
  target/i386: Only realize existing APIC device
  hw/intc/apic: Pass CPU using QOM link property
  target/i386/kvm: Correct comment in kvm_cpu_realize()
  exec/cpu: Never call cpu_reset() before cpu_realize()
  exec/cpu: Call qemu_init_vcpu() once in cpu_common_realize()
  exec/cpu: Call cpu_remove_sync() once in cpu_common_unrealize()
  exec/cpu: RFC Destroy vCPU address spaces in cpu_common_unrealize()
  target/arm: Create timers *after* accelerator vCPU is realized
  target/hppa: Create timer *after* accelerator vCPU is realized
  target/nios2: Create IRQs *after* accelerator vCPU is realized
  target/mips: Create clock *after* accelerator vCPU is realized
  target/xtensa: Create IRQs *after* accelerator vCPU is realized
  target/sparc: Init CPU environment *after* accelerator vCPU is
    realized
  exec/cpu: Introduce CPUClass::verify_accel_features()
  target/arm: Extract verify_accel_features() from cpu_realize()
  target/i386: Extract verify_accel_features() from cpu_realize()
  target/s390x: Call s390_cpu_realize_sysemu from s390_realize_cpu_model
  target/s390x: Have s390_realize_cpu_model() return a boolean
  target/s390x: Use s390_realize_cpu_model() as verify_accel_features()
  exec/cpu: Have cpu_exec_realize() return a boolean
  exec/cpu: Call cpu_exec_realizefn() once in cpu_common_realize()

xianglai li (1):
  exec/cpu: Introduce the CPU address space destruction function

 include/exec/cpu-common.h     |  8 ++++
 include/hw/core/cpu.h         |  7 +++-
 target/s390x/s390x-internal.h |  4 +-
 cpu.c                         | 11 ++++-
 hw/core/cpu-common.c          | 15 +++++++
 hw/intc/apic_common.c         |  2 +
 softmmu/physmem.c             | 24 +++++++++++
 target/alpha/cpu.c            | 10 -----
 target/arm/cpu.c              | 53 ++++++++++++------------
 target/avr/cpu.c              | 10 +----
 target/cris/cpu.c             | 11 +----
 target/hexagon/cpu.c          | 11 +----
 target/hppa/cpu.c             | 20 ++-------
 target/i386/cpu-sysemu.c      | 20 ++++-----
 target/i386/cpu.c             | 77 ++++++++++++++++++-----------------
 target/i386/kvm/kvm-cpu.c     |  3 +-
 target/loongarch/cpu.c        | 11 +----
 target/m68k/cpu.c             | 11 +----
 target/microblaze/cpu.c       |  9 ----
 target/mips/cpu.c             | 27 ++++--------
 target/nios2/cpu.c            | 20 +++------
 target/openrisc/cpu.c         | 11 +----
 target/ppc/cpu_init.c         |  8 ----
 target/riscv/cpu.c            | 10 +----
 target/rx/cpu.c               | 11 +----
 target/s390x/cpu-sysemu.c     |  3 +-
 target/s390x/cpu.c            | 21 +---------
 target/s390x/cpu_models.c     | 16 +++++---
 target/sh4/cpu.c              | 11 +----
 target/sparc/cpu.c            | 10 -----
 target/tricore/cpu.c          | 10 +----
 target/xtensa/cpu.c           | 13 +-----
 32 files changed, 189 insertions(+), 299 deletions(-)

-- 
2.41.0

