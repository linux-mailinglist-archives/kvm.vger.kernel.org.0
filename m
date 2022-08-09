Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278AD58D635
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbiHIJQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbiHIJPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D71F122BEC
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46ABA23A;
        Tue,  9 Aug 2022 02:15:46 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 654393F67D;
        Tue,  9 Aug 2022 02:15:44 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing libcflat.h include
Date:   Tue,  9 Aug 2022 10:15:52 +0100
Message-Id: <20220809091558.14379-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include libcflat from page.h to avoid error like this one:

/path/to/kvm-unit-tests/lib/asm/page.h:19:9: error: unknown type name ‘u64’
   19 | typedef u64 pteval_t;
      |         ^~~
[..]
/path/to/kvm-unit-tests/lib/asm/page.h:47:8: error: unknown type name ‘phys_addr_t’
   47 | extern phys_addr_t __virt_to_phys(unsigned long addr);
      |        ^~~~~~~~~~~
      |                                     ^~~~~~~~~~~
[..]
/path/to/kvm-unit-tests/lib/asm/page.h:50:47: error: unknown type name ‘size_t’
   50 | extern void *__ioremap(phys_addr_t phys_addr, size_t size);

The arm64 version of the header already includes libcflat since commit
a2d06852fe59 ("arm64: Add support for configuring the translation
granule").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/page.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
index 8eb4a883808e..0a46bda018c7 100644
--- a/lib/arm/asm/page.h
+++ b/lib/arm/asm/page.h
@@ -8,6 +8,8 @@
 
 #include <linux/const.h>
 
+#include <libcflat.h>
+
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
-- 
2.37.1

