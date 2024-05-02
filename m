Return-Path: <kvm+bounces-16398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37478B9626
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33026B220CE
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B7C37144;
	Thu,  2 May 2024 08:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UGxxNZH1"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF433997
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 08:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714637382; cv=none; b=AQaoFuIyxeuhtLY6sgzuM5+2xeO+/hETzM3xcNMpKyGWeqZ5miUjaQVunSmDK+6owh5e4QqYMxyaDLPMZ7kn+d+vBk9t/1Dwn0udwAD59o/moHIng149n1xJZJ+ueImAk5YRhmldbxgXnq9jkB8jKqMIq1QhIYRnRjiDvmm8hjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714637382; c=relaxed/simple;
	bh=cBikJJxtRyosgRer76KHRkA/clQa1Ldt4VOpeEOVuGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IFvfUywmvEeSZkITpB1WzRb6uQzGzX3Cwe67kJQjE9gQzA2q9RTtbGbrrgEjRU48n4f1ufQJyqeDln9Ei8nsT+XuQNx55DUvYmeAkOgBJSCe3ewmzqwLIBbPBZ8L9xuv11b2MqSHdjVLToEBcY55WG+/VLuaodpPZcPjFyKGeVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UGxxNZH1; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714637378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PUn/5bHOO1/8x7YegQ6ZWZdaG/2EH6zQpwsl2+tWePw=;
	b=UGxxNZH19Mhow+WnCt4WHZll7Hf1drGIQOZgUOCzDRQNaigjj5PqLyGmN10YRR3zBytaCM
	NQtQwPgqFlcwCdkjM3o20qyyk7c0JsCwmEr+f+kw8AraBNarJNRq1TZNtcJ2xoDDZir36m
	sj2kH0brkRlI3PhZipqg67+gl8SsOaI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH] runtime: Adjust probe_maxsmp for older QEMU
Date: Thu,  2 May 2024 10:09:35 +0200
Message-ID: <20240502080934.277507-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

probe_maxsmp is really just for Arm and for older QEMU which doesn't
default to gicv3. So, even though later QEMU has a new error message
format, we want to be able to parse the old error message format in
order to use --probe-maxsmp when necessary. Adjust the parsing so it
can handle both the old and new formats.

Fixes: 5dd20ec76ea6 ("runtime: Update MAX_SMP probe")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 scripts/runtime.bash | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index e7af9bda953a..fd16fd4cfa25 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -204,8 +204,10 @@ function probe_maxsmp()
 {
 	local smp
 
-	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
+	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
 		smp=${smp##* }
+		smp=${smp/\(}
+		smp=${smp/\)}
 		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
 		MAX_SMP=$smp
 	fi
-- 
2.44.0


