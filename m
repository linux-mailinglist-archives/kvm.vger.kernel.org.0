Return-Path: <kvm+bounces-41347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9156BA668A4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C41A719A2418
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8501B0402;
	Tue, 18 Mar 2025 04:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gM4y6GFb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BD638FA6
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273495; cv=none; b=ffe4IAIGK2zvKQ82jsZ1wQ++KLchaDCl4BpSPIDjs+qMz5WNEj/TOHqGzyftFnM0ErmSCCCGp8Fu8I0NYXYsFwXLc4I2YCSIBD7AfdpnOQc+D9d2E2X1qpz4IG0vkP03l5Hggwzr42V80/R5E0dTWLAvxt/jN4R0keNY98Zlw6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273495; c=relaxed/simple;
	bh=k5iHrn0Ip+BXMF0kBnk7lULb90Qdll6NBSBJOoU+Yao=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=KFCZtzgISJM5hOe3vPmyOVEvcBujThX/mgh5BzMMkTGeHp7kumO9Lxf8t4mG99//IXkD3o7//5lHV0MgFDwfOB0x0doEFKXSl15nrXFp19aHlHFuD4XajG5kZWBC9YOmjYWdABnYQbYfVOyn5mekAZGw9da/fIIQ2QHwT5Oxfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gM4y6GFb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2254e0b4b79so122474075ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273493; x=1742878293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu9103r8oTjAUXk/0jU4XMC8f8kUJ8IRY2kEKbMxwAQ=;
        b=gM4y6GFbKJCgEOaqfaMihTBtbTVoSbCjTSed2tw0AFV7DsAofVvghRbIfZKebIEgmC
         bsP62PL5dBplJW9/HMsYRfswCCqOcyQ5Yn+O27kImHvsSkP1ixUlKvq8+YxfyoEY/Agr
         2dhhjWAP4KNwUp/Uyi0dAgdzcE2eq1SWZ2MSc2RnEFlSQIUEoyb5Zmw0EKi9/tR08swM
         CCKs37LFp3JyE1+fS+jUAtTIT6EtunEccbydknNa8dMHlUGV1fIWTtRv+N+7gwHUaLDS
         6qGjUz0h4/FNAKFrekxmS8khEPPIJH6rVZK1uLtNjFlU4IILrqSgpbSYq30RpI6QkwDe
         8bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273493; x=1742878293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zu9103r8oTjAUXk/0jU4XMC8f8kUJ8IRY2kEKbMxwAQ=;
        b=iDzIyIFsXNOQfabWkt4nLCspWTisI5s9Iye6ZXoStR/tZzPoxOqPev0kf40D21GY35
         yzzfgM3s2+y9bOlb4YAJv7QhFpjvdjWcPKVA3lsnGXHcsqwCVJQmX61t4EW90V7CDWzd
         YaRA6DLQL4l4VXX6jwv2xMNRCuVTKnlsXCaCBWoBbqjWEoY5L1o93EydCRQnYpBYVM4/
         3WrSFbk1ixJfKrLfjqm5nG6oi8/luGsVAw3pgsrUCNTyRHOPh0umeoOD4Bj6n1bxr0nS
         T2IGwBxrQMhXq31w0ATYNWPgEmQWZCtCACnW9wXWmKDCdf47ee5kWJXOtnwxf+OhhhSr
         XSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0XA8Kq0YnpHnhhBjd5dWaQivJQiwXI/FUH2SNw5Hp3+LinNN6gGYNupSfR2clNU6LJ1I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzg40AR/tJ1ZSQrFfT9VNWltbS5xe7CNM+Ajp1zWY+q+EGoZsI
	d8wKMPvzi96RbaluNb7YPb2Kxts4s6haXUD5zMef98yaLSOHwY9Lpu5dk3oFUtU=
X-Gm-Gg: ASbGncub0WXSoP/Ze81EwdgdIkjycUmKgG4f1cfuBg++b440xuRdRQyqGuMwj1EEJFF
	l0QSBaUQMuRDc45MZhdrQ7+EKhgPs1eGSB1Tv3V2wyewnIVMSnFZ1+gCoU+qchaOZ6gDISgXETn
	qHEY3P+RKBeNAplTUyRvumrQ+u8Fd2w9Zdz0V70kCsdXazI4pIXSp9o+ZOcwbgoS0ifnhxp3TGZ
	Ekq9YQgNkqHjnpvK/ibh3TwEJ2zSdkaQtZU/kw+TbZI++5eO8QMWaoyWzVigbnx98kNqfUU0/a9
	fuTeGuyIqQ3tSEBD0S08HISeWdjgTlruzC1vOzjjoh4Or2l33MA0EKg=
X-Google-Smtp-Source: AGHT+IGjVevdOxVZtllqsOzTh2kSPli9+2FoEMdQ20zfQwf4sZc4Mag5ZWZo6Cn4913jSf5K9IBO+g==
X-Received: by 2002:a17:903:2b0f:b0:224:194c:6942 with SMTP id d9443c01a7336-225e0aee904mr229423185ad.34.1742273493096;
        Mon, 17 Mar 2025 21:51:33 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:32 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 00/13] single-binary: start make hw/arm/ common (boot.c)
Date: Mon, 17 Mar 2025 21:51:12 -0700
Message-Id: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series focuses on removing compilation units duplication in hw/arm. We
start with this architecture because it should not be too hard to transform it,
and should give us some good hints on the difficulties we'll meet later.

We first start by making changes in global headers to be able to not rely on
specific target defines. We then focus on removing those defines from
target/arm/cpu.h.

From there, we modify build system to create a new hw common library (per base
architecture, "arm" in this case), instead of compiling the same files for every
target.

Finally, we can declare hw/arm/boot.c common as a first step for this subsystem.

This series needs to be applied on top of
https://lore.kernel.org/qemu-devel/20250317183417.285700-19-pierrick.bouvier@linaro.org/
to compile.

Pierrick Bouvier (13):
  exec/cpu-all: restrict BSWAP_NEEDED to target specific code
  exec/cpu-all: restrict compile time assert to target specific code
  exec/target_page: runtime defintion for TARGET_PAGE_BITS_MIN
  exec/cpu-all: allow to include specific cpu
  target/arm/cpu: move KVM_HAVE_MCE_INJECTION to kvm-all.c file directly
  exec/poison: KVM_HAVE_MCE_INJECTION can now be poisoned
  target/arm/cpu: always define kvm related registers
  target/arm/cpu: flags2 is always uint64_t
  target/arm/cpu: define ARM_MAX_VQ once for aarch32 and aarch64
  target/arm/cpu: define same set of registers for aarch32 and aarch64
  target/arm/cpu: remove inline stubs for aarch32 emulation
  meson: add common hw files
  hw/arm/boot: make compilation unit hw common

 meson.build                | 36 +++++++++++++++++++++++++++++++++++-
 include/exec/cpu-all.h     | 12 ++++++++++--
 include/exec/poison.h      |  2 ++
 include/exec/target_page.h |  3 +++
 include/system/kvm.h       |  2 --
 target/arm/cpu.h           | 28 +++-------------------------
 accel/kvm/kvm-all.c        |  4 ++++
 hw/arm/boot.c              |  1 +
 target/arm/helper.c        |  6 ++++++
 target/arm/tcg/hflags.c    |  4 ++--
 hw/arm/meson.build         |  5 ++++-
 11 files changed, 70 insertions(+), 33 deletions(-)

-- 
2.39.5


