Return-Path: <kvm+bounces-45880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D37AAFBC8
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 644F51BA0D27
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A377522A807;
	Thu,  8 May 2025 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R7pWnIyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4064F84D13
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711811; cv=none; b=YGDXbbLQFa9bb02uWRtC7TyBWVeV5fUOcCFREH8SqgKMCud52GPDz+uKTZEM2hZ9QyqlfHV7DIaNKrrcIuInwblhjy2XlqZX3BRimZa+JK8tGuIrG6j27eBGFvDAbkoSc5QDsVGcyjvNRekGrFYVUUFA44Ww1K39n8rVREDSDVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711811; c=relaxed/simple;
	bh=1DPdZRXrBAQS6oDMAMM5AvEs3lDC6vfohrFQOHeSLEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ekXQGZXfGgPwZh7aasGLdFTWjqqtxjcY3yopwtwZrgKC1plo/z72PdFGivjLUyOZkHMLjymEkuniUCk1EX0U8u0TTvQ/Bdc8CJdug4fLbzhB4gEdRCedJmuFCZobjUWFWktxmnB5Vwrq+F2aOe49lJVj//fILi0P/vU6EbvtgXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R7pWnIyp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e76850b80so7573645ad.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711809; x=1747316609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfVenGRAMwE+Z64hRHr90BeNRoYPJugExqalvrobNt0=;
        b=R7pWnIypgVavSB/hNp5huG0MEQV37jWcb8jJMxWpwMghOKKGoh1E9LwrzZ5XoPnWk2
         OWk26S4PhhPDwy5wBK/LLdCZLymIyX0mwH6HL6yDqXadPcFojlRZ6URhUqCzLUdis2Zx
         ScMlTojEn6lrCojJ5AbwmnlfZL/CxzezyglRZkPvcswV9YvJUx7qu+aQMKP3gYhdabBe
         ALyM0GXCLjVWKrsUOSzm+x4qKioBfT59TOlCOVA2NnLI7bldWC5znry5Hu6+zvJC2K8x
         DCA0RtIuXaoGL/K2GQG9HPRcPFlmzUm1ur8wbeN8cnIL0y31xJzNPA9P/Uemajoq52Yb
         i+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711809; x=1747316609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfVenGRAMwE+Z64hRHr90BeNRoYPJugExqalvrobNt0=;
        b=iUFN71vLah3g85Jnx9YoDhDi/30SAi37oBwwgtG9i/Q5MTaIF7scZiWMvieuE+Umo8
         JHPHq2Wt6gHa6yGks4R5GnXtdFD1de+1s5RCV7mPwcBKkBbVBTQRtHfihObeFeDHgp5V
         xOu0P+XMwd745/JHEdAUS6mpWl+D96saDRTAcrhWPPGjH1p8dG3NDw6lMDfslhzeu/pE
         Qe+vcDR27i2aeJ0nFsHkCEJMB3dqW0BF8P4uaQbFG63RBppR61V208L5RbiwEX3LpjLE
         TqXimPR5njbDfiqaNFVSwfHycyJvYKGLE/Ri5osPXp1AppBRhKvSRp3PLD429dYj6ep7
         YQ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVvL7G6oOzsreeU29vUWtq+FW4A8fYgrbdypjdloxco2TJze3tWKTc6hjylJ0JglW69P64=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwkhhQStAg0dzX7+0xFtINq3JB1tcQQGfD17FXZ/41VecX3NBp
	whVuy+5KTwy8ixHYwNH6dR6REO5fUEnUxYPEkKJy6eFOyZdfN6V8actOkroDisU=
X-Gm-Gg: ASbGncvdklrRDVOj1INfLfU5xPzwrmR+FziQB90AT29AavVr4pCBon8XS6hebJ1bhSM
	178EzixHrZxvZmmkjFemMweIuD+mf945H2jEduSW1OlKxCpuI/X0xC5iWZN8VUfvC03yqZsMnaN
	3NEBXMO9w6Rdi2iQCDkVXI0bSI2y2PxMYFp6a+BP+TkpTsSZHg+SjDrPrc9bLmu/WPTd+41AQMU
	dmoq0NRB6j7v9rQ/0PUL9cmR21cumeBaMul2PpTkm4Tn7BL5hfZK75MSAshl8RgJQ94EG3iSuH0
	JB9QJOs/vVGDxLI3/O4VU6Lig9U2hNE6gJqNCLWgyvtah2bXCVjWx8+XiRTQnORvBjLe5Dic/Lg
	BCS9PI3gq8CG2qMo=
