Return-Path: <kvm+bounces-3126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E20800D2B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94AA8B212CF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB29F4A9BA;
	Fri,  1 Dec 2023 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P7b4dJv2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF32510F3
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 06:32:10 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-32f8441dfb5so1561772f8f.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 06:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701441129; x=1702045929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2r7iA7OoHYzxctfj3egfbT+slVUvULOjb8ti2ra+So=;
        b=P7b4dJv2A4PESequfg7QwbL5HJVLLRDbyK96r1Iwz8fGtccCwWiB0tJRSb9EMYd7yS
         Gt6BWCE18E8TUKThpAsnZbnvX7dOlJ6/1EtOxFMKEnLUobgy4IW5Hn3vrgrdTkjBdAC/
         qZAuIoStGlsfK1hogiQecZfSLSnwEAgdpNpu4tqasofhZbrtcW3fp3Btyh08/4YrvVQu
         xCjPpM3s+sbQ13U8hV9nG4dGA1mQrGXfIk+nNf9nO0wVJXm2e6dZdMKLyJ4JVZF4B6z/
         Twd0QC0yr2w+gOfW1nJd8+mKkDGUUoKvKWzvztR8RN+XFeX8FRX6hIGjP4V3PehFtGkD
         MaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701441129; x=1702045929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2r7iA7OoHYzxctfj3egfbT+slVUvULOjb8ti2ra+So=;
        b=TxkxSbtOZz6cXIVux0U4zlIOR/62B7WzuWfoNnRQOOJh62S2G2sbbRGomIvE6P4H9U
         02hJNITxvidYwSiFOJ2dEH3/LsWe3CRukaCZKcpNZOQH6U/8a+g3RTrzNqWS8y2C47ZL
         nBrbtb8ZOGb6dLw7YU8I6XQ9cl4WeOFK6e1BBQs0YYF9J9/JQoXVBuIkrGfsHaX0sLsv
         GTPqrs1FtMZ2xBTeA7W+klgGYvdjAVZmF5iZEp0844EWkAY8VxSMBzjOs+9HaGKWVD0j
         XVMIpEXOBlErFXzhHzy2BSlQSHqJSoobAjxQ+COkeJe6TRJdS2kPCTblSmMY+TL+ShrM
         VmcQ==
X-Gm-Message-State: AOJu0Yxw2LkWyZMVZG8t6etyRC6/lZDiOX3Ow7lJHDFVzUntUdGuiW/I
	OG5AxrlCyhis9RrEfwgPf0CdvA==
X-Google-Smtp-Source: AGHT+IFRjWrcyt6o2zfMnv+I2s9cP1wBQQTO9OsNacCHUVKUdyh72wWH41cpsgSJYt+qugV5saDEJQ==
X-Received: by 2002:a5d:4e8b:0:b0:333:85e:a11f with SMTP id e11-20020a5d4e8b000000b00333085ea11fmr889298wru.59.1701441129295;
        Fri, 01 Dec 2023 06:32:09 -0800 (PST)
Received: from m1x-phil.lan ([176.176.160.225])
        by smtp.gmail.com with ESMTPSA id dq4-20020a0560000cc400b00332e7f9e2a8sm4277513wrb.68.2023.12.01.06.32.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 Dec 2023 06:32:08 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 1/2] accel/kvm: Expose kvm_supports_guest_debug() prototype
Date: Fri,  1 Dec 2023 15:32:00 +0100
Message-ID: <20231201143201.40182-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231201143201.40182-1-philmd@linaro.org>
References: <20231201143201.40182-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvm_supports_guest_debug() should be accessible by KVM
implementations.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-cpus.h | 1 -
 include/sysemu/kvm.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index ca40add32c..a232348c91 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -18,7 +18,6 @@ void kvm_destroy_vcpu(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
 void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu);
-bool kvm_supports_guest_debug(void);
 int kvm_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
 int kvm_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len);
 void kvm_remove_all_breakpoints(CPUState *cpu);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index d614878164..6ed18f2d6a 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -206,6 +206,7 @@ int kvm_has_gsi_routing(void);
  */
 bool kvm_arm_supports_user_irq(void);
 
+bool kvm_supports_guest_debug(void);
 
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
-- 
2.41.0


