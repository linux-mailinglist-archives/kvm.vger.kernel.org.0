Return-Path: <kvm+bounces-45036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F5CAA5ACD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6DAC4A52F0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C6126F45D;
	Thu,  1 May 2025 06:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vdlI5lWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF072701D1
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080640; cv=none; b=twIsZzkUAytJFTj70obNEXeddnuKEKqAjXS0AsgNxK5miOiV2BgEoBRdVmjJ50XegYsX9WVzEjZrhEVrAP0rJglFFnTuy3i86q0Z5+h413b8QnrpO1qTQmrpX7iW3Fz0Nv3pfiRtmVOAXYhmuETDda1PDdYFK1mUKMsA+mK5nwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080640; c=relaxed/simple;
	bh=m1DRJ3QbS/3fqgC3jyFLitIJTXEb4Mtan93MiLUIBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvXJCU/ZJyqH8Aw/RJDFOmMn4MLoAoShPPVbKdQenlGPmMQwpfx0i9o6sjb10F24aADwbECO41nczYm33VkluEywxQnDuLi47zVeu5CbdeOo+/6jSuf6CFSeEWKIATNAS+gWSqSrAcGDJdzIjxvyf5JKFJ2Ls+65dtgOB+Zc2S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vdlI5lWu; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so600532b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080638; x=1746685438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=vdlI5lWuMjlEaiGyOOU3jVpC1qIyh0+OweGthYqND+vo08oqA82JHDfx6dg9ObhAnv
         RGcSi5if59ClJoZcyD1Wf61N1sOLeTXy3n/i6S9/jA4pKsvhzYxOlZUi3m4iXVtaB3yO
         hi14CkaCoXufdfV+gbF3DB67Z7IATmERa4hASZIYbHWyzTsGr66oMmAJ6Jd+DWbJwmRe
         oZAMlto2rchPRL0iKBjcE4aM9jv72+nbLB+hwi9NkozTfnOZ7/fVJT5Yqiur223RovbK
         ITmJXUic7mSsuN9hFdmKOuckSgcbNtSmhnm/y66ReImG1pAsPsP12fA/c+DIxyMK5RiO
         KfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080638; x=1746685438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=O2onFeUaB4NN6tpeywh0mJfPbFMc5Nr743LeIpchiogER2dz3IhyrevRRbxwdGM2JV
         sIqw8qIxaRy3Rok4IsNF+EoG26RS0HfQl0qIIrSlg3mYtREia+TcGgF5jFNdX/hEZeT1
         q6+gtU+YV4WOqYJbUn3GCUg23GDbeVflufKbVkM3sCl4OxkUjrxWXXx7kj4onT4mRv9T
         lPjq42+c7L/zHJn2ml5phxCVJ3aKWLXHBnHQdXrLgxdS1RJ9Hyd8nC2vupcEQ+pghAh1
         pgZtFcmr7qKkRZA+H8cg5cTFnYIYZDFN6Jp4Hp4CGaT8vUBPo4dqRQFYzJBFqvyELB0i
         NVBA==
X-Forwarded-Encrypted: i=1; AJvYcCXH2GvhLTSATJ8EGuoMB2lnz92XHIvaKbVj7g2V7g7+7dDSnEDqG5uMeSQUwQreSE3vGPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY5w3vyyI5U5jyHVHphBTJIRZSLegGrwGL6OdADw9HRW34Zhhr
	GXH0HP1VVaFeNSb6al5pvXs7Hr6lPXt0Uchyb4dLFhsUCV+ua8MqyP/z32EaIYM=
X-Gm-Gg: ASbGncuT2ksaFfNQsK5frYO+mNdN0nN5NZmVFgu+7G0Z7Z4WBIFP4mSamWFJTGESPzL
	YfOY4ZUa2I/PWvtnCKQkmkSuiNgefvA6H7ezWKFXLzHHZJ6p4uPCyX4c3dmtDHuRMQ3gTvti5d/
	SxhPvUndDtKGqhJQAKqpgalaL0nB+5Fn12UWdsjxTHEiggjePyPRriRsIHHX+GVFJYHsWqjeaRN
	H03hHpBir5wLcGUmhKH9QBYb5Jd+l2YV1LCblocGTWcrcs9Vp6wNrxqpmCElACGg2osvKqQX4Qn
	mDHdrZGu++k8eUF49quPBekhgAhNsmrfLQPig2P7
X-Google-Smtp-Source: AGHT+IH6J99jOhsc8o7g3sHqxpYwWEy99wbbi+relVHRPmsGkWpcQW3abDuw0wKNrlva7C0fJ5MztQ==
X-Received: by 2002:a05:6a20:d046:b0:1f5:520d:fb93 with SMTP id adf61e73a8af0-20bd6f4545cmr1904279637.24.1746080637671;
        Wed, 30 Apr 2025 23:23:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:57 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 07/33] accel/hvf: add hvf_enabled() for common code
Date: Wed, 30 Apr 2025 23:23:18 -0700
Message-ID: <20250501062344.2526061-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Other accelerators define a CONFIG_{accel}_IS_POSSIBLE when
COMPILING_PER_TARGET is not defined, except hvf.

Without this change, target/arm/cpu.c can't find hvf_enabled.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h  | 14 +++++++++-----
 accel/hvf/hvf-stub.c  |  5 +++++
 accel/hvf/meson.build |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 accel/hvf/hvf-stub.c

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 356fced63e3..1ee2a4177d9 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -19,15 +19,19 @@
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
+# ifdef CONFIG_HVF
+#  define CONFIG_HVF_IS_POSSIBLE
+# endif
+#else
+# define CONFIG_HVF_IS_POSSIBLE
+#endif
 
-#ifdef CONFIG_HVF
+#ifdef CONFIG_HVF_IS_POSSIBLE
 extern bool hvf_allowed;
 #define hvf_enabled() (hvf_allowed)
-#else /* !CONFIG_HVF */
+#else
 #define hvf_enabled() 0
-#endif /* !CONFIG_HVF */
-
-#endif /* COMPILING_PER_TARGET */
+#endif /* CONFIG_HVF_IS_POSSIBLE */
 
 #define TYPE_HVF_ACCEL ACCEL_CLASS_NAME("hvf")
 
diff --git a/accel/hvf/hvf-stub.c b/accel/hvf/hvf-stub.c
new file mode 100644
index 00000000000..7f8eaa59099
--- /dev/null
+++ b/accel/hvf/hvf-stub.c
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "qemu/osdep.h"
+
+bool hvf_allowed;
diff --git a/accel/hvf/meson.build b/accel/hvf/meson.build
index fc52cb78433..7745b94e50f 100644
--- a/accel/hvf/meson.build
+++ b/accel/hvf/meson.build
@@ -5,3 +5,4 @@ hvf_ss.add(files(
 ))
 
 specific_ss.add_all(when: 'CONFIG_HVF', if_true: hvf_ss)
+common_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
-- 
2.47.2