X-Google-Smtp-Source: AGHT+IFUTjKWPVkUkd1NBRniOTZ1k0pEbrW8dI3RWonTdhC9W5HoKkZnRoLeVCQ+2VhsISUWKpmYUg==
X-Received: by 2002:a17:902:da84:b0:224:11fc:40c0 with SMTP id d9443c01a7336-22e85613e2amr56447695ad.11.1746711809443;
        Thu, 08 May 2025 06:43:29 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15228fa7sm111988195ad.181.2025.05.08.06.43.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:43:29 -0700 (PDT)
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
Subject: [PATCH v4 20/27] target/i386/cpu: Remove CPUX86State::enable_l3_cache field
Date: Thu,  8 May 2025 15:35:43 +0200
Message-ID: <20250508133550.81391-21-philmd@linaro.org>
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

The CPUX86State::enable_l3_cache boolean was only disabled
for the pc-q35-2.7 and pc-i440fx-2.7 machines, which got
removed.  Being now always %true, we can remove it and simplify
cpu_x86_cpuid() and encode_cache_cpuid80000006().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h |  6 ------
 target/i386/cpu.c | 39 +++++++++++++--------------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b5cbd91c156..62239b0a562 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2219,12 +2219,6 @@ struct ArchCPU {
      */
     bool enable_lmce;
 
-    /* Compatibility bits for old machine types.
-     * If true present virtual l3 cache for VM, the vcpus in the same virtual
-     * socket share an virtual l3 cache.
-     */
-    bool enable_l3_cache;
-
     /* Compatibility bits for old machine types.
      * If true present L1 cache as per-thread, not per-core.
      */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6b9a1f2251a..4be174ea9c7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -468,17 +468,13 @@ static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
            (AMD_ENC_ASSOC(l2->associativity) << 12) |
            (l2->lines_per_tag << 8) | (l2->line_size);
 
-    if (l3) {
-        assert(l3->size % (512 * 1024) == 0);
-        assert(l3->associativity > 0);
-        assert(l3->lines_per_tag > 0);
-        assert(l3->line_size > 0);
-        *edx = ((l3->size / (512 * 1024)) << 18) |
-               (AMD_ENC_ASSOC(l3->associativity) << 12) |
-               (l3->lines_per_tag << 8) | (l3->line_size);
-    } else {
-        *edx = 0;
-    }
+    assert(l3->size % (512 * 1024) == 0);
+    assert(l3->associativity > 0);
+    assert(l3->lines_per_tag > 0);
+    assert(l3->line_size > 0);
+    *edx = ((l3->size / (512 * 1024)) << 18) |
+           (AMD_ENC_ASSOC(l3->associativity) << 12) |
+           (l3->lines_per_tag << 8) | (l3->line_size);
 }
 
 /* Encode cache info for CPUID[8000001D] */
@@ -6849,11 +6845,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         *eax = 1; /* Number of CPUID[EAX=2] calls required */
         *ebx = 0;
-        if (!cpu->enable_l3_cache) {
-            *ecx = 0;
-        } else {
-            *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
-        }
+        *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
         *edx = (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1d_cache) << 16) |
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
@@ -6907,13 +6899,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
-                if (cpu->enable_l3_cache) {
-                    encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        topo_info,
-                                        eax, ebx, ecx, edx);
-                    break;
-                }
-                /* fall through */
+                encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
+                                    topo_info,
+                                    eax, ebx, ecx, edx);
+                break;
             default: /* end of info */
                 *eax = *ebx = *ecx = *edx = 0;
                 break;
@@ -7284,8 +7273,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (AMD_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
                (L2_ITLB_4K_ENTRIES);
         encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
-                                   cpu->enable_l3_cache ?
-                                   env->cache_info_amd.l3_cache : NULL,
+                                   env->cache_info_amd.l3_cache,
                                    ecx, edx);
         break;
     case 0x80000007:
@@ -8821,7 +8809,6 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
     DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_features_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
-    DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
     DEFINE_PROP_BOOL("kvm-pv-enforce-cpuid", X86CPU, kvm_pv_enforce_cpuid,
                      false),
     DEFINE_PROP_BOOL("vmware-cpuid-freq", X86CPU, vmware_cpuid_freq, true),
-- 
2.47.1


