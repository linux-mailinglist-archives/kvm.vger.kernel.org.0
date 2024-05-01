Return-Path: <kvm+bounces-16335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0288B893E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D7841C211A7
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1179770F5;
	Wed,  1 May 2024 11:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RegDcHoz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258D6166E;
	Wed,  1 May 2024 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563055; cv=none; b=nXshrzuvQVSHvvdmS6cpB+Rqj1LKj2RFxr6R+jn3InboYmMguuC0SMmIdhGU+3uFkcF144ah34yT1zk4F3mRbdmmRN67DF7C/vKHGgYOhpTFBgMWQgRdMQO0YQ76yoIq/QKIABzxBc72E47bW6lRZypxqeD8gJSqwxxUA+OOUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563055; c=relaxed/simple;
	bh=ZPWgrXuqWYUuAjdqFkmq3oOnUFlf/K4b5/Gpn5LRl04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz4XbD+GS2tSBKh8P2Pumgmk8DQ585AMTLT8LV7Zgi71/KMPVFWn+tdHhFOqlrdMBXaQQZOl58FdWzuvCykHsgMmGdgl36HoeiknZN7iHAi4kzmtl6r04gPoQbaedFbydHalGrFAvPjydirJxCP5lRJmtF9ZyFeIvYJuL7PU0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RegDcHoz; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1eca195a7c8so2501245ad.2;
        Wed, 01 May 2024 04:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563053; x=1715167853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYhyM+QV5csxpHLgX/7kmJ/huORg40mwGJt/SbZ3cb0=;
        b=RegDcHoz8Gqa4ARc1L4RJeE6brXz9oV3AbeO0KIiktNnroO83lVk+ekDj1zC4fxC4h
         40DvTE6XHOnk6sNeQqqPycZeQHwM0r4lnRBg+tPlC0ubb+jx4m59sQsEzfw5PDtdNl8H
         bXkPakZ+vqDlQmXhk9FZGhRjU0vcCT6KBPYHgrvBseWkmO284Hjo08uycOfl/U9ioD7h
         /RNatWObfh8L06MVRrfBaQy6ID4xuqvf9APCb3yWL2LchLnvZgfsbM/39M5trzLcs0NM
         6xqbfGghmpMtkFDApeF1DepcJ94OoY1/yMJsd+a5mlQmgzpNDiQTv439+HuyNziLFcHA
         U36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563053; x=1715167853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYhyM+QV5csxpHLgX/7kmJ/huORg40mwGJt/SbZ3cb0=;
        b=X9/8RNrK2zw7mXgGbywpWG7F+6i0zhRwAFHC070Ai6sjCF3jDLtlKQvUPDIP0jlpr5
         V1Ygje7F8ePQb+wQyYtQFK2sQmzY2Y2RILUAPUciErChB670pnBeIn7P75Yt5w6Mr4XK
         wljKuJDLM95GcL2r3fMc4IwGyiu4whdNjYijUk2tJfNQwdCKHUxE0gRsxvCGHJxcnWy/
         TzJbVy2TzZgzhuKBp/k76nd6c1ICNImGVKQjxIgaKAVEVnKfLkR3oWvqsTi5ctwteGzP
         PVcCF0z+q4Gpx1/eQL/tL0dqNSvvra8OA+g2MxmDCxd2s8+4EpbZTmx0xXQvHD6i7eVB
         ZIPA==
X-Forwarded-Encrypted: i=1; AJvYcCWeQkImYtLwA5QxHkiBNwo3+tvk1bLsoumyjBIvOZQxKFOZ6Bzyfr93BrBtOyF30PBhb7eQtmx0plnVI2jyy0g7pz/wnINByNVTFv85ZRb5nv0XcD8qgoI+8RwUNxaZIQ==
X-Gm-Message-State: AOJu0YyJ6ia9lyq7BDUIg5gXxhbcvFIq3itSJZylycP0dsWU+d0ccL7F
	jAuCWW1xT+xAeqdWGt9y0P8faS0wN7bGAYwGtpwrXW3X+wUti4to
