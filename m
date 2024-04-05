Return-Path: <kvm+bounces-13694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E608998ED
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58B92B229F3
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386EA160884;
	Fri,  5 Apr 2024 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RWZU5hha"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165AD15FD05;
	Fri,  5 Apr 2024 09:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307819; cv=none; b=PNr9gq3Rq6sm/yBNH+9NxmSXHJwPUSsPXWwcUopkgxlMqx//f8JtKarwO0GY7XFh1OaHmpelWHqSV/prxBUB4QTC5giWJnBQ9XDIlstes5rlqll+w/YBSLhHF/evnOPx0DX5Pb7/zhBfgSG/PDolZ3r63DdgZ/RoNxM9C0LcgjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307819; c=relaxed/simple;
	bh=rlL2+FErBdos2+O/hylf7fixnJvVATK9Gyb1N4Ov7ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiFe+0YvdVpYhqaQjncoA/HlRk/qwtpsyXV1MqLnzawQfB5189RPYfSwwOyOw4n1TYFeIXrntdzeS0cokoOGZ8ilfj6glKACgI0FtdXYMVf8VZtk47KppdiMU8X0uJoLLUQsfwcFpViltgR7ZxbQ1SsLgMkhoskq7Uo10fUhEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RWZU5hha; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso1445352b3a.0;
        Fri, 05 Apr 2024 02:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307817; x=1712912617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uiRGj9yVp2/RttD7SIRbJPPpByI/TPSbVrR2YfMTJYI=;
        b=RWZU5hhaPdKeEtzbfjMaH3g90DiuO1qrC8s4SbJ4VWAaHRkxTFuUdTMmf0ekOTYWnj
         B9kdPYxBJjwHFTHHo6l8JID+Vs/sLRENoxtIS1Cwmlk5Cl52GcSuRIK3pWeEVx8+0a4O
         wPfkKBPRgUgcGieJzUaYYtDBMbRe3al1PPuNiCD+bT6XU31eFvQrSrN9Oag2TxKQHhaA
         ZW6p0UwLLQPy+RMShgulDfCUOPw/DlUpiohMNgUfffeNWVy1F4cx1skj6ZNognWfRXX8
         8VGDl+iGxirx1r8wa+1WcMcUzdzsymwfhnK8Y0fItx0/M99qysm1Hx1+nyC/QhVccn6b
         9GLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307817; x=1712912617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uiRGj9yVp2/RttD7SIRbJPPpByI/TPSbVrR2YfMTJYI=;
        b=Cw/sM7nB/xuV350kKwsDDTzn+xcPvXQTrJIixC7ccR0zlnIxEyYMs1XxBHce4P8/sx
         QviIiq3SqLFS5P0usAsSXqBs3kuQxNPbact0QhiruF7fYKgZTIVODiulcpS+TSV5n8cr
         21jR90Yz18K73wKgz+AOYgsxA3w+V7NNxVaK1faC43BpyfrEibXQOggmf22eK+8DJbff
         8s6Jopap1O0/4mo0GK1qi6DavE8rsFLteylf0rhTLNUsAi0307HZDVFC1n79npRw1mkX
         Vjxrw/bDKSUsofm57hoFsWBVsivQ9n1Lx1i/RT5WpHoeW6jJWClGWJY6AQyevAQk+Lsp
         FMWg==
X-Forwarded-Encrypted: i=1; AJvYcCVidAiwoBanzyLUAqZOeS1AAbyXiIk8q36lHL3ThIX2NeqYTmhXFyCwN5Znzr9dZ7UTTmVa8HhjEx1cijpimZpxJ0OlKz1dsZIRwXgeXCSVSmU1jtSJwPR3aik3QPBl3A==
X-Gm-Message-State: AOJu0Yy82z3SOR0lxmKCFLva6y9ydlZNuaQVw5Af26ogF7lSxiYwiR9l
	vI9auNxU7jl/LclU11nUmuz9eJzsKEkSR8/JopO+jWVxljn8VT3j
X-Google-Smtp-Source: AGHT+IFqNZOWLsGBfX2j9GyTIkY7CisycE4Gye8dmhOPb3YIK0IRM5IIkvfRtFIykc5HqnGn3C5teA==
X-Received: by 2002:a05:6a00:4fc7:b0:6ea:749c:7849 with SMTP id le7-20020a056a004fc700b006ea749c7849mr907567pfb.13.1712307817273;
        Fri, 05 Apr 2024 02:03:37 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:36 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 17/17] shellcheck: Suppress various messages
Date: Fri,  5 Apr 2024 19:00:49 +1000
Message-ID: <20240405090052.375599-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various info and warnings are suppressed here, where circumstances
(commented) warrant.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh            | 3 +++
 scripts/arch-run.bash   | 9 +++++++++
 scripts/mkstandalone.sh | 2 ++
 scripts/runtime.bash    | 2 ++
 4 files changed, 16 insertions(+)

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
index ed440b4aa..fe8785cfd 100644
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
@@ -184,6 +189,8 @@ run_migration ()
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
 	live_pid=$!
+	# SC complains about useless cat but I prefer it over redirect here.
+	# shellcheck disable=SC2002
 	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
 	# Start the first destination QEMU machine in advance of the test
@@ -224,6 +231,8 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
 	incoming_pid=$!
+	# SC complains about useless cat but I prefer it over redirect here.
+	# shellcheck disable=SC2002
 	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
 	# The test must prompt the user to migrate, so wait for the
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
index 3b76aec9e..c87613b96 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -137,6 +137,8 @@ function run()
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
     if [ "$check" ]; then
+        # There is no globbing allowed in the check parameter.
+        # shellcheck disable=SC2206
         check=($check)
         for check_param in "${check[@]}"; do
             path=${check_param%%=*}
-- 
2.43.0


