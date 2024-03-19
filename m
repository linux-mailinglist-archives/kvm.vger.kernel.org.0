Return-Path: <kvm+bounces-12090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247DC87F8AD
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 484581C21A34
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0399054BE2;
	Tue, 19 Mar 2024 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4nna4Da"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B6D537E1
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835229; cv=none; b=g5v8+zJvqpxg7v7xx6x1jkDWRCRTSYWduZXpx7Wr/h+a4xO3b0gRZrl/XHEs2r65GWdTlXGl2he/lnRHB4XpYsdH8JNLBOVsqR+vb3KGv91osasNnTZyDGyEOZ+jfUbcZP8hY58kxd88Aa3ynbOSBQWcDWy3DlHwQbZaoYZVoZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835229; c=relaxed/simple;
	bh=6FODQDK0kilYnb7hWg4H1aahNJkcim8qq94PMKU7KNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSvNxvVau8+z7hxkA4I+2sKwdqe526GRNTMzehCCnvL4vUXSPBphUQ4kC9aQQy6e4UT1kpdtLUy/MABM/vRNE+Zh4vUNV8qaKB1/OO6jRGoqWBqcWUPzMwy4TwDs0XwZ7gftuyk/ofKjEPGpCVJR0r99jGgI96eG79DDQsZkYbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4nna4Da; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3c39bc142edso41455b6e.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835227; x=1711440027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0y0odnkHg56MP9cN9AQCJ0tr4xMulM+8pNx+P8ve/gI=;
        b=P4nna4Da6n/GxsOUwaGBKxJHozIkcgzzGpd8CQGEOtKjVmbcvj20ly67seIXMiAdkO
         Jpug9/D9V54fSQ36YTOEACu+LiSUext/xSvs6+3yQnlteawFfm1Ku+1O+u9JHZgsX/Nk
         nSZ7FpNMnGz0OxQgi4lg53yjUt/84wq1qhEl/Zk9a6RMfqgNHkSC2Fxh6eOB/OWrK22K
         GlR0GAu9OLO+iHjnorzB6rpSidOHhP3MwJlYtVGmvBVM0D5KkmQWsoyNLgqh9VVJkO8q
         hmxsnnsf7E0mny0gPBGakLlCf7pB7Vjy0sXowMKdpTYkYa697GahjMIuHDRC0KSQXg0u
         s/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835227; x=1711440027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0y0odnkHg56MP9cN9AQCJ0tr4xMulM+8pNx+P8ve/gI=;
        b=D5SAyeCYyiTULFjr0RmWAjHILeKZQt29WG59QSxsh1nfrK4TpehzGDNYXKlMOyfDF+
         IauG5OixIdm0li3A7riLOKzxzRm67KMLvHBtBxGIh/cnlafvbMzNNkoDE/afLu7YEzRI
         X6LhlKD1VIuYM4K6iUazvsaM7LZTHmbd+HxyXoV00Ybuq7JBw1Et4CUmFQBVz/UaL9BU
         S758u3UYR8Bw27mbimqUobByZq93ktleq9pzfSE8eI0MI7zbquCF/+JjnwoK0Q1Q2CyO
         c2Gf614t0mUQs2YmBaUcTlYWl57q7vl4wTRH2gLqSNCSXVAPUfuc1+HD0+IgS2Y9FhEK
         TtFg==
X-Forwarded-Encrypted: i=1; AJvYcCW7icEGzm9jkir06ezYAerAXzE0wwDX1lysMbdCrLowdZZ/agLFoMGSL6xo8DPR7HJBPLX9oQnzsXFYZYqOZUjBail9
X-Gm-Message-State: AOJu0Yxd/P/v+n7ZfCyw+GaoG2OZdqqkeQtDHiXQEIutqlFHWejjGPs8
	uJ1zsTj1pBRf5g2KoE7iL78rbGDctlhF3xVDj78Ge3upStpgJEcDtufB27TjeJE=
X-Google-Smtp-Source: AGHT+IF9aDLZUPosgy6rpk16ZaqRepm+7B0h+dF+YDWbgQFj5DBzE5ABhTXmbPl0bJZP9AS+TMu9Gg==
X-Received: by 2002:a05:6808:f0a:b0:3c3:69a2:4248 with SMTP id m10-20020a0568080f0a00b003c369a24248mr16079802oiw.28.1710835226966;
        Tue, 19 Mar 2024 01:00:26 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:26 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 14/35] scripts: allow machine option to be specified in unittests.cfg
Date: Tue, 19 Mar 2024 17:59:05 +1000
Message-ID: <20240319075926.2422707-15-npiggin@gmail.com>
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
2.42.0


