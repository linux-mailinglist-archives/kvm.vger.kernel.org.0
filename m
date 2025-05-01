Return-Path: <kvm+bounces-45057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8462AA5AEA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06481671C3
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543B327D79F;
	Thu,  1 May 2025 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mIcbC2sE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5927CCEB
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080658; cv=none; b=YQxLmgLoexBO4FP386d9h9DaOT2VZLEpda6mud5CCvBOP+c0d/lIBtvLj7njHYfPXY7ts0br9Gl1zX//XYQGUKiDazMp0Rn8dpUnrJ+82rUk7UXUXwqgsPshi6IiWko4xa+mXTcJUO7mF62azARgWWLfYdMaVuVRnijUdu85P1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080658; c=relaxed/simple;
	bh=YITc4Pb+Hvl46IJMp+aKdC1iThnFAyIKPGaVcVTf7pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXP68rIXa/GlHBWaqwRJx/H/zjULqv8XGUz60TZUyx/G/spHm93hrgRtxrXXkd9CAvv1PpkkDovaG8JmxDsiHlcqOMt3Jh95a/vp622n+CRcXZQNDaEyD+bCT1ZRiKmaxvPtQ2tr869Q3OYit0TyzknkNcZXfRatVE2C1d+T68U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mIcbC2sE; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-736c1cf75e4so626650b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080656; x=1746685456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z22S85haL/KF7qK35umsJwcCPzG3sLDPMH83wLAS3JI=;
        b=mIcbC2sEpNrKrNyKAt/iQFbKlxV8ZFAHhsbq0nQgmdhUM60v1bKx9I3ibJRCCWMtOL
         nt0N6GKE2NSovHSXaP3Z6vBi9eLoL93nwdBE+5Hc734sVlTqGbH85we45oTQy//RFD9u
         iuOY8qcxu5ZkFYJoRs4eXkjmccuuoYAudKOd2mSdPfm+uDyfxvTHlVNjz4x/i2kq2M1x
         E1cuVMMrM0Y6oqL5UItjVJSnc8JfC46RkvCJWlzAo0I0yZWDR73FCM1II5ipiQNx3qGT
         L0Xz7TlWPaH3qIvCSjoXeh4WErQ59xLDzfSegjpQprfJ0RZP0mxo8xIpeoQahUQ3XPV7
         ZHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080656; x=1746685456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z22S85haL/KF7qK35umsJwcCPzG3sLDPMH83wLAS3JI=;
        b=DgtQokAitxz1fWfPNUXePcXD9rlCVG/JwUMfuJULcznsDuuEY+l0y2O67ZuqzRmTXN
         ZfNE+R0ry/OnofBGRNGPIXGItJq2Li1QaGhaLcjlBYU12IywLIrizhQFZ2ZxcslLoTGh
         nYaPM89gqLOkqIOVNGgI/92KIdvbjbizdP0pHEnvf1eXPim8qiCzQc1hW0SPR5N6J6O+
         tVqLhHhUAC5gpqvosMULAk+SaBYl4yd1Gd0FdYo1w0NfXzzO5Kqd4INRB5Rxg86k0aTB
         y39yVKqCJaZCYvnmPYHoUIXly73ra/jwqPafnpkkK/6iYXXOtpCGvEgFvrpr1ooYIR7L
         HTmA==
X-Forwarded-Encrypted: i=1; AJvYcCVb+Na2G0cmt8NiEOsmg6VPEU/LvMXhfGMAeEva/zFklAE5L8rzP99yqvkiKb8KUvdl5VQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWJv3ENGcb0wDqALiAP3VHkNv5lbFoiq4amV35GVfKTWLulFV4
	JJQ9JH8wLk+VdU7yGhSdDNrtBiBi+U/beRl1JpFV7ZAcAX5sYz29jUJm4mNMOmU=
X-Gm-Gg: ASbGnctkV0/NfU+4fbkiGxtqJkArQYRk8duXq7t7ukGqXIQG5k/PcJ/cUXJU/kBq0C1
	I9b1qCvOrYfIxnjxMMYPhj1XX+XIp5qwn0nXPdRL+5mcRthX/Iwt5cWtRPthE0cCVkeotJWV31i
	/6STy3B1sVuR9j5VAhO5CT/4cYCsLpkaGJ3kTcUW3NERmuaSLlM4a040YkmKpKQuDGG/nTJdZBg
	5Fk09uKkSYeo3kt3257z1QpkshBLkDJk3qYxrftJzDzVbfBS5rddzBj85uDk93IGngOqE9glgAV
	0IiAIDKbtNrkXLMWDhe0D6MvhIHrYPvbA/ROYATh
X-Google-Smtp-Source: AGHT+IGliq3ReuCnpBopZwRu0exFB8q6L3+dRZknQKd9EToD7dD/BV9xUglJOlu94RB9QZb/pidXAw==
X-Received: by 2002:a05:6a21:101a:b0:1f5:8605:9530 with SMTP id adf61e73a8af0-20bd804956dmr2006315637.28.1746080656445;
        Wed, 30 Apr 2025 23:24:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:16 -0700 (PDT)
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
Subject: [PATCH v3 28/33] target/arm/cortex-regs: compile file once (system)
Date: Wed, 30 Apr 2025 23:23:39 -0700
Message-ID: <20250501062344.2526061-29-pierrick.bouvier@linaro.org>
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


