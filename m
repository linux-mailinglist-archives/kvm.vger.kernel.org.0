Return-Path: <kvm+bounces-8667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E7B8854926
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D9E28FDF3
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84082339BD;
	Wed, 14 Feb 2024 12:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SHcFOAYy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2230E33082
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913337; cv=none; b=g6wAZ+YPk3zoDJ74G4VwAW7VwjrY516vwrXuD+9raIi7sHHRV/wyzfOuIJ4m2O68Gu+r063sLiTMKrBX60tjAK9GAleyjkj6Ks4wqNJl5CTeLzaxeYgexnnjLCJCkeUki+iraymcS4kwgDCwWIb8svi1roTFt6rib1BIM/nFyjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913337; c=relaxed/simple;
	bh=wJwTvM5mVd1MXqWP/WyWJ56swcNYEHP/wHGTRHHgGXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uNAk0UEDuZpBcdCZOdcpXDgpKEhC7rPlynrGOwCQ2bBk90VWzhyuFJfk/qXaiVPF8xMK7Zvqz930VgyFaBMnS7c1o7Jjyi3UQCoH0uK3dZR9r2qR8ZbJ4cjKXYxw9MJfDP3H926nRTwiLfRMnDz1eMyCXVV3VNXwJa570VezpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SHcFOAYy; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e0f5934813so1508784b3a.2
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913335; x=1708518135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFrJR7zq1Wh+NaQVmo8MahkS9AhhLjr7VokUjc39p8w=;
        b=SHcFOAYyMTWDh0NdGc2ls3IPwntCet9nN9a8VM2jH82UKSb0zRH/M3HFgIF3SniyOg
         bTExLtPe84f+6DOV35Z7J+zL8cEj2s+mAZeIjL8AkYXW94nSH0oCgbEyIbQpzAknJTmt
         w3g0roCpVGF9oUrT+Nm26l4JUrUGtBDZvQgAQfK96d4CVyGd7bgIOHktJPna31xYdYNb
         OKwjhucWD0iviyqecDr4fLpj2apx0kroE3r049nchQaIDixtXwoMiXbfGl6FxH7e5wMQ
         sSHyLDhcTXXqdTffP36+Hfx/gknkd83eVihPj+HvdgfcdCmHWNifzzt5MHF7NXNXtUjd
         DSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913335; x=1708518135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFrJR7zq1Wh+NaQVmo8MahkS9AhhLjr7VokUjc39p8w=;
        b=Y3M0bZK/cyzeIfBQgVdKE0/TogL0XAT2pwkwAT1RhLGIx1tGvtplNcodGJAqwzR3lz
         wXvfbJLL8C1nxh4XdFvQyGxNIphqX39AHHg9WbH5tLLYcwdQDub/C48wVB/d1UPYBAmT
         tO8BHBwA7u+jgSBe2642lsDUt9HyPg5lqGTfTGHGU02Qo43zmZsT1obybJzWlgkI3VOL
         YtGkSMbGAozKFpFgwT0sZ+JQtuqskyerZBU5cOwwpM61tbJ0swzfsLJ2cioW+vexiPrB
         OZE8CB1FiuSipChRwb7aOw3+yIusnrZeY6/Kulv5xwyVZkt/CqjDDapaOfgIo60BLU8H
         aylg==
X-Forwarded-Encrypted: i=1; AJvYcCXM5DCPfzOkXIFoFSSvH4N71zzKpHtKYYJQbeSpOisw+GCGOVifdi/Rmj+4dX3XjG2abFNmBeiH25wqpiMddT/7EEtq
X-Gm-Message-State: AOJu0Yyqvyjm/XrvEzhqd1lG1XrS+N50B3Otr6/2FaGcZogO6ksia2PA
	MbXLLUFj4qWvLNKb9BYqSFbu491ow2oyzFIKqQLxUBLgvQMTynpg8rM5x50dvlA=
X-Google-Smtp-Source: AGHT+IHHg6mR1oE5KV3JL5Ul1+XprOuDuIXsFOWSumDnqgVZHvdiGWEqbiuJhhstLxsBhyToHX0nIA==
X-Received: by 2002:a05:6a20:e68e:b0:1a0:6dd9:ef76 with SMTP id mz14-20020a056a20e68e00b001a06dd9ef76mr921198pzb.56.1707913335284;
        Wed, 14 Feb 2024 04:22:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXwE/FJZ+5K3PdVza5DR+at+9GHTWB0pV2AkH1WRTM/evpC7Q982V/s6voPRBx+N+fhlyHtWlE0PNU4u+3U8g8jjJWkymv3M6Ex+0sN5PgnxmDLuFlZbRTtxCWxcqju+R6RQkIbMYnhHJTJtmeTUN0y6RqK+q/0dJyMOOq5IszI+8On4eJhw+50K6m/Lx8XaOD0v9Bv6K3xG3PadjM8NvvBaAvilkaJ/qOqZjxmvYmBna/Sthk4i51u/WJ+b8pnxk38y8itMsQnfwCJlsoGEpGnIeQgp2pwoMvCDbvKQTVWx3/mRExbtsPyoydY74LJTg==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:14 -0800 (PST)
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
Subject: [kvmtool PATCH 07/10] riscv: Add Zihintntl extension support
Date: Wed, 14 Feb 2024 17:51:38 +0530
Message-Id: <20240214122141.305126-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zihintntl extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 7687624..80e045d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -37,6 +37,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
 	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
+	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
 	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index f1ac56b..2935c01 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -88,6 +88,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zifencei",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIFENCEI],	\
 		    "Disable Zifencei Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zihintntl",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTNTL],	\
+		    "Disable Zihintntl Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),			\
-- 
2.34.1


