Return-Path: <kvm+bounces-9812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FB48670E3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 413E528B3D5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759D15BAC3;
	Mon, 26 Feb 2024 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWWhBNAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5AC5B5DD
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942388; cv=none; b=bDlmSVDWIzUWHfXPWdA5pnlabYZjusa+844oJTRRBmp6TrDnxTcRVRQpcnAtEsDraCMGnzeK/3jyHlENzTFGeDwVWYLHN1irQcc5G8uTKwih+HK8EEb+OxEYutGjBID6e04cit1Y/29Jhd3Wp7XpWgvBiW8Vw574sds00hlzfTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942388; c=relaxed/simple;
	bh=jBlhbk+6lZmMF7ngHiKUuEBiNalz5eyJTv3Sg2WFYhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gghU/2xh80blm5aEb+ILS7AyFUYE4OKusm7Lzynnuf7lV/zsE6vP+5dg0mHu9yeoZbeJlEj3BRsGms4UAMDARUS7wCWzseePrCYU3zEvVGJSJ0u89BqJMpBdfkH1Tn1430BLqzhie53z9EgvNrzFMt8vTADVXduWtiHR71IEQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWWhBNAx; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6de3141f041so1632890b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942386; x=1709547186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jAuqrxMcZW4wl23iP7z8CzJrLIJVN3gCB9fphF+waQ=;
        b=jWWhBNAx3lKmnRoy/GvateiV5KYN3VUOlsPWjM1pdl/IMOxrK7eBb6wsDJ4ah8V32S
         afD/ib2wC5TFvOcG2SBABkfgVpIsF99rS95YXCf7VaSsLbPn1o/9FQ775+gAb9tx3rrn
         VwN5hltkhXGmEjsRwY4udaNO5eRsx46eCnoyUhXaZopvX0QawMAGsvbFbnEpa72Q1OCj
         1nhUNVpwt4Lv6KE9okM+ZhCHq7cpaYqY6nfM+MHFcM1MPqUpHXdWGW0Oq0CGjH2UHe68
         Lv9ELwplZUEg4BS3kOju0XeEUZ7J/jfVZ/BiXFXsPTqDW2+gIwG2gkQnDSbopYyWCNpE
         9JvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942386; x=1709547186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jAuqrxMcZW4wl23iP7z8CzJrLIJVN3gCB9fphF+waQ=;
        b=DODgrceNnKiBsTMwt4GRxlTzekE8gqqd/ecppPbQA3789cHpzCtkhlNYswY+XZmYSy
         j9M+lFwkwQsZk6eBiRmtuy4LiWPjzyPT3fMgH7ZQrzOqHoamueL6wc9Rn7DUTJc5tKoM
         L0WpUJ5jgrTARpaL0K66wyakS5DfQqeWz8NoyYEVVQCgygMMH3wjQ7VRUStBqfuHsHX5
         GaOKRPmQC/Zvk8jzH+fB1LRLacgJkN54nkK1myiPSYMJv+VmBqYCTMjVshmJpa4zL54M
         gwJNMjBnsnHia+zx5ypg8UyD+qg5ur4lyyGyakCWCYJAmivzWzYrFbAfQaNHsNsAeJXz
         N21w==
X-Forwarded-Encrypted: i=1; AJvYcCXbhFcQ8qdYPPVFSB6iUFjpI6paAVakKXAqS9JIDkNn46nupG3AqylEfFh7dzZ3rHeYeWRBvsaM4pRpegm0NFKFfeAZ
X-Gm-Message-State: AOJu0YxwRAoS46VtgRK/7wigj/3IQpp6ZhXXkUEMA3l6pCL7Ie4eoVwl
	j/QBtdNmJXEg3QmlxNcQ2PvkN0s5U/xsDQIRdYZiXD09j8ERSvt/LeEvztTV
X-Google-Smtp-Source: AGHT+IFx6C3wv07L2DjnRHJQeATNcvuoKZUoZcB0ZDNHuzcUbtvukPfSOqP0fRfztgkY099c8H1quw==
X-Received: by 2002:a05:6a00:1817:b0:6e4:ea94:3625 with SMTP id y23-20020a056a00181700b006e4ea943625mr8337098pfa.13.1708942386575;
        Mon, 26 Feb 2024 02:13:06 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:06 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 08/32] powerpc/sprs: Avoid taking PMU interrupts caused by register fuzzing
Date: Mon, 26 Feb 2024 20:11:54 +1000
Message-ID: <20240226101218.1472843-9-npiggin@gmail.com>
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

Storing certain values in MMCR0 can cause PMU interrupts when msleep
enables MSR[EE], and this crashes the test. Freeze the PMU counters
and clear any PMU exception before calling msleep.

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


