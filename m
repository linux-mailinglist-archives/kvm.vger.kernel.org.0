Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB85A347F0F
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbhCXROd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:14:33 -0400
Received: from foss.arm.com ([217.140.110.172]:36892 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236975AbhCXROR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:14:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D6A9113E;
        Wed, 24 Mar 2021 10:14:17 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 548123F7D7;
        Wed, 24 Mar 2021 10:14:16 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 2/3] arm/arm64: Add a way to specify an external directory with tests
Date:   Wed, 24 Mar 2021 17:14:01 +0000
Message-Id: <20210324171402.371744-3-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324171402.371744-1-nikos.nikoleris@arm.com>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds an argument to the configure script which allows a
user to specify an external directory with extra tests. When
specified, the build system will include the Makefile in that
directory allowing a user to add extra tests. For example:

For example, DIR contains a test in test.c which depends on symbols
defined in obj.c and the Makefile:

tests += $(EXT_DIR)/test.flat

cflatobjs += $(EXT_DIR)/obj.o

With this change, we can add DIR to the build process and generate the
test using

$> ./configure --ext-dir=DIR
$> make

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 configure           | 7 +++++++
 arm/Makefile.common | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/configure b/configure
index cdcd34e..e734b9d 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
+ext_dir=
 
 usage() {
     cat <<-EOF
@@ -54,6 +55,8 @@ usage() {
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
+	    --ext-dir=DIR	   specify an additional location with more tests; when enabled
+	                           DIR/Makefile is included to the build system (arm/arm64 only)
 EOF
     exit 1
 }
@@ -112,6 +115,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--ext-dir)
+	    ext_dir="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -264,6 +270,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+EXT_DIR=$ext_dir
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 19db50d..ffe1a49 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -13,6 +13,10 @@ tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
 
+ifdef EXT_DIR
+include $(EXT_DIR)/Makefile
+endif
+
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
 
-- 
2.25.1

