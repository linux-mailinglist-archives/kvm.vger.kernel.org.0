Return-Path: <kvm+bounces-44236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F773A9BB40
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2BC69268A0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A0C28BAB6;
	Thu, 24 Apr 2025 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AYR0uIhw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E3291165
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537326; cv=none; b=uKMS7zCfBTXDIKFN+r7pJZZi7PRd0IAL7QtVqkvADPV9L0MVA88nBqOKJCRkvgbdTtVcbuSMyBd7esKUVseHsvY3A7abF8HqXFf/MD0NwjgHwuY/rNlyRpe1XBRR+1/O48tSy/rcd9WvT2eO/KcrSlqiFNFbd9ceoUazQfCH5Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537326; c=relaxed/simple;
	bh=zrpYQoMZn9cP3hXKr//k4bRamwH6MhHqDYFJxzX8iUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jBvD0vTxReKBtNgSZUlriY5GXe0q20VhYuEKyUQkj3oK7shquBaXGBO4J0WeWREzG7991vXPI8S8vtMgol8jcmURSwYPjFqKWw6g8B7Qwx8sGadXro1xoe3DtNCU1ovhPNo9SMHc351xxcTxQPudMNJpGJCkgzYDg70Gyw1Oj5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AYR0uIhw; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b0b2d0b2843so1382210a12.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537324; x=1746142124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74On0jTwFoitdsTi4zrAD2eD1+d9no9rwvHR5I6qA4o=;
        b=AYR0uIhwxVqNn3o6zUdUPixPKug5i8yaPfuNkXtpAUrXxfWKIBuTt89aMBa49G/blC
         P/dGqob84StP4+CbYWC3JCf8kBDdobOQG/gnlwgd6plWWTK7oF6KthBA0M8JG061i2tn
         iNbDilc1sRz+dggiUABbG8cSDnEMsCYggbVGbJkE6MAjLtPpLtdlljqfM9qy/motA2OU
         XV1xGtJwFHPtVn2A0V5dFT6mrnP27p3KgRchf0rNcQJnhMgeeOtdSRRnmejzwGHhGVws
         KpHY8WevdYHO0j+t+H0dXSfWbw9hMqo93q9v62jTIAiS0YIdyv86mQe7AQpYGsV5WVev
         W/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537324; x=1746142124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74On0jTwFoitdsTi4zrAD2eD1+d9no9rwvHR5I6qA4o=;
        b=Ogu9ETvx+zWWljXEd087QgMvE/hkcwcxlOz7hX3GZpbw42CAoZPM2NuJc04/ITN0Eg
         NUUl7woWnNaa2k5VXfmFmLk29liK8AHdWYlzUr0oUwKXVU4wMgN4cVWj4DDKvt2Xne1o
         AHUSBzd2nl4voMQRYt9AmOYa0eDoZPvtg7ZyHbWX1ZT9qBd3c10IpMRYqAek48mJVxHi
         lf7WVQ5Py85M1q4XpvIbAS6HjgBBzCdu6WmD1BLO+joUXj+g7pSYVyT7WZAGnzAPDSGy
         CT07gVNxLgfd7WmD2yNuFd0/h+rHDtZpyqxOOLuKGyK9Txl0K4HwrbcmFb/5XeLnXiw2
         kOAg==
X-Forwarded-Encrypted: i=1; AJvYcCUXNL+X1nnx165BstGL9/NCWH68RFVIm2DrBcwmOajJ4esHCsdRqfz5lyStVrcccE0ulgc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9B9KbWnqy8J5UQYiU0a94XZMHdTqroFb6XBpC9RgmENk2k8TU
	gR5h9btp2n29WiNP5xehFaYI7QT4acp3IpQBw92RTmg+LA29Ue9A5R3J6ZCz4n8=
X-Gm-Gg: ASbGncuR5dNcLHx2j58falwMAB61A3vzgR8s9Heht6jxHRH4hKUWmvsT4aIyaGD0ybE
	8vpUd3XXZI7oExAeY1spClatqgTzHM9C+40ZCOzLwdLkyMBJrwx2vdr79U5YSeZImG2KmgRBCho
	+axEZ5trS6yCTST5Zagc2L9lDQ7xuKBjdkPtG4qtl52kRh8Mzf0145Be1ykx6kAI2Bxaog3B9DS
	MXjw30/u9u0VfI18cZRjiPAeumSnNeA11VTJOv6tlcHlHfycFRG2abI8sFTNuRe6Zgka4o8vsH7
	gBkbL1+dXDXQmQUnIfqfFLX5mEiFrV2ROVy1l0IL
X-Google-Smtp-Source: AGHT+IHB9N0x/f7qY9ZvBt2OkR6aKoT3LR0rIcTQkENbimzoV8Z91BtLZRoVeqO4MCvkOQfAgJyXXw==
X-Received: by 2002:a05:6a00:1305:b0:737:9b:582a with SMTP id d2e1a72fcca58-73fd9051555mr132199b3a.24.1745537324570;
        Thu, 24 Apr 2025 16:28:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 7/8] include/system: make functions accessible from common code
Date: Thu, 24 Apr 2025 16:28:28 -0700
Message-Id: <20250424232829.141163-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 18811cad6fd..b690dda1370 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -210,6 +210,10 @@ bool kvm_arm_supports_user_irq(void);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
+int kvm_check_extension(KVMState *s, unsigned int extension);
+
+int kvm_vm_ioctl(KVMState *s, unsigned long type, ...);
+
 void kvm_flush_coalesced_mmio_buffer(void);
 
 #ifdef COMPILING_PER_TARGET
@@ -237,8 +241,6 @@ static inline int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_t
 
 int kvm_ioctl(KVMState *s, unsigned long type, ...);
 
-int kvm_vm_ioctl(KVMState *s, unsigned long type, ...);
-
 int kvm_vcpu_ioctl(CPUState *cpu, unsigned long type, ...);
 
 /**
@@ -441,8 +443,6 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg);
 
 bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
 
-int kvm_check_extension(KVMState *s, unsigned int extension);
-
 int kvm_vm_check_extension(KVMState *s, unsigned int extension);
 
 #define kvm_vm_enable_cap(s, capability, cap_flags, ...)             \
-- 
2.39.5


