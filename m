Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C450D600E3F
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiJQLyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiJQLx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DFD58513
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54AD3B81633
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BDAC4347C;
        Mon, 17 Oct 2022 11:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007627;
        bh=o1+D7GlEbIo/66tqzr55voUAuV+8d8HNm+7m2mJHTnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEvz1dN9V2J6DfWwaHcINmGNk5KfC+DrGecS/CYfMFt3bqlb0z/5Gu4lSnVKrjvLR
         H+pq4EHAvciAwcJl8/5q0a3v/7vsiJweWJzs1FpIZu0dG+Pbh9xeATxkEIO2suI4wk
         3MnGnzPp0BYBQt2he5snpb62IhURuZt7VIvWmQn12j1+1Aj4rdWnTMLTVnD4yu6gfJ
         ASqmT6v4l8QDNir6qvaiUj2logQs2EkcsyuwVnDkzpFkkOIZvcIXFbdAg7EUJrL0rO
         87/VupeAHUljJt5U8ZkRnCXVOfEABvq163z88euFMFVOqPo+KzvJh1hQEAia8fCt72
         wyuK82vvGkgog==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
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
Subject: [PATCH v4 24/25] KVM: arm64: Don't unnecessarily map host kernel sections at EL2
Date:   Mon, 17 Oct 2022 12:52:08 +0100
Message-Id: <20221017115209.2099-25-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/image-vars.h  |  6 ------
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 +++-----------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 31ad75da4d58..e3f88b5836a2 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -102,12 +102,6 @@ KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
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
2.38.0.413.g74048e4d9e-goog

