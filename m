Return-Path: <kvm+bounces-44402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEB6A9DA49
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A4589A272B
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013CC227EB2;
	Sat, 26 Apr 2025 11:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kjLB7VTu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E41E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665450; cv=none; b=Tj/8LhYJ/uygxD8wN7Q+MXY+cQjcGc1pw1klQLQV2bvzx5CNpoAFv/kA68B4fMuMzMuDjOEcV53w772ybIVnNRNv4whfhvIDKyPWwGKuqjevNF2M64vXxL/dMYxDlakEDmm60p4/JM7J/TH3HeSU1I+hzxVzAW8Rar/BHfzugI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665450; c=relaxed/simple;
	bh=WloU9S+m6ZvHvTWt9Lg6uhA5IHMHZWUmy1t294mGXuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6cFGzEL72zegc9Cy8QNWL1TyeCIbCk+KR9qSmwNNTYtECxxvFwIwPTilIsE4vktT6vLbw4SpNvBU2sCcnWpJE4k0GR2QhrdqcV7XB4eTeo9mDbV/Nx72RTPcyEw8OvbxCyrKJtQf3LbhkEOQIL9jPFtwxFWTogU9YOoJaLkozM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kjLB7VTu; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223fb0f619dso35600555ad.1
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665448; x=1746270248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yq4t7UW6LQy8HVZqyavJ2lszswgStVhP6cQHkrVx0B4=;
        b=kjLB7VTusrZV8IRI71sNNKOeH2/qbH3iaDlwrq9zZ1ydlMPHbaWS7mhxbw5PbEBDQ5
         DWt20SSnb03fuWmVBOFDAybIDZV/DqBSh3mj4RCZ52IC4ug99auCStiVNNrNs0Pi7eYZ
         ulxfn/6KN/CrVAx+9oXt8U5iPWcjX2rFAGwMEy/SNUmVNusRb0Y1JNHw6WvhndxXrYyf
         f5zFErlbNRqAoQ4FMac0RFbGP2Gl8vGngaq1cv5eHkaqYq2++E0ywBPsXGkzAS+dq1Vh
         6s8lcPYALZKq06d4JH5P383QNYulepLxWmOzNFlC0suBViIX49aFU8FZoibKZ+9+iv8r
         Il1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665448; x=1746270248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yq4t7UW6LQy8HVZqyavJ2lszswgStVhP6cQHkrVx0B4=;
        b=E7BUAFNcY9ifG/8+SHXnhELed86vCmjLUuIGVReHrVGlQGBAAOvwSgOn7at8jnGFN2
         E9WREJEC/EdB07YCG6PM+aSbQ91glAQP4IJwG60zURFmy3+OqC6cN01fOSEFjo1YBRME
         Q7IWHEEOQ/fHdbAB0Twl6YdlDsbf6M1AtfS3n9o1ShD4Zc5jpQ2VT3U8IhIqO9s1zhn/
         GYSCB8e6JZ9ZlzU8dJA/RaTGMuZnDYeGgfqmsWY0TCIXlYgpB46BlksGkYhRTfrHYzED
         VrmMl57pvMaf8GkDEKRwplFOOpMG9OuwKxj+p2gcp1ReKjn3krAzrIz+IriU5RKRkVHp
         XYkw==
X-Forwarded-Encrypted: i=1; AJvYcCWtEjElYAIXzJrgqJZ6TeG7GAl4X31S0AtywNvucEvkdAvm2GzxUV2lCL9Nq8SUrx8ldv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXFn2rgGyHmaj0uDEQ7bxmSHpwTOT5uX4ntDBhTRwtzhf6RjGi
	+9NCLOVsKaZu7jRsc7+2ONAhi2Zql4A0/DPIQwECGsV61OWnqjxV2Y2KSg7c4Ak=
X-Gm-Gg: ASbGnct3iF7Qer0MHXHim3+HIc0cMCw215GaMg7rZmqlYy7hfOpJHswg5p9fZS8NBc2
	XKV6ZaX7ftP9ecJczzUtxQGx4MdEZGRU+BMy+Xh24nAdwEbpoQdz0GAbUZLV2gueFV1968eAToy
	O4xsNb+7DD5pJSmpKdHTwrV0yvYL8TBmN7UyWVhilUruoIhqyvKtH1IuGHIS7ZDDoqXbqGzX1cl
	MabyySz/g7MLWdqGN971TH4rGFpGtfSd4lT/3U+XuokfN+gwDtq6FZ9CMOI+YE2P+btZcQykMV4
	bt2EZOxO40hsfvPFgnM51i8rOfkirymQZlzhLrAX90ZNGdf2cFX4Lu/mMEC7Rr3neis/hrd5Bdr
	SnKM7
X-Google-Smtp-Source: AGHT+IGDnh0quYRpDy7nLE2ncCbxfljnWL5zLXiKBflQXpcBpFJnbx3+2K5rT8sdaHoyn3k+2zKXrw==
X-Received: by 2002:a17:902:cf11:b0:229:1717:8826 with SMTP id d9443c01a7336-22dbf5fd209mr87029915ad.28.1745665447909;
        Sat, 26 Apr 2025 04:04:07 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:07 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 02/10] riscv: Add Svvptc extension support
Date: Sat, 26 Apr 2025 16:33:39 +0530
Message-ID: <20250426110348.338114-3-apatel@ventanamicro.com>
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

When the Svvptc extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 03113cc..c1e688d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -27,6 +27,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e56610b..ae01e14 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -58,6 +58,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svvptc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
+		    "Disable Svvptc Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0


