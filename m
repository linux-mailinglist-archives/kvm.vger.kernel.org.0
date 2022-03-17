Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA984DCBD5
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 17:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiCQQ5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 12:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbiCQQ5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 12:57:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78D6C19E39E
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 09:55:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B161682;
        Thu, 17 Mar 2022 09:55:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 797993F7B4;
        Thu, 17 Mar 2022 09:55:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on arm64 systems
Date:   Thu, 17 Mar 2022 16:56:01 +0000
Message-Id: <20220317165601.356466-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
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

From: Andrew Jones <drjones@redhat.com>

If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
be run by using the TCG accelerator. In this case use TCG instead of KVM.

Signed-off-by: Andrew Jones <drjones@redhat.com>
[ Alex E: Added commit message ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index 28a0b4ad2729..128489125dcb 100755
--- a/arm/run
+++ b/arm/run
@@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-ACCEL=$(get_qemu_accelerator) ||
+accel=$(get_qemu_accelerator) ||
 	exit $?
 
-if [ "$ACCEL" = "kvm" ]; then
+if [ "$accel" = "kvm" ]; then
 	QEMU_ARCH=$HOST
 fi
 
 qemu=$(search_qemu_binary) ||
 	exit $?
 
+if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+	accel=tcg
+fi
+
+ACCEL=$accel
+
 if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
-- 
2.35.1

