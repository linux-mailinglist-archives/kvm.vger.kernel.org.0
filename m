Return-Path: <kvm+bounces-13688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D49178998E0
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0489B1C20C58
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698401607A6;
	Fri,  5 Apr 2024 09:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edQelarB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A5C16079C;
	Fri,  5 Apr 2024 09:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307764; cv=none; b=QREMJA3jPKNeS/umVhGgXElz4Dk9DY6RCWa1AW0e5HBvUMFNirDOLOmEcHTGz/48cOOYJs45lQKWdGr2Rst1THCyu7klOhj91vwlAF4z0z+LnJYdIlHkCdN4zPQ6H3C9pbqwFb57Aq4zPo9U5kbPGxOjHV2j3N6+jT5yoIsLkmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307764; c=relaxed/simple;
	bh=pE3HfiIGEmqFSFiLu/iGrulwEbzK+1DappCu3kmRLRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoNOhZexxsOAs0u/fbdfz8AVE+2OQoIGep2xBOkJUJfHEtyE0P3znVmV7QFWm7uwMrM7RRyzogQicE6pKclgaucnbVdrFC/E2ZMcd4NdZ3ObhY8BPWFrxBaRlvREVGeNHPdBzgIB5vGLQ4DS0SB5QtkEx40N4MsEijDisA3ATPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edQelarB; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ecf406551aso1130359b3a.2;
        Fri, 05 Apr 2024 02:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307762; x=1712912562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oK6zod+kpdXqaCAT61YomIe0gTSB8IC96Vd/WuMdYZk=;
        b=edQelarBqxBVwF8JANqus6D2id8ay616sHedrvFCcImRxr41tytyvk5UeLrKDbkVow
         MADgTKpsMbL9pXM9OTiZV+QYzeQMgpdD8p+pM6+uUYOMPb7DEvYwsF3aQMzG+5esM3S7
         TLytQF7M/7LhS6Yt1X2knQ9tnxfoF34S/elZEDgb/FGHtKEajrgreXrO86eHHUjnEUFu
         lmThg8sKtbenkKYxhAcpewNQpoCPJfzs0EfMdnVxBv57KYdd5RlWPlFH5uWXqUNOMmEZ
         0utzL2H3ANmbu7KeOdXWMqULa2qd1bxsMMcfuYYEzwohiYu9diW0hK67h1q3J0MJ7QLs
         FeqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307762; x=1712912562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oK6zod+kpdXqaCAT61YomIe0gTSB8IC96Vd/WuMdYZk=;
        b=mJtYOHUMXLPkmP30/d9fJc6Cz98BF396M19hFVTWLtBG9wPxBEIUy4n1WwTIrYWuVJ
         mvw+h8DxAcNdR1FN/nRyxqs8Fx1aVRRVInzdDJGZk8v2TXRcEINqrOOgC2sUSAlV89ga
         vuP/2FcqBeNaebEwRBN+pBaAIoEOUDca6GevlHzA1cRcxuaV6WjmeeSreiNUr5nZ1GRS
         b9Unh3eB7woSv6Qd42mLd6VAibgfd8s88jrJrvnhDB8xh0bkArx11qCq4dVI8eWiH6/O
         g6mE4LfE7Mt7baEnBX/JDZFlWldsLDtBrHtMn5uwH+l8Gi9UEAhQToi4OAuLTFA4w9Vd
         vMcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtUA8YZIY5l5oV0DJZmflBzOWSOOmzKvL+mUu14poincbJiULkqFwsHoOPm71/yopzTrT2eXmCeHdA1HvmV3ZGhwyKjEjHpaR+oV2YfURaQNbyav3FNvslsVRK3qfvww==
X-Gm-Message-State: AOJu0Yyw6FmX1csR/yxQmH5FXYW7HXfj3n/3YLjz6c7I11UYrhjsbzoG
	8bAuVZVQ7pgyTutqzhHNzqSQ8Z7NE1XUzzQ5jYu4yUnlIIRNsFdR
X-Google-Smtp-Source: AGHT+IG7JVb1s7kMZIVcxNaa60h6q30VL08nNHdeaH0PUwUMxshI28Z3r3tOvqs6XzFQP44N1cvSNg==
X-Received: by 2002:a05:6a20:6a09:b0:1a5:6f67:3f63 with SMTP id p9-20020a056a206a0900b001a56f673f63mr1142804pzk.0.1712307762482;
        Fri, 05 Apr 2024 02:02:42 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:41 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 11/17] shellcheck: Fix SC2145
Date: Fri,  5 Apr 2024 19:00:43 +1000
Message-ID: <20240405090052.375599-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2145 (error): Argument mixes string and array. Use * or separate
  argument.

Could be a bug?

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


