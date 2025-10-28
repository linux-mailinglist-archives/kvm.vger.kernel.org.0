Return-Path: <kvm+bounces-61351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CD9C17282
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC2364058E7
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0229735770F;
	Tue, 28 Oct 2025 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="StekrSeU"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2A355806
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689565; cv=none; b=LkAMs6r6+/nxxQeKs9DavVEKC4OE0eNkk/6CPhOrIkV9bIntMvZjZJnPCfqiXafyPwgpFuLAFDESAPZy/AbaKsWuRM/SVFFFkyA/YJnV7bH/p2jjpII9Sf2uRpEpnLLhkQXbR07evd/PUwyH9UjJ4iLKv/x8bDTRlXnJwOQXGlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689565; c=relaxed/simple;
	bh=xxeKlF8mwwnlrrgJ5iUG+Sr9g1freJAFqFCx5sFfPto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5tB1sFp9cAZtEt8CZMh9JtFQ5SlR1TyNoHOgGspfRDGaJ5Q7CurHPqox5pOtR/63DhP3JIPTMPGNWSchnjGHogqdErEl9yW+g6+3uHsj0KNVYZ2eHKVzYxs36ml2Sr8Hno0E6/JHMlAPua1VB9M8GnI136/qF6s7cIITnpopq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=StekrSeU; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Peddc7Q36WMJTpzb2qo2jbZSMjh5dJyVyT5u+gHEIs=;
	b=StekrSeUZvXHyXuPrkb3ATeaqN/iQxe8KQqTsltCdgUXGfOz6F4laz22aypepTdqxelqTG
	Reef7DZTx+uzJW1SzUwAlI+4p1ej7E89S9kZlRWfIIXBM7pNdEbv0BDNVKiBnAFUJBF6cV
	vVJszKBS+6Fm48VkAnyslWxIAx3dORU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 1/8] scripts: Always return '2' when skipping tests
Date: Tue, 28 Oct 2025 22:12:06 +0000
Message-ID: <20251028221213.1937120-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
References: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

runtime.bash always returns 2 (or 77 in one case) when a test is
skipped. But two cases are missed and return 0. Fix them.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 scripts/runtime.bash | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6805e97f90c8f..0cbe2695948b8 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -103,13 +103,13 @@ function run()
 
     if [ -z "$GEN_SE_HEADER" ] && find_word "pv-host" "$groups"; then
         print_result "SKIP" $testname "" "no gen-se-header available for pv-host test"
-        return
+        return 2
     fi
 
     if [ -z "$only_group" ] && find_word nodefault "$groups" &&
             skip_nodefault; then
         print_result "SKIP" $testname "" "test marked as manual run only"
-        return;
+        return 2
     fi
 
     if [ -n "$arch" ] && [ "$arch" != "$ARCH" ]; then
-- 
2.51.1.851.g4ebd6896fd-goog


