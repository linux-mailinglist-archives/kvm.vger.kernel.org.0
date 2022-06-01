Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F6153AB53
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349558AbiFAQwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344305AbiFAQww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:52:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED0A3340E2
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:52:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC6951515;
        Wed,  1 Jun 2022 09:52:48 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 188273F66F;
        Wed,  1 Jun 2022 09:52:47 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool 4/4] x86/cpuid: fix undefined behaviour
Date:   Wed,  1 Jun 2022 17:51:38 +0100
Message-Id: <20220601165138.3135246-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601165138.3135246-1-andre.przywara@arm.com>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
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

Shifting signed values is rarely a good idea, especially if the result
ends up setting the most significant bit. UBSAN warns about two
occasions in the CPUID filter code:
===========================
x86/cpuid.c:23:25: runtime error: left shift of 255 by 24 places cannot be represented in type 'int'
x86/cpuid.c:27:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
===========================

Fix those warnings by making sure we only deal with unsigned values.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index f4347a84..1ae681ce 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -8,7 +8,7 @@
 
 #define	MAX_KVM_CPUID_ENTRIES		100
 
-static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
+static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, unsigned int cpu_id)
 {
 	unsigned int i;
 
@@ -20,11 +20,11 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 
 		switch (entry->function) {
 		case 1:
-			entry->ebx &= ~(0xff << 24);
+			entry->ebx &= ~(0xffU << 24);
 			entry->ebx |= cpu_id << 24;
 			/* Set X86_FEATURE_HYPERVISOR */
 			if (entry->index == 0)
-				entry->ecx |= (1 << 31);
+				entry->ecx |= (1U << 31);
 			break;
 		case 6:
 			/* Clear X86_FEATURE_EPB */
-- 
2.25.1

