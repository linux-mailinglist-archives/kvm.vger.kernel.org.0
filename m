Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCC25E9462
	for <lists+kvm@lfdr.de>; Sun, 25 Sep 2022 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiIYQdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 12:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiIYQda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 12:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD0329C82;
        Sun, 25 Sep 2022 09:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C847C60FCC;
        Sun, 25 Sep 2022 16:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38668C433C1;
        Sun, 25 Sep 2022 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664123608;
        bh=Jc7NPPQi/AxLruVk6vIStJKeePhKZzkV23avx60HytI=;
        h=From:To:Cc:Subject:Date:From;
        b=MO/OH7thtlmoZzoXvFWnzueTijLa4tB4Dl1sB9aLNM65BHkOzNXon7zmEX2wxs0DK
         Vbojfu9mOpMD5yTgyf5ecrYkNHsE/7GFWIwVmwbWZSiTB1sUqgwuRqpvGy43632pt1
         mdSvwC6GH6iQGqGPLQXoemUmHLbZs7Ytaz7Mqd6gjT+QOVjN/zDzjawBnwg61a/I2N
         TXtz07CaMlPrj1PjrAjevHhtDClAaIP8TIhvg+qbx2xCE9E+R2E5HOUijxTGaaIm8c
         yMzdgJeCHJmhOAaBNMupCTsXcPLCCMvTVjzBWlfM1G5ToMUPeGLnWQF84ZBB7PUqVp
         3U6YKRgoQtb/w==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v3 0/3] riscv: kvm: use generic entry for TIF_NOTIFY_RESUME and misc
Date:   Mon, 26 Sep 2022 00:23:57 +0800
Message-Id: <20220925162400.1606-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a preparation series to add PREEMPT_RT support to riscv:
patch1 adds the missing number of signal exits in vCPU stat
patch2 switches to the generic guest entry infrastructure
patch3 select HAVE_POSIX_CPU_TIMERS_TASK_WORK which is a requirement for
RT

After these three patches merged, the left RT patches are similar as
other arch.

Since v2:
  - splict the series into two separate ones, one for next another for
    RT.

Since v1:
  - send to related maillist, I press ENTER too quickly when sending v1
  - remove the signal_pending() handling because that's covered by
    generic guest entry infrastructure

Jisheng Zhang (3):
  RISC-V: KVM: Record number of signal exits as a vCPU stat
  RISC-V: KVM: Use generic guest entry infrastructure
  riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK

 arch/riscv/Kconfig                |  1 +
 arch/riscv/include/asm/kvm_host.h |  1 +
 arch/riscv/kvm/Kconfig            |  1 +
 arch/riscv/kvm/vcpu.c             | 18 +++++++-----------
 4 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.34.1

