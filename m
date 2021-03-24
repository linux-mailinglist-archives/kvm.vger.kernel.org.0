Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D37347F0B
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhCXROb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:14:31 -0400
Received: from foss.arm.com ([217.140.110.172]:36886 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236702AbhCXROQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:14:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FFFC106F;
        Wed, 24 Mar 2021 10:14:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49A363F7D7;
        Wed, 24 Mar 2021 10:14:15 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 1/3] arm/arm64: Avoid wildcard in the arm_clean recipe of the Makefile
Date:   Wed, 24 Mar 2021 17:14:00 +0000
Message-Id: <20210324171402.371744-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324171402.371744-1-nikos.nikoleris@arm.com>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds recipes to discover the generated .o and .d files and
removes assumptions about their locations in the arm_clean recipe.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/Makefile.common | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index a123e85..19db50d 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -78,9 +78,12 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
 $(libeabi): $(eabiobjs)
 	$(AR) rcs $@ $^
 
+generated-o = $(cflatobjs) $(eabiobjs) $(cstart.o) $(tests-all:.flat=.o)
+generated-d = $(join $(dir $(generated-o)), $(addprefix ., $(notdir $(generated-o:.o=.d))))
+
 arm_clean: libfdt_clean asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
-	      $(TEST_DIR)/.*.d lib/arm/.*.d
+	$(RM) $(generated-d)
+	$(RM) $(generated-o) $(tests-all:.flat=.elf) $(tests-all) $(libeabi)
 
 generated-files = $(asm-offsets)
 $(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
-- 
2.25.1

