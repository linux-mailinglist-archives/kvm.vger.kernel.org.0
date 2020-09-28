Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36C527B3A3
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgI1Ru0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbgI1Ru0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:26 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=l9HYw2Bbon6wcPzRXVYSoU9Z3H0BBZQjJDN+mJGq7kc=;
        b=ExHH5/B4sLzCcTXNuOU7kX3t5NRiqJgdX9hA1XAa7Yj8JDX8rvQkG02PhjmD6qPfF1GwA0
        mnvb8n06EpZeA+f55Znkz8pFef+0JGgFTq6suDS0hIpjbmP/cVMJcpMa07aPJ5yKjR/P2H
        vHjXmCLnXZ1ELQB/g/V6SpVjrKRipXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-91Q1usWpPPeCpCaJ7YjEmA-1; Mon, 28 Sep 2020 13:50:20 -0400
X-MC-Unique: 91Q1usWpPPeCpCaJ7YjEmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF4688014D8;
        Mon, 28 Sep 2020 17:50:19 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4523100238C;
        Mon, 28 Sep 2020 17:50:18 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 09/11] s390x: add Protected VM support
Date:   Mon, 28 Sep 2020 19:49:56 +0200
Message-Id: <20200928174958.26690-10-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200923134758.19354-5-mhartmay@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[thuth: Drop the verbose "SKIP ... (no host-key document specified)" output]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure               |  9 +++++++++
 s390x/Makefile          | 15 ++++++++++++++-
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

diff --git a/configure b/configure
index 39b63ae..706aab5 100755
--- a/configure
+++ b/configure
@@ -24,6 +24,7 @@ wa_divide=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
+host_key_document=
 
 usage() {
     cat <<-EOF
@@ -46,6 +47,9 @@ usage() {
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
 	                           '--erratatxt=' to ensure no file is used.
+	    --host-key-document=HOST_KEY_DOCUMENT
+	                           Specify the machine-specific host-key document for creating
+	                           a PVM image with 'genprotimg' (s390x only)
 EOF
     exit 1
 }
@@ -98,6 +102,9 @@ while [[ "$1" = -* ]]; do
 	    erratatxt=
 	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
 	    ;;
+	--host-key-document)
+	    host_key_document="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -229,6 +236,8 @@ ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
+GENPROTIMG=${GENPROTIMG-genprotimg}
+HOST_KEY_DOCUMENT=$host_key_document
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/s390x/Makefile b/s390x/Makefile
index c2213ad..b079a26 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -19,12 +19,19 @@ tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
+
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
+ifneq ($(HOST_KEY_DOCUMENT),)
+tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
+else
+tests_pv_binary =
+endif
 
-all: directories test_cases test_cases_binary
+all: directories test_cases test_cases_binary test_cases_pv
 
 test_cases: $(tests)
 test_cases_binary: $(tests_binary)
+test_cases_pv: $(tests_pv_binary)
 
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
@@ -73,6 +80,12 @@ FLATLIBS = $(libcflat)
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
+
+%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
+
 arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
 
diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
new file mode 100644
index 0000000..5613931
--- /dev/null
+++ b/s390x/selftest.parmfile
@@ -0,0 +1 @@
+test 123
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 6d50c63..3feb8bc 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -21,6 +21,7 @@
 [selftest-setup]
 file = selftest.elf
 groups = selftest
+# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
 [intercept]
diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
new file mode 100644
index 0000000..b391208
--- /dev/null
+++ b/scripts/s390x/func.bash
@@ -0,0 +1,35 @@
+# The file scripts/common.bash has to be the only file sourcing this
+# arch helper file
+source config.mak
+
+ARCH_CMD=arch_cmd_s390x
+
+function arch_cmd_s390x()
+{
+	local cmd=$1
+	local testname=$2
+	local groups=$3
+	local smp=$4
+	local kernel=$5
+	local opts=$6
+	local arch=$7
+	local check=$8
+	local accel=$9
+	local timeout=${10}
+
+	# run the normal test case
+	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+
+	# run PV test case
+	kernel=${kernel%.elf}.pv.bin
+	testname=${testname}_PV
+	if [ ! -f "${kernel}" ]; then
+		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
+			return 2
+		fi
+
+		print_result 'SKIP' $testname '' 'PVM image was not created'
+		return 2
+	fi
+	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+}
-- 
2.18.2

