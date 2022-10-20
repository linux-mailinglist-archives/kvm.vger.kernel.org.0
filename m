Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5354D605AA2
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJTJHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJTJHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C7119B670
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3256B826B2
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200A5C43143;
        Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256858;
        bh=1jQOoC4QeQ5PeHe2BUgnYaoSU2WdJgjc/MaY/L+aAw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI0AJzHCwQ27ve49DQJVt3jVb11zYNLOweUKPoM8w0DCWGWLIiS1IVQHn1kGca3Dd
         shNP2A6hLIZDbg4sjJSFcnoEV1YmVaWUNS4dzCZLQeGFlttJ6q0VyOY2mdSSktQqmp
         orBNIAxCwtxUoX5q1yCmYrnnGc4ReCc6IREj9NEvUjHI4BmoqJa3i+cuEiz22udzjM
         NkRp1LycxjwtIUXMkzy33EYGxLdLW+pdwa4TTd9yBtqgFGFagkXzgAWLOjkFAVElTE
         XemSEnThjC9TN7z5ukY3G//88qxl3AP5mgzB8S2Jsg5ymMhqTCSuxoy2rgl5t+CwgM
         wzToEtN6uBXog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWa-000Buf-CF;
        Thu, 20 Oct 2022 10:07:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 07/17] KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hypervisor
Date:   Thu, 20 Oct 2022 10:07:17 +0100
Message-Id: <20221020090727.3669908-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For VHE-specific hypervisor code, kern_hyp_va() is a NOP.

Actually, it is a whole range of NOPs. It'd be much better if
this code simply didn't exist. Let's just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7784081088e7..e32725e90360 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -63,6 +63,7 @@
  * specific registers encoded in the instructions).
  */
 .macro kern_hyp_va	reg
+#ifndef __KVM_VHE_HYPERVISOR__
 alternative_cb ARM64_ALWAYS_SYSTEM, kvm_update_va_mask
 	and     \reg, \reg, #1		/* mask with va_mask */
 	ror	\reg, \reg, #1		/* rotate to the first tag bit */
@@ -70,6 +71,7 @@ alternative_cb ARM64_ALWAYS_SYSTEM, kvm_update_va_mask
 	add	\reg, \reg, #0, lsl 12	/* insert the top 12 bits of the tag */
 	ror	\reg, \reg, #63		/* rotate back */
 alternative_cb_end
+#endif
 .endm
 
 /*
@@ -126,6 +128,7 @@ void kvm_apply_hyp_relocations(void);
 
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
+#ifndef __KVM_VHE_HYPERVISOR__
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
 				    "ror %0, %0, #1\n"
 				    "add %0, %0, #0\n"
@@ -134,6 +137,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 				    ARM64_ALWAYS_SYSTEM,
 				    kvm_update_va_mask)
 		     : "+r" (v));
+#endif
 	return v;
 }
 
-- 
2.34.1

