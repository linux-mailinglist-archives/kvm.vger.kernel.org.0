Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3451D592006
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 16:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiHNOM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 10:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiHNOMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 10:12:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3929F9FCA
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bv3so6357476wrb.5
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=K+4ztMrZDye6S2odnUAg2YD+Sis7k4asg4StIp4L2N8=;
        b=DfdO3yRHemNBlA7Z4K40epXT6a5mzLgotaT+wjrQ0CCVq94MwNT7SVXLAtyZUDygnw
         2lQfcVKnpICBUjlEpWDOPzfaZFnEqrkxVNsNybuTrzGd3fjZDmCT+ReRqE+Auj4sGY8K
         uRcRa9FbjDb05ahlJI00s/Hk3/l5lZaGjPgWTME/bO5b750e+9+lPtrOES7c0i8tIc8C
         8hdkA+jZ3XgV6n68tO+rItWKC9tkWGCXtj9yeDj/SfbPE7NEb7jemnuz+/jhcmNW7ShI
         3RdqO1rZca3tYU2ZJk3Fivp43ZyuSk4V+oEveW5vwEiKUcew/VQlHqnG/kHLjQlvWFvt
         70Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=K+4ztMrZDye6S2odnUAg2YD+Sis7k4asg4StIp4L2N8=;
        b=de0nclvHvhrgkvNmCyqp3nrcCzO+eO41pvBjtoO2OESQTb5MnFdfKBatV2Rwt/GBHa
         bRgcdicfiZSUgo8wDYroDc7EmuncKDkrTvIwgDH4Q10nIG3Wx8k2F+6QwBf+NJFpTPDS
         H3dqn57UVyHVWL40qsapa7b4sqsgaELO7wcnyjycap+I+QNJfr29FAE+G4ea5DX/vcLr
         tHdQr0Z/ghBccocBEIC8H+r2Hkr7YTeXTGDtsYHFJ2M/ojpVIFnhl6zzGmF0IYkKyN5S
         Fj9Y/N/Br4wB99fITNwk1efs6yuGCW35ENe4MQKTdc88L6EmAlZ2kWJUgvqiNjcfPKoi
         dl0g==
X-Gm-Message-State: ACgBeo0DTx+yBANQ7WNlSudHt55XC20zJhSU4oaTb9RqHdWS0yCb913F
        2P3eRIun479BD4yNQJHlQhMa7g==
X-Google-Smtp-Source: AA6agR5PV8qeRAKHvRTEReWxvq3UtoJToFqH0Q4Bl/uP3TlBuYJBu4g3GQwfQjHfdPU5zsQhWphrPw==
X-Received: by 2002:adf:fc88:0:b0:220:61dc:d297 with SMTP id g8-20020adffc88000000b0022061dcd297mr6138300wrr.660.1660486370580;
        Sun, 14 Aug 2022 07:12:50 -0700 (PDT)
Received: from henark71.. ([109.76.58.63])
        by smtp.gmail.com with ESMTPSA id b8-20020adfde08000000b0021db7b0162esm4625419wrm.105.2022.08.14.07.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 07:12:50 -0700 (PDT)
From:   Conor Dooley <mail@conchuod.ie>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] misc warning cleanup in arch/risc-v
Date:   Sun, 14 Aug 2022 15:12:34 +0100
Message-Id: <20220814141237.493457-1-mail@conchuod.ie>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Hey all,
Couple fixes here for most of what's left of the {sparse,} warnings in
arch/riscv that are still in need of patches. Ben has sent patches
for the VDSO issue already (although they seem to need rework).

VDSO aside, With this patchset applied, we are left with:
- cpuinfo_ops missing prototype: this likely needs to go into an
  asm-generic header & I'll send a separate patch for that.
- Complaints about an error in mm/init.c:
  "error inarch/riscv/mm/init.c:819:2: error: "setup_vm() is <trunc>
  I think this can be ignored.
- 600+ -Woverride-init warnings for syscall table setup where
  overriding seems to be the whole point of the macro.
- Warnings about imported kvm core code.
- Flexible array member warnings that look like common KVM code
  patterns
- An unexpected unlock in kvm_riscv_check_vcpu_requests that was added
  intentionally:
  https://lore.kernel.org/all/20220710151105.687193-1-apatel@ventanamicro.com/
  Is it worth looking into whether that's a false positive or not?

Thanks,
Conor.

Conor Dooley (4):
  riscv: kvm: vcpu_timer: fix unused variable warnings
  riscv: kvm: move extern sbi_ext declarations to a header
  riscv: signal: fix missing prototype warning
  riscv: traps: add missing prototype

 arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
 arch/riscv/include/asm/signal.h       | 12 ++++++++++++
 arch/riscv/include/asm/thread_info.h  |  2 ++
 arch/riscv/kernel/signal.c            |  1 +
 arch/riscv/kernel/traps.c             |  3 ++-
 arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
 arch/riscv/kvm/vcpu_timer.c           |  4 ----
 7 files changed, 30 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/signal.h

-- 
2.37.1

