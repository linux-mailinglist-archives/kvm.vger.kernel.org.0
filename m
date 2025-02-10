Return-Path: <kvm+bounces-37747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D195A2FC61
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD6C116627D
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAED25A343;
	Mon, 10 Feb 2025 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rDhnaJj6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69112512E6
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739223385; cv=none; b=HBAj7uSyvu5Q+ZOWuXmRkanl5n9cuQm3hhBVrI50hWj/Gn/tL8TX2tt7TbH0RK7WsjhkD+yGNhhODlHpJ0v9ZA+t6dFaoTLd2f7dUG8Qr6oJAFD/49PUzMmOZIIfS9x5sddz7PpvQksJIUyA1JA+lTx7wSPfqu5Z9alfooYcjN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739223385; c=relaxed/simple;
	bh=lrDM87EalMP0GWePHFKPtuAc2CInBLBdBuI0LXUWGM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NH7IJtFEw65YbYx6IKryNzKCa9MkojA9NiEuV88zAGD6D0bkToQzcQprH3SRLWMXAk8qk4AaZrLDwn/CT93ySQ1/tZ7rjUf9POvXvflfOHg827qFaRCVRPGk1+6XM8A90klk5x6SThJJXd6qoLHX1bI4/9bKxe99P22hBXynTdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rDhnaJj6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43932b9b09aso25637105e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739223381; x=1739828181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laF+WRFcEPhbPigMR+biZf/NV/ZYQNs3dPPw81Y/wsw=;
        b=rDhnaJj6PI5/lkQZPki6MkliMDJwTkENio10GINel/ivmJmPcsh1FektJEbJzWrNz/
         ggr5x3h8fXnDSsl1slFagTi2GOH6EZk1do0NGNqNt3BNLigkDXug19oU7lq2S8n2dzRC
         SVPVYplpQNbLjSDi8RBQuDiAfBh9JzC8cvlucJjxwKdER48pUnObtT2ko5o7ZYnSP54u
         +7eEvfs2I73gr2jPHYD+O+BTtsVy750EmxxOSVNRONPVc1DuwID+jYuWTLAiTzvMP7MX
         RzSVyF/vRgYbInLKijZs7ozle3R8f1T4Oslu+eDjeVBtaiJHP3AS5S0wVhlwD0ezcLtZ
         BMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739223381; x=1739828181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=laF+WRFcEPhbPigMR+biZf/NV/ZYQNs3dPPw81Y/wsw=;
        b=bHJNcEi4yy4KLSjwi0r5PcmYKc80AP1BnC3cuy1IXkazOXQej8keea3GOm5w13VzNz
         BNQeaEhSTJh2VM9LzV0pj7s7tk2GCCNM92FnXxV5aehozd8RGGqZ2LyxMJY6WOJrvXg2
         bTlewT4LCPrVmLwfWTsgO0p3/Opgn2AzZVoj8vvf5hzMFdtUgTsaQlkFF6HLkzmTx9Je
         CTW3O+Vkq8T4+pXlCjzLJeI1YDCYU1uN+p+8PJzNhCu/9uoCxO77tONvmdb0nQidyYuw
         rMnQmrUtMMino42ylGfRcwuI0b5Bw/++0mBZ8c4yoaaxzpuY18v2J4WjV36HuuyJI75G
         044Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2K+IPTHv+oW3d0/jM38+JLLsFUL32h3Ypkn2Y6Sez/JCKgF1HlRC6Ll5DLAJh9QfQMRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzITqqvHdnUcfLNzPrgUE4AVQVnjcC/MkSPpOwE3xBTi4RC2i4L
	Of5sQ5hdbqIzB4sQSLAL7MX+DLfHJdjDcvMnDbBQXgL7x13T0WIndWzcIgbFS0018tTmqdD6uDv
	rNP0=
X-Gm-Gg: ASbGncs4jZ1XNIC63kwKuFYguAaQcRu0Tl7XXHFtnJGCR81koHYsQWBzZT1qMRZeWTa
	qjgn+Ia0zN9i39oyTXZfrmnwOBDtJU+U/hrMe5DIOZhYFlfcyWRicgC7qQBLSgx5OhtROGG350c
	JlxdPhRvwC/i1W6spixvLLYINhsA5n9MqnlMhWkMrQxRQ8AaSrJcDKulFU0sfKPzMO45ghOuTrs
	3OUZwDegnkP+/x2DGY9W7KHDLqp0thlLYRgl2a0N3a2Xu5AjAcYpo0JFcsNh4P3av2+OB/XTE3+
	L8IPFVBnuVwLyOmN
X-Google-Smtp-Source: AGHT+IFgS/HX5A+kH5PAPBrkqn8fBWMnZmlOER5QhwFIE+HweZ3IE1yWLyw44chbTe5o+iil3uYEhQ==
X-Received: by 2002:a05:600c:1c07:b0:436:18d0:aa6e with SMTP id 5b1f17b1804b1-4392497d041mr163575835e9.5.1739223380954;
        Mon, 10 Feb 2025 13:36:20 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm47541515e9.40.2025.02.10.13.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:36:20 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 13/15] RISC-V: KVM: add SBI extension reset callback
Date: Mon, 10 Feb 2025 22:35:46 +0100
Message-ID: <20250210213549.1867704-14-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250210213549.1867704-1-cleger@rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, oonly the STA extension needed a reset function but that's
going to be the case for FWFT as well. Add a reset callback that can be
implemented by SBI extensions.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
 arch/riscv/kvm/vcpu.c                 |  2 +-
 arch/riscv/kvm/vcpu_sbi.c             | 24 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_sta.c         |  3 ++-
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cc33e35cd628..bb93d2995ea2 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -409,7 +409,6 @@ void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
 
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index bcb90757b149..cb68b3a57c8f 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -57,6 +57,7 @@ struct kvm_vcpu_sbi_extension {
 	 */
 	int (*init)(struct kvm_vcpu *vcpu);
 	void (*deinit)(struct kvm_vcpu *vcpu);
+	void (*reset)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -78,6 +79,7 @@ bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 877bcc85c067..542747e2c7f5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -94,7 +94,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfence_tail = 0;
 	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
 
-	kvm_riscv_vcpu_sbi_sta_reset(vcpu);
+	kvm_riscv_vcpu_sbi_reset(vcpu);
 
 	/* Reset the guest CSRs for hotplug usecase */
 	if (loaded)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 44f551143498..f81f06f82650 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -540,3 +540,27 @@ void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
 		ext->deinit(vcpu);
 	}
 }
+
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	int idx, i;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+		idx = entry->ext_idx;
+
+		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
+			continue;
+
+		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED ||
+		    !ext->reset)
+			continue;
+
+		ext->reset(vcpu);
+	}
+}
+
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index 5f35427114c1..cc6cb7c8f0e4 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -16,7 +16,7 @@
 #include <asm/sbi.h>
 #include <asm/uaccess.h>
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
+static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.sta.shmem = INVALID_GPA;
 	vcpu->arch.sta.last_steal = 0;
@@ -156,6 +156,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
 	.extid_end = SBI_EXT_STA,
 	.handler = kvm_sbi_ext_sta_handler,
 	.probe = kvm_sbi_ext_sta_probe,
+	.reset = kvm_riscv_vcpu_sbi_sta_reset,
 };
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
-- 
2.47.2


