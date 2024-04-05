Return-Path: <kvm+bounces-13658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A449899800
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 445A02887A6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3863C15FD00;
	Fri,  5 Apr 2024 08:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnS/AYUN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26DE15F33A
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306221; cv=none; b=hNUiUQqig8uPxplgDWlQEY7s19rNkOaLTUJR/77P8rm9Dwmk2ghZLls7nAsgQiyw8xflPV1u++kGSy4GnqIYgvXLk0J6u7nxWrIwJH+q82IYa3AfqMuccLJqRLIvv8eEw4jeKra6Zv27G0eXZ0Kfl899Lu+e3hdWI9/V/R4bOug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306221; c=relaxed/simple;
	bh=IyvEGazAmsLR3qiEaCHJ2HSlTYwO0yTAzoBe1/owdAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJiwBRgYXFAr+bgsVeObta8Nxa/ALdij0uTdghXSkGZoMbUYfC0xDntGOEtX8DA04ZA0MGPWdoxT0hGNcaneAzqvzQW/+9qK+/kNesMV1oJhw6/2D/7KoPCnyicdaaJobb3HI0a/foHumFyTS+VR5cU8rXQt6/BXBODOFEUGzac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DnS/AYUN; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3c3d2d0e86dso899791b6e.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306219; x=1712911019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVYqqHarz35z2bPDLkBdM4mE9lu/iFPV0s4V9UaHozw=;
        b=DnS/AYUNW+NZgECOmVeMz1mjBIWo8BRnQqyyFIZpy83Mc2iD79PHKM9ZpQ64IZBoXn
         bQq1Z1iH1Rip/R05An2doVCOtyNcS5gagG+ejXoDORQMfaTe8M0DnYZ25oPCW2J7ZKcq
         LkIXWkg6ut5eGaQWazEery/g8J90RQ6UmmSWiw+mKv5XS6aVnuJyneK0fCuZWj7jsCsK
         2WeEvl+LdDg9dfrMkejJN/Im4adnayfydKR0RMAVnG2yUQcPbxVCbWts2vDSSC4D+4DI
         2Xmj5tOspfIQR2b2r76WAQaiasCTd7dsQEHQchidZlmV8VuCAiMyDRB+lLK8m49+/Pm1
         lIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306219; x=1712911019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVYqqHarz35z2bPDLkBdM4mE9lu/iFPV0s4V9UaHozw=;
        b=Cmf+rtXAUcS1GTc4JQd/NQBOK67kB6rXKiPzxO+N9gmz80NP+7x3kD693sX0c3V1NA
         /m7mn09exFEAZREh1mszU0NyXqyjOJgiYwbTX+EPT0hdN76U+txdGzMkGRprdM2qM2YV
         tlScjheU60jdYmIRZacux+1Ty4KagPvGH4+WPxCDG8q0ZqkBsBHXpfwmZx+wjh3heXhM
         kg4PcPvcStUkYaXS3bOVFbTbnG1ZR3T2PgI1AolNsVx4/BMfYl4L1FTqSpDsqsFsvZCJ
         LopBpc7xoN5M2YBVxXJIPLbGyi45nqVqe/dqLGdOOGxbIfAor6lf64Elz8rs2lTKjp9+
         nRiA==
X-Forwarded-Encrypted: i=1; AJvYcCWx+3P28+z5BovlrCRgD4fRqQy1CfbkZZEQdMvegrgUKs1Hwy1xX2P+Zh4hrKxFmgVzA9iUSrgj8V6yduJQ5V7Rl1U8
X-Gm-Message-State: AOJu0YyOXKbn4TCo51slabv/eHyPW/+Iq6gKK8nyZgq1BRb9O5ZPwWDZ
	QFBAq/slA/XWrsUXfFq0bCAjO63shOVSVKpP+GeymNtCeeP7kSKs