X-Google-Smtp-Source: AGHT+IFRvIa3dx8kGf4HFdIIro2Yu2MuudVt1JrMdj5z3e4X6RY0JLVjSEleK/CrHZosrlvZp4Yc8g==
X-Received: by 2002:a17:902:bc45:b0:1e2:bc3c:bef6 with SMTP id t5-20020a170902bc4500b001e2bc3cbef6mr1904842plz.37.1714563053087;
        Wed, 01 May 2024 04:30:53 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:52 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 5/5] shellcheck: Suppress various messages
Date: Wed,  1 May 2024 21:29:34 +1000
Message-ID: <20240501112938.931452-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various info and warnings are suppressed here, where circumstances
(commented) warrant.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure               |  2 ++
 run_tests.sh            |  3 +++
 scripts/arch-run.bash   | 15 +++++++++++++++
 scripts/mkstandalone.sh |  2 ++
 scripts/runtime.bash    |  2 ++
 5 files changed, 24 insertions(+)

diff --git a/configure b/configure
index 49f047cb2..e13a346d3 100755
--- a/configure
+++ b/configure
@@ -422,6 +422,8 @@ ln -sf "$asm" lib/asm
 
 # create the config
 cat <<EOF > config.mak
+# Shellcheck does not see these are used
+# shellcheck disable=SC2034
 SRCDIR=$srcdir
 PREFIX=$prefix
 HOST=$host
diff --git a/run_tests.sh b/run_tests.sh
index 938bb8edf..152323ffc 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -45,6 +45,9 @@ fi
 only_tests=""
 list_tests=""
 args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
+# Shellcheck likes to test commands directly rather than with $? but sometimes they
+# are too long to put in the same test.
+# shellcheck disable=SC2181
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 98d29b671..8643bab3b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -44,6 +44,8 @@ run_qemu ()
 	if [ "$errors" ]; then
 		sig=$(grep 'terminating on signal' <<<"$errors")
 		if [ "$sig" ]; then
+			# This is too complex for ${var/search/replace}
+			# shellcheck disable=SC2001
 			sig=$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$sig")
 		fi
 	fi
@@ -174,9 +176,12 @@ run_migration ()
 
 	# Holding both ends of the input fifo open prevents opens from
 	# blocking and readers getting EOF when a writer closes it.
+	# These fds appear to be unused to shellcheck so quieten the warning.
 	mkfifo ${src_infifo}
 	mkfifo ${dst_infifo}
+	# shellcheck disable=SC2034
 	exec {src_infifo_fd}<>${src_infifo}
+	# shellcheck disable=SC2034
 	exec {dst_infifo_fd}<>${dst_infifo}
 
 	"${migcmdline[@]}" \
@@ -184,6 +189,9 @@ run_migration ()
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
 	live_pid=$!
+	# Shellcheck complains about useless cat but it is clearer than a
+	# redirect in this case.
+	# shellcheck disable=SC2002
 	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
 	# Start the first destination QEMU machine in advance of the test
@@ -224,6 +232,9 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
 	incoming_pid=$!
+	# Shellcheck complains about useless cat but it is clearer than a
+	# redirect in this case.
+	# shellcheck disable=SC2002
 	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
 	# The test must prompt the user to migrate, so wait for the
@@ -467,6 +478,8 @@ env_params ()
 			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
 		fi
 		QEMU_VERSION_STRING="$($qemu -h | head -1)"
+		# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
+		# shellcheck disable=SC2034
 		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
 	fi
 	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
@@ -597,6 +610,8 @@ hvf_available ()
 
 set_qemu_accelerator ()
 {
+	# Shellcheck does not see ACCEL_PROPS is used
+	# shellcheck disable=SC2034
 	ACCEL_PROPS=${ACCEL#"${ACCEL%%,*}"}
 	ACCEL=${ACCEL%%,*}
 
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 756647f29..2318a85f0 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -65,6 +65,8 @@ generate_test ()
 	fi
 
 	temp_file bin "$kernel"
+	# Don't want to expand $bin but print it as-is.
+	# shellcheck disable=SC2016
 	args[3]='$bin'
 
 	(echo "#!/usr/bin/env bash"
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 597c90991..fb7c83a25 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -127,6 +127,8 @@ function run()
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
     if [ "$check" ]; then
+        # There is no globbing or whitespace allowed in check parameters.
+        # shellcheck disable=SC2206
         check=($check)
         for check_param in "${check[@]}"; do
             path=${check_param%%=*}
-- 
2.43.0


