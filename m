Return-Path: <kvm+bounces-53972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B98B1B252
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8F6A18A0C79
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 10:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DE22441A6;
	Tue,  5 Aug 2025 10:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="MfB/95/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEE24291A
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754391249; cv=none; b=FS6mltyE0Nm1fz3iSzSgQpmwpWOrT1AhYBDfLnybJ9O9CETIcmkp8SChONgAItptnv9QXXSMgavRg00Hfs7mvd1rmCPh85ImA+9juS+gR+citfmrR+3ibcdpHXj5XFwLIVx6IL8Jq5RHsIT/ED0iHBH88KxYo2nHXiVHXtGcdBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754391249; c=relaxed/simple;
	bh=j6njE58QFD+zg3/0GPbXJiFfWjG2rF0iiy1yUJKDjrI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MrD5/0DIGlk86bJhCebaG2Y2vNxJc7AlyeODryVPrc464Odu/rY2oBdUvhoN6YfZXWOBmppZeXuBy7N+sFI7koRYAqcuetYmcRyiAlRiZojQY2nTflz5xsNLqWa3G74HajvqVimHLFYuEj8XWJkwYAxM0hSiAlHenx+SHxME5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=MfB/95/X; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b788e02084so283175f8f.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 03:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1754391245; x=1754996045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WUiodtQBvKBTA/iKS7oNMgVKazgBWdic3Ly/8SfR7xc=;
        b=MfB/95/X6j7hyi4c7mQpUHSGHCFQ+iwVMOhVU76zaZu1/ti6Q7Fsddwq90v7WAby9Z
         bpQrNgHRQOapowQzdW2rKJND/CykUwh0CHt7OC6y16oXCsqauOJ6Iv+Q+dCZkBRD9TB/
         ESbOFd/jij75oNWIsHZbATIku4rL7puYnZWQKDwCT9OZSWGKtpVz+4QfrgpGJYkkX2Ns
         9HGPug2CVmlfubL7YgWML764DvueOgAsDvN2zAn282lf4EuuTU4mX/eDTC67Dnmq2r7e
         SlANsfpi7uwMevgl1FI631eJEjgOtuMz6XnJKReJp3mdRah9u2Ik5NF6s5Y/vXwPCfgR
         D06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754391245; x=1754996045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUiodtQBvKBTA/iKS7oNMgVKazgBWdic3Ly/8SfR7xc=;
        b=UhPbHaNqrQtEOd9QUt4DNiPtywPF5CyGoms5DgBFloEbUHHyNmJBrg1UjHWDgMB5Uf
         hYloXtwphTAQWgP18EBO88HuFcvCYYeAo/vXtH5tcSqvJGsnX4xJpy2Pm+SfcrYWgVuU
         A26pRL7IcAE/DO1ZACY9DJptkXffGjsEAvAmCC2UyCxvTZjKs26U3bsRldr3XRJzr9mu
         pJAagth1P7NnwMV3syyFqv3VYjg5bUPGnk9QKCb3gYs7BLUMJ5wW+pTA974MyYtTBaM/
         U2f2S2DcVuNYNFEYa4dTpDOyWbZR8QSdQ6vSr3zTTpMLtzRfRpmNEdU6piNObQBzFcM2
         7BMg==
X-Gm-Message-State: AOJu0YzA3YsHpuTWNa74nq81G14rNAlNV9yaHc0v4KzsHPE1nwj7+E8c
	lAjPylvn2G5FXPZxes2O2e00cg3WAJ4hI66lrb8DuKSGkT2uL/csqButp99e/8ZEi+8=
X-Gm-Gg: ASbGncs4sXG+yOTsXvETY8kARdpoRuEaLaGdO53JOIzRS04VBP7i4MJ6bgGVh475udd
	9JWKQ+DbXu9nik9fWUHbycziV2CxY+84A4NB6Q7XMBVftRZZgEUMmQT8xC8r+Xg6YTxePeecCre
	hcxV3O2/bHrvTI2nuIRdW8oh89AsXbxs7nliPnO6tR+Y7Lf5N+XYKyfVBay9tb7btlpqo/UQ/sD
	1h/ivRMnfrJeeLgrBu/jec3VLc90tpCSCi0Hdpe3n0E5gGKhE6FfxTIJruuus8DBzRU4h/3kUR+
	o2Lcjvsm4IxKPQQlpJZqLup2ojD6BX/b7icB1mkUc5mz+6DrhKVVlhNGMsQgx40/g4RZCX2xzKl
	HWLIMXlpf+t+4VcPTWI2W0AA003EWMad4oXQG6io=
X-Google-Smtp-Source: AGHT+IEpOsq0FAVja98/mlRReMdSEb+xPNZ7ZEoi0EN4dXoUtDCJVpNHURSd1y/tvYFRXGJZtratYw==
X-Received: by 2002:a05:6000:1a86:b0:3b7:99a8:bf6d with SMTP id ffacd0b85a97d-3b8d94b6fa0mr3885890f8f.11.1754391245272;
        Tue, 05 Aug 2025 03:54:05 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:d884:b809:d57:1ad7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abf0csm18344450f8f.14.2025.08.05.03.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 03:54:04 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	stable@vger.kernel.org
Subject: [PATCH] RISC-V: KVM: fix stack overrun when loading vlenb
Date: Tue,  5 Aug 2025 12:44:21 +0200
Message-ID: <20250805104418.196023-4-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The userspace load can put up to 2048 bits into an xlen bit stack
buffer.  We want only xlen bits, so check the size beforehand.

Fixes: 2fa290372dfe ("RISC-V: KVM: add 'vlenb' Vector CSR")
Cc: <stable@vger.kernel.org>
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index a5f88cb717f3..05f3cc2d8e31 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -182,6 +182,8 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
 		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 		unsigned long reg_val;
 
+		if (reg_size != sizeof(reg_val))
+			return -EINVAL;
 		if (copy_from_user(&reg_val, uaddr, reg_size))
 			return -EFAULT;
 		if (reg_val != cntx->vector.vlenb)
-- 
2.50.0


