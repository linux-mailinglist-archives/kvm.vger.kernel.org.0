Return-Path: <kvm+bounces-46665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE9FAB8092
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2448A7B354D
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAE829826C;
	Thu, 15 May 2025 08:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ssrxfhF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B69295D89
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297441; cv=none; b=nWOSm7z6SQLu92PKJo5po6WAF/aB4bmrAjGIF+kIaT+kVy9NcYJ6hcbf+R11THn7iQ4/tXTf/riDlmyggaqlVYgjMTlF1TNGOVyXDaxeOrKVcE0WyGGvov1IYtWLsOYZlbuD7nx7kvorCAcnfPhhqqmow1cQ5rz7qWo5iNJ416M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297441; c=relaxed/simple;
	bh=3+zyVKqir6lmor6lBqgW/Ph3RSN0Yf9mQOjdau7kAZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8yjEVl4ENpOnlpjREBBGu2GWR3taHkBLrOcc6dZadm1vOGKo3Ane5cQK9UO42u6iSK0GuKsAl45auIji4tu+y72IBFR5BrDD0tprYnWxPSShpE6Yq3/896FX9tkL2W0UBZM59W4MnYpH2lAcLarr6U5GOQF5O5TDn5U7gezVrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ssrxfhF5; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so6367275e9.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297437; x=1747902237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Pxqge87zPhTrwo0PySrFAhV25ryh/dqXEpJhdjy2V4=;
        b=ssrxfhF5ah6odZizln5pR782/IP2X3nIaWIUcvsyzukTT7hE5f/y6QQth10LGsSxBY
         JMMPtpq+IfUjwKyv1WWSYckPnboQqTiD3Ocp+I6MFR0joJblcVjNfhyapXNvax5Udwpq
         yTgigFxm0INxHB3mqaWMZ6PBNdafhW8FDlXuPTfXF0h54d/QcnEc+NgkAZTYBXAX7n4O
         Feba0HG/rq5+Wc38OwL+FAuTOBD8f7LIObaSccW0adjlfoNiAHc4dq7GwT6HQyYzIKV4
         O5yrlF+mVOQ0GmEDqOp5Nn9ssSNwLOVOFrkG+y4TuVVcLr/UkZ46Eo3v1JMFzb/dSqEZ
         MCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297437; x=1747902237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Pxqge87zPhTrwo0PySrFAhV25ryh/dqXEpJhdjy2V4=;
        b=JA14yPkVC7lYE8XqzkjhEfvR/TwOv7PrbtTKrNmuKZB1nbtX0+Fk9GOo1msneJ+MUI
         Befv1S9UUvhin7NQ1V1JITxn5pWLIYr2jMZAvcpjGRVd+2ejjEmF2ipPH5/nb3NxDhNy
         gcd9hvfpl7yBD2eHjdIxqM1wYA7hOGRmtUXj6OMrgOJkVgG1gm4uGy4ANfIxBRQ+lmdA
         /kpGWrff0W+sdyqolWjWWD67HWtNWDua2zQfGQ6DtsHXDJ6rSipPGb88pxl4y5ojoQIe
         ysbWyS5dib0PUEjqaDtt7xkdISAVz3QIMHCddFbhjyJSSTXEw/YSbDSuEH6O+OBrPWY1
         KJAA==
X-Forwarded-Encrypted: i=1; AJvYcCUS/vInh9UqvA4a7QIsDHM2NoTLvoDDZqlOVfYLgmNxLD0r6mBCwoQZU6IV1fgs1Pa2Kwk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv0MdEmVyZx/615U/tfCd4AhEaQu6QCPh//r+t4lEgZ/v2coQS
	pZFEhbXg8eFbmVkLefxpJYPVGP88vKS1OIDaZTIeWigAiawk3W+8WyEff3YhI4E=
X-Gm-Gg: ASbGncuW8jJrV5StVHciPB+7mzsClLIFP+Yl471ktltBbRnZ0b+uROL9hbZON1Ludhd
	VDorUk5FHWv5y7tojJ0H5t1X9tX8tj8dF36vGiqHBc8bcB9c5LazxUVbPmhMOwB2lwFpafu/1Uv
	bdAnOv37DYc/IeR8kgBLA+H7Bi1osya8+Xp9LH+ZBYFhGxFLdb74DXXLi66LrjiA6/IX/R1b/wE
	207i5ciDjrRg7OXQ02sCL81pwpj27gS3f45aOX2pqRE/HrWQzNIdPx/+WR5j1cPoaS3+Jp/hOKa
	I85Z4olxanlW04iim4MlvezErWN5BS2QQfYLs+rkFg+rTDQntauZhxNeYncLUQ==
X-Google-Smtp-Source: AGHT+IEupGcBKUaQtXkFnFukO6A8UdisKBYtlExsocwvYgZ1EXZBcCmelFzxOJQp2aJDmAYM6taW7Q==
X-Received: by 2002:a05:600c:4e11:b0:441:b5cb:4f94 with SMTP id 5b1f17b1804b1-442f20baefamr66539545e9.5.1747297436910;
        Thu, 15 May 2025 01:23:56 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:56 -0700 (PDT)
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
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v7 11/14] RISC-V: KVM: add SBI extension init()/deinit() functions
Date: Thu, 15 May 2025 10:22:12 +0200
Message-ID: <20250515082217.433227-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The FWFT SBI extension will need to dynamically allocate memory and do
init time specific initialization. Add an init/deinit callbacks that
allows to do so.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
 arch/riscv/kvm/vcpu.c                 |  2 ++
 arch/riscv/kvm/vcpu_sbi.c             | 26 ++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 4ed6203cdd30..bcb90757b149 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
 
 	/* Extension specific probe function */
 	unsigned long (*probe)(struct kvm_vcpu *vcpu);
+
+	/*
+	 * Init/deinit function called once during VCPU init/destroy. These
+	 * might be use if the SBI extensions need to allocate or do specific
+	 * init time only configuration.
+	 */
+	int (*init)(struct kvm_vcpu *vcpu);
+	void (*deinit)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 02635bac91f1..2259717e3b89 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -187,6 +187,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_sbi_deinit(vcpu);
+
 	/* Cleanup VCPU AIA context */
 	kvm_riscv_vcpu_aia_deinit(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..3139f171c20f 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -508,5 +508,31 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
+
+		if (ext->init && ext->init(vcpu) != 0)
+			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+	}
+}
+
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
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
+		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
+		    !ext->deinit)
+			continue;
+
+		ext->deinit(vcpu);
 	}
 }
-- 
2.49.0


