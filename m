Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34643159701
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgBKRwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730561AbgBKRwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:33 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9539E20848;
        Tue, 11 Feb 2020 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443552;
        bh=+GxwISj8L9rgC421r+aQwDL/s2TLFKCCFgapyXZ3gcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7/rcirA0+aBR5svs3tWmrs1dw7oWNx/QmvgwQJvUmS+cHpP41KuWoCMycJbHSxGN
         Fat5bTY8ykqrYJXjBCKe+1LC835ZKaGcKFpTfAUgOKd2ecrJcyqXWsi/1t8gzPYjN4
         5jh9m3Tw2d2uZ1wRRbBowUPy6Vc6YrD9NqZzCf2w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgC-004O7k-IW; Tue, 11 Feb 2020 17:50:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 73/94] KVM: arm64: sve: Use __vcpu_sys_reg() instead of raw sys_regs access
Date:   Tue, 11 Feb 2020 17:49:17 +0000
Message-Id: <20200211174938.27809-74-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a wrapper for the sysreg accesses, let's use that
consistently.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 525010504f9d..738ee805aa3c 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -110,12 +110,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	local_irq_save(flags);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		u64 *guest_zcr = &vcpu->arch.ctxt.sys_regs[ZCR_EL1];
-
 		fpsimd_save_and_flush_cpu_state();
 
 		if (guest_has_sve)
-			*guest_zcr = read_sysreg_s(SYS_ZCR_EL12);
+			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
 	} else if (host_has_sve) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
-- 
2.20.1

