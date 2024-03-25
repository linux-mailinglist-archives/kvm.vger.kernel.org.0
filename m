Return-Path: <kvm+bounces-12596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D2088B1D5
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12CE0B37994
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB054C618;
	Mon, 25 Mar 2024 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="USsZK2vt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AE481DE
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380726; cv=none; b=r1RgEekJiI9ybFTKDDzmIp/U/sYrTwnfFhsGxeRBCvwFdnVslvkBGmzkCVHm9/EzU8kR0WIyniO0knUX3SYWMAo0tlr5YkP2BFlH8ddW+HLCRz2R1Pzb/75WRjoJgBKkJEjEUO2QcshCbXYXH7tb5yAhfAk8gNsBJGtViObWAWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380726; c=relaxed/simple;
	bh=GW5z7MqJ5aLA1CF/5n0v7FHh7UlD/oGdqRRJKML6+Rg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sF4T/+63y+X7mhz+eoxVyj5MR+m31kgM0p/zjZISkqpgmofqG6kRC6Bv0Tt816Iq+Zcu+8xr3gM2HMNeGOyL8CuD9KgSsYhuqqpgFAwQ/2fMtSsEqN8CxowxkK9i7IgVq/g6QLY3yC+56wDbHZ+dvsZ6Nzbw+JRlhX6nLNWWZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=USsZK2vt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e0878b76f3so21699325ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380724; x=1711985524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsnDKpOPK6NSHgg6UVlxEBFTpXYmQ0vw53/Q6mnf+qo=;
        b=USsZK2vtcgjRPlVvns6dKguou8ci2pTSRNYvqbxSxNn6UBjxCxwg4fpgESECNFs5Zw
         xxvTJKqSLKtxi9GdyRGKKVBIXpEK8WhHYBAtfp3GDbaVQJNhohN8iBtAOSbOBr4w29iF
         b8SGPHKFGkZpmJkd6uUc3g+npimPv7UL5APADUHXDoBUBV9VkSLlqfyX3tYPCHZlyK+1
         dvFddYA9XEO3x/fDi9w/gITR2i1G9Z8fvxi44D7j6S5YzY5TpB/eUKQtPOpX854DLt98
         +aXQyDXXg3oAd+7kLraa7vUaTLjtmqBFz3R4lZtpJfyLcVcLjbiVMxU5mLLM/qa7b8fi
         PCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380724; x=1711985524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsnDKpOPK6NSHgg6UVlxEBFTpXYmQ0vw53/Q6mnf+qo=;
        b=ulAhzYa2QNre9ZqexZne/yQAgg0L6FZxMf9XKiH9ZY5U5i45LWndSdgPArCgqzqG33
         g7It2cXlJ9qlWtY4HNrGH9dpLOSrk3+tOW3U7OFTvNnb9rqq5Af2HFnegedc3rS/5VTs
         sqArwJEe/1wTc+VaW1VaC/ENG7pRLOA+4Lgc0koEKVSxcfY/Pe+eKf8TY/cPh5pS9iXV
         PlmtfSNDYHJe57ZOnQr/ECdQiNMXRxUbTaZQ+P4k4QHm9/oDN9kTnFLLGlDgrndAstF8
         a48cwuX0T8k8SQMgQRfoUW4b7RWdgQyTMcHYyNtX9MgRRxG4eEtclI+hsfaMUW6Fs+D+
         WyKw==
X-Forwarded-Encrypted: i=1; AJvYcCVoe1nAQrSCqT86KxMHsoDO19EVpizZ2Ie0Yp2ZQiNTbnMG9+2Qgcf+tjROn1lcdiGb4HlLv671Zl0jYC/L4zzTMP2b
X-Gm-Message-State: AOJu0YwVnHtp/rvLN6E+2RbumLiFBSNaUj46XPvJQ8yNGx4Z+NiwT/Yb
	LbRK2vXKdwYMbaDpVFe9GgEwWBVQCmaLOrVMrbZOfh4FQGnwq5NTfee3gEtJMk4=
X-Google-Smtp-Source: AGHT+IHSbQ6+kvovnIpRkDyDtxvcwtzAc1RLnLaAypxFjW/3T827fUsWrO+zRjaJAb7KnzljJYcfxQ==
X-Received: by 2002:a17:902:d4d0:b0:1dd:df89:5c2 with SMTP id o16-20020a170902d4d000b001dddf8905c2mr10066270plg.22.1711380724452;
        Mon, 25 Mar 2024 08:32:04 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:04 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 03/10] riscv: Add Zbc extension support
Date: Mon, 25 Mar 2024 21:01:34 +0530
Message-Id: <20240325153141.6816-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zbc extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 8485acf..84b6087 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -24,6 +24,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
+	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index d2fc2d4..6d09eee 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -49,6 +49,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
 		    "Disable Zbb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],	\
+		    "Disable Zbc Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
-- 
2.34.1


