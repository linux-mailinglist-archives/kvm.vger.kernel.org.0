Return-Path: <kvm+bounces-16834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFFD8BE467
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC39C1C23DEC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B30E15EFC5;
	Tue,  7 May 2024 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzL31YAo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BEC15B120
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088876; cv=none; b=phiwmdWh/I2d+EVQS6J2OBVtqqB76/15/gQ52oOJ4QwwyurQqwfu7YGT2jl9zhNfpKmuKXSJXqN3Qj562AHTOtZ11ak2pa26R4dRBfQXcP+Nwi+wJgTxH7fphYfAr9SuXznejclHXQzubT/gEyAs706ymMMxybe0ky3c1umf4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088876; c=relaxed/simple;
	bh=O1e9JPxKfNYdC/BnwzpEcziUQTTUZFWNfm9Sh1xzTcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UWiizzoAmfqM7eP/YXHwhr5K0CWnnR8mkfJWfckUb1Vo05eddszlujogcKdq314jx/qi6Oo1XtsaIMizlFodhSvNdwTY9UfVV7hM2plxnwaCPbhD/ayEEMeQ1qLH8LPy6Zk11gK1KCIO0nfuTp5in8skx0afImFoCjsQGZjpo74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bzL31YAo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715088873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AfYXlia3FD7KN6Jf4iXTRUssF4mhx7f/Nwd/R6ZwacY=;
	b=bzL31YAo6DyFrGeL97KO15Ij4SL1s01zB9ek4ODPacAKR5TWQ5LRx9Yj7NJS/Zx3y13sGY
	MT/DHuyF8ZQYyh8X4ZKJGJxc/IsNR6vJlH+dJegGzFDspRuxO7qdAW3NX+CyDGeQwQ5vu2
	mnDAYw/J3lDqMktEBH9GEt5T9NfM0EQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-DQfXhFSkN8Gd8lcxNfrLUA-1; Tue, 07 May 2024 09:34:28 -0400
X-MC-Unique: DQfXhFSkN8Gd8lcxNfrLUA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D7FB801189;
	Tue,  7 May 2024 13:34:28 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.193.6])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3B9D491020;
	Tue,  7 May 2024 13:34:27 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] travis.yml: Update the aarch64 and ppc64le jobs to Jammy
Date: Tue,  7 May 2024 15:34:26 +0200
Message-ID: <20240507133426.211454-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Ubuntu Focal is now four years old, so we might miss some new compiler
warnings that have been introduced in later versions. Ubuntu Jammy is
available in Travis since a while already, so let's update to that
version now.

Unfortunately, there seems to be a linking problem with Jammy on s390x,
so we have to keep the s390x on Focal for now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 9b987641..99d55c5f 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,4 @@
-dist: focal
+dist: jammy
 language: c
 cache: ccache
 compiler: clang
@@ -20,13 +20,14 @@ jobs:
 
     - arch: ppc64le
       addons:
-        apt_packages: clang-11 qemu-system-ppc
+        apt_packages: clang qemu-system-ppc
       env:
-      - CONFIG="--arch=ppc64 --endian=little --cc=clang-11 --cflags=-no-integrated-as"
+      - CONFIG="--arch=ppc64 --endian=little --cc=clang --cflags=-no-integrated-as"
       - TESTS="emulator rtas-get-time-of-day rtas-get-time-of-day-base
           rtas-set-time-of-day selftest-setup spapr_hcall"
 
     - arch: s390x
+      dist: focal
       addons:
         apt_packages: clang-11 qemu-system-s390x
       env:
-- 
2.45.0


