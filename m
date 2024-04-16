Return-Path: <kvm+bounces-14771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2448A6CEA
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61D9F1C215A8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 13:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D7A12C7E1;
	Tue, 16 Apr 2024 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nM2kbBeN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D47D1272AA
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713275712; cv=none; b=YDyc1h0iaavJiAffcPJvD5BlOafubc015ZTCi253gd+3l9yc73Zpc0achrDh1DVE0mRPTsUPuDRPzjs+gKIaXcFYjNNHVZyoZeXT2RGkN3ST6ZacSZt4VuCdmq9qpKvcEuN631rXaqiV0GLocNNTlnYR+sBdLIcF7I7of9p6Zbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713275712; c=relaxed/simple;
	bh=7gnNlQpmPTha3BrmsvmwHEikdOtnoTPEc28vlwcQwEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8yffm5nMUNc1jqQ0QE+OhDtIXZX5kohPEWlVIWofbnSFhb9qiuptHmk4QVBy6oVePcLL1V2BTOdCP2nJG1VXV2dGHjJM4wY12W2yWyQoI5QGmnNdvJNmhPY9QIbnpXjwvISMFFchirjWS6GuUe2gWML0ZM0vzWPQNpRTZtTuIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nM2kbBeN; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5700a9caee0so4086006a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 06:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713275709; x=1713880509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1653K/UfEWnXUTbr/YeJw2UmUosHHOUFfds+vppZrE=;
        b=nM2kbBeN/UIVspqTXT+yaIS98etFtqxG5iR/OOL8rnSI+p6hR64adbFDAYqKIUv3qi
         GRiAKSMDuTBlWAzDS/NUA6obLmYPyDFbkqyiZDk+2j3qgB2/EpqQAkv1xXCY2DtPY1xa
         TZkaf1DSCuAAEBZJC5iY5PIZ0xre5LEs2q4cmZsjM7DZC5c5F3FMQLyqoX+IYfOPY/Jx
         GpCf90RiENfUjoAKWkM8Kfx9wLhfNTUs+6dWLO/ej9VSIM9VnukDCxLvmyaB1iUpuh7i
         i75i6YXNqtunlYAHxhvMmueoWds1TYFBPpOOeWDAdWutDjTGJUFWmOkA7Fq825xynEMX
         TuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713275709; x=1713880509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1653K/UfEWnXUTbr/YeJw2UmUosHHOUFfds+vppZrE=;
        b=hFaa7FxdE7Ha2O5ip0Wcq4Cgbga2BoMuyUMRzr71Jw86dXyuCcBMEslDsLlaA7bEiZ
         rGeS2bgTXmJNoEZqCEuP4ftjp29l4ZJtjru7pRGYxE4Pt8bJSoVvmGH6kdiz/qFz8QAw
         2jWu27EwQFZveiLwbMzGhcl28dqqlaq4yKJHUyKvwgFFMJ5r+65mu1Hva1Pc4jw3+g/S
         6YBYwoWYOAP5erTDd6EeOUm03isKjeSwKeqW1YDJQD1fxIZyQHv2UF+ZDVdvE1G4uSRv
         87WKuwiGuHUaLJ/Vol21TpOUw9LTXxJPwQABRPsle0Ywy4VrqoUKm7buw0FkfPyY/NYg
         GtCg==
X-Forwarded-Encrypted: i=1; AJvYcCUr+ccWT8ubUnSgHwPJyzkoygEgU2HFo0RNqnJkxnI9qDlnpAOFyMxKTfIXPvuMfsN0kvFG7AeNIsor5UZkerXwSMpZ
X-Gm-Message-State: AOJu0Yz3wAnRSf1kgPeoQD7J6kL/OgH6CC8IXn1yboXSeq9X/HBAxBqe
	Q6JOZj49urP1fN08qf/LhpyqRGKaT8xDL+38Wx36SY3D7Ps0FgpqdDmON2x1VjA=
X-Google-Smtp-Source: AGHT+IHkUMQgIFsx5SzP07ohbcv44kLEvoExY/YrMlXFyL1i8R4mcChXMZxYy0/mFxCZjbzS5CDwpg==
X-Received: by 2002:a50:8ace:0:b0:568:d5e7:37a1 with SMTP id k14-20020a508ace000000b00568d5e737a1mr8273701edk.36.1713275708861;
        Tue, 16 Apr 2024 06:55:08 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id bl19-20020a056402211300b0056e064a6d2dsm6108679edb.2.2024.04.16.06.55.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 06:55:08 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v3 21/22] target/i386: Remove X86CPU::kvm_no_smi_migration field
Date: Tue, 16 Apr 2024 15:52:50 +0200
Message-ID: <20240416135252.8384-22-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416135252.8384-1-philmd@linaro.org>
References: <20240416135252.8384-1-philmd@linaro.org>
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


