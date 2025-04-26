Return-Path: <kvm+bounces-44403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F80CA9DA4A
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4408C1B663BD
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A33229B21;
	Sat, 26 Apr 2025 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="a17h5ur6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B41E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665454; cv=none; b=V3nwC2rQ8F8UnDPJbZiTETDdhcCJrEpTuSHuitPLc0yEvjqGt9TfTGBGmoEslACJJsIsN+V0RMk1cCUf/KOePfGS2Dr7BPzVhAXwOlvSlQPG2U5DDM13/pH8slaTNVxN+tWuQPWSFtF6TR+azcwIokjKgt0DFyJbmHRaSvEP/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665454; c=relaxed/simple;
	bh=2sxhCNXNz+uusMd8m0WOoiM5IIhIVXykeDlCg+8yVbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBNeWBiNOT08bz8NG1Br2R8Kg1g0HMtW2EJiH7Zrm/AAQqEtwzPLVYbvNBRnXY+7gnvedQWXs75+NZUHe4VzU0RiJbCWYUHI4i3tSyuYQDrCJCYXPGI2vpxKRwco3NEFuI3+4oixkXP7VSJrPEtDts2cr109X+d3pqLgPg4b9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=a17h5ur6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22438c356c8so36583605ad.1
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665452; x=1746270252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0IwKIyhJe48lUgNI7YxfwAQ5b4aIzLCl3JBaAqKrgA=;
        b=a17h5ur6Huw5Pry594+jLE14DYLArM2UgID6L2R6/9qYwTGFRb8lICztSv0Tf7LMHa
         ZRavSt60qoYSdcfI0++GDGvTsY/NLlTQvv6yBut0rzGfPnAKH1AnSvWfYxYE03BRCB+t
         wsiUKjcUea98ZVDDCNovZijXW7PRXFjw4UClmyAtvyCzK6Fxa/18WE5lj7e4yWu+MXnx
         oFJqgV9jdIV6CidaYM4FFIWR0Fr0Y87wFf+gETa9KnrN8SSJjkRkPw29pEPiDCW5di4v
         DZNjF8UwBCpB0maALUb3jeNYFsfARNVXdR4EXUrgGiTtQQWwqZvf2fz7+ZyBKJsNah/A
         pIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665452; x=1746270252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R0IwKIyhJe48lUgNI7YxfwAQ5b4aIzLCl3JBaAqKrgA=;
        b=F77q6E6FRXn15cltDIuCuStvnQ5iYCnI+TbyO/0fMyYasD/hwiMFhcdb+xE4g2AT64
         1ZPB6uJBIXBACG0gp6KhlVul3800b7gRErBdIrn0OV8KLS2b8sXslVdhDsiTb7FBjq96
         1PdNfgzRTzThLnR+xIPoxbyQnIbT66xuTvgItEEv2FMhB2OcdRN4dpMnFv78BrCSxnsk
         NrB5+lCKVZm6oBImPmmzUzKi4GYarzhQl1LtD5QKgAfraLnctCzhX5agHcT5/rNGW7Uf
         Y13oc9lpxFCGHSrvdW4hzjLhm46S67zDKkI+AMHYLCU/ByOUgXDS3b5GmpnOaURnPjMR
         ngUA==
X-Forwarded-Encrypted: i=1; AJvYcCWadYHqiSfP4qfTur6f8kD12VnMIky/0uUsWK14laCaocm3mWiM9Yv9NGX1zz8Piva8kRo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx88lT8EyOGsn5+G2fajxAu4BXiVSL6OmvYtvqpNJrCJoEcpim7
	YNeCNGPdUb/diK8OgHAC4fYk1jbuVDHH8Tt5cUZoiJ0Q+5l0HMIHpO/J6z33Q9c=
X-Gm-Gg: ASbGnct1Ajdir/nVzqz8DIY/xrZKEeRISe2qNu/qLvX/cLSIwrdEsMj3e+k1vueyRdd
	xjB+LR/J0Jjh/9o/sogGkXcJRRNUXovdhUoO8irpQMAuY46TsBNc/jXgOjZzGj07/X7yOT3hUTJ
	+7tWshjMH591twWwRChO9XUI1g0WMOID5ekaznPrw6klpK0SIi/WjQPVb2GOV31CJ+VScHAH9Fn
	HNF3/SZZXXgrKaClKjwOP8Kn2AHzwBqOlb6AUsIBd/mnma6ByzkZBv6fCvdFoFBWxfel7Ud4EfF
	vx2Mr1zQQAe531FneLW0iAMX+pkfoEP4qRViQlxDDeWbpmKXk0iqtgKFWjprOPumitERwXoXyeE
	WH07/
X-Google-Smtp-Source: AGHT+IEUyP8Bw9liWUKDVyCN8lDpBvdIIKIvvwie76DgjSbiYPaJKKH7xy0oBU4DlxeVssDGygoABQ==
X-Received: by 2002:a17:902:f304:b0:224:10a2:cad9 with SMTP id d9443c01a7336-22dbf62c6d6mr71591435ad.41.1745665452494;
        Sat, 26 Apr 2025 04:04:12 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:12 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 03/10] riscv: Add Zabha extension support
Date: Sat, 26 Apr 2025 16:33:40 +0530
Message-ID: <20250426110348.338114-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zabha extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index c1e688d..ddd0b28 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -28,6 +28,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
+	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index ae01e14..d86158d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -61,6 +61,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svvptc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
 		    "Disable Svvptc Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zabha",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZABHA],	\
+		    "Disable Zabha Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0


