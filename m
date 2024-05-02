Return-Path: <kvm+bounces-16393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4287A8B9567
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 09:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 928B8B215B9
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 07:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51832225D7;
	Thu,  2 May 2024 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PavLa9XL"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FADA224EF
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635621; cv=none; b=PPpYyJuOkNHXl8eFXHq1Kx1rKVO0S5yeD+LtDtc1MLT2aGdGh9SFQGCf7ZWfSO87hz6g1HiqbnxvcgNLmZhQhwDUkmZ7YpRVrelt8U0acn9H3HyLWGKmxu54fkcxMgKKzbzUASkDQfNLBqs2fC7xedS2voGtZDaFBN9fA/228Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635621; c=relaxed/simple;
	bh=5w8KgEeplEgdD5avufH4230Ry31kwU+dxjNva7fx6ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c9IHGVfynKdZFNU7+kUHSxba5fCI5E3fUQlbCoe+wSBHWTFj+6JH68Y1hhF6np/KS2VD/ZmU7j1tJDqEnBITl2xi6KsA8QDOqUUG/lG+2RCk7pPVJBq6xbP9PRh3lN3hw/9jrzwLNUV/Cue2oAluYhkcAjch6250DgbjlourBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PavLa9XL; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714635616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7lbWrqcOFDe1oL2g7PiVPq+5ALof3Xrfm3dWBwqlV7A=;
	b=PavLa9XLpWoyHfaFKOwnw86RiqSA1Ci4HtfSxhBQYKCG9rNY4Gg0pqefvWUwfHZVTh8jpp
	dfsXDPiLr492SXOjotI0s2p4+EwnR2DpbLRxE47GmGVtLYAvbD+a2savoyWSLaTm0BXPeY
	UhgGWIxVXCW40WGaJR3oezo33lmuvrI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] arm64: Default to 4K translation granule
Date: Thu,  2 May 2024 07:39:18 +0000
Message-ID: <20240502073917.1343986-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Some arm64 implementations in the wild, like the Apple parts, do not
support the 64K translation granule. This can be a bit annoying when
running with the defaults on such hardware, as every test fails
before getting the MMU turned on.

Switch the default page size to 4K with the intention of having the
default setting be the most widely applicable one.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 configure | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/configure b/configure
index 49f047cb2d7d..4ac2ff3e6106 100755
--- a/configure
+++ b/configure
@@ -75,7 +75,7 @@ usage() {
 	                           (s390x only)
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
-	                           64k, default is 64k, arm64 only)
+	                           64k, default is 4k, arm64 only)
 	    --earlycon=EARLYCON
 	                           Specify the UART name, type and address (optional, arm and
 	                           arm64 only). The specified address will overwrite the UART
@@ -243,11 +243,7 @@ if [ "$efi" ] && [ "$arch" = "riscv64" ] && [ -z "$efi_direct" ]; then
 fi
 
 if [ -z "$page_size" ]; then
-    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
-        page_size="4096"
-    elif [ "$arch" = "arm64" ]; then
-        page_size="65536"
-    elif [ "$arch" = "arm" ]; then
+    if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         page_size="4096"
     fi
 else
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


