Return-Path: <kvm+bounces-13654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 048D68997FC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268E11C20ABF
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37ADD15FCF0;
	Fri,  5 Apr 2024 08:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PE5J8TxN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22C215F31D
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306205; cv=none; b=cBQpnlcBWcjgWE3qeqgbqyRO/QX/MJ7sHtXZuUYl3b8KTUBjwbY+MsmDyclkgf39Tz13jsv5Aq1RnkIZN9nxl9JCW+Kgs+sQYU3zLJMV7dkN7MhKI28alZd8fhpWosggk3AIvCVLqav8yrTqG0ip1Met6fIfH35qRELvHJwn7C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306205; c=relaxed/simple;
	bh=fkBnWlDkWkexGX+n8Zvl6vUvVV4mEQ9IwquZrWsGh5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzL34ht1y5oSEgvf7P9Ut6plyq7/juMVrkFeYECAodlBCOZQlBoNHn6KVHueaaooprwNp3SIFC9eOesORtVoSgqEgdJ8IylB+0prBKq5ptrDlet4doiH5ZHIITbi64piYpbaoyXDKqAeFOUA9nxUxvoYETiDdrPVOtTYntG/5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PE5J8TxN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ecfeefe94cso299542b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306203; x=1712911003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQbx6UjediBeLlNcsWNM4lfZY/zhVIKWn4tLrrWPArY=;
        b=PE5J8TxNluPaiYXzXiAvdsZ5HUJuavAmqiBFBV0IgWvsWWV6JvpWoriJpaHvaD6DpY
         HkIF0690bgksO6+aFQnQxIxwuxci8RGnTnoTq6XURVSSqlAH6fFaXzDAwsM2kw7cfhTt
         pDmSP1p4VSx2naorPFPDClGppeF4GxB4lo5ODsRk51qUnaH1lCN9zCdojQqBG4CET3g5
         5aerFunenIOWFp+xKKZSCNeGMu5uyVTGnuc56W/CdJfXiTpCpe0E4Z7l1X9zwvQHT4PX
         KHWMfCsRFCLC1uOoqX4zm8YAtI1dFIVjNaMoAvM60E4S+lkJG+pFyEKNd+I2DSg87WQJ
         2jtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306203; x=1712911003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQbx6UjediBeLlNcsWNM4lfZY/zhVIKWn4tLrrWPArY=;
        b=hgD0bxtasmMrPV0kUAksXe3e4F1h449MCPZRnm/IQ3DFJOule88w/T4KZdPZdLkwrb
         v0Vi0HygcmJkDclcEaEqxkiAmOw3Rzy5RgnlN23CIoWLb8sb6IQ3hv+hTgKT1qMhC//7
         d8/pBzSMalNGv6Ky8YAya/6zjwwOXee9c0Xsnmc6vwLE+qVUX5BTtgOzaIOa7z/4E01A
         AyucRIce4jn7Sbv+Kx/D638nHCfXreFmbMZx+rL6usXtJWkutNNiIEtOkv0/ZXUM2WzP
         ucQILaA3vgaKCrHX7pvfJ7bZxc/aqmoPL9WzzhtFlRwDzOezKJCqqbHzcdf1LdbQkhjT
         FyGg==
X-Forwarded-Encrypted: i=1; AJvYcCUzPnOtuYa4JMCbF+1Bdb6w4eNIS1Z9qiZI4lwqZYrVWdWdvuFPEe3gnWEGJUo+jIAsuJsWrYqw6mhosDI1sbQW1kbG
X-Gm-Message-State: AOJu0Yy7krYWaHFVc+dsN0bfgndc7UZ4ajyZJhRzwhEBF6Dq6VBq6gBW
	BzMIjfxupog5Z/3k/jXRR/jkGKISa469bUvXrT0FIhJyMuIrvnK0
X-Google-Smtp-Source: AGHT+IFcw/uR74oa6sH/n17w8+m0KhHI45Aisa+Loe+RbZgjSwZ1p0b28ZKqppC36g1aKz8WPNG6rg==
X-Received: by 2002:a05:6a20:9154:b0:1a7:23ae:4421 with SMTP id x20-20020a056a20915400b001a723ae4421mr2401241pzc.24.1712306203180;
        Fri, 05 Apr 2024 01:36:43 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 14/35] scripts: allow machine option to be specified in unittests.cfg
Date: Fri,  5 Apr 2024 18:35:15 +1000
Message-ID: <20240405083539.374995-15-npiggin@gmail.com>
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

This allows different machines with different requirements to be
supported by run_tests.sh, similarly to how different accelerators
are handled.

Acked-by: Thomas Huth <thuth@redhat.com>
Acked-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 docs/unittests.txt   |  6 ++++++
 scripts/common.bash  |  8 ++++++--
 scripts/runtime.bash | 16 ++++++++++++----
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index 53e02077c..5b184723c 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -42,6 +42,12 @@ For <arch>/ directories that support multiple architectures, this restricts
 the test to the specified arch. By default, the test will run on any
 architecture.
 
+machine
+-------
+For those architectures that support multiple machine types, this allows
+machine-specific tests to be created. By default, the test will run on
+any machine type.
+
 smp
 ---
 smp = <number>
diff --git a/scripts/common.bash b/scripts/common.bash
index b9413d683..ee1dd8659 100644
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
index 255e756f2..a66940ead 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -30,7 +30,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
 }
 
 skip_nodefault()
@@ -78,9 +78,10 @@ function run()
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
@@ -114,6 +115,13 @@ function run()
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


