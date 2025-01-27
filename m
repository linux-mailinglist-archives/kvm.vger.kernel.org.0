Return-Path: <kvm+bounces-36656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC979A1D68F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3047018869EF
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8F21FF7D4;
	Mon, 27 Jan 2025 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fFibQsw2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9743A1FF61A
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984295; cv=none; b=gMELe+wFsRiZHVwevN2+YL7bThw9VGp8gEUeXzwaCb8ULIMVeobj3vQCoGaOcDZ7rWFQn2ZdjXh/7FByWiPXq0mLDxZRCHQ8Y8dg/8/J3sIrTBXQXYC27WWZG+U0RwHJNZrIu8THV4mPebw6saciWGCdNeQxpX32tgIdLP59fRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984295; c=relaxed/simple;
	bh=8vuyUY4wjZbrn3XxaFpdO3UnUXqpT3oZ3SpyiUBj3t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgGkoa6Ffdr+ImYwIGa6QB+yiR7mlSHN+1jQMnj5LAeT58SNatB/JDpXt0L3yNisMt0DkDux1Vq5E3U95hMj+WIKhLayBlyYGWEqhH5z6Tyoo5npicn8iq39SC6T9xvKMU9tIpPE26MnIdzzl9A8yXaGJrBytiHimLy67hpDZHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fFibQsw2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2163dc5155fso75909895ad.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984293; x=1738589093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1fLkxDezVY5xdUOqyUkkMgsyMNSvYqCY7qCMYLwy7k=;
        b=fFibQsw2NTnV0ZuFwEI7eQ5cvHB5fI5Oi9ggyTgl6WDEqAMnltNau3ntZ44ghmJfNY
         qeLjTNMR2CUSJWq4PT3tdxX27UKVdSGC56RVKWkfyaFIfzI34zdQgOfHjfT1Yctpp2qQ
         OyKidcyHJIUbtVf67q+7bVeVznn6x3E5empLo/W+47nwUytgyQ7LiaFyAPdbvXVJVAA3
         OPYkF7OEvemw8+QtZojS8MAGD29ZWHkIQq8n1zFf42vaattpEyOP6aTC+fFf11o830uw
         XGPqjSFr5G3y2hDg0ynd+aPya8GzVvvVf3ph9CddWaHqyvRE6dtuNdKL3jEylmd+kW/F
         jvmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984293; x=1738589093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1fLkxDezVY5xdUOqyUkkMgsyMNSvYqCY7qCMYLwy7k=;
        b=j8fYkDpRNY+eLoleU5WJjKsVq/unVhaUZfrPHJpQkjebZzZoV/vDnj82xG96c8sgj8
         wsq3l6N7UD//fu4sUdV304bUQVBuDydGGjjmx7NyrmYzdh8dJtJkx4x0wt8DehtjT7TR
         F1ZueuAxJpUNhNQvcY2ZlYBVnTyTEl5FI6cfrMF1novS1T6ypudrRfSp+A8IXmCgCGrE
         h0R2MAKIcpKpunq9QplKY+LYTwSN9XqtkBh5z43aGr/KaUDS/0lnZilAO6P3PFmvw8kC
         IhjihEwA+xQn+rDPjErPzrWFFT6YN5CA/AojBt1YL3vTm7MbAYXwiJEDEmrV3IQO4Ofk
         /5ng==
X-Forwarded-Encrypted: i=1; AJvYcCWsmMUPkQHc6JGFFfch3i05Hg69yaojflmCT2f+NnAJL8mh/1f8oNZ00WuJrWHgK/pteCY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw5gQ2Q25MvQSNU6JFmhPove3jO5VCPfP0pm80Z+AGIIjyz8o9
	BQd4PSeDtyy8i4Ujzeb5ZECczlM/v6qitMyzlOUb+0t+ik2RMlJrafpX5EdYKP2CvpzRf4b9T1W
	JkAE=
X-Gm-Gg: ASbGncsM48guiXJgRy7NiGa46bIAwGPYodUwHIqpqybCEPhh0xtPu5ppMyeyDHzbCj+
	lOPyIRToFXvXlCsoV/CTHjUsn5YaBa/a099sPyiJ8IXEl08uDxQsHe0nrUP6DEvoNo4QM1QaBp/
	EGxfwg40DB5/iq3BGBI/3loShwYoVakTV237D+ibjtoeoVWJW3agG4huJHNsQVQ81rIXJvQrNnh
	fkuP7Ht8BFjYlzcnLfv7RrKdbAaUHEK/qTyw9T0dqri7nI+Zyor1Ro6E+p+X1+p6Ru8Uopoy5UZ
	gIFAGn28PwD1FKgfdBMUh9kjJ7ym6WtusXBTU22dYEho
X-Google-Smtp-Source: AGHT+IFq9lwCkTGawArxaN/anWckzzjn/Vj830cQ+kHh71q7m4ZYVMswYhB9yws2yOvIj3mzEr0yyw==
X-Received: by 2002:a05:6a21:7882:b0:1ea:ddd1:2fda with SMTP id adf61e73a8af0-1eb215683b7mr61710813637.26.1737984292764;
        Mon, 27 Jan 2025 05:24:52 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:24:52 -0800 (PST)
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
Subject: [kvmtool PATCH 3/6] riscv: Add Svade extension support
Date: Mon, 27 Jan 2025 18:54:21 +0530
Message-ID: <20250127132424.339957-4-apatel@ventanamicro.com>
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

When the Svade extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 85c8f95..cf0c036 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -20,6 +20,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
+	{"svade", KVM_RISCV_ISA_EXT_SVADE},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 7a9ca60..5389dff 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -37,6 +37,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-svade",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVADE],	\
+		    "Disable Svade Extension"),				\
 	OPT_BOOLEAN('\0', "disable-svinval",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
 		    "Disable Svinval Extension"),			\
-- 
2.43.0


