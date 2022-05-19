Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5052D4C5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbiESNq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiESNpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0FC3EF11
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 468C1617A2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFBBC34100;
        Thu, 19 May 2022 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967935;
        bh=01scSGwFMX4UX/Fyks9TF9FRUQgO1lQ2Yumv8GkNuXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsLv2QBDVEbJnkW9C6SNDZaSlM95bEV9jgWjWDC33tevmIDYfvPlgWQfBf2C29IE8
         PdrjeP1VGHB94FH6y35YbmYNC/i9JVfbJB+emajAZaoIzi95LKLCU+SwTbGWkUrS/p
         MoXyjdHnNQ6HAi/FTI8f+/qIX20stHS87CALlgAbqEbPAPGNrJkMgrFuPNFYLtm2n+
         rtC2wyfGHOJAFkgmrNzzWMiFXrTFkfPagj2sTYvDldt1HDi1Q1syEqX2xr8AcRuLV3
         wNRwecTcQNVScVjsq0sxNu66dlU02HnZfRA81vGhPJokr0hhQmWejRAF31YI9aeRzf
         q4kTZXgcig5Hw==
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
Subject: [PATCH 48/89] KVM: arm64: Skip __kvm_adjust_pc() for protected vcpus
Date:   Thu, 19 May 2022 14:41:23 +0100
Message-Id: <20220519134204.5379-49-will@kernel.org>
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

Prevent the host from issuing arbitrary PC adjustments for protected
vCPUs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 40cbf45800b7..86dff0dc05f3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -275,9 +275,22 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = get_current_vcpu(host_ctxt, 1, &shadow_state);
+	if (!vcpu)
+		return;
+
+	if (shadow_state) {
+		/* This only applies to non-protected VMs */
+		if (shadow_state_is_protected(shadow_state))
+			return;
+
+		vcpu = &shadow_state->shadow_vcpu;
+	}
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	__kvm_adjust_pc(vcpu);
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
-- 
2.36.1.124.g0e6072fb45-goog

