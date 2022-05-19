Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB2C52D48C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiESNpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiESNnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:43:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F31719CE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC42EB82477
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E9EC34117;
        Thu, 19 May 2022 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967816;
        bh=85shQP61BCSRjbXAkRjEzDdqJZbFWFzFv7BZf/OaUmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgnhwW8HZyvKsH5oQyPqeOqAEt7QEwzyfAEDHLdPSe3emDrRl2fCYuS0Dldl2ItKa
         FWCA3edEkx7BVHqHb8PI81qO4XPXgJFtFKSFK3LqXV0aBpSguRmJ9xT69Pgw/N40P7
         vD7sa/6qrCRvinCefLpUO8F0PxUqhzGq8+OEuZ2AXgIuAoOM+/7j7CtPU+SeFAoypv
         wc5ZzTlEI/vOnowknkF6zPAUqrocTuJk79n272SUWCvDDfFA2B4g91lYg7e/CCm04G
         NqHnMAVmvWvUSrrWip4vAtPpiC/5wmxWTONRAIBtMaQoKK2v9fr7GKcdC894hMWaya
         J1EOqwsWnPPbQ==
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
Subject: [PATCH 18/89] KVM: arm64: Factor out private range VA allocation
Date:   Thu, 19 May 2022 14:40:53 +0100
Message-Id: <20220519134204.5379-19-will@kernel.org>
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

__pkvm_create_private_mapping() is currently responsible for allocating
VA space in the hypervisor's "private" range and creating stage-1
mappings. In order to allow reusing the VA space allocation logic from
other places, let's factor it out in a standalone function.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mm.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 168e7fbe9a3c..4377b067dc0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,6 +37,22 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
+static unsigned long hyp_alloc_private_va_range(size_t size)
+{
+	unsigned long addr = __io_map_base;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+	__io_map_base += PAGE_ALIGN(size);
+
+	/* Are we overflowing on the vmemmap ? */
+	if (__io_map_base > __hyp_vmemmap) {
+		__io_map_base = addr;
+		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	}
+
+	return addr;
+}
+
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot)
 {
@@ -45,16 +61,10 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
-
-	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
-		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	size = size + offset_in_page(phys);
+	addr = hyp_alloc_private_va_range(size);
+	if (IS_ERR((void *)addr))
 		goto out;
-	}
 
 	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
 	if (err) {
-- 
2.36.1.124.g0e6072fb45-goog

