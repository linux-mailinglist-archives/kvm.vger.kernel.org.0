Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3C10B130
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfK0OZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:09 -0500
Received: from foss.arm.com ([217.140.110.172]:48188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfK0OZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B52A831B;
        Wed, 27 Nov 2019 06:25:07 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FB303F68E;
        Wed, 27 Nov 2019 06:25:06 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 02/18] lib: arm64: Remove barriers before TLB operations
Date:   Wed, 27 Nov 2019 14:23:54 +0000
Message-Id: <20191127142410.1994-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When changing a translation table entry, we already use all the necessary
barriers. Remove them from the flush_tlb_{page,all} functions.

We don't touch the arm versions of the TLB operations because they had no
barriers before the TLBIs to begin with.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/mmu.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 72d75eafc882..5d6d49036a06 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -12,7 +12,6 @@
 
 static inline void flush_tlb_all(void)
 {
-	dsb(ishst);
 	asm("tlbi	vmalle1is");
 	dsb(ish);
 	isb();
@@ -21,7 +20,6 @@ static inline void flush_tlb_all(void)
 static inline void flush_tlb_page(unsigned long vaddr)
 {
 	unsigned long page = vaddr >> 12;
-	dsb(ishst);
 	asm("tlbi	vaae1is, %0" :: "r" (page));
 	dsb(ish);
 	isb();
-- 
2.20.1

