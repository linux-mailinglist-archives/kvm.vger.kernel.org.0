Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2852D4B3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiESNqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239121AbiESNpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0541B5B3F0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963406179E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86938C36AE7;
        Thu, 19 May 2022 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967896;
        bh=/a8/l7RJWZHY7hWaGIhGiCgxQi3kK7qNlpV74vXL9LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fh8c5EEbrBocWn0/lbHq/tOjwQAeOeCpvwb1HjvKWwOCOFcLRVML86UOKzPSI3V2J
         M6sQ+8Cc85Z+LtafNVYgt+IFIilx2fIhgbu75oaIuiFI6TXQoR7Bj2uRq9UID0IUjl
         Ip+LSj0r7Y1wsbnve37h+sVkLs+8TvWOeE2NJZ+n2xsGsr/8w7ImG6UMBDjAHBWlML
         C6VYkCXFBpzQsGesBkH7Wc99/MmLzYHr7hJYSCHtI5GOqkA6vJl45WLRc2NWafy+rB
         jvJTQ/npO6byjhnxdCJtVN9qyNC6ooBVfH3RaI7dpiGumqb1vT4vqf4k/wlG65/PBl
         MR5Q+ayZpl6Jg==
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
Subject: [PATCH 38/89] KVM: arm64: Don't map host sections in pkvm
Date:   Thu, 19 May 2022 14:41:13 +0100
Message-Id: <20220519134204.5379-39-will@kernel.org>
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

We no longer need to map the host's .rodata and .bss sections in the
pkvm hypervisor, so let's remove those mappings. This will avoid
creating dependencies at EL2 on host-controlled data-structures.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kernel/image-vars.h  |  6 ------
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 +++-----------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 3e2489d23ff0..2d4d6836ff47 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -115,12 +115,6 @@ KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
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
index a851de624074..c55661976f64 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -119,23 +119,15 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
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
2.36.1.124.g0e6072fb45-goog

