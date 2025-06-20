Return-Path: <kvm+bounces-50076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B77AE1B81
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A05716960C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3113728CF6C;
	Fri, 20 Jun 2025 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vW4dl0K/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B028D8E2
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424885; cv=none; b=V6RGgVodF8av81/eI7Xae3jbUyDGE9WjOWyNh0N2nu8pLCILT6P01T5aU/4VGam759G42t0YhtcuDdkum9YKYLtR5nAm49YRYGtWBx2Rzrvl7YJ7zxCDgVNsxEwQVwdScH9E2hbt0g0FzNZx6gewaEueaRQtvKvh8ZtgUynimrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424885; c=relaxed/simple;
	bh=cAWshMd8vzRKluuPhyw0wwsJtSS12+oKhiwVMhrpOGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nb3oaA/lXFXJk66zctS8l4LqfqH1GHxKfbVeX4qYxc3Xd/M42iUMadbzw4pMh7nIVbVJrxsITaXNw6sDcKnm02r09zekwN9VbnOX+1kl7pfpBEboJYAFfIjTG+hjktThb7S25IQjYvGg4UdfAwj6cnB0GPiLmdrm37JoevfX9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vW4dl0K/; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-450cfb79177so9801225e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424882; x=1751029682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHkUxhiwznLnPGQ7CmoJiivDkUiQkmNfBetsY13UZBg=;
        b=vW4dl0K/GX/zE/0s3oZuNf8AD/4dnEYj8T+oo5oPclT18fyMOHvqwvzyR6aeI95Ku+
         Ez3+y9SA3z731FmuX7nbzYOCmqAny1DMdF6WU5ZqBGUX1fcBWeINpKL++PaOXfls3wIk
         1HMrqXG/kut102eZR4HDq4QGmq3KQX94pbde2ahc8//GSyaRgaJf4S5831f5Fl53WZ7V
         ardeOP69nAdhAeaf8LIUUDWCppkJj+inXTfyWliRMeM0B7W3VQi7RMdWjjvwKVju41MM
         gfk9kLY3h9DgVYkLuMaorI4kBqfkk+X2quvNwi2N2g0Gof28KucufMScNH8kMZDyMdt2
         jbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424882; x=1751029682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHkUxhiwznLnPGQ7CmoJiivDkUiQkmNfBetsY13UZBg=;
        b=vp0SVHyFu7Ll79srF3mTBgziEag3GxCJ7Y+zI9N2Kdm8FrI83K9WcbQgtGwlvg9K3y
         VbSin6m1UBcRSulJYEvPSYDykXGnuejqUOsbwkRMrsOIyyC5kiyL9s7TPUNYPHupA03z
         UfyDOquxu7Ly3kR4en9XX2exrgXuX++gHVXlAQyBCsFv5pnxwJkPeoQEKUf8D7M3pU2k
         GaSLxfQgdaBe05cFIm8jXJPd3+IRdKZlcQlSx/OlJVVsWStYZqwklxJ9Hr7NxP1I6KWS
         YVx/S/dLa0aeyqE080Q+a7/FSSvPDF3zgGB0N+m5hYFmhastgvRiiDP6UArUbhvaAVyZ
         hhKw==
X-Forwarded-Encrypted: i=1; AJvYcCVIXadpIu4nR3AIbPThDm9k8BoQtV4SQ1nMsqXi63M0Fix9vxReVsYXSurAsLu5rRx3QfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR+KKCK9aXFMQSHT6S39MJiPYNCELn09wmehOFOe7oOVJoeqpa
	qpqi6T69HyH2jqYVxpz46muTRRLN8Gd3frDdlMcFBfTozPLY8lwBixUW8gint+9Y70E=
X-Gm-Gg: ASbGncvNjta2T/wtA1KfNzCFW3U4/fOiX09+ucAFgRXEqleR9peEgcYP26IrstDwIvf
	d7aagktJOJs/oOdqdexmih5dmGFMg2Ag3SiXOFGVZLV47Vy7myKWfxVzzLF0lJUX5j0Onuq3vQg
	E/MvgNsX5ZPM/K4kt6ST9nX/4DuIurlXjcZFK9ovnB7k3+rRp4eNz6FgOKIWWXEW7//QjRGE4lI
	Wre5VTMHh0/IQK9JFjRp376LH6Lkm3gn8UX3ymKiUMJ5JHAu0zox1G2TVJ/MgU6V39LiOF5YybV
	DYKZeaHEMZw0Ax0t/3oVGl3ft2p7gbC/EKDQg1cV5v3c03bsoSEkwxiSYBAM0r4+TxzGNttXHMX
	1Kx1R3HuAwklQZvqo5+o1FWgf+UnZoU6kKIsV
X-Google-Smtp-Source: AGHT+IFIRA+QgEzXaz5Kv5aRlxYuLkZKTx/pYgPZDxWBgIRvFsRGsi3xvxXp90rTSlKsbLeeXas7Hg==
X-Received: by 2002:a05:600c:3acf:b0:440:6a37:be0d with SMTP id 5b1f17b1804b1-453655c3d4fmr28644125e9.15.1750424882015;
        Fri, 20 Jun 2025 06:08:02 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e98b66asm57984935e9.17.2025.06.20.06.08.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:01 -0700 (PDT)
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
Subject: [PATCH v2 09/26] target/arm: Correct KVM & HVF dtb_compatible value
Date: Fri, 20 Jun 2025 15:06:52 +0200
Message-ID: <20250620130709.31073-10-philmd@linaro.org>
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

Linux kernel knows how to parse "arm,armv8", not "arm,arm-v8".

See arch/arm64/boot/dts/foundation-v8.dts:

  https://github.com/torvalds/linux/commit/90556ca1ebdd

Fixes: 26861c7ce06 ("target-arm: Add minimal KVM AArch64 support")
Fixes: 585df85efea ("hvf: arm: Implement -cpu host")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


