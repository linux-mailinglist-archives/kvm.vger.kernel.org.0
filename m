Return-Path: <kvm+bounces-60324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB34BE91D8
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9145622487
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C217393DF2;
	Fri, 17 Oct 2025 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGUhkLIP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66EC393DD6
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710377; cv=none; b=ZiMlJ3r9XaexcacsBdAk9a7M7QL8quZj9hF1m4Mlh7yUy7BmaBAc9KlPzwJ3hAR/5/TSLoc6Byibm9t7kCaaUjhXy7TjGy1mL68yUTnVcD1WrafetgD8a/UTr3E7iRj/A7Cjtzzn2EyNIO1+dNgOO5niDPO7FzYCYOQPecX+h/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710377; c=relaxed/simple;
	bh=jxs53oV+7mOu+x28rMSkND4v8hZ/JxVmM/ArTkb6TsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfM+1Y8++pdxoBJ5cOVkOZGDClNk2PGMJMTDZGSAJ+ZuM3+qBICgE/a1WhNwWxTQD9zoP5ArkzHpaIz8BtJcVndIzyFi9ESEKZNcOJyCmX6zReCPXKp1RFuNOJCEJs195lXpQAbUdIWkARWTsKfl1/2kJlLHL+SsHtGOJfQnv6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGUhkLIP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47103b6058fso14905795e9.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710374; x=1761315174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WasMZ1F8t7Kg9KHdJ7LE0HpXXcmnjPD1fjMmZVQOLK4=;
        b=PGUhkLIP3SFdiKJIPVbYils+GLJZq+pv2wElSePLucGRlioZqRJIuiG//LZ/9glkfx
         VbX6vFBMRnVvEQLhTD2A0T3dBWnYhfFSewaXyiuyQj0BfAHdOUbbBwxhm3zNTYrxafRW
         TB0Mj8trf539fOGpLUDGGXw9b33htOo/MJUGtdPI8MOE+M1cWZuRA/kRj5ISJdZ/AC4T
         OAHb967or66w6RdICSb05OEW/GdMVmtelh88UdAJhzERrLCTOJmRSozSafJBpJeQJl6S
         Gp5CBxlBGugVuZISv96A4skXReLDi8OrEnP98ACiYJPVVJZkcLz/JA1j4B5R19kNQaD8
         LGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710374; x=1761315174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WasMZ1F8t7Kg9KHdJ7LE0HpXXcmnjPD1fjMmZVQOLK4=;
        b=cN983SfNLilmzt5VtsA97DDoFiOOCGsezs2rLRKwDOgx1UwBKM1XLV6SVmdOnYpWVU
         8nyZtXs19FZw9dzm2h8dpxlwSXXg/UkIECFkVg51+/qfxy+cf7YSD9wj7gm+CbkgYc0+
         EtuAsDBwjn1rPUUS1YuchDHUXuY2MoeEXx87VCSa40X15FwiAgvvUJWOIi2WTlJrTm6G
         bLjO1WxUj/KhXOl+9RWEeW+1w9y8yRlTcgqFgk4cfAPMCBahRAgaU0jb3krzJcDpNo0F
         2TNY5fdfzQx6Ly7jarGq0JPI1n/3mgBtzOHztKU8Fgm9GTgnX/LY3bWXxuqNgz8VnaMG
         CxmA==
X-Forwarded-Encrypted: i=1; AJvYcCUi8e4F6dbTXECRngC/7EMEA7KcAGQnyb+BibIgwJ3Cl8xRP/J5e1eI4FNHq4ntT66Vo0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3/TNYT5zxfzeckJ9nDRWvowbOQJZOjTjQPdF2COe5UCcKUR8/
	OBsT9J6z339pD2D29R7eyH+nrfkxNb5Ffv0NsGUTeUI01PUzZXIYL6Cr
X-Gm-Gg: ASbGncvNOddKtDq8AYUOK1OEiHgNazI1NJOJNnu2vBHfqb5M8FbBZocNFpM9m3Ehy+J
	K4fAF9uvLW4B3CXJ5Gj8Zl8QQqK4Piaj09RC+yHVNiO8XcmiSUvMsDxQBcTfIe6GRGeJY4bIIaw
	G3Soc0T+3KZTm44OJ6WASt7Yt+tRTqhCaipzhGIhevgkUQTcIE9wm4P598GTLctZriXZogSzIYQ
	PGdI2g2O6oPfc59NyVL4Q9kmj0kuStP/Zd9BInOxgY7gF1Sd0XLid1DErZoWeyEA0VzU2kMW6ll
	Ds6ZnEM8gHfn/kczE8p0Ir7x42Z/DP8H/ltkYUgbtNPkoEyOgEHGKoahdESUH2DHyfX3mBGxGE3
	Hno4rUaoFipgnbxGP4JCPsZWLSRe1TtLdw4P/wFGlwFIQsPBhO0aKsCFNblCMkjp9bqUwHWQccE
	rlzM1Qf/PzqgpQ5F5Cy5TNttiL34VZYPM0SUcc16huatI=
X-Google-Smtp-Source: AGHT+IG6amwdU3JKUNT9VxbSRtbgM8Avy/BhQKgGnYnVbRSyWIQst1AQFp5GjR8o/1k5iR1G2og/Ww==
X-Received: by 2002:a05:600c:470b:b0:45d:dc10:a5ee with SMTP id 5b1f17b1804b1-47117315a43mr32494655e9.15.1760710374055;
        Fri, 17 Oct 2025 07:12:54 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:53 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 08/11] hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}
Date: Fri, 17 Oct 2025 16:11:14 +0200
Message-ID: <20251017141117.105944-9-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
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
 target/i386/tcg/system/misc_helper.c |  5 +++--
 4 files changed, 9 insertions(+), 14 deletions(-)

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
index 9c3f5cc99b..360e0e71f0 100644
--- a/target/i386/tcg/system/misc_helper.c
+++ b/target/i386/tcg/system/misc_helper.c
@@ -132,6 +132,7 @@ void helper_write_crN(CPUX86State *env, int reg, target_ulong t0)
 void helper_wrmsr(CPUX86State *env)
 {
     uint64_t val;
+    X86CPU *x86_cpu = env_archcpu(env);
     CPUState *cs = env_cpu(env);
 
     cpu_svm_check_intercept_param(env, SVM_EXIT_MSR, 1, GETPC());
@@ -299,7 +300,7 @@ void helper_wrmsr(CPUX86State *env)
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
         bql_lock();
-        ret = apic_msr_write(index, val);
+        ret = apic_msr_write(x86_cpu->apic_state, index, val);
         bql_unlock();
         if (ret < 0) {
             goto error;
@@ -477,7 +478,7 @@ void helper_rdmsr(CPUX86State *env)
         int index = (uint32_t)env->regs[R_ECX] - MSR_APIC_START;
 
         bql_lock();
-        ret = apic_msr_read(index, &val);
+        ret = apic_msr_read(x86_cpu->apic_state, index, &val);
         bql_unlock();
         if (ret < 0) {
             raise_exception_err_ra(env, EXCP0D_GPF, 0, GETPC());
-- 
2.51.1.dirty


