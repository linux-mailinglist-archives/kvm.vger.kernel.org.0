Return-Path: <kvm+bounces-25622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 383B9967140
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 165841C219F2
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ACA17D896;
	Sat, 31 Aug 2024 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eJwBl3up"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF53533EA
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103689; cv=none; b=uBXEkW2KYZ5PE+XpjIhD9bOZY9kZR8UPjO/WE+FetvUlbHvvfVR+syd68rfXtyULq7awkd0PdRFkbPmji1JPIvlL+D1GlKgJIOgja7dc4Y1w5Fb+VcOiNTph7uNx+Qkx0TnQT5rdJp4TlE9rWALh+dDizyhQmWWyLVUnTmoZNrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103689; c=relaxed/simple;
	bh=iUeMOxB+bJ6yYs/eVf1WGH0sBRrkfImQ7eFcLyGwVsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjgDltksJ3U1LoK7TTIdbzmtV1S147XLYeeEb9nOZQuAUCQ6uJ/v1PinTBdYXG+4f2/C1VYAJT216rr4bTOymAHRvOvrKsJGjGCJUwJX/hja0zByKIuZpvhrDVvVRWBXzzBIlBPiHRYn8odp7O22CEpZeFwcs0ntiTVUSoHkf+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=eJwBl3up; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2055a3f80a4so181635ad.2
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103687; x=1725708487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amrFrBBY/dGhGTVucOT6fTXuPbDgIkbswePVZ2ud29k=;
        b=eJwBl3upQKzG2yBwbIhXC8PDnkB7cMTsgrTQy7kUUL+x7eQcGBTCk4uqVaG6o8R17e
         GGaEADrsEsoeVVla6xTx2knDdtIopNAOi9SA1UT7zEYF116yQ5borxvl0KV9UPJ7Ghca
         ydXZjgbO1aqGIbYTTPaTiM8BgkXeESwQKmHSuODppMEh+iZ1YVWTjwHDR4FoL671KqRf
         nkPW77E8OJZ94UyUNnc61kyBernbpi19ZeGLtgTVSjyG9D+NfwvAWc/7I18lDtq55Xoa
         fjBWykZLuYh/aFpWfHGC/rZjeOROfD2cfUfJVLdzO+V+q1YVzDMCvqgHfvRUNPqW0lQZ
         usUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103687; x=1725708487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amrFrBBY/dGhGTVucOT6fTXuPbDgIkbswePVZ2ud29k=;
        b=Lffnzq6mh0aAVKGWcnO/g0fPRPbF9Cmu3VAXsMe9LHXZAFsL9T7Rly/Ww/P/xI6BUQ
         X7Cj+hTIT5zded6JfxDgaUPlGXe+gR+ViT59EBxCBvUVeL5nNPSPLKAbqclkLKrsVD6G
         cTUcuuVwIIWuXZfXoc9K+fr1OW0rn8DNdXee5CXaGz5MfCH1IoLxpau8HdRXUEEEMgeg
         cT+A6Vag0pTjGw5GIS8GB7Kyzjh2cYaDL1OkG7pvIaxrM/X7mOF4+ro8eHm5yS3lCp91
         xa3AU3QrS29MVZ26AnlgClRm3ttZi0mFdKrfxIaN77jaoud6rePGDMp13JEr+DyeR+Fj
         SUcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSCrPc2uR1amqvsFBsKX93AqpcmqJ1hbi+hx4R/O5z+MOtnG7ByQQYEk0DKOEPoTbGYBU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz575Xs2X5+RKsiKPQW2U5Sn7NYPHwFg1a+w1eqVic+TpM74UNd
	y2lKgPYxqarVLOQVx2egNzecbMQrBVNrY4a7Jcvw5cme+VKKm5mdq3yb7HpppIY=
X-Google-Smtp-Source: AGHT+IHNCPuYTkZ5ewBczhrpsP1Fp01YKGsd3IZMcvqfAJZhV9rk5L4wnPoTAfR3/F/G81ss8F83+w==
X-Received: by 2002:a17:902:d48c:b0:202:2ed:b3a2 with SMTP id d9443c01a7336-205443ddd83mr23280685ad.8.1725103686583;
        Sat, 31 Aug 2024 04:28:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:06 -0700 (PDT)
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
Subject: [kvmtool PATCH 2/8] riscv: Add Zawrs extension support
Date: Sat, 31 Aug 2024 16:57:37 +0530
Message-ID: <20240831112743.379709-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zawrs extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
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


