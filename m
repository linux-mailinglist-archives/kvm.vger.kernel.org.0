Return-Path: <kvm+bounces-2637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A4EA7FBD81
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AF391C20DFA
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF5E5CD27;
	Tue, 28 Nov 2023 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ave2lSuu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F1127
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:03 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cf89e31773so38022185ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183423; x=1701788223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kbUuA57ruEhi2ahjuA8C/2BffQFp958wQ651hhrhePw=;
        b=ave2lSuuLQFF0CjPlBJU/TkLyIwND+Unhkmvxo6lgUBeE89VmqmlrmcrQwGkJP1ZED
         MZjn3BiifmepmTsvhAnx0w1U02OT/QQrVvmObFXF+Mv4GmXNQpWnJcg867yxq9P4rnKJ
         bVPzubxTh5uZ9n6J33O9zF6PnlR9hkPJnynM3RgnQ58SVRv30ZyU3+xRi7k3upf5TCjV
         WMGPLlv4O8iiqLmSxzSezOwQ/WSa2MCLn2dMcQYKMNu6wA/CsgRd8JaskzpGzNmuxjMZ
         iTbaElTg1BTHxl1PVYYxpKftFuPknQry4IvixtAQX4xNiPc4JXVXp5NSgMAcvjnV0fwd
         fCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183423; x=1701788223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kbUuA57ruEhi2ahjuA8C/2BffQFp958wQ651hhrhePw=;
        b=VHNALWiu1Qikv8k9afhDxlvev6PbLtBwleh4AyUH0IXW8XJWjlpUtkS5j5yYAvM35F
         xW50DJf/+Ok7ZIl6LKOaCJ6feiHS6Rlr+sxHC7/ByyotuvEz+wF0Rx30S2yZnJwiydBj
         WpYgcN0CZA2U5i7lIisQ7kLIPJ2At7h/lB2mqpdQqMXdiXmzmjor+5lIQ1LLOBvNoBwf
         sNvKCIWIFcEdcyrV/tN2xuKsO3g3oX5kBoGoMU6yvEGP75h6+0jaC252UWbz7TLuJuE/
         8CxjUWEtVKKczJ40woqsViMcNmaLFQUBEBEZZAphB37dxZCfVrsnnSYQlTjiStpI/Dhi
         BucA==
X-Gm-Message-State: AOJu0Yzffa1Y6m4HiRDT8ctrdwRiu9D4yrqqbW9Y0VMgKax0q/O/FrOt
	BUomOYCpuQYMMyXEA6rm5KN7ew==
X-Google-Smtp-Source: AGHT+IH+Ebdv/W0b+4+opaX2MitG1Qm7BXPcUPvE32hQyY7M4XQ5KEKJq/an9OAS+JCfWK4gxs+DOQ==
X-Received: by 2002:a17:902:988b:b0:1cf:b130:e9af with SMTP id s11-20020a170902988b00b001cfb130e9afmr10972906plp.20.1701183423144;
        Tue, 28 Nov 2023 06:57:03 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:57:02 -0800 (PST)
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
Subject: [kvmtool PATCH 06/10] riscv: Add Zicsr and Zifencei extension support
Date: Tue, 28 Nov 2023 20:26:24 +0530
Message-Id: <20231128145628.413414-7-apatel@ventanamicro.com>
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

When the Zicsr and Zifencei extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 19786af..a4d54eb 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -27,6 +27,8 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
+	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
+	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
 };
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index af5c4b8..c524771 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -58,6 +58,12 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicntr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
 		    "Disable Zicntr Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicsr",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICSR],	\
+		    "Disable Zicsr Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zifencei",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIFENCEI],	\
+		    "Disable Zifencei Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),			\
-- 
2.34.1


