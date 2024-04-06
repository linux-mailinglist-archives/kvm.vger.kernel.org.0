Return-Path: <kvm+bounces-13803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F9889AADA
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0701C20F5A
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952962E83C;
	Sat,  6 Apr 2024 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wdr/Lauz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9D62AD02;
	Sat,  6 Apr 2024 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407186; cv=none; b=ns/HC5f3MnPqDihd19CDYe0Ah6aTBk3J2K2DlxpEfsO2O8GPh/acktrLloAKWOqV0T7YkSL5scESAFHqgKegSsg4r1XqcLscwyiTh7Z+QascrnCV6vR6yb7motVpD0olFA7gYR6CmymBc+uVZzE07C76fc4Bk2K+RG2o2LevN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407186; c=relaxed/simple;
	bh=E9V+D1WzxVx771XD8ctKhzgHjEAQ4Z6qQre3e4eGKLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdtS2zl9MszCwvPkkN2SC5uNaZRKfaGAKPytyfGrGUKvKjaEKxCPkbVHiKubehNW7vauk2GZT8mZHPfKGQkdLRWKsVZiJ0nD5N+fkiPBiNTj5WCUPhiR9DBjYUVgCwklU5Ct4dJ2gYPP/JZpS9oU7ArlJQaxsTFbiWeRqWR5h+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wdr/Lauz; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso2240576a12.1;
        Sat, 06 Apr 2024 05:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407185; x=1713011985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qaba2L6x2dAj5DcBCo5KTsqOGBkhqsWqRrfdlHR5ju4=;
        b=Wdr/LauzUz3o25qo0ztHHQKCLaa9Pd4jj7CgiAF26oYRr95GlQSede9TpXi5g7NvTP
         DjFs6OTMKNhacgprG0Shq8Zzc/hfQZFBiZoKxGyVfzm2atFIMReJqHh9/j//gojvqqLe
         o2FJrS4BYqu59wl+6yyZnTFThBDv4w3cc0Odq2PB8EdAmz2B0SzWIJm14mlCRylh4l4j
         oH95Hp8RecqkNzSOY34EdsJ5Xqm2ry67FQRstK7EoClZ5PjRggwGxYTirC34O8I6jFIG
         7CjF5BjYUDrdQGMlq2Qofwzf20khI9OHlsXy3oanhbog6A0M56wLBNpIFL1J7lpa/n2Y
         3YdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407185; x=1713011985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qaba2L6x2dAj5DcBCo5KTsqOGBkhqsWqRrfdlHR5ju4=;
        b=mxdQGIK43qv6Uu2BPw1CNXGCTqrrpgrg9B7Tixw7TUog2sz4tBeX6HZSvA0fFUjzLk
         lJv8g2s/oh+tI/kvHorquc/xtXKyHkjGMxFLk3BvtkmroTbNyO/T2UUWCgxnKWxuN/zj
         pfGGow55TpfNrgaUlY5kFvudPe59ZzdGyMxlJM5L8Dux24UYf3CfuoFXRfzTbgtddNNi
         8xOkNiHoznIhJ+lI7f1gNTl4efOh6bnfqxy9tZSKUk4XSNCDKe0GCxv/sIkL5aeBVFQK
         MW9Akh37iZpbei2wjT5L5cXoboS6kXmK6ND4i2zHOcB8cBtGYt0EY+ISt9/Oz0JTxLTb
         CqQg==
X-Forwarded-Encrypted: i=1; AJvYcCV/E5M4SE2H+nNvHoaF4BUti2W2wLmQGHJYLGqBl8a1k20gagwyA9IxLsoXXuSNKN+lWWfrfFRDvZJQs5oYF1e7UjtXSwo+H+HoI8DTiQnB3shVvx+NKsE5D8YiSDTV0Q==
X-Gm-Message-State: AOJu0Yy1tNcldByueXim5ti9M0o+gxSw4K6C27mIwqU8Vmsog1GftcC0
	7eCvaUEsdhLYFXH9mBPqmSy74JnMILDVgtLtKPepT+Eckd6TzBnU
X-Google-Smtp-Source: AGHT+IHtQqbCWjek/Kw7U/EWKBnTW/ETkzN7lWi05EYkEgh8HEshJ8MsbtIGm3+uuLIyM0NGEw3xzQ==
X-Received: by 2002:a17:90b:1254:b0:2a2:d4bd:d5db with SMTP id gx20-20020a17090b125400b002a2d4bdd5dbmr2957629pjb.49.1712407184811;
        Sat, 06 Apr 2024 05:39:44 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:44 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 06/14] shellcheck: Fix SC2155
Date: Sat,  6 Apr 2024 22:38:15 +1000
Message-ID: <20240406123833.406488-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2155 (warning): Declare and assign separately to avoid masking
  return values.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 10 +++++++---
 scripts/runtime.bash  |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f9d1fade9..ae4b06679 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -411,7 +411,8 @@ initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
 	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
-		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
 	else
 		unset KVM_UNIT_TESTS_ENV
 	fi
@@ -423,7 +424,8 @@ initrd_create ()
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
 		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
-		export KVM_UNIT_TESTS_ENV=$(mktemp)
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
 		env_file
 		env_errata || return $?
@@ -566,7 +568,9 @@ env_generate_errata ()
 
 trap_exit_push ()
 {
-	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
+	local old_exit
+
+	old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
 	trap -- "$1; $old_exit" EXIT
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f79c4e281..3b76aec9e 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -15,7 +15,9 @@ extract_summary()
 # We assume that QEMU is going to work if it tried to load the kernel
 premature_failure()
 {
-    local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
+    local log
+
+    log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
         grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-- 
2.43.0


