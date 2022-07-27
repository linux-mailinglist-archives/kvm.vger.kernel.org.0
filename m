Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF85828A6
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiG0O3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiG0O3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015AA2F00C
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1281BB8218A
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5AC43470;
        Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932166;
        bh=fZInrAoNIVl8PR0KpPGqdwlflap1sZZaD7KTRy5ITxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N16LoX6sEIfnKsJ4VapTkdCtVgIv4l3efmNbGIh9CotiND+28uE6EmYY0nFK6Pi8x
         5c79S/T0IFV4nxWgj87xx8RSAJysD33pqPes4YeD6NGBtTBt5NEc6c2lU9/5MknQ6x
         GM3SMEo5T8SXa0n0tDtybfeJIcUx6abwYiW0uaisS9bbApZCpROztnIsiJr1yJARMT
         oeAwjSd4dckzL89bctz2/ZYjdkueaCrdgcMDXXCWCoGoykqv/O8UtInnBm9sUZvj5v
         ES65Vq/wF5ojSIh9gH8Oet94mgkBEhhUlThBqb+SR7ZVFIJAEhamOvETWh7CQ1htyT
         r7MSAw7u8TAdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2O-00APjL-Jm;
        Wed, 27 Jul 2022 15:29:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 5/6] KVM: arm64: Don't open code ARRAY_SIZE()
Date:   Wed, 27 Jul 2022 15:29:05 +0100
Message-Id: <20220727142906.1856759-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oliver.upton@linux.dev>

Use ARRAY_SIZE() instead of an open-coded version.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 3 +--
 arch/arm64/kvm/stacktrace.c          | 6 ++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index acbe272ecb32..58f645ad66bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -103,14 +103,13 @@ static void notrace unwind(struct unwind_state *state,
 static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
 {
 	unsigned long *stacktrace = this_cpu_ptr(pkvm_stacktrace);
-	int size = NVHE_STACKTRACE_SIZE / sizeof(long);
 	int *idx = (int *)arg;
 
 	/*
 	 * Need 2 free slots: 1 for current entry and 1 for the
 	 * delimiter.
 	 */
-	if (*idx > size - 2)
+	if (*idx > ARRAY_SIZE(pkvm_stacktrace) - 2)
 		return false;
 
 	stacktrace[*idx] = where;
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 417665854f86..949d19d603fb 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -187,11 +187,13 @@ static void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
 	unsigned long *stacktrace
 		= (unsigned long *) this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
-	int i, size = NVHE_STACKTRACE_SIZE / sizeof(long);
+	int i;
 
 	kvm_nvhe_dump_backtrace_start();
 	/* The saved stacktrace is terminated by a null entry */
-	for (i = 0; i < size && stacktrace[i]; i++)
+	for (i = 0;
+	     i < ARRAY_SIZE(kvm_nvhe_sym(pkvm_stacktrace)) && stacktrace[i];
+	     i++)
 		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
 	kvm_nvhe_dump_backtrace_end();
 }
-- 
2.34.1

