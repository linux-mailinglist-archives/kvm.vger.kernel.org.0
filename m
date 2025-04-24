Return-Path: <kvm+bounces-44192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBACA9B266
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A03F71B86EEC
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2AC27CB06;
	Thu, 24 Apr 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ojWJotjG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E876718C03D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508764; cv=none; b=G3KV7ALafg5FV9So68elVO6s4gy8EkJARHrBuTBVYtmvFBgx5P2sSDJ8TOtJxRbhEJBquIu/RZlcEHFOT8ck3nCQu/Lq7E8Pn3wsBzC/uwpYQ8yQ7JNCSMRCigZQK4dQxULwUvCUvcnDJrN3DpxvMkaHnjQ0GJpZJidyLKsT8Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508764; c=relaxed/simple;
	bh=tcUDi7mPRYY6TGIPK1UnEszKL2dfkGGQM+zViOQ2Jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJXxcY2jUuDbBu1HMo9o7IlHUKrFm+SPYNOr/r4mE8nyJoJAzAn4WkpzncliKbINXfgjAOYZXDkA7r/z2ZHv0Nf3dQDy0f4NFutapRc+HdQJaJTmT6r2ZmPHp/c7AgTBQjuUrlWA34O7nOt33kLtNTAhsiPJbdV7Zms0w8hFVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ojWJotjG; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7396f13b750so1288657b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508761; x=1746113561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=ojWJotjGqOORKNzlyL+ugbvlhPbMjUEm8ipyafJD1FBwyR5Xe/YbjNdXY8QR+LkQQp
         YSas1/X5KkI0Rwy6tscVk0FfnZPzGfAOoqjPlewqaLwwoNjt950JzT39CYS5a4nl5dyP
         u/6DvV7Age3xT7+BTsT+cAMhVI6w/oIzfPD6RIeASrX5HkFFJ2Enct/K+/+ndBpFN/G5
         w2XC17GbAvGoY8MqOLZTrh1LkGI0IkUSFjscstd5iq/UhomruuAumzhsbpBXH9Qf0i1X
         QX+c5AUQ7CGkPV5BZgXB3rl6BKrAq2UH20Rm+xyEmJ5iaBal9xbHDLLz/UuiAq/1z76w
         XyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508761; x=1746113561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=lOVpPXSOxsmlCLbKP+WR6vsngwED+qz1sEMq2P2JpKQUCsj2X1hjr9E6NIFHWZbXcP
         X4YKDkvk5uDVCVJbfTlyuIrNK2QeTOJif2egAZlma6UJvQpnzxGDssyiUx4ij+LRX633
         IrllGrWoysFtEj1ui4a7LyqIgxqxAIzgkfGwppfZQkXqJNpYQQPdJfpUqNO4EgX8DX7n
         6U/NtBiHCfqrOagNf+U2mEQx19LkXyXb8Yoh4tgGuJlWZiondVxW4Uu8bDBvbfRhaKgB
         lQuKygBoxTw0/qKc6La6oLegYj6g8Ik+UiqNQK0iZ2I7gQMa3RwpZwyrCGBBaHH7+Hgx
         ns8w==
X-Forwarded-Encrypted: i=1; AJvYcCUYZl+WZEuzSqaeobPcD59twis4O8YDWwsNCPbIfERIUSrBA7Jrb8ig6+S4reD7K96Oc5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqoeDdX4uh8ochQ4QHGvhwuWa8g1WnOQQ0SpIocaiVWK6hETax
	9xpPZWOxrSLjXVcakHjhp5QQ0f2pMu/NwJH4/ishEKbWvabM41Nd/Mi17o8A9YY=
X-Gm-Gg: ASbGncuvyEM6fXBrpnY78VVqRO89NEFlXG7as87IatMkhrk5lY/966X58O++ncFnsZW
	cweQeot+bGG1/fw+FpW13r9YvEQh96QGNvO4YR3daV9I+oc6bkR5r2swzVb0BhahlFeQ1aErMO/
	GpVoDMEN1YzD/gX5vo4N0kGfz9NK72FB5ur5KrAm3fXNDZdvc/t4ZLk3pJBmknmav/TAeLy9QWQ
	/N2OZmOiHM3yNP71pYLAP6b5Nwz5hhqouc7PBcvwq4xlz6Tn41j32FwU1OTeQQxmhi9cHSpFZcW
	rdGHkCvR8lbwpKgN3qcBj90Obs6s5dgRylERcFIJ/wQ2rbuayBtP1Zfo5pa5sQC10RPvU7PygBd
	QB7QN
X-Google-Smtp-Source: AGHT+IF7K2bMCBebnT9LwgduuidxGRgYFCLYLlDVmnaUdkMWDHmiUi/EPjiSU66dMxFVcXl3y3OAOA==
X-Received: by 2002:a05:6a00:22c2:b0:736:eb7e:df39 with SMTP id d2e1a72fcca58-73e24ae669dmr4974975b3a.24.1745508761140;
        Thu, 24 Apr 2025 08:32:41 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:40 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 07/10] riscv: Fix no params with nodefault segfault
Date: Thu, 24 Apr 2025 21:01:56 +0530
Message-ID: <20250424153159.289441-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
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


