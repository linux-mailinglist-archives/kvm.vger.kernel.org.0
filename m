Return-Path: <kvm+bounces-9817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF6F8670EA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70B3D1C26BA5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668C95D72B;
	Mon, 26 Feb 2024 10:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8A7Evuu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D35D46A
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942409; cv=none; b=Bcgoa29r6MxrWDFu3uafcpMwF9hc4QGTwD4BOn+m1+QXsgNnsxc5fe3+SzDKj7nanqZu6oMTii/qt8qzDdwpthaeFrzqEQTGAYRNh//FZqt7taJ65MKVqku5fgiliN2kWqXr94C7dzk+6pKCPToFuKhysb9G2YAOiA3jWnIOF1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942409; c=relaxed/simple;
	bh=fHxPWifiBlMDHDN66yCuD/ls2/UF7jWTcC7A9sa7i74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io5l/i0bATjzxrPLkAd83mAn1++McdTFF9RlYrGHg+toVCN1Nr5KNZxo/7/BB/Nop2F9y49jjXISPQOzV/czCmsRkO/0cmdZ12HeK9Ag/QZFPuXVVUfDipgxIflRX2rSbV7b+XDIl04nMUyjWBJ0F/FqitcMBzGNh+Z67y6SqZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8A7Evuu; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6da202aa138so1790029b3a.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942407; x=1709547207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56iBudlm9U8d1gus42bi1dKHG12FVRnvk/I1w3JRqyc=;
        b=d8A7Evuu8ANkDWJGpTKJwelQA3yFH2U+1+MRlJ7+PTyMHr8tyKGXhFnUKSzATzPDaR
         Amw5ZynDEqHuVGrWuBnb0/xhA3UKHQs8git2VNpgYRbPpc1RZiuyGS/WMXKHqsrwB9YZ
         tpZIgr0bfqGD+NC0grnrw+lUYNnsQOh9T5x09eu3/54hm8LAeVBljcyzpHQy0fngwSRC
         otongLFqpLNhcPmBhuwZdy2yKOcqEvbuHZEu6jOPFzfKjC6Mggztdq8lmIr9fMfncRQh
         rFUUd6N/bM4kh/eS+Lqsf9xti8cuis4vmuhliRzbQaIyfPp9TN7RB0x2MXsADubfdklx
         +xNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942407; x=1709547207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56iBudlm9U8d1gus42bi1dKHG12FVRnvk/I1w3JRqyc=;
        b=gWhDW7M2ORV7JvC7OFk81abLT+dvQok6++oUQL21hid9bV7Tmr4p3l8i0rglbUJjco
         IpYgVOVDedSKkQz6FAyi2jL8Mg/LY8r23ST/RyKoPIO1qo0urWUxdCPVhX5Ih7XC7qgM
         fYaGUHvykJbuEs60Smg1mGLxxykKvFLWU1ArhuetnbXwm6Yx57rlpUPorlkSau0Zbf3a
         mKEQSkJHLaLepIJf9/kQcVHZYYPcoap4NwNZBIOE78DweaVotSIz2XEFk9SEfvVIZY7T
         oiHRfSIz1ijpqL0UnC2vSWsOLxad7xIZ8MjMyM4twzIn2KYpwCZv9+ZZSRBFDQAIX2/0
         0XsA==
X-Forwarded-Encrypted: i=1; AJvYcCXW/+xiAQXac1vlNDYbahv7C4uxeTrxKRRK9Ep7b+zspBM7IkWAWikoWH2s/rv4+Z5/03kfHomjABHVCsf8TsmtNBXd
X-Gm-Message-State: AOJu0YwqBX2zIIREGEFtr7lbRgk24YS9/dHN6VyEEWwZHh0wvEqhrkg+
	H0kpAIA4zPenWwGMSHSSkcXRdC4LZELbX1xAz5l3WTyjJ1bPaUyI
X-Google-Smtp-Source: AGHT+IFCEmru53h8ykn6ZFvyv19vcFj2ApRKFuuSf+y+EfsDSVWG/xsHvEixEPxFldkroBR47nCwmA==
X-Received: by 2002:a05:6a20:9e4b:b0:1a0:e13f:c69 with SMTP id mt11-20020a056a209e4b00b001a0e13f0c69mr9729563pzb.8.1708942407554;
        Mon, 26 Feb 2024 02:13:27 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:13:27 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 13/32] powerpc/sprs: Test hypervisor registers on powernv machine
Date: Mon, 26 Feb 2024 20:11:59 +1000
Message-ID: <20240226101218.1472843-14-npiggin@gmail.com>
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


