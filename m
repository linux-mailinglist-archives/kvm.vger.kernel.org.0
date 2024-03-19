Return-Path: <kvm+bounces-12089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 075C787F8AB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ABCB1C20B88
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F975466E;
	Tue, 19 Mar 2024 08:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7uRe9b1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124CE537E1
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835225; cv=none; b=lQOIBEFedMMrAtxyJHgHljJxygfXF7+GVG9mGKx9aLGAK4xAnhp3pFPkbMiQI47Utjia486nS5M8IVL8IJYIQZcsQaCuUVH2J/StNd7dt0FeFMn6TQQfhSUA+WN7U4SF4WVuJFr5w1l5vBvKR1mYSNo5g4zK3qiTIWC50LFMgUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835225; c=relaxed/simple;
	bh=1x5/rqeT9ppXaqKDZIpSZAlaJ10cabI+55HBL+jx+6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbTC6auy95RggcYSvBss4FnJjrnRQwVbYwUCe943cMy/iKBg3NdcJEDHaXdv9z5FSiUI+2bygaJombf2zqFStAFEh1L+A7OQ7ucYLAkhKELTvvfUYZdirVV+8waRIJciLOT5Exw3XX/FH3+L/ifNAghsZsIXwkI8qXe+BIkcpf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7uRe9b1; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e0f43074edso3121193a34.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835223; x=1711440023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dYKloMaVNRA1K0WdUqfNiU807y8A/fMNA27ThMkpH8=;
        b=N7uRe9b1qehp4PglVvVRVWWg216m7/b25RBWYn+z6Cte8vmQd0UcG3cO7oLQVIQViC
         ezDyq19jAj+wyfKi0it/4LLUbtk8k+rhhpJ4fxmJBr614BUpMw6N/+J1KXmuTioBo1x0
         1Ffkv59He2vpfgcVITM9VAmmH20goDcXFj6BTOWS8UNJGS+aYdo7l2kdc92+yT37eX5b
         dJG50M11xb0a4HXzFReD+3ZleGwvJtuPdTQr0kMtrQcOl0mp+Sk7H9dn18htq9zJH4Fs
         EX4htXnx3Pmyger06nKz4XiWKH0La6P6paolno8uoVH6VMpffjNuEyxzALUexF7oZI/h
         I8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835223; x=1711440023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0dYKloMaVNRA1K0WdUqfNiU807y8A/fMNA27ThMkpH8=;
        b=bsdd7uMgIuhDl4ubVQjXj0CWBY2oim70JdydGq6GoiS5tRpmGcLw3brER/DcgEV5Iq
         sT8pU2+ZqoWeBHdWZxwIlj0ccbuReqLTlkbpF66kNbCpyqyshQO1PEshMz1ebbo/jDIA
         QasGnNVHpN+vs1qvnpxG8mwC46DmQl3v/GqYzlnuAQU3kqLc0t27RLWXwbufCPx5xF4j
         GgbtYpyWhqCdTe4ngtfKxy09pjQa+8cJxW6m02NMYvPUVwrxEiPGv4CEe8dbEg5+zE+G
         BpwawLxpvppF7PzsIoHnAJvPbLk0x/FvROJaqfwLdRz2NNComx+ZxDe+JF1UeL4FLiTm
         drKg==
X-Forwarded-Encrypted: i=1; AJvYcCXRpwGaRpO9XTxQxIx+2+WcZXYfkqsulBWTgPCRUY3BMA2eI5ENQWzXKhLUubUtQAGfAyky9QNFjVchCuizz/uTMgj7
X-Gm-Message-State: AOJu0YwkX5b6w3tkKsa/1+Xh7GWTd6sb8wTiwKorNRYTLpmwGdIDE0Dy
	Y+7WWDGoOzF4btBu19MWBcqX8S1XgAkahSus2FFwFciX9ZtZXFFgjqDI7L0hRxg=
X-Google-Smtp-Source: AGHT+IEUonzbDLFfzykkcQwpnCF2OnRoX6IIO7f1kwVSXYK0lVTHuWmBwNyL1fdxb0nxoRNutxc8cA==
X-Received: by 2002:a05:6870:84cb:b0:21e:b8f7:9a1b with SMTP id l11-20020a05687084cb00b0021eb8f79a1bmr13865746oak.25.1710835223042;
        Tue, 19 Mar 2024 01:00:23 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:22 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 13/35] doc: start documentation directory with unittests.cfg doc
Date: Tue, 19 Mar 2024 17:59:04 +1000
Message-ID: <20240319075926.2422707-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
index 550eff787..d6abf72f3 100644
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
2.42.0


