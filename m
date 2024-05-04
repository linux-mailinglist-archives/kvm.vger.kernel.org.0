Return-Path: <kvm+bounces-16569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9798BBB3A
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC15B282B12
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213F5286AD;
	Sat,  4 May 2024 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejT8++5o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC122F1E
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825756; cv=none; b=HbLH4a4aS36A4jfLJFuwrv/sT4vThmg4vegBKOEiWI+Q5vP0JXXit2ko4punqC9FM65gSXKVEkUfgK7HtQgMiqxns+kCVxtSAsQrqbTbEiFDuqvjOOwPuL7b4q4gR8g9VSFvMZHm0j6i7HWihimCsR9c97Fm5iM9YtyZjsBrCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825756; c=relaxed/simple;
	bh=Ey2vi4gQPPUWsvoPQ9sgGcFts/Ja7OoxQpZLS4rGSc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIYqfo2SKrKGJt9eIQqFXQKauuk2dvWqD5q8i+EFU9TFkE+zyJqxMRuUHHOxm2hp/OBry5t16NWDOYLXUrcZ0y/v9ki0cPVUTAouU98Ol149WlhIA2zOeOzI4FD6y1U6+nxC80F6KRVA8eRPLS1TD6NNaesgRTmGpF+yPXt6Q5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejT8++5o; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6f44d2b3130so512165b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825754; x=1715430554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLJ4F+YKrXLreQDqYuCgCaOGHgxIONW/HHGxnZQi+UY=;
        b=ejT8++5o75Z1Z82LUyc90LCDv3Y6fgdjRHY5FkNpDS0FPGXiV6CUfu2WNLayj+pWag
         cbkp3QkGbH0vASlGyX3RzM1MUHFsvTQ38D+zz0oIxYq2OMLm6syxVdMct4TQ4yV30sCD
         VRtPAJVJpQ1g1X0la63cF+f6xV72qusiH7My3J016x9GNdIp8+dhnqilDo9Y5D6+ZPoW
         Gi5RmSX0IlYcHNCQqRrzfrt+eRAyUHQGr0wOM301wE2ZFbUI/cXyrdDdw9aVxKB2jjxC
         7mQugTGQJEekdeVU+B+7bzbByWC7sWo21XjpHkRIYWfCgxOo1ISFmUF8Q08P1kAmBTaE
         R5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825754; x=1715430554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLJ4F+YKrXLreQDqYuCgCaOGHgxIONW/HHGxnZQi+UY=;
        b=FbH9nddH1GcTm57E5MY8Zms9wcgTwKsdkc43moBURaS4XoHm4ibc933NQaY2J3293n
         jeLBJOhfdhJQdzpFNMcXo9J8jhvrTm2EnqHvFxMRcq2TKKTo9kReTN0tCX9ldNQUJ3jQ
         52BO5evXI8h5KgwyALHYnocw7Z5Gyn/3BbWaV5Wws4UhLfQJlDOgA5pdnoGVCAvbUcZk
         MVpXjjm2WfiBlMnCiv8xvEKuGbF3oCmh6gp6hSUyGlujlzNUP0onwPNrA0bxRtlLdJy9
         0M2jwxHgrzWu6oGzs9HCe08VktZMMc0J2jyhkjupHS2vMo/uks4gvwxrii3DiH/PczP4
         EvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnqvkLU0xWzxHUCdFnh9wBvbrtSlrNfZGQTs3lTbOKtoDN3/2C/ECyhnXclREFu40IW0dE9OdyObbjeuC0LICg0AYy
X-Gm-Message-State: AOJu0Ywu8iSQKNgrHCPwLLb/OK81tokALlaR7fMHzVhr/NCvrga6x9+W
	JwCy3k0EQYIdCU5r/pEIWmHMrsyLM7tluxpS43GlH1ZcxUIKcjkl
X-Google-Smtp-Source: AGHT+IHLAKw3BD6hW5ivGm/rKmAEyFICvMjClcsYl5pfoB1uSKJ1pCOvw+uWJkH4jaFuzAcKq99lJQ==
X-Received: by 2002:a05:6a00:1903:b0:6f0:b81f:af5b with SMTP id y3-20020a056a00190300b006f0b81faf5bmr6119136pfi.34.1714825754399;
        Sat, 04 May 2024 05:29:14 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:14 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 06/31] powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
Date: Sat,  4 May 2024 22:28:12 +1000
Message-ID: <20240504122841.1177683-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Storing certain values in MMCR0 can cause PMU interrupts when msleep
enables MSR[EE], and this crashes the test. Freeze the PMU counters
and clear any PMU exception before calling msleep.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/reg.h |  4 ++++
 powerpc/sprs.c        | 17 +++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
index 1f991288e..c80b32059 100644
--- a/lib/powerpc/asm/reg.h
+++ b/lib/powerpc/asm/reg.h
@@ -24,6 +24,10 @@
 #define   PVR_VER_POWER10	UL(0x00800000)
 #define SPR_HSRR0	0x13a
 #define SPR_HSRR1	0x13b
+#define SPR_MMCR0	0x31b
+#define   MMCR0_FC		UL(0x80000000)
+#define   MMCR0_PMAE		UL(0x04000000)
+#define   MMCR0_PMAO		UL(0x00000080)
 
 /* Machine State Register definitions: */
 #define MSR_EE_BIT	15			/* External Interrupts Enable */
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index a6588ca63..c25dac1f6 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -476,12 +476,7 @@ static void set_sprs(uint64_t val)
 			continue;
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
-		if (!strcmp(sprs[i].name, "MMCR0")) {
-			/* XXX: could use a comment or better abstraction! */
-			__mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
-		} else {
-			__mtspr(i, val);
-		}
+		__mtspr(i, val);
 	}
 }
 
@@ -538,6 +533,16 @@ int main(int argc, char **argv)
 		if (sprs[895].name)
 			before[895] = mfspr(895);
 	} else {
+		/*
+		 * msleep will enable MSR[EE] and take a decrementer
+		 * interrupt. Must account for changed registers and
+		 * prevent taking unhandled interrupts.
+		 */
+		/* Prevent PMU interrupt */
+		mtspr(SPR_MMCR0, (mfspr(SPR_MMCR0) | MMCR0_FC) &
+					~(MMCR0_PMAO | MMCR0_PMAE));
+		before[SPR_MMCR0] = mfspr(SPR_MMCR0);
+		before[779] = mfspr(SPR_MMCR0);
 		msleep(2000);
 
 		/* Reload regs changed by dec interrupt */
-- 
2.43.0


