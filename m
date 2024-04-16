Return-Path: <kvm+bounces-14870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C56A8A7434
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FFF01C213CC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E025137C2A;
	Tue, 16 Apr 2024 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X4JKWdiY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D268413174B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294125; cv=none; b=oDSHAIkEswB0+0Z7MX7NBsDaXLNQktn/kWp/uM9O8yO9g0p2bNWQG3d7+0SFT2vKx8cRg8ytuofdHP2VNUJ9Q9w7NxB9mj1XFjNhwNmdx55r+qou3ZIs+sCcuLHJb7DcoEeyiYfPO2FhB/GOGYSLDp0lJGt6VvHm6gbWsLe7BY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294125; c=relaxed/simple;
	bh=7gnNlQpmPTha3BrmsvmwHEikdOtnoTPEc28vlwcQwEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgC1LQMhpDhtt1AKcx7prCtWLW7PuQjv/dWegReShQsyJ49gVxeIMHEDKdIr+sVAWY8vYuvqkB29SL07pH3ba/wMNDnXsALCpObhYYoOyXQqwdhlSvKL/G+L6ctpi9fIrKXSQFE9dJnlfjaGSNavjKExaAqj8Qs48uSVj8yvU6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X4JKWdiY; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-516f2e0edb7so5851534e87.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294122; x=1713898922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1653K/UfEWnXUTbr/YeJw2UmUosHHOUFfds+vppZrE=;
        b=X4JKWdiYCCBToX3tm589zFYmYXxRs+/FO9UV5U2NXxZrjn+bAI966p5RCOX6MkoqER
         ySAyocMz4ErVvmK6+yIT1Cr9PKzVR+dlGB5SUaY6qK3iKw80RgivrMvn6RjWlUDF3oid
         Bm42ylheCkwfhoW2V3QTCyUZgKCmatX1Q3GA6Lzcj1XCVfRt533jj1+z8XHJ+YPuIfjG
         Vjs63i483VutnujSvIQfAHBIdTPY9pxJOQBTd8/kzo9i0ECYUYIdyIGhLlLArLVmUQRo
         N/HRCmqEEgtjpSXMYZlPIWXC2B665uMpsJbrFhvEFQZnyxj4TgVtK1S0tV+G+SooAU3X
         /b0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294122; x=1713898922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1653K/UfEWnXUTbr/YeJw2UmUosHHOUFfds+vppZrE=;
        b=wjXZUcGx/OqndgRTJDBRRCaGg50+YCvv9N87nPpaXblGezflZic4EjSBk5cdNEOLZK
         Cv9nNkfywPlX2jYdtFAEpcVNLaO005orvrWniwXBZuBsYx9Tr3s4HwTnhXl1H6fMur9I
         RuGa2tLd9C3A+kiiNAdM0YltY0R0rJ81MqY1x2ENe0pj3tXMRcSAiYEkuSthT+2CbatO
         sMFzEFa42kVUFiFpMV6g0xQS7sWxgGRnhQ1DKbqnugryweQ7SrJvgc+GoRGbV4fa1QU7
         5jB2e5+l1canhDGhUXNfvQ68Oh6smYM0DIomz4m7bgt1xmXs1w1YyWdoFsqcRNZjIHr5
         aIyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUawz/yIP3AGFYbcpJsxOP/N+Pj1c9iPqchJRmWE/2/8XoacJnftzxgVvvjlpBLhVWU7+5IqF7uMbG3X45bE+DnHEuP
X-Gm-Message-State: AOJu0Yz/my40izAVJOPK3QeUncNxFfHymDRpHaL/CXHVIeqHDNGSgJPh
	cq833f96/mZ76FG6+wGMFqxXBUjJHjo9+vGnRdIuEjrJJ2XJRQdVXNK9uzXktUc=
X-Google-Smtp-Source: AGHT+IEHRsVutYB17m+/QrIlhkoNuNzc8b/Lou/MToYRe0nANYYcGjkDKUkf+XUo5NjTJqJrDznq6w==
X-Received: by 2002:ac2:5a0f:0:b0:518:d259:8542 with SMTP id q15-20020ac25a0f000000b00518d2598542mr5101592lfn.2.1713294122153;
        Tue, 16 Apr 2024 12:02:02 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id y9-20020a170906470900b00a51a74409dcsm7262977ejq.221.2024.04.16.12.01.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:02:01 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 21/22] target/i386: Remove X86CPU::kvm_no_smi_migration field
Date: Tue, 16 Apr 2024 20:59:37 +0200
Message-ID: <20240416185939.37984-22-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
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


