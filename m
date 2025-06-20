Return-Path: <kvm+bounces-50085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BB1AE1B9B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FA3F7B0B50
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3C929993D;
	Fri, 20 Jun 2025 13:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a2l4feHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0943A29826C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424936; cv=none; b=hsTc602Qvc0qyuMFfzW4Cbmuaj1d0/7sOP2npk1XHuVwW38NJYiYe6v6sF5l67wYw4znkK7mIq+iZc8qoCE6eUiCELQfUmQrgFpLe3pc6loQcvzEgTeHcocJLBmHvNhGywqb3JnzgEg8x1w2oCDGsEP5hCyPn0X5DSK5xKTuHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424936; c=relaxed/simple;
	bh=qC65Ay6TG9kTlaZ0vDf1BJ0Nd15H+ixDWGWWGzj8DAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h63Fj00NHIBx296eKzccywD3xtM1KAtFW0LWO7KgOThMAwxONvlmjI20f7PqqVT7nIHWuuhw0kOAEiyJZenSwOmy/OXJG6zJJ6mlwYZ2/A2rS17Ygr5A3VpT3HAUvq/36Y8+lU5irzaop1CQjMhhJN5ujAUb22LB60DVAimZxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a2l4feHs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45310223677so15221345e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424933; x=1751029733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WoXZ8Al0R/es9sXpuEKkELf4IYQr/L/uwmOyRIHiR2c=;
        b=a2l4feHsJAfYecIxn/ySbiR+gAjfteRat/bPpEWF+yzJ2rVxZCW+1uedqfATpCHchR
         2MQDNqqZozgX8iWYuhNl4pY8vfhqGts7+iHS9VXeLkc17sS5zcNBK02zUBU4Eficioen
         z7upgiBC76OhiOKGD/yaLRVfzHub9clcO5LbJRbKmWr5thcQxZ075bdUcULj4IvIUwFH
         8ylyMUlCK4y8N/YXnLg/9tzGjjo7NUk0XHJWSwQ5ZVw4bvqbtDUl8zpy2Hv784JmUwrD
         JquMWiG3rtUsnRbNS+0rN22X8jMxAWIpp4NNfsHoYWI0PyyJ4he8aFrrBwKI5hh/gGOK
         +nkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424933; x=1751029733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WoXZ8Al0R/es9sXpuEKkELf4IYQr/L/uwmOyRIHiR2c=;
        b=sWC7y73q79fgelK79DAnnrfNhVH43WLg+EkS/E8DnWCsD+9FRqkU1FZivFKgYWQExA
         sSrdaxv9rMJqBStE0MmE1IGQBG5SsPiOjBkfTldL7kQsX1PrY8TMwKzTXABjwVshqIqs
         ecHGXk3xNDWRv7WUXENQXLbGRiugsWjMk1LAPII7A3ItMqsRgu8CyzdzAqOaxumnN+Sp
         ylNYdgCzWCyynBroSjhajOGkDO6fmfSIqwl6juW9riiPRFHvT/oOTB/Mv087KWV2xf5Y
         HinQJra+Hf6KjE1ptiQ66CDrk2RlY1LUUdN2MNVhwDFib296KD30qhjcYyEDh+umo1UX
         U0wg==
X-Forwarded-Encrypted: i=1; AJvYcCX1BaN5H5MrXFBr2th+Ppix1QhIoygXgu1wLR6IgWXI1HVI9979IySbqcy2WEaq0qhLKGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqBcheW1TgbH2pRtvWyHX7pXaB3hYfZG2pQSeZu4ncfFpjVH2K
	gj4X94+gi4SB5xc1joH8qx+IYnGVUJKpdB9VrOvlmicEAhpS3hpoHIF2cHPtDUvZAiE=
X-Gm-Gg: ASbGnctdt+YZJkpauj7pxDYIVEbkBMqxvsqhpIzcyTf8kVy5tyBUpjOatVW8lpDEy3O
	k8oyl2NaTuaGkcDN0Cm6WlbXSKml2b+WAqVBq+pwaRSYWJ8RjOTSmYNB4vARD6H8kda3+wrZ874
	IyL3+sRU9Psv6yhKmyfWuH5dSe1UpcbszdAyWYAdlXxvlFo4jV4NVZCjETcqcK5MunhegBGtSYH
	hzGpQEy5U62f+Ikpx72Ccn/kDeJH5l6Ig/WE7Sy8lLqgmnYVzuMkw4PwawKGOCBDqBSijtXaHss
	jEO5Td5ntAnHZ9k7XZWTrsbXEtuoxp+J28sJu2xI3HGgeqil7bHA0BJ32j6K5sENCi2N7nzYHhm
	X/GHN8LADeDxWrO9b05QfqflHgCUS3WlJvCH4
