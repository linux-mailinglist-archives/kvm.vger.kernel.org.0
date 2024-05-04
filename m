Return-Path: <kvm+bounces-16574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814178BBB40
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36F1E282B1D
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE4122F1E;
	Sat,  4 May 2024 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9HELf82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35852225CB
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825775; cv=none; b=CAK5/khbxMaY1KitoghWySuem9AH7cFChf7Xav7KA/X6wT2AfT9uN4xQXY6GhbcYUBtvlRIn2XwWGpyJUanClwPAA9En2Rofkmqgz7YFhZUXMgFPkCjHiTX4ExO4QCT/DsR+3POpdFBHCLRBAmGYD5axd5MtRiIFYRzQUN0oivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825775; c=relaxed/simple;
	bh=7fQeu+L458wsHH/QIPBH00RMuFPMFW+HGUqffLYKiGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+vB0k5x6gTEbhS31SGHK/WUNsWZc11xBMJhruyrRUT/vL4WCStc+1a0/5UDlCuYvv/Tn0w1whHqK4oLK7/988AbDmrHDWgto7lfNhXhT28u44ZqpRzFM3oygX1Av0Ih/m70jKRuf6E5irNf6d6ySJ5QHC2gkhiF4Da/jE037a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9HELf82; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f44b390d5fso512131b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825773; x=1715430573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KL3WN/bxkH6E8862NdjfyN9j8TIYfGdUkTmziJ3+E+4=;
        b=B9HELf820F+7XL5K76YSImJq0lLBYqY1JiXKpW292AZ5aJH3Ehy/VvIgflcF9zBaGQ
         XetkpONz+Rec9XTUA6kHvM1bFbbv+AjA31EyRacHMl55wp3XhjnGNpeJuE056FQsylc5
         9KZn9+sUIfcSWgH0mEIAhCEuOFa6lWFZvOWdanQLUry8KY8KIC0oVJKUHvr+imkaZlZc
         XW8fgMqRyxNwA69STTbdlJGEXT9Qc8VLHuL93AU+6PFhxF++VhaKFMBf2Zf/9zpz/Tq0
         fxxMspG3BVo193T3fAQDvr+cu7qoy8XnAYcvstaDeZFCx+ow5+LVCPzBlWt3h/3PUqyi
         ZkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825773; x=1715430573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KL3WN/bxkH6E8862NdjfyN9j8TIYfGdUkTmziJ3+E+4=;
        b=HWxCsJby1OkVxhBzQMIZk++fsaPLlzwIwvABhIfZpPxzBsMSTKtNr7KXOXbW3Xmi8t
         IOAAAEou5ijTHgaDKHIqLP9jGAGsZ6ZqU2hraILso7l37s9vhPbp9OYyKUK7uPk5gk5f
         F0xaJfjO0N5eSDvbddyS6pm42J6rqwoxZa+qsJ8cSFdgN1rdVzcUNA8YGEWCDR/ry56J
         xjP/dhimqCYyAL1hTvCRjUUQAjDKIGgG+xu5Q1tpahQW0RQGVNhLzwy02urAXdmlTIa8
         22sVgGHMUqUK6pAFRmDWJxOUBcusukhfZCcNUNM5ziLSqiCDj/VWJ00xqIuNeXj35gVN
         neMA==
X-Forwarded-Encrypted: i=1; AJvYcCUwBL0YLQBCtHjyTvRaczWxJbHZ+qSkTun/IzHpAZl7vp7LyG2VpHWMwJZRnUo4X2n4mb9ZMpOqOfhvZcnsbgXx8ALL
X-Gm-Message-State: AOJu0Yw4eNJipHdW+Uc71JDAsN5ySNwlPIy6qTltY6+3IeqkrXQBSxNa
	v5Ly9h+ZDJ1saaKhD0p1reMPbkLHiSJPc0CZgL4LDK/mxdN6ajlL
X-Google-Smtp-Source: AGHT+IHBmXjDuf4tcSq4Go5iahY4Ba3kc5TDtYi/Y0fd6Oj+KY7AD/7pfPGXye/+vZmLqeCSyja2UQ==
X-Received: by 2002:a05:6a20:12cb:b0:1aa:340e:237e with SMTP id v11-20020a056a2012cb00b001aa340e237emr6790296pzg.59.1714825773410;
        Sat, 04 May 2024 05:29:33 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:32 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 11/31] powerpc/sprs: Test hypervisor registers on powernv machine
Date: Sat,  4 May 2024 22:28:17 +1000
Message-ID: <20240504122841.1177683-12-npiggin@gmail.com>
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

This enables HV privilege registers to be tested with the powernv
machine.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index c25dac1f6..de9e87a21 100644
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


