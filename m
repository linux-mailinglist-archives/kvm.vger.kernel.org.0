Return-Path: <kvm+bounces-13692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 420038998E8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73EDE1C2114C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C579115FCF4;
	Fri,  5 Apr 2024 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEqGySza"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52B815FA79;
	Fri,  5 Apr 2024 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307802; cv=none; b=Gk5flg35G6glhQYamkWf1MgxmPghz0TFI3SI37yd3wgef1Y9tFtI+TY3wzPCZvWMtJO2opngG1GCT8zDdPvfxu0ygFlGvR/139k6hA8oWTwsqI3yNTM29m5lLeMudy/l7fSPtVZGk7vZ8vysNmWQKLtEt9uqShmVQItTXBQ2Aus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307802; c=relaxed/simple;
	bh=Q9N10wDNVQO2Isx1GrQkRJ55/A8RSrRwkxpCPQXpaCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHJp9NXaIFDBbnwn6cyoMu62n5P2D75aFYYCgagK8sd+on8xLwD6c6E7Vg6N9wOU/upRXAYWRwrHUwLvSTiBIQlZwVhJcdpPIzX2uVz9gSofLduwegWfdFnrQ2bT8xcm5zDqgpOr958kA0pWUG+veOPY0uqbCL7hXb7EnWubvSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aEqGySza; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecf3943040so962944b3a.0;
        Fri, 05 Apr 2024 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307800; x=1712912600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZoPeMi4EUbYS5bzq/p7KT/LoRuIgjUs4gHO9gJQvmw=;
        b=aEqGySzaKG76Quk3RLXr0O3DrrcNp8Fg8VU3WvXKwtvmmZBkZnNw8i1pb9puvzXinM
         oi6PePHCOVrfKk/XQWjAy3w1h1XPEGVoGgTQTR7v8zNJsj2/5k8R70L9zd6TYGS8M/KJ
         FzRIoXhCUHkFrsn2xceXMIONPDyGCD8mtSM2lGLG9oJItGjam1LZ1G4c8YT8PCMOPA/1
         BPHypQyjZ18VfFMRK6szrfsCMpkLGz702tNkWIfP/e5DWjmgSLcwGD23vmWMMsOWG5Kr
         IQkUDC1IY/EyKBp3yUx0i7k9Q7DEV0WtB89G4vBASBljuSvDNKZpVAjHrl4oDX7ImOOF
         cVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307800; x=1712912600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZoPeMi4EUbYS5bzq/p7KT/LoRuIgjUs4gHO9gJQvmw=;
        b=CvJu4ZV77vqmrU58EPYiccLiF4ndle4wpT3ky2K3+HgkZ3XRJdZL6uvCMEWDZeJSYx
         fP/b24dveR8RKAiKatKMuIswMmJw/IsCKHPrsCJPacvVB3375isHG/F1y/xMBBf8JlwG
         CAiRoexZivZGTtLeRHg1tBkolbT4xldd+p1AQKqmZITQ8DQIJi9ECDTxM1ZWVvBKrr1Q
         QIF+Lv8wZtOecQmE/EJ5FPKWKnYa7LufJmfiQhzoo7PQAQ421Zg873PKx09+Y75Kn5gc
         EXZPPJ9TN5TIVjskPwD6rYm67eKVK7g8P+AGp7w3/tSWaRvdHE9wAwwdR2VPVx8pVin6
         jnsg==
X-Forwarded-Encrypted: i=1; AJvYcCXIOu75DhQ3g+PxcVr+aMeeJWxwJAn635iSq5qST3pLXqPh5cw7DRCQBo8C/Vlc+ihHqQOdGBvo27X2c96dRJM9O3Q6JzfA7e4FqAxpgazXZK2BOt0SOfdLN8pB4c8djA==
X-Gm-Message-State: AOJu0Yzl4/pBUDrQFZuh1uysflmP+6yylMebAjBC7fC32QjX6x2ZRIi1
	SBuUEJDiBoQr4nESZF0X5gCOg8RP9Z7dHgvQmMcC7RFcSovok9C5
X-Google-Smtp-Source: AGHT+IGhF6M+sYBw6xULHEvA6i3LuA5ZQUV1BEY4WWHLg6fW1cN5WbIu03G3AJlZbUnpEKHDGrYjVA==
X-Received: by 2002:a05:6a21:9996:b0:1a3:55d2:1489 with SMTP id ve22-20020a056a21999600b001a355d21489mr1068416pzb.7.1712307799958;
        Fri, 05 Apr 2024 02:03:19 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:19 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 15/17] shellcheck: Fix SC2048
Date: Fri,  5 Apr 2024 19:00:47 +1000
Message-ID: <20240405090052.375599-16-npiggin@gmail.com>
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

  SC2048 (warning): Use "$@" (with quotes) to prevent whitespace
  problems.

Not sure if there's a real bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 116188e92..938bb8edf 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.43.0