X-Google-Smtp-Source: AGHT+IGEOZJZmS9VN7oJFrBpyPnyA04MJAIvpYC6GlxrITVRrfApyBG3DfPjsMvyvrXG11kPH2vwoA==
X-Received: by 2002:a05:600c:8b52:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-453659c05e5mr32757335e9.10.1750424933502;
        Fri, 20 Jun 2025 06:08:53 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536470826fsm24688205e9.36.2025.06.20.06.08.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:53 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 18/26] target/arm/hvf: Trace host processor features
Date: Fri, 20 Jun 2025 15:07:01 +0200
Message-ID: <20250620130709.31073-19-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tracing an Apple M1 (Icestorm core, ARMv8.4-A):

  hvf_processor_feature_register EL0: 1
  hvf_processor_feature_register EL1: 1
  hvf_processor_feature_register EL2: 0
  hvf_processor_feature_register FP: 1
  hvf_processor_feature_register AdvSIMD: 1
  hvf_processor_feature_register GIC: 0
  hvf_processor_feature_register SVE: 0
  hvf_processor_feature_register MTE: 0
  hvf_processor_feature_register SME: 0

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c        | 43 +++++++++++++++++++++++++++++++++++++
 target/arm/hvf/trace-events |  1 +
 2 files changed, 44 insertions(+)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 52199c4ff9d..87cd323c14d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2160,8 +2160,51 @@ static void hvf_vm_state_change(void *opaque, bool running, RunState state)
     }
 }
 
+static void trace_processor_feature_register(void)
+{
+    hv_return_t ret = HV_SUCCESS;
+    hv_vcpu_exit_t *exit;
+    hv_vcpu_t fd;
+    uint64_t pfr;
+
+    if (!trace_event_get_state_backends(TRACE_HVF_PROCESSOR_FEATURE_REGISTER)) {
+        return;
+    }
+
+    /* We set up a small vcpu to extract host registers */
+    ret = hv_vcpu_create(&fd, &exit, NULL);
+    assert_hvf_ok(ret);
+
+    ret = hv_vcpu_get_sys_reg(fd, HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
+    assert_hvf_ok(ret);
+    trace_hvf_processor_feature_register("EL0",
+                                         FIELD_EX64(pfr, ID_AA64PFR0, EL0));
+    trace_hvf_processor_feature_register("EL1",
+                                         FIELD_EX64(pfr, ID_AA64PFR0, EL1));
+    trace_hvf_processor_feature_register("EL2",
+                                         FIELD_EX64(pfr, ID_AA64PFR0, EL2));
+    trace_hvf_processor_feature_register("FP",
+                                         FIELD_EX64(pfr, ID_AA64PFR0, FP));
+    trace_hvf_processor_feature_register("AdvSIMD", FIELD_EX64(pfr,
+                                         ID_AA64PFR0, ADVSIMD));
+    trace_hvf_processor_feature_register("GIC", FIELD_EX64(pfr,
+                                         ID_AA64PFR0, GIC));
+    trace_hvf_processor_feature_register("SVE", FIELD_EX64(pfr,
+                                         ID_AA64PFR0, SVE));
+
+    ret = hv_vcpu_get_sys_reg(fd, HV_SYS_REG_ID_AA64PFR1_EL1, &pfr);
+    assert_hvf_ok(ret);
+    trace_hvf_processor_feature_register("MTE",
+                                         FIELD_EX64(pfr, ID_AA64PFR1, MTE));
+    trace_hvf_processor_feature_register("SME",
+                                         FIELD_EX64(pfr, ID_AA64PFR1, SME));
+    ret = hv_vcpu_destroy(fd);
+    assert_hvf_ok(ret);
+}
+
 int hvf_arch_init(void)
 {
+    trace_processor_feature_register();
     hvf_state->vtimer_offset = mach_absolute_time();
     vmstate_register(NULL, 0, &vmstate_hvf_vtimer, &vtimer);
     qemu_add_vm_change_state_handler(hvf_vm_state_change, &vtimer);
diff --git a/target/arm/hvf/trace-events b/target/arm/hvf/trace-events
index b49746f28d1..7ef75184901 100644
--- a/target/arm/hvf/trace-events
+++ b/target/arm/hvf/trace-events
@@ -12,3 +12,4 @@ hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid
 hvf_vgic_write(const char *name, uint64_t val) "vgic write to %s [val=0x%016"PRIx64"]"
 hvf_vgic_read(const char *name, uint64_t val) "vgic read from %s [val=0x%016"PRIx64"]"
 hvf_illegal_guest_state(void) "HV_ILLEGAL_GUEST_STATE"
+hvf_processor_feature_register(const char *regname, unsigned value) "%s: %u"
-- 
2.49.0


