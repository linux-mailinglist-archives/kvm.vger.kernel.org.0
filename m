Return-Path: <kvm+bounces-50320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859B0AE4003
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338DE3BC424
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05AB246BAA;
	Mon, 23 Jun 2025 12:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PzmtgcZq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C6246791
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681181; cv=none; b=ON973nZPd8uz54SKDaY4d67pPEKcr+RlqLKQdWjZX4FB2HpiihDX8RJbAK/gpan3X++WssgKRteuYEZvOTQVIJ3KtMgjWEJPlopzqJ+YH5z3wN39BEqPWJ7tB0xYsEbwyxrfVCMP2uy29ZIoMzgWIAzNb2d3vLjG04/4cHyaJak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681181; c=relaxed/simple;
	bh=HxNunKVv87y+lC/++/jjCIzc9tbwNcMQQoHP/47rfTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hezN+MCrtN5UAuHBGfbcvAMwxTAYkrUWvRrnWuhe/26ZprEkAymvxp5U5JahoopjtSIjr9nahVitXHOS/q6Di0sPYW3RY7EMo52b7eccBM6WF7iCLlRNT1fIKM24Fmv6aiXeny4eamldvOQwK4068Hbpfgmov/mCqNJ1kP7W54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PzmtgcZq; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a522224582so1926341f8f.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681174; x=1751285974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgoMlu6luU8uPkDpvUPvEjZTODhHkmT/W4wpYdZo59E=;
        b=PzmtgcZqWOWb4/P4v1ylQUu15qkl0l9W2nYB2kHzXpC1MQsMD9gGWywzSrbS4ec5Z2
         839Y4HCE0/sR3T7jy+FtbIlzavS1Mo8zHAD20CXvzj1GTlK09h2xEG455R85Ld2yilCs
         nwcTPUWtbXzvchGEF5+kVg1UDesmfJhUUjj55Ky9vKCYM1T3osbDslhRmeNCILkJ/PwL
         ZaxRbnfyUfo9u0dJ25hAELjifQxp9kAmMMFmbQ6PlD/y5zsCaeeIpf/5Tmsu2GbunEeu
         Vr1tJRlkPeJrOvy8tLj2L36cgbRDD9S7LD09hqN8Lpdn7OIc/VMEkGvIQo+L//78KLJC
         I5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681174; x=1751285974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgoMlu6luU8uPkDpvUPvEjZTODhHkmT/W4wpYdZo59E=;
        b=vU/Jdw7A1Y8P87gar5AuiRZ2Dzx9WRXHxfQvtUF1zGpY7mHNSe2KuQl4ICT52AoXz1
         pvrlPS9DLSiVFxArVHBDsonYUoBhALBpGqAGOKS3sDUKmXnnRlpgEx6No7/9lWX3A84I
         hpu/+Qyn5cf4MB2JIbHLevIG+Bu4HPKxyvJc/VHs5JTltHq5l14zdY3co2LeqLZNzhGS
         BrRnqXUBb0JEdm+lVC7ndqc0/UcnudsTv/GAEOF09h2d9/zneXI/KOxZAA7ifxmJ9eBu
         +QsY7r1LE1TMMXcQxA9JYdX9nFxvdySQScNzHS/3Genrr5GHz2B0oZPRzkqgtIIuI2zK
         yzsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW47Rzon3nCpdYb9BYzpBR60wLUQYehADTrh0k2et4oIffls6/Q0HE8c6JW0c2buXOIapo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoXyhuGmQDWEU9roQSCCr2gvsBnwOKJ03A5cdkCLnGsHZEOlNg
	7noybyvqrpgPvmjwM70xaOI+CAGqFc5q6SnNW0lr6tDR4qUVMitcwf4NQ2GwM1jIKgE=
X-Gm-Gg: ASbGnctm34kRsgoAqrZHsYZYCV7ZW/lxqHaZ+5sulaFRmQwDvEYHbhsz6v2E10kOmuE
	JXgt7HtP2Rgi0Ldy0ZK/pI+3J7xgy/U+bEw24znBc2UCiK5Q0b2yJlig21ZZHXwkkEx+YLd/r1l
	3dka/rXr83Pa6PBQAnKRLySEqQlb9xipF4R31sbmWaBJ/mIhjlQ4FrApzXVRvJEoYQ54zae9e/Y
	0dS9JgnFfONoF8CA8Vk+ONmmVdl1zfJuAyBZX7s+icqy1duuPqmU9QSntG0e5XXM2bvJbM6+sS7
	5wG02BIQbGq0O3XCS2C+28T5qi4wwMi6mU1XLkA6fozq8BRsZR4K+8OadkWnkTwi4DFro38s8B7
	Hs1L//sNNO9YaG6M7q9vq6EPVinRnZsKIYgqo
X-Google-Smtp-Source: AGHT+IH5nN0Buqju33OA312k0qD0vKiMOH8kEulBGzTvtfmPtg2jIEiKfCSnA60Z3UW/VHNqpVWLLw==
X-Received: by 2002:a5d:584c:0:b0:3a4:e6bb:2d32 with SMTP id ffacd0b85a97d-3a6d12a2416mr9606493f8f.22.1750681173855;
        Mon, 23 Jun 2025 05:19:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f1054bsm9217868f8f.9.2025.06.23.05.19.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:33 -0700 (PDT)
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
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-stable@nongnu.org
Subject: [PATCH v3 09/26] target/arm: Correct KVM & HVF dtb_compatible value
Date: Mon, 23 Jun 2025 14:18:28 +0200
Message-ID: <20250623121845.7214-10-philmd@linaro.org>
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

Linux kernel knows how to parse "arm,armv8", not "arm,arm-v8".

See arch/arm64/boot/dts/foundation-v8.dts:

  https://github.com/torvalds/linux/commit/90556ca1ebdd

Cc: qemu-stable@nongnu.org
Fixes: 26861c7ce06 ("target-arm: Add minimal KVM AArch64 support")
Fixes: 585df85efea ("hvf: arm: Implement -cpu host")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 2 +-
 target/arm/kvm.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index d4c58516e8b..bf59b17dcb9 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -879,7 +879,7 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     hv_vcpu_exit_t *exit;
     int i;
 
-    ahcf->dtb_compatible = "arm,arm-v8";
+    ahcf->dtb_compatible = "arm,armv8";
     ahcf->features = (1ULL << ARM_FEATURE_V8) |
                      (1ULL << ARM_FEATURE_NEON) |
                      (1ULL << ARM_FEATURE_AARCH64) |
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 74fda8b8090..9a1b031556a 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -266,7 +266,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     }
 
     ahcf->target = init.target;
-    ahcf->dtb_compatible = "arm,arm-v8";
+    ahcf->dtb_compatible = "arm,armv8";
 
     err = read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr0,
                          ARM64_SYS_REG(3, 0, 0, 4, 0));
-- 
2.49.0


