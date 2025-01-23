Return-Path: <kvm+bounces-36457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7271FA1AD7D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 096F87A21CF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674981D63F3;
	Thu, 23 Jan 2025 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nHda6UVz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A551D63DD
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675962; cv=none; b=c+gKuhQc0e6R4f4NiKIyMfMUGWNmZp42J5Sba8M7IwWzmuqU1J/UHzifylLtPL/4CERzpJ3QzH3wc4CL8K5Q8TspTLyuhZFW9l2z8fuTYH7R3OgZeVQP4p54+o/Wn8XdWndcKt9qkzodVNy6HFqfUZCT1rqQSZyAp+P4yCj+xPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675962; c=relaxed/simple;
	bh=j9QeyZEDciQrvxU6PmCI1XBKPe2C1gsxmtg5jSikSM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hf3skVKlfX6Lc2kFWkb8GsStGRbEaZBpfIykYoclX4MzH5nszvyhyiJ8hvfmalzD3t+rzRdRxVY3LbemL/iEC102hvrxUAEsjgO0MI+DtnSbu2Qf4xppl4CEo92UTCYjKCUg4dW5yBKQGpfgzyC/hL6zBp5f+lrjmbGumY4W4Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nHda6UVz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361f664af5so17051855e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675959; x=1738280759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gXZ2pCmpp3MBAsW4Hnbi8sV5bqYGRAr8w/4hsc1kvQ=;
        b=nHda6UVzPd84CB7aEepZKZmlRMzQHln0z1fpFa6mHdLPdRrw5yf2qRVHQzrq6Bq3Sd
         eG5SDb9cw1XHiJ1tTfQgWrFiq3qny7jiieB1rebZ3UmzbyT5in7A6AAcn6xlsc3NZQ9B
         mlPiUdAwmvRVOC0ia438OkJnCbmi/ZyPHspXFksNpUFGto5PRFDrVK0uT+uG7afZtgPo
         rU/hH9ml9ZBd6PnYSVp/Iuo1o6VKYGrvtK+86R+VIqlzsAGYqHBxgSkvLNcfVE2vgNQv
         iedouJ0W1AX7QW8vDHftnYZ5WCbsMMAtZxBKpetrKYVMcEbsINspGfM/FB9QoaMufoEG
         f6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675959; x=1738280759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gXZ2pCmpp3MBAsW4Hnbi8sV5bqYGRAr8w/4hsc1kvQ=;
        b=IoGYpggV6Or8l4qVgQh9tRToFgytF9mjM5d2WeCxMNGFcdf7RqCCQM85G0GT9eMm+3
         9gbnag4A/7T5AKDQoB+oQSDXSFZEOU3DGjJ1cm3U1PGfYlU+j3Qk3VOKrei+jlxh6X4a
         YbhCVU2OU41TrJe28fLMLtk1uBijYD7CwZSzXvmLvqPa1uxbvgWX5/LucqolyEpo3uoP
         ctqhJX8Py7iROZaOXvefwwmDEvFO2eVmhya2DGGo1xQfDAmuAc6geLVhmYEC63oLYnW1
         GXwi0Rh/t/0wiQikIrbddj8sKovsNa7AWncIQU+8mjCnwEuk+ILzLMcrZawmVAfXl21q
         H5Lw==
X-Forwarded-Encrypted: i=1; AJvYcCXwWwB7OVgSdJ2pD9VkO91aMLPtz174UpFdHuxD9KlBzQZiOTnJVo8fJdxwqX1Xl1RVBvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSQmKIqB1eeqA72aJxABZ1N2hWBanobjw3BswC1A1EZHyi3Mbk
	SFLBpCYYZLzQ9A3Vjbh3yrD7IBnq8PGz0aPcVtv5/aYhVDzZo5zdX5b3TXgW3JY=
X-Gm-Gg: ASbGncsQ2MllFwu+wcksMOWewKUoje/KiymJteVziKauiATt2VMMJQQ6XU0js7QHJKz
	LG0m/OdKM49CtG/obrvRft/X0sD95O4OkOy3IUVWhXlH3YxvEEZg1I0TgajObvkF2MYHG67UsUO
	PYQDJf2BlZ+b1xcM//OFxGoYYAOwnOH8EpjGDtkT5Z5WtFiK8DhUffimvbcHQYCraRcJNWowaiv
	dXXuNluY4QU21M21VIU7JiX3hPmL98XhMSRIrYG+kkQFET4HCL6MtVou78MtvsmODYVV8t1rRGx
	q+j/97wpq15nXQaSkUIGShUt+f5lwbge/0acsPCOAoyygARkqpAo2sw=
X-Google-Smtp-Source: AGHT+IFkrF3nSiyRp86eT1OfDhljZaIiOgfPlVgQgIeU90j7M027ZvrIkgirhKCWekxtCJUAZQHWLg==
X-Received: by 2002:a05:600c:4f48:b0:434:fd15:3adc with SMTP id 5b1f17b1804b1-43891431319mr209632555e9.25.1737675959187;
        Thu, 23 Jan 2025 15:45:59 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17d79csm1009152f8f.39.2025.01.23.15.45.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 18/20] cpus: Have cpu_exec_initfn() per user / system emulation
Date: Fri, 24 Jan 2025 00:44:12 +0100
Message-ID: <20250123234415.59850-19-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Slighly simplify cpu-target.c again by extracting cpu_exec_initfn()
to cpu-{system,user}.c, adding an empty stub for user emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Good enough for now...
---
 cpu-target.c         | 9 ---------
 hw/core/cpu-system.c | 7 +++++++
 hw/core/cpu-user.c   | 5 +++++
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index dff8c0747f9..3d33d20b8c8 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -24,7 +24,6 @@
 #include "migration/vmstate.h"
 #ifndef CONFIG_USER_ONLY
 #include "hw/core/sysemu-cpu-ops.h"
-#include "exec/address-spaces.h"
 #endif
 #include "system/accel-ops.h"
 #include "system/cpus.h"
@@ -176,14 +175,6 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     accel_cpu_common_unrealize(cpu);
 }
 
-void cpu_exec_initfn(CPUState *cpu)
-{
-#ifndef CONFIG_USER_ONLY
-    cpu->memory = get_system_memory();
-    object_ref(OBJECT(cpu->memory));
-#endif
-}
-
 char *cpu_model_from_type(const char *typename)
 {
     const char *suffix = "-" CPU_RESOLVING_TYPE;
diff --git a/hw/core/cpu-system.c b/hw/core/cpu-system.c
index c63c984a803..0520c362db4 100644
--- a/hw/core/cpu-system.c
+++ b/hw/core/cpu-system.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "exec/address-spaces.h"
 #include "exec/memory.h"
 #include "exec/tswap.h"
 #include "hw/qdev-core.h"
@@ -182,3 +183,9 @@ void cpu_class_init_props(DeviceClass *dc)
 
     device_class_set_props(dc, cpu_system_props);
 }
+
+void cpu_exec_initfn(CPUState *cpu)
+{
+    cpu->memory = get_system_memory();
+    object_ref(OBJECT(cpu->memory));
+}
diff --git a/hw/core/cpu-user.c b/hw/core/cpu-user.c
index e5ccf6bf13a..cdd8de2fefa 100644
--- a/hw/core/cpu-user.c
+++ b/hw/core/cpu-user.c
@@ -25,3 +25,8 @@ void cpu_class_init_props(DeviceClass *dc)
 {
     device_class_set_props(dc, cpu_user_props);
 }
+
+void cpu_exec_initfn(CPUState *cpu)
+{
+    /* nothing to do */
+}
-- 
2.47.1


