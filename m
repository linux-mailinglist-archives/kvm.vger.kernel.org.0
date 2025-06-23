Return-Path: <kvm+bounces-50319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2E5AE3FEA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F21E116C254
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19FA244698;
	Mon, 23 Jun 2025 12:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FaLbu3ZH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D432441B4
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681172; cv=none; b=efjyk2uV++FrVdf2DMwM459a90gkj+HhNcVbENgBY+MRaWSmrwSCHGLzUybhPdarotbXVMchLOy7MjaKQFqkb4f/G1gxwyyB9ckWmmAqr4/zMaRg0W0gviyTuvyY9HRitpEOckow6NabT+aOYt4Os9IUmmNRwIjfgE1nHqd3uKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681172; c=relaxed/simple;
	bh=f8NvzMqKx8UHnEdJOyorF06BZHlOzCa768Ga0ywIB7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RW3WDdPKbbIiIzAhWWXk4cVIfIWKUiK8A/Ft7F6zQqBG95hJH7pny4gczn4LyTGKWvvUQtZm5iEx8ewY99v0kmwScGf3pcxPKtKc0AyvHjtDzq/PgNZN1BbbxUmGHk9fWFyePO4+yx+6vPUq8dKEcGOS8lJEiVDmA8n8bnEtj40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FaLbu3ZH; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a57ae5cb17so2272094f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681169; x=1751285969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyHQEfn6inWyZRMUVI/8b1HegzN318xDx/IKxFDD3c0=;
        b=FaLbu3ZHgbCbd70kdwr5QiS9OXj4hEVBplvcgqtCxjjKVlOQPfC+P503TzWGtYiX2m
         M4fsBDwiEp30294oNMT6bKN0CvQ34FsmoWOTEzDGa7QCB+cXbERA3XaQhELTVnqy4QC0
         OvEn1VWW1s0tBDuaVapmVUAkyQHKSe1HBw84maCJrwIWPzF7fu80YOcWG+sZd/NSTJps
         KYfNZQN1zP8pvboogKVH/FbkdatCJ+FOR3rSEcobNTEvtdE0EOIp/FtExgcLLbMyiR1j
         8aiaeb3W++7Vi4srTVyYhyePc52LFCGfs0S3goM0o6uJITBtHOwMw7PJ0mehFj9qPdtw
         Td/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681169; x=1751285969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyHQEfn6inWyZRMUVI/8b1HegzN318xDx/IKxFDD3c0=;
        b=jaRy+TwrHEhZGLDRgZNLa3JqwoSdIG12L7bFieNOj61ZbvTVv0LbKhEGsShqC72Mnh
         mUpd3kE0Vn8u7srkVQ7BbtutLgG5tvG70kq7wnFXNeDOSJgi7dk9LUYfRS8LV3BdcYKP
         ckS82+bDaBQe2tzQoM95gmcfBHQscbX1AhMP9b2O8k5Uh0zkb6fqyI1Qq+VmZRLpgMSl
         hUQ3/E/x+demcJIntCW6rjx97b3b/lZDYSssgTWjoLtDQ+C9tYyErCy0AEEqicm5PI7s
         /mTkA8KVlGulJ2dtryJmv8WnaOnkIPTnaDNXTn2xVeTJg7RsLAYmsTZZEg1BNbS7dE3y
         hfVQ==
X-Forwarded-Encrypted: i=1; AJvYcCW78wEcU/EOTCGhAkRR1cUYvDuyNww8kRkWJ8qAEcL0D+Ay/tQWG76329bsabD+qKssgdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdOKsZ6ys7QMuYV85REoTDzXozn9eHNc4Y71zY+M12DFdRbPLW
	nRuO3ULElouDL7Kw3D8dAVw/jgXrQtOx/DZzoakgoRu4QakK8l4E9x9sajHNzJTQ5ao=
X-Gm-Gg: ASbGncscw63mzSNI96awX6MVfdct/gjVEpYzU86ATVbWcFfvGx17vxkkHEa4PCYRJru
	7RK34B+I9FP0JHOeHRz2RxWTl0L8pmR12h3XZ6vXK1TbfKRjdQHbx5aj9ni2yZqvQih3tW/PIfj
	9JSYS3XoWiwtNiVH5Tf+M8XABDkwvBFhcjc7weepmcd52ssXY6+v2YCUeSfU/FNPMSqsmUDKkyv
	u0b/FdDm+2Rk1nln6D5AGt24dqTtK6MExbYCfaF5nAx9QGl5SYzTEa/415UF0gHK464mnVtY2Jx
	5r1yZthKHp+yvUof4+BcsmWxQN9gj1Bf7nG59MWOhB6xRkuf1V2tJTLaYd1a/tWbhrta5zgNkpe
	mdknSL48U5OKDbtGbcjTwR85Hp4Nxv+Jok7td
