Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08ECE726953
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjFGS7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjFGS7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:59:14 -0400
Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3784C1BF0
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:59:12 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686164350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kXcUsr/5wRJ9hTwACI2tN3o6lvHyW3B8pfUxohWgjWU=;
        b=CK9LU4HYoKd2rL4vxoP39KUduVeZuXnIJXKFg1Rf/tVXsLBttas2G0Ek9jP5QpbF6otxA1
        wcO2eW8Iopc6+m1qDEIeDnrodNkUpno7rZRm/QwyjODo+0v+8iaNFQazcf27YzhOl+QXLj
        nzrTjlByXjfuYH6/PEiiSEXjk6rIIpA=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 3/3] configure: efi: Link correct run script
Date:   Wed,  7 Jun 2023 20:59:05 +0200
Message-Id: <20230607185905.32810-4-andrew.jones@linux.dev>
In-Reply-To: <20230607185905.32810-1-andrew.jones@linux.dev>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI built tests use $TEST_DIR/efi/run, not $TEST_DIR/run.
Also, now that we may be using the link, rather than the
script directly, make sure we use an absolute path to the
EFI source rather than assuming it's the parent directory.
TEST_DIR already points there, so we can just use that.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 2 +-
 configure   | 5 ++++-
 x86/efi/run | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index f75ef157acf3..6872c337c945 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -21,7 +21,7 @@ elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
 	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
 fi
 
-: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
+: "${EFI_SRC:=$TEST_DIR}"
 : "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
diff --git a/configure b/configure
index b665f7d586c2..6ee9b27a6af2 100755
--- a/configure
+++ b/configure
@@ -313,7 +313,10 @@ if [ ! -d "$srcdir/$testdir" ]; then
     echo "$testdir does not exist!"
     exit 1
 fi
-if [ -f "$srcdir/$testdir/run" ]; then
+
+if [ "$efi" = "y" ] && [ -f "$srcdir/$testdir/efi/run" ]; then
+    ln -fs "$srcdir/$testdir/efi/run" $testdir-run
+elif [ -f "$srcdir/$testdir/run" ]; then
     ln -fs "$srcdir/$testdir/run" $testdir-run
 fi
 
diff --git a/x86/efi/run b/x86/efi/run
index 322cb7567fdc..85aeb94fe605 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -13,7 +13,7 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 
-: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
+: "${EFI_SRC:=$TEST_DIR}"
 : "${EFI_UEFI:=/usr/share/ovmf/OVMF.fd}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_SMP:=1}"
-- 
2.40.1

