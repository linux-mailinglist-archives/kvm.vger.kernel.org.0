Return-Path: <kvm+bounces-13653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 620F88997FB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD91B1F21B48
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F056B15FA73;
	Fri,  5 Apr 2024 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wmd9OBB3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552F215FCE5
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306202; cv=none; b=a/qR3I6nUVlubXEhjIscMvAwK5kshAmfpeMepPvNl+KM1UpywhsETdz6j0R+zBNeCDHXnJKr31Eudrt3/ImPkvNuD9UJ5LVAMJ0db/7OlmMLkRNFyvCd64uOa3khrb7bsBA7pe+LzHILXmOUlQxGIH4aqR05LrvF8gOcmiwnsMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306202; c=relaxed/simple;
	bh=lt9Zksk1vAOKjIaQk17fMFqQA4SgWsNEIqoUtKDRdSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCqc+I8m4QGsgma+1dy5UAhBaeKg1qjDc8Fu7jMu7Bjc5+mIsvsR1eNFqnVrnZWIluQ3VDIl1uV/H05cDn45SKaZBMLwDyN2mX8NIELXipsdSl3vMpmxbz1j34h9/6OhtivQcoUS+EGLPhZiq1n9ISpKUW+uCEZ064kd9au3rsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wmd9OBB3; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5a4f9f94e77so1062619eaf.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306199; x=1712910999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6L3mP48IsUDDp5GHT4hPb4TjswdvN0rLft4Daqo8RQ=;
        b=Wmd9OBB3EovId3Cxx+vUs/1j8VqeGQdnH3x9WgDE3Pu73rdhKlOgO4fygkBGFN76b5
         1GodWO0kViOPukvVi2AgN5kLICzJvXTVFMXKeCvW1TNg7gQKUhzhzIajaNiHMVtXadrq
         Gu/4vdENu5izFvErLwLxqUh9D9a4S8CNbFrpupPTTOakpb24FvJ2rajSwm1AQO9D1wYT
         j0GEo1Q+YEW4ZEQr966MtwWQ5WxfPj0CXvS3+jJHQoRj/dau8GIMX2j1zX0j+8jQGNps
         yNTNx1s/Y/XBNX5Ng3EzzKO5yYTB/EjBdkX85wD/xCntLzDCxhfXqtKrlb64zrT5gYnk
         Io7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306199; x=1712910999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6L3mP48IsUDDp5GHT4hPb4TjswdvN0rLft4Daqo8RQ=;
        b=CK5+RZe6JEjxWkzfJj6Zgx4q8HBHRjt8jR9gxOHiNNPoaNqKTcQ/afb69RveDgnzIW
         auUfR+E4iHVrkZEQOG3vc43Mhpn1YR8FZ92PvcyyxkmbzvyjRo22U2O2g/cwY56kTKJw
         hK1vlHJoa4C7OFuDQ6XnOA408MZozqcWa+3sR58vTL+H57UGslZxqfnviu6Q/JphmG+5
         5Xi8FG0OS+bd18Qxrz5Kf97nMlKkqGiqPzt8RpSWjpqM8mkfX7LEH9Gd8iKKHbMc0mWN
         jZcSoX621c1RSjcqP2SYnsDzG0q5TwK96VK0IJwJIBZF7r04IM53gEkMqdOiPOTECwG5
         naLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeJSyFZ9wLZa3xcfwiUfA8pU4MwUHNxTqCGsQyvg+c44V/AraIXXFOeBdTmRRFv5CNV9QQnXpEiroySpEFIwVEdr1e
X-Gm-Message-State: AOJu0Yz9cGdN2OJvV/nIZsccjqZE/reRtK75GY/eA4uh+5s7vxqVl0I+
	RFYf+PNEtKDyfQzA3r0KBBj/lzW77WMcrtRx0QmViqo863QoHWRHSLpCLqJ7
X-Google-Smtp-Source: AGHT+IH7po3SAfDMqmHjbzAUfipp3UDO9dTc5iB0AVwVRPWt0QnCqIEQEeiB9i//C3iRw3a8ZWGX4Q==
X-Received: by 2002:a05:6358:ca8:b0:17f:8847:a4c6 with SMTP id o40-20020a0563580ca800b0017f8847a4c6mr1049547rwj.17.1712306199322;
        Fri, 05 Apr 2024 01:36:39 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:39 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 13/35] doc: start documentation directory with unittests.cfg doc
