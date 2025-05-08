Return-Path: <kvm+bounces-45872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510AAAAFBAB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6FAD4C4CF9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46BE22B8CC;
	Thu,  8 May 2025 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VFHB0K9E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566694B1E6D
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711656; cv=none; b=a9KZSeLVXMjaltUNGCgVydYdXVoiOMRnmEla04o8ZAgAAdMNZ7La8J3SSGh7MQyOYnDEpu0utj0OoSdaXg9yWriHatJRZKXM2hNHeZi6cmXjgsz9d2VOps+UQMvj3Su5iWPFxcU/1Ly/xcnA3HE2fe4sE1/lLdOnDOTWtTzkYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711656; c=relaxed/simple;
	bh=NqL/KPnW3rHo+PJFRpMlW3G98lRMn8/Ip73RFjJkb5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lK3T2WwVbIaxfer49lLiOCZgB8pMo4uwjSaugc5DTR6xMOzrwWT4TLClxg6LmlptqmxoekAuNFTwVWnlWcbl6Sg3HA8J2emd7B1+CgCIkWnEsdnCtU2aNiiq7UsA1pjXQM+dI6XN9T+p3N/9GOguV19a5anZX/mKWKCS7bu8cWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VFHB0K9E; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2264aefc45dso14444485ad.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711653; x=1747316453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAafb+dHM0R7U2T8OMZzAcuOcBI3QoaSzAwGll5ygQs=;
        b=VFHB0K9Emv9MP5XpBafFr2bkj6JXcs1W0g/EwmNf0HsUBMZZ+sBeYTvOQkT/KAkrOV
         hUQ6iPZGzF9Bhz7IXVYxaQe0ihGf54MeGX89R30Gs8YG0JrSqxAyD2yvqOmD0LOToNq7
         0NY9YNxjB4KdohvZq5obntsnNVZmhs0N7wjz6J5bM8nChxNReACZpQ+v+GvM3UGfX5qS
         /t7pZ+ndCWpTX1z/Vidonp7jGyTytQw4/+rkugJa2Momon+YyIFWC5vDjmCgTKMuzolh
         2EzOXFjR87X9w1Bm42zVVKmTnbHTL4Ha0KH/cqO+m2hrxgfwpiZ3NXiJbLrzIFMGooZC
         rXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711653; x=1747316453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mAafb+dHM0R7U2T8OMZzAcuOcBI3QoaSzAwGll5ygQs=;
        b=wlFc7npnRE2FiOSYijQ8GOvyp8Vdsoew84dAozMVS1vGzYCj5vVetNDPHsL5iJPdhI
         iQaDaJ2Tw+3G/GXJTibHx7hhf0ZErq7Z2pbKh/uHHAL2HgZm3kHZF07glToD9f0X++ZA
         /HuPM3cmQ1aAJM2llNZ3JgH3DIit50PrjgPKsJNitzncj8RLfXR11y5m+8jUDjspzgHd
         ViPY4RTWjHQkQtxpS+mTomE/jQi2GQcGBjqXIiN7Z20E0fxMEojVzcN8k4TsV4i1bytL
         bWpAqO9EXiPepya3fgKPdb4TNC2atJsHBebp7pBBW/HQthdnuYX2FSBAI4+Ch1YyVt4H
         hAXw==
X-Forwarded-Encrypted: i=1; AJvYcCVrNc+gLOaqaTG9MukpCpooQXIAQF3Etbk1jA9cyHHJyB5RRV7NOKnqqyY2SaZqQTjF/i8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZn7/T/FIf3XUGD5lDo/2iEvvTmrvkJ/s2eDlRw2xnMs80GUqM
	QUMQR3tj3RW6m2+4VWPhhlJpBQEwQPC6nFBQLxBETlG4FqH3CuEfOzJSVxhqZfs=
