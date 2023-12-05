Return-Path: <kvm+bounces-3574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 798E4805682
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282231F20DD5
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0270B61FA9;
	Tue,  5 Dec 2023 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KZAHwjKg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38183D5E
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 05:50:55 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6ce557298f6so1584565b3a.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 05:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701784254; x=1702389054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=KZAHwjKgp2LBtSTwhRd7QX0pVgCtGW51nd0JVlGasJi9WwHD2uLZhnJN0sYMilXjN4
         Uk3/eEIiQyNDZnGBtrJJQ8lkbqMHhy3NYJNza/03ckMtykYipMP3Wg9deRO3rwCEseVg
         ELEHh/PJ0eii12a0YEaUF3p0wpH2EY7O8WZ899zB9+CnzZFspePuVQliqMcs+QGuZNmx
         Hbls0rMQWjjeC2ywalB6J0R55nL4UOUyipPYmdo4EvySxP6s6gR2y7zUmNuoZoF7CyNX
         UsU04BYo1ieiJ1jjJ9Z8jWdDSjpWKos/rO6CODvB2Pqb6LUY+7PXVaDEGa235830hPMH
         U8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784254; x=1702389054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=hV96VK9MgnCTCHuEwNLkQTln23PTJKpNPzFthPFQjiMM1BbjyjVBo/YjbJll97VXnc
         QBNvW04PmRp7tY09TlcoOv2G+TFBsQlezVMLE6HqvlDrab3UjvLNSR87ZMo8PqB+ftRa
         xYNn7aG6hsp71MseKEpKFm25oJS0WTsfE7p1mcAhG+dfUZO8Fm765Pxkp94sE0voPcdJ
         SCx1FbUKKIVINwxEjgkNbw//yPbTCHXoZuc6nsYds9AQftzdnPnkyH4GBm5mPt1GIPfs
         +S/D2YElavZv2pgoewmNrDhPEEK6ZN0LZdsmoRXQdrhm/oPvKrz1Pw/DhFcFUbVUK8uB
         mAag==
X-Gm-Message-State: AOJu0YzIEq/ey5mG9u5I2xIZR/osbMz9bU1n54wcD94rzpWfMcqjBp3K
	9LzCHswv+sZ4osRgJR9ib+J4Ug==
X-Google-Smtp-Source: AGHT+IFFofEjDPFCygGTkPI8Pv4OsjhRCek6+h6rFjjhHBJGn6KCZVf8+gVKPxrIKPeuKD+6UPO0Dw==
X-Received: by 2002:a05:6a20:3950:b0:18f:1df2:356 with SMTP id r16-20020a056a20395000b0018f1df20356mr3471659pzg.96.1701784254595;
        Tue, 05 Dec 2023 05:50:54 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78c16000000b006ce77ffcc75sm673641pfd.165.2023.12.05.05.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 05:50:54 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v2 2/3] RISC-V: KVM: add 'vlenb' Vector CSR
Date: Tue,  5 Dec 2023 10:50:40 -0300
Message-ID: <20231205135041.2208004-3-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
References: <20231205135041.2208004-1-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace requires 'vlenb' to be able to encode it in reg ID. Otherwise
it is not possible to retrieve any vector reg since we're returning
EINVAL if reg_size isn't vlenb (see kvm_riscv_vcpu_vreg_addr()).

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_vector.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index 530e49c588d6..d92d1348045c 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -116,6 +116,9 @@ static int kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
 		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
 			*reg_addr = &cntx->vector.vcsr;
 			break;
+		case KVM_REG_RISCV_VECTOR_CSR_REG(vlenb):
+			*reg_addr = &cntx->vector.vlenb;
+			break;
 		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
 		default:
 			return -ENOENT;
@@ -174,6 +177,18 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
 	if (!riscv_isa_extension_available(isa, v))
 		return -ENOENT;
 
+	if (reg_num == KVM_REG_RISCV_VECTOR_CSR_REG(vlenb)) {
+		struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+		unsigned long reg_val;
+
+		if (copy_from_user(&reg_val, uaddr, reg_size))
+			return -EFAULT;
+		if (reg_val != cntx->vector.vlenb)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_addr);
 	if (rc)
 		return rc;
-- 
2.41.0


