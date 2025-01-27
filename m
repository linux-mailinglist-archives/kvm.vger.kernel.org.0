Return-Path: <kvm+bounces-36658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA49EA1D691
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C613218869C8
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABE61FF7C9;
	Mon, 27 Jan 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="it4HOwyA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73EB1FF7CD
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984305; cv=none; b=GeOiF2HieqNbNY8IAKFgFcnU4a2y1KM69yOGYCJ3uB2Y4vQ39uiCwjxIsGM7I6VfXCYJXRB4uLh6AQg3BSeOTnpZiNin+A/nd7Ah+qEkxllLunbkAcXwMHRfvXtlNBHQjx+O1ygjPQkebGugoitgQ6RwU93XMFdKhFwLiVSZkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984305; c=relaxed/simple;
	bh=CRdrlZIerYegGD5hlJpRRRflBCOD7OjiD++VqrxhuNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjOkUNL9vPchhQiP6Nc7cAJSSTwhHEAirZdN/vVLkJuLgCSaIXycQZwf8MyR9z9m5IKwAbIkIv8I7n/Lxyo+ofoDWsoNQToYOvJUaFbIqNdcct76ltDPYPvfbD23gBWGWC2aRbBfUCCfQXayw9Sg6G22PWZtzuS/hJH9G+9lAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=it4HOwyA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2166651f752so86300235ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984303; x=1738589103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClVUDaF5nKQfJ2TSW+emY+qFs9FRjC0yOn/dakK+/xw=;
        b=it4HOwyAdoqpxehoGjwbPMMGs52/6aDRvP8h7mu6P30gubQ4vJAl5mWiix2/rF6Bja
         yPkrmkxILNg1rWDHHFk4of00L5SlPD+CYDsQJBsXVpMmkXOzSFwKT/6mMDOw6t38DCaW
         yfdF66abQFKcFvqELeRmeiLaO+bisifOXnmQAQsIQm2zahnEJ9SgSsrBiAGQuY0qHqqs
         ypGQPv3EQtdImQVqRke17VNsiJ/gXDmfad0vDXJReO9erAAEawP6757qRk3KxsofAZrI
         Mze9dUT3vPPFg+NIdjVjtxEYn5JOmwo/B1wspRsr3lAIItLZL929ysG2cKMs+IE/YLAn
         A3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984303; x=1738589103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ClVUDaF5nKQfJ2TSW+emY+qFs9FRjC0yOn/dakK+/xw=;
        b=bOhKinaMv5qEQMiPyHyCZ5V5Pr4oE1gClfk62nnpLAZAwLoO4Pn57I/xrznAyWBR+O
         U7FNitrwn55LSKQp/xLFbr608+OJAZzecD6SbLOczNvCtXdKUGcJZBBP6nQajpq9bFem
         SWo7j8jL7Jo61IxojfsFN8tpfpz1daSC5khm5Q7EJfHpUYr2/3gCu/RbE3VmPXPoRJS4
         VLOxZwZAIoXXhr8cWiU7BIE5/YGdUwRh2ERygv8YjmbGRQEmhxgOLaCD5BZP9X64MRO0
         Oh+RiW0appw9ermo4ShQwWFOS3IQw9NPqSlZHel9pdf5DW+tcwVUj6025XkQ89KR57yK
         GKJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSD00GnbhTevNlhpsmuaFtxmrmUWS1oU9YxVmsi1Q7rwE/k0bUvieNNmPWer53UajF5jc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQHEiutGvBQxiSlQZCaTw/Scib1eB+LDROdffTGkIJNVaD+4vi
	iSz0DqqRekmy729CKCWFw81ecM6crSXIBMqh3fu4qTo6XTMKsh/S79ZMhoWRcz4=
X-Gm-Gg: ASbGnctulxgSAv1sNhkPtTPD+Si4n0jhWXOVd446Rod6nPI2ngkUHdtWx+gZVnXQJw4
	7lbUaonJbD7wEqDueQacJzNoFVtPmfocAssgIN4mZNi0hZkr3F8FhwrtIFRD53GifaMlTjBwmXP
	rbEVauQI0oDOjPvrDML4mNHo19jJu/T/WG4/d6DGq8+v338dqyKkKy4Q7LZCRMD1JezYOeOhE/8
	ZKYc/b79ObSMPVOSQ2E0/ENPRZt0qVu6xf0rEteW201RhaxyXbDVAr4xFIKDkAeiwV0zk7SrcHm
	F6LwFs/rM5/nB+qfRqERspcXzDz9wn0NY1wgoRwPBMyk
X-Google-Smtp-Source: AGHT+IGuzEYHNDOM9dPEbUhYWot+R93Z9Vr9Jf7CFXB5tvlmQE7HvRHwQAsT2i4beE2ZMJBCdl2AhA==
X-Received: by 2002:a05:6a00:2448:b0:72a:83ec:b1c9 with SMTP id d2e1a72fcca58-72daf9bd895mr57630242b3a.6.1737984302924;
        Mon, 27 Jan 2025 05:25:02 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:25:02 -0800 (PST)
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
Subject: [kvmtool PATCH 5/6] riscv: Add Smnpm extension support
Date: Mon, 27 Jan 2025 18:54:23 +0530
Message-ID: <20250127132424.339957-6-apatel@ventanamicro.com>
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

When the Smnpm extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 7f774f8..4c9dbc1 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -16,6 +16,7 @@ struct isa_ext_info {
 
 struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
+	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM},
 	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e3eeb84..5eccdd0 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -25,6 +25,9 @@ struct kvm_config_arch {
 	OPT_U64('\0', "custom-mimpid",					\
 		&(cfg)->custom_mimpid,					\
 		"Show custom mimpid to Guest VCPU"),			\
+	OPT_BOOLEAN('\0', "disable-smnpm",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SMNPM],	\
+		    "Disable Smnpm Extension"),				\
 	OPT_BOOLEAN('\0', "disable-smstateen",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SMSTATEEN],	\
 		    "Disable Smstateen Extension"),			\
-- 
2.43.0


