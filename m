Return-Path: <kvm+bounces-28013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A19B8991535
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D32D21C21E12
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2E713D62B;
	Sat,  5 Oct 2024 08:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jsuN7eKg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFEE3BBE5
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115263; cv=none; b=i0kP2nuvUJqI1Rkj4NDG/6a62WyE3WAEIQyMMyRD37EjaU5FietJrVrBV0TZiJGLmr1FwSKsSkYn17WguimpIotaIDHDT714kDN+MPWz6HnJsebsZDqtTX16UC/XTADNnwQgb3Au9jmQZaLlE3qojOK3ilWGb17Tc5cpNFMDYho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115263; c=relaxed/simple;
	bh=ZHKp6susW+DmRi09Ty1jgVH69v0kE/OAgAo9YVToyXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfqzLiLm+DrxfwsSiojGKy2oG8geYEfHDdAg5QL0NCCJUY+cDefUWY4nhhoVmBsSSS/BB9WlQYSe88UTxw3RAbnGCP6cBLGNRsRUE65urx+yQpBb6ZFoEBT74LaOl9lHdZ3EjmBMYjXa1K3hLXqxXAu0J7zEWN2YdajtyfQBu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jsuN7eKg; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e1c91fe739so1996817a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115262; x=1728720062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnTudTyVELXhybVtVq++J6lTF/E6Jxcldx86tlZwzWc=;
        b=jsuN7eKgJ7FwY5O1rYyqeGvkCIOMGVhdK8Uf3DBfvHsjVVF9Ld08Qd2iJDW2qUOyN3
         E0nbv8qO0UUDuACwT1/msRh3YruvTm/Gisuuaq7Vm8e9IcOoXkMM8CwRCYiwS/2fJcBc
         QRveV7j+fnCf7/Ka4mA6LEvkPdQmYdsfc0C29xNtRjhNsQlAmL1rqDH/rpjptTftPFBo
         idA+1dXLBgZfS8Xrf3YPWzyeqJnmS4dN+J7KPZnJnMR8vmFWu5WMFgIZxh3JWoJxVB7r
         YOej+B6WVwT7Kz04yDoB8o9hyfaaVF4v/TrsZSx2bWtLY2t3a2679fn353UZQq7UVIdY
         ywTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115262; x=1728720062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LnTudTyVELXhybVtVq++J6lTF/E6Jxcldx86tlZwzWc=;
        b=W/AAk115beNuvYeguZh71UlMPr7CdbNWM2ihLOD7xkLHPdB4rlOMJNKYugjyvGE35z
         FWSnJ5CE1OT1sAnmuYRzKeJZ3hk5ZBGQF2IR6MC0DK3/LFdUQZw1Ff9rfmUNtja/HmoL
         1Bf5+Rq8f3jojrXmDgdZSN+NrBuOtSkrs5EeHS1/APWYsaVotVkvz4ZBhfwuDFCnUpvK
         qtZrbUfTw8zuxdwikSVh7rohVCjzb4a69VOD/0PrPTonn5nyi+3Xisu17lB7kHNsFtH6
         g8cJ84PMgioHdA8uz49wyBHn6WGfzzsfiQEj4LiiZbj/Wj/eYICqmUQKrJpd9FX+A8eX
         YZ3A==
X-Forwarded-Encrypted: i=1; AJvYcCX22TKVxWcQ+zQMPdG4T54nvU98LkBEyE6Fwb2yw5lEAWmE/wqKZAtgmoFU++7uoaVfEyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz02CUGVE7SVGOY8Fs1iAglrapZEN6k9KvYu1bcWnGqaWFddwuD
	QzzAjx1d0OwbwMM93u+ppi2E2Lh+X9mVBkUn7fteEqf3fJBETOoVnzHW90oNGgE=
X-Google-Smtp-Source: AGHT+IEnuOzukj3EhhTiLkX34VWObsDOqzoeGnbWToEK7upZYPpjOZtBKbVZDiiQSLbHdYOq3pg6gQ==
X-Received: by 2002:a17:90a:e7c7:b0:2e0:9b59:c0d0 with SMTP id 98e67ed59e1d1-2e1e63e3315mr4881500a91.41.1728115261841;
        Sat, 05 Oct 2024 01:01:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:01:01 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 8/8] riscv: Add Zimop extension support
Date: Sat,  5 Oct 2024 13:30:24 +0530
Message-ID: <20241005080024.11927-9-apatel@ventanamicro.com>
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

When the Zimop extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 768ee1f..8189601 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -49,6 +49,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
+	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP},
 	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
 	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
 	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 5d655cf..7a9ca60 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -124,6 +124,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zihpm",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],	\
 		    "Disable Zihpm Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zimop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIMOP],	\
+		    "Disable Zimop Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zknd",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKND],	\
 		    "Disable Zknd Extension"),				\
-- 
2.43.0


