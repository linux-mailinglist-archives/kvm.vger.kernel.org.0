Return-Path: <kvm+bounces-13806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C78C589AAE1
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8233B2827F4
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952392E852;
	Sat,  6 Apr 2024 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nre7uVSv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4502869B;
	Sat,  6 Apr 2024 12:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407212; cv=none; b=g/egYebXljoPXH4ihs2lXf1gnBDbw9DEF+wyeJ/ku/A3XwEP1a+JQVvz13lnDzFPcGiYlHe4F0Xgmdl0YKUSpdhdp8x52VIIEgADy4icYix5u1uX+bAAuMooJUOojXm/VPCe7Ub4KCkWPzmSIGM+1Pv7+JUYrmB7n+TXF5NvTr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407212; c=relaxed/simple;
	bh=BtK71PP95PMC4Hzbtxe4zhZtffb72GLFVB/PQAL00a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubG6KI9JruQD0J6ejg8zJeki/pPb/LOX8N1W229HTTGX/JliDsqe1h11X50saOdjwh76F9ipKbWbp3eMstvCfcJhcHB8mm1Mg5pXHLijkCyYZwk95I3lyXKfFiYx4NkyEb6GBp7/F80WWKnkJ25JjAH+93/hSJwI9YEA8ZgSUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nre7uVSv; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e6b22af648so2980169b3a.0;
        Sat, 06 Apr 2024 05:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407211; x=1713012011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DuXv8jLymFAc3dj84mPa+u6v5joW+GUy7CVoN0Mom8=;
        b=Nre7uVSvbwMtjIOmmWfgrPZvr25qmWqwmRCVA9P7GD0aRaucpm3How4Tr1HzAI0G6G
         irA9Pd7gjK6Nk35sdHgiW1nRwY4axeLWOknNpOLz35sXYXt2vr/MuliCjSjf8yOb+cSg
         mq0yd3SzfmbJZpeuf5llLJpWfn0VmnbWTSIf2fcLkdaWUytja4s7LAER5vXTaolq8qZ6
         yHvCdg7hyN8LxtXo4OZVhQncGXXs/2nXuLnu//s3WvO/yh+3pJsZm+GSqUFlHIOb+OUH
         WcIrv6/xMLcXmfO/DB9dbD/PAPZfXRV5amSxQVKYz4eaJJ3It6AmZRisa9RAjCJEAnDv
         nvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407211; x=1713012011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DuXv8jLymFAc3dj84mPa+u6v5joW+GUy7CVoN0Mom8=;
        b=U2ebr1ZEYdroeBs917nFJTEHzxUKKNO51L0hDSLEaLCsriZwj6A5ExMSBSvsN5sQpt
         UBFhmfUf8b8DNfMEzmG10R/qwluybhlNvNzNY7tZb5+ZzgC263sK832n4aydnrGlq8MS
         A9QldYwQyAUKCrXDfixbC6bLkwEC1aay2ei2gVR+AG4B6YBKUf97TzAiR3s7AIKZRpWv
         PMcGHvpGyvQQn5Z/uxcJEoWlAy7u9giD794B8xipjWKNPo8IPthdR/vc99/zdY5s/AtY
         QdYKP43e9SQ53L/BWY9FUOWdIKXiTdnaWKxG+lQk0C0MvTr2qz2s/OrhRbOcYYTqZk07
         7usQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6wzgmsnHYmUjzuUJ6iHLsX/Eh3Ecohel3aXO8m9Xe7ko1e/LJGjF7hPM5LiNZXwSBM2Kx0H1a7eFfWtz3T5nup5h5z6k4QSUkJE++KXBjy2W097id5gcu/8U9Aj5IxQ==
X-Gm-Message-State: AOJu0YzoGXr+uP+H82f8oq2/7jILOMC8TPW/dBDbAFbZA5tK6wKIjx4t
	GLHgc1JzfSpXsnf3tq5UPBEHOK2nXqaYtgR/+HsHUymtI42pD2RH
X-Google-Smtp-Source: AGHT+IEG5DwuJ6rWhrJoMat7kd4rj//Ns4BzAmacd0b/2q33I7gOlOkW3W7COJMdw+lJbq3lxrimmg==
X-Received: by 2002:a17:90b:1b04:b0:2a0:4a82:5b05 with SMTP id nu4-20020a17090b1b0400b002a04a825b05mr7263902pjb.19.1712407210832;
        Sat, 06 Apr 2024 05:40:10 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:10 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 09/14] shellcheck: Fix SC2145
Date: Sat,  6 Apr 2024 22:38:18 +1000
Message-ID: <20240406123833.406488-10-npiggin@gmail.com>
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

  SC2145 (error): Argument mixes string and array. Use * or separate
  argument.

Shouldn't be a bug, since the preceding string ends with a space and
there aren't any succeeding strings.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/efi/run             | 2 +-
 riscv/efi/run           | 2 +-
 scripts/mkstandalone.sh | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index f07a6e55c..cf6d34b0b 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -87,7 +87,7 @@ uefi_shell_run()
 if [ "$EFI_DIRECT" = "y" ]; then
 	$TEST_DIR/run \
 		$KERNEL_NAME \
-		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
 		-bios "$EFI_UEFI" \
 		"${qemu_args[@]}"
 else
diff --git a/riscv/efi/run b/riscv/efi/run
index 982b8b9c4..cce068694 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -97,7 +97,7 @@ if [ "$EFI_DIRECT" = "y" ]; then
 	fi
 	$TEST_DIR/run \
 		$KERNEL_NAME \
-		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
 		-machine pflash0=pflash0 \
 		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
 		"${qemu_args[@]}"
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 86c7e5498..756647f29 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -76,7 +76,7 @@ generate_test ()
 
 	cat scripts/runtime.bash
 
-	echo "run ${args[@]}"
+	echo "run ${args[*]}"
 }
 
 function mkstandalone()
-- 
2.43.0


