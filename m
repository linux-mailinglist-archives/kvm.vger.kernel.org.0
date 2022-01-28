Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00CD49F94C
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348491AbiA1MUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbiA1MU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E51C06174E
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8716D61AE3
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88D0C340E6;
        Fri, 28 Jan 2022 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372427;
        bh=wqhIZcZjCG8ZfdU+M+zw1+wAN8pkiQnHo3bZ8MRkd1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWBKEwmbKzmg+AyQVAIAs02Hbepoq6KRYqcYTf8tlAnlurmpE2zZwdqdjc1USPzhx
         D18H5QKygJGwxuwnjgLbRPFMEZz8CI57bvOp3AKY9V4hlHL9dk6sCj0bFY0ppxYj1T
         EjuaqSaIrdIPCUobpBl99dCAd2QUn86fygFKUesFtwwSp6NazrJ5OCgSh/4OgyQOt9
         hGqTRloYDD+sQ09QyQ+iPhYi/aj+8CrtAMyT7KKJPbrxi50k8q6h6GPfCoYfMMeTzO
         Um2krxSC3cYAs/c+UVN9tYeDbq2zjJLdYSOHcS0WWPUheY58otKXvPHbXWEgOMItcE
         tkeOpYHGyAyXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE5-003njR-AT; Fri, 28 Jan 2022 12:19:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 25/64] KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
Date:   Fri, 28 Jan 2022 12:18:33 +0000
Message-Id: <20220128121912.509006-26-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
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
index ccd063d6cb69..edaf287c7ec9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -351,6 +351,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
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
 	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
 
-- 
2.30.2

