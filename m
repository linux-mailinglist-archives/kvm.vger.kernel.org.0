Return-Path: <kvm+bounces-45323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D163AA840D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A51F617A096
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796951B4242;
	Sun,  4 May 2025 05:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xtWYbSGs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378401B0411
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336588; cv=none; b=MUejZBzBM+6glkihR4kP46iTaBEsNIKy69aji1X1asulNyH2ud4wlTQtm9ma9XJajPsKF6YzKS2APJPOSdXB/x8u1qipIvZWf7usWGkMXdP+rwX3zyfP7jszfsIAYczXo8tXVfA1fq4i7pY2VNZQJko7RsQKe3RBCYyw642h+VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336588; c=relaxed/simple;
	bh=nio9YJkiK2g8f7JN+bhkPA8UAPODA+S829FcakWQE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egEVB07IP29F4fwLx2scKgLuzHZbph5DjqxCM/9W52KpBauERA5T18ve2OFIKr/nOzpYAe4tZhywjntv2au/kjxrHMgC+8wE3+oXl9eVSo7YRdxoaeQPpeTdNfUWwSKBHlzd+HjBTjqNIQV2XRoMfIOo9o2BY+OKstkX1TJmCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xtWYbSGs; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2264aefc45dso53637635ad.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336586; x=1746941386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=xtWYbSGsRlJDQYmzqjK0DvxC9fpxwk6BOXjRu71FMIHbq5ii8QsMsL2FL2B/pXwDTO
         2cTnAffQ0kr85gLAipZbq1ZUwgL0c9fap4kh0jOIc2yDZlJ5MyIiVypostTzPJx0DAzs
         AR8zV+g8j78kkZhjUqqJrAHp610JcyiKqiH0cNNJYVu3/2G8LrqA2K+Q8luTPjS6D5tT
         MnfBjVp3kQ1W8ImVBuij8NOPSnCs45s01GO1fBwk8aB/q/w4LGcsF3CWvhiA5qPi0mI6
         /AAey3x19ZKPPSydD2rDqL3l+EMzUp9+vIUvHlZ6dHFDiiBhIo5kKz2BaQrW7EPnmgov
         2W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336586; x=1746941386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=JVLH4h6eT+F0eLfumjbaj/MBTRtc2oksmzWMxHbvrUI1eHPq2ofIgf8TtTt22WFnfq
         kV7NsYwqdGHxYV2hQS1JiW3yaTCflcH7UFfNJMGLBoBqoU7AzaL/hWtn1O+nKEUCCVxt
         1RPs3SNci1OFdb9T/EXPQNwJX+QJBSXwWmsS2ytHYewNCf9OmR+n7pPTAUGOJl5vs/QB
         mCkOzP6rtNzZnmoOrwwV27CudINXuwbJ2nu84z3QWQiyIx06PZ6eMVT49K6mbh0Jnneo
         qvLecX8Bt3bSAO9hU4sCOGrXCYuCLns9m8MDWo7ZYOn7WQNr0eijhBU0NBN1cSH18k9e
         f3FA==
X-Forwarded-Encrypted: i=1; AJvYcCUI2a1/Hl3Ja7MxSC2omDNulo/qtTnVqZtSJ8YQwrmvsdMqIM8VzXpCANdhRXmSQWzesiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIEc3odR3kXJ+OysZkS70mXA7LqlPhp4Vj5bNy/H/v98TBjUZx
	pmRSWfVn5F015H9/vlbi39+s0Pg9DpTrN4fIHruPta+w6OJtyJuy0GF2coZseyQ=
X-Gm-Gg: ASbGnct9yv5tYBs2UOhwbi/piLxNu4QlXpX9bVlNA6OLefkZ3JvBg+8FosOxcUQ3NN7
	7q3/Ps8pOGuYQC8tNH2mcQaNlxSO4FEiS6dOKvGpQaoZUy1QMOCYVmd3x/fcWQS6S3q1Yo3Drry
	ZApgoaqqjwHTGMpg5OPT+/BFg48Exph+Iz+HCuuly7axwvmzoSVhgKOe/vsOg4Z+nDkA/apnY8j
	WdYZXxSY9whQKC9IdP9HEMwe3Ay/FTBS3aao/MH6Zn8v8d8SAM94arjrUKTGH0A9nBDNUTIlEGK
	NuAb0WBA7LO+0PBq+hj27UopPs8ITjKa4HWdYRpW
X-Google-Smtp-Source: AGHT+IH8pStqcZBvvYFFxKQxcdicD1/a/lfc9xhDUZ+J9NMLqS3FmKOe7ccMNbifujt3rX7vnt1Q1Q==
X-Received: by 2002:a17:902:d2d1:b0:224:194c:6942 with SMTP id d9443c01a7336-22e1eaabf6amr44782545ad.34.1746336586599;
        Sat, 03 May 2025 22:29:46 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 30/40] target/arm/cortex-regs: compile file once (system)
Date: Sat,  3 May 2025 22:29:04 -0700
Message-ID: <20250504052914.3525365-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 7db573f4a97..6e0327b6f5b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'cortex-regs.c',
   'machine.c',
   'ptw.c',
 ))
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
+  'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


