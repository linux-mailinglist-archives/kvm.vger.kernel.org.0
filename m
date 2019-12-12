Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B011D3DE
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfLLR2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:28:52 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:35258 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730114AbfLLR2r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:28:47 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifSGY-00069s-0w; Thu, 12 Dec 2019 18:28:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>, Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4/8] KVM: arm64: Sanely ratelimit sysreg messages
Date:   Thu, 12 Dec 2019 17:28:20 +0000
Message-Id: <20191212172824.11523-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
References: <20191212172824.11523-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com, mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Currently kvm_pr_unimpl() is ratelimited, so print_sys_reg_instr() won't
spam the console. However, someof its callers try to print some
contextual information with kvm_err(), which is not ratelimited. This
means that in some cases the context may be printed without the sysreg
encoding, which isn't all that useful.

Let's ensure that both are consistently printed together and
ratelimited, by refactoring print_sys_reg_instr() so that some callers
can provide it with an arbitrary format string.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20191205180652.18671-2-mark.rutland@arm.com
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 arch/arm64/kvm/sys_regs.h | 17 +++++++++++++++--
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2071260a275b..e8bf08e09f78 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2094,9 +2094,9 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 		WARN_ON(1);
 	}
 
-	kvm_err("Unsupported guest CP%d access at: %08lx [%08lx]\n",
-		cp, *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
-	print_sys_reg_instr(params);
+	print_sys_reg_msg(params,
+			  "Unsupported guest CP%d access at: %08lx [%08lx]\n",
+			  cp, *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 	kvm_inject_undefined(vcpu);
 }
 
@@ -2245,9 +2245,9 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
 	} else {
-		kvm_err("Unsupported guest sys_reg access at: %lx [%08lx]\n",
-			*vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
-		print_sys_reg_instr(params);
+		print_sys_reg_msg(params,
+				  "Unsupported guest sys_reg access at: %lx [%08lx]\n",
+				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 		kvm_inject_undefined(vcpu);
 	}
 	return 1;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9bca0312d798..5a6fc30f5989 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -62,11 +62,24 @@ struct sys_reg_desc {
 #define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
 #define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
 
-static inline void print_sys_reg_instr(const struct sys_reg_params *p)
+static __printf(2, 3)
+inline void print_sys_reg_msg(const struct sys_reg_params *p,
+				       char *fmt, ...)
 {
+	va_list va;
+
+	va_start(va, fmt);
 	/* Look, we even formatted it for you to paste into the table! */
-	kvm_pr_unimpl(" { Op0(%2u), Op1(%2u), CRn(%2u), CRm(%2u), Op2(%2u), func_%s },\n",
+	kvm_pr_unimpl("%pV { Op0(%2u), Op1(%2u), CRn(%2u), CRm(%2u), Op2(%2u), func_%s },\n",
+		      &(struct va_format){ fmt, &va },
 		      p->Op0, p->Op1, p->CRn, p->CRm, p->Op2, p->is_write ? "write" : "read");
+	va_end(va);
+}
+
+static inline void print_sys_reg_instr(const struct sys_reg_params *p)
+{
+	/* GCC warns on an empty format string */
+	print_sys_reg_msg(p, "%s", "");
 }
 
 static inline bool ignore_write(struct kvm_vcpu *vcpu,
-- 
2.20.1

