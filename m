Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AF923CEA1
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHESoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729168AbgHES1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2FD322D2A;
        Wed,  5 Aug 2020 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651987;
        bh=hP1SRFFRWqbDLnmg7Ay63LFh6KHBdMO20c6qOlnTzaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9eEK8BsrKZSBdrVuibcMXxUkOL3E4OeEGwyLqOiAD72vkvE1mgubR+PctgLbx/qK
         w9d85l7gVxXaqPvl+OEv5knhp3E8oh3phOB3X0HVrFUJW3LrUpYn7ZpiytWtcbN4KO
         PBsFiJ37pcTIvWo/PIgaxNQerQLevFnqpUGoe+1Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfm-0004w9-QR; Wed, 05 Aug 2020 18:57:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 36/56] KVM: arm64: Introduce accessor for ctxt->sys_reg
Date:   Wed,  5 Aug 2020 18:56:40 +0100
Message-Id: <20200805175700.62775-37-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to allow the disintegration of the per-vcpu sysreg array,
let's introduce a new helper (ctxt_sys_reg()) that returns the
in-memory copy of a system register, picked from a given context.

__vcpu_sys_reg() is rewritten to use this helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 85a529eeeae3..5b168226088e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -405,12 +405,17 @@ struct kvm_vcpu_arch {
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
 /*
- * Only use __vcpu_sys_reg if you know you want the memory backed version of a
- * register, and not the one most recently accessed by a running VCPU.  For
- * example, for userspace access or for system registers that are never context
- * switched, but only emulated.
+ * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
+ * memory backed version of a register, and not the one most recently
+ * accessed by a running VCPU.  For example, for userspace access or
+ * for system registers that are never context switched, but only
+ * emulated.
  */
-#define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
+#define __ctxt_sys_reg(c,r)	(&(c)->sys_regs[(r)])
+
+#define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
+
+#define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
-- 
2.27.0

