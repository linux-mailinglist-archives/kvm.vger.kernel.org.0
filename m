Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AD2600E2C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiJQLxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJQLwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B7580A6
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759A6B812A8
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E06AC433C1;
        Mon, 17 Oct 2022 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007567;
        bh=jCaLq7to3/AuF6vKjq7Qx6bD9iG0ZWRGazDqhkaJ4I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaZCh2dF42xC996Jl1/+QdGYrF4UWLVy30p1+GZ9W5ybbpzJp31QBnOFNEJqvaDKr
         DHjIOyBDT1yZ8y40qqMoFNYrWpogNpD+0za6G92OJKRFlqqxI/LBMJWrgoUK8bkYOB
         zsGhXRec9/MqFtmBfH1xPLoDvDML1Sb6dGGhKvV4AxOhnsMJtnh4vf1MOH5wmLouTL
         ZZSeI9FX43vOdSrk9jKxUAGJsTLw4VDlmB50+59t5Q47t96BPdxM+Ayg07siNuo/y4
         m5O5cwfM3UVT27rJbhTScpJHNo2ZKEg4RK1rjyrxAU07radKibv+2yQPRL7o252IjB
         uM5jBnOvDDWMQ==
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
Subject: [PATCH v4 07/25] KVM: arm64: Prevent the donation of no-map pages
Date:   Mon, 17 Oct 2022 12:51:51 +0100
Message-Id: <20221017115209.2099-8-will@kernel.org>
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

Memory regions marked as "no-map" in the host device-tree routinely
include TrustZone carevouts and DMA pools. Although donating such pages
to the hypervisor may not breach confidentiality, it could be used to
corrupt its state in uncontrollable ways. To prevent this, let's block
host-initiated memory transitions targeting "no-map" pages altogether in
nVHE protected mode as there should be no valid reason to do this in
current operation.

Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
of memblock regions, so we can easily check for the presence of the
MEMBLOCK_NOMAP flag on a region containing pages being donated from the
host.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c30402737548..a7156fd13bc8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -193,7 +193,7 @@ struct kvm_mem_range {
 	u64 end;
 };
 
-static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+static struct memblock_region *find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
 	struct memblock_region *reg;
@@ -216,18 +216,28 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 		} else {
 			range->start = reg->base;
 			range->end = end;
-			return true;
+			return reg;
 		}
 	}
 
-	return false;
+	return NULL;
 }
 
 bool addr_is_memory(phys_addr_t phys)
 {
 	struct kvm_mem_range range;
 
-	return find_mem_range(phys, &range);
+	return !!find_mem_range(phys, &range);
+}
+
+static bool addr_is_allowed_memory(phys_addr_t phys)
+{
+	struct memblock_region *reg;
+	struct kvm_mem_range range;
+
+	reg = find_mem_range(phys, &range);
+
+	return reg && !(reg->flags & MEMBLOCK_NOMAP);
 }
 
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
@@ -346,7 +356,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
 static int host_stage2_idmap(u64 addr)
 {
 	struct kvm_mem_range range;
-	bool is_memory = find_mem_range(addr, &range);
+	bool is_memory = !!find_mem_range(addr, &range);
 	enum kvm_pgtable_prot prot;
 	int ret;
 
@@ -424,7 +434,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
-- 
2.38.0.413.g74048e4d9e-goog

