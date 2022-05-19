Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3B652D4F0
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbiESNsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbiESNrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0249597
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B61617C1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DCC36AE5;
        Thu, 19 May 2022 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968018;
        bh=5F/D/YXt7t+edZebowc69LcMSXovKQAVpAUbrzWr4G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRqWIDIZ4YTWgSt+DR16tZq2E1Ls2DuPEl+9nvlXiOkuMl613G47YivsqPXtlNF7r
         Hoc3zHhhPWr0c6vZtsUp0i43+ZPYdo7OrNn/IYLf0AYuvMAmBuO1AI6VOfJLo4lDF2
         tdmi9SP1XL5QacOsTzXTvG/B6yDLhdCJ3dw1qC00PSNkbWbfMCmPv2PCclzh5PktDv
         Lg1N0DkrTLKWaMlg2H4Q0FHmwfQ6tmAkXDMAJuFyy/QBU5QaUoI1OndaP+gS3MCqlB
         OwjyF8M0PlwnflbwrlewxH0oaOxNp9cNZTqlrZsPLYHLG9a9I90bEgkV3jT2i0eX4x
         n59cjJsO/e/AA==
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
Subject: [PATCH 69/89] KVM: arm64: Do not update virtual timer state for protected VMs
Date:   Thu, 19 May 2022 14:41:44 +0100
Message-Id: <20220519134204.5379-70-will@kernel.org>
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

Protected vCPUs always run with a virtual counter offset of 0, so don't
bother trying to update it from the host.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6e542e2eae32..63d06f372eb1 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -88,7 +88,9 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		if (likely(!kvm_vm_is_protected(vcpu->kvm)))
+			return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		fallthrough;
 	default:
 		return 0;
 	}
@@ -753,6 +755,9 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *tmp;
 
+	if (unlikely(kvm_vm_is_protected(vcpu->kvm)))
+		cntvoff = 0;
+
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, tmp, kvm)
 		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
-- 
2.36.1.124.g0e6072fb45-goog

