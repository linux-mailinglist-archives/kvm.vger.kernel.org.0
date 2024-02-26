Return-Path: <kvm+bounces-9813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F988670E4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8B041C28223
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDAF5C5EE;
	Mon, 26 Feb 2024 10:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QM34Wlux"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6D75B5DD
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942392; cv=none; b=SxDDgBqN2LGt36ggYZ0DFXm9bAQBz8enecb0Rh5wyW983FaIrycIgtbf7vHYSrGYk/NYrqMavs5eveWlOmyiFqUYzfjCpLW5bzBiITVN5kLvXA4UuRqi2lUTx+YsjOfpE919ayXvb6szDzdZUB7OYbK/3Nunosh4plZCaJSlDJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942392; c=relaxed/simple;
	bh=SNrX7HZ+PoZtvfNE5new3YDQK7WmU/Cygv0fQvQ6frQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP15hcVylPt/KJKlm1BT2JBF3dU2Q5udI78wbGAG4pFknKMMkox1asjBR/NtkzK/1dB4lo7PLCPJTbLbXa2mbM1NHLcpbz0QjFPq0+ILQeoSSKMEksXTgXg+6lXOPOKvsO+HLvtDeMDJv0DoL6GkYXgGPDNCaamRUtcFk/X0KSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QM34Wlux; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d8b276979aso2211243a12.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942390; x=1709547190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibxxwYww92kmlNy8I2FmvONCg7yA0hsHQ/uPKW/vpvM=;
        b=QM34Wluxi5/8coXtQW036+/fA4SiGHq40CY635xfNm+3HdmLfKxY17j0e+NVw4+BIJ
         G1TLA4IliIaGMngh+sJ+Pwbk+t/1exw0Ievm0HHm9/gJufT9mJ+cB5uzEpvWrHvUXT9/
         yVmO/1v+VJgXw4ook0WCfoEQQBT0YxBpZmZ6gBKvSJ3YS5bSyfhAa1lE9WZkTfZlSIUY
         OWowlzxuDyr4zlEfxgjnrYMNGfDPkv36sr5gVcQcHhaH3CSod4zENvJCq0NWQw+rgxMF
         B5AVuVzhTqZnVynfstGX7ilMaFg0q5GkX3xWRJlU9SWzXc+y+VG0KrJNyLCGVzJBzSW8
         HuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942390; x=1709547190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibxxwYww92kmlNy8I2FmvONCg7yA0hsHQ/uPKW/vpvM=;
        b=sDpOCiX+4Pl4WViSdJCEa6ml0blzkNvQC5PP75HndzAtqEaM1wCrg3vkgC6Zh6Mjlz
         1NZiUFDivjX1P6PMkBGxxi1iKDMrPlrNjz95PwOy+NO7atfpSAh1oIIvj+Lgw0hgvDGI
         us27pAUp1ZkdOXXNXgo8pSqMy+E9XuCwnNiR5mptTedJgx1jS0+dmqbyuuRx5aAXyqrs
         3530KORGyLvLFqcBShT+VRQVCZRLay2sId1sEeF5CL6HU6REGPAv1mIM17uQdpi5IZoN
         YQv8ViQl+B1Tz9BQ1/2vM48g1oqIbfwl18ESqA+nRATHcBxesRK10gA482EUtjGbkv9B
         5LDg==
X-Forwarded-Encrypted: i=1; AJvYcCVRzhGIWXD7odQCPuasC49qLMao+8J58g2La9VuaiskgTOhhDlcBPmhSZWuR8k46hMEt+ixc9x1cNei0s+NIcAQYdFm
X-Gm-Message-State: AOJu0YxG16+fVZHpV2/sgkzNeYdwBpqm4lub6rsJOPjQ8PbIUDhmwsyf
	3h4H0K8JeUE6l/GOrEGyIYFj5/jxFvYEwLdLLjQSyH0bd0s0vuZZ
X-Google-Smtp-Source: AGHT+IFka2ncRxwgdU5+LqoyMrXm720L3nBJvm6PweGVGm1ggkLbMOftr1Jz9ko+3ETODmRo47wVeg==
X-Received: by 2002:a05:6a20:9d92:b0:1a0:ccf2:8f35 with SMTP id mu18-20020a056a209d9200b001a0ccf28f35mr5515837pzb.39.1708942390587;
        Mon, 26 Feb 2024 02:13:10 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:10 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 09/32] scripts: allow machine option to be specified in unittests.cfg
Date: Mon, 26 Feb 2024 20:11:55 +1000
Message-ID: <20240226101218.1472843-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/common.bash  |  8 ++++++--
 scripts/runtime.bash | 16 ++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

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
index c73fb0240..8f9672d0d 100644
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


