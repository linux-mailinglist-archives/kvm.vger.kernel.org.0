Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133364D34B8
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 17:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiCIQ0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbiCIQVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:21:52 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF2283A5
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:20:53 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD673168F;
        Wed,  9 Mar 2022 08:20:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF9B33F7F5;
        Wed,  9 Mar 2022 08:20:52 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] arm: Change text base address for 32 bit tests when running under kvmtool
Date:   Wed,  9 Mar 2022 16:21:16 +0000
Message-Id: <20220309162117.56681-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309162117.56681-1-alexandru.elisei@arm.com>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 32 bit tests do not have relocation support and rely on the build
system to set the text base address to 0x4001_0000, which is the memory
location where the test is placed by qemu. However, kvmtool loads a payload
at a different address, 0x8000_8000, when loading a test with --kernel.
When using --firmware, the default is 0x8000_0000, but that can be changed
with the --firmware-address comand line option.

When 32 bit tests are configured to run under kvmtool, set the text base
address to 0x8000_8000.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/Makefile.arm | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 3a4cc6b26234..01fd4c7bb6e2 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -14,7 +14,13 @@ CFLAGS += $(machine)
 CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
 
+ifeq ($(TARGET),qemu)
 arch_LDFLAGS = -Ttext=40010000
+else ifeq ($(TARGET),kvmtool)
+arch_LDFLAGS = -Ttext=80008000
+else
+$(error Unknown target $(TARGET))
+endif
 
 define arch_elf_check =
 endef
-- 
2.35.1

