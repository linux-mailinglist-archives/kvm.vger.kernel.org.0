Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9152D490
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiESNpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiESNo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFDED8096
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1223617A0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51C4C34115;
        Thu, 19 May 2022 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967868;
        bh=NQ6SWFoOzjdMQ7IQILXMfWfCkw6f84MvjUSYfV0Aqic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr1/kz7V4b+WFeZPm4n6SvvfBLnsn11vQHxdy4iMDYXZkSDLIYQCw/pbXgtRv1zDw
         YUUeyyySJ3IXi+5xgI7BRYzdFotNAm9UMO1tewYm3kNtNK/N3H5fdCJgurDNLLiVaO
         yw26aRCPz9hyn305tg+QacfMEfwRetntZ9hrZ1mSHel/OpfFh2GZ+vCits5vM0GfSM
         imoQRSSP42318gOm1DMDjzcmIjk4ZIHhk40naZpJkLjDKIgODsqTAUz5g9DQ/UTBwd
         7B99D763qW/FGQf5Y2oB6osRJC7aIvvtXHRW3cDutkDZ1Mq4cIf1ARJ1StG5pFrqrz
         PPbvi4EzP3IoA==
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
Subject: [PATCH 31/89] KVM: arm64: Disallow dirty logging and RO memslots with pKVM
Date:   Thu, 19 May 2022 14:41:06 +0100
Message-Id: <20220519134204.5379-32-will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

The current implementation of pKVM doesn't support dirty logging or
read-only memslots. Although support for these features is desirable,
this will require future work, so let's cleanly report the limitations
to userspace by failing the ioctls until then.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 67cac3340d49..df92b5f7ac63 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1679,11 +1679,17 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
-	/* In protected mode, cannot modify memslots once a VM has run. */
-	if (is_protected_kvm_enabled() &&
-	    (change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
-	    kvm->arch.pkvm.shadow_handle) {
-		return -EPERM;
+	if (is_protected_kvm_enabled()) {
+		/* In protected mode, cannot modify memslots once a VM has run. */
+		if ((change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
+		    kvm->arch.pkvm.shadow_handle) {
+			return -EPERM;
+		}
+
+		if (new &&
+		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			return -EPERM;
+		}
 	}
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
-- 
2.36.1.124.g0e6072fb45-goog

