Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751514B9D1F
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 11:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiBQK2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 05:28:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBQK2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 05:28:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FFAC91356
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 02:28:18 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C3B3D6E;
        Thu, 17 Feb 2022 02:28:18 -0800 (PST)
Received: from Q2TWYV475D.emea.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DAE83F718;
        Thu, 17 Feb 2022 02:28:17 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Cc:     jade.alglave@arm.com, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH] configure: arm: Fixes to build and run tests on Apple Silicon
Date:   Thu, 17 Feb 2022 10:28:06 +0000
Message-Id: <20220217102806.28749-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
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

On MacOS:

$> uname -m

returns:

arm64

To unify how we handle the achitecture detection across different
systems, sed it to aarch64 which is what's typically reported on
Linux.

In addition, when HVF is the acceleration method on aarch64, make sure
we select the right processor when invoking qemu.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/run   | 3 +++
 configure | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 2153bd3..0629b69 100755
--- a/arm/run
+++ b/arm/run
@@ -27,6 +27,9 @@ if [ "$ACCEL" = "kvm" ]; then
 	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
 		M+=',gic-version=host'
 	fi
+fi
+
+if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
 	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
 		processor="host"
 		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
diff --git a/configure b/configure
index 2d9c3e0..ff840c1 100755
--- a/configure
+++ b/configure
@@ -14,7 +14,7 @@ objcopy=objcopy
 objdump=objdump
 ar=ar
 addr2line=addr2line
-arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
+arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
 host=$arch
 cross_prefix=
 endian=""
-- 
2.32.0 (Apple Git-132)

