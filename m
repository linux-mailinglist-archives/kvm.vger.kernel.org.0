Return-Path: <kvm+bounces-44187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C4AA9B25C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE5B1B87207
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A071B0437;
	Thu, 24 Apr 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pDGn9uGo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A822544C77
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508740; cv=none; b=aorUcT7Wf8qOA7XykZHFd35VN419qx5TaUpywYApUuoqRy/AwUIPPbLcjzzc2zDN7xCGGE1GZ0Z+vbPnVHCGZFUU/70crc8mgUg9waXlzPrEi4ldgY9ub8WD9A4YESW65DOf6cIsi9ooxxdHtz7njx0rMKruFdLR2MQBW60fWBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508740; c=relaxed/simple;
	bh=WloU9S+m6ZvHvTWt9Lg6uhA5IHMHZWUmy1t294mGXuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFPwQg2KkIrEaPdOoCnotbETGYDunuEO/tVy31NBzJOxEw7swwi1/TAMCKct5XO5cs80SeRqnPK+MagPrQJz6U1pgTaB2n0mP3CdU0UuEc8LkZIuyoKWL8bmi3Fphzx9E8Ahrvt+eWgwD05fCv5iuL6UXkm1pf6s5sMRenX2I5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pDGn9uGo; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso1176456b3a.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508738; x=1746113538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yq4t7UW6LQy8HVZqyavJ2lszswgStVhP6cQHkrVx0B4=;
        b=pDGn9uGormHSgRtRN8Rw7Vi84f5+C3Eddf2kKgFNJhh6iZwXWiPmz4wlASn8o5Tl14
         VDFs85wZR2eckPQiLO1yRjPU+WddJ5KAm61EuYhJR1hsjiyWxOnuuPD6l7X5fhoALIrQ
         cSVMO3Q6rJ3S0IOmbo2Hha8lBtbZOgPuabbJZXTv+Wp4sTruHV3t9jl5q7ZG5mZyvs18
         RYdREi+T9cWsmMc6BvVrbAGw/avIrGE4TUEeQDUhGYJUaoWVLpwtKi5SiIVniYLZsJ03
         YcsulmARVkwflli84bdFIkUnQ15l+KsilHd535Noi4CYE/JsaWxm2rNeiSAk4Z3bOPlb
         LbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508738; x=1746113538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yq4t7UW6LQy8HVZqyavJ2lszswgStVhP6cQHkrVx0B4=;
        b=FDNLvjIgXTeUfS+V/772QOgIqn5b595qCmqSb4x8hBtYh1MhmqjdfBrrrVukv4jj3a
         YJGbL5CuOQALdttp4TusBiWlt1gKJqrGzRW/S7H/9aHhD8Eg5LhxPL0xQvKx2/8ZzVoA
         1bX6NdqLYV1PAAJRke/2vhUUTKQzQ65vzlwAvRI55BFB4+grjxDooZ+h1rys7twx0kO5
         vJH1+l57ONSjfOo/PMO7pNkKwnkwmK1zKlZpkdks3EAwL921LN9zCWRq+0JijbSdxDEC
         +Xo2uUV6pNPLRGpJro+I+CitnKbk/XoFHqH/7OkEoEcpv1LGy8qYUc/ofZgKMLFa/KwE
         1G/A==
X-Forwarded-Encrypted: i=1; AJvYcCVSOrxz3+YR2csnDY+Ss6p4cnthCAMspBDK9kEKn2gIe9G1csxe1txOH0A5c0uaZKmfIQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ5z2AgV6Jz9RrK4P2fdeCresf0YsNcQ1TCN67tBtwdnMwUhRr
	N3sAWLPhJ9OOlZt59dGrOmSys/McxIOnzEhQi5eLwXSAb2W2G5OA4vu6GaTxxkY=
X-Gm-Gg: ASbGncuAE8eyB3K8WIQG+lghpyR0wsTn4mN1Y7iioAc5XEliOdKsipOxIPpL+jHYYNM
	g4vWU8KNePwpqygOn8tkB4f3Tgs2YqzefmbngxObgST5Irma3Ex0APbHmqSL4gG7SoOZ10kgWcx
	QNWgUbZP2FjyA6z1S7ybJ8o2A2beQOAHU+FqwsarSEQMwAGcaxlcseEkBNx+fA/cF14Lfb40rtt
	q15s6Gq+T/1o4jZeqZ2Ijm1VOk2bi15zQN/1ZLPiGn8KLun0Q2QJ5q/3CfnCEONzVxUXx+C9cQx
	lNybj6thcIuHAa7NFivp0crkoOXq8bJ3TOcB9edNBo2O4V/RUVMSvgirJTVyiLV7DhfLOZOmPku
	aIRiI
X-Google-Smtp-Source: AGHT+IHLx1lBNMSbQnarUYes6btCTNwf/1IXV6SM3KkJ4vOw83GPlyVf2KCTioeOb9jergc1GD2B3Q==
X-Received: by 2002:a05:6a00:ac0b:b0:736:65c9:9187 with SMTP id d2e1a72fcca58-73e245e4080mr4091165b3a.9.1745508737767;
        Thu, 24 Apr 2025 08:32:17 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:17 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 02/10] riscv: Add Svvptc extension support
Date: Thu, 24 Apr 2025 21:01:51 +0530
Message-ID: <20250424153159.289441-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Svvptc extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 03113cc..c1e688d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -27,6 +27,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e56610b..ae01e14 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -58,6 +58,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svvptc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
+		    "Disable Svvptc Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0


