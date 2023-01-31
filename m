Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA07682928
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjAaJlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjAaJlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:41:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D512F79F
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6425061478
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBDDC433D2;
        Tue, 31 Jan 2023 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158084;
        bh=ycJQTa90vNc+zMPsmHdkSUMnSh/e/B8/iWuzQP1sK/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eW1KAYTImXH4uKcG50l+3lzAf+qP+IcoWswxpH+ZhKTG5Bfi3Gd31I/pVgMc0Jatd
         s7SyMVT1BvQMLjDJ6te0nZcf/h30TutFLflJZJT/ny/v0fPZGzIyuNB6+nHUNjRy4N
         BUEL12QfPQzU4R3bpOXvj+ZGEuebunB4F6/m5z9g7KDZ6MiKTCCOT5yvViovu4g0sr
         VHg/i+Ru1LzlxO4w/3Yviogbg1LKraWDy4NKn79Rlv0XaEU+k9YFr2ihbuS8Xue5pX
         26dl3mT+Cqgu2SWkfiZGjXBqfLp9rixYbWuc0fMzMblLOcroLtxfQqxnV4wV3x1dwZ
         9SLCLshDkVLyQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtQ-0067U2-Jt;
        Tue, 31 Jan 2023 09:25:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 11/69] KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
Date:   Tue, 31 Jan 2023 09:24:06 +0000
Message-Id: <20230131092504.2880505-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

As we expect all PSCI calls from the L1 hypervisor to be performed
using SMC when nested virtualization is enabled, it is clear that
all HVC instruction from the VM (including from the virtual EL2)
are supposed to handled in the virtual EL2.

Forward these to EL2 as required.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: add handling of HCR_EL2.HCD]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e778eefcf214..2d8c09cf3e49 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -16,6 +16,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/debug-monitors.h>
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
@@ -41,6 +42,16 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
+	if (vcpu_has_nv(vcpu)) {
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
2.34.1

