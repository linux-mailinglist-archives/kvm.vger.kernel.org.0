Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1200810CE3C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfK1SEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:34 -0500
Received: from foss.arm.com ([217.140.110.172]:39312 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfK1SEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E44B1042;
        Thu, 28 Nov 2019 10:04:33 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 18D453F6C4;
        Thu, 28 Nov 2019 10:04:31 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 02/18] lib: arm64: Remove barriers before TLB operations
Date:   Thu, 28 Nov 2019 18:04:02 +0000
Message-Id: <20191128180418.6938-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
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

