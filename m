Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C700C4623A4
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhK2Vto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhK2Vrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:47:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3AC08EB3C
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E03C6CE1410
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218E1C53FCD;
        Mon, 29 Nov 2021 20:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216394;
        bh=rvoIj5sBGV8NY7D6FsGInJvNPEPNgZDlDa3Ec2tMPLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUrEvQgIPIX/tY3L8hxXp2CmBWG0KgRQdqsUDv8MxExJYJdaDChMk1BU1+/xrpUTX
         TvCNHAMsWO3GLcuP3kQt/Y2RyeRac6RKB9sLkHacqcR/30KXlKfvKUMWhJikuZbfrd
         +pymOOdYD4pqnWAFrGMlNSYP/15WXbowSpVaOuZrImg65eiQQ/aXDJI+sMMhfOpZKH
         UNQrC0kvGqvU+sOaLuspN20yjeYrysDwAoPj/ybdDTr3pA5eY3LjuEW5HB4I83LTgM
         2V0VIvOH3cZEpDs3B37rSZO6k59e+NlFHM/Yg4u7m7g8atMhB3L8MFCHItetV5Wdzg
         Zb83gaRO4RLWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqs-008gvR-5A; Mon, 29 Nov 2021 20:02:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 15/69] KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
Date:   Mon, 29 Nov 2021 20:00:56 +0000
Message-Id: <20211129200150.351436-16-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

As we expect all PSCI calls from the L1 hypervisor to be performed
using SMC when nested virtualization is enabled, it is clear that
all HVC instruction from the VM (including from the virtual EL2)
are supposed to handled in the virtual EL2.

Forward these to EL2 as required.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: add handling of HCR_EL2.HCD]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..1fd1c6dfd6a0 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -16,6 +16,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/debug-monitors.h>
 #include <asm/traps.h>
 
@@ -40,6 +41,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
+	if (nested_virt_in_use(vcpu)) {
+		if (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_HCD)
+			kvm_inject_undefined(vcpu);
+		else
+			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+		return 1;
+	}
+
 	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
-- 
2.30.2