Date: Fri,  5 Apr 2024 18:35:14 +1000
Message-ID: <20240405083539.374995-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate unittests.cfg documentation in one place.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/unittests.cfg     | 26 ++-----------
 docs/unittests.txt    | 89 +++++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg | 25 ++----------
 riscv/unittests.cfg   | 26 ++-----------
 s390x/unittests.cfg   | 18 ++-------
 x86/unittests.cfg     | 26 ++-----------
 6 files changed, 107 insertions(+), 103 deletions(-)
 create mode 100644 docs/unittests.txt

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fe601cbb1..54cedea28 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -1,28 +1,10 @@
 ##############################################################################
 # unittest configuration
 #
-# [unittest_name]
-# file = <name>.flat		# Name of the flat file to be used.
-# smp  = <num>			# Number of processors the VM will use
-#				# during this test. Use $MAX_SMP to use
-#				# the maximum the host supports. Defaults
-#				# to one.
-# extra_params = -append <params...>	# Additional parameters used.
-# arch = arm|arm64			# Select one if the test case is
-#					# specific to only one.
-# groups = <group_name1> <group_name2> ...	# Used to identify test cases
-#						# with run_tests -g ...
-#						# Specify group_name=nodefault
-#						# to have test not run by
-#						# default
-# accel = kvm|tcg		# Optionally specify if test must run with
-#				# kvm or tcg. If not specified, then kvm will
-#				# be used when available.
-# timeout = <duration>		# Optionally specify a timeout.
-# check = <path>=<value> # check a file for a particular value before running
-#                        # a test. The check line can contain multiple files
-#                        # to check separated by a space but each check
-#                        # parameter needs to be of the form <path>=<value>
+# arm specifics:
+#
+# file = <name>.flat            # arm uses .flat files
+# arch = arm|arm64
 ##############################################################################
 
 #
diff --git a/docs/unittests.txt b/docs/unittests.txt
new file mode 100644
index 000000000..53e02077c
--- /dev/null
+++ b/docs/unittests.txt
@@ -0,0 +1,89 @@
+unittests
+*********
+
+run_tests.sh is driven by the <arch>/unittests.cfg file. That file defines
+test cases by specifying an executable (target image) under the <arch>/
+directory, and how to run it. This way, for example, a single file can
+provide multiple test cases by being run with different host configurations
+and/or different parameters passed to it.
+
+Detailed output from run_tests.sh unit tests are stored in files under
+the logs/ directory.
+
+unittests.cfg format
+====================
+
+# is the comment symbol, all following contents of the line is ignored.
+
+Each unit test is defined as with a [unit-test-name] line, followed by
+a set of parameters that control how the test case is run. The name is
+arbitrary and appears in the status reporting output.
+
+Parameters appear on their own lines under the test name, and have a
+param = value format.
+
+Available parameters
+====================
+Note! Some parameters like smp and extra_params modify how a test is run,
+while others like arch and accel restrict the configurations in which the
+test is run.
+
+file
+----
+file = <filename>
+
+This parameter is mandatory and specifies which binary under the <arch>/
+directory to run. Typically this is <name>.flat or <name>.elf, depending
+on the arch. The directory name is not included, only the file name.
+
+arch
+----
+For <arch>/ directories that support multiple architectures, this restricts
+the test to the specified arch. By default, the test will run on any
+architecture.
+
+smp
+---
+smp = <number>
+
+Optional, the number of processors created in the machine to run the test.
+Defaults to 1. $MAX_SMP can be used to specify the maximum supported.
+
+extra_params
+------------
+These are extra parameters supplied to the QEMU process. -append '...' can
+be used to pass arguments into the test case argv. Multiple parameters can
+be added, for example:
+
+extra_params = -m 256 -append 'smp=2'
+
+groups
+------
+groups = <group_name1> <group_name2> ...
+
+Used to group the test cases for the `run_tests.sh -g ...` run group
+option. Adding a test to the nodefault group will cause it to not be
+run by default.
+
+accel
+-----
+accel = kvm|tcg
+
+This restricts the test to the specified accelerator. By default, the
+test will run on either accelerator. (Note, the accelerator can be
+specified with ACCEL= environment variable, and defaults to KVM if
+available).
+
+timeout
+-------
+timeout = <duration>
+
+Optional timeout in seconds, after which the test will be killed and fail.
+
+check
+-----
+check = <path>=<<value>
+
+Check a file for a particular value before running a test. The check line
+can contain multiple files to check separated by a space, but each check
+parameter needs to be of the form <path>=<value>
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e65217c18..432c81d58 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -1,28 +1,9 @@
 ##############################################################################
 # unittest configuration
 #
