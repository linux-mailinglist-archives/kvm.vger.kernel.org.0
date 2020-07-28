Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F7023053D
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 10:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgG1IX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 04:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgG1IXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 04:23:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B4820809;
        Tue, 28 Jul 2020 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595924605;
        bh=iJ+8/MWn5KdaoZ81Y0HfDlr48qzak2k8kb91X6SO0S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uewzYw+Xs67HzTT2pJajyh1R5CYcRLNJBkQAy0ca72w4NYphAI5cXI/qsrZk+gbl
         oCAXjVjUAa24o1lA0ewSimmiTtPJPx2LWThxiP8+NgPur0ha3BJ5ydDIiw+ceqxwog
         +ToKOaROkXVQnHLz0hrkP8AmJqLeQgQWGrXs4Ar0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k0KtP-00FaXh-GW; Tue, 28 Jul 2020 09:23:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 1/2] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions
Date:   Tue, 28 Jul 2020 09:22:54 +0100
Message-Id: <20200728082255.3864378-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728082255.3864378-1-maz@kernel.org>
References: <20200728082255.3864378-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, natechancellor@gmail.com, ndesaulniers@google.com, qperret@google.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
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
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20200722162231.3689767-1-maz@kernel.org
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..e21d4a01372f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,9 +380,14 @@ struct kvm_vcpu_arch {
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
2.27.0

