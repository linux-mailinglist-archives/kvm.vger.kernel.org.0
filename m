Return-Path: <kvm+bounces-41907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD2FA6E909
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D45E53AACFF
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB4D1AA1E8;
	Tue, 25 Mar 2025 04:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hAXCTheI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC71F0E2A
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878780; cv=none; b=PZe0pbjGVAWfZ2YKnrdqRBEFOUac8fUoZWEhm7d8pM8/C+RDDXcL9OAAaaTe4F+CFt6Z3ys+RYJDrgHauIbRfrUsovBALxRxkrQcceZQhvck+Sh7A+nUt8NJZW4pwvcGyO8jEHdeQauJJl6vFIxQDxx1Y0XrnkiW8E/o41XTEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878780; c=relaxed/simple;
	bh=Po70ZZDaCg7i7Hxty1tnaCl6Xsh2JYoh6clfUjfjrR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FiNWDjSe5qgWxAlZN/XFt3GUmGAmKBf1MbHo67yyCrYzM83I2zizX20EAl+BQ5QlGVUCu+8LBYc/0seD9GzfGosvi1liXZ99aeKO0Taoi27jmkuUst/zYSUHz+oq4EHkelk/3YY6pMeIfYVDqIvhjfvrNnPviSd1jjzxVN/Ejhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hAXCTheI; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224019ad9edso26333755ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878778; x=1743483578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pS3gEZRMWOaWak1qsS38oc8ZE/M7wQ+w6QdzWBH2Aio=;
        b=hAXCTheIV28byYKZ5kj+KLYeGMsVn5TPYsgFYtkPQGoO3PXgKUf8HZthsqHLZ6nM3/
         enT92+NkiPskQRj70D2P00TJ/NfgF65q1kGBkoX3yv7BeUO3OcHsjRKEcZOK6aEVeZ43
         WO3n+SjGNiYfiMVOpAa/VaQquj9sUuQpx4ARkN85Hx5+kDdyBAeh+BmIjYrSpmcFufaC
         yWH9AuU7WBlC7o39eBIWmuyfwi7ulBM8vN3ut2fcITuGACMrnxoa5v9RMz/e56UJIMLt
         32QB8vyk0N20akMcmhrcc3uspe2SxMoVFXnKtD/UxstUr6Ug/7aw4bvaisVJSFkJMAiV
         68Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878778; x=1743483578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pS3gEZRMWOaWak1qsS38oc8ZE/M7wQ+w6QdzWBH2Aio=;
        b=NqyxRGTto8mHSwdKlYtJdFSieIbR3cmvwlnEVIYL0TxZgXAh7jLMiBnQ+J/p+y+oCU
         zvaSG1Dwh+3kKGtoalRAI2yR9nzppKgR1aHlMmSOlPiyuXaPtNxqWp5dudZ6idyNGzNY
         gbi+rtwNeqAvoomPhBEY+JJMUQDJ0/VhAUu8KqLI5uPMXBTK0JS8PqS7WgRv1xTmysaa
         o5z2berq+89V/H1O1NTxA3v4GCiIV/ay3zwOBq91XE9V/FWaxMzuzYOL/SYo7Ub+SvGI
         M2PMniTJTJhkd60Tvm5qyBl0I5oYvW4qtsJYGgGnTkWudcrk3G1R+CoGV3LozQlin4XH
         xCcg==
X-Forwarded-Encrypted: i=1; AJvYcCVqgkMOcReeY9waivYEjVdCMg9ZBXnZaq6caSErlxXGvnJRrizAWihrCtAjXdQ0fvoXMwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT95+6HS3oc2ldntp/OjZE1clV9JVvNia+iVr6yhAKUJAoa35U
	kKDKdMkbvOjO+tZkf561RN+BCGs6bSu51fd1MAA4oHrMiJC/QEetFn/nUlOx3A0=
X-Gm-Gg: ASbGnctVMWNLzlz4M/I3iZQXFeRp3srrBBcNjOe2nZX9A31D5l7YvmnkTxsSCn6texL
	Mf/9W9iytv4TTY7XuL2OrcdP1WW9ZTluj8ligQR5B1JrtenC8PMSSU/XvLMNB/qF5c6BAora0oQ
	UBa0s7NXrs7/2NSRA17It6wu0GWSIM3VFipahlFIvR/I7mousGu/U+C3X6Si0h5ekFpJnwouXHO
	LHugzGZSYnmaAe8PGffqLRKN/HBcsUsimdwzzRdpVXWTo7CNw7ykSLrxXHtG7khh7L2lt0WfoEJ
	bItFnYzfLmuT2OV2rSELiqdDEARi8/rqAe8QWSXqojZs
X-Google-Smtp-Source: AGHT+IFSJ7fSgpYAHJW7th72zltx6rj97RlW4Khdsq0ywa9MEQR0n3b7F9efClc0LuL5kNihOGXTUg==
X-Received: by 2002:a17:902:f64e:b0:220:c067:7be0 with SMTP id d9443c01a7336-22780c50a94mr237157895ad.6.1742878777836;
        Mon, 24 Mar 2025 21:59:37 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 17/29] accel/kvm: move KVM_HAVE_MCE_INJECTION define to kvm-all.c
Date: Mon, 24 Mar 2025 21:59:02 -0700
Message-Id: <20250325045915.994760-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This define is used only in accel/kvm/kvm-all.c, so we push directly the
definition there. Add more visibility to kvm_arch_on_sigbus_vcpu() to
allow removing this define from any header.

The architectures defining KVM_HAVE_MCE_INJECTION are i386, x86_64 and
aarch64.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 2 --
 target/arm/cpu.h     | 4 ----
 target/i386/cpu.h    | 2 --
 accel/kvm/kvm-all.c  | 5 +++++
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 716c7dcdf6b..b690dda1370 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -392,9 +392,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef KVM_HAVE_MCE_INJECTION
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
-#endif
 
 void kvm_arch_init_irq_routing(KVMState *s);
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ea9956395ca..a8a1a8faf6b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -33,10 +33,6 @@
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
 
-#ifdef TARGET_AARCH64
-#define KVM_HAVE_MCE_INJECTION 1
-#endif
-
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
 #define EXCP_PREFETCH_ABORT  3
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 049bdd1a893..44ee263d8f1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -35,8 +35,6 @@
 
 #define XEN_NR_VIRQS 24
 
-#define KVM_HAVE_MCE_INJECTION 1
-
 /* support for self modifying code even if the modified instruction is
    close to the modifying instruction */
 #define TARGET_HAS_PRECISE_SMC
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0723a3933bb..7c5d1a98bc4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -57,6 +57,11 @@
 #include <sys/eventfd.h>
 #endif
 
+#if defined(__i386__) || defined(__x86_64__) || defined(__aarch64__)
+# define KVM_HAVE_MCE_INJECTION 1
+#endif
+
+
 /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
  * need to use the real host PAGE_SIZE, as that's what KVM will use.
  */
-- 
2.39.5


