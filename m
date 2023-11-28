Return-Path: <kvm+bounces-2636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0387FBD80
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6D71B22096
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642245CD20;
	Tue, 28 Nov 2023 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nFLP5A7l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F68111
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:59 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cfb3ee8bc7so27950605ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183418; x=1701788218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdili8BtTS1M3baU+hZ81RVV3W9O2cLJnQYpN2vMBOw=;
        b=nFLP5A7lte2k7NeqbrSkEk+a5NTsRJ9NLb8nKTohITc+iQhd/nm3ERn291YxyMgj7i
         RXfRDKnMm9X/3xArNKXnc9LjZ1ZkqXBytECVIwGg/5qluKFNZFx21ZTRG8HsLpb1TjsP
         +9pZWGa8d7plZoIwbwqAhdTFReymfkrhk6sv+ZkeYJ7Wbdcq2rYDjdJytlEftqS05ayO
         b6DKiqIzRbeuRfrW0ngeke/9KBxCXGQ7tKk+acKqBSbGuFYKGJhCdTReTaH5g7gAOJlC
         FPtjy2FQ/UEqlsNjxugrUTNFAOn7zEBeZzKHtU4TtcbFDymdSScv4VKIrMQ6DCgl9cXZ
         jL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183418; x=1701788218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tdili8BtTS1M3baU+hZ81RVV3W9O2cLJnQYpN2vMBOw=;
        b=YGruW4jses8QpDpA8lr45zMP8a5hHxIqxBkqHeS6bsu1x7WW7dTEJmtA6HLZMO7xo4
         dIKLAZB0b4RKgD76/Ky0jsTVNA5uJO99VaSq3fdTzywo7hPV8UeqN1VhwDdTtB2+pYQ9
         OGeUbWHnf1LM8P5pjryWFjOSmHQ8FrDT9wjqTuzEE9zUH2wDNFgdZmW4EaWlE9zr5xZ6
         qqX3HmX+Gme3BEqrOcmCEHaR3ntzWAv/+D4nS7NLrgdAoYTrYJWAijrezsWbycVHxpfC
         3UsUo8BTDu7nrYEU3G+OXi6lDXMsVIpVq619z/okNHxnGQa1trsxuUI3YuCoFJHvCuN8
         +HrQ==
X-Gm-Message-State: AOJu0YzWDhOythvEzsWqQQd13D2SWdaK1w5jL114RCg3WyUrzikg9+EJ
	sCeJHM3euvcI1PakqmtzJ66X/g==
X-Google-Smtp-Source: AGHT+IHtOsF59+XMv3bPjl1d2IV98iItNDJlb3ZNbUY8c97idQ/4fFYABVJErS8fwmJJiAW/nQHLiw==
X-Received: by 2002:a17:902:bf02:b0:1cf:ca03:a221 with SMTP id bi2-20020a170902bf0200b001cfca03a221mr8585431plb.24.1701183418467;
        Tue, 28 Nov 2023 06:56:58 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:58 -0800 (PST)
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
Subject: [kvmtool PATCH 05/10] riscv: Add Zicntr and Zihpm extension support
Date: Tue, 28 Nov 2023 20:26:23 +0530
Message-Id: <20231128145628.413414-6-apatel@ventanamicro.com>
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

When the Zicntr and Zihpm extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index cfe4678..19786af 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -26,7 +26,9 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
+	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 978037a..af5c4b8 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -55,9 +55,15 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicboz",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
 		    "Disable Zicboz Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicntr",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
+		    "Disable Zicntr Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zihpm",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],	\
+		    "Disable Zihpm Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
 		    "Disable SBI Legacy Extensions"),			\
-- 
2.34.1


