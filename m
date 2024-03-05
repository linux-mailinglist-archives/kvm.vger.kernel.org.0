Return-Path: <kvm+bounces-11021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B9B87249F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 245E9283834
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F43D512;
	Tue,  5 Mar 2024 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NwtD0lAK"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F3A8F5B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657194; cv=none; b=JP/W2vWt0AoBDJjQ0Ee+FOwFYrdTP8Dlc4iuxkPBASHAg/ZMxsPeR8KjKgYyiSFBDjvX+j9Gc9y5fdPORKJ2vz6WFr8k9HURbEBRTXkN3Z3erSkcNMH20nGVNZHBVB3ddXGTGNdp8zUvRbCVoj/klzCAVRxZxQ9Cwt1tBy0EccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657194; c=relaxed/simple;
	bh=vS8RBIPaMK+XTVtiCk3oJ/Iw996ZA0Kgef7lQF0hZ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Yn/VhNsjejWFMLilWJ2qibOsdqBuWt5OMWSIyA023xLmTHwi/0wOEGb0I6krbRkYyu0DxGURzi4rZeIIS1n8atZtsQmOOm57r6HrOjH2f7B5VQ5YmihlF3btth6shKmn5lL2KTJbDUb5X1pvD1R4Ca7WeGNDwoa78WXHU20Q2/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NwtD0lAK; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sQhWmCzXkFMJxWz7cbGY/Y28rowAcEv8BcVa6A1WR9A=;
	b=NwtD0lAKOCQfHBpEjAmijmfmEYmkl8hnDx8vDFnsLJs/ysXPzsYfScFANUtpkP2oIsWxrB
	Vb1A55EJ3yFb1oHVQNiemZVzEScXHJtWJ5OKLI2p455rccbpnLjweIG5Szf9dZak21rIFL
	j/M+0zq2Heyovx79JpzG5McU3xaAoL0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 01/18] runtime: Update MAX_SMP probe
Date: Tue,  5 Mar 2024 17:46:25 +0100
Message-ID: <20240305164623.379149-21-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
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

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0


