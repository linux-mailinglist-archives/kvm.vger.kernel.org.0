Return-Path: <kvm+bounces-38338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 474A6A37D60
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:45:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A696165A90
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D151A83E2;
	Mon, 17 Feb 2025 08:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WXrnlq1V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100F1A5B86
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739781912; cv=none; b=Rmwo7UTfi8Ov/WAJC06bJoZEGwk2aVydikduH6vwijLGm7BgHx8QGa8deTpe/vSWPe8++/kpm3kjVBA3qd9xLve6UejnFsWItdgdvDRHean5k64avROaBMFrybj6UzP21hlGln4vI4V9Gly8u0NQdm1VkqS7Zfc+NvAe7vYZ3aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739781912; c=relaxed/simple;
	bh=NceHRzo7rfPzw9qlSpoCUbMFfY2h6D1qiOQGzNjwyFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N3MdqQxU+01MDwMKGt3zCWAd2cRyORPl7RQ0BPjinQ7cFZDD0ghHWHpkVxE1nG20XRosfBEHFw16v2E2GV8/awBS6Yxq2mzGbNPQDdOaXkmY0Ats+2EbtCWL3diJ0hWPqLfAPZirMXn9dCRkevO2/1bJSuNsQkZbAhlwv4jXdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WXrnlq1V; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43971025798so8083155e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 00:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739781908; x=1740386708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+GPsKALm7Yq13goem1fMBJYo69c+TVWg7YcZfawoJnY=;
        b=WXrnlq1V9uIna3e18b/lTCXtDYw4ToE83osFNlY72Ecm9Hk5EgLvdXDW+LfpoenBhJ
         ehblgStMuOQy+8mifi9iBrmk2ic8OOZf0zSmY+f68SVwsXVcY42x/7ZybB/H42HjSkae
         lxwqfBjM3GdBOxPLqNSbpTjzIiuhOo3pBMhMmQSm0yk4fz/uakSIzsaTI+RswNOs35FQ
         GvV7AS1Ow1yKW0gEw6oxV/36rN8B5SoWtAIOZW6R0GyfLJ6nueIXpMS99AzuiJK91Ig3
         Lawh9met8yncZqC3E/8GPSJ7+7dS6ePWtPHOq7hcVG1/mQzJInxlZA/Hx83lF4YxhY6m
         40CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739781908; x=1740386708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+GPsKALm7Yq13goem1fMBJYo69c+TVWg7YcZfawoJnY=;
        b=fLh75Nchydy6gxgMR0iqH0fuCaw8u0SFN4N2JvEvnfTZ8JuR+tKTeKckvjUDfm8n15
         5lQN1OJi1qytT7NDeEX/vSsh9E+4LX1xVaPm6VfWlWa5i1DTLWXfA1yndo2RmkPnUNvl
         8v1KqknPGvV8fLFXT13+lTjk5YAcz7+xitQ3F0MNrRV+fkQ8cyJBle3FtxyAM2UWoArn
         H1LWxq5fz9Hs7T+R23HEkAzPCbGipmfpHzLzUxi8LtyjUmJDdOgH5lZjpQIGIJnsEPRV
         mCVJxwhH8Y4OoKZQ+a1u44RYVYjspv6Pp65xGL35ThoXLyq7YhMtvW6R3eVgqKs6wSrr
         1WMQ==
X-Gm-Message-State: AOJu0YzcoDb0jamZ89flFRe3ceSVVHhnrurqvBC1P4JMr6ku5jgyqF8J
	1aj0a11lMrkTdwoFiFyXupf2yEQ5tVeeCrhUMynHsdONkGsHK1Aw1PhCIFH7l9VVCzfK7G+jceR
	E
X-Gm-Gg: ASbGncusFtyhyzcHuKV6G2zVJcWDFyutWUu4y3UnojLc3tGm9b6TVGTkegIWHuMCqpx
	4o8YKuY71ztxGi1FvklcOGJYj8SQ3N9dW2gOb6PEj61x8qL+J5n6UrxZ4yoNi7ThBRCz/WL4K05
	FmEPhnOcaJIxsMzyooQ0nmFeUQAyYEYXPZKHGRKCuGwVUBDrz3E/zvGWq7hMBPC27lQDHL+mxaU
	OqjIkv+J7YqS5wOoKBgbFQaFVfW3yfJxacB8PbMnkjHG1RG2towXrciIN1dJzxNMrB/l0Mn9S9T
	ark=
X-Google-Smtp-Source: AGHT+IHp9BY0m/Q6kFaedN0UGWMC/ZwJ9KU/eUOLSaZCeTXH+n6PgSUFQ/UOHrMVcwrNPsAg/8wITQ==
X-Received: by 2002:a5d:47cf:0:b0:38f:38eb:fcff with SMTP id ffacd0b85a97d-38f38ebfe58mr5923816f8f.29.1739781908113;
        Mon, 17 Feb 2025 00:45:08 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f771dsm11482660f8f.81.2025.02.17.00.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 00:45:07 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	cleger@rivosinc.com
Subject: [PATCH 0/5] riscv: KVM: Fix a few SBI issues
Date: Mon, 17 Feb 2025 09:45:07 +0100
Message-ID: <20250217084506.18763-7-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix issues found with kvm-unit-tests[1], which is currently focused
on SBI.

[1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Andrew Jones (5):
  riscv: KVM: Fix hart suspend status check
  riscv: KVM: Fix hart suspend_type use
  riscv: KVM: Fix SBI IPI error generation
  riscv: KVM: Fix SBI TIME error generation
  riscv: KVM: Fix SBI sleep_type use

 arch/riscv/kvm/vcpu_sbi_hsm.c     | 11 ++++++-----
 arch/riscv/kvm/vcpu_sbi_replace.c | 15 ++++++++++++---
 arch/riscv/kvm/vcpu_sbi_system.c  |  3 ++-
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
2.48.1


