Return-Path: <kvm+bounces-50322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC82AE3FA4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9FC57A3FAC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A91C242D99;
	Mon, 23 Jun 2025 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Be4Byts0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1423D2BF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681187; cv=none; b=OoKNimtuTrGwUMCRTuT7oTsvpOpuRmkFmtexpxfRiU2LhSRgy9wjLRQnmgJZHlDCvO9dEZN83JcQFNzNK2RDcs2ETLazg4hg6ATBERti/CkvsQgR2krPFgusfZ698vm3guxxsRBzkZkR46VsFshMFTo/UjkBiaeoVTVX2e1vlU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681187; c=relaxed/simple;
	bh=+DBhpbpCKgsijeRb7QPhXIgSV2/9qSiYA+5kXEQs2PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NCSE0YNyGMRZemMjCIwj50vVe9+em5F/+hB1xnPOlMdSzHfVRcl7sGs9M26Gdpl1tkB/SSCqG83Q8lUiIN4yO1VIpGftEBtRD11/S47D5m7A8yWttc+3KzJyeJ/Q1rc0fKyboa7jNmOqSEaWBFSOJkDQkYzSDBfDLSq3Dxpz8Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Be4Byts0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so3235194f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681184; x=1751285984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG0rGkpeQcTfIwjCevzyaz+W/QtJY+1YJlHHFNrDtaE=;
        b=Be4Byts0rDV8gTeKsJ3Z8CTu8ClpQtY0l4ci1WixD+umGfOFdnAdaIchM42bTSXIok
         Lq7yvO4zvevcPX0hBeprebr0wYBB/sxEmTvqr7Pp2OzQWhKymlliho6HRulsaVN7LoDC
         E8dlX/PWYALph4W64Rd8GNouVGGsgKWFVksvzM1UHI3xSManFoU7y9GLsGQsfTAaoS6A
         LBf/UEHL2My+u95xNuGeL3BvQbDLGWll/sbENEEqnmnnkRDrVDlo5hmpxU9gqtD3srUu
         bns2rvcwKXaUFtgPmvMdnKGdCOoKhAyW/WEWSqVNEhGM1msORUUzyOtfs9S8wLwGY2nu
         zjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681184; x=1751285984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG0rGkpeQcTfIwjCevzyaz+W/QtJY+1YJlHHFNrDtaE=;
        b=TI+h9VvoZK2lamDkB9vs8cSnTxTnAb6X8QEi3nCtQnpBqNkPLTdpu1C7pPQVJh88LJ
         Ay0wQrvjaret4oIfjTE5cGh+JrSLrheMwHdkzMGKxGZXsnv1tOwZCzWot4ZZiJ3WXWLH
         EP93eMpQcPSeiGmZV/Kt0fdQowpJqF4GebBDxZlAgzXpWoAeH23snEepJh2M7tzTpYr9
         4NhfoOKI/4R2cXiojh6IH5n2JWH17dnlhvgPOX92ZkN3jj6lDfeUbS9QomapnRhANXiC
         l7snIT9Q1kF84Joi1/LCUQCpLKmNejGw9FVHNQzoG3AXaDpEThvivJydelVnHujucZ2U
         ipQg==
X-Forwarded-Encrypted: i=1; AJvYcCXGP29b7L2nlKvHCPNWtLtkOQYwIJOY+siLfMqd31E91wzTIw+YOIFNFm6L43ZsA5ykGt4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGxS7QrCDEYTD8wgRMOUwktc1RNVWbZYjbf1NSsVDrleSucXMn
	5m2g2uoUmpwwWvtYnEiBMjU1ovSwlR8iKQs60IEPrS2y850ldnNafu+cjhCvbMCq9RM=
X-Gm-Gg: ASbGncsWTcYI0nByuiIRIIgLnjW/j6/gWBfWGmp/KDkgpN00U9JWPTgbRCe+AN3x+DR
	h5sgrtoBrKkBuACa9/CjmS05aH3kKSmrH/QCjzmnpIjuatcREHYJQtqEqwdrwFI9yCuuPayG6M4
	n0vD9eIm8th+A4Pnba7I+vNwH2FsSDdPDEp9UtMMpSdZkLLqa9fwtpcwSgJCbF749BK892fGCpy
	HhCARmAdyc6rpxPziOpC9wt5ZtHqv0axrnRExoEhUVE6rg39zVzBBjOo3E7F2Qiz95EMvHcWPQ9
	J5FQs6YIp5bSNx0O3otpYYK8w9jGquXUaJW+/ma3m3sDfnILNCTeO7m6jdiBwKR4nSeE/ogrrMd
	R4KcN4FswWqcUzzf6PCRTjXHnx+OIv6myz8uH
X-Google-Smtp-Source: AGHT+IHTcK8NRdR7PNArgyYQkG0nUCVoom+k7oQ1rJFLDhrBWTeykxYJUpFWrxkFgsUFr33IXybNlg==
X-Received: by 2002:a5d:64ce:0:b0:3a4:f513:7f03 with SMTP id ffacd0b85a97d-3a6d1303b0fmr9477486f8f.44.1750681183940;
        Mon, 23 Jun 2025 05:19:43 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646d14f3sm108727095e9.13.2025.06.23.05.19.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:43 -0700 (PDT)
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
Subject: [PATCH v3 11/26] target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
Date: Mon, 23 Jun 2025 14:18:30 +0200
Message-ID: <20250623121845.7214-12-philmd@linaro.org>
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

In preparation of raising exceptions at EL2, add the 'target_el'
argument to hvf_raise_exception().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


