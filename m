Return-Path: <kvm+bounces-2639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D247E7FBD83
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BCD4B22552
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4BD5CD17;
	Tue, 28 Nov 2023 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EIvAmC+q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C81111
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:12 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5aa481d53e5so3981914a12.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183432; x=1701788232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GaZLArS4uEWR7hS0+LMZr4tSCm8f/wfXv0BlFAD2A4=;
        b=EIvAmC+qvAEcJdIyQxIuygqOI/iLrZilV7UY33H+Xa7jaJiXYRkLAkVkbFdX3bwND+
         A8b5NeMj+c+YsYJ98bgoxth4bsod1SdC0AHEstbv0I+kKoo3gtqj9RJPmYaGdYQx1w8L
         kkZ4zdIKm0U7LndEFEooa99p5lgBfxIM0xasAPBtKA0vycD1Wq3/aL1fZ9ewMrsVqKAQ
         yNSrm7J7PiE73GoIoPDqcCpt81hkgPykFb1L5Y8wFmFYVBCBX/3dD5qGVpNwX0NJ8P3W
         kWt+pJmGo+jCIk9Ehqnxv3kvpTb9ct8G8IhIk0xV1fvoZYSQVTFyrI146nmiIuZGmXi5
         rU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183432; x=1701788232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GaZLArS4uEWR7hS0+LMZr4tSCm8f/wfXv0BlFAD2A4=;
        b=B0tLDpnd1SwMHmXF0i9Us2TxH1sNOTvjeJj6tvBgrYn/x0TJ3JWWy5HZc3IMKnR3MB
         HkM7mSMp71kw/tO9CSyes5Zu0gdkPfQV/i3/9PE7qAE+jpaEAcRDYwVJsC6upLlIOqTH
         QhDXOghd1pxc+bNPS/aDRTy2sFJHkcq3+hzNosFzMQXn8dUOGWGvV88AHCgwtEncr9JD
         ZSc8NfjUPGKIOHiqIC59/ms4fkXol56tW+WRQhSRlh9EKB38CnRPgNDiI7cn9iBhP7kP
         SOr+Gxzi2TT85WflPWZ0T1qdVQUFPAbAr0I7BXBJ/VlePJmqZZMjt8noYrVYSxdFR52j
         YA0A==
X-Gm-Message-State: AOJu0YyBVku/2GO0rp4NfOOafoB8n1yj7j6XpPv4YoNp0YS312XUYi3P
	u45m+YXJoe1hwa0SIqTGFuaqyw==
X-Google-Smtp-Source: AGHT+IG7bgWXf62BmYjAlTTPfyIqGJJN77eb7QgJcUohI3jWVxZ4PVOdEsRVUkiPfOmmG6tfo2UwwQ==
X-Received: by 2002:a17:90b:390e:b0:285:da91:69e8 with SMTP id ob14-20020a17090b390e00b00285da9169e8mr7059326pjb.47.1701183431732;
        Tue, 28 Nov 2023 06:57:11 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:57:11 -0800 (PST)
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
Subject: [kvmtool PATCH 08/10] riscv: Add Zicond extension support
Date: Tue, 28 Nov 2023 20:26:26 +0530
Message-Id: <20231128145628.413414-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zicond extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 0fe0f0b..1124fa1 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -28,6 +28,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
+	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
 	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 49eb3e6..48d0770 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -61,6 +61,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicntr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
 		    "Disable Zicntr Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicond",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICOND],	\
+		    "Disable Zicond Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicsr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICSR],	\
 		    "Disable Zicsr Extension"),				\
-- 
2.34.1


