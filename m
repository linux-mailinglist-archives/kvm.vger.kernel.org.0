Return-Path: <kvm+bounces-45879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 154FCAAFBCB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B235F4C89D4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3943022C339;
	Thu,  8 May 2025 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vAR1fWyO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA070218EA1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711791; cv=none; b=MPF3CxPq9rRaRfoH24V9JmYnmqRKOvtZ/N3peoLa1Ev2CFMxhJYQPQbrKrbCOOsgyyeMdWY9IOUbwnWYSw35Y+WxYEcq9qG15eCCIXMZHEA9aT72WInUm+iTayJJefkMqsVXpOWKZ7KNp4dFFFObeiq7tBGpnkp7lRa4HlJms10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711791; c=relaxed/simple;
	bh=4qzhmG0pBpRFM/WwRA/Ma0CEvnKIdAmleKwYZ1VCuX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEoACqg1iyc2rugB7tcSKsAkLAVH3wDU27qimXvQpsRwAxaBnL7FwptH0I4guysuNzrvgDKViR0iddJZCGQz9uwiSnp7hUwJoLZtiSKUl7VpR7zVbCXaEi8yOlyEB63hqmH/26YrFVloNwTyku24F+C/fNfLBb5IrqFDWDGiHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vAR1fWyO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227b828de00so9655515ad.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711789; x=1747316589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ftaUxFMOJWyPcpYYJywN7GZrXuW4pScDj+n5IUMy18=;
        b=vAR1fWyOBKTzYFVGahIwGqNAQPbxN89udL5IdMf16OSO4I5Xq/bnPhaJLECxfhLdmo
         UolVjXr8m2EzVsJFem0oLVR9oNg2ZpCIBt5VFS7exaKhPVzOkHUQiNtbL3zhW0Urot00
         rhjF6xbNMPyRvJC8fK2ccb7DQ5dO7jt2dmBm1U4rdiNJStsjqKoUFqdqOjguaRCeISVp
         7iUPLQihCIFb/LNijXBpbOG9UVAMPrNjMlVc5NytpnH/7hhbY5rcXd6+FQ/nutvMxHEp
         cjTVPmfM6pPLqroJtIdq2/4hmYlhPM5hN7ihlUEd3/jXPFFePIAK74HBV2nKdvcJlRmD
         DQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711789; x=1747316589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ftaUxFMOJWyPcpYYJywN7GZrXuW4pScDj+n5IUMy18=;
        b=mY1464H1Z+VUzYHjUaGfCjui2T7H4Lmd3IA6JS3Taj497fajp/6+SLh28uw/42y/QP
         VM6Lls6NNX0Ucrut6smVS6jTb/wdUZcPp3f6Av8nO37ZbkLlA41gSMZKf0nx+Wr/isu7
         ziuFInYl1D4Mkg3spX97VY4ijfmrfaVJzMt5B3ahl2/M9EkCfPFx2W4JIBiCCtbkM1y0
         uvcXRqqEGDB6RSz0N52+es1ncFYbmfVLiBqJiZoXIC6dFpkf3cSz6xj8VsyMwNrWdy6/
         Hv/zC+bg+ZdBkLvgye1gcBimOjR5k5tX34o/9OcoNOku1ARRE/EGVu3FSG7m7mzcqmfG
         iUIg==
X-Forwarded-Encrypted: i=1; AJvYcCW84zJbDyEewnjwcbI+rg5YJbJPCSfjHmrWSESciqMI5I3a7Eu76jFBBpyJSS8Bxaa/M8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA2EGoa3Lt+xhbDzgHiQSVzr71LFIYwV9RJDBvSaNsWIGtuV0N
	Bh7wNojlUY9hRL2sczbe4ikto1dOQE19Rga3kj9hYVm2qfX7idlCNN8p6ko6DoI=
X-Gm-Gg: ASbGnctfQTDNknuaLjJNPVOG+emb6JYA1HHoO0/b9NTQ1y+Qgmo2VKpsmgpHNewhvef
	o1yAXA+6q2zH7xchlaaq0p8Fe8JRMzuEjhl1nhwaYS8q0jzpRpsUHFzrSi0uzOEITnPmcr24M5I
	wxTmOPz16NnK4Rz88/T7J/jbzdPEhpZ1hg9t9u5pn9Qe7gPB6tLh8vxB1JhisovC9DMd1/9HTYS
	VwGWsBQ2zvLI+gF4WZjhsBs2xXopVZjkVNfQP6tcF84R2/5uA3zhQiIoWOkqraGVODceG6W63ZC
	alNB8zqcTsXlVEln7QmmC0nSpk1ZVi9yjaViWlpFsr+3oxsNWidcsCJ7Y3I2+zbDzqHJFXxLBH0
	s4bOQpc/BgFTRlek=
