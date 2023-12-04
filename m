Return-Path: <kvm+bounces-3397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE85F803CFE
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ADD21C20AFB
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DE42FC3F;
	Mon,  4 Dec 2023 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Y8v5FiRi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58F6B0
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 10:29:16 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5c6734e0c22so688452a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 10:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701714556; x=1702319356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=Y8v5FiRiLHstq0msZOlqLf8Sl25plGCmGtEsGWsib+DtSVNoCvhs5of/UDX4+tqJcx
         tOgjGMPj5hRUAxJILcIte+QrCRlue1Rw3BCieflj7Bb6uJtatFoeHdLaG2+pumOgiGzW
         te5v49Z79q462RpWBrkZmH/8Dqn4ETn4+4oHYEaNL1euMpG6T2cSlJUe0V7qMthp1lTP
         PvGJc2MKBADD5KHaBDBNMI2tPcxuCcJd1DS0Q/+qgaI9b5F1WKogKQvrJkfF/Sg461UN
         KKZFcDjUWG+5UtT0pwZksWp4bmEyfB2/vSh9bjPSyPTscDH7y5asI3tyFrd1ekZ1tWEQ
         2c7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701714556; x=1702319356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDmx5prnNC5GcsIkGu5R3qOSAEa8hCYanFPPTHn90qw=;
        b=sz19pcmHbRpam68zeCXmFScX7L1mID5AxAkJLB1T7yBNJXzr4bFTf0xEm+24/WMzFC
         UMFPUiv1upmtSTDNqfXmp6Riy1rxHMjbjN24b5ByeRj1VI5neFR/DE1Pot4HJww+8KO5
         SqTvDE8YOz+zLAqj5CpNlRT6Zlz1sL5SC/AA48aSV6biUWAHSlvgAj/7yqNJC7nuoQGP
         eCttxQVsfAY8A98ykogQ4oaN76jjV6PTzyUnE6q7DWjrcMM/28y2FA7d+YWJKSz5B5kd
         qqV2Dnwq7ExrchmV4wT/PNann1LFbdVR3dTRzxdMotVZjuLFDC3ZGL2+jGLQuJz/UEt4
         nNRA==
X-Gm-Message-State: AOJu0YxeAK8GwvoVxN5Op9ham+ZUAMMGLb8BeAAx0qnDNsqg1o6iVV8W
	yG3YkYbEUBJviAaYGaTxX9NzWQ==
X-Google-Smtp-Source: AGHT+IG6Wyqv2WvJP1zaZXMUuQtyu1/S6bopl2FuO6DN7j/U4MqqE9hCWwoYJQU65ZQ+sT3VU7DtaA==
X-Received: by 2002:a05:6a20:daa7:b0:186:555e:bc80 with SMTP id iy39-20020a056a20daa700b00186555ebc80mr1933829pzb.25.1701714556270;
        Mon, 04 Dec 2023 10:29:16 -0800 (PST)
Received: from grind.. (200-206-229-234.dsl.telesp.net.br. [200.206.229.234])
        by smtp.gmail.com with ESMTPSA id it19-20020a056a00459300b006cdce7c69d9sm1806224pfb.91.2023.12.04.10.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:29:15 -0800 (PST)
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To: kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	palmer@dabbelt.com,
	ajones@ventanamicro.com,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 2/3] RISC-V: KVM: add 'vlenb' Vector CSR
Date: Mon,  4 Dec 2023 15:29:03 -0300
Message-ID: <20231204182905.2163676-3-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
References: <20231204182905.2163676-1-dbarboza@ventanamicro.com>
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


