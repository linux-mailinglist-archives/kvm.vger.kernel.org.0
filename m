Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404F7229D0B
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgGVQXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgGVQXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 12:23:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983052065F;
        Wed, 22 Jul 2020 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595434985;
        bh=JDuAd/IXbI8mLdXTBjc0KnzENivxsT/B90lZcHtXwho=;
        h=From:To:Cc:Subject:Date:From;
        b=udcoRBeZF9RGPjhoURMUpD3UOr/OOnpMCD9pTkbd3aDurKJl11MY/yzD6rpZoRjA6
         Z/t+wAijL9lSdZLAeCBTU4LBlpf4oj26sPVCr3uXmGNTNIZC46aunqF46m2n5U1Fnb
         T9gu5YQz2f6mdtoBlP32JjoZHYvc1cawuc1feO5c=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jyHWJ-00E1Ih-Uq; Wed, 22 Jul 2020 17:23:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions
Date:   Wed, 22 Jul 2020 17:22:31 +0100
Message-Id: <20200722162231.3689767-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, kernel-team@android.com, natechancellor@gmail.com, ndesaulniers@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far, vcpu_has_ptrauth() is implemented in terms of system_supports_*_auth()
calls, which are declared "inline". In some specific conditions (clang
and SCS), the "inline" very much turns into an "out of line", which
leads to a fireworks when this predicate is evaluated on a non-VHE
system (right at the beginning of __hyp_handle_ptrauth).

Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
using the cpus_have_final_cap() helpers, which are __always_inline,
generate much better code, and are the only thing that make sense when
running at EL2 on a nVHE system.

Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 147064314abf..a8278f6873e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -391,9 +391,14 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
 
-#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
-				  system_supports_generic_auth()) && \
-				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
+#ifdef CONFIG_ARM64_PTR_AUTH
+#define vcpu_has_ptrauth(vcpu)						\
+	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
+	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
+	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
+#else
+#define vcpu_has_ptrauth(vcpu)		false
+#endif
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

