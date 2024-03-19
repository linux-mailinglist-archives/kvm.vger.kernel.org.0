Return-Path: <kvm+bounces-12094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F423387F8B3
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F117282D20
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D203C7C0A9;
	Tue, 19 Mar 2024 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mH4q0Ai9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0D3535D2
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835245; cv=none; b=nvr1BKnL9nBQh6Zu/UZmbh0qxyKJ6z9OQ4HuUzihi3n8bRSN9cqCH+z/q3eE/bZZ9J3JWv7cJtxlI1ABJNGqe+ReDV9EEIcGKb1NSKY6RJVxpClb3D9ZpButRIt0YnXSE5r4PLSSCQ553dClqvBe08sJ8m7LVJWmLlQaP6RWO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835245; c=relaxed/simple;
	bh=fHxPWifiBlMDHDN66yCuD/ls2/UF7jWTcC7A9sa7i74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA01JQtkxyJdIXTHBXpdOSWH8Ah/ke8ef+MF4cwARJtaX4mfGDLJdfhyLI4Txo/F/zwCLgBpWKy0+fgn9GRWAe4faJwemUInSnHrntM6Xx1OttZGb3PIY5aDqEQwFx1YIz0Vp+PrDJm7t52ejIbs8PgxKpzMPPFv03G3rUHYMgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mH4q0Ai9; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-59fdcf8ebbcso3240982eaf.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835242; x=1711440042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56iBudlm9U8d1gus42bi1dKHG12FVRnvk/I1w3JRqyc=;
        b=mH4q0Ai9vTo0qM+dmGoQEroqlTYOjrqm5BH9R0TO0yDTA1bVOCu0FabEx7czQ6vKEu
         z/D5v4d03P6gjtDS5YlnArELreRR7iIm5sbuKClivRZTCjr/kZJz28vaorKd42FH+97S
         xHAdhROIZv+XgcboSFdjBk014wZf97GoyR33MLS0aSMHAFLmIKpfu3nR1BXSoyzWnDFL
         5EZoYKXpQH+wpT+TNmdPOu+pn1Ee8UF1oLc5iaKuoJZlK8mlnGjw/dHbMrA6TvNuU1T6
         Pk5nA3aYlG5xMEuuIZNjjU1290Snj6oPi1pDOZ3mbz0vibBbdq8lnSVw6fxGmTfteVB4
         XMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835242; x=1711440042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56iBudlm9U8d1gus42bi1dKHG12FVRnvk/I1w3JRqyc=;
        b=iRB3P/UdFeSDnQwoJRb1653v+TBzjHXq29o9Pk5Y6gSX9L5Xm8dNACOVnsRrZA9pLK
         SNwcjz+aNuIqaDJ5TCkHrPV43E1IEunaOkYMXsoC74dT7ZpUYdL7G1t4aZLTCpNHyxiM
         uUw+YRWTTdOgTwVBMmVEKuEdRJZXJ871xSxKQXU48LsSO+BPCRA9i5eUZaNvYBoZwvOc
         0+WOPRHrgW40U+MkDSv/YYF5a8HaABF90iuVo0df9i6dALrE37CJhG7NK/WU49u6v402
         Kgh7HEj5B02Yg3B5vlEvc1G5FPs9pRQBcupa+XOgjxhZ3ah5wCfja/7q4uPkR2UYUMU1
         QpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6AKchViF4SU3d/jVovsf1nAQWgBeoOzn0v4tsRL40EjVtCiEIYdb9+mzFxF9//9LJ6l++rhva9xUYp6bc53dTBTeo
X-Gm-Message-State: AOJu0Yxqq+zq1QzM9ZyIQsue6o2R6VexoJsy1GpnFI8HNPXFtz5qQsoP
	dnHitWBF/VCmx43Gzu7kEGNgUOQA84PCiTmplTgxQtj42ZBhUCsQN1+tE/UoLuI=
X-Google-Smtp-Source: AGHT+IENcluRYOn764yX9kdrqhDitabVcoLdDZNFBA6m80FQCe8kH+MHmByOwdqnFMJLcUcM2UVYxw==
X-Received: by 2002:a05:6870:40c7:b0:21e:b2ee:75a4 with SMTP id l7-20020a05687040c700b0021eb2ee75a4mr1948697oal.15.1710835242665;
        Tue, 19 Mar 2024 01:00:42 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 18/35] powerpc/sprs: Test hypervisor registers on powernv machine
Date: Tue, 19 Mar 2024 17:59:09 +1000
Message-ID: <20240319075926.2422707-19-npiggin@gmail.com>
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
2.42.0


