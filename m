Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8005C64733C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLHPgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 10:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiLHPgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 10:36:18 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1D266C84
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 07:35:33 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay40so1338527wmb.2
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 07:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+RM4UwijIpBPUIIRN2AowsmzXNijKTCSn3H3N3D+GCg=;
        b=sVtUEeiouVnCevIsTQ1U1d70vH9x97w5UheXwB1Vxxb8uNF6TyomteXx+Lc+35n0q8
         k+nASupApS+i1paBd8HCmvbZAppuVs3JbYfgbaktVhCF8Qq31G08SHgu46stisNWK5LI
         zJcVcsBMx4vWgCFt2xM6z7MjdaLYfEZG9Q82nQCzGhHz0cUzx40n1omVKxqUmUqfJ+uW
         FRjTp9aLzs8udl3dc8HrtcGG93DIu8ejLBu+laQtS6QEzEY29+lD+NS/M2mYkuS/ZsEr
         aJw6KTF486KexxawK6eoFDfe8wWIXxwOXpYBuiOLUsGX9cGPclQMhKZItyQD/5zo+XkF
         z0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+RM4UwijIpBPUIIRN2AowsmzXNijKTCSn3H3N3D+GCg=;
        b=hpGtSpKjJmq+ODjShGZedxqB+g7PXGSonHVamvGLN9yWk/oe6BxNddqefBhtxGHzWp
         dEcTTIlFuTwCxxAGYvlO4//3KEaVqctyGxxnb/j49nX+t/lEW+BCMH1zD2y2pnvXPNiF
         WacGiESbsCvmXRmD8VHQQlPZt2hPwrOD0ehfqj8KlwhfcJNyjKLcNEwaFWFAKP7NAOh/
         A+a+kEpB3Ni4oA152qZZySRkVTQRdanJ7/nfROZjMA8SwA8g2WoJJRypX7c2BJA5G5m6
         dCXgUyMWpU9WOMjlWIGJT4bH9/aFGT1UK9IkQqDj9XzniFfkY7U5vcrx62fGUiwXto2k
         X8zw==
X-Gm-Message-State: ANoB5pmMLEexlmTSJGKrJ8E3K45Y49RrerhrQKfeEoXRzD1RTRAON4Ty
        +NjQ/kg7rJEPOk4U/olET+kWaA==
X-Google-Smtp-Source: AA0mqf49aJ/+SKfZbINuKtt6dxJE/LrEL9Yzvc4uqOLweecB0LwA26N7v4IJRugoVSQ/98bgO+RUXQ==
X-Received: by 2002:a05:600c:3ac5:b0:3d0:761b:f86 with SMTP id d5-20020a05600c3ac500b003d0761b0f86mr2210330wms.28.1670513731944;
        Thu, 08 Dec 2022 07:35:31 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id ay5-20020a05600c1e0500b003c21ba7d7d6sm5412191wmb.44.2022.12.08.07.35.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Dec 2022 07:35:31 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stafford Horne <shorne@gmail.com>,
        Anton Johansson <anjo@rev.ng>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        Chris Wulff <crwulff@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marek Vasut <marex@denx.de>, Max Filippov <jcmvbkbc@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Laurent Vivier <laurent@vivier.eu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
Subject: [PATCH-for-8.0 v2 0/4] target/cpu: System/User cleanups around hwaddr/vaddr
Date:   Thu,  8 Dec 2022 16:35:24 +0100
Message-Id: <20221208153528.27238-1-philmd@linaro.org>
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

We are not supposed to use the 'hwaddr' type on user emulation.

This series is a preparatory cleanup before few refactors to
isolate further System vs User code.

Since v1:
- only restrict SavedIOTLB in header (Alex)
- convert insert/remove_breakpoint implementations (Peter)

Philippe Mathieu-Daudé (4):
  cputlb: Restrict SavedIOTLB to system emulation
  gdbstub: Use vaddr type for generic insert/remove_breakpoint() API
  target/cpu: Restrict cpu_get_phys_page_debug() handlers to sysemu
  target/sparc/sysemu: Remove pointless CONFIG_USER_ONLY guard

 accel/kvm/kvm-all.c        | 4 ++--
 accel/kvm/kvm-cpus.h       | 4 ++--
 accel/tcg/tcg-accel-ops.c  | 4 ++--
 gdbstub/gdbstub.c          | 1 -
 gdbstub/internals.h        | 6 ++++--
 gdbstub/softmmu.c          | 5 ++---
 gdbstub/user.c             | 5 ++---
 include/hw/core/cpu.h      | 6 ++++--
 include/sysemu/accel-ops.h | 6 +++---
 target/alpha/cpu.h         | 2 +-
 target/cris/cpu.h          | 3 +--
 target/hppa/cpu.h          | 2 +-
 target/m68k/cpu.h          | 2 +-
 target/nios2/cpu.h         | 2 +-
 target/openrisc/cpu.h      | 3 ++-
 target/ppc/cpu.h           | 2 +-
 target/rx/cpu.h            | 2 +-
 target/rx/helper.c         | 4 ++--
 target/sh4/cpu.h           | 2 +-
 target/sparc/cpu.h         | 3 ++-
 target/sparc/mmu_helper.c  | 2 --
 target/xtensa/cpu.h        | 2 +-
 22 files changed, 36 insertions(+), 36 deletions(-)

-- 
2.38.1

