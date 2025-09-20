Return-Path: <kvm+bounces-58334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2F3B8D125
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 698404666F8
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFAE2E7177;
	Sat, 20 Sep 2025 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SCbvuNLT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AD2E2DFB
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400753; cv=none; b=kHuO3aVt76KV2j+X7aNDqbfLCnohjscrcxLVCDVi6E8tW9RqgO3tj5ceBh74N85flqyaAKULuWhVF/ltILV1HC1eVE59jW05QZCYPydAA1LSsNkqTz2NDnT7haSzSYUmBg7eOaL6BQ8ZuiGZ+jmFlkNMls9imomlJdc5Tgg8mOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400753; c=relaxed/simple;
	bh=4BFlmqPFmB0y8a2YMn/MaIcIOGsPHlt2XA/KAa8fqQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V76zu1Zp0d0RSUE7QwjOpCrcEUQO8X7Id9XoQtBIa2RmfXl5k9c7olHWb01mTBEwkmeA0dyGV1n/s/qxLMOkSUI+My8hTtLve48S3JPe9A7hcNSn9S/+tK13kkwbHDYe4oEzz/biE3Ui13fH558VKc1qGAuCajVpptHujI+rDMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SCbvuNLT; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-425635acc4dso6654145ab.1
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400751; x=1759005551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxscO8SXNrjDBekFMJlTFlhXiLgQFfajmO2RZqDfrAU=;
        b=SCbvuNLTfq73d56rhpwdP7lcF+ClacdDqjgdi/PAaNyWMG9Wsr2vnbg1BvJOKfgWs2
         ky0O/lbBtZB7CLCGhPiNiWnBVif6mjY+jTPR34wTKNkWGc7tMESgdiNKlhITopQjDwL3
         ngtMzwVmEayKBnKOuXbKY/CJR6lS3L8W+mLVnCAg7pa8Q944wsvTEs2VzU0d3uwsJlng
         dkuDAS3LwToaaefl/xkaRAzmGv054Eb2Sd+msJENQPgwf0bQOdgKUrlMU4erakRBQ7vo
         4d4vNG4qvoImhOhHBL/w6azQc2ME9cqIO+wuOSaYtDBHk/JyISS6fNI3Y+vbyIfrIRml
         ArEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400751; x=1759005551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TxscO8SXNrjDBekFMJlTFlhXiLgQFfajmO2RZqDfrAU=;
        b=dLOs6cN8FB111FIv49+uxOiiCnrbBVXkRpaWEDqgks2+nt+T+dJQu8u23qGO43iSTY
         1hN1MzKAOrO+10qyQPKizw+u8X8PGoHZ00s4cV0eGymDu26B7ECm7EIQ47sEpkjmxZFS
         snuznBjmUZadpmAhAsm2l+tTgYWNylXVTn321afMVjJ76+DMVgaoKt0GfFTCZALaZnY3
         H6vMZBZnAkOlypTpwQhnekb5dnVdMYsXLHpb6WmQKXyfgErdak2iTKnRkEX9UY+lpV0G
         5tf43QPpskuQZtdG//nzydq5OeWaLFMvaZueqpYyH9YthPUjecSytgtR9p8cchKgBoFD
         7oXw==
X-Forwarded-Encrypted: i=1; AJvYcCXgPzwlHv4O5cd8WwUkQ4lwLsqSmbXSC+L9Y2hH/xWzpirZ5JquTqLSlezq+JVnnAbbVD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU1gLOJyMe6JeoLpMr1t1GHehqZCKVcIrcOI/m03t7AefSzgSK
	CuDL7JKVD0fD+Ndn6CeRpmqFB2sp7B7beG3tBZFQO9TPWgRYBpHDIpOKxZlorEo9yTA=
X-Gm-Gg: ASbGncurY4eYaV5sWDVkd9w4eOmglb6YSvvrqK/0xSEY732a0AmRyRqyFleXlgfQEKi
	t1WdiTG9MlakcG02DJ7ccItp+Xe6wwUsjRYgVzHh1rYOxPu0KKlh8TuZpfaWKdsBs67zQeektUF
	CYwG0R+n/y7fmPKZwyuIewCgl+3VB+lJQngbuhvDwqA3ALeZmY4tjLGDgVlNzUV5luddAj8IPWi
	WmF5xWsVbULc+u+Qv3Add4Z+Gw9glDSh0jAyLr6RqG/TlAV5RUTRvbmfwEjM82vQtcJ1QYLlHt8
	1Ip+7m00eQtJ8iuaIcj0I9sQqcPilVOo9n98G18PU+vfAb+WHkr7VrlTDUPCYGMUY0FgYROlJmS
	kQJw4U33/H+TT4x8/dk+x0wIr
X-Google-Smtp-Source: AGHT+IERpRPEc12mV955tvnuQoeNvkZUC+MN7EtTp3JKXd3eHnM2oBc0U3F0kWPqnL99WZIdHZ+AuQ==
X-Received: by 2002:a05:6e02:1d9d:b0:410:cae9:a089 with SMTP id e9e14a558f8ab-42481922e1cmr116891435ab.2.1758400751055;
        Sat, 20 Sep 2025 13:39:11 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d56e429f3sm3768486173.74.2025.09.20.13.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:39:10 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 14/18] RISC-V: KVM: Enable KVM_VFIO interfaces on RISC-V arch
Date: Sat, 20 Sep 2025 15:39:04 -0500
Message-ID: <20250920203851.2205115-34-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920203851.2205115-20-ajones@ventanamicro.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tomasz Jeznach <tjeznach@rivosinc.com>

Enable KVM/VFIO support on RISC-V architecture.

Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 5a62091b0809..968a33ab23b8 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -30,10 +30,12 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
+	select KVM_VFIO
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_MMU_NOTIFIER
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select SRCU
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.49.0


