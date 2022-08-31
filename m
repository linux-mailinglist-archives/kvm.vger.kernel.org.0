Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612795A850D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiHaSJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiHaSIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:08:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF9E1AA9;
        Wed, 31 Aug 2022 11:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CE99CE1EA8;
        Wed, 31 Aug 2022 18:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A15C433D7;
        Wed, 31 Aug 2022 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661969318;
        bh=X2tPBwFu7XVmB6phIN9skedNXoCQvadtocOI5Ou7AtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si7DSIRhdsRxBzfyCLDLcXGbY1zTdbsvSoQNoYlvoMOxZV8UzkgMKlyg+KlNF8K6N
         znqPMfNc9gFbGi8sCI/zLztp3m7txw6R3E9ls0XQ6+Ifz5vj0aSW27KuWYW1mazaaV
         TOUvOm9jJzeE6j90fHZTZtVe/YVHbcOai80JCMc1bQIdjzzl3TnBcKO8I58+LQO5Pe
         ES5Pa5R1TA3akb7Qt3xtzvG3Cu7gGpv+XGulOubH6iNkKTCGdwzRerFQB4Lcmcnjxy
         V+K7uuoLvu4anO3dJU+cIL79zUJJ3SW0FKetDPROyhjZ1Icd9562xCLQrzqNetnRFB
         zqNaBhb+kRMLw==
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
Subject: [PATCH v2 1/5] RISC-V: KVM: Record number of signal exits as a vCPU stat
Date:   Thu,  1 Sep 2022 01:59:16 +0800
Message-Id: <20220831175920.2806-2-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
References: <20220831175920.2806-1-jszhang@kernel.org>
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

Record a statistic indicating the number of times a vCPU has exited
due to a pending signal.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 arch/riscv/kvm/vcpu.c             | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 60c517e4d576..dbbf43d52623 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -67,6 +67,7 @@ struct kvm_vcpu_stat {
 	u64 mmio_exit_kernel;
 	u64 csr_exit_user;
 	u64 csr_exit_kernel;
+	u64 signal_exits;
 	u64 exits;
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index d0f08d5b4282..3da459fedc28 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -28,6 +28,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, csr_exit_user),
 	STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
 
@@ -973,6 +974,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
 		}
 
 		/*
-- 
2.34.1

