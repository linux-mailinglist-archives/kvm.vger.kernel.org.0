Return-Path: <kvm+bounces-12784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F345B88DA90
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BC8CB23B20
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37D838382;
	Wed, 27 Mar 2024 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QfbNJfLB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A8B4503E
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711533215; cv=none; b=Ur1ku5S53bMDcu0LerVHqT+6wTr/AbpkiyGQX5uaPTKTQvlOz9aOVWzeDxTz4LbtzrQDmA/wbT7X4aY/Ou0oHdvNBrIwouv8ecBpCUoYiaMkUZX1DLF67h1qrdzz7yaOtRLHL2tVWgwKmhZFJPW5xFj/L4KHwEzp+4/xHF8m7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711533215; c=relaxed/simple;
	bh=8cmzz8JGndfSx3MR40wsgkrR+0qKQiuIezK8yJo2Pxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/brMcSPE8x+m6cP1BjXQT1I/CHhj0Jh4DVX9Rp5L/80wauBCuv/mzFMZfscQlqt/VCHLTs9QgCavXtuz/q9OIZzvRPx6DHcL0SnbtKJIvgcKnSc3nEm+J08BF3BWzMWJ5oESQZ5dGKpqQAFKe8/1FdfARqGnao/cBKx4Y5P7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QfbNJfLB; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56bdf81706aso6882863a12.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711533211; x=1712138011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNAyK3lGFt7pCi07DIyw1qVnA4J8LeB4ju/ikziy2DE=;
        b=QfbNJfLBhfgTWw4DpZEs3GTFqtsPGtVHuV+RtuQRZzE2lmjf3Y+ADNe34kR4xK4WPt
         5Ldz4feki8UzjjkM/6CEqscbHvcIYLPSOxS3Henok0Aj+BG7tpAgaoVOMPXr5X+qf8OY
         vlKN3RGX9+cotbR8f9rmg2vZc6X4A1oIDh5fR7M15YslLxXDkxPWbGMId5BDXlfXNQE2
         C2K+c9tbOkpuyJI2k5QcUTn3lKqykURU8BZQW9Csb2LNl0O0G1PhinHhUTXo/g9vJSVW
         5gvsx8UBd2nGYsFSI8/wNMjMNgfL6kUjPYHnw2yG3lYXAOWzgTPLNf8+dm78WrTZ9eeo
         /gUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711533211; x=1712138011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNAyK3lGFt7pCi07DIyw1qVnA4J8LeB4ju/ikziy2DE=;
        b=CXphKYpIXIfgObxz/HUkvAHvlKLO7pTyMJpHkEmNXKVTEljR2eBeDbR1b73gqi5q9W
         g6dfmz2UEYdDJNBtwnXynanRmiabeLZnStYDyRCHMkPBw7UDM0POvUJ1zQ0EAIvxeW7g
         Kfzspq4PK39HAm83EUHtSy7Q4wNzWgAGX9DWjJQ0KLIi95lQ2B8GKHPUuxX7EUnDnKJd
         QJWtYCgCJsc3x8mL+7Xe8kIrt+mQRm34n9b91lKbxZU9/AI3XNk7ZWwgfOj9/bhQJxQt
         7CtiygXw8Wnx0K3HFghqMtAyZnRJS3f+51oL6+A8e9LyikHgmKDU3zOL2a7uRFUQVTY+
         NrXw==
X-Forwarded-Encrypted: i=1; AJvYcCUXe3o1PGvRXFjceSYrIHPwixVY2KdsBjomfeGMrw6+mEvNIu+OeJlXyxONcvM1NOHeQQ4dhGdJ/U0X+flin3vtbw8l
X-Gm-Message-State: AOJu0Yzhf6XnRpmCD+zxMIPudSM347BD6YKZpld3CBAy2svzPceBLJU6
	atI9yOEkwLh8pgD9O65MMXucLi4eBz9yxVIj6Q/cXzxpb6AoYeww+cO4sHnKCF4=
X-Google-Smtp-Source: AGHT+IFqlzJkjsEArB0K4+VQ5UbPfp4Drf5hySW8JZyMQzhoQOcPjv7NaxQMw4TTbsNtYR4e4aRJTg==
X-Received: by 2002:a17:906:b257:b0:a47:39c6:8970 with SMTP id ce23-20020a170906b25700b00a4739c68970mr2716915ejb.39.1711533211584;
        Wed, 27 Mar 2024 02:53:31 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.205.175])
        by smtp.gmail.com with ESMTPSA id n6-20020a170906700600b00a474b3c90c4sm4437161ejj.24.2024.03.27.02.53.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 27 Mar 2024 02:53:31 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Thomas Huth <thuth@redhat.com>,
	qemu-devel@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	devel@lists.libvirt.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH-for-9.1 v2 20/21] target/i386: Remove X86CPU::kvm_no_smi_migration field
Date: Wed, 27 Mar 2024 10:51:22 +0100
Message-ID: <20240327095124.73639-21-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240327095124.73639-1-philmd@linaro.org>
References: <20240327095124.73639-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

X86CPU::kvm_no_smi_migration was only used by the
pc-i440fx-2.3 machine, which got removed. Remove it
and simplify kvm_put_vcpu_events().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h     | 3 ---
 target/i386/cpu.c     | 2 --
 target/i386/kvm/kvm.c | 7 +------
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6b05738079..5b016d6667 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2018,9 +2018,6 @@ struct ArchCPU {
     /* if set, limit maximum value for phys_bits when host_phys_bits is true */
     uint8_t host_phys_bits_limit;
 
-    /* Stop SMI delivery for migration compatibility with old machines */
-    bool kvm_no_smi_migration;
-
     /* Forcefully disable KVM PV features not exposed in guest CPUIDs */
     bool kvm_pv_enforce_cpuid;
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 33760a2ee1..f9991e7398 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7905,8 +7905,6 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
     DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
-    DEFINE_PROP_BOOL("kvm-no-smi-migration", X86CPU, kvm_no_smi_migration,
-                     false),
     DEFINE_PROP_BOOL("kvm-pv-enforce-cpuid", X86CPU, kvm_pv_enforce_cpuid,
                      false),
     DEFINE_PROP_BOOL("vmware-cpuid-freq", X86CPU, vmware_cpuid_freq, true),
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e68cbe9293..88f4a7da33 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4337,6 +4337,7 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
     events.sipi_vector = env->sipi_vector;
 
     if (has_msr_smbase) {
+        events.flags |= KVM_VCPUEVENT_VALID_SMM;
         events.smi.smm = !!(env->hflags & HF_SMM_MASK);
         events.smi.smm_inside_nmi = !!(env->hflags2 & HF2_SMM_INSIDE_NMI_MASK);
         if (kvm_irqchip_in_kernel()) {
@@ -4351,12 +4352,6 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
             events.smi.pending = 0;
             events.smi.latched_init = 0;
         }
-        /* Stop SMI delivery on old machine types to avoid a reboot
-         * on an inward migration of an old VM.
-         */
-        if (!cpu->kvm_no_smi_migration) {
-            events.flags |= KVM_VCPUEVENT_VALID_SMM;
-        }
     }
 
     if (level >= KVM_PUT_RESET_STATE) {
-- 
2.41.0


