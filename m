Return-Path: <kvm+bounces-28008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F0B991530
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03AD8B22AE6
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE1113C8E8;
	Sat,  5 Oct 2024 08:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="becPqDEy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558C113BACC
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115246; cv=none; b=LaUuOvw4L9a/PpcBeXZe+3h0p0mLxpRPRTLEwI98NHwvsqxytWDCnh8FODH/kX3ejZ+rVNL9W2IkZHcYbk0YdrYktoXi+wzhC9tieP60ZoLnetmansZHki5uOkJp///dQ6v+r+lmsqVM1KdJwPQ13Ga5HrLKwUL0E78BKzPHPL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115246; c=relaxed/simple;
	bh=XSqULW5lX/44tcrVgEul/UFTu+7LqRrG83usGSEiWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG4OD46j0eq2/Y0UnxMhlgg3Ln3hD91NxgvK47DHtY1TWZQVvN0ILhaqoDQ5cpMDAD9PapZ3R/c1Lm6OnvF0U+dDLUMdGPSVz5axKCzDTzFe3dR1XmnB2m2kG64zdA/YXS3z+C90YNGAGD7DkAy6UAPvDTCw6DiDJTzu+mSo0k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=becPqDEy; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e075ceebdaso2155334a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115244; x=1728720044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQsf+jR6aG4NjI4xejRTeVTRkVyoQSxLnCUJFtnhGtw=;
        b=becPqDEyY7pgWQ/vwWRkf29hdAqgk0j1hQxov8z94ULYyuNxDkGTW9hbW9kJNhzgJe
         DCoXME+vMU2w80r3JToZnsn+7KdjB4oUNsLU73f8XZk5lPsz5usKM5AQ0m0PRQoLry0e
         jZ5A+98hrt1yJgt8qK+aJ2oZtmCfqQ2kdZBejPs99vc48j26dz26QEV5NrqUBJQA0krU
         ydPImICnYXBdUhIr5pnLWjZ4052gEqvIvbq5CmikSjTQNJsP1mv7ucTHh8VsvgFUhbC0
         t9ngncW3TdwtRVJ46L46AHt2iw9VUJX6iDefU3m0aAJ9A0abblZsXo+rQQPvspVHAeU7
         L1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115244; x=1728720044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQsf+jR6aG4NjI4xejRTeVTRkVyoQSxLnCUJFtnhGtw=;
        b=W1o2Kl0geh92NV4anmKofb2akt6BlrVAOoQUajGC740h9pX7Guq49N2qMUpKnmcK10
         lutUNqgtagiU4zXUVJNUSSCBsHQkHWzW+MX/Jkmpvix4QY4omzJvb7+GUmB0NdGnkxn5
         8r84+z3uAVQcS7mqbo5+xbPvBZPW81vh1VhUfECPnaU6t/ruKK2dd3h6MOKtOfF5QgJH
         CNDsOHkA8tyPQPzYKwAoE1NQteS77o77udH9YPdstCVjivUe5KFDy4kPQd8IGWnlLyTC
         taLA61Zg1ijfZGXHUJzZ8Vc6g0Cg1jMy+O8DezoogokSprGj2Ph30ofxHTxjNLCycY6B
         OyQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzg1dDFkbO2vZGLFOX8TKhsvWqaksDpFC+fxCLFUti2kl6joe90tsCVbqViSDPCZcQ6P4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrz4H8d4V2OjYU6jN9JpStS+i/iE4UEHhAGRr+CMonBpJGi51I
	eeDY3FI3J48xfWtABrMVtMFba0LmomGs46hNoj7SczWFhhPRZPOIHwRR94ljGh4=
X-Google-Smtp-Source: AGHT+IGdz7RXo2myL3SxDLY6yZr6Hkugoz+QUjnFI/C6nrX2W1ljAdcvfo02FUviIgHA+yyHeYhQgw==
X-Received: by 2002:a17:90a:2e89:b0:2e0:8e36:128 with SMTP id 98e67ed59e1d1-2e1e620f811mr6961515a91.5.1728115244474;
        Sat, 05 Oct 2024 01:00:44 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:44 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 3/8] riscv: Add Zca extension support
Date: Sat,  5 Oct 2024 13:30:19 +0530
Message-ID: <20241005080024.11927-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
References: <20241005080024.11927-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zca extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 9d0c038..4fe4583 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -32,6 +32,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zca", KVM_RISCV_ISA_EXT_ZCA},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 0b79d62..40679ef 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -73,6 +73,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zca",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCA],	\
+		    "Disable Zca Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


