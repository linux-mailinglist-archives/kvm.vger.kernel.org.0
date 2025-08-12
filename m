Return-Path: <kvm+bounces-54530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7F5B22F0B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BE20166430
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67442FDC25;
	Tue, 12 Aug 2025 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RoyOu9Nw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5821D596
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019714; cv=none; b=nje/a7T1D4F8MGLwo0gvKJ5u9jBIRNEn+gnW5WFLvX3SiKYCYI2xQ/UwQs0IfW7uVAKWUZ2zvxWBY79xdCKq8wZmg+i6ga1nR3xpfADTkructxDzD5KfxwVEAGaf7P1i5Ks2ftKHkeZl6ILRvFSyNb5pvMF04TiHEhf5GVJcorQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019714; c=relaxed/simple;
	bh=biYhynh5VtlPMW5C9lkL839XZRJSsoYCWslawzM4S+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TI2BywPvYmi/zhPexxUFeOl5qHDvOSHLjaEyxA/ki917hxNA9p5xkbtklWbplzb24x5DhMYbINcvrgfumqLDJ4wUKsw98GUCuA/xFrurOyje8Lw/+8gdhpDBCs1PSo9Hne1QOiXy3kH1MILkgUO4LAJR/+2Kp5X5Y26YlDELcLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RoyOu9Nw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459e3926cbbso24869585e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019711; x=1755624511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbl7ajSiNJK7b98o2AX/9HHrEnoB7DYhJ//FpfdP6jM=;
        b=RoyOu9NwhdhjBoFxBPs4rih/4b4fgLhuIWXHj5L/6TBIyrMKK37ByL2NmEykPmLwNM
         P0kDp2M3sCmlNjc1i9wLC5M3ISxwdxomPVigdIEfY73K+4E2aK2diRwQljRtcW0kiBi4
         DjITc6AiuN+gWrzXxw49gsLT4Idmed/HP6F2fPh0HtqCDofRFXU4n2QTqf6sHVBK6faN
         m01fJMMLDF+ijWXHwPiVmYR6reKU8E+EO/E8FsjVx5bCMo3QPj+kf8/Z2NlKVeCuxNFM
         mzmRoCg1wOSmpwp6lE4K5WrL66zAxYX+x5QRohdSVjYnllAxqjugCb4TCoKZB6L50k9h
         xBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019711; x=1755624511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbl7ajSiNJK7b98o2AX/9HHrEnoB7DYhJ//FpfdP6jM=;
        b=QUiNKUQPWpHRmQPqDx1ft6rQQ/e+PThvWx5ewg4qIGH47cOptOVp1gjWzJ/oyDAVxU
         g4eWzUUDU1VTnY+PUA/ndxn3I0XxqI3TbvEKoG2o58So5TEuint6ikWfcVmQk78ebr++
         wheOQyy14LZuwgBJj4MFzNOsxRTl7B8tSYDyS4cDnuAwkAia7tYeYJrFMvi39inwqK1N
         wVVXnoJ8jRqGA5Ke6sQDMFJ4cXqSW2LGTXi4iwAdJ5d2KpCCmCNqaIo51cRnOjfOdWxz
         91cPV0iFwMr2ejtSEF0COjUNxRaM0+eodjXyLFBCo34gUeUTLfQwlxKGtTzk05FoxQ5r
         4Kuw==
X-Forwarded-Encrypted: i=1; AJvYcCVSnT3Srg7Iwxw3TTae5Yj5rSGuzqOclQT5OcVB3AWjARtJxdj3Jqu6FKnitkUsmjHXl5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YynvI9LIwau6jkutIQDKp+1Fq6X+CjA5tKlPsdSowoxJH8db9kQ
	E+AlwP/yUv8xMuO7HHXiAalRIKEZdUZ/+kRMt+cTKWxT0SBj0woHyo5J34KotkoykHg=
X-Gm-Gg: ASbGncsetj79FTwqc81CXzfOURVKvLnMq5ApHfQQjCalmd36m/cvmnwhpJM70/6P9GB
	uKLPNjPHNWe8jKsEojA86BujAwNCWY7sRduB/Kt6mh8JnGe9G4/GBL7sIqVLG4z1nAOlaI79diH
	t9yNnS8Dqvsbblc8sGnSKGnQnBS8krFAFM1tMS1PxKV+U/Au6felZdvNKJ0cmAWEH7sXbxXZjTM
	ibQlf0BG3qrxL7Xwwz3X2f5FOfuYN9fa2aiRJv5KAgpWm/Vn5I1eX80CoN5ZF7wtoZcf1/zedgM
	gQg4I8Re4gUlDxNxuhfemMoeBu9vfbVkM2c0W1lJ03GyPMsDLvllfK8QwPexSblEavGyMsuU9Fw
	cbLId6cqC4GJ14rAa22gl1pL1lDY7TwBAAFBxlJjJq7PkCQh6OxGCjpefKAs2mW2JcvBTn8VQ
X-Google-Smtp-Source: AGHT+IFWwbaQHe23BReftsVg783iD02j6Cp/qQHnk8XrfTKXBUvofgvLXMly9n8OdcFF/Pl/0k18wQ==
X-Received: by 2002:a05:600c:45cc:b0:458:f70d:ebdd with SMTP id 5b1f17b1804b1-45a165dc8dcmr54605e9.16.1755019710554;
        Tue, 12 Aug 2025 10:28:30 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b4f9e952sm444632735e9.9.2025.08.12.10.28.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:28:30 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Claudio Fontana <cfontana@suse.de>,
	Cameron Esfahani <dirty@apple.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Alexander Graf <agraf@csgraf.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Mads Ynddal <mads@ynddal.dk>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Miguel Luis <miguel.luis@oracle.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 01/10] accel/system: Introduce hwaccel_enabled() helper
Date: Tue, 12 Aug 2025 19:28:13 +0200
Message-ID: <20250812172823.86329-2-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250812172823.86329-1-philmd@linaro.org>
References: <20250812172823.86329-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hwaccel_enabled() return whether any hardware accelerator
is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index fa9228d5d2d..49556b026e0 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -39,4 +39,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.49.0


