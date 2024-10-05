Return-Path: <kvm+bounces-28010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7D3991532
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D3301C21422
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A67613DBBC;
	Sat,  5 Oct 2024 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nOdIjOr/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1537F13BACC
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115253; cv=none; b=FkcDOa56e1MgwHrOqod3lTYvCjZihbmVHOB/KmcVYH8KN5Qu2iBv5AZYgSYWBtnM6+aMnzEAZkQfFAZPu3bQX1yT4JdSKwbSq5bqOE66oqRemfezALVe2leO7QziB6s3jDoj3hN44X3MhqTJ3Pish1FtcJEAXSYHNf7VoJBXECU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115253; c=relaxed/simple;
	bh=f9tV2toc+TQ5K0UcOm5fLBCCM43WQTdgk6longx/02o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK9vkRZ/xLPhCpqkWEBmtBuWraSmNLndDXyxEt5MS+S3t4oYHPMYxtvxLUBkOS0cayDwypx5g8Yr/ERUO/j2b/XdYVj4KIOMyyI7ls/QHIXPEhFCPWCK+a1VqShIo73FJRbwb/MEU54lypV0jZdQmk2P/Kugwnk33tw1BV4Yu9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nOdIjOr/; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7e9c1a6488aso936040a12.3
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115251; x=1728720051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HljAqjEh40WC0r7IuZKgWy7tz4cBN23W4UZT2AmrxA8=;
        b=nOdIjOr/HCyOe7pzyYD6W8PaZluC7CFKdJr7KtcKCHs54UOkVvoGzpXq/uymk2o00r
         Ev1HJ/3hNRFwmNyD11pq4/ueaGfdg+hzjLYUrXu45S4X7AzJ38ZZaphOXsgD8aFoIAfN
         JXuYMe42ONrVFMaZOsAM1YsUmYbxCNv+GPTtoyXcVWfs9XPgRX86AhuPe2MOI7EnOP60
         HPzjA8l2mZgSIwwsUv1mMOxkGo+6rOyP3IOXfbJaTmR0i8k94R2DYqyzYFL/kmlf7zsG
         FcAkMIF12O3SPy9um2KxQ15Y6jQBOJXo6dtJEmCqfjA3vTOxQHZS+djlWTJ2sIetdHQ5
         eoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115251; x=1728720051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HljAqjEh40WC0r7IuZKgWy7tz4cBN23W4UZT2AmrxA8=;
        b=FNUifN0d/Mbh40rCBF2po6BEj/dXwTvIZmhi0wocx26nFFF6R27GHlJb4xDxeAsEN7
         qS/GT9QfSvfC595wIdQJB+HOg55QSzALn0e6civzSDDofxM7j/uOiTDW6BX+Fq0Iy2rJ
         Vn9UhketZFB5WONjKPoAUp/2IVfYmK0V+mjdxyyXvcqULNEOIrWTT+YfzSfyi7tEkfTc
         +qmLVYUqJTc8/CZeTZcL+HzuqkYjUhtRwC8/IHMfQKo7Q1b/lDGZs6g3NEkLHhPozELA
         Ls75ZtEBbmV4ANsP+Se+8ewdPR/EbcFeTFWXh+9z09qp3ow8z4InCmvHfks1gS5lJTnW
         12uQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8RZ8Yj1Q7+et5tD6l1S2dwc7cxbuZTVqPxYLt3qTeg3i9gAms/uBuDSp/49LsbR70gS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvJdTvvTqgXU8+a1pWGUMvHOpz8/pXnq5pcxnH1mH/O1tTUn9c
	N57MeBSS/P8P5jIlN/ouaCq48yZ71ogJpl7BwiTVIQrIAcS26kdGj18t1rZ5a1I=
X-Google-Smtp-Source: AGHT+IEMy+RG9uZADphTMdKJaq51ppmQz37AVvkIvuuTaHCxFJfpj8n4zS76KNrs0Z3Z67iVp2abaQ==
X-Received: by 2002:a17:90a:db15:b0:2c9:8105:483 with SMTP id 98e67ed59e1d1-2e1e621d982mr6330721a91.14.1728115251303;
        Sat, 05 Oct 2024 01:00:51 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:50 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 5/8] riscv: Add Zcd extension support
Date: Sat,  5 Oct 2024 13:30:21 +0530
Message-ID: <20241005080024.11927-6-apatel@ventanamicro.com>
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

When the Zcd extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index c62d4a3..5587343 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -34,6 +34,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zca", KVM_RISCV_ISA_EXT_ZCA},
 	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
+	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 68fc47c..155faa6 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -79,6 +79,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zcb",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCB],	\
 		    "Disable Zcb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcd",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCD],	\
+		    "Disable Zcd Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