-# [unittest_name]
-# file = <name>.flat		# Name of the flat file to be used.
-# smp  = <num>			# Number of processors the VM will use
-#				# during this test. Use $MAX_SMP to use
-#				# the maximum the host supports. Defaults
-#				# to one.
-# extra_params = -append <params...>	# Additional parameters used.
-# arch = ppc64				# Select one if the test case is
-#					# specific to only one.
-# groups = <group_name1> <group_name2> ...	# Used to identify test cases
-#						# with run_tests -g ...
-#						# Specify group_name=nodefault
-#						# to have test not run by
-#						# default
-# accel = kvm|tcg		# Optionally specify if test must run with
-#				# kvm or tcg. If not specified, then kvm will
-#				# be used when available.
-# timeout = <duration>		# Optionally specify a timeout.
-# check = <path>=<value> # check a file for a particular value before running
-#                        # a test. The check line can contain multiple files
-#                        # to check separated by a space but each check
-#                        # parameter needs to be of the form <path>=<value>
+# powerpc specifics:
+#
+# file = <name>.elf             # powerpc uses .elf files
 ##############################################################################
 
 #
diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
index 5a23bed9c..50c67e37f 100644
--- a/riscv/unittests.cfg
+++ b/riscv/unittests.cfg
@@ -1,28 +1,10 @@
 ##############################################################################
 # unittest configuration
 #
-# [unittest_name]
-# file = <name>.flat		# Name of the flat file to be used.
-# smp  = <num>			# Number of processors the VM will use
-#				# during this test. Use $MAX_SMP to use
-#				# the maximum the host supports. Defaults
-#				# to one.
-# extra_params = -append <params...>	# Additional parameters used.
-# arch = riscv32|riscv64		# Select one if the test case is
-#					# specific to only one.
-# groups = <group_name1> <group_name2> ...	# Used to identify test cases
-#						# with run_tests -g ...
-#						# Specify group_name=nodefault
-#						# to have test not run by
-#						# default
-# accel = kvm|tcg		# Optionally specify if test must run with
-#				# kvm or tcg. If not specified, then kvm will
-#				# be used when available.
-# timeout = <duration>		# Optionally specify a timeout.
-# check = <path>=<value> # check a file for a particular value before running
-#                        # a test. The check line can contain multiple files
-#                        # to check separated by a space but each check
-#                        # parameter needs to be of the form <path>=<value>
+# riscv specifics:
+#
+# file = <name>.flat            # riscv uses .flat files
+# arch = riscv32|risc64
 ##############################################################################
 
 [selftest]
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d7bdcfa91..68a1c1464 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -1,21 +1,9 @@
 ##############################################################################
 # unittest configuration
 #
-# [unittest_name]
-# file = <name>.elf		# Name of the elf file to be used.
-# extra_params = -append <params...>	# Additional parameters used.
-# groups = <group_name1> <group_name2> ... # Used to identify test cases
-#					   # with run_tests -g ...
-#					   # Specify group_name=nodefault
-#					   # to have test not run by default
-# accel = kvm|tcg		# Optionally specify if test must run with
-#				# kvm or tcg. If not specified, then kvm will
-#				# be used when available.
-# timeout = <duration>		# Optionally specify a timeout.
-# check = <path>=<value> # check a file for a particular value before running
-#			 # a test. The check line can contain multiple files
-#			 # to check separated by a space but each check
-#			 # parameter needs to be of the form <path>=<value>
+# s390x specifics:
+#
+# file = <name>.elf             # s390x uses .elf files
 ##############################################################################
 
 [selftest-setup]
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 124be7a1f..867a8ea2f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -1,28 +1,10 @@
 ##############################################################################
 # unittest configuration
 #
-# [unittest_name]
-# file = <name>.flat		# Name of the flat file to be used.
-# smp  = <num>			# Number of processors the VM will use
-#				# during this test. Use $MAX_SMP to use
-#				# the maximum the host supports. Defaults
-#				# to one.
-# extra_params = -append <params...>	# Additional parameters used.
-# arch = i386|x86_64			# Select one if the test case is
-#					# specific to only one.
-# groups = <group_name1> <group_name2> ...	# Used to identify test cases
-#						# with run_tests -g ...
-#						# Specify group_name=nodefault
-#						# to have test not run by
-#						# default
-# accel = kvm|tcg		# Optionally specify if test must run with
-#				# kvm or tcg. If not specified, then kvm will
-#				# be used when available.
-# timeout = <duration>		# Optionally specify a timeout.
-# check = <path>=<value> # check a file for a particular value before running
-#                        # a test. The check line can contain multiple files
-#                        # to check separated by a space but each check
-#                        # parameter needs to be of the form <path>=<value>
+# x86 specifics:
+#
+# file = <name>.flat            # x86 uses .flat files
+# arch = i386|x86_64
 ##############################################################################
 
 [apic-split]
-- 
2.43.0


