Return-Path: <kvm+bounces-13652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C19A8997F9
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E70BC1F222DB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCAA15FA98;
	Fri,  5 Apr 2024 08:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFHr5vFb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4732415FD11
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306199; cv=none; b=kUpEtQ0NrIAY6ot2Jq10iNMyyryfIRpki0+YQ6znugRnpVCfBsL5lTr7nUr7CKYWyPn+BySL/269xjOlQFHEWQfbEfViphqS/bewNcUUPqLYcqkQkqIHZrURvTGAZXYxl99TNvSUINwCWEHcaP6TbczuOQ8jxTbZwJcSXRfRbj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306199; c=relaxed/simple;
	bh=fbqNZZPm09BqJw/QNLPZ5z+EzYFkeSuDDGM35NwnIuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJf64oR40Kj8Bxho3IFsajNAvYkfolUaku9R8HJS1CaLOzgs+nb5Z5+PVJegVv5EEjWP78vNnsFTIv1exbguGJaFMwWF8gK+qlrULDnGtwcRQ+XEiSC0Bez5GLCxc2fXY6w2mORlyd2tTi7kFPkJWUpAfIj6t/bxIVtD8E9x9XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IFHr5vFb; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ecea46e1bfso1639300b3a.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306195; x=1712910995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyFvGHfzzKi7gHDZhJlEbH1l1spuiAuHSEsVjsjNP4U=;
        b=IFHr5vFb6ITsNDtFfwAVHRaE/Mvs8uM2Tao3Ju3318EpDZ6pOZg1duOVhRQoiGgwuC
         JBFiYCehTYtFTtJo/XV0u2GI+nyYNosmv/s1tDv+OzJhNpHhXHJ/0+iEID4SHKIxaYwP
         pTSAlmDXRFkDVvbK9A6aXNFDvd8/NHdcwpLpafva3ycs+NvZJzqOYOIAJ0n4E59ZE1Ye
         vPf4fbmnyxP6bRpS8QebIxY3O+0iLoDH7vxNwScnsFDjTsB1Ch9ZtF4MYnielnvCCPPB
         KTESH25gX5xM5lB6ubDWPyMkAbYq3+YOQsYSfHjySzEmkHSq+gk+0Ab5ROV5/LJGeSEP
         25qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306195; x=1712910995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyFvGHfzzKi7gHDZhJlEbH1l1spuiAuHSEsVjsjNP4U=;
        b=AFwVMfODWrd4/8q+il7Py2995hFX8d2NOMqkiArTUMZEqWKb79/fDDXjiG4oOWgSMW
         ea0s2kpxYw8/gLwbvaK+5LjN22ViDF0iVbaT4+kKV1NXe3f74Gc2ZrAZElF3j0wEkrbr
         n4FMDcmvM5QIgD5O+2W9EvxN8vDh75xrBhfgHl8ICiwVSPZ6aBLZa9SsvkjGC1JaJOgr
         Ki/5WTs1hb8i4pTmRT3rFex/X9U+551pyc9v4LeYawz6vXkDJCQIfcp4tLBISXAJQ/uK
         U49jLPqH0VffKDFVkKFQvcYKhVvVtt4myAkjnCghvpU5Y6zrsq+nNRsFcDfZ7212u8BS
         rCJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUogRy4hH1fKLWT9CCeDrl29UtPlH1Ku+rbPBzDrstjB6KmLR+UiNg9LKuh3bP/j391znXCfd53swSdK5GlXN59E+TD
X-Gm-Message-State: AOJu0Yyxwu7+6CSeDP61RCzZUjVr2zCtbox4whpbBXyy0qwFjFlyh89D
	eFCq9+1LCw0me2AwKzK8y9JJaXcSRwx3V/tGI1PliXT9wxcl84z1
X-Google-Smtp-Source: AGHT+IFDpih/tQljzRLV4rSNKceTY2XTqFpquzGXL5bAu3A/HOyOAwY9rjNgfnrzZrOv2inOMXRlFw==
X-Received: by 2002:a05:6a00:2d2a:b0:6ea:baed:a15c with SMTP id fa42-20020a056a002d2a00b006eabaeda15cmr848558pfb.4.1712306195405;
        Fri, 05 Apr 2024 01:36:35 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:35 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 12/35] powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
Date: Fri,  5 Apr 2024 18:35:13 +1000
Message-ID: <20240405083539.374995-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
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
index 44edd0d7b..cb1d6c980 100644
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