X-Gm-Gg: ASbGncuFZgXI4NH2DtgAnOb/T6zdGGbn8Ikmn70srGdpXlOtMN9TDezyB3OjKoii9y1
	p6Rr+4EnXXWduMCwQ7mV64prnRcBhaJ43oW/WPprwJT2vQSCH+FeJyFdzUe5eRlKQA3fKojghwe
	32T9OKohqbGMZaeIeHVMuqCc/Z+T362vxTIa2jS1XVrxRWjaxscWf5kxzD+VY/qvrlFartxyfN+
	+bEGnzutLSnSs+SWlRmr/0mX2sBUsd4a2y2kp8OsusFJMeM0QHUpiNkyeGfEm8YG8MXmnL8qpe+
	M8mM3vEoNEitAKX6y9VSkiiEopil/C+hgHoL0KJkHSwhO2i+bQOFGpehR2gjguq+o1hqmtafjvB
	3S8HTP0kaBHpmkzg=
X-Google-Smtp-Source: AGHT+IH2y/VUfyrC8R22FpXXRo/ODUgoWXOAiZYF8dEokDeUe9aZgmQXy0YOuspLaJeraSPMUSaU9w==
X-Received: by 2002:a17:903:194e:b0:224:f12:3734 with SMTP id d9443c01a7336-22e8660509bmr47849675ad.30.1746711653500;
        Thu, 08 May 2025 06:40:53 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e150eb5d2sm112359365ad.7.2025.05.08.06.40.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:40:53 -0700 (PDT)
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
Subject: [PATCH v4 13/27] target/i386/cpu: Remove CPUX86State::fill_mtrr_mask field
Date: Thu,  8 May 2025 15:35:36 +0200
Message-ID: <20250508133550.81391-14-philmd@linaro.org>
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

The CPUX86State::fill_mtrr_mask boolean was only disabled
for the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
removed. Being now always %true, we can remove it and simplify
kvm_get_msrs().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h     |  3 ---
 target/i386/cpu.c     |  1 -
 target/i386/kvm/kvm.c | 10 +++-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 06817a31cf9..7585407da54 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2253,9 +2253,6 @@ struct ArchCPU {
     /* Enable auto level-increase for Intel Processor Trace leave */
     bool intel_pt_auto_level;
 
-    /* if true fill the top bits of the MTRR_PHYSMASKn variable range */
-    bool fill_mtrr_mask;
-
     /* if true override the phys_bits value with a value read from the host */
     bool host_phys_bits;
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6fe37f71b1e..fb505d13122 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8810,7 +8810,6 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_UINT32("guest-phys-bits", X86CPU, guest_phys_bits, -1),
     DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
     DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_limit, 0),
-    DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
     DEFINE_PROP_UINT32("level-func7", X86CPU, env.cpuid_level_func7,
                        UINT32_MAX),
     DEFINE_PROP_UINT32("level", X86CPU, env.cpuid_level, UINT32_MAX),
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c9a3c02e3e3..87edce99e85 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4635,13 +4635,9 @@ static int kvm_get_msrs(X86CPU *cpu)
      * we're migrating to.
      */
 
-    if (cpu->fill_mtrr_mask) {
-        QEMU_BUILD_BUG_ON(TARGET_PHYS_ADDR_SPACE_BITS > 52);
-        assert(cpu->phys_bits <= TARGET_PHYS_ADDR_SPACE_BITS);
-        mtrr_top_bits = MAKE_64BIT_MASK(cpu->phys_bits, 52 - cpu->phys_bits);
-    } else {
-        mtrr_top_bits = 0;
-    }
+    QEMU_BUILD_BUG_ON(TARGET_PHYS_ADDR_SPACE_BITS > 52);
+    assert(cpu->phys_bits <= TARGET_PHYS_ADDR_SPACE_BITS);
+    mtrr_top_bits = MAKE_64BIT_MASK(cpu->phys_bits, 52 - cpu->phys_bits);
 
     for (i = 0; i < ret; i++) {
         uint32_t index = msrs[i].index;
-- 
2.47.1


