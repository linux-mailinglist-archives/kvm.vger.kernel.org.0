Return-Path: <kvm+bounces-36657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B301FA1D690
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D97D63A2112
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1FB1FF7C0;
	Mon, 27 Jan 2025 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WbJLGWdn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4F1FF61A
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984299; cv=none; b=aEJpLWDDrNfCFCjw7vDHyTE9xA4+IrujCNpmQzvMAmJjlb+Y6UDQi9/4EzE6wmRTM3m7ODS4HalCz/tGdkVcZlQmB1zxGRoEX+QajXFZ/6hwkdxBuyR1vMy6IG46Xpsxs1XABwG5QBHrq4yT/iNaSuj3ul3Yg5WbTI/NcMHIE4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984299; c=relaxed/simple;
	bh=z/kfBBw+2jXafNxgpAndKh+K1vxDTl8pcSkH2vAm3/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7OaSdyjDaWnw5LyFls3H9R8V1DseraSZCi9HoXRfe7b1fQgi+WCNyK/Sfim2NrWVp9GdXDyeTUVRgcTL38013dbDNm8JPZ2HtTWO8mr7SWkn7pHZ2cVFnkKXcVcauz62u++jYTBk1nwGfoJgy9IdJRIm2tkYYKT6WzOa6GpYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WbJLGWdn; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21680814d42so70176315ad.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984298; x=1738589098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyFuZqIvuoPsi26fo27XHmOKoN8l213UJXn990xuuSs=;
        b=WbJLGWdnMyx3cMvUKGB05TAkcB59AYTwU0+MMRFnw5PDc8g7MJG0DipO6Vm56nLatw
         NI+eefYsO2D83FNxuYUfnfWRPXxwHQKCtZiLu6GExASAslNkGeQK/xvDa2nK6l5/GGBk
         LgHbRy5Q8m3mEeo4jk+jETJkIpgeK0j+Xg7Fsu5YYjW37idlT/ULmKeIuj0bxmwKxjLv
         SHkBhFrGspC/RYenJZ+aCgHrB0oECm5UbXdLx9+mV4UNmjCw9ZlsDIIwu8vhxWbSYBcp
         tNyysVJd6iCm70da2puuwI8KPDC02dIrea/lERK5P21WY3vIiwt/lBe1HzXUHXTECW35
         zf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984298; x=1738589098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyFuZqIvuoPsi26fo27XHmOKoN8l213UJXn990xuuSs=;
        b=H3k6si7Hwt9w/J6MakGW8JHxsC+DYdYtuReFrFOwYcvfeJX3z6nowhJqv9oiY7KRi6
         6aOZwMel2lELNDCy6wfXPi98RGOjxlMLymMcz8uYPf+vVCi5Cc0zM/qxlHrnbilTOBFc
         3ZqaGycuhUsyoztr/f3TRU4Kd5tcZMCBNvjkq62dBAu0GrQBrCnVhzMjYfuOZuPDa8UV
         eYScdwgwfG8FQAEE0aENN9Tr60ZpjEQvfgZHVZmhNMXiGALXPE/m9YM14ddNUaHsMw0N
         5hT96S9bg+KPC92RJumFqxe50XgJ3ry/0aiSVTBPpV1+WBNsfq+RocnLB7hP3PtLBeh2
         g1xQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0rWq8+RY5WVXh7wAOeA9NeN76oGyS6+MM6vBkR/nGngcaVcKdLefGHTUZ5lBzk6myR7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwluLRlU1z1PwCASlh12zsvCcX/N4YNziAUR+eKmKKHaqCfa4yj
	nh0KOAdPuMuWfPscDr0zN1yruRaNVEkIs81HS8yW48t8WrgnhGgtx2bsmFTkpe4=
X-Gm-Gg: ASbGnct7intgYYE4v/+dLCycVmo7b0eBZA8M7LiWDmQ7ban6xMILmSYoF0bMIRLyxJ1
	kBmym97pxEnscUxHQ2gzAwBCo6rit/itHUzNtwDCx/vZRjZW5mMRpyWh39o79gJ3nlJfzfcqKyJ
	t+ZQlUSfy1mEOA9SuduDWyozhMsZ4eMH2QHM4xCFQbsRdwwldPThiGwj6oa+ZR3lqZOX6jE7zx5
	uGFQYAwb5xOb7TQW3v8FGEEbjDdfHb2v9Hp8U5YDspYKuR4MlvKSAVPi4J6fLSDB36rOgYG84+b
	lQi6OUqugWJnUwIWJBYJsuJz42oEwfgvCJVmQKTTgkJG
X-Google-Smtp-Source: AGHT+IGOPKbsTzAU6PPUvasAKPUIG/JEo/1wHILrRnaRRTp6n6q6iQVr30ZLF0hpFh9nTgyji8x31Q==
X-Received: by 2002:a05:6a21:7882:b0:1e0:ce71:48e0 with SMTP id adf61e73a8af0-1eb215fb27cmr62751726637.39.1737984297604;
        Mon, 27 Jan 2025 05:24:57 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:24:57 -0800 (PST)
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
Subject: [kvmtool PATCH 4/6] riscv: Add Svadu extension support
Date: Mon, 27 Jan 2025 18:54:22 +0530
Message-ID: <20250127132424.339957-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250127132424.339957-1-apatel@ventanamicro.com>
References: <20250127132424.339957-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Svadu extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index cf0c036..7f774f8 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -21,6 +21,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svade", KVM_RISCV_ISA_EXT_SVADE},
+	{"svadu", KVM_RISCV_ISA_EXT_SVADU},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 5389dff..e3eeb84 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -40,6 +40,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svade",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVADE],	\
 		    "Disable Svade Extension"),				\
+	OPT_BOOLEAN('\0', "disable-svadu",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVADU],	\
+		    "Disable Svadu Extension"),				\
 	OPT_BOOLEAN('\0', "disable-svinval",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
 		    "Disable Svinval Extension"),			\
-- 
2.43.0


