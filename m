Return-Path: <kvm+bounces-10116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0609886A00F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BE721F22087
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE29524A8;
	Tue, 27 Feb 2024 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L396xdrd"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6BA524B2
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061682; cv=none; b=HmP3gyQr2sujQ3DXljoH78DAC13I1Va6vfAgZbbz2Antc6PHP4eEKLgJhthJMoLqvSTQQOvT92ruZEgYJFKvaVnAlwsYdQ1fJmMIttmqmddtLQCw7W5KcB6c1sbFQWyeX/9S6/cUL4Z8PGgqh7Xsy2pfqNCKJg9mVSGISRUeSoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061682; c=relaxed/simple;
	bh=lEQ6K0Q+ikRwyl81me4BlSv2NGdOq8DunwtRX35EskI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=lf/EiXeh9HNkwkmXm70ZgC66lgKLisCgc1Zf43Ttukr63SHSyU3OTAInYMdv9MYV+7c926Jjo6eyeD7ygi2L/pgMBLeuRljFyZ4ZLEDXIH0oTVM8guJF26habeAaawvkv7Vua7qcWMq6W9Y08LhujJWvUJ+bna0KAT6H4oqYG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L396xdrd; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4OBPHXt5GQvSmvvE0fniEaHSM6+gtKcQZ+u11vU2bk=;
	b=L396xdrdbzzi2SJFbaAlBsIAwmibGkEeJfxukl3fhb57DZ5SmmAXfZMBWrcc5XwaUPsu81
	71JLWhaWXdHjHblYppiaemxgDYtbbKy8etb/azksu7xoGS6AtBOs7CxG5wBhpkOSiFBuMK
	oiTWW93GxYq+3flQ2AUuQwNOXm1CK3Y=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 01/18] runtime: Update MAX_SMP probe
Date: Tue, 27 Feb 2024 20:21:11 +0100
Message-ID: <20240227192109.487402-21-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Arm's MAX_SMP probing must have stopped working at some point due to
QEMU's error message changing, but nobody noticed. Also, the probing
should work for at least x86 now too, so the comment isn't correct
anymore either. We could probably just delete this probe thing, but
in case it could still serve some purpose we can also keep it, but
updated for later QEMU, and only enabled when a new run_tests.sh
command line option is provided.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 run_tests.sh         |  5 ++++-
 scripts/runtime.bash | 19 ++++++++++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index abb0ab773362..bb3024ff95b1 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
@@ -78,6 +78,9 @@ while [ $# -gt 0 ]; do
         -l | --list)
             list_tests="yes"
             ;;
+        --probe-maxsmp)
+            probe_maxsmp
+            ;;
         --)
             ;;
         *)
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c73fb0240d12..f2e43bb1ed60 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -200,12 +200,13 @@ function run()
 #
 # Probe for MAX_SMP, in case it's less than the number of host cpus.
 #
-# This probing currently only works for ARM, as x86 bails on another
-# error first, so this check is only run for ARM and ARM64. The
-# parameter expansion takes the last number from the QEMU error
-# message, which gives the allowable MAX_SMP.
-if [[ $ARCH == 'arm' || $ARCH == 'arm64' ]] &&
-   smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'exceeds max CPUs'); then
-	smp=${smp##*(}
-	MAX_SMP=${smp:0:-1}
-fi
+function probe_maxsmp()
+{
+	local smp
+
+	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
+		smp=${smp##* }
+		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
+		MAX_SMP=$smp
+	fi
+}
-- 
2.43.0


