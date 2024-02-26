Return-Path: <kvm+bounces-9830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CD9867101
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC47528F8D4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EAF5F56E;
	Mon, 26 Feb 2024 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFPi3EBd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F95F546
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942465; cv=none; b=m4e0l7jZoJdLsUqCFu6BKx62KWb5bF83yxaeZE74hEq/5hZw202W01tjCxUQDtjfCYS/t6JRxE1cC5jgUkn7vWaKRsEtEUsZYwxlu/seQ1eSvitdf1BCwb8GoI9CfTN70PwJdtV6QxJWSR2SGj+lPfpqN8Y9hToHWr/8JJ84cVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942465; c=relaxed/simple;
	bh=nu4MY8BoczRigNs/SOzwzP9v1kh101w+thMmxB+Qk10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toy/OfeVUKYPTrfKFEZ8cRmCxR9cOQxol3APZtVE7kyx+J5VzHlF4niNkU5OBG2vMA7FCD6hWtW3maAG0Bcl2szP3hIRpkUuRA1YeU0/MXiDdz53CLtzMPlHNViF8jGGG+4zB1eVeiXtYvqQdyBSDnhyodjwEx+WN5zoO4UBk+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFPi3EBd; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e43ee3f6fbso2623908b3a.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942463; x=1709547263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WD4EgWO6jWpsny8sTO916nRWmkEIJB0yBQp0dWHoO/A=;
        b=FFPi3EBdwP+fUto7PMQYnt9hO8jSLHIVVdTyrfA+WNbLTR7oQE3dxtql0qTyyTJVq7
         V7hFMChTijcY2kogMxgxOx0ORKBmTxtvd1xc5ogzu2IlL+Fr+xgaD23qx7DZLrCHX8Mj
         PZyVQNTJqK/eoycgjLBzfW4R47ywq+SeEvbv/IV5Mlofav9ld22efYBZ2nb3Jpg/69PW
         JiOM9edo0nmRAuuwAd2hxDUZlA7ZJcZ5KC+vYh0B2vSuPWsgpSWZH0bi2SokcA+0PkOG
         XcLO/gfTQB8RWpCyQPIHbjOEl6jB/NsB7LAQisBDn6yX6RPxYvgJW0CMJtc4zvee89DH
         DQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942463; x=1709547263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WD4EgWO6jWpsny8sTO916nRWmkEIJB0yBQp0dWHoO/A=;
        b=R7gW54Hug86YjPDkRKPPgtsRVP1w+vF2PJ05zCVUvvJEl5/uDyV0Y0uxFZYHcoWGLH
         y13BXBNC6y+OcQCOdFhL49XqGStYWBX/Gb6JsABwRBwCcVlpPl+L+yf/ihLg5Y+/vgF6
         aRBhUXhJoaL2hFicZP522cYxwZb4WSgdn/ynDC0O4A3m8rXvLgWG8TVFAe4KPSKdWuqC
         Z2Upm4aB5tA/aCbLC5OhajYwG5KU6fz3znAe63dSXIHCCwG6szqWz3Did2rn8yb4gk6i
         EMl0h/+tngFDDcz+WT+FvGBoFP7yLb46xR3sXqTH6/KIOqIDqUOxMq1r3MnZi84eJJ/p
         BxrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpc/QhfvMs/hVMkfcn0eSxwDTt1N9jatD3DVNVQ/G8323TXBOk0OM0kTorHT+ma1w5beS+RFlA1T/0BnuJIfxSseYm
X-Gm-Message-State: AOJu0YxBlxTnixCuE7ZUfE7iwb6Wrw+dbae/pWS0v6E1IuEa9d0IXRZr
	2A1UzUs5/R+E/cJhW2Sb7BaV1I6RrDK9CyziYgfm+5ODukt0bQN0
X-Google-Smtp-Source: AGHT+IHa8gV23iRmCxzjDwE6B3Lo408Yo9xJnued9ZFME7J/7f6BXEdaCNTXLkFlJXnHIDSxz4g17A==
X-Received: by 2002:a05:6a00:b0d:b0:6e4:84db:e30e with SMTP id f13-20020a056a000b0d00b006e484dbe30emr6346753pfu.32.1708942463024;
        Mon, 26 Feb 2024 02:14:23 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:22 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 26/32] powerpc: Add sieve.c common test
Date: Mon, 26 Feb 2024 20:12:12 +1000
Message-ID: <20240226101218.1472843-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that sieve copes with lack of MMU support, it can be run by
powerpc.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common | 1 +
 powerpc/sieve.c         | 1 +
 powerpc/unittests.cfg   | 3 +++
 3 files changed, 5 insertions(+)
 create mode 120000 powerpc/sieve.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 5871da47a..410a675d9 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -8,6 +8,7 @@ tests-common = \
 	$(TEST_DIR)/selftest.elf \
 	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/memory-verify.elf \
+	$(TEST_DIR)/sieve.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/sieve.c b/powerpc/sieve.c
new file mode 120000
index 000000000..fe299f309
--- /dev/null
+++ b/powerpc/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 3ebdf9dd3..008559b43 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -136,3 +136,6 @@ file = sprs.elf
 machine = pseries
 extra_params = -append '-w'
 groups = migration
+
+[sieve]
+file = sieve.elf
-- 
2.42.0


