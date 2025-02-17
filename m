Return-Path: <kvm+bounces-38339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E1CA37D61
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 976D03B0FC2
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2281A8404;
	Mon, 17 Feb 2025 08:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ooQ0KidS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379021A2630
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739781912; cv=none; b=a7/+x5Y9ikrOKIetUP3w9EukEx9qrryc5P6uiYLU3F4qe/QRVk6OHBes7DwcC9SDMiKa+/61AsU5rEetmIjmeed+JQiGc6TmqNsBbVIHWC+fgKU08zj7eWhIypVYJm50D7QTK9mRw/6vdy9tXNsw7cd2FlPUgSbrdysQyVWZgkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739781912; c=relaxed/simple;
	bh=2Tut0PY2upP5Cl+GzK2sIbXrM5UY9W46/YKCJOvbOiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLCI+plZx/7Bog0cdNtxae2vMx20RpfnHwSgvaRT25bpf4ZIFCULbqdiKWgmdVddBpULE4S0CSjhAtoNVnsTePPAzuuGpmIodb7allhVMuzYSZ6akJdDcgZtb4mGXa9i4t/knY3ZVb8W84FdzFwnVWmjLg+h8cj1O4qeVJdmFSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ooQ0KidS; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38f378498c9so1302185f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 00:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739781909; x=1740386709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmOiuBasU6JQWrtvlHuH5EGMnpuZux+G/rw1YW3ZnKQ=;
        b=ooQ0KidSvlEn95evQDZ9cPJ/0tijkYIsvqCm0cRqZmjlEEBYTlXGtiTig5vKFw359w
         PVm5zzg0YWFbeEjHjLhSyKo0YihJnC7rYcJWLAb5HkzZu7ekG7gBljwblhop4XIzpkRB
         tJazWF3r8GxdLr8Pfpj1zObNSdDymLh2mfBpM9VKYqktVKb4iid1A7G6Dmx3OKXhMFZR
         YkuDy8i3FXzGorqG0TRHHwg9mpOVItvTBEp6IPuz2TT/enRIAb8AtQtuPr5h1LmUiUSN
         N50beiV5+b1UHdu9eESGs8+3jFOyeo+YQ0VH9pRMG7AmN9F8F2Wcc91UbxKM0Klj+TDi
         KdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739781909; x=1740386709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmOiuBasU6JQWrtvlHuH5EGMnpuZux+G/rw1YW3ZnKQ=;
        b=CFiuLc+7yrPQouRhZvYZ91CgedL2MX3ZhrR+IrMysNDZ4eCr95joMdne0DHoQln37r
         EfIq7bgORnFMsOOHpmJ50YjbSovZiKw50RsQL0aV9f2y0oQCkDger9iqgDXJ22+d44cY
         zgoLyBrvhKHZWCaetTzk2mBe954Pigk/cpsNjVnC8+i3L94L+Xi7uOWUF8E6BfPNpEVS
         /YqcvcD6w6H2CJ6T3AP96OIwzil9I9WAnm7Fp9R1yoMpe/Sxqvq25SzL+8/+SYz2cwA9
         gU44Awp/I8SPMzAoiW3pQUroZbk2qZmEVmoszUnav2L6ncvMk/Yn7IDEdTK7+5y//mfd
         6iEg==
X-Gm-Message-State: AOJu0YwhS+E+J+WgUNRbEEJhD9v8b5gSYqPS3GHLjMElOIPMGIzIyDnB
	NamB1hCr/eOZF7PoL9lCx/TdzhqkLsPEDKiZVi41FjlqF3gFrSw7lZCGhj5r7/fiTb3oJrQ7yt8
	X
X-Gm-Gg: ASbGncurQ16O84Bo0cQRRfW7NNO+vEPR6KLj3It8/jHvU+Ls0eUOu+x4p7XnCy4RT+p
	LzbHisi18hImRP7sd7tsghzT3RR617Vv7wVs5Zq0Bx0lOhscQHdDrYnMCgxNMBo4sy7wtjKSLaw
	P9Ero+IlZaCPIITV8PQtx0K+PLwqGiorVESnIoLb5q+aaYuXSatlbvD9bGgupozf2V2y+v1IsE9
	PlvHAZ6I9rQ5YTo+8q/0z8oSs33qz6vrpxnS+AIi8+jIZj1vnvN49oeL1e9Hun/ZHz3pjyvZHC6
	Dpc=
X-Google-Smtp-Source: AGHT+IG4XexX5u4a9ST4SKpxQS8lH/aGBNXid1q/a0drWF3aciYyLxMBoUybxw0lIHE5NbqdkQOXHQ==
X-Received: by 2002:a5d:694b:0:b0:38e:65db:517d with SMTP id ffacd0b85a97d-38f33f5107dmr7035502f8f.40.1739781909479;
        Mon, 17 Feb 2025 00:45:09 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258f8c4bsm11630555f8f.46.2025.02.17.00.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 00:45:09 -0800 (PST)
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
Subject: [PATCH 1/5] riscv: KVM: Fix hart suspend status check
Date: Mon, 17 Feb 2025 09:45:08 +0100
Message-ID: <20250217084506.18763-8-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217084506.18763-7-ajones@ventanamicro.com>
References: <20250217084506.18763-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Not stopped" means started or suspended so we need to check for
a single state in order to have a chance to check for each state.
Also, we need to use target_vcpu when checking for the suspend
state.

Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index dce667f4b6ab..13a35eb77e8e 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -79,12 +79,12 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!kvm_riscv_vcpu_stopped(target_vcpu))
-		return SBI_HSM_STATE_STARTED;
-	else if (vcpu->stat.generic.blocking)
+	if (kvm_riscv_vcpu_stopped(target_vcpu))
+		return SBI_HSM_STATE_STOPPED;
+	else if (target_vcpu->stat.generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
 	else
-		return SBI_HSM_STATE_STOPPED;
+		return SBI_HSM_STATE_STARTED;
 }
 
 static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-- 
2.48.1


