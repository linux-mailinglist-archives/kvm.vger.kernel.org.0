Return-Path: <kvm+bounces-60461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4C3BEECA0
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7273E4986
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D3D23B615;
	Sun, 19 Oct 2025 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReDtLC9S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3231D21B9F1
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907824; cv=none; b=G1bmayDGiDqGEpkjqtpkHKPb+oYGpMfFxJZvTssmvoo7F3UPilo8bifnmq3JqB/9CBWG8xhRknhDPQv+rZolSiyaqbdAppiPCzoG4/8NVuy0SoC82gk8Zi8uL3Kor8txKfnkr9/vXHjyxVwTjmX4IerfY+/ffp84ZXY3B5aStoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907824; c=relaxed/simple;
	bh=i8OGt9P0VUtw3NRwIouiP6F8L5N6qMuVapZKGvG84+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK5Yz0UGQ4wOdzud/ELrW7129jPRqKc92kJPaTVFmVEM6pvTfEW3aRqXnv8fJLUmlF8fCC/rzg2Qks/Yd+Cqz25pXJsA9M2ECj4p0UAVvDF5ViU+8aDcw5EQeQ4T/LBPQW+Pn8T2512xJFlOPzTplrhiQOqtXpaIpIvUzChynBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReDtLC9S; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-63c3d7e2217so3760247a12.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907822; x=1761512622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4M6OPI3ZScUV1Z3V9YEwq0Mmh3V3HGR6RP7L9+iqOHI=;
        b=ReDtLC9S8hHcMfDvoGz1I5O2AJvi3DSoQKBDvOyeBTVDe7FzOnnphegNvRvjFtYA8S
         oUUGQ9GmMMJngLlUOrQEXZIOwTtSAR7aiCJzFrVBCcEZpzO6QiBmm7vesedT6PF9SAF0
         m3LS1rMzkZKsMGNEIhtyEmS+GDtNpmwoJFGr1fC/J+1EfLAmk/8Bxx/DHhrqsCT0uJQc
         h2DpM0tdNVrpDsvgLu4uygDTwgFjJNQxf9KHw0Va6ocSJ/msnoNThLu6gT6WeZuD2mrw
         gYGumHHYeADvC8MPPhM+H95pDK2n6sKU7GBoILYzBVB3fu75gBEUOUf+tMMkKoM2UcL0
         8ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907822; x=1761512622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4M6OPI3ZScUV1Z3V9YEwq0Mmh3V3HGR6RP7L9+iqOHI=;
        b=XWm6oGTe7rGfJK9jw8TkicDx8lQuZF04KaW+cFYWhpuEewCCMqHShrEJgsjLV2TbqA
         Shi+Z2hqhq4MfN62Akv8yRHtYRhde9qNhuR9EGFXNKuU14AQa0zLyavQHC3w8eMhmfJW
         i4IZd9hhBO2Wu2FJIC9thkXw+IyW9/v0rEsPYdoJpxP/U9tJlw3vex9kZDlLVmWg+fuP
         vPieTD3U1J4cKOSVvK3gxbK3NbDP62KrcGESu4Ucms2a2zUijrt9nGA/7aAXEHiEQCtO
         HqFHs237ZpWnZU7yT2JfzJn3Q8jZv4rXtpKwRj6HZM3mb3ahcYj7n3V1EQYmjMzf4FmX
         UHSg==
X-Forwarded-Encrypted: i=1; AJvYcCWjTRABj+Rs2xmn/g+w0p7FM2/Er3kE/vkz0Zp0Zf3yKbZeDtk25eA8UTiULSDKKt1j+8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCAxo21kUAR3k/p+9H+0tvubuIrLXZxyFwUoGBSlAaLki7s2jo
	d2lTnZJRPoiA59CMFy8W0/uouh3xTBKdzcZRCFvI23sIFuuGLU+Pjs9YzDM0Nx7e
X-Gm-Gg: ASbGnculs3T+/Sq0vTEZgPy/t7alwjcl06U+B1+8NwyqDOWHmbJfp8LgBtriMQT8jm4
	SZ/FEoV3IwNejPM/64dCxotIMXs4o9ZpC8FRKNIvSubNd3rgLUiba2OHbTX6LuqeHlOhm2WNdVs
	7WtjjG6lCqUQB9QB60OPhyAFNR0atr/ukECXyuvy8bnIgc6S00vQuCTLV3dP7tPf0vqKNPjzZtO
	Qd6mGNvaU5IftQCGzs9zIrfCVkIUJ1jh4RKDTX9NyjkdcRcerki0Me1wqUIV/L+avjMFKsJoChl
	Hc9Do8NzgNN3pXxjJxa0atIHedp1EyLHLPDKUhEHCB2I/NMP1SVt5Fe1pNP5yFYcnJxqnW8m0Ve
	GUYenn+hDwzYSOWXnVnEXwOkECKr580aVHAce2PlKFZgjnlMEOlCEMuMS8VfJkwdbE87VbZBP5w
	WII715tYy2HovqDII7Ws8oqVtsIqo+eoNKdQ7JLTpG0Psj1gOUTJLcG6wSzl8SOqHhsSFV
