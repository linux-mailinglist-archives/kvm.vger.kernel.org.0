Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C585964F38B
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 22:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLPVz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 16:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLPVz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 16:55:26 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFE65F402
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m18so9238867eji.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 13:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hDjaN8eJVHHHAcFnMzr9A5qx6nMta47BhVSDkoRkjiY=;
        b=koVIL3cKjIUh0I9iexsK0DqWfQr49gTESlxiAo8T9vnX2CJ4QixeCzMydRIRBOKWbx
         +R5klEOuw0jjsMOseiyYra2DmM7xugL01wBlJceq+pr1ETQMYuEF+l2nrxerxSyoOukk
         EE8047bs8JQBm+dUp3FUQQC1qnfqTHK47keip65hJwdx3mwendQAsAQLaIBR2pRzqlvf
         NqOH4fAeX01aJpH0nqGWNSKzukViznSJY7eNEFluBWjQzNLupunEjytyMWUMkkzTPBA2
         KPTKjr9ShUXrdrTne0thHjnLliuX8/iEm2579930rtW//wgEDKCU8+iqi5HVgULV6x0O
         iFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDjaN8eJVHHHAcFnMzr9A5qx6nMta47BhVSDkoRkjiY=;
        b=yVZVtHnMbjdtueNr8HSn8HoMhCg1SCSHTJh2QvMZYxAJFGU6FmzGejmxqpXF0q68iV
         9cweVC07wa+2pDgDCapYnoGrNDhha5b54W+IwZbRSYUXlY09gGJn0Cm2qHOpxKPMJgKP
         6/cai5rKPNiKUfmPRYCrRsCpiArgypRoowlp4s4oKRuDMeJhpSrSVlOnnQrqWrn3TjoV
         NFFGS54hepJ088k60o3S9JB2M6SLZEHOz1rQV11eZ+UPq/0cg/HQ6Q0TCam1nM8zBV98
         zwsYUf9l8EoBjWqKBvVhK5VJN5VzofYWQdYL2WPjmFA/5r6nii6bXVIiw19XoHlnIGkb
         Lqgg==
X-Gm-Message-State: ANoB5pkqnk6m3EY9vYtlCSq4z/3xGQ6oke5uZoPeeh5T9nprIc/JUvIg
        avVzX3Zw5VYeppVEAYf0lMNKrw==
X-Google-Smtp-Source: AA0mqf44m9uRz2q1p7VXh76chobt7pep0KjNv3fyOdRMxmPyqai4zHyqi15eXjf/Z+1BI3Gb+0JNtQ==
X-Received: by 2002:a17:906:8385:b0:7c4:f348:3b1f with SMTP id p5-20020a170906838500b007c4f3483b1fmr10710690ejx.44.1671227722936;
        Fri, 16 Dec 2022 13:55:22 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id f22-20020a17090631d600b007aece68483csm1261840ejf.193.2022.12.16.13.55.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 13:55:22 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marek Vasut <marex@denx.de>, Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-riscv@nongnu.org, kvm@vger.kernel.org,
        Stafford Horne <shorne@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Chris Wulff <crwulff@gmail.com>
Subject: [PATCH v3 0/5] target/cpu: System/User cleanups around hwaddr/vaddr
Date:   Fri, 16 Dec 2022 22:55:14 +0100
Message-Id: <20221216215519.5522-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
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

Missing review: #1

We are not supposed to use the 'hwaddr' type on user emulation.

This series is a preparatory cleanup before few refactors to
isolate further System vs User code.

Since v1:
- only restrict SavedIOTLB in header (Alex)
- convert insert/remove_breakpoint implementations (Peter)

Since v2:
- added 'dump' patch
- collected R-b tags

Philippe Mathieu-Daudé (5):
  dump: Include missing "cpu.h" header for tswap32/tswap64()
    declarations
  cputlb: Restrict SavedIOTLB to system emulation
  gdbstub: Use vaddr type for generic insert/remove_breakpoint() API
  target/cpu: Restrict cpu_get_phys_page_debug() handlers to sysemu
  target/cpu: Restrict do_transaction_failed() handlers to sysemu

 accel/kvm/kvm-all.c        |  4 ++--
 accel/kvm/kvm-cpus.h       |  4 ++--
 accel/tcg/tcg-accel-ops.c  |  4 ++--
 dump/dump.c                |  1 +
 gdbstub/gdbstub.c          |  1 -
 gdbstub/internals.h        |  6 ++++--
 gdbstub/softmmu.c          |  5 ++---
 gdbstub/user.c             |  5 ++---
 include/hw/core/cpu.h      |  6 ++++--
 include/sysemu/accel-ops.h |  6 +++---
 target/alpha/cpu.h         |  2 +-
 target/arm/cpu.h           |  2 +-
 target/arm/internals.h     |  2 ++
 target/cris/cpu.h          |  3 +--
 target/hppa/cpu.h          |  2 +-
 target/i386/cpu.h          |  5 ++---
 target/m68k/cpu.h          |  4 +++-
 target/microblaze/cpu.h    |  4 ++--
 target/nios2/cpu.h         |  2 +-
 target/openrisc/cpu.h      |  3 ++-
 target/ppc/cpu.h           |  2 +-
 target/riscv/cpu.h         | 12 ++++++------
 target/rx/cpu.h            |  2 +-
 target/rx/helper.c         |  4 ++--
 target/sh4/cpu.h           |  2 +-
 target/sparc/cpu.h         |  3 ++-
 target/xtensa/cpu.h        |  2 +-
 27 files changed, 52 insertions(+), 46 deletions(-)

-- 
2.38.1

