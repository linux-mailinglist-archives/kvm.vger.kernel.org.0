Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE65324859F
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 15:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHRNFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 09:05:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgHRNE5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 09:04:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ID3sE5039579;
        Tue, 18 Aug 2020 09:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/O6n2CD7R+9ihKDnPfesZemIaMx5C15gqSzpS70EZkU=;
 b=o4fKJEV7PXD81lHqy4KfgKmpaGGfyaBdbDRji3hFwLm+R71o2pQ0UX30OfGsnLzA/ukv
 kfvfu882aHGFxZF1d3GNp5YGH7AV8xlzeF5fIFtFbmIpPLh7gJoIffuUZMc4gBhoN9eZ
 0HsPIBI4mi15fzQmy3AWGk9oXmUoQAd7kwiGPm2cf/maR8NbWg4ziRpYuikS5Zgky9y2
 ebG+eQilno5GCMMPZpo8QnS0EaiqoBjNjZUOL/yMdr0LMUht0fIsGyfAAYR8ATK+SwMJ
 GHHfZbLLVo0Yh43iBTILTDmnxyt91RKIcntR93a27X/D+uHbgljMpIrSiO+V9XmN6F1G uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r397q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:56 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ID4TXd042836;
        Tue, 18 Aug 2020 09:04:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r397p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:55 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ID02Tl016349;
        Tue, 18 Aug 2020 13:04:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3304bbrdew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 13:04:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ID4oCD28967198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 13:04:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53C054C046;
        Tue, 18 Aug 2020 13:04:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D86334C05A;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.52.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 13:04:49 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/4] s390x: add Protected VM support
Date:   Tue, 18 Aug 2020 15:04:24 +0200
Message-Id: <20200818130424.20522-5-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818130424.20522-1-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_09:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 configure               |  9 +++++++++
 s390x/Makefile          | 17 +++++++++++++++--
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+), 2 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

diff --git a/configure b/configure
index f9d030fd2f03..0e64af58b3c1 100755
--- a/configure
+++ b/configure
@@ -18,6 +18,7 @@ u32_long=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
+host_key_document=
 
 usage() {
     cat <<-EOF
@@ -40,6 +41,9 @@ usage() {
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
 	                           '--erratatxt=' to ensure no file is used.
+	    --host-key-document=HOST_KEY_DOCUMENT
+	                           Specify the machine-specific host-key document for creating
+	                           a PVM image with 'genprotimg' (s390x only)
 EOF
     exit 1
 }
@@ -92,6 +96,9 @@ while [[ "$1" = -* ]]; do
 	    erratatxt=
 	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
 	    ;;
+	--host-key-document)
+	    host_key_document="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -205,6 +212,8 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
 ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
+GENPROTIMG=${GENPROTIMG-genprotimg}
+HOST_KEY_DOCUMENT=$host_key_document
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/s390x/Makefile b/s390x/Makefile
index 0f54bf43bfb7..cd4e270952ec 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -18,12 +18,19 @@ tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
-tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
-all: directories test_cases test_cases_binary
+tests_binary = $(patsubst %.elf,%.bin,$(tests))
+ifneq ($(HOST_KEY_DOCUMENT),)
+tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
+else
+tests_pv_binary =
+endif
+
+all: directories test_cases test_cases_binary test_cases_pv
 
 test_cases: $(tests)
 test_cases_binary: $(tests_binary)
+test_cases_pv: $(tests_pv_binary)
 
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
@@ -72,6 +79,12 @@ FLATLIBS = $(libcflat)
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
index 000000000000..5613931aa5c6
--- /dev/null
+++ b/s390x/selftest.parmfile
@@ -0,0 +1 @@
+test 123
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 0f156afbe741..12f6fb613995 100644
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
index 000000000000..b2d59d0d6f25
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
+	"$cmd" "${testname}" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+
+	# run PV test case
+	kernel=${kernel%.elf}.pv.bin
+	if [ ! -f "${kernel}" ]; then
+		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
+			print_result 'SKIP' $testname '(no host-key document specified)'
+			return 2
+		fi
+
+		print_result 'SKIP' $testname '(PVM image was not created)'
+		return 2
+	fi
+	"$cmd" "${testname}_PV" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+}
-- 
2.25.4