X-Google-Smtp-Source: AGHT+IGSAEruyy42RcbostlDmIvNL1l2atIU8PAtqHcOivFYyhlrRwD6QwsSK/hgSujyhUWyY/+Q2w==
X-Received: by 2002:a05:6402:2681:b0:634:ba7e:f6c8 with SMTP id 4fb4d7f45d1cf-63c1f6d5e1bmr9986226a12.34.1760907821475;
        Sun, 19 Oct 2025 14:03:41 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:40 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 08/10] hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}
Date: Sun, 19 Oct 2025 23:03:01 +0200
Message-ID: <20251019210303.104718-9-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
References: <20251019210303.104718-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoids the `current_cpu` global and seems more robust by not "forgetting" the
own APIC and then re-determining it by cpu_get_current_apic() which uses the
global.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/hw/i386/apic.h               |  4 ++--
 hw/intc/apic.c                       | 10 ++--------
 target/i386/hvf/hvf.c                |  4 ++--
 target/i386/tcg/system/misc_helper.c |  4 ++--
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/hw/i386/apic.h b/include/hw/i386/apic.h
index 871f142888..6a0933f401 100644
--- a/include/hw/i386/apic.h
+++ b/include/hw/i386/apic.h
@@ -19,8 +19,8 @@ void apic_sipi(APICCommonState *s);
 void apic_poll_irq(APICCommonState *s);
 void apic_designate_bsp(APICCommonState *s, bool bsp);
 int apic_get_highest_priority_irr(APICCommonState *s);
-int apic_msr_read(int index, uint64_t *val);
-int apic_msr_write(int index, uint64_t val);
+int apic_msr_read(APICCommonState *s, int index, uint64_t *val);
+int apic_msr_write(APICCommonState *s, int index, uint64_t val);
 bool is_x2apic_mode(APICCommonState *s);
 
 /* pc.c */
diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index cb35c80c75..ba0eda3921 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -881,11 +881,8 @@ static uint64_t apic_mem_read(void *opaque, hwaddr addr, unsigned size)
     return val;
 }
 
-int apic_msr_read(int index, uint64_t *val)
+int apic_msr_read(APICCommonState *s, int index, uint64_t *val)
 {
-    APICCommonState *s;
-
-    s = cpu_get_current_apic();
     if (!s) {
         return -1;
     }
@@ -1079,11 +1076,8 @@ static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
     apic_register_write(index, val);
 }
 
-int apic_msr_write(int index, uint64_t val)
+int apic_msr_write(APICCommonState *s, int index, uint64_t val)
 {
-    APICCommonState *s;
-
-    s = cpu_get_current_apic();
     if (!s) {
         return -1;
     }
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 8445cadece..33f723a76a 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -527,7 +527,7 @@ void hvf_simulate_rdmsr(CPUState *cs)
         int ret;
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
-        ret = apic_msr_read(index, &val);
+        ret = apic_msr_read(cpu->apic_state, index, &val);
         if (ret < 0) {
             x86_emul_raise_exception(env, EXCP0D_GPF, 0);
         }
@@ -638,7 +638,7 @@ void hvf_simulate_wrmsr(CPUState *cs)
         int ret;
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
-        ret = apic_msr_write(index, data);
+        ret = apic_msr_write(cpu->apic_state, index, data);
         if (ret < 0) {
             x86_emul_raise_exception(env, EXCP0D_GPF, 0);
         }
diff --git a/target/i386/tcg/system/misc_helper.c b/target/i386/tcg/system/misc_helper.c
index 9c3f5cc99b..0c32424d36 100644
--- a/target/i386/tcg/system/misc_helper.c
+++ b/target/i386/tcg/system/misc_helper.c
@@ -299,7 +299,7 @@ void helper_wrmsr(CPUX86State *env)
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
         bql_lock();
-        ret = apic_msr_write(index, val);
+        ret = apic_msr_write(env_archcpu(env)->apic_state, index, val);
         bql_unlock();
         if (ret < 0) {
             goto error;
@@ -477,7 +477,7 @@ void helper_rdmsr(CPUX86State *env)
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
         bql_lock();
-        ret = apic_msr_read(index, &val);
+        ret = apic_msr_read(x86_cpu->apic_state, index, &val);
         bql_unlock();
         if (ret < 0) {
             raise_exception_err_ra(env, EXCP0D_GPF, 0, GETPC());
-- 
2.51.1.dirty


