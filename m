Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664652D4C7
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiESNqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiESNo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:44:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC6FD808A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEF56B824AB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA773C36AE5;
        Thu, 19 May 2022 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967864;
        bh=p7gI1CdAvMGFDucFGozIsSRUoT2cXsZgzqAgI+aWRJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7W4ZFQznwTwavYOMNgqoZkaJVWQsO9jN5kCKT1XWf5AaAmeKy3VxnW9sjsHkTLrG
         TfY6Z1cv3xDm6oV5E3McihQcd+gS4Vyn0F611oNXQlegU9gA0keNPi0EzvSHc2haHl
         NDdjUkPfBZFxp2ELKBx3uel0J7617Iv1ErnVXybdPJrzSMpd3Bif4Cg8eyF6eST2sk
         jWX9PujhExD/LYygdXm3cXPKf98gQR2loIkkuIl4K4arnxGzaUUBCG9Da4gWbMAc3V
         dsR4JViAgvGJnJWKzm5iSCzC6dwD1JRI63LsONf+4c9LakPeXQgPuvw+zYfW5JDy0O
         Ef8kzB05GrtWA==
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
Subject: [PATCH 30/89] KVM: arm64: Do not allow memslot changes after first VM run under pKVM
Date:   Thu, 19 May 2022 14:41:05 +0100
Message-Id: <20220519134204.5379-31-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

As the guest stage-2 page-tables will soon be managed entirely by EL2
when pKVM is enabled, guest memory will be pinned and the MMU notifiers
in the host will be unable to reconfigure mappings at EL2 other than
destrroying the guest and reclaiming all of the memory.

Forbid memslot move/delete operations for VMs that have run under pKVM,
returning -EPERM to userspace if such an operation is requested.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0071f035dde8..67cac3340d49 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1679,6 +1679,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
+	/* In protected mode, cannot modify memslots once a VM has run. */
+	if (is_protected_kvm_enabled() &&
+	    (change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
+	    kvm->arch.pkvm.shadow_handle) {
+		return -EPERM;
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
@@ -1755,6 +1762,10 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
+	/* Stage-2 is managed by hyp in protected mode. */
+	if (is_protected_kvm_enabled())
+		return;
+
 	write_lock(&kvm->mmu_lock);
 	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	write_unlock(&kvm->mmu_lock);
-- 
2.36.1.124.g0e6072fb45-goog

