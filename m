Return-Path: <kvm+bounces-66966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8B2CEFD9E
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 10:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D35CD3062E0B
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 09:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B532F6577;
	Sat,  3 Jan 2026 09:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e1Guby/7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020921A95D
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767433580; cv=none; b=EVB+Is4RqpQXZ3Ks2yiGTQAx016Y0xvgqm2rtoLgW+m35M60OS7ERMC4YxWog4I3Xki02BY1XYzPJ7q1VsN2+cRsaHqzWMrbip9ztt/sTXRbiVA0Hu+KnqSNXrxVz3XXjCkAaOZGcxjrPGQRNp+0ulShkpkMGQ/YraA3vdKmTTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767433580; c=relaxed/simple;
	bh=IJTgg8oliI0wBung+FX2PEpyuBK0HOEoNJVtq00Xp1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jI4lNlvvQpMMWtKvvYASLmdehz9Sbi+mJZ9jjVS/ZhBTD2kcNscGJzDqSpg+PZtInou130pLQoIES5TjRsTNaF+IEmJPAyBJpuwIT+BHQ4Ikmm3IheG8y8B4eW+gBRZ1+i0VbpDJfiEf6Ra7kSQd8Me0GI16Hqok2lCMBJMhq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e1Guby/7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso130543055ad.1
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 01:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767433578; x=1768038378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP0IVTx42h14KuVE1/XaC/JEoSCL6PoSMoPSC6rOH4g=;
        b=e1Guby/75ytZ1y9WAmLt0IEZFBO5eycvKmzSDYg8EIbmPl9g83pcMKKYLEnLzIXV/w
         U/Z/CRdGsiux+eZ5uY7isddRGMq5jhymklgBLqa7jHT9WT1GkMpBMA7TofjSh/4+Snc5
         fO/zrjfKX+5q2TkWPKt49Dmem0258wspB/MR2uK5CiT3wOmkbOxw/kmC/LedInK7adbK
         S8BTxaP3qQ2h1Zad9BZUdKVMmfeUySXF14BYOa+rsxez1ob39rDFB9ILWiilQDv06n+F
         aNJaHO0+8Br4u9z7XWUONDnxPABpWobB9PeDunPL8TiWWnPhYI0vRghMzY+vDltKcc85
         IIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767433578; x=1768038378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dP0IVTx42h14KuVE1/XaC/JEoSCL6PoSMoPSC6rOH4g=;
        b=QdjtP+XmjgjialHPIB2B+1DqE/pM5pRq4ots7jWJSHSXqS+CDoz3517ZFu65Ck8CWS
         bk0YhG135rHwY7K26uJ/U6/mx2ESgeRIvjcn1kTiTkfo+g7vb8LsO00MGQCzzT6auIe+
         Rh5ur1MHCn9SWxjgarWWa6uwobViUW/tPjTzo0HZPlllPa5/aEBAmsy85GmhgUEqKARd
         HOCTiNmyMA1v+du+H3w99QLMBYbGbZOuxK6BFyqf/C6/S0MNmH47bsl2i53itxKkyPcZ
         TpZdqLyoRGvEngX9CVT2VqbkhTjyZ14tvM4cBGOt5UcEhpsvfeV1IRH96ryGuVcmFQmN
         8pRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3x70m763NvIoDdIYr4NYR6lS5TZewY2GtVFOfis0MvSXP3mscyviINVPnzk99OTMNd3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKDUp7yKrP2ori89QPQl8vVuW6Cw86K3KxAXfgj7bYI1k0E4zH
	h+dwur5/8W6B5H64l8O8PzhwJ4Zfq+45ydrTQB3Qb/h1RGqRZd5ALXVe
X-Gm-Gg: AY/fxX7i9fO/sbEBV3cHvhabxd/x1Ul8dntl+NLv61RDPvrVQQewwCu1UFuXuv1NMwk
	KsuZX19VLxIsJXQt9Ea/rqU/ViKHL6u6n20KUxWWLu3RKCfLf/USbTQk4EgEzGVogndkT7fgwFT
	OWXTF19VK0sRbres/f68ihj4eW2e84W0gLO8yccZ6bS00KHTPuvsvXMUu7tY2s2y4R/vUrKedWs
	VE5lgh2NOrsFtmrEebVyfvnVeeSCbjLzz+7bsdixY8LdaTSnUy/0ttsTm1TGhFcWHi3+xsZV8Nn
	GBX+9c+9+p5+lm1cxHx91i93nz9+tvg7KQSFtPkpzN6JQkiohQKcIh5kbpCrHGTdcSK3jvFYYLl
	67KziZvBcOcA1PO6Sea4rLwkdufLhm0QOyUiDXO05b2HjjUU8jPzDdzmgYYbWe4xPW0G9jB0/eL
	Ww5j0zofD6rR5xp8qZWA9Ng7e0zYAX8LHAj69GLIjpNbNKPQabOIGvfc4FFcDJ2P9Z
X-Google-Smtp-Source: AGHT+IG1CFsdsCyqKZEWFTi8fQu6+83oYv/ThQFQjQRZsNEh4BZNCae/3IqB71uabmFWXjYrwHYsoQ==
X-Received: by 2002:a17:902:f68a:b0:295:99f0:6c66 with SMTP id d9443c01a7336-2a2f2836964mr436024535ad.36.1767433578268;
        Sat, 03 Jan 2026 01:46:18 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cbdasm403124315ad.65.2026.01.03.01.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 01:46:17 -0800 (PST)
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	daniel.lezcano@linaro.org,
	tglx@linutronix.de,
	nick.hu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>
Subject: [PATCH 3/3] riscv: suspend: Fix stimecmp update hazard on RV32
Date: Sat,  3 Jan 2026 18:45:01 +0900
Message-Id: <20260103094501.5625-4-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
---
 arch/riscv/kernel/suspend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/suspend.c b/arch/riscv/kernel/suspend.c
index 24b3f57d467f..aff93090c4ef 100644
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -51,10 +51,11 @@ void suspend_restore_csrs(struct suspend_context *context)
 
 #ifdef CONFIG_MMU
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SSTC)) {
-		csr_write(CSR_STIMECMP, context->stimecmp);
 #if __riscv_xlen < 64
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, context->stimecmph);
 #endif
+		csr_write(CSR_STIMECMP, context->stimecmp);
 	}
 
 	csr_write(CSR_SATP, context->satp);
-- 
2.39.5


