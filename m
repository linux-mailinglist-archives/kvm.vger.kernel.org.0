Return-Path: <kvm+bounces-28009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8552991531
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C40C81C218EE
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83E913C8F6;
	Sat,  5 Oct 2024 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LWmN3hXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ADE13BACC
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115250; cv=none; b=eEyCuLJaOCTiVk7MuKXw6l7S+UZ8HqneDo0l3kNOvmqknHDkuy/0ctedUOUcQhHwL4JCbVaCek24/1RbN1JEys4NY21YZ+Fl4qlNgGU4I0jPsRz1LAJ5ymL65o9Ez2dUsbJRDqYPHe6Rvi3PbNj6p2RLfN+iWPrQsDLN+NLfMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115250; c=relaxed/simple;
	bh=yE1Kx4xAasdzYern6qgCDMbQ6t3Ms3GDREOf9fVs0DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ3auMwEv0lshZHtNV+mTfi/7wDYV56+ZDFuFGXyxuS2RMgQaxTrQpOQVuJS1aMvGG6VtB7OCCEom65YHbWehJr5k3VpLTzj903wqLfni31WsCu2QIgcEujGlSfM1OZglfTi823vWkCLB2K5acVrZgta0Ip6fQdtKIAfdbkE0Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LWmN3hXQ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e06acff261so2083438a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115248; x=1728720048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DM/N+JeqYmdY2NXCjdx0WYlyoYAIQjty9vGRP5j+u3c=;
        b=LWmN3hXQntkMzJZbXExEECsX9FXOiE0YIPF5ZuwsK1tegDSK4pTWyrLk3MIhJeN+0V
         yFd8ptAxYdofFFFBOGcYVeHqmag9JRT0TLTP1Vf6kX4SvCiVuXrvujaA3C+Ve+wbLTlN
         0w/3rzES0hKZxyeqfDECUjAaHPpS0TFMyG7WKik1LWsEfSRsXncf6EM0G8aIp7+/uKsx
         RpItBtea03d+08DuZOSsVCJqYTy6eg5ZIMNOIMi2syqK6R6BeYjcnblPaIXtnsKxQYFA
         W2A1ue0/7T3A8pqsK3/3IOAT5kvwKWZgkIzCfERblOmzvUTTXmLKqn1OtXv7vIGtpi2i
         Aq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115248; x=1728720048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DM/N+JeqYmdY2NXCjdx0WYlyoYAIQjty9vGRP5j+u3c=;
        b=rJAbwKuqy3XJ/bc9YeQPz9rFI06yGFxb/tFhitPWsyZUajphMfOQh6DvvV5O7FlQA8
         Rm35xUkrMVseO/I68SspLxHU8jwR7BiFhOqtJOCpsmuIMvyB0d3xJG83j14rGR9syxgv
         E85fQcwYsOpeQvO3WjEmKPZ7eOFpRb4lByK8/CxBANNoKh1zPog6doLQC3D7gN2bmm18
         kXMXMRQz0+mChRFREPhCQiR3SkOQmLRoiNWYZMOcf1F8A2BOcrqxr/jCDBnQJUX5rANZ
         VLWNYFd6kVgnE7Wmk5CGaHUwGXZ2zRnrDjc+r3vNNAFYQ1a2yBw7mFEdA9CteQGaJdRA
         44GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsqZFgdxRLyy+znqVjSK7JV1NErToYLTZaTZlVv9inigwre2bUxACI4DjfTY0XipwTlWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXHetAv9+jExQZ2FR6nmNCtHcA1b6YsmFMcsC4a16eZeq5a8ba
	dTqeBiLeAyQCW61G35Iwj6QvJQjNIJq/irQrwS2IPfb9N26lRDgkQVJORzmjXqE=
X-Google-Smtp-Source: AGHT+IGI+zpaqn3faEdRdE8+EoO4jUPW+w/Mg8yq3mm05z1gf+V8soWztvDLvAWEaG9XJ94CGTRTBg==
X-Received: by 2002:a17:90a:458b:b0:2d3:d09a:630e with SMTP id 98e67ed59e1d1-2e1e6212e23mr6986690a91.1.1728115247905;
        Sat, 05 Oct 2024 01:00:47 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:47 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 4/8] riscv: Add Zcb extension support
Date: Sat,  5 Oct 2024 13:30:20 +0530
Message-ID: <20241005080024.11927-5-apatel@ventanamicro.com>
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

When the Zcb extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 4fe4583..c62d4a3 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -33,6 +33,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zca", KVM_RISCV_ISA_EXT_ZCA},
+	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 40679ef..68fc47c 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -76,6 +76,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zca",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCA],	\
 		    "Disable Zca Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCB],	\
+		    "Disable Zcb Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


