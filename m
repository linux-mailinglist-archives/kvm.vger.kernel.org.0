Return-Path: <kvm+bounces-8970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D52F8590DB
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 17:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA512826FB
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 16:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6417CF25;
	Sat, 17 Feb 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wxv6fQrt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C398657BE
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 16:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708186920; cv=none; b=YSEYphDnxcmZMDIlmeZcA/FLNtOehsuDRxc3pk0LxrWq7L/YGPK+6NxQMzYRVs6DvS57O3IZ5dBRCYWhAhO5tj/s4R93FC9WdXXr3ZOlwbuU/insBouFsWHCewa7MT2MxlB/LxxzEDQZ6vAYJ9hNVgztmNLjLc842ZYh9HuUvRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708186920; c=relaxed/simple;
	bh=kbkWoK7PeRqZNubt2xQEk1eKm39EWOJiBoVs+PshX68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tVrg7dLVENnykx59om1+mVwsnfLtPNkjs/XDDXod5ovgi/ghOt0MF4oACQGXiW0flGBXi4FTuv63dxWOE5novX4+eNgpVPQdm5+aEZA26PnG1dT1IwY+7Be8x3IOmRuL6VvMRQ3oXwRQEqUi9rHQjLWqu7LsdEk1X0dkB6wqqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wxv6fQrt; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2906bcae4feso1027347a91.3
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 08:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708186919; x=1708791719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5FN+oD3KMFC/TfdeFvM0FRMaVy0lDXkbGnnLaiCdz0o=;
        b=Wxv6fQrtteNbI0AZJCIv7wT5CdFi6U5LLQNeZp+TDyf0ZTMfQWrp7y9lJEXIDwqok5
         udI3Adw1CpFiFnVnrkMjHl6uPOnpfB4me7oB9VpuuRSmUVZVTc1kFdERTJ/xLfYDdVc9
         Q5whLA9xJTDD1JEfsInw8tr3G3ELzqgpLTxwLaUhclzCdsiCStW0qe1PI1w/2SM4ss9d
         iN/ed9ckSADfG8IZ82VkA8pzrCG6tEZhTuRfzGaF9I/r9qTSBOdIUrx90oXhetYm9IEv
         rghXjBiVISMy134486YCN7JT3d0h/Z0S5lVh+nTcFR6q3S+KUBQYMlHnrpsS9i7rOqvF
         gEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708186919; x=1708791719;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5FN+oD3KMFC/TfdeFvM0FRMaVy0lDXkbGnnLaiCdz0o=;
        b=qVZRyi1r9uOoB3791/oZ6WmNvphxcEJpZhSftWINz6G0dW4/Hlc/Lzk7koBrOjUChM
         mwJsAcqZX2lap24nhK5kUKG4UlPUi00ALUdSBGq2Hy1T5V9Dh6zN3b6uvnws+72LTQj6
         6gEiftMTqaSJGy49WqLjH9/O0K8JIZmJg+KYmJGhktEdvvzqiC+/Nr8r+SWzzEPO3Y8I
         Sim0UjZMF6KniEs3QOlLKXxbbG4U5m39hI0W9XtWcxS2m9ZAZyu8u1nF70Za/gLRvREu
         SmliagOn5yhTpLHpA3D5PdRoJqJBOIMMrv7G0Pz7ob344h9txUc38T1TccFk+QvMT6mL
         60ug==
X-Forwarded-Encrypted: i=1; AJvYcCXvlI1aZOwSZwDepi0pljtumKJWfuO7hWmOyXvxtIFb7Kotycfwf702OvgGuKe4eFFbuALzmBf/jdTAwAV6J8HLi47Y
X-Gm-Message-State: AOJu0YzCF7Jw5mk1sknUXaf+NWa+GP6+1NsS3T2zNQfbb6A0/LfoBHFv
	bYt2r7kSkeNcHxzHvAKPEZfkp1oducSPajzWPZf39bW3kBV0xSP6
X-Google-Smtp-Source: AGHT+IEp1wWk0hWr1iqgSdT60zF8Ll2pUswOOcezURmLUmxuEUAnE+0kvPs/yRIPW1g7rSNrkJ9TCw==
X-Received: by 2002:a17:90a:bb15:b0:299:dd2:47f with SMTP id u21-20020a17090abb1500b002990dd2047fmr6272516pjr.10.1708186918491;
        Sat, 17 Feb 2024 08:21:58 -0800 (PST)
Received: from wheely.local0.net (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id pf10-20020a17090b1d8a00b002992754487fsm2001864pjb.5.2024.02.17.08.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Feb 2024 08:21:58 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH] Workaround (possible) QEMU migration bug
Date: Sun, 18 Feb 2024 02:21:51 +1000
Message-ID: <20240217162151.144408-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent updates to machine memory can seemingly be lost across QEMU TCG
migration. This patch stops the machine on the source before migrating,
after which the problem can no longer be reproduced.

This isn't arm64 specific, powerpc could also see corruption using the
reproducer. It must be just that it's getchar implementation was different
enough that it didn't show up there.

arm64 runs the migration selftest okay with this and the uart patch.

I'll try to work out a simpler reproducer patch to report the QEMU issue
with, but in the meantime a sanity check and any suggestions about this
would be appreciated.

Thanks,
Nick

---
 common/selftest-migration.c | 5 -----
 scripts/arch-run.bash       | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/common/selftest-migration.c b/common/selftest-migration.c
index 02b102cc5..dd36696fd 100644
--- a/common/selftest-migration.c
+++ b/common/selftest-migration.c
@@ -10,12 +10,7 @@
 #include <libcflat.h>
 #include <migrate.h>
 
-#if defined(__arm__) || defined(__aarch64__)
-/* arm can only call getchar 15 times */
-#define NR_MIGRATIONS 15
-#else
 #define NR_MIGRATIONS 100
-#endif
 
 int main(int argc, char **argv)
 {
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2214d940c..0d6950c26 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -209,6 +209,9 @@ do_migration ()
 	while ! [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
 	while ! [ -S ${dst_qmp} ] ; do sleep 0.1 ; done
 
+	# Stop the machine before migration. This works around a QEMU
+	# problem with memory updates being lost.
+	qmp ${src_qmp} '"stop"' > ${src_qmpout}
 	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
@@ -232,6 +235,8 @@ do_migration ()
 	done
 
 	qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+	# Resume the machine after migrate.
+	qmp ${dst_qmp} '"cont"' > ${dst_qmpout}
 
 	# keypress to dst so getchar completes and test continues
 	echo > ${dst_infifo}
-- 
2.42.0


