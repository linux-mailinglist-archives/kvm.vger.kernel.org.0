Return-Path: <kvm+bounces-60115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F375BE1159
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 02:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2412C42531E
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 00:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F8672605;
	Thu, 16 Oct 2025 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ifSuaKrU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834335962
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760573838; cv=none; b=WLtjRPdb/Y7+VPldbodVam0BZ0QS9VqDC/K/8igB9JcSnXRmyOAUjqd8EuPTX/0X7TaXb0rnRAM3ltnd9+mSLUdnzCfqOY9nX7ydexfwe/hIi3Ls1Dvc6t0J1YkRPU/U95GJOwbdwNABfszXEak/iFazeOXQuMbIFywJa+Kpjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760573838; c=relaxed/simple;
	bh=3nwS8JQ9zjyPPEh0FDdvtn+6T1P3KX7rqtYXZtj0c4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uMhlegZ+phosMWqMdXhYbTinjnh7GGzaf2wWiFWsQesnpyOCFJYyZ0m47RAgEnCdoGoFR37eUBtcIAmxnnL/C0WUUJV/wD5xdidnFIvJGyd8q1AZL9VmeGj9cTOB6/M+hCDe5NIn9tJ1+HRpZC0NaIjPFqiUh2Z/c25i+EC4B98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ifSuaKrU; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-782e93932ffso141254b3a.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 17:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1760573836; x=1761178636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bwptj4G5KoYvNAhjikL6LhizMbH7cKsoQglRkksgDsw=;
        b=ifSuaKrUtRlBbG9MQ9Ok1pW7Uecj7cFdCTd27QsS6LG9A/r1vTYBxOVTBHuYt7FAIZ
         LDVb/cQqIy+OFt+p5bZ+MSoQ01CqI7Qkp+hpLYmPIWDa7FVh95tavaQKjt/yCsY5uiWQ
         iuVnpZHm3/YV4xboPJXD6IwZ3l6rts8cvUG3PQeP1CsJHCAF/1XdX0chvRPitTxb2CEp
         AsTR44Z5P3FHfjwqLAOwAHw/mIUappj/PCJpc9jFl96AwExZjOXwSjgeCAkMyPq9ZJyG
         aNVGkJ82jAGDY7IkojXTnW6Y2ZsnMThMkVaWuTuMaQmDqg1Ym1hpdcD8PLzB6DRKhEc+
         7T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760573836; x=1761178636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bwptj4G5KoYvNAhjikL6LhizMbH7cKsoQglRkksgDsw=;
        b=djDw+xszrpAfIWzLrsN2gMlrad8hf/DON4yfnJbpYhES/joZPfuvkYhpXJAGHfXDsP
         fPy5D4f/GCRxbOgHmxn4+FqXrXJ2wRUWR+/3leS9Jv/Q5VTsOwR1YcEGkAFO4tUPEGsK
         3DRm21OONCukhXSitREo9aT+dEMbkalohR9MR9DlwJWYXN0+AV9j72zNj8zpcMcqCNRl
         Ug1tOd8CI0lYXm2oeyCsZ6b//wRbcJjaOTkIkturED09igIDeFRfeRVSg2AoEfVf4xiR
         3fjbpVMBKm7zEp696sL+nj0KuI01CERPJq+oAbtrdfmaOXVkui9e1m6EedeEFP3/qm2u
         kk5g==
X-Forwarded-Encrypted: i=1; AJvYcCUamceLI9jxdcRrtrMmfl27tQJ/l5etmJAP6igg2Y7MvFb2Kc8L1J9eb32zi76ReQTxr5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzLoMDcwzLMZSEPPMIY6Q1OdiVTsJBftX9qnOBdRQlLzmClhS4
	DzqpNaHkKd6FC5zplMzPNV6boiL1YbjHHkXoPohlG2+I6B/0ty/CfDuu8M+RDhaiO9M=
X-Gm-Gg: ASbGncvapfrYY7E7jW3R5mU19Dlo7ae8YwS+A8D7dBWgE6fJvg7eEZ68jiLDNqA951h
	kLjKYkRgEKMGzNT/T8/Hb3I2CPbEXvESRmZ+B6C7yVJyIXx8dF9ixusCsqYRHss4WJhcR0wKbgt
	CcGmp6h7+Kqo9y1sGe2tALuFE1pdqJ1Nw6ldIrlkEEjKOlWUPNwOSoYv5I2ELk0zbtD1OZoeDmW
	EyeTSk8m9i2K3m+ZKCIoA2poULTzPWr+rkiyLvPgFy/712WMIOHXuBNl9X12TWKL4HQQBEA8UUB
	b/WkUAxISVsHWNxML+FWSwSgsUf3w7x5mMn22yBXpk1O8YjIS0e6chMSddZFg6DihgPQoG68vXu
	bam4G7hUWSG3TSJnIXuZUG8bo0rFlyc52txkzcw61I5Ic4mTWUvsV2ic4xWTsWoHNGqgWZaD9RK
	bv9nNHhv+hBWW+kNM6e1uxIA==
X-Google-Smtp-Source: AGHT+IF8Txz7jrNpsSTJjE/JSeJk6k3fgDPYMzVbvQKqjcn0cbcXxdsvxtPavIzWrNBmcH4D/9ElyQ==
X-Received: by 2002:a17:903:2381:b0:275:c1e7:c7e with SMTP id d9443c01a7336-29027356a08mr313186275ad.4.1760573836372;
        Wed, 15 Oct 2025 17:17:16 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099afbdb5sm8484645ad.104.2025.10.15.17.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 17:17:15 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH] RISC-V: KVM: Fix check for local interrupts on riscv32
Date: Wed, 15 Oct 2025 17:17:09 -0700
Message-ID: <20251016001714.3889380-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To set all 64 bits in the mask on a 32-bit system, the constant must
have type `unsigned long long`.

Fixes: 6b1e8ba4bac4 ("RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

 arch/riscv/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index bccb919ca615..5ce35aba6069 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -212,7 +212,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
+	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1ULL) &&
 		!kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
 }
 
-- 
2.47.2

base-commit: 5a6f65d1502551f84c158789e5d89299c78907c7
branch: up/kvm-aia-fix

