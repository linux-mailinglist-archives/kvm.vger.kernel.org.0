Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99044240667
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgHJNGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:49 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48018 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgHJNGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 48BBA4C891;
        Mon, 10 Aug 2020 13:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064800; x=1598879201; bh=5i+oOdei6MHmdYzVHJtxN+8Vf4HkfKSmai7
        ip5ROpe4=; b=LnLD5PwzdE6H7FjBmx2/rS/6EJY6kpq3ZINcCV2hQ/51BJm30LF
        csLuHU+pqtzft/3zz++YOMHul25mGiiiqbB3YePX32R0cL9F+btI+3ANPN5Bglfo
        abCeLgl1J6nHBLML6pVbTBP2TMSy8ACHij9ocGKrfyRUgh6x6qOxgbto=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iqzpZI9aUKG7; Mon, 10 Aug 2020 16:06:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CBE8B4C88C;
        Mon, 10 Aug 2020 16:06:36 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:36 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 6/7] configure: Add an option to specify getopt
Date:   Mon, 10 Aug 2020 16:06:17 +0300
Message-ID: <20200810130618.16066-7-r.bolshakov@yadro.com>
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

macOS is shipped with an old non-enhanced version of getopt and it
doesn't support options used by run_tests.sh. Proper version of getopt
is available from homebrew but it has to be added to PATH before invoking
run_tests.sh. It's not convenient because it has to be done in each
shell instance and there could be many if a multiplexor is used.

The change provides a way to override getopt and halts ./configure if
enhanced getopt can't be found.

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 configure    | 13 +++++++++++++
 run_tests.sh |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index f9d030f..556ff13 100755
--- a/configure
+++ b/configure
@@ -8,6 +8,7 @@ objcopy=objcopy
 objdump=objdump
 ar=ar
 addr2line=addr2line
+getopt=getopt
 arch=`uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/'`
 host=$arch
 cross_prefix=
@@ -31,6 +32,7 @@ usage() {
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC		   c compiler to use ($cc)
 	    --ld=LD		   ld linker to use ($ld)
+	    --getopt=GETOPT	   enhanced getopt to use ($getopt)
 	    --prefix=PREFIX        where to install things ($prefix)
 	    --endian=ENDIAN        endianness to compile for (little or big, ppc64 only)
 	    --[enable|disable]-pretty-print-stacks
@@ -76,6 +78,9 @@ while [[ "$1" = -* ]]; do
 	--ld)
 	    ld="$arg"
 	    ;;
+	--getopt)
+	    getopt="$arg"
+	    ;;
 	--enable-pretty-print-stacks)
 	    pretty_print_stacks=yes
 	    ;;
@@ -156,6 +161,13 @@ EOF
 u32_long=$("$cross_prefix$cc" -E lib-test.c | grep -v '^#' | grep -q long && echo yes)
 rm -f lib-test.c
 
+# require enhanced getopt
+$getopt -T > /dev/null
+if [ $? -ne 4 ]; then
+    echo "Enchanced getopt is not available"
+    exit 1
+fi
+
 # Are we in a separate build tree? If so, link the Makefile
 # and shared stuff so that 'make' and run_tests.sh work.
 if test ! -e Makefile; then
@@ -198,6 +210,7 @@ OBJCOPY=$cross_prefix$objcopy
 OBJDUMP=$cross_prefix$objdump
 AR=$cross_prefix$ar
 ADDR2LINE=$cross_prefix$addr2line
+GETOPT=$getopt
 TEST_DIR=$testdir
 FIRMWARE=$firmware
 ENDIAN=$endian
diff --git a/run_tests.sh b/run_tests.sh
index 01e36dc..c4f436b 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -35,7 +35,7 @@ RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
 only_tests=""
-args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
+args=`$GETOPT -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.26.1

