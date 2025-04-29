Return-Path: <kvm+bounces-44672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D2CAA0185
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F6D75A7DDA
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED7526158D;
	Tue, 29 Apr 2025 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aLMrnI/H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B8027465D
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902824; cv=none; b=asSyruApsIU/bYBj7x5PtsXKxXTH+fqVQdnOTRZibCcclKwF/y29MK7md6RemgLEID1iVN3a4TC4EEmjkhpKHiyWnIPnMbVoufyNplzDmIzFiuq9Jpq+8QPCwQCldcql9vIev1S2otjPdz0+uT74m5kwWnv6ZPt3VVomJerHOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902824; c=relaxed/simple;
	bh=5Hgj1vZpwg2Z0JsicRVAw18+KqdVWfVKTB3FJ3JyZDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4T8eC3XCD2eBLUvmmq/pTh5ynv7eSzmIk9ge7wwg+lKywoSMpyn+3liyRHKWX1R+lPds03A8dwpqRIHvTx8yizHCtNksY9rGBErWbIIoOS7MCsnQg9O855H5zlbgoJJVY49kqpmZw6svIn3gaKVhIWHKKbr5/0AeT/CNbQ1+Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aLMrnI/H; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2243803b776so92932245ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902822; x=1746507622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amXX/THKLt9of3i5C6GzRyhvwR1vAr6wdZGYECnCXXM=;
        b=aLMrnI/HDKZClzdENZVvAIXvUpWw9/cW5w5Eio+fDgL5JpgOKJcZX80qgNZlCMweHt
         0cTJuWYJssHhZw0VLKrdHawlectmNvZdyQOsFau6fwIkqKEWb+qjVcEpjWXpj5+GmqvG
         A4iwwD+VB/Mtfo+soiJc4QoFcTMgX6C8D6Vlg42AurXg99O+ksi9Cp77CReXSHr2bNFj
         jvtu+yLaSzNFVRNxhAHQlKbvMaSI/uYyby1D0LJ7YlgtetGMuHU7Dtf02ig4hHs7mimX
         SiPlDau/t58034WgXnIRLfVhbxOueFr+CZ2A4XUBJ3an+gVEdlOmTPlsGOL9BUTb+CQ0
         5AVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902822; x=1746507622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amXX/THKLt9of3i5C6GzRyhvwR1vAr6wdZGYECnCXXM=;
        b=aTqoGrH8ekj84k4+2rEo8lzdwaiSrNt3hf6n4KsPJIWfo8m3TME95g7Wi3zr0Bi9Pz
         rTKH0IhRXbFAi6nIK7p5hNvNbGhN9IS7zfX2gLeYeZ6+DKVjrtwg0O3iv3jcOo7Y4Dhk
         1zQoDhfE6s1pJ7zBVDkfv8y4DAlDMvD26gNUJqmaWkRLsjNjwnqksmx0F3yx07Xr2Hf2
         izi9FrNc5eIuYqUNdvNoKQIT//wp4HKtxQxPhpEbaXQx3zpNpB1RtYz6CnZlvR2OOa2e
         EGxDwzxR1VrKQ9jMmxs0lrpWNr/fFg+yrZqpAnU/B8aPpaqIKxDyHkIVlX1H7IfMemm5
         w9yA==
X-Forwarded-Encrypted: i=1; AJvYcCV3I3XmjfmpZp23/RDbjSDc5n1RCy0PPS6+J0z3aof1U8HR2DMWyonuRSBgzOzTChVOcoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBENDOW00OxEMhQxSZ0WiYl/t8yFN6q0waQfhGPS4g307oTGc/
	U1QB6+P19HNsr8AnzYThPbiw4aw0W5lGVNliSrTLCJjH4ssnrDhJXkekXEODjt8=
X-Gm-Gg: ASbGnctvJJt5wpzbgq+v71ik3cf/tIA9e8BsgqzjP4IlDMpM33g4C/RaK2RuJPOnBtD
	/SH+inUlTKF9GFaS/8ea/D/EANiERDha8l2YXGEitkt5VbBO9hUYLY/v7aEEWF/QGY0RL66ep++
	3yrK3QdBYfxNKNqIqJjPvxzBDqZ4pkKPRsJab6woutH+j+YAv4b3zN1EmuIDXu6nZr2knpvVjwa
	wK1DirOU5OTjIOhiUxgbbPl4JdQI8Hv+z3BjgWn9hTbaS/Iq/bh/lKauIMC/Esm2LgiPIeaDbUF
	8+kk8CjefKOydaVe7Y06D86mGA5dxtGhFSB4MpO8
X-Google-Smtp-Source: AGHT+IEPSmT/3UWE3bABefq+kerkvTIDMzjVefNcm7AcQNO/z374B5XjWls0wpsS4F9WSoqUM7jzug==
X-Received: by 2002:a17:902:da8b:b0:224:10a2:cad5 with SMTP id d9443c01a7336-22de6f7e6a9mr26233645ad.10.1745902822519;
        Mon, 28 Apr 2025 22:00:22 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 07/13] target/arm/cpu: remove CONFIG_KVM from arm_cpu_kvm_set_irq
Date: Mon, 28 Apr 2025 22:00:04 -0700
Message-ID: <20250429050010.971128-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is called only under kvm_enabled(), so this is safe.
Previous commit took care to add kvm_arm_set_irq stub if needed.

We need to keep a CONFIG_KVM_IS_POSSIBLE guard because
this function uses KVM_ARM_IRQ_CPU_IRQ, KVM_ARM_IRQ_CPU_FIQ and
KVM_ARM_IRQ_TYPE_CPU which are only available in this context.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 5e951675c60..e7a15ade8b4 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1101,7 +1101,7 @@ static void arm_cpu_set_irq(void *opaque, int irq, int level)
 
 static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
 {
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_IS_POSSIBLE
     ARMCPU *cpu = opaque;
     CPUARMState *env = &cpu->env;
     CPUState *cs = CPU(cpu);
-- 
2.47.2


