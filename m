Return-Path: <kvm+bounces-50084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A7EAE1B98
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C72113B99B6
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A84D28B3E2;
	Fri, 20 Jun 2025 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VVB1ZZn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9986298247
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424931; cv=none; b=gJwcZYwGTF+dzFJUiK66UmzSk/xRv/JLhhnL2CU9Ryqv0HsyNLODHSyS9Ff0IbvYv2YCHhkt3RMbUGvoLGDKh2Nbjsg13V2bLW89DM2IjGVzQdOdLXxFf0vR91f2fNKGZzeIL9mR5kTuQmpXqXT3NNTymWWP4NDy1iMa6b3FiUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424931; c=relaxed/simple;
	bh=2RBkFcYe6adt6N/lEYhQY7JRojJuhB3pWLTixzDtiYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hl77NabbsynlbhCdgYK68j6bHHql61HiEvIAdSzTaFHOjL4Pad0XVn369EC5jjn4MnMVnO9dyfSJrx8X22uBP7iEeCn4NY1uAfd1LPXwcQ34XOhB/62loeo5rvbsHgWaD61cP+Ngnom6K34MGHR7VPMWivYYyY1zwdaqgbrbShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VVB1ZZn4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-453398e90e9so13153245e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424928; x=1751029728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NW0Hu04oFurHIvjEpsNrwT15qBihdHLv3c5t8qKFRhE=;
        b=VVB1ZZn4UoMYmBM/ZH9lFdzWWsK78/Wk+GzlHWoePlPidX7k/KtP2/7rXhZL5CtA6p
         yaLbc+SxM+wJ/aZjIQ5HEEbyqtPwf6+MIVXyfuQGRMtLAheG4Gaf1HT4M+poXSTkqKKX
         7SX7uh5n+n4NFP1BJ1ZyyRPmvKUvNwMrNwjRu5iA8AaQBK/N0OSkPsT3WqAt3LdQ+eFO
         unJyPIfYDyhAR8RcPSf96vaEe69FwcPAg3bH6uG9pa8cz1ZhKgHWyiwxcKUp7IK2w9Qx
         yd/XHDNxtusDdkqzrtJPGkMyaKk7NSLq2N9GEpxH+HLVnP+qusur9lqLTXMg+SttSek5
         lzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424928; x=1751029728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NW0Hu04oFurHIvjEpsNrwT15qBihdHLv3c5t8qKFRhE=;
        b=JhEe5Ap0KQRQoNV9yJHQpwfSMeJmd9kApzqO7Lfaa5NRf8/X7zpr8JZVamSGjVM9xF
         qMALwA0SL3A6DMSCgp2uQua92J/mhxmGZemV75ChQE+XJi08KIjMSX/LQofkmL+K5vo/
         fG2XSrM84TPpOSG3fQIHPx8rwPSKKudOf7TdHXX7NF8vYfhkNPTcWhc1SHWm8vfSIvkQ
         grnAYICQgYW2ottIv47jptMbCS/2bgCpbg5u3jHe3jnzzdsW7eaDVsyjhqLkQchNGu7/
         XtmmUbzMlapUB3EBLlFRsF+3sF84CrUQ5VtvHSH/R0R0lZG3qmclNy5blq3ICdKyIWWG
         7rUA==
X-Forwarded-Encrypted: i=1; AJvYcCVYz8979ZvCikWWv+Yz2M3v8bU4ECtNZhuK6zTRzBfkcUnP/h5yf/7+gysjAdrR2uT2NCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWk7wvWXFSLbx937TDi1pDleQyF6HAoOzNIUFe0SXJfZ/lq/M3
	CD7pP3z5Ngl2fYQcHZzpAA1X+TEDdrin6sUGnYCxviW9aZHJDZ2MIAy6B6CcCP83eo0=
X-Gm-Gg: ASbGncteM/hHBYD5sfGywBtwyk52cyv6Ml896Xd+2ce5fkrT8i12cLbx4sfHR5BCTcO
	7LqJ1cO6dYQaoTH9TxNOLT+OUtwveVBW/wCSfjZvehA1TsiFJtwYlRJgPNHQgV7rz7vVLQL7VV6
	jEsmmYhVnl38LEIV35qDoHcwmWhYVhg0rvYBMwFEgq9nmIgqPHpUPp4xSTdDoJAoDCFWeASTE8R
	hrGW2XJ2MeQcVmsteMRKZx5UYAT2+O2RSRXdRMN7nP4TAQK1utZ7U0LgFCiLf3C5Hd3mlSgAvRS
	G59Y5lzHzhRREnjPpvIjje77yaWQ+tUFWRk/dTPgcoa6JtCtPo5fUZcrOeJvoyVH87sxgSKfwdW
	yCPgaYUAtYOL/R24LNCvCugvI6hbjyW+JAKXV
X-Google-Smtp-Source: AGHT+IGUxGQ9nSF7X2qks3F5L0LQ6lJ+WfpvhuThp4HFmarf7Jsr/FvLwKNQzlPqKQDhSjDBkrHhqg==
X-Received: by 2002:a05:600c:1991:b0:444:c28f:e81a with SMTP id 5b1f17b1804b1-453659f5888mr23208755e9.27.1750424928234;
        Fri, 20 Jun 2025 06:08:48 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f18152sm2006529f8f.27.2025.06.20.06.08.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:47 -0700 (PDT)
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
Subject: [PATCH v2 17/26] target/arm/hvf: Really set Generic Timer counter frequency
Date: Fri, 20 Jun 2025 15:07:00 +0200
Message-ID: <20250620130709.31073-18-philmd@linaro.org>
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

Setting ARMCPU::gt_cntfrq_hz in hvf_arch_init_vcpu() is
not correct because the timers have already be initialized
with the default frequency.

Set it earlier in the AccelOpsClass::cpu_target_realize()
handler instead, and assert the value is correct when
reaching hvf_arch_init_vcpu().

Fixes: a1477da3dde ("hvf: Add Apple Silicon support")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index fd493f45af1..52199c4ff9d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1004,6 +1004,13 @@ cleanup:
     return ret;
 }
 
+static uint64_t get_cntfrq_el0(void)
+{
+    uint64_t freq_hz = 0;
+    asm volatile("mrs %0, cntfrq_el0" : "=r"(freq_hz));
+    return freq_hz;
+}
+
 int hvf_arch_init_vcpu(CPUState *cpu)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
@@ -1015,7 +1022,9 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     int i;
 
     env->aarch64 = true;
-    asm volatile("mrs %0, cntfrq_el0" : "=r"(arm_cpu->gt_cntfrq_hz));
+
+    /* system count frequency sanity check */
+    assert(arm_cpu->gt_cntfrq_hz == get_cntfrq_el0());
 
     /* Allocate enough space for our sysreg sync */
     arm_cpu->cpreg_indexes = g_renew(uint64_t, arm_cpu->cpreg_indexes,
@@ -1084,6 +1093,10 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 
 bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
 {
+    ARMCPU *cpu = ARM_CPU(cs);
+
+    cpu->gt_cntfrq_hz = get_cntfrq_el0();
+
     return true;
 }
 
-- 
2.49.0


