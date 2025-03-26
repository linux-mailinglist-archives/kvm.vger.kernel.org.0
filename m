Return-Path: <kvm+bounces-42027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F79A710E2
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8F917581F
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC22195B1A;
	Wed, 26 Mar 2025 06:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lKgW4E/y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1C3188734
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972242; cv=none; b=BlSH/YmyZ52LzszuOqg8+n6W5uUk992yKDIgMDTtRcbl8oRwNVv+UX6DKcrh2kxPLVXHjmhAFv5or/AIrjve7P1HdwszF+AXBFDVo9BeHdL0EnoKn8D8OqUp2Iyz+u+c0+czKvDRa4QOUCVBP09jwE+A881kistqV+dAIEsiZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972242; c=relaxed/simple;
	bh=tcUDi7mPRYY6TGIPK1UnEszKL2dfkGGQM+zViOQ2Jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZITc7HLs+3QPO5igXVornTb0bAgastTI+b2euopxADOGoiklTVz+UNuxVQkeBmoUno1g/toyHji4Q4ht6gLi6fDSplkRhMMWqcN45JuDMFjjAntC29RIir3s09W4oeyFq8JmK5zT1V66rIOmgOGOEYyytQ5y6N/w0K8fRxacAnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lKgW4E/y; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-227b650504fso70578805ad.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972241; x=1743577041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=lKgW4E/yjgQr0cyetmwDNTPNmV8H0ExnG97R4vfiBnAmDweSJgqsd1LPR+V5bOwj9f
         4w0GqEbsTnsaz71r+sZY4AedMidUYn5ekA/GRSn/nJhdU6o5aU2rFVy3M7Uy3TyLuHZ8
         lTq1MrEi19eabGgBumU7BjCiTQ46Eiw+gMw0O9ibtrBuWNaJfiz8RT7VR0ubWUDgwn81
         Sdj8Ib3UCQcjY6k/jy6JU200PupAlg4n1u//8PevoCbPVdEyo1Uzrhjm8PJgpMrzIMvU
         SVjzKy/E8ExfWHXxCTCzwLFNGIAs8ygLFkZgiCqmGITgKk399Mqpmcw0pi41jc3pJ+Bt
         CRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972241; x=1743577041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=chMl6FoYcqts2+tfylJXnvxkS3KacUhFdT+fgQhzranHsjplgFuw/NlO6RNYHWd+A8
         hp12fR5bTAeWPePxV+ymUzQKJhsGdL0DWTKMmKpt0u6jf5flXCQNW8KzCB1anrLUCYQD
         NPeNExAy0GpMfMTThgMno1E8uvM0jaqe167Ornn05euJrC36J4nfZlaFZvnwc1iX3USb
         nF2ThKAhW/WbYRP2hsRPGxNj2AW05ZyZIp+XseUK9DRoq814K3FwNG+xr8EPlyGbDoab
         pQpsefRy2IspkepGxOAp+f2SwNzPeW4CDTF6lgp1zxZMbaLZrBO9WgU4bD2Ic7VP5m0j
         gVKA==
X-Forwarded-Encrypted: i=1; AJvYcCVxqkxUIzY1CG+0Q8ugbCHttLbidiw8GRHJTPKkCCjw5sYgo9DB1P+tjzvsfT/gICYuTQI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+iaT3VXe+Re06BgKpVSA5WYF87TZwBcSAn4rARvrEeZtTG4pX
	ZdgjHM/CBdFbUn8J9jgh3xNg+tggn6SSXa6QM2jkC+7BV+b3cO6nNX/qUeo5ZMs=
X-Gm-Gg: ASbGncsW0/kfdCgxodNK+QtWHCP4a6t//2/IvmiAkFNK/xPvamH5lFH1iHlv7lgVHkP
	5qFdCtin8KpAxW5Qccx82Bptp3KrvebjAVwRx7h02lIVA/iHL0EDrQENMwvq+o8Lze77l2nyERd
	8Vq5HQjeRr1R25/d7tC4hWbVQcnApAuYgT2ON0SK8NXL3ywCe35zz7igoDIU+Zcz5smQM44dkQI
	RHaysQEKbkCablmDn433ksM3mIELnMnhGoatTBuyIYd/8CHzC1M2o6Lvg1ZLJ3bGJ1ZL73leZyA
	57GlM40bGhfq0mt9sKhW1CAsbBPnmBd7V/6H6bf8m0lgAm8FO6h+nmIMeu+scriwyxYsfmL09MJ
	QnSYuAg==
X-Google-Smtp-Source: AGHT+IHEXzBJ/0I/f9e4El2GDj7ALJ2n2VvSCV/ikyKtPUEZ5gKEr/YYTNu7LdVL4MHwzaSwVIphCA==
X-Received: by 2002:a05:6a20:3d89:b0:1f5:535c:82dc with SMTP id adf61e73a8af0-1fe4330dcf3mr33348397637.42.1742972240520;
        Tue, 25 Mar 2025 23:57:20 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:20 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 07/10] riscv: Fix no params with nodefault segfault
Date: Wed, 26 Mar 2025 12:26:41 +0530
Message-ID: <20250326065644.73765-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

Fix segfault received when using --nodefault without --params.

Fixes: 7c9aac003925 ("riscv: Generate FDT at runtime for Guest/VM")
Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20250123151339.185908-2-ajones@ventanamicro.com
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3ee20a9..251821e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -263,9 +263,10 @@ static int setup_fdt(struct kvm *kvm)
 		if (kvm->cfg.kernel_cmdline)
 			_FDT(fdt_property_string(fdt, "bootargs",
 						 kvm->cfg.kernel_cmdline));
-	} else
+	} else if (kvm->cfg.real_cmdline) {
 		_FDT(fdt_property_string(fdt, "bootargs",
 					 kvm->cfg.real_cmdline));
+	}
 
 	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
 
-- 
2.43.0


