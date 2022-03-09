Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDDC4D34BB
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 17:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiCIQ0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbiCIQVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:21:53 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C31B3A5
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:20:55 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09B8B1691;
        Wed,  9 Mar 2022 08:20:55 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C0933F7F5;
        Wed,  9 Mar 2022 08:20:53 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] arm/run: Fix using qemu-system-aarch64 to run aarch32 tests on aarch64
Date:   Wed,  9 Mar 2022 16:21:17 +0000
Message-Id: <20220309162117.56681-3-alexandru.elisei@arm.com>
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

From: Andrew Jones <drjones@redhat.com>

KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
take advantage of this by setting the aarch64=off -cpu option. However,
get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
This leads to an error in premature_failure() and the test is marked as
skipped:

$ ./run_tests.sh selftest-setup
SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)

Fix this by setting QEMU to the correct qemu binary before calling
get_qemu_accelerator().

Signed-off-by: Andrew Jones <drjones@redhat.com>
[ Alex E: Added commit message, changed the logic to make it clearer ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/run b/arm/run
index 2153bd320751..5fe0a45c4820 100755
--- a/arm/run
+++ b/arm/run
@@ -13,6 +13,11 @@ processor="$PROCESSOR"
 ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
+# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
+if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
+	QEMU=qemu-system-aarch64
+fi
+
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-- 
2.35.1

