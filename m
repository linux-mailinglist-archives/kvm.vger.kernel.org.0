Return-Path: <kvm+bounces-50078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C63DAE1B87
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4715177E1A
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0011028D8E2;
	Fri, 20 Jun 2025 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lH2LmX91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B976284662
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424900; cv=none; b=dswuDXsxxAVngz/jHlKlzmjy445CWsaNcyU13qlTZ0su/rJTo7z3czRZiH16f/ghqo0B4dnutdEzNosmYXu7SJxLV0e37slg7okoC8fBMDp0XDG+slRtfI9CXAKyv350hbDMzA7M49FqnkTFZq70c26drDxImiAQulQdmhFT/UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424900; c=relaxed/simple;
	bh=BxjAvOKkwCXb0SAFn4LDJo//G86Vjg7XWmaJecVv3Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQsbslre+U5vOaayC2vgZcGPwjKf8em1QK3VO5aP3BoC604I7wE5cgEKYt+nQtszErxb8Qqb6HaUuOO+lve/nRZomwOHiqsPZpo8kcYzXkdjjZnVsMf5C8hFE0x/WPiKB33ima7J9AfAQn5DBbQaQ3pJAoRDffpAUPNN4QX3gAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lH2LmX91; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-450cf214200so17544245e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424895; x=1751029695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZYVTt5RemOQGhErk/wxiT1GRcR8x45vVeqGw/eKctk=;
        b=lH2LmX9156hS9FOMEWRJomdxe16gOEhpXPOmARTP2zR4rWbSqOFRqRtAIKyKByLK7A
         GFQWoAkOzIyMBVibL1sJZwLkX2TcJ2rdKpgr+3Ncm60YMZdnBlKsO0C1dkoZ4H6p2tVN
         G6bcqa6gD7kgU7vQUpU/6FLVFGDjqZRBLSvOZv/tX5Xr0Pbd992McRm6DHjsaYV9+8qo
         eHAhXY/SjYTYIhOKALHAaOpH1onfkGSZS7uEm5VdH35tCdbRo6gjKkLh5pS7AhD2B+Kq
         NN/Uo2KAvC9crHuwXnE0ZZjqgz8aR+vmqH220bhoFAkac7j5rh+Ugkxh7BYMknIJwoyq
         Rbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424895; x=1751029695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZYVTt5RemOQGhErk/wxiT1GRcR8x45vVeqGw/eKctk=;
        b=laaxxsm+I/3Zb4/cpStRDrV36guiMYn/AS3u7GFIbYyUbV+g8LoCneXPyCH3Av4f/R
         GG0fGE/j6P1uz0tULjg/rRvXJhBgoACuV9v26CXv8WIusi+tzkFDA2Z4wyJAq3HBG+Eo
         sGPf21qxPaQhM6lcfBpnjzRznNo7hJDxwMdGnkD2hgTB6x3BFPN8FOK3TntHsNw7yTUW
         T+V21cZdPoIdlCSZj90BL3OXi7upqm8/YaHpnfNcWQVGPEPixfsKmanOwO408CbGcVuy
         BcXAXKEWbjDjBUpazF61oIPu6FOugeb9LiKk+u1revulXtJYAFEpCH1zS/YwBtR7hvkS
         jElw==
X-Forwarded-Encrypted: i=1; AJvYcCVQAFy56C7Co6cNLuDxMTTRjjh5QLT/T6QnCrBOcBv4PvF7D8kajyIITV25mdvT4EOVpoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLNc91LDczz9mrWWq/OemB+ietCkQrvPD0lD/CZeAjIM5j3SZf
	yNJkzoG+YeI/DJ94IA/NEhLwqNFE63nFHEoj64y5ErqSaO0YoxIuT8J0Hqu/2mwqyCk=
X-Gm-Gg: ASbGncu2yr5VrBaMWfKYRGYhvuGDFWojE3A1cPA79Sqd7ne7gFPiH6Br6vWXpVf5Oqr
	+GeBHELQSlqwYkGfUDXe1lzJiP0CUDScGkcIsc+1QDmXO7cvvfusQhT6yw2dI3QRn52NzwGIjUU
	gJAZhijtcUdA2+CZYazKKvfkzPvGVB07MUNUHyhZWNhcAqgyIsQCfMygDCqNANqGW3KzK00ru0G
	tn4r7X7gR5GL2SZL5FaaI+ts9NsVOA4d/upnjXEO7fbGf+tiEqSssS/dZXksyC+NmpQWT0szvO4
	//fuMtG2wenibOaIG0RT4t3NMv7rxyAJkTJIrRoQ0HoCrGbRo77I30qKWWmt3T6JuQqbqFsO0Hu
	Eaj63FrtUhXyaMi94qOOtAY8ql9bS6/g/Z++SjeFKV8GlOfY=
X-Google-Smtp-Source: AGHT+IFVLdhGyOe5Gwiz0JlxZs0z4PUuLavXcnnSLq49twNgh52Q6RjdjYzWXSk1EhN5FYPARRZVKg==
X-Received: by 2002:a05:600c:1f94:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-45365a05192mr27153005e9.30.1750424894423;
        Fri, 20 Jun 2025 06:08:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117c663sm2084326f8f.64.2025.06.20.06.08.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:13 -0700 (PDT)
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
Subject: [PATCH v2 11/26] target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
Date: Fri, 20 Jun 2025 15:06:54 +0200
Message-ID: <20250620130709.31073-12-philmd@linaro.org>
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

In preparation of raising exceptions at EL2, add the 'target_el'
argument to hvf_raise_exception().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 5169bf6e23c..b932134a833 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1089,13 +1089,13 @@ void hvf_kick_vcpu_thread(CPUState *cpu)
 }
 
 static void hvf_raise_exception(CPUState *cpu, uint32_t excp,
-                                uint32_t syndrome)
+                                uint32_t syndrome, int target_el)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
     CPUARMState *env = &arm_cpu->env;
 
     cpu->exception_index = excp;
-    env->exception.target_el = 1;
+    env->exception.target_el = target_el;
     env->exception.syndrome = syndrome;
 
     arm_cpu_do_interrupt(cpu);
@@ -1454,7 +1454,7 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint64_t *val)
                                     SYSREG_CRN(reg),
                                     SYSREG_CRM(reg),
                                     SYSREG_OP2(reg));
-    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized(), 1);
     return 1;
 }
 
@@ -1760,7 +1760,7 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
                                      SYSREG_CRN(reg),
                                      SYSREG_CRM(reg),
                                      SYSREG_OP2(reg));
-    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+    hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized(), 1);
     return 1;
 }
 
@@ -1963,7 +1963,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         if (!hvf_find_sw_breakpoint(cpu, env->pc)) {
             /* Re-inject into the guest */
             ret = 0;
-            hvf_raise_exception(cpu, EXCP_BKPT, syn_aa64_bkpt(0));
+            hvf_raise_exception(cpu, EXCP_BKPT, syn_aa64_bkpt(0), 1);
         }
         break;
     }
@@ -2074,7 +2074,7 @@ int hvf_vcpu_exec(CPUState *cpu)
             }
         } else {
             trace_hvf_unknown_hvc(env->pc, env->xregs[0]);
-            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized(), 1);
         }
         break;
     case EC_AA64_SMC:
@@ -2089,7 +2089,7 @@ int hvf_vcpu_exec(CPUState *cpu)
             }
         } else {
             trace_hvf_unknown_smc(env->xregs[0]);
-            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized(), 1);
         }
         break;
     default:
-- 
2.49.0


