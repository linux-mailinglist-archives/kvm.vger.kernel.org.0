Return-Path: <kvm+bounces-2385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 135D67F665E
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4024E1C210D1
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2DD4D595;
	Thu, 23 Nov 2023 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r0KyoDmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB3CDD
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-332e40315bdso490849f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764609; x=1701369409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jApUa9NwPbQ48ykKJDUlLJN0yCBFVC5cyFHqkJvQSW4=;
        b=r0KyoDmiKEjbDZhXrzjeEUL4JxZTN9U45r871EpS5rMZgL3YnhI9CvCdYLqRvgc8UT
         APwyvHPr7tkTMUwGaZAxtfrC8O9I2uMAb1e1ep2P4c4lpyCCl8ib/BKKoClIEyrVkycA
         aNkLMxp+QhcFhuw/vplnL0INVVdPaluB4zou81xhTHrNBEFia5rt8D92FUD8SUzZ1CZk
         pnfeZeAhSb36YnYGPq9v/zzswYlmqHgNxUd7VG2OiYG6U+uVreE6ijNlmn+iBaUWTf+B
         3AThABwZNkyn3XScKE++5c9RR5P9eTBCtRi8KhsrSKKDjK0OTLDFKj95d6YM4SrTJxdB
         V77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764609; x=1701369409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jApUa9NwPbQ48ykKJDUlLJN0yCBFVC5cyFHqkJvQSW4=;
        b=YQr76cXMnO4zym4KAz+HR/JAuU6Xin6d5r/tsGl+MQngsnMaI76cGZcAAGyaAVFvVJ
         m1Tzo8ocNbjnRY1ChK6dPmcOPCn+XyBsLj764ztM4Lqhpf19v7J4wUNh9rNwzyUeNwBa
         KE5sU8bldJkog5JkBNmc3yocsUmtGqYsUpVSGQ05Luh1LhaDSQsvx6ppvTw4HBMZ8v1x
         4jSt7v7shgDWgN0DbKrweHhHeCemlQbYDVcNDS2ZHckiZFPc5+RD7Jpj3jYx4dk2MhPn
         +mt3UaQJOEwKxk24I2bZpn/wBgeCMAKeUAeEWSXKpkpX25iCJifYR/OUN0YDFIK/vpAi
         6kKA==
X-Gm-Message-State: AOJu0YxQTJWzZLfbCF9U1CurtWpUb3rtMgQC5fm98v162oPf8mBqMYQb
	7de4g1VRsY5PdP5RCJpTzARzyA==
X-Google-Smtp-Source: AGHT+IGoH3/+9lMqDaE3gMOPiF0vZZLwfEqa9I1S+IVqZ94k9dU4tzrTTd1DiK72Wv7UvsKyi6Tjeg==
X-Received: by 2002:adf:efca:0:b0:332:cfbc:cb44 with SMTP id i10-20020adfefca000000b00332cfbccb44mr191483wrp.43.1700764609133;
        Thu, 23 Nov 2023 10:36:49 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id i2-20020adffc02000000b0032f7f4089b7sm2318145wrr.43.2023.11.23.10.36.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:36:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 16/16] target/arm/kvm: Have kvm_arm_hw_debug_active take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:17 +0100
Message-ID: <20231123183518.64569-17-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
References: <20231123183518.64569-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
take a ARMCPU* argument. Use the CPU() QOM cast macro When
calling the generic vCPU API from "sysemu/kvm.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 1f6da5529f..cbfea689cc 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1455,11 +1455,11 @@ int kvm_arch_process_async_events(CPUState *cs)
 
 /**
  * kvm_arm_hw_debug_active:
- * @cs: CPU State
+ * @cpu: ARMCPU
  *
  * Return: TRUE if any hardware breakpoints in use.
  */
-static bool kvm_arm_hw_debug_active(CPUState *cs)
+static bool kvm_arm_hw_debug_active(ARMCPU *cpu)
 {
     return ((cur_hw_wps > 0) || (cur_hw_bps > 0));
 }
@@ -1493,7 +1493,7 @@ void kvm_arch_update_guest_debug(CPUState *cs, struct kvm_guest_debug *dbg)
     if (kvm_sw_breakpoints_active(cs)) {
         dbg->control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
     }
-    if (kvm_arm_hw_debug_active(cs)) {
+    if (kvm_arm_hw_debug_active(ARM_CPU(cs))) {
         dbg->control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW;
         kvm_arm_copy_hw_debug_data(&dbg->arch);
     }
-- 
2.41.0


