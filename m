Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18109637CF6
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKXP21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKXP2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:28:25 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24257C2858
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:28:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3572723A;
        Thu, 24 Nov 2022 07:28:31 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEA5B3F73B;
        Thu, 24 Nov 2022 07:28:23 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 0/2] arm/arm64: teach virt_to_pte_phys() about block descriptors
Date:   Thu, 24 Nov 2022 15:28:14 +0000
Message-Id: <20221124152816.22305-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was writing a quick test when I noticed that arm's implementation of
__virt_to_phys(), which ends up calling virt_to_pte_phys(), doesn't handle
block mappings and returns a bogus value. When fixing it I got confused
about mmu_get_pte() and get_pte(), so I (hopefully) improved things by
renaming mmu_get_pte() to follow_pte().

Changes since v1:

- Dropped patch #1 ("lib/vmalloc: Treat virt_to_pte_phys() as returning a
  physical address") because it was incorrect.
- Dropped the check for pte_valid() for the return value of mmu_get_pte() in
  patch #1 because mmu_get_pte() returns NULL for an invalid descriptor.

Lightly tested on a rockpro64 (4k and 64k pages, arm64 and arm, qemu only)
because the changes from the previous version are trivial.

Alexandru Elisei (2):
  arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
  arm/arm64: mmu: Rename mmu_get_pte() -> follow_pte()

 lib/arm/asm/mmu-api.h |  2 +-
 lib/arm/mmu.c         | 88 +++++++++++++++++++++++++------------------
 2 files changed, 53 insertions(+), 37 deletions(-)

-- 
2.37.0

