Return-Path: <kvm+bounces-28007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A4E99152F
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CBA5283C39
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F5813CFA1;
	Sat,  5 Oct 2024 08:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="m3x3j015"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A913049E
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115243; cv=none; b=FGzXZSrxndyxMD+lMiEqqXILSBGp6T4QI417SYeuPye1r0n0CHG2RsdMH41F04k/q6ZooztpW++kAIVOiDYaw5y1/LQe1r6qSB/oZ+ugQvNpRw3zc+QvG3gtB1dRf5HupIw89pjWEa+ZAesajgmjym7VoXfMH+zurCNm84i+fUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115243; c=relaxed/simple;
	bh=vFcSAwaoHjTQIYIuybwWMnD0drvKwXdrD1Fa1FRVis0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt/knlc6B24gQc8IyI01EM6bN/WhcHfzBc1KoJSpy5QZLbXt404H38hpxKHYDXYONMrp4PxxrIdQXtk6ROoTHEmpETxluTLzRcLrUAEkA7wAWdL3acGrwOsX3rcf3AbqzkfHDotW+e/e0VDgbKXnLXOipYoWJzr/E41iyh4W+YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=m3x3j015; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e0af6e5da9so2189785a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115241; x=1728720041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjTizSTnXElNIJbMBBHecQzJBJ4PN+Q8AQDR1bin79U=;
        b=m3x3j015GDuouGwcg5ma7fk6v0UuAxTRoJMDfsHC5oJnTLMu0OBsAO26qDQzkpwort
         azJvKeyYBBLoYvPsyichotCXH+alAzBSIuL787D5WXfASBtMRgznCFNb+uEKlRIqJkSJ
         mzPhQI8U3ce0edPKlaVZ5xkitpxtvJi40TKYS4/mXdIHwx2iEUTWki6mVXDnazHp8oXd
         /GbGQnYu7Fa7ojD+FhGy98Me1gGijiqTvd7aY1mOOqsRQ752Graoxr45IVZv4bmsHbyL
         SavFDIOymLKAJ9E/yEQzKKXw6NWk9wOLm185MgdANDQ8CD/TsRscq1fs/81mFaEUmBcj
         7djw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115241; x=1728720041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjTizSTnXElNIJbMBBHecQzJBJ4PN+Q8AQDR1bin79U=;
        b=ljSsB/90c7Q9/h0dKvDhZdIxu0W5pKLEVgxekgB+sYBJF5Ibv2tXr+Rkwndey1oaRS
         l+qtFU+1JIuLoDz+b2LS84xnhbOgRRFCNHilYEKvIGVRpjEZI9fT1oqiS/Q4UJiFknsD
         ppv+ZIpsnNDVE1fCwcYP9SICwAMOceGkz/YRSxVYS4sfrLMSusJp0s4/tuK5UqHq0+xY
         I1Ogud213027BDhFRZLr9NqcukPYLQ9LL2w83ljmfwEY7v2BTqJv/bXiQRrs3HQLVxgi
         S0Br2lOXpKTgPnllbcuR6ZS2IwXIgf3mGiDguFSV2WwadTwj2gE4u3Fh9GZZct4qt6n9
         x+zw==
X-Forwarded-Encrypted: i=1; AJvYcCXqKFq4uSqx05mmQLy0EAzmLzUoljYvQCzSQRQlKck/tc+E2BWxsQFm1t4QGtl7XLyExiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpe4Oz9JXDCSXCZ1isG291QSfaeKMGuwxvaVRqb8xNoT2zoztb
	H2QIQsKUIuc9vSBRmJ18DZWo3vpA8IzDEq/R5mG60oLEvBe8FW1c8kytfiECSic=
X-Google-Smtp-Source: AGHT+IHYFulm8IbiBhdXV1nK9KudvzS9bOu/G90SzgSlUd4JFIZSJ3Z4BWmXHZwIEjLVT7BYG6vLUw==
X-Received: by 2002:a17:90a:ead2:b0:2e0:b741:cdc0 with SMTP id 98e67ed59e1d1-2e1e63217efmr6007810a91.32.1728115241103;
        Sat, 05 Oct 2024 01:00:41 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:40 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 2/8] riscv: Add Zawrs extension support
Date: Sat,  5 Oct 2024 13:30:18 +0530
Message-ID: <20241005080024.11927-3-apatel@ventanamicro.com>
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

When the Zawrs extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index e331f80..9d0c038 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -24,6 +24,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
+	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 3fbc4f7..0b79d62 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -49,6 +49,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zawrs",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZAWRS],	\
+		    "Disable Zawrs Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zba",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBA],	\
 		    "Disable Zba Extension"),				\
-- 
2.43.0


