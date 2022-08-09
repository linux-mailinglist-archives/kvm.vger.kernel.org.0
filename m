Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0FE58D62B
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiHIJQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiHIJPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EC982182B
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA09C143D;
        Tue,  9 Aug 2022 02:15:37 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2FF3F67D;
        Tue,  9 Aug 2022 02:15:35 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end parameter as unused in setup_mmu()
Date:   Tue,  9 Aug 2022 10:15:46 +0100
Message-Id: <20220809091558.14379-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
room for the vmalloc area to grown down. This was made useless in commit
c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
setup_mmu() was changed to map all the detected memory regions without
changing their limits.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe4941f..8f936acafe8b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	}
 }
 
-void *setup_mmu(phys_addr_t phys_end, void *unused)
+void *setup_mmu(phys_addr_t unused0, void *unused1)
 {
 	struct mem_region *r;
 
-	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
-	if (phys_end > (3ul << 30))
-		phys_end = 3ul << 30;
-
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
 
-- 
2.37.1

