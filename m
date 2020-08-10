Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30DF240666
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHJNGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:46 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47978 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726815AbgHJNGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:44 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DE1FB4C88C;
        Mon, 10 Aug 2020 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064801; x=1598879202; bh=3+BnVU1emfZqWuACNhhvRbzAKUlk9OStoLf
        NwfeYqvI=; b=HgmJ97yyIc9BRyHp9k3Gu5sQPduo14UGhAofW0AeS+64V3WUE8O
        GZD7QmNoJAK8OC4GUI7j4muVdlIhD8PJsIHE6NbovhvRSBpAnQXRHjURUWG2PGDf
        KgrpUgPByV2aUogMjD50XSBodcMhtIwR2Q9gDyTqfFIKLq+qLkahh24g=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WT3lccldD8ed; Mon, 10 Aug 2020 16:06:41 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5AF4A4C8B2;
        Mon, 10 Aug 2020 16:06:37 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:37 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 7/7] README: Update build instructions for macOS
Date:   Mon, 10 Aug 2020 16:06:18 +0300
Message-ID: <20200810130618.16066-8-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200810130618.16066-1-r.bolshakov@yadro.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-built cross-compilers for x86 are available in homebrew and can be
used to build the tests.

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 README.macOS.md | 71 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 20 deletions(-)

diff --git a/README.macOS.md b/README.macOS.md
index de46d5f..4ca5a57 100644
--- a/README.macOS.md
+++ b/README.macOS.md
@@ -1,14 +1,54 @@
 # kvm-unit-tests on macOS
 
-Cross-compiler with ELF support is required for build of kvm-unit-tests on
-macOS.
+The tests can be used to validate TCG or HVF accel on macOS.
 
-## Building cross-compiler from source
+## Prerequisites
 
-A cross-compiler toolchain can be built from source using crosstool-ng. The
-latest released version of
+GNU getopt and coreutils should be installed prior to building and running the
+tests. They're available in [homebrew](https://brew.sh):
+```
+$ brew install coreutils
+$ brew install gnu-getopt
+```
+
+A cross-compiler with ELF support is required to build kvm-unit-tests on macOS.
+
+### Pre-built cross-compiler
+
+Binary packages of ELF cross-compilers for i386 and x86_64 target can be
+installed from homebrew:
+```
+$ brew install i686-elf-gcc
+$ brew install x86_64-elf-gcc
+```
+
+32-bit x86 tests can be built like that:
+```
+$ ./configure \
+  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
+  --arch=i386 \
+  --cross-prefix=i686-elf-
+$ make -j $(nproc)
+```
+
+64-bit x86 tests can be built likewise:
+```
+$ ./configure \
+  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
+  --arch=x86_64 \
+  --cross-prefix=x86_64-elf-
+$ make -j $(nproc)
+```
+
+Out-of-tree build can be used to make tests for both architectures
+simultaneously in separate build directories.
+
+### Building cross-compiler from source
+
+An alternative is to build cross-compiler toolchain from source using
+crosstool-ng. The latest released version of
 [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng) can be installed
-using [homebrew](https://brew.sh)
+using homebrew:
 ```
 $ brew install crosstool-ng
 ```
@@ -30,18 +70,9 @@ $ ct-ng -C $X_BUILD_DIR build CT_PREFIX=$X_INSTALL_DIR
 
 Once compiled, the cross-compiler can be used to build the tests:
 ```
-$ ./configure --cross-prefix=$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-
-$ make
-```
-
-## Pre-built cross-compiler
-
-x86_64-elf-gcc package in Homebrew provides pre-built cross-compiler but it
-fails to compile kvm-unit-tests.
-
-## Running the tests
-
-GNU coreutils should be installed prior to running the tests: 
-```
-$ brew install coreutils
+$ ./configure \
+  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
+  --arch=x86_64 \
+  --cross-prefix=$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-
+$ make -j $(nproc)
 ```
-- 
2.26.1