X-Google-Smtp-Source: AGHT+IHf0libKwgmd+MQV/clEwoJpojBT3miHTd/ZiyF50sfD38cB4OytaIbg2ZPNUn3nC4xndB+Mg==
X-Received: by 2002:a17:903:2310:b0:223:62f5:fd44 with SMTP id d9443c01a7336-22e5ec997b4mr119109545ad.40.1746711787379;
        Thu, 08 May 2025 06:43:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b22b0594a67sm240599a12.23.2025.05.08.06.42.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:43:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH v4 19/27] target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
Date: Thu,  8 May 2025 15:35:42 +0200
Message-ID: <20250508133550.81391-20-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The CPUX86State::full_cpuid_auto_level boolean was only
disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
which got removed. Being now always %true, we can remove
it and simplify x86_cpu_expand_features().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h |   3 --
 target/i386/cpu.c | 106 ++++++++++++++++++++++------------------------
 2 files changed, 51 insertions(+), 58 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7585407da54..b5cbd91c156 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2241,9 +2241,6 @@ struct ArchCPU {
      */
     bool legacy_multi_node;
 
-    /* Enable auto level-increase for all CPUID leaves */
-    bool full_cpuid_auto_level;
-
     /* Only advertise CPUID leaves defined by the vendor */
     bool vendor_cpuid_only;
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fb505d13122..6b9a1f2251a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7843,68 +7843,65 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
 
     /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
     x86_cpu_adjust_feat_level(cpu, FEAT_7_0_EBX);
-    if (cpu->full_cpuid_auto_level) {
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
-        x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
-        x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
+    x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
+    x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
 
-        /* Intel Processor Trace requires CPUID[0x14] */
-        if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
-            if (cpu->intel_pt_auto_level) {
-                x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
-            } else if (cpu->env.cpuid_min_level < 0x14) {
-                mark_unavailable_features(cpu, FEAT_7_0_EBX,
-                    CPUID_7_0_EBX_INTEL_PT,
-                    "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
-            }
+    /* Intel Processor Trace requires CPUID[0x14] */
+    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
+        if (cpu->intel_pt_auto_level) {
+            x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
+        } else if (cpu->env.cpuid_min_level < 0x14) {
+            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT,
+                "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...,intel-pt=on,min-level=0x14\"");
         }
+    }
 
-        /*
-         * Intel CPU topology with multi-dies support requires CPUID[0x1F].
-         * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
-         * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
-         * cpu->vendor_cpuid_only has been unset for compatibility with older
-         * machine types.
-         */
-        if (x86_has_extended_topo(env->avail_cpu_topo) &&
-            (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
-        }
+    /*
+     * Intel CPU topology with multi-dies support requires CPUID[0x1F].
+     * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
+     * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
+     * cpu->vendor_cpuid_only has been unset for compatibility with older
+     * machine types.
+     */
+    if (x86_has_extended_topo(env->avail_cpu_topo) &&
+        (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
+    }
 
-        /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
-        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
-        }
+    /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
+    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
+    }
 
-        /* SVM requires CPUID[0x8000000A] */
-        if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
-        }
+    /* SVM requires CPUID[0x8000000A] */
+    if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
+    }
 
-        /* SEV requires CPUID[0x8000001F] */
-        if (sev_enabled()) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
-        }
+    /* SEV requires CPUID[0x8000001F] */
+    if (sev_enabled()) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
+    }
 
-        if (env->features[FEAT_8000_0021_EAX]) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
-        }
+    if (env->features[FEAT_8000_0021_EAX]) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
+    }
 
-        /* SGX requires CPUID[0x12] for EPC enumeration */
-        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
-            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
-        }
+    /* SGX requires CPUID[0x12] for EPC enumeration */
+    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
+        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
     }
 
     /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
@@ -8820,7 +8817,6 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_UINT32("min-xlevel2", X86CPU, env.cpuid_min_xlevel2, 0),
     DEFINE_PROP_UINT8("avx10-version", X86CPU, env.avx10_version, 0),
     DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
-    DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
     DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_features_only, true),
-- 
2.47.1


