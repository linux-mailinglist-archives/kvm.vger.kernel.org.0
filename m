Return-Path: <kvm+bounces-16394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9328B956D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 09:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAF08284A5F
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 07:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A53C2261D;
	Thu,  2 May 2024 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TLLYceIx"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5D9224F2
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 07:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635728; cv=none; b=idJ2nhLgzFRK/FBQGuhoJd9XWg5L/7QtV7V9eZOHBZUKZrl4WQYvwJfIUOzTrgoj8LhOAHFkTSlc5wT+nZZo3CK2MBAerEiRbzbI49KgV4L0zEqaZAmFiLnsY4ftXF+iFS6d/nBopG0WJjvEV8PFIzOX3CD4OO09VSeTKquVEgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635728; c=relaxed/simple;
	bh=5w8KgEeplEgdD5avufH4230Ry31kwU+dxjNva7fx6ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UcEtZ9PWGPARN1Se7DoJxYWX17b82vBUtD5ve8sY39pXTfDK572T7vtJlt6eb5u6nkue4gbp1swayX1szZ6/9EMrVuIRbEfxbfScI2JkX3SxSLZeD4Fo4IudX2KkC8pApK8H47m03pryvkOTnDC5N+OtXrgwQfc8dLJ+bFozNno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TLLYceIx; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714635725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7lbWrqcOFDe1oL2g7PiVPq+5ALof3Xrfm3dWBwqlV7A=;
	b=TLLYceIxH1zcrdbVsvXvN++E1tWJIXBKCVyu5uyuNYCYiUGicX0x9EDjBPJFC2KhJHyC2t
	O31gXo5CmWyFkxL193PAExKclMXtOab68LaLwhWi0tcgNlDHZjaFpTgzpRa1TvGibKshzS
	XXAwND3OdlIdL8MlcOWayeLwJ2wv1Fg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
Date: Thu,  2 May 2024 07:41:56 +0000
Message-ID: <20240502074156.1346049-1-oliver.upton@linux.dev>
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


