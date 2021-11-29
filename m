Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650004624A7
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhK2WXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhK2WVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:21:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C0BC091D3D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52DABCE140F
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AFCC53FCD;
        Mon, 29 Nov 2021 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216470;
        bh=iJui46ZcjZoyFxy28ez7102NEjA5q3RQEoAi8jCgTJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDvMQKBk+sYYiGsmoh2H2oe2+SEOMSHIZ5dLPnqUbcNfRdpqOaICLXukmri4U2IhN
         wZ0In22rJkTmx6PQipCEfphs8PZYD/Nh+ppxXQmBViJAkWfdvCNXJx0mJeqMKoP1Zp
         Rpfg1cJ4CV/QGjt0Ftkl86k6iXeEFxCNFe9rw3ZGx/5mk4dclHat0bhqMnVL2H9BNF
         wQ6pfgrZFv5bBDk5siZ6Cai4pxT5UU7xAE0nOoq7ZnwTtHXx2nZlk4BpU0zk9sykKt
         qSLCBbucVN3vNYdhdnkW+jnagE4MHbSGBFWcz57TL6Ygvwc/kr6u+isWvp8nPP10fO
         iCjeZtg53pt5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqx-008gvR-08; Mon, 29 Nov 2021 20:02:19 +0000
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
Subject: [PATCH v5 30/69] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
Date:   Mon, 29 Nov 2021 20:01:11 +0000
Message-Id: <20211129200150.351436-31-maz@kernel.org>
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

Forward the EL1 virtual memory register traps to the virtual EL2 if they
are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3468b8df8661..e96877fc3b2a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -382,6 +382,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p)) {
+		u64 bit = p->is_write ? HCR_TVM : HCR_TRVM;
+
+		if (forward_traps(vcpu, bit))
+			return false;
+	}
+
 	/* We don't expect TRVM on the host */
 	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
 
-- 
2.30.2

