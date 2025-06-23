Return-Path: <kvm+bounces-50327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 759A1AE3FA9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E7BC7A90DB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C24248F7E;
	Mon, 23 Jun 2025 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YzLyAtMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F6D248F45
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681213; cv=none; b=UdRnnVnQsV4o6c+oQYJnz4c+7nPLOvavpZfylIdWFtt3CEC4ertMNTahRBRvyIY6+eSCDzysxdIUx2tqh3M70yfnGEf5PqzhYZLK2zRhn7SUWCvbnFQRYHFiNHQ47Y2mzLBSePiBavBZEX+fX7nbEunmx7wLvuMzBVv/bkJASB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681213; c=relaxed/simple;
	bh=p4QFhmH28HBuRM27U/KVXW8KMZE0k7vZr8mQTgcMCs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMjNySHft0dFtQzYo5vx7E6piWpWR8EFw/tnPY6NZQzV53wsKJQrQARmm1jOygZI0jhMdhew0DL3d9DwXfQLKm0JzAGGs343pYP//5W5EQSjXKP8SjnZKp1vgMRiEceteNDQXD37U1+bRPZFW4GlKr6H5/jmfRVgJyvXMfp2Wj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YzLyAtMQ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4536b8c183cso10208595e9.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681210; x=1751286010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zn98SRXtaFwoihOhnAeEFS9N5zUhWDF7TNyGo/TLss=;
        b=YzLyAtMQ06gpakkXpoBG2XvLWC3P9wI0NMqEbduvchwVtEL8VnQQjdDUVQE4uLpdlE
         O6Y8P5MTT59PGfRZMnckOr4uOq7kkAgNBRDUW/OpfFIsMPCIh0qmLcm72BEBW5IsuWfS
         +bddBQSV6PCrLgAdw33wWCXf7EmJ1en6zUQR0PQriM004182NSezUAx+uEd0j6YGMoQv
         wmZuT8sD53em2DJgVJV5ioOee1gkjxd7Ruwbhy6/R4LligQQu0mjCnBzfXtV2vwG/47C
         pXVzcb0fkeF/6pv12HjwllO9lFWVX6T/v89FCzC//x4W2dEYOSSPjrPJVbPfMGY/05LM
         pSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681210; x=1751286010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zn98SRXtaFwoihOhnAeEFS9N5zUhWDF7TNyGo/TLss=;
        b=NoKQtBfJ+FKLTBAELylYM79C8kiv/Q08ZEWYhKTe0Dec94Lp2hnwaBdiy6lni4Jlfl
         eExElZOlS1gGXXuMxFeI3l480RjSpnDRgQPQd/Deo6DDohD9pJKd3dxMSAgE76WTHGtU
         YgDkx8+0807kwMLTV+wKz9z+V1TRy78dUjzQcfJVUCfxsHXd2IoT3Ww4j77eBr8znf2M
         9nJaLvK2reGJk/DGymX36UGpd+KC7zecYJjdm+/Mrk81hSLuXYH86wvLd1kT2dv7311R
         WxaqMrDqohDMak5LTWclW8xqR8NNXUqoAA4fq5NWjsNXFsEHHNDR2bwF+TC8vQ9eZmxZ
         yN2A==
X-Forwarded-Encrypted: i=1; AJvYcCVAtYxAOyR1c1ZNjk4w4W3a6Gp0F7/Z8C9jQ98m+1bzDTtECmxU0B0PbVhl2l4CMaUyqrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY7PwHxHtQ2CMZUSxuiRZmlh7dI4lkUqwDWSxYYIaS4GlRDJUE
	t7XcM0HvPAhsYBky10sGVh542WfCA4hU22/L49dylpJW6OXg9o7hEk21P953KjrldrY=
X-Gm-Gg: ASbGncskLKkyFB7j2myzzeEqtcZQgPFc8d7Vk4/qNdkcfNUJuBfp7DJdB6s7xgusaOL
	QVqvlte1Rf6YlXncV497uF2wwEsLpYLcQqZmLt4+dRf7VgGDP4/1PAGVriE89pn/W6k/4y4vm6G
	qoyS4RKYMc2wt2MMNHRPKC+ZouQJsxs3UFk5dIMrE76MYHR445AwE69eU07udQ5OOxeqpX4Nu9Z
	Z4j+I+Wvg5RDmB9XF2EJsAh6mijcM1+xGH5L23AUsAPcNBuvU5CmwQlkkIY79B63BmOx/UjVaFO
	NaM95LBjEaux8KT5hWIfG2mcrFjhxTasYSbocfpTHwV1GZBm+ZbEgfNvfO3l9UG83B17fqyUyN1
	cdGogOj80cCL5GwoInE9oRIWCXnEMqAdrk+SA
X-Google-Smtp-Source: AGHT+IFhxvf0pVdM4spy0FqKxphN+wj0nPLNYA/H7sLORxDSPVaYXm5uBRM12Jr6vzicVX+Kk0gVwg==
X-Received: by 2002:a05:600c:3b19:b0:442:d9fb:d9a5 with SMTP id 5b1f17b1804b1-45365e5e41dmr102028495e9.9.1750681209616;
        Mon, 23 Jun 2025 05:20:09 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f1d168sm9202901f8f.40.2025.06.23.05.20.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:09 -0700 (PDT)
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
Subject: [PATCH v3 16/26] accel/hvf: Add hvf_arch_cpu_realize() stubs
Date: Mon, 23 Jun 2025 14:18:35 +0200
Message-ID: <20250623121845.7214-17-philmd@linaro.org>
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

Implement HVF AccelOpsClass::cpu_target_realize() hook as
empty stubs. Target implementations will come separately.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


