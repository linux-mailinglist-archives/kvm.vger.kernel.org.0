Return-Path: <kvm+bounces-44176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BE2A9B0CC
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79EC57B9455
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BF929617E;
	Thu, 24 Apr 2025 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XbJe9QFr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4B32951AF
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504070; cv=none; b=L8KBj+STWicXMZAzlnO4XrbJeXfN8XQpB7VWKThnse8JJbpXI1yXQ9vb9LohIpA7sltTY9UKKu3tHLJatRiXezfdE72amncnTPwnFlum52iyU4LO0lwcXXy+1aP8OmfX7QeO7xuzIqbYdQHG7ncswnPMyP16ET9JLoMOewPgM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504070; c=relaxed/simple;
	bh=lrb7r2WDY6/wiV70trrJFyhVfjh+ttGLRTnjEamSc+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h/J6fzF5X8nvGHoGZxh80tTZ7uM1Qcu0XZLkjt1FGKak9bizYFWdP2EPxetXZhmEKwYdnrCuVmvdXrWEtoxqt3VrCrF35agOdvhQG9LWoHJBFjj7LEp1BWE1DP6auc1rWvYSEKmdFPESyu9Pm0DYzzpI0Pbr+tHRcXA/OdFLccc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XbJe9QFr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so9635255e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504066; x=1746108866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+7xBf3XhJMHfpZe6B0obtpZq77mLhIssmTOLfcblvc=;
        b=XbJe9QFr/198bFBMe0kDnmRcwfggZDJWfbsXRfz0KwxrS2sZZlklMbpaxSGQxDkso+
         8ZXyoRzxGpnaCcazFtAGjzLP1pIclvwLO3OZ82s8nmcercWkwXZw8VibNb3/naT9Ch7t
         lg4UXSgMyYgXagUHDHFgvj01YQsKI9EPC3slYHdT8pudV5tBWXWWe/Tom8r43tad1QHM
         LhYy7YlW9awbC0iyAv+MA/R4vKbUctEshurVcj6pQcQIczcjshb1apYJ50NtfCBgRg9j
         xvoFgWgGCU4Rfum3+xIrinWqTd7Gsi9yE21RS8LOJsCn1TS3Iq/dvVZHkPePYPAwuMLX
         EB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504066; x=1746108866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+7xBf3XhJMHfpZe6B0obtpZq77mLhIssmTOLfcblvc=;
        b=TPcX+qAoz37NGwPqmv60O6ac+ILVLeKV+qCqlFj5DfHHltDLm+hX8DG/ACBekKwBXO
         RYn00CNri8QFCpbd9GlNIy7MfYYrC2/agLIRGPJtp31UHUe4/jnMsVjvAIeM1dSVUHdp
         nTTcKDDFS89xv1uElU0LUHFGgYjbGHoA0xEcQJveGKYixwa4drlE3xtRO3desGshf5LS
         K8RVYl2mAI1elTDXPyjUh6IMaEdfi/c9kbsRCzs6LEmNa4oM72d3B4Gxb6bQ1TfBsfUP
         tYbG4Vkj7xh1pp4m1KD1cOHbq0tl4BpmgbTimNT5GxT1qLx4whIjtjeFzFHTmzVzJv+V
         /anA==
X-Forwarded-Encrypted: i=1; AJvYcCWJUFfaEfneKHwFcw+gaHoG3YIrRda5byjRSI3zoFpSKV4hyNfJYIjYQ0+FEYEG4mZOKQk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCIysKLwxTkyPhAxTbc0NJiagA9z/LchzmICcUVqIGFTT+rBZv
	zzqjnJqNVQPR46HBuZpcV3gvt97KceHovPZE0kJwTOPOZlBDKkrnwrmfQxjUxUs=
X-Gm-Gg: ASbGncs2SQfxAUmNedJDkkeAt6W+fIiD+hS5w4aj9xZckxrhLN8+zhoTKYzjxh1jk1o
	8gNPO/+dstRdcaq7O2uNmBF01oahjJmLxrt7g8XOYbQndjxLF2LpnqfizbnXcmETsIIcoVD5bLu
	YnTf/7zJzMDcj5XshJ+bfZZ6UhJbBos2VKnj7n/0wdGrrUEan6trpk7xb6dWufxSxL935vlFwtS
	4gV2YwGP9gKYpyiiCF4vPoYeDPfS0hHEsH96PdB9X6fmkhkMQ3aiskGL6iSt9iIWAI+8FVIRH7M
	M53ufH6lvSlAx7HuJoDeBhaqX3fdWstErakA+aFSHl4PBDu2aqvhRcbmQvVCU5ERz32LGsO2Xei
	MkQ5keCq3EKGpQTLB
X-Google-Smtp-Source: AGHT+IHRjNQ9hktsGOI0gDbs88pFfwmyof1gAXg0Su1amTrqhLAxn7c+kspUyHkoAKmkYrrR9nwrhw==
X-Received: by 2002:a5d:48ca:0:b0:39c:1257:cd41 with SMTP id ffacd0b85a97d-3a06cfd462dmr1866395f8f.59.1745504066490;
        Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 31/34] gunyah: allow userspace to set boot cpu context
Date: Thu, 24 Apr 2025 15:13:38 +0100
Message-Id: <20250424141341.841734-32-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow userspace hypervisor (e.g. Qemu) to set the context of the boot
cpu. At the moment, only the program counter (PC) is needed.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index e8037d636e8f..df922be2429e 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -1703,6 +1703,24 @@ static int gunyah_vm_rm_notification(struct notifier_block *nb,
 	}
 }
 
+/*
+ * We only need to set PC to start of kernel
+ */
+static int gunyah_vm_set_boot_ctx(struct gunyah_vm *ghvm)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(&ghvm->kvm, 0);
+	u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+	struct kvm_one_reg reg;
+	u64 *regaddr;
+
+	reg.id = core_reg | KVM_REG_ARM_CORE_REG(regs.pc);
+	regaddr = core_reg_addr(vcpu, &reg);
+
+	/* We only need to set PC atm. regset is 1 */
+	return gunyah_rm_vm_set_boot_context(
+			ghvm->rm, ghvm->vmid, 1, 0, *regaddr);
+}
+
 static void gunyah_vm_stop(struct gunyah_vm *ghvm)
 {
 	int ret;
@@ -1790,6 +1808,12 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	}
 	ghvm->vm_status = GUNYAH_RM_VM_STATUS_READY;
 
+	ret = gunyah_vm_set_boot_ctx(ghvm);
+	if (ret) {
+		pr_warn("Failed to setup boot context: %d\n", ret);
+		goto err;
+	}
+
 	ret = gunyah_rm_get_hyp_resources(ghvm->rm, ghvm->vmid, &resources);
 	if (ret) {
 		pr_warn("Failed to get hyp resources for VM: %d\n", ret);
-- 
2.39.5


