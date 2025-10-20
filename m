Return-Path: <kvm+bounces-60510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A84BBF0DD7
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08A3B18A2C45
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9F12FB601;
	Mon, 20 Oct 2025 11:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DykTIx+K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE41D63D8
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960131; cv=none; b=mG5t1WVFsEZNDxSPGgfAfFSmWGS5wFT8BTyw/YcWHtNbIQFmJYzJ9yTxMeLm+B1/0k4GUezozq3clxfbTShKs3llPMwM8qujW/zLPx6KsLCLt22QtIw9gLYyJ/rlZGtL61egUYMR9gI8rVXGaLzNEnOiO6smB1rPbkDxLjInskM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960131; c=relaxed/simple;
	bh=tG4i0E2xHcullbux4jKDu/LPgS6glg8S2cgGHOgq9Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEuA6+fyvKiL0THD2VT6PQ1U+OHPrfS1/ixJtJSY3G87NYG3HZj88A3x8Qa69SMPjNfTlVVdXGMZbQ7T18nGLMzH8HKxczJUWeXW0yrnDMn4gt+VJdRNKpKda2xOpMAg1/QII8+1Vrt8g6jNIbdsaI1c2sgyAjMxKtEs6+mUMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DykTIx+K; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-471075c0a18so44970545e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760960128; x=1761564928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAkkZcqWQBPqLRoYMt3hCTfFtTwm8REFlMaR8FUYzOw=;
        b=DykTIx+K3O+No7Z0sb4a+WpjhAcueZE5GREoXUCWSTuF6Ohtb0LiMnbJEv1DBwDTb2
         tlLjn8QN/7gn0C+YaMfh3OGftqNgVrkUZonymHTQqKIb5Bs0Rql78za2fH3vaOl9BkIU
         mLRh2AgyjXABO+AjxKPK1UofKmLYmh5q9o5WJ+lAw4d5INW7yQ6DIDcYAQNAX8ZPAzQx
         kG1vi0UPnGFQ4n0A0OM4UeomMCqIHDRbwJ9R9hjvRXzcUfaJJNT7XgDgrcXWjEFC4lfH
         SvT0+SNsEQZZeF14ZnVT0cL4ASvRTEfYoRcLbRuL1YpUI2bjWg4a7F729xKcVjBuNXB/
         oEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760960128; x=1761564928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAkkZcqWQBPqLRoYMt3hCTfFtTwm8REFlMaR8FUYzOw=;
        b=fcMlXJXBfchN9apT82o1z5tyG2Ze/zmzrUSYiLSn5ohbO3aMaEQ+jf16tDjUt/k2Gp
         H3DJ9ugVCExvppCRgCW1zYjznj9cDvkwsPXXltWoeFp6ylNXsjpZYXlWzwj1aT5aXpIl
         op4SzvbiBrVodkdUdTU18wztYeNSYuCtBbXqg2VkGOq/wKE+vEa46hKVgIDgazXkomqN
         ypVq6y2OSMP4PAgnz7imWWbyRhCdPIWa8t6abZKxZoLu9gKEGh9AVRUX1QjmdiF4PCzZ
         07R4rcJfkO5gl/LaBxemz4mdztt297h1/X9myRkluhymHUjp45tTnV5DSxmsmXChFB/o
         vCjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgFEa+l17IoOwepCJAndvBSLsC6HETU0eAhFC5PfDIKZoHPKv967xHQzxMQb6F3CSBI3w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt/yEDfWnOpg0DUnsqVviD7ro/FMk34zV6xZtus2MUoXM84mPV
	jMYrCW/M8KcAglv6lAcc5FshnOdXzGzy4q6irHb21xp3aIU3vZGnnZ01sIoicGz3B8I=
X-Gm-Gg: ASbGncugKQ9Kag1pPR5basfcyedH19ff78/bvf6ohlz6snikFZrxw5zgW6Zk6gyOb47
	W7K2Pl7AHJrwnaLQQSFZTNCUC1AOxs5/9DUJkr7s5H2YZ1AhGdPWtGKc4X6RNViHBmEDW/gQUp3
	M/b7CFOzIRLs7YWKY7ltq9YT4bht+Ulg4nwdw1fcfUxPHP60Xjk19LgAIUMEjkAP1oVDpIjkWRb
	XjjfolBF4YEZkDM+dinhZH22crot5AhfVYqC/UPoAUWOGtZlEn38wsY+Yo3ELjp6GGPIyIDAW6H
	0yai/oMXTv/mS8rKzhIfXvL53HImU722hcrBhvHR2cbMi6Bon7p8h3LQTbjSfaYGwGOhEo4AL/x
	+ENdqLrrzbPFkMhBCSmEcKZvPGY9TgHx0KfuHhyei4QcBgQURZWAI0EXuom1sa4vf4faYObu80C
	MsbydhCniZcEY2/1ZQ0c1iNWdMRB14qJGWs6TvgWc1lT0NXPIhvg==
X-Google-Smtp-Source: AGHT+IF2AFfYUbg6zZHrbdDsDhS2C/ImRRjkdhB/lLsq6EYZa7SyNf2IVzSoyfvyJJ0wStkrODlcEw==
X-Received: by 2002:a05:600c:5029:b0:46e:3686:a2dd with SMTP id 5b1f17b1804b1-47117879c4dmr86035915e9.11.1760960128118;
        Mon, 20 Oct 2025 04:35:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442d6c6sm221017245e9.6.2025.10.20.04.35.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:35:27 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 15/18] hw/ppc/spapr: Remove SpaprMachineClass::smp_threads_vsmt field
Date: Mon, 20 Oct 2025 13:35:18 +0200
Message-ID: <20251020113521.81495-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::smp_threads_vsmt field was only used by the
pseries-4.1 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 82f556f97e1..1629baf12ac 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -144,7 +144,6 @@ struct SpaprMachineClass {
 
     /*< public >*/
     bool linux_pci_probe;
-    bool smp_threads_vsmt; /* set VSMT to smp_threads by default */
     hwaddr rma_limit;          /* clamp the RMA to this size */
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 546e100c9cd..c8558e47db2 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2588,7 +2588,6 @@ static CPUArchId *spapr_find_cpu_slot(MachineState *ms, uint32_t id, int *idx)
 static void spapr_set_vsmt_mode(SpaprMachineState *spapr, Error **errp)
 {
     MachineState *ms = MACHINE(spapr);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     Error *local_err = NULL;
     bool vsmt_user = !!spapr->vsmt;
     int kvm_smt = kvmppc_smt_threads();
@@ -2624,15 +2623,6 @@ static void spapr_set_vsmt_mode(SpaprMachineState *spapr, Error **errp)
             return;
         }
         /* In this case, spapr->vsmt has been set by the command line */
-    } else if (!smc->smp_threads_vsmt) {
-        /*
-         * Default VSMT value is tricky, because we need it to be as
-         * consistent as possible (for migration), but this requires
-         * changing it for at least some existing cases.  We pick 8 as
-         * the value that we'd get with KVM on POWER8, the
-         * overwhelmingly common case in production systems.
-         */
-        spapr->vsmt = MAX(8, smp_threads);
     } else {
         spapr->vsmt = smp_threads;
     }
@@ -4649,7 +4639,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
     smc->linux_pci_probe = true;
-    smc->smp_threads_vsmt = true;
     xfc->match_nvt = spapr_match_nvt;
     vmc->client_architecture_support = spapr_vof_client_architecture_support;
     vmc->quiesce = spapr_vof_quiesce;
-- 
2.51.0


