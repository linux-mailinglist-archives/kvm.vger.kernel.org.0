Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D3C5F64F3
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiJFLLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiJFLLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:11:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FDC7F020
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:11:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA75E1BF7;
        Thu,  6 Oct 2022 04:11:56 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 740023F73B;
        Thu,  6 Oct 2022 04:11:49 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 0/3] arm/arm64: mmu cleanups and fixes
Date:   Thu,  6 Oct 2022 12:12:38 +0100
Message-Id: <20221006111241.15083-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was writing a quick test when I noticed that arm's implementation of
__virt_to_phys(), which ends up calling virt_to_pte_phys(), doesn't handle
block mappings and returns a bogus value.

When fixing that, I realized that lib/vmalloc confuses the return value for
virt_to_pte_phys(), which is harmless, but still wrong.

I also got confused about mmu_get_pte() and get_pte(), so I (hopefully)
improved that by renaming mmu_get_pte() to follow_pte().

Tested on rockpro64: arm64, 4k and 64k pages, with qemu and kvmtool; arm,
with qemu and kvmtool. And on an odroid-c4: arm64, 4k, 16k and 64k pages
with qemu and kvmtool; arm, with qemu and kvmtool.

Alexandru Elisei (3):
  lib/vmalloc: Treat virt_to_pte_phys() as returning a physical address
  arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
  arm/arm64: mmu: Rename mmu_get_pte() -> follow_pte()

 lib/arm/asm/mmu-api.h |  2 +-
 lib/arm/mmu.c         | 88 +++++++++++++++++++++++++------------------
 lib/vmalloc.c         |  4 +-
 3 files changed, 55 insertions(+), 39 deletions(-)

-- 
2.37.0

