Return-Path: <kvm+bounces-62644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2182AC49BF7
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0549188D9AE
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD93305979;
	Mon, 10 Nov 2025 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PUifzqSs"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C7261573
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817229; cv=none; b=jAxl3W4Yn7uaU4cyiwBhqQ6CospBgXS2De/vgXuWDcao6eCkLCJ3bMCVVMky4xsTjNRSWZCDGfq3WGbY1SGYl5nhOWlyOl6Fp89iNyZBLB5s+5ZoqGm1+eLSYhfrOFjr2hsStiBFfGMj/aXXtw8vUggOgz7w19FYRIATO1QApoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817229; c=relaxed/simple;
	bh=ogJdXeINqQWlpc3T1UEK6sCoWh8eJk5cHClB8hzYApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l57r6hK6H+ISHKvxjuNvZcMhyMWqp6fxsKT50LoN2xY9IM7kNZiKBesbr/ZXGT0F0g2Zja5lCePomqvwF4rc+29haDR/c7HpbJYAzqkRDX0jee4DYAWc3Dvvqy7Tax18OhuyFb/TIwnj5iY4cI7i28LWgfmtGPtvmIng3KM7Xt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PUifzqSs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UZWKobXDfLkd7eERlrIkQnCB9bLEgjEGKzWLVchtxf0=;
	b=PUifzqSsCvaC+q98arBe8udyvqY/HJ7NptyD9RL/9QuYJ4VChad7VyBR61qB2+AfGt1RuP
	C0Z8H1iD+qohsuFjf2Wr76e1xkFvwv3/TdAhnsUyTPP4AxJIpfkqLDTBE6MGCrm2qI6uOD
	BE2NkUimswhxkXh02YSsGW5W1Ou0boc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 01/14] scripts: Always return '2' when skipping tests
Date: Mon, 10 Nov 2025 23:26:29 +0000
Message-ID: <20251110232642.633672-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
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
2.51.2.1041.gc1ab5b90ca-goog