X-Google-Smtp-Source: AGHT+IG0jiUUTmeqAWUri6/ZJ6x4DVSBOfaEpfSa25gPf14UgQYKRFy2gTrbK23eOovRBdpzASNZQQ==
X-Received: by 2002:a05:6000:1a8f:b0:3a5:2d42:aa17 with SMTP id ffacd0b85a97d-3a6d12d53e2mr9880614f8f.31.1750681168848;
        Mon, 23 Jun 2025 05:19:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646fd7aasm108552565e9.20.2025.06.23.05.19.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 08/26] target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
Date: Mon, 23 Jun 2025 14:18:27 +0200
Message-ID: <20250623121845.7214-9-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tracing $PC for unknown HVC instructions to not have to
look at the disassembled flow of instructions.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c        | 4 ++--
 target/arm/hvf/trace-events | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index cc5bbc155d2..d4c58516e8b 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2071,12 +2071,12 @@ int hvf_vcpu_exec(CPUState *cpu)
         cpu_synchronize_state(cpu);
         if (arm_cpu->psci_conduit == QEMU_PSCI_CONDUIT_HVC) {
             if (!hvf_handle_psci_call(cpu)) {
-                trace_hvf_unknown_hvc(env->xregs[0]);
+                trace_hvf_unknown_hvc(env->pc, env->xregs[0]);
                 /* SMCCC 1.3 section 5.2 says every unknown SMCCC call returns -1 */
                 env->xregs[0] = -1;
             }
         } else {
-            trace_hvf_unknown_hvc(env->xregs[0]);
+            trace_hvf_unknown_hvc(env->pc, env->xregs[0]);
             hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
         }
         break;
diff --git a/target/arm/hvf/trace-events b/target/arm/hvf/trace-events
index a4870e0a5c4..b49746f28d1 100644
--- a/target/arm/hvf/trace-events
+++ b/target/arm/hvf/trace-events
@@ -5,10 +5,10 @@ hvf_inject_irq(void) "injecting IRQ"
 hvf_data_abort(uint64_t pc, uint64_t va, uint64_t pa, bool isv, bool iswrite, bool s1ptw, uint32_t len, uint32_t srt) "data abort: [pc=0x%"PRIx64" va=0x%016"PRIx64" pa=0x%016"PRIx64" isv=%d iswrite=%d s1ptw=%d len=%d srt=%d]"
 hvf_sysreg_read(uint32_t reg, uint32_t op0, uint32_t op1, uint32_t crn, uint32_t crm, uint32_t op2, uint64_t val) "sysreg read 0x%08x (op0=%d op1=%d crn=%d crm=%d op2=%d) = 0x%016"PRIx64
 hvf_sysreg_write(uint32_t reg, uint32_t op0, uint32_t op1, uint32_t crn, uint32_t crm, uint32_t op2, uint64_t val) "sysreg write 0x%08x (op0=%d op1=%d crn=%d crm=%d op2=%d, val=0x%016"PRIx64")"
-hvf_unknown_hvc(uint64_t x0) "unknown HVC! 0x%016"PRIx64
+hvf_unknown_hvc(uint64_t pc, uint64_t x0) "pc=0x%"PRIx64" unknown HVC! 0x%016"PRIx64
 hvf_unknown_smc(uint64_t x0) "unknown SMC! 0x%016"PRIx64
 hvf_exit(uint64_t syndrome, uint32_t ec, uint64_t pc) "exit: 0x%"PRIx64" [ec=0x%x pc=0x%"PRIx64"]"
-hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid) "PSCI Call x0=0x%016"PRIx64" x1=0x%016"PRIx64" x2=0x%016"PRIx64" x3=0x%016"PRIx64" cpu=0x%x"
+hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid) "PSCI Call x0=0x%016"PRIx64" x1=0x%016"PRIx64" x2=0x%016"PRIx64" x3=0x%016"PRIx64" cpuid=0x%x"
 hvf_vgic_write(const char *name, uint64_t val) "vgic write to %s [val=0x%016"PRIx64"]"
 hvf_vgic_read(const char *name, uint64_t val) "vgic read from %s [val=0x%016"PRIx64"]"
 hvf_illegal_guest_state(void) "HV_ILLEGAL_GUEST_STATE"
-- 
2.49.0


