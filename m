Return-Path: <kvm+bounces-11054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0CB872559
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AA97B275AA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA9517555;
	Tue,  5 Mar 2024 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p0uoAYv9"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B914AB7
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658579; cv=none; b=qcRLbUPzSxkjRp3U3ANCiKwzTQKX/SOJWeXjphTlycByGbNQkB0v+TZhSVwOvVpEhequ4ovEARZyrKFbbpT/5QUfCgsKTG2vr6pys5M7B4Ej6hi8Xjg5CRcWgBafNvFIr/DIpM3PBvri2BfCSlJUKZw1WF+TwKeY4ixyTgq5mlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658579; c=relaxed/simple;
	bh=4i46ZDC2uxgKHd3TOXhYpqv4YobfEXZh2Ec+yfOpcFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JcR/D6IRE9uwRCXaE4kD6QSjCNDXYHgrouCXrmZHCoC7k3BaNenTDCSmjEEw3FOaPbwbp83bk6kc7eXRRY1wcHABowXpXaNeQZaFxwfY21DGuRmds1Yu4nSqJDTU+tSvfTDJzN8nIijCZex9492a/xf32CIShXNf8royWR//984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p0uoAYv9; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/sD2rBGTNu1CiBDS7Tvk/5gX+q8F/Jb2Pp05sNhh2Y=;
	b=p0uoAYv9ObQmlg1FJc8WLsj60oLxSVK2AQFC6Mv23DaQloaCcsIv6y29Lo7tr/kXJBKAX6
	LJvZObtg1pTHnMoZESvrUqAkcjcnPNcYHjokpd/aOiLzvNyv8nJOsEuElWbQVtBO1NlXYQ
	c16UXY3lVapSr+iSNIVb0RabVocDCdg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 13/13] riscv: efi: Use efi-direct by default
Date: Tue,  5 Mar 2024 18:09:12 +0100
Message-ID: <20240305170858.395836-28-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
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
index 14d2569e9e0d..49f047cb2d7d 100755
--- a/configure
+++ b/configure
@@ -94,7 +94,8 @@ usage() {
 	    --[enable|disable]-efi-direct
 	                           Select whether to run EFI tests directly with QEMU's -kernel
 	                           option. When not enabled, tests will be placed in an EFI file
-	                           system and run from the UEFI shell. Ignored when efi isn't enabled.
+	                           system and run from the UEFI shell. Ignored when efi isn't enabled
+	                           and defaults to enabled when efi is enabled for riscv64.
 	                           (arm64 and riscv64 only)
 EOF
     exit 1
@@ -237,6 +238,10 @@ if [ "$efi" ] && [ "$arch" != "x86_64" ] &&
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
2.44.0


