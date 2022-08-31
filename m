Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E425A850B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiHaSJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiHaSIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:08:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C45E68C2;
        Wed, 31 Aug 2022 11:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E5DB82221;
        Wed, 31 Aug 2022 18:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B7C433D6;
        Wed, 31 Aug 2022 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969315;
        bh=+JjElnI5IjOCD0ml2rzIPbAQ+2yKUfZWwuoUc78T+4U=;
        h=From:To:Cc:Subject:Date:From;
        b=Hfa+oD1uUUs2d9r0k5XrVD0NjeEB8EEqrGsuhqiXSJsWdk9oPHgxQs3PlHlA41btc
         YvHMiJk0ha3z2itd9l1pGNll45OnmpJ1quUsu/rkWQjEAxVWMo+hryCMaoCLta3G4M
         6QoryKkOTwmn5HwJsdlR41K7nTGvKXD9vMP1BlE7CNNO501Wty7/OOzrCgkfrkQNmx
         s7FJW8wv1Td+Cv+EmWBMyIqUGHB9FYkYPtC4x5dR8QVZE5TPWp90d1Hvc6/eO1p+8k
         U6SxWyOER38RdBgD/fPQgjs9gryoD4H5T/eE4DBULcvCUNfHC/u/Xa/I3Z7OGZP0TV
         2tuLz7Q57y5Jw==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Date:   Thu,  1 Sep 2022 01:59:15 +0800
Message-Id: <20220831175920.2806-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is to add PREEMPT_RT support to riscv:
patch1 adds the missing number of signal exits in vCPU stat
patch2 switches to the generic guest entry infrastructure
patch3 select HAVE_POSIX_CPU_TIMERS_TASK_WORK which is a requirement for
RT
patch4 adds lazy preempt support
patch5 allows to enable PREEMPT_RT

I assume patch1, patch2 and patch3 can be reviewed and merged for
riscv-next, patch4 and patch5 can be reviewed and maintained in rt tree,
and finally merged once the remaining patches in rt tree are all
mainlined.

Since v1:
  - send to related maillist, I press ENTER too quickly when sending v1
  - remove the signal_pending() handling because that's covered by
    generic guest entry infrastructure

Jisheng Zhang (5):
  RISC-V: KVM: Record number of signal exits as a vCPU stat
  RISC-V: KVM: Use generic guest entry infrastructure
  riscv: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
  riscv: add lazy preempt support
  riscv: Allow to enable RT

 arch/riscv/Kconfig                   |  3 +++
 arch/riscv/include/asm/kvm_host.h    |  1 +
 arch/riscv/include/asm/thread_info.h |  7 +++++--
 arch/riscv/kernel/asm-offsets.c      |  1 +
 arch/riscv/kernel/entry.S            |  9 +++++++--
 arch/riscv/kvm/Kconfig               |  1 +
 arch/riscv/kvm/vcpu.c                | 18 +++++++-----------
 7 files changed, 25 insertions(+), 15 deletions(-)

-- 
2.34.1

