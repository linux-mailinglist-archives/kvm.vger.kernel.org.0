Return-Path: <kvm+bounces-36777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DB5A20BF1
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2B4C3A4FC2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DA11A83E8;
	Tue, 28 Jan 2025 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GnJijNKS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01201A8407
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074148; cv=none; b=HPz5iWybirgdFTsBaMMl3kOrjxNaExB3cTr12wKV+nA4IExrcTSPTUU18blQMv/HMMgqJ2P1sooKUZkNkNa9siI5aBEqd8BBoseZS3WmaNA9dOlVgOy693g5PAoHm02uQ0iKXIhKrdvf1jGty2P19a3zPcQXIF5hkSwSMgDwuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074148; c=relaxed/simple;
	bh=b5pmYrFAmwtCJg8B2cUet21qlaBWJzq176CYmqC1/Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOaV39rooMv0TR+AUHe1434LcwTj3ZuJ+pGai0vXEqebcBB+z38L6CR7xCP3tsOYh55FFIpJ4JJtp3IASEokVgm6OEEJwmzMLy14KRzmQHbBuAJC1CB2p5bREpX9JIClZbS6kArC9QBrnC0s2d0cIzrFLPHX3pVKJGDsCM1zEhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GnJijNKS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436249df846so38370535e9.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074145; x=1738678945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tw046dW5+uhhYJLaed8H1nN+PEtNbdWPjJLIYS364MM=;
        b=GnJijNKSe828VJJaNQXenZs1ajoM+/738CP0f0+4PZEQOLRNxBGeKDhgxNjbNx1yrr
         QHQ2+RcYor+oiMvdlmTdDfhvc6SsFvT3xrUcb3Z20lG2vYSW+bBq7/wA8kv/+DShe15a
         q8+TP4+yYNQecqFAUY260/7n2EAz9wunzuJ3Rw3WjaYPqK4puB/GeauI+98pYH3wwefC
         NesPe/stnRKHI4HFo0ljlBH1iZTwEXre/9BuYoZwPnOKFrF5RnedvW87sxrl2uXnE028
         cANoOV8lgbC7DNemum+FZDAQwIKe+aJJI+3HwNWgG9AthBhbnn754UdUMEl01S+pM5HM
         IuRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074145; x=1738678945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tw046dW5+uhhYJLaed8H1nN+PEtNbdWPjJLIYS364MM=;
        b=xLL9WarKfbxUyCj/hXATwvlpHD9lWLWvpFl4ZfmB/4lj8eyd/Yxi0zlj8AXDdoRnsm
         dom/5V61OHntSTBP6OvfAilYchrhqpz3mjsrBQeu55kkgZYulok8TCxsm1gMqCR6eyU4
         nuqxnhvpz0frX3bUg1DeuW0yl5ktkBQ1JG3i5iO3Y/O8M4bBspR2Rqxy2Rkldii1vhzN
         BnPZxAxzaAmTZe5IR28Tb7zaOLc7grHKSOD0dpoSNegzeucYmLSGfPnoJBYTu416cC2B
         hd34qAAqgV/joDyfQtPa24QGYMV3ovClf/G/Dm9XEFYSCpbQsMQznUxj2KTDemp+GA2r
         dMTw==
X-Forwarded-Encrypted: i=1; AJvYcCUyw5bTCCsdHjlm0ZXTgmdmiaD+hRBce4so745gy/igZgoYWPPWiCkewI45JaT5Dj0MzV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwftUuNVpUapoF2+6KEZIHcJY/ge/j/qyUMVeAkuR0AwfelIHvU
	fuagu5luPhuNNlgxU6Q73NOW18zqq4Cs+a2xEbt94GrbS5Mr74omHbJbn1zr+fJx2Kn/6FpqMwf
	+k4Y=
X-Gm-Gg: ASbGncvL2DwJOF1R1Qki+/FJtGs+BfKlL4nschjR4G2Y2p92ILvE7G51HnKXMuch6g9
	gVIc+L6+71cURm5n6V4Al8bcdCTPinHvk8QXwzJ7qspSPRcaPG/7vrMjLcaK0X+Wp1MrSpUvezd
	dyPwaLEsLabNRz2d5BzclcLi1iKZyTBswjFUT/lcKx17UXAnSzFbziI66qc1urnkTB+Bd+SWhQf
	S6eq014+7DumWnQvlXr5QWYce8LmBKyffmt1TphwD2+JXJpaCJfcC5Qwmfgwplwi8SzN01qM7vc
	IkjMWG/TiTGXnRa5Pm3M5sS0bOn8Nv4SFzGV4tiNbNE9IBee39bT3y4AORz59ro8cw==
X-Google-Smtp-Source: AGHT+IEyyaAAlYQ5I3ppwUr7kelaVWlDzVIFlhZYrwH74VA7sdBpE5YrUhEnY7P3LEg7nQWsma+f4A==
X-Received: by 2002:a5d:47ac:0:b0:38b:e919:4053 with SMTP id ffacd0b85a97d-38bf57a993dmr44371093f8f.44.1738074144814;
        Tue, 28 Jan 2025 06:22:24 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bad92sm14282474f8f.61.2025.01.28.06.22.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:24 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 6/9] cpus: Call hotplug handlers in DeviceWire()
Date: Tue, 28 Jan 2025 15:21:49 +0100
Message-ID: <20250128142152.9889-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

To call the hotplug handlers with REALIZED vCPU, we can
use the DeviceWire handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 9ee44a00277..8a02ac146f6 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -211,16 +211,17 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
-    if (dev->hotplugged) {
-        cpu_synchronize_post_init(cpu);
-        cpu_resume(cpu);
-    }
-
     /* NOTE: latest generic point where the cpu is fully realized */
 }
 
 static void cpu_common_wire(DeviceState *dev)
 {
+    CPUState *cpu = CPU(dev);
+
+    if (dev->hotplugged) {
+        cpu_synchronize_post_init(cpu);
+        cpu_resume(cpu);
+    }
 }
 
 static void cpu_common_unwire(DeviceState *dev)
-- 
2.47.1


