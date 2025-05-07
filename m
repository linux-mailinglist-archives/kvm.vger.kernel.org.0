Return-Path: <kvm+bounces-45773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5F1AAEF5C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69D6C1BA7B93
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7456D291878;
	Wed,  7 May 2025 23:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JyyVNuaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDF291883
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661371; cv=none; b=ECG/JT4syz02BTUbHOiUa6aCpEZJh9ppNvOBlfzrPH5hkST8QgjdW5jkZc2jqmrCzA7PqEtJhlIyzP5hqy777t3wWDmZwdSD9QNdqeJUHc3QjnLOCeoXO/kfolBxFgwj6NYpZTRGRQ0SSs7zRkc34mZlEcfekru7BpoHbuYvl9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661371; c=relaxed/simple;
	bh=m1DRJ3QbS/3fqgC3jyFLitIJTXEb4Mtan93MiLUIBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1dbCDq6CW+dvYslywO+gtbcfCm1sgAHn6xU+ZhkpS11no3fV6QHu+q9pHk+YzPklZ1CY/0wsPA3tJRA87e8IHd/mjUThCnVCJJoV6YhflK3cvLIxP7QSFV6JkqYWEvsz1yG2tngaDBAk7pofPr7ZwY89lzrF6r/LO17hoLRdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JyyVNuaL; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2264aefc45dso6457115ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661369; x=1747266169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=JyyVNuaLqWsAeRI35oZdFwztrtRfidam/I8WZX+WErAD/356Ssv+x8Q4V19yfne81W
         yylLeHKCixEx2JGxYWMLatliJm0yCCIxPvlUcNheAAlyPbbosr/t2SmpoE7EPA3n8DcW
         aOrcICQkN9I1IijqJshs/enZMX3Yz/SgteeqosXkoBNoJLkdy80EPoCBTsNro9XsvITi
         mjUwLxKghIDl4E4p6LNiuUK3Dz1X6lA0ZpEC9waYZXU92WsQyPMOC9KcQf+HoxOeT7WI
         0XEFpfYehlOL+uBiKd6kUEdL+L0NTE9SZ807k0IUfP3aWb+irLKO6qnUXyuC+6iEle4u
         E35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661369; x=1747266169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=oAvqSGd3Sz9Hj4fn+SKKKkK5WQht/ghRZ2wKOwr1bd13I9emU+E4JPrzJ/iARNYXCZ
         AZ2+zjxihY9FK8i+28cDP2caJJpIIelhlIMbiTDxgqXCdiU8eShhWqcT7vyFPDah213j
         97DobdK6TiYOg7vFLT10vAKHAF+bSmotyCIkVmSHc5jfd8721XNOXkzEvfksB5KUGozD
         ocVhkxSKx4i9Df28OL6HzYnsHPRQ5Vm5GUPraHasI55DbGUIJtiXHTjlemera5AhhxkG
         PdcqQu309cCm7ovGh3/04karHQ3x/0tjnY6pfNlYfNQB8nHmntbJYXlyLiVjg+QoAxji
         j4IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmejmo8zzeMN1syDbG/M5JUQ8GQcd1Tw8tyRUdvfWd/nHhqPFXB2DpTjxew+LYprrOe5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG+xjhh/+mr5/ZvoVaccglxPydXT3ow1GMexrwpk5eB9tWpOBF
	7c+59CQKPK8P+500lfatl0CKTgopLTTiwwUG81rQyIsE7PA3I8ffLY5yQ7rqyhrAhlMroaUdAZF
	mTkua9Q==
X-Gm-Gg: ASbGncuVjSW6wP9Nwih/MBo8CGtScH1/5B3XtlIo7myNKYC8aghi+F35UjUIUIKCPfW
	Strtg1lNcIjkH+ruA2NC23hnmiOUheS1yR4xfhFqrfExQEvnxibxTjmHaDZXUQVCLvjJJsiv3Mz
	cNEpCrPn89yX2Ghf8uVhrpNSrYSHgGM1KjaVi5uEFaEC3ZvAef74/IExmmW52cHXnelValX0RZ0
	W7KizKgXzSub0A6cB8kDv4TbfaTlBa8ix56Dd2K3pI9F4vgSBqvAjCihYFM87e7ln83MeqwGcSw
	r0cNZ4vrevNp/Ddkyjst8AwnmlIXxZEcTpP0ivrU
X-Google-Smtp-Source: AGHT+IHHvc0EvNKRFKpNtmu7GMOzbaEWqTdnUSZ8fl16d0tlW8oALJDg56XL2EyLWt0yNIiyINpabA==
X-Received: by 2002:a17:903:fab:b0:227:e709:f71 with SMTP id d9443c01a7336-22e8660497fmr17618375ad.29.1746661369557;
        Wed, 07 May 2025 16:42:49 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:49 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 07/49] accel/hvf: add hvf_enabled() for common code
Date: Wed,  7 May 2025 16:41:58 -0700
Message-ID: <20250507234241.957746-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


