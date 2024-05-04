Return-Path: <kvm+bounces-16570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BB78BBB3B
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40988282B12
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE452249F5;
	Sat,  4 May 2024 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzqIHU2O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F9225DA
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825760; cv=none; b=lVhe8Cd2rRLd9XQgFYwc/lV5rRlOsiSlpkRDtFzL9YT3pQfNpy82NSZrn98Q4Cg6CX3OOAotkAEHgrlWcpX2+BJd+nOBu9ITa22WOg3RIBvuIphfISZGWSi/ARWK0i1SNEmYLFcfFuZIRLKEkjOWvncKN9Wnz+4kGy0IbLZtAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825760; c=relaxed/simple;
	bh=3yc7NYcXdEj5sUosfXRTU/CV99dWyRB+2GWI/8vJ/Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j03iqEXJ5NnUm97XWq14INWwpmJ85jskrleKtejZy29Pr119XXMh3/fxfYmmLCZTn00pQNLRWI9rK+UEAYmEy0dRqMYP4wyim+g4h/dHXwjtidz/HDyqCtPaGbR9QitQZS3GbdYcb2lmF/0y/b+vEWRS9NMz0X4vSxEag7IyxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzqIHU2O; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f44b5e7f07so391948b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825758; x=1715430558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGMJSfkN2PfJHtxLiOclIw2fyyzbggN8HHskSwcg0zA=;
        b=IzqIHU2OkOlV2FCJ+37lWvZ9IarvplaP1PrQXyAKEWmtns5L+wdUtH7bp80iFhmtbC
         fbzSd2VnOoiGW/4L1NY+NsNsdhz8EU/XkYL2rO5/Qj+K5J8Bkvmw6u6ACpXW1If1NwpV
         aJc2x3ZeWGYrQ6dyaOKVfnYZD7yrdFlC/D3JNq1z4cFFbqmaIdpTJNm3I2emGRYfRUHY
         ptOkX6rLiHQWsHT6vie0KJ/DlAoN6Pk36mvIBGQ9Itkd2m/HNz3uTlHQg/EOeiHH6pZ7
         d5HisHNKZGE4Bh5gsejrcQoFOnHYUv1lu72Uk9RDa1rGQKl1jVmVVaxgTrN2piXpcCcN
         hPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825758; x=1715430558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGMJSfkN2PfJHtxLiOclIw2fyyzbggN8HHskSwcg0zA=;
        b=k10mLjzHSe/lk9C8jz89LCGt2ft5EJKYFo1+Aab1TWEb3WsHy6SI2U7hFi99RuxKZR
         ztDOzO8lQUcFlF2Tufw+ylhvJItq3WFOO30hqyI38TzDdl51NaV/zKfSCv8NWVevLQLF
         FShWXZlzgxEXfYw3EAILCLWglr9/hNeFWpggZXlNi8DWaZWyUJfsqvALbuN7Z6ZihJXU
         S+1pSJTczBli7WPUtlXng+0OZAuXqoEd4OLU/TS+KmmFeEViCtPQipD9885uzVvMvBH0
         i8Td0YZETJ4sNt13y9jhfT5MPeUYpZaNdTCq0hCaQXwjLGM301SzftrlPHLBgwvQhgdD
         k+2g==
X-Forwarded-Encrypted: i=1; AJvYcCU+nnf7gRus5nmcgnhluAoeWpyjrVgDdVk88ZVYHGOylWG6y75VEdIY210FU9WQtOIVh64T0moKJU1QnxtF+g87kZRT
X-Gm-Message-State: AOJu0YyJ4ZBGc9sjUw4jMr/z7Jb9Og4TNm73cBx6psHRBZ0JOkGWuUsv
	jby/3FyVl8pLbR4MDae/SdOnUdY4iXiFEzFYTH5SJizCcZIZayzz
X-Google-Smtp-Source: AGHT+IF4Gwv3VCJ87TdHGNnmmkZNl82UF42Fzg7O1j26MYNkfF8j7hnGLUzlLI5XVds3TNEaAqZ0bg==
X-Received: by 2002:a05:6a00:4e4e:b0:6f4:5531:7ce4 with SMTP id gu14-20020a056a004e4e00b006f455317ce4mr2694549pfb.33.1714825757985;
        Sat, 04 May 2024 05:29:17 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:17 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option to be specified in unittests.cfg
Date: Sat,  4 May 2024 22:28:13 +1000
Message-ID: <20240504122841.1177683-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows different machines with different requirements to be
supported by run_tests.sh, similarly to how different accelerators
are handled.

Acked-by: Thomas Huth <thuth@redhat.com>
Acked-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 docs/unittests.txt   |  7 +++++++
 scripts/common.bash  |  8 ++++++--
 scripts/runtime.bash | 16 ++++++++++++----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index 7cf2c55ad..6449efd78 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -42,6 +42,13 @@ For <arch>/ directories that support multiple architectures, this restricts
 the test to the specified arch. By default, the test will run on any
 architecture.
 
+machine
+-------
+For those architectures that support multiple machine types, this restricts
+the test to the specified machine. By default, the test will run on
+any machine type. (Note, the machine can be specified with the MACHINE=
+environment variable, and defaults to the architecture's default.)
+
 smp
 ---
 smp = <number>
diff --git a/scripts/common.bash b/scripts/common.bash
index 5e9ad53e2..3aa557c8c 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -10,6 +10,7 @@ function for_each_unittest()
 	local opts
 	local groups
 	local arch
+	local machine
 	local check
 	local accel
 	local timeout
@@ -21,7 +22,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 			fi
 			testname=$rematch
 			smp=1
@@ -29,6 +30,7 @@ function for_each_unittest()
 			opts=""
 			groups=""
 			arch=""
+			machine=""
 			check=""
 			accel=""
 			timeout=""
@@ -58,6 +60,8 @@ function for_each_unittest()
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
 			arch=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^machine\ *=\ *(.*)$ ]]; then
+			machine=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
@@ -67,7 +71,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 177b62166..0c96d6ea2 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -32,7 +32,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
 }
 
 skip_nodefault()
@@ -80,9 +80,10 @@ function run()
     local kernel="$4"
     local opts="$5"
     local arch="$6"
-    local check="${CHECK:-$7}"
-    local accel="$8"
-    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
+    local machine="$7"
+    local check="${CHECK:-$8}"
+    local accel="$9"
+    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
@@ -116,6 +117,13 @@ function run()
         return 2
     fi
 
+    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" != "$MACHINE" ]; then
+        print_result "SKIP" $testname "" "$machine only"
+        return 2
+    elif [ -n "$MACHINE" ]; then
+        machine="$MACHINE"
+    fi
+
     if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
         print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
         return 2
-- 
2.43.0


