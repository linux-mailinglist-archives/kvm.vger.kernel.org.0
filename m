Return-Path: <kvm+bounces-44407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2046CA9DA51
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10BC84A6FB5
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6504229B21;
	Sat, 26 Apr 2025 11:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Zh9H65u8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C9121D5B7
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665473; cv=none; b=WaqD3rt3/J4iWHkWHJ0WEHqzcsGq672rDTq0E1Jt/mVuJz6+YjK59LBnuqDGqA+Vukr39XtOvAb1HQAg/z6z58qmW8OaRX9J7cX4wAlwlLYR+DtqyVjlIKXNijbM0om0ffttG7nh3HicUe+px+wLbpHArnHDG6OmBm8ohY0BSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665473; c=relaxed/simple;
	bh=tcUDi7mPRYY6TGIPK1UnEszKL2dfkGGQM+zViOQ2Jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEk2vY+4ULSrzQAcb359cDE9oKwKfEKQCwouOKUTLetogUUUI9xR2qzKGJYAQneQmoaGcvg2pB4im0HP/LlK9KNWmqcysly/mONO9RMQCeqIARDbYdpQn4JovZ3igOUMBSPi5C8/+I6JPZG2zwaUftKtPoreTJjUKqhkZA1mNaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Zh9H65u8; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2260c91576aso27158615ad.3
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665472; x=1746270272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=Zh9H65u8qKJmLmOvipw78mve674ZJ47BYC60tuw7mEUvrhqEIwpcAMRoMfODITG5Hc
         MPOrodoek9/dXR32HwAETXOGiD1ks0cFul+YAjkh3NqjZ1JILQKty386c5FGmQCPN4XX
         T1gFL76fSktXlqj1+026D1eeVTk5GwYyiYVS/hds3pd0iJDeTepbL5389M2HuCgJQ3nA
         gljv5dx+kPwZCRZFGGNOl/e1dcvQJME2OH15+Cp2puOqN+Z9ZCrNZZkwZ9m3IgVETwrf
         LtMFWjKsNbE0tOB7MsfGqQ8K4M6ayUceZ9+Pa9k1Fkq+jMTR5TGtfy0x6ARsaOkzAOtk
         q34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665472; x=1746270272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9/1qWtDS6xTLdJMtcRPhkRNGwQw4N6MsnqnwpODYYU=;
        b=hB/92cUZrbuDrUCwihci7Yr+yqdMhennhlfZbyYS9fmO7yNGwTEKIRRc4NPn82xFc7
         c5BEe0lQMNSrKyaGVeSv/v9Tv5oWu3zhJuTb/E1ldA4pPZHdU8vr0VfOjdURSRB0JdJb
         Kacx7hrkaoWclMvzCBwdsbTrEtam3/bS+ySQQbEX3PVSsrv+VuPfU/ACR9gIGwjan2dx
         souVBq9RgWQYHX9BQRRrcCjvKIGNXcxyhS8cBJjnedDB66F4axyg/6zocZNLHVxHhYlh
         OGgTlYQffX/sstfPz7H+/rAKOG2xqCL1N77zaXyJ1c2b+dwV2eNTyquFFO4aOqMBk2Tw
         O3/g==
X-Forwarded-Encrypted: i=1; AJvYcCUfhZdDMbgefjyyrq98QbrqPMBkuAYJg3oRpunqToSJ95EA7V9mPoBh11UM8i80RCSrbvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSg9VWQsOxYdn4KTfsYHhoghWn54haOU/nokmx6FcXimPz8XDl
	1Pzaj1QtHf/spCR8z4nDxy6kiLP4zv9OQULxRQgB8xxPSgnFLzCElH6p31KoZZY=
X-Gm-Gg: ASbGncvhjKayJmPI6hXg13oRJdYRHBBc1MBd+mENUdKxv1WHVNTcmsE1tipHDezG7GV
	bsJDfZ2/m1R4pALo9hkcJsIx70hIQx310VPyDSL+QChdtIcpO8fjfBhw9P11pq+GJWPSJHeJHyi
	pEgKinmHgOezCzkRMn88KQVIkw0PdXyLgswO1pmKdb18x9Efwn52ztFGz70Qt2872ve9nzvys23
	CFGcXIN0hA0dxaOG5C1Y6vxlZbiBjUGBL5irYYWQP7/2SIwn8zqvX3ebZzTalUFH2aJZB6dNtwU
	0ycGKReKC4PM3j2teaaQ11pjNrpjkJXGItjUCOkAdlDAWF7TjGoE7oMyL7QmnJaWCJPAWZOIIgH
	/4mEt
X-Google-Smtp-Source: AGHT+IHbv6LChpCH65BPpOe7ZBPebThZDY03o/Ar6cKTcr8f7+X0YX9w6Lyha79eeR/QT8hpjwMUew==
X-Received: by 2002:a17:903:41c9:b0:223:f9a4:3fa8 with SMTP id d9443c01a7336-22dc6a040dcmr37829105ad.19.1745665471721;
        Sat, 26 Apr 2025 04:04:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:31 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 07/10] riscv: Fix no params with nodefault segfault
Date: Sat, 26 Apr 2025 16:33:44 +0530
Message-ID: <20250426110348.338114-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
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