X-Google-Smtp-Source: AGHT+IGONk+2bVcU1kBsY7l8EGy3hJXmRltBZFla7gk+WV2vmkiRRpwOVMFVXS3NYuIdjWZ5BW9lgQ==
X-Received: by 2002:a05:6808:1a85:b0:3c3:d587:4ac with SMTP id bm5-20020a0568081a8500b003c3d58704acmr679375oib.25.1712306219012;
        Fri, 05 Apr 2024 01:36:59 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:58 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 18/35] powerpc/sprs: Test hypervisor registers on powernv machine
Date: Fri,  5 Apr 2024 18:35:19 +1000
Message-ID: <20240405083539.374995-19-npiggin@gmail.com>
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

This enables HV privilege registers to be tested with the powernv
machine.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index cb1d6c980..0a82418d6 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -199,16 +199,16 @@ static const struct spr sprs_power_common[1024] = {
 [190] = { "HFSCR",	64,	HV_RW, },
 [256] = { "VRSAVE",	32,	RW, },
 [259] = { "SPRG3",	64,	RO, },
-[284] = { "TBL",	32,	HV_WO, },
-[285] = { "TBU",	32,	HV_WO, },
-[286] = { "TBU40",	64,	HV_WO, },
+[284] = { "TBL",	32,	HV_WO, }, /* Things can go a bit wonky with */
+[285] = { "TBU",	32,	HV_WO, }, /* Timebase changing. Should save */
+[286] = { "TBU40",	64,	HV_WO, }, /* and restore it. */
 [304] = { "HSPRG0",	64,	HV_RW, },
 [305] = { "HSPRG1",	64,	HV_RW, },
 [306] = { "HDSISR",	32,	HV_RW,		SPR_INT, },
 [307] = { "HDAR",	64,	HV_RW,		SPR_INT, },
 [308] = { "SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
 [309] = { "PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
-[313] = { "HRMOR",	64,	HV_RW, },
+[313] = { "HRMOR",	64,	HV_RW,		SPR_HARNESS, }, /* Harness can't cope with HRMOR changing */
 [314] = { "HSRR0",	64,	HV_RW,		SPR_INT, },
 [315] = { "HSRR1",	64,	HV_RW,		SPR_INT, },
 [318] = { "LPCR",	64,	HV_RW, },
@@ -306,7 +306,7 @@ static const struct spr sprs_power9_10[1024] = {
 [921] = { "TSCR",	32,	HV_RW, },
 [922] = { "TTR",	64,	HV_RW, },
 [1006]= { "TRACE",	64,	WO, },
-[1008]= { "HID",	64,	HV_RW, },
+[1008]= { "HID",	64,	HV_RW,		SPR_HARNESS, }, /* HILE would be unhelpful to change */
 };
 
 /* This covers POWER8 and POWER9 PMUs */
@@ -350,6 +350,22 @@ static const struct spr sprs_power10_pmu[1024] = {
 
 static struct spr sprs[1024];
 
+static bool spr_read_perms(int spr)
+{
+	if (cpu_has_hv)
+		return !!(sprs[spr].access & SPR_HV_READ);
+	else
+		return !!(sprs[spr].access & SPR_OS_READ);
+}
+
+static bool spr_write_perms(int spr)
+{
+	if (cpu_has_hv)
+		return !!(sprs[spr].access & SPR_HV_WRITE);
+	else
+		return !!(sprs[spr].access & SPR_OS_WRITE);
+}
+
 static void setup_sprs(void)
 {
 	int i;
@@ -461,7 +477,7 @@ static void get_sprs(uint64_t *v)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 		v[i] = __mfspr(i);
 	}
@@ -472,8 +488,9 @@ static void set_sprs(uint64_t val)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_WRITE))
+		if (!spr_write_perms(i))
 			continue;
+
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
 		__mtspr(i, val);
@@ -561,7 +578,7 @@ int main(int argc, char **argv)
 	for (i = 0; i < 1024; i++) {
 		bool pass = true;
 
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 
 		if (sprs[i].width == 32) {
-- 
2.43.0


