Return-Path: <kvm+bounces-50083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6DC0AE1B9A
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E50471C2013D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BEC296140;
	Fri, 20 Jun 2025 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DN5ijwxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A9428CF6C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424927; cv=none; b=gVWQooXbEAKww5KFZT4dT7Qg5ZmUoXmqZEq0d9t0YV8P8vqdExKETTjmrGCi5m5yDafiAiF2SWDEIOHi8KP/RvGQo7eiGZaMYrBuM/3BrvQ6IogPZa445soow/9fJ8DsWgGR59tEwwnGKKat0BQylBGKmvOrjTsChdnuNnnnDTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424927; c=relaxed/simple;
	bh=yFTq2Gitn6SefGsXiazBl/v47RuK0/hVhZ47YteIbhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQhISYB66eXmpEKe5T2j9Ye5b1s7nKDQagDbNeVyT2Kl1xRrmfqD3Adl5nZj/hHw85cyxMusg+1wJHgTBtSlp0RpGmHh0bmc4DRPJPtL4OtnQpgRVKiVuzTD179bAMZMoqfbNCpVp13eRivIjHtsWvFYBZ6FY4xhzGs645VTUSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DN5ijwxU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4531e146a24so11630915e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424922; x=1751029722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kLq7ybqs3cS0L36YzYXj0nQxUzd1xncr8lPWgttp7A=;
        b=DN5ijwxUGqHRjlKryjyvQz22lXwB1yMSwgQdJlguFH7Ro0lkIUinc8W1Brsr71lR7l
         FuCc9Jkayn9F4Y6PwktmeHl2s/pynzrrkSYEMBSB73RVSKL/Xj2Hv+m5Y+mUDPeZtv6k
         kIfyd40hJTS975w8e6LkOePnrjmsjvWZiEGDcjxibUyEzHwQoYf3YdhqpBiDrY7Z0eGZ
         W5n25rFM7iaUTO2eJkPMg5tZosF2bEa3WR/wWrEG73uS5BH/8IZunx+50K1TBH+8w21X
         zjcJW0aM3Cjiw6VuGyY4lmsd+LrGSzJ4xJXov4bTQbIu62gMucb6LeZ2+8XQCJI8xrDw
         I32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424922; x=1751029722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kLq7ybqs3cS0L36YzYXj0nQxUzd1xncr8lPWgttp7A=;
        b=dnO1rp9jme0qzn25OqXv1zdFmDkJueBH3zqCCYH9wwGtsKSxxWuKqlSZwiAlqzpZfo
         T4SKygXlMyzYy+eYxOr9HbEUqPR7knakvuwVYsiMRvMUfePg2tdfqX8lf04UXd/qoowp
         /odvzQbrN6F2ja0KbKtoMJ49ZuaFZcaSDUXG4DSVeVbBdXquUaJSAFASuPOkuPD4f3Md
         BuwMyIIYI/QdXVWjPqSW/KNSudbAgf1HHoLPflEFd5MYrnaqtA+IZIgFIJHt9cVTWPM9
         Nkxr757wAHbbAGZUy6qdiNCheEKO6YpDBQKJLw5LTbn3La6wkz3KGaol/dSH/+sBUIaa
         GRfg==
X-Forwarded-Encrypted: i=1; AJvYcCVGuP3fJXxRFvdEnuGCzwnpcXCOX+afgn/oD1aO3GUoJoYcjju677a7vHA3ZOotMv1bd2U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/r2I5zWXfnfnB3pbVSjqm7GPTJ1VJDRfBR0wC/nRuDtbGyYfE
	GofV/ZrrXdKF6qv5E2KCbpiS5JhC9V/VWMAuijwumJP32xpI5T1i01ul/rR9hgATWso=
X-Gm-Gg: ASbGncsa4cCtxqFCFapnbhqFsRIKtpmnDCk9JcBBfp+rhAQw5jS5QbNbh/rTL0q+yEH
	jK9WlXDaLEomN7Yd8SpB/Nd+kAs+zyYEccPzv7ypXL+Il8K1LgXCBJionHzZ3JZEaE8BAY86QK1
	7ITlcnne0PIf+6dGUbr7Frv+5D1QPNefe9NWLa/pDXl72Qw9JvUPCucZrMHhVUJDP+rDqQLtKyC
	s+MI2lusXOdLeCAq+GfeV1Hf0BR40m+E/PY/cCz57zsrYHlbUvecipNgykNU3J1d9f7Y5sCG0cS
	t1pHt4iRmzAVBbvJw0eelr26qb79gyz1VdKG0dttChQUCwNR5bdx6SDP3rCfN/S5xSH9mJSnp4R
	14YQuQ7nPlIjo6WV+9lFkO+xSdcME+Icvo/oV
X-Google-Smtp-Source: AGHT+IHx17Q3o0n4ExJMDEX9nhiRFuD9m/DDwUW/YxBilyeTC3sNUKgmjYDttzl1RvFGqYhxbO7bhQ==
X-Received: by 2002:a05:600c:c4ac:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-453659be428mr24945485e9.5.1750424922099;
        Fri, 20 Jun 2025 06:08:42 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646fd74asm24979395e9.22.2025.06.20.06.08.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:41 -0700 (PDT)
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
Subject: [PATCH v2 16/26] accel/hvf: Add hvf_arch_cpu_realize() stubs
Date: Fri, 20 Jun 2025 15:06:59 +0200
Message-ID: <20250620130709.31073-17-philmd@linaro.org>
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

Implement HVF AccelOpsClass::cpu_target_realize() hook as
empty stubs. Target implementations will come separately.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/hvf.h      | 3 +++
 accel/hvf/hvf-accel-ops.c | 2 ++
 target/arm/hvf/hvf.c      | 5 +++++
 target/i386/hvf/hvf.c     | 5 +++++
 4 files changed, 15 insertions(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index a9a502f0c8f..8c4409a13f1 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -72,6 +72,9 @@ void hvf_arch_update_guest_debug(CPUState *cpu);
  * Return whether the guest supports debugging.
  */
 bool hvf_arch_supports_guest_debug(void);
+
+bool hvf_arch_cpu_realize(CPUState *cpu, Error **errp);
+
 #endif /* COMPILING_PER_TARGET */
 
 #endif
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b38977207d2..b9511103a75 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -588,6 +588,8 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->cpu_target_realize = hvf_arch_cpu_realize;
+
     ops->create_vcpu_thread = hvf_start_vcpu_thread;
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index b932134a833..fd493f45af1 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1082,6 +1082,11 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     return 0;
 }
 
+bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
+{
+    return true;
+}
+
 void hvf_kick_vcpu_thread(CPUState *cpu)
 {
     cpus_kick_thread(cpu);
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 99e37a33e50..28484496710 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -367,6 +367,11 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     return 0;
 }
 
+bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
+{
+    return true;
+}
+
 static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_info)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
-- 
2.49.0


