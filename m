Return-Path: <kvm+bounces-66959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7A3CEF305
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 19:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49747301FC0D
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 18:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476D12C2AA2;
	Fri,  2 Jan 2026 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PgQ4wf2F"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE0EEBB
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767378659; cv=none; b=YsyopcL4vx4RWTF0LThcRMgb3xgavGA97jxAlZg7nyNzwd/v/YOJJ4cudSD4lEe9LpytgWFFb0yy/IVCJ1ULKUqvJ0RkmRPX8id4jCd1p/gaYIc84d8H5bUxRxznsjUTB99eAfk46sEmmMriSSnIQWNmf6Ud1nZDJ4pAnRg975o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767378659; c=relaxed/simple;
	bh=D4TmaAxTnBQ/b9c1hBEfJ1PosADa9TkbcS6/QTR4RDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GJz/M1DQfvnDZElzMFnvMJ/SsZk7b9Xup0Zw2SdNw09toMWXtC4luV3ryFWBavefxXH+8GWazXx975nP8p+jsCm3eXAHZAzUQRKTWNskRF14kNTu/W7GZoRM2m0Y1WNnKfDGfyOhthHqqGY/Ko+HKgltOhucUzpYIUG4RE3gKac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PgQ4wf2F; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767378655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HaTtIvEunPnbGtxv7cizIPNuobdeWOh/nb+49uxiikk=;
	b=PgQ4wf2Fal0JVno6ocBSiIN7aX91fsXpzNT0Kw+FE4P9/igSTaedWHpYoqoJJnEdtDyD1A
	sc5R03p4Uw5vDfr17mqCRy4N6uhNvQcnOmnfoOK2HFkYN11cO9hiuk3BYwcWVcriwdOxfV
	HNS6zg4kFwddVORaio3TfPE4fldUoRQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests PATCH] x86: Increase the timeout for vmx_pf_{vpid/no_vpid/invvpid}_test
Date: Fri,  2 Jan 2026 18:30:39 +0000
Message-ID: <20260102183039.496725-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running the tests on some older CPUs (e.g. Skylake) on a kernel
with some debug config options enabled (e.g. CONFIG_DEBUG_VM,
CONFIG_PROVE_LOCKING, ..), the tests timeout. In this specific setup,
the tests take between 4 and 5 minutes, so pump the timeout from 4 to 6
minutes.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/unittests.cfg | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d32bf6..bb2b9f033b11 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -427,7 +427,7 @@ test_args = "vmx_pf_vpid_test"
 qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx nested_exception nodefault
-timeout = 240
+timeout = 360
 
 [vmx_pf_invvpid_test]
 file = vmx.flat
@@ -435,7 +435,7 @@ test_args = "vmx_pf_invvpid_test"
 qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx nested_exception nodefault
-timeout = 240
+timeout = 360
 
 [vmx_pf_no_vpid_test]
 file = vmx.flat
@@ -443,7 +443,7 @@ test_args = "vmx_pf_no_vpid_test"
 qemu_params = -cpu max,+vmx
 arch = x86_64
 groups = vmx nested_exception nodefault
-timeout = 240
+timeout = 360
 
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file = vmx.flat
-- 
2.52.0.351.gbe84eed79e-goog


