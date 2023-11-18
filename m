Return-Path: <kvm+bounces-1992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB3B7EFFD9
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6BE0B20970
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080A6171B9;
	Sat, 18 Nov 2023 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="IoWrbD1y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7847F127
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:10 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3b565e35fedso1869704b6e.2
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314150; x=1700918950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Lz6ogHXgHZOdZ5Ib686FzWXhsFd6UPtthB40XrMVnw=;
        b=IoWrbD1yxkD61k7g68tZA7cWoO8hlBj38n8WsdFiB9PRN5C4NiIEXOEc4lWSz0+4fx
         CGNnIaln4IDvOgLWht4v2jQacalTeRYjqWuYeZzPLllNpx5BLEtgDaS57CECITXJfnxV
         YMncE8mGgT6OpEebz42CzkFyam9JOoFwuN9MNb1YKRFJBtNjX9u211bhHzqFugONrauS
         gy/RrQ7cfcRcmgpj21sYWVMZAeRLP00X0zpmWfAzLi93An2Ds16k1TekrRejiiVuEQOH
         H5dtw4FW0hgiDWeRWRbin3YIWlDynXf/DpDAK+AC0OOP+2a/U7hC3D6CSIq4uh8x+L7P
         hPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314150; x=1700918950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Lz6ogHXgHZOdZ5Ib686FzWXhsFd6UPtthB40XrMVnw=;
        b=NTJiil3esqN5JAGokKo5z8AOqmGFAALlLubzcYA6yQNrmpWXWK7zKXNDrYME6D1+Am
         +3CWqgzjFn0ubjsK81LRyxnpEEhIzcw8zB8aExEG407WzjTriBJVgS1ZPmhvRGpcHqbB
         K9mEenbIfekcZHhUJZtN5+3oOprcKQqWhbKRtlDyj34h9GfH069kFVzhfSIQg3irufto
         jTfH+xHaiWA5LRv6kaRAaSOEeldsb47a5hqTN/uzUWkRsXCPasAOtLaL6du1g2xHQqGa
         w79IZAPOyNpkShmLSTwGEg18G/DY3kdCLYgJu6+C42R0bRc8Xr3jz4gUxrrMQXB3NlxC
         ceNw==
X-Gm-Message-State: AOJu0YyZX/ZNfM3cDBhI6+SNVsdglGL4eOqIXhRoYzAGMqiOBaVHue3o
	Zm1GDYmc31IVwetKmb7O6hf9aA==
X-Google-Smtp-Source: AGHT+IEZfB18bg/kahzUSmE4wgJU+L9J1u2AQZlPSv3uG+TwgdNKLDaEUizwi1ayY6Y851td7wiZTw==
X-Received: by 2002:a05:6808:1705:b0:3b5:9965:2bc2 with SMTP id bc5-20020a056808170500b003b599652bc2mr3549571oib.23.1700314149694;
        Sat, 18 Nov 2023 05:29:09 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:09 -0800 (PST)
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
Subject: [kvmtool PATCH v3 2/6] riscv: Add Svnapot extension support
Date: Sat, 18 Nov 2023 18:58:43 +0530
Message-Id: <20231118132847.758785-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Svnapot extension is available expose it to the guest via
device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index df71ed4..2724c6e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
+	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index b0a7e25..863baea 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -34,6 +34,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svinval",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
 		    "Disable Svinval Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svnapot",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVNAPOT],	\
+		    "Disable Svnapot Extension"),			\
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
-- 
2.34.1


