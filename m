Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02A952D4D0
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbiESNrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiESNqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4B3101E1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAAF6B824AB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E1C36AE5;
        Thu, 19 May 2022 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967959;
        bh=cvBKGfWFAbmH68bmeDTUSse0RpVg4TXL+HSHAKVcsow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQp2SFcckGWaZ9r0J9knvbktkXOKat0vRrw0drOozmkrj5NmVw+v4Z1R1k2SIUxh/
         tZNo0nxM6bw4OZGYXFVFUR2oF9sQ2KLHxFgTEMcna2qXdo7NDaeG3hkx+WH2jsnXiH
         xlxQcV3WCwpZWdkEK6BnY/k5Ca1DblJjAl/yKHX6pct9uCx/nLEZa2UBebBkYHq9JZ
         l0fQFEOiUQMJpeZbA51jyKB3gtseKc8z4xyhtMzLuWBxXsc2mphJwz61qYXJ1cNL/f
         SimpwFLv03rxan7C6ccAVnO/6rzgBCSNmoIIWii5vMFHu+SEutvx5hKD5X4YPZmAmq
         mmtHtc6gGT3FQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 54/89] KVM: arm64: Reduce host/shadow vcpu state copying
Date:   Thu, 19 May 2022 14:41:29 +0100
Message-Id: <20220519134204.5379-55-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

When running with pKVM enabled, protected guests run with a fixed CPU
configuration and therefore features such as hardware debug and SVE are
unavailable and their state does not need to be copied from the host
structures on each flush operation. Although non-protected guests do
require the host and shadow structures to be kept in-sync with each
other, we can defer writing back to the host to an explicit sync
hypercall, rather than doing it after every vCPU run.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 228736a9ab40..e82c0faf6c81 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -196,17 +196,18 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 
 		if (host_flags & KVM_ARM64_PKVM_STATE_DIRTY)
 			__flush_vcpu_state(shadow_state);
-	}
 
-	shadow_vcpu->arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	shadow_vcpu->arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+		shadow_vcpu->arch.sve_state = kern_hyp_va(host_vcpu->arch.sve_state);
+		shadow_vcpu->arch.sve_max_vl = host_vcpu->arch.sve_max_vl;
 
-	shadow_vcpu->arch.hcr_el2	= host_vcpu->arch.hcr_el2;
-	shadow_vcpu->arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+		shadow_vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS & ~(HCR_RW | HCR_TWI | HCR_TWE);
+		shadow_vcpu->arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2);
 
-	shadow_vcpu->arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
+		shadow_vcpu->arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
+		shadow_vcpu->arch.debug_ptr = kern_hyp_va(host_vcpu->arch.debug_ptr);
+	}
 
-	shadow_vcpu->arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
+	shadow_vcpu->arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
 
 	flush_vgic_state(host_vcpu, shadow_vcpu);
 	flush_timer_state(shadow_state);
@@ -238,10 +239,10 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state,
 	unsigned long host_flags;
 	u8 esr_ec;
 
-	host_vcpu->arch.ctxt		= shadow_vcpu->arch.ctxt;
-
-	host_vcpu->arch.hcr_el2		= shadow_vcpu->arch.hcr_el2;
-
+	/*
+	 * Don't sync the vcpu GPR/sysreg state after a run. Instead,
+	 * leave it in the shadow until someone actually requires it.
+	 */
 	sync_vgic_state(host_vcpu, shadow_vcpu);
 	sync_timer_state(shadow_state);
 
-- 
2.36.1.124.g0e6072fb45-goog

