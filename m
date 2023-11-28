Return-Path: <kvm+bounces-2635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 253CA7FBD7F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5419281298
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78915CD0E;
	Tue, 28 Nov 2023 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="MREn/27x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF14510C1
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:54 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cfc2d03b3aso19333565ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183414; x=1701788214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0zuXKCmA/fCwgVtEEggMd6l7hk0jdC/LhoPoNgdg+I=;
        b=MREn/27xkqfj8iFU7xESUbYI4OKjPrxXq4CP3i9nF5F908CF72kotDwj+wHkT03irI
         vkSp4/7wFMiNbrDlHn8yvFnfe8bPb+4dXAjzp/GSWxmsrmhr0zHcy/fBOteY5haf0lcb
         x3L5X2o0Qw72k7kdmFWAODSTY5ImbenJJ5h2hnwA7uwFzgw1Holb+ClEAlr8GdKZQYNx
         MopptGtYln6iH8PQNEKrK55q9dMUaqOZ6CAZ/98O1oZzxq5DLf6LLvyHeAXbV/CP5z8C
         5oTkM0CV3E25rqZwtobZwy60/8w9YOlrCNTNR692xbsW1ydaUMRPtvPodZfo062VMhuT
         ZwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183414; x=1701788214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0zuXKCmA/fCwgVtEEggMd6l7hk0jdC/LhoPoNgdg+I=;
        b=astqgqXnKtdcPSbDIGAP+oqGvbHCwkGTMQ4a6S56fngsDHy7RFoRmFOZs/XMaw6iYY
         AMbLKuxzjDBQmqsMsXFLraO/W/bVKAzyziUiUL9GXNF0Bwlo3ipxh7U0jPQzmvbT7OeV
         DwPcMm7QiKPS1VWuoe9+2ix+xjgxBmqd789SRHc5ElW3xXXcnel7DlqC6WNdKov18wtb
         36e24z34bA0kjLeVRx6MITq3MHp7wjQ9U/zZXEVyGbcFrGhDoiNm5ppPDIghGrf386bW
         vo6J+eqeYYoaUyo44aPB+/Lrk3Sn6J7ivp1ugrfWeC91EhUzvHYP0dylyBRxFwmcmD5T
         meXg==
X-Gm-Message-State: AOJu0Yw+4R5AdIHfUIMJBkvH2WaiPjVu4cRhaQyzBJUuZ0euccX8LLXV
	pfXKyK5kNslV2I5s++vIMN/I8w==
X-Google-Smtp-Source: AGHT+IFMvTCBlHbh81wYN3s3G7OgL1J0aZlGcfQICX60Aedc8bG47talciVsG9wOml2AbCSK9ZGjpg==
X-Received: by 2002:a17:902:ce8a:b0:1cf:df4f:30d9 with SMTP id f10-20020a170902ce8a00b001cfdf4f30d9mr6152725plg.29.1701183414313;
        Tue, 28 Nov 2023 06:56:54 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:53 -0800 (PST)
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
Subject: [kvmtool PATCH 04/10] riscv: Add Zba and Zbs extension support
Date: Tue, 28 Nov 2023 20:26:22 +0530
Message-Id: <20231128145628.413414-5-apatel@ventanamicro.com>
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

When the Zba and Zbs extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 230d1f8..cfe4678 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -21,7 +21,9 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
+	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 863baea..978037a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -40,9 +40,15 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zba",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBA],	\
+		    "Disable Zba Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zbb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
 		    "Disable Zbb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbs",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
+		    "Disable Zbs Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
-- 
2.34.1


