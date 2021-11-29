Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FA8462389
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhK2Vp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhK2Vnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:43:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDE5C091D10
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 990D7CE140D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86F7C53FD1;
        Mon, 29 Nov 2021 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216331;
        bh=tTxcULXoo3QMlH9nFuTANsqJJDvpHaZXohlcPR2wbWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3YpLz8+uJ97q1qgocMm/qBME7Or4leBztDeHl8LLfcYLQwYdiEJ/8K9Vb83elpLS
         mFO249KYbRxRrYifgBfI5Nvv7LmfU4phIFVF7Ye9Ag8Sj/b6phUu9/IStJqnZ5y4Um
         sDvsEQ4gkFhh9GyNvalpFl0MQGdhpbBCCIq1n4KZZlsJereKlXEeG5+KIKkKnR8g9/
         zF7RF0iJRzkkLLgNxnmJDgmJdAat2KUflypGZqxwkZU4OiIlsXHQ2ot9PSDIBAYgb0
         xSesnCXlh9OHCvSAnmx+9V/TOlFItkKjBsuDlc0as9QyqpcJpLkfE2ObRRZ8tm79GS
         DPic66p0ICqXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrB-008gvR-64; Mon, 29 Nov 2021 20:02:33 +0000
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
Subject: [PATCH v5 52/69] KVM: arm64: nv: Don't load the GICv4 context on entering a nested guest
Date:   Mon, 29 Nov 2021 20:01:33 +0000
Message-Id: <20211129200150.351436-53-maz@kernel.org>
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

When entering a nested guest (vgic_state_is_nested() == true),
special care must be taken *not* to make the vPE resident, as
these are interrupts targetting the L1 guest, and not any
nested guest.

By not making the vPE resident, we guarantee that the delivery
of an vLPI will result in a doorbell, forcing an exit from the
nested guest and a switch to the L1 guest to handle the interrupt.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ae4d6489373d..7b575df62fa9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -736,8 +736,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 
 	if (vgic_state_is_nested(vcpu))
 		vgic_v3_load_nested(vcpu);
-
-	WARN_ON(vgic_v4_load(vcpu));
+	else
+		WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
@@ -755,6 +755,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	/*
+	 * vgic_v4_put will do nothing if we were not resident. This
+	 * covers both the cases where we've blocked (we already have
+	 * done a vgic_v4_put) and when running a nested guest (the
+	 * vPE was never resident in order to generate a doorbell).
+	 */
 	WARN_ON(vgic_v4_put(vcpu, false));
 
 	vgic_v3_vmcr_sync(vcpu);
-- 
2.30.2

