Return-Path: <kvm+bounces-10282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AED86B2AA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 584421C26504
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A7C15CD65;
	Wed, 28 Feb 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gvvzS0+m"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BB015D5DE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132701; cv=none; b=AskA2nK7kWttvSWbD1nt5fYKuzCIZ9NfsGxPeKcE249lXp3CssW7NjFCwTLUb1Xr+0/WijBs4CbKqNNPe7LuXWOk3F2zeOtz/8oJDHHWgtot5RfRgOZuDzieuAaaHYiRDG/1/zc5iykEWwH8Nh73UjBlNWXhRsde3GUXyxTL9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132701; c=relaxed/simple;
	bh=VcqCPtXMv1uhuAB5IP9SDsGiETFkqzYGIzDHN66nbe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=AZYdQ2WmmoJhfSOZObj+xyEnm9IK/+H7DJZ0IqoGq7i97rsKu90qJS4NkPsHM3JQ5gB86xViUsx7iBvbQC8sPTtVkA1jqKPRxojhIngtHuLq/Vh4yM7i+7jLArKoGNE8KiRhgix4CQ1LFO5TEkyBz2IXfLSe3Lb38VaNGRxaDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gvvzS0+m; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q9vRF005JAaDyhyrpAk4NO6v3kQv7hh9HfRGIDgBLwU=;
	b=gvvzS0+mpv0DMyjUR7Ici7npzazyK4T9VeBWcXy3oAgYUMgvhDn3wVZ9xf8K6dQcT9T05B
	OKaLJgo60jKecmaZler76EyqNfFSGkBaatvBp5lHIK5SpFalf66DUDZhWAcdb9SNXND2GR
	uNvpz/14jJp/I+pvqmGiO64SrG/Q2SE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 13/13] riscv: efi: Use efi-direct by default
Date: Wed, 28 Feb 2024 16:04:29 +0100
Message-ID: <20240228150416.248948-28-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

efi-direct is much faster and riscv makes a lot of use of environment
variables, which can't be as easily used without '-initrd'. When efi
is configured for riscv, assume efi-direct is also desired. Users
can switch to running from the UEFI shell by configuring with
--disable-efi-direct.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 94b243fd1b26..10728773eb3b 100755
--- a/configure
+++ b/configure
@@ -93,7 +93,8 @@ usage() {
 	    --[enable|disable]-efi-direct
 	                           Select whether to run EFI tests directly with QEMU's -kernel
 	                           option. When not enabled, tests will be placed in an EFI file
-	                           system and run from the UEFI shell. Ignored when efi isn't enabled.
+	                           system and run from the UEFI shell. Ignored when efi isn't enabled
+	                           and defaults to enabled when efi is enabled for riscv64.
 	                           (arm64 and riscv64 only)
 EOF
     exit 1
@@ -236,6 +237,10 @@ if [ "$efi" ] && [ "$arch" != "x86_64" ] &&
     usage
 fi
 
+if [ "$efi" ] && [ "$arch" = "riscv64" ] && [ -z "$efi_direct" ]; then
+    efi_direct=y
+fi
+
 if [ -z "$page_size" ]; then
     if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
         page_size="4096"
-- 
2.43.0


