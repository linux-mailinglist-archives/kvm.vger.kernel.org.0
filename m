Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AAF5B8321
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiINIhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiINIgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2721D74DE8
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD028614CE
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AE4C433B5;
        Wed, 14 Sep 2022 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144594;
        bh=XjVIvPU3zWa+9OaMaawmlciTVUPSR/pweEDm06D5NfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYIr2IcYtoMGNjm2gY3rGb9TcmYPaINJIGzYn3I/vJbyoFgwyV5/t549bxDRmrRYC
         poCmhac3+zOGXRPItBMVUsp4ffd4He9oQ8J4lYy6EGrPyYnN6aZxan3TBb10mpG1Y6
         AV/+BP/6BZOupGnmutAKXqQWTMS/T8JNYu+nsWBQsL/XL8xb0Ukz1AUV5Xy16QwSIi
         +08VrXlYcnsdfJMM3YFeR/RpC1b0RFCvdiODBX2+PH5y0jqBfwTkN/CIsRMeVY/kFu
         EN9gg8pr/eR5XDjc8vsKklInPrtpa3dLUcv6W9Vxy7tK7pwL2ypptdK49h5tAF0Aty
         Hbly6X2HEkncA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 24/25] KVM: arm64: Don't unnecessarily map host kernel sections at EL2
Date:   Wed, 14 Sep 2022 09:34:59 +0100
Message-Id: <20220914083500.5118-25-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We no longer need to map the host's '.rodata' and '.bss' sections in the
stage-1 page-table of the pKVM hypervisor at EL2, so remove those
mappings and avoid creating any future dependencies at EL2 on
host-controlled data structures.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/image-vars.h  |  6 ------
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 +++-----------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d20dc9d555af..b585bbd36d81 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -118,12 +118,6 @@ KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
 KVM_NVHE_ALIAS_HYP(__memset, __pi_memset);
 #endif
 
-/* Kernel memory sections */
-KVM_NVHE_ALIAS(__start_rodata);
-KVM_NVHE_ALIAS(__end_rodata);
-KVM_NVHE_ALIAS(__bss_start);
-KVM_NVHE_ALIAS(__bss_stop);
-
 /* Hyp memory sections */
 KVM_NVHE_ALIAS(__hyp_idmap_text_start);
 KVM_NVHE_ALIAS(__hyp_idmap_text_end);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 5a371ab236db..5cdf3fb09bb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -144,23 +144,15 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	}
 
 	/*
-	 * Map the host's .bss and .rodata sections RO in the hypervisor, but
-	 * transfer the ownership from the host to the hypervisor itself to
-	 * make sure it can't be donated or shared with another entity.
+	 * Map the host sections RO in the hypervisor, but transfer the
+	 * ownership from the host to the hypervisor itself to make sure they
+	 * can't be donated or shared with another entity.
 	 *
 	 * The ownership transition requires matching changes in the host
 	 * stage-2. This will be done later (see finalize_host_mappings()) once
 	 * the hyp_vmemmap is addressable.
 	 */
 	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
-	ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
-	if (ret)
-		return ret;
-
-	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(&kvm_vgic_global_state,
 				   &kvm_vgic_global_state + 1, prot);
 	if (ret)
-- 
2.37.2.789.g6183377224-goog

