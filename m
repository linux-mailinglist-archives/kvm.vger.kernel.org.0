Return-Path: <kvm+bounces-12088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB76C87F8AA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C9B2B221DD
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2E2548F8;
	Tue, 19 Mar 2024 08:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N21fKVeT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB6537E1
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835221; cv=none; b=mTIRnwmkICIjQxlAv4kRL9e0gmHHDqQO6A53zNRV9LQQ920lj01wRWFWJ0GxbuQ4asZfb+YUO5B9MYvk8tGPK+ak7suuCf/41emM836TPLYjSMTfmFRE7YPpwZm1Kvt67nuO3fhenAMUTgPX2RHgkO9h0RDiWQ0FhgHrf4WHgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835221; c=relaxed/simple;
	bh=tO+frPY5DM1EE8eWVVUQhA1w9bpleNl4bMRIxRc2SyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D573o9YMllCLK62JMxzYl86EU4cXtzPP4nG97tSJskMYjANh+D+fxAxIu2kjGOEUTTytPrS/R1aPTeJLULzBLZpIr+iRggXgyg+z2ZwE3o/kTTdYthEGEy66KfvmQaJURqmihsxJQGDya9CG+rXzGM3ceDZAO/cUpmt3hqWlyhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N21fKVeT; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-22195b3a8fbso3831479fac.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835219; x=1711440019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izEPUDLrTWux3hhd+DYadQTbCcRPUPa7uPofKkjLRfw=;
        b=N21fKVeTM+oB9hFTr9NmxVn5NX0KCu8/xwJobPwyeLIPlJeNswWzJAv1aKmhUZRe6h
         kq2cxvNAhaUo0MSlKYLgiD55D2m+P0IVOvjvNiTKRNY2S7oea8NNB45PoA/+QTj96dEV
         tNNz1An9QI8CXzGRiSrkQKDS9xgpsbZOyFxSyV/v75ANGwjmAGRKePKh9s2yOHihbxQm
         oVLn28qK01j+IOn7gLJ4OzGmyiEHgMJ0Pg19Okgq3+fiBLmMrvE1uLZCAGNs/DLihrE+
         0s2Ley8T/eSAzxzGmdyMIqPqEqitypEPhn0CpdpOyFLnuwq/Nk95TlO5xwVAcGYIc9ZD
         YQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835219; x=1711440019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izEPUDLrTWux3hhd+DYadQTbCcRPUPa7uPofKkjLRfw=;
        b=FBrMmSlOPVFvd477kaAIP8fee+q3H4OQlx79GwWlsAH8eEoXuAEi92tEkKKYH0mvmu
         9GpjRjxU4T/p6ofZB1z/pD+m/8zALLh4Qdy+Zs2fcmvKEMrFO51V/eWrMQmapjLiYgYO
         ud9ep04FmNg7RK5mDPIcYzp1aUpCQhkzvJaa2l5BTo4gGnYO1EjyT0IZmxhr6l7w/IbV
         eX6WEvDKrYlQxxNvCyRYjJvYhP3pLTG/rJisCHIjoNiPcycyYFxawki7kHq5j1beQ4Fn
         42yjsPzDdw99cPLxAS/Ebv/8YTVVJK3qb+Zzl5BlxUQ7K6pnwGJ1RacyUKKGAS9ttXUR
         Hilg==
X-Forwarded-Encrypted: i=1; AJvYcCUXLmOhM0iRRzg4++5gNnby+fxmmkBZGwLpf3aGxRaThqppZDN+D/0s385bqku9V20mdbwmMtssMmTwK4yeS1yvzAvB
X-Gm-Message-State: AOJu0Yz6H3E4KfseUz+zNobokY+k3YQQmxEuhNPgj76K0cQVpMFisVkJ
	YcVuNymrKwpA6s7SSpl8/2aA9GgIkwBcbD/D+n4OVJdtISYtB9zXQTjN7I3TwE4=
X-Google-Smtp-Source: AGHT+IG6AoUV4kxb29g3tkOeDbXZj/QPCcaJ2eebh/M0r60HpuDQrZKe9HHIFG91jyt9Gi9dH8DNRQ==
X-Received: by 2002:a05:6871:554:b0:221:14d4:6ab9 with SMTP id t20-20020a056871055400b0022114d46ab9mr16702195oal.2.1710835219241;
        Tue, 19 Mar 2024 01:00:19 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:19 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 12/35] powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
Date: Tue, 19 Mar 2024 17:59:03 +1000
Message-ID: <20240319075926.2422707-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


