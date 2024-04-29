Return-Path: <kvm+bounces-16165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B888B5D23
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF0771F2029D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4289E130AE8;
	Mon, 29 Apr 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S528nEJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6C130A45
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403206; cv=none; b=s8puMbabDABuSnJ4eWNeRVipaSc2hedPolLC46hCPCIz7fciMiLPUGlVz9caFtNgGcCaOEZJiWpj/COVjXrYAYq6eRZ2q8jVQ08pwAWQf9Flnan00SHrZx6NHF35FGV0+zP1JzXKEEOovwz7GwRvh75gwG+eNzpdLEbXM10VrNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403206; c=relaxed/simple;
	bh=awZzvOfeihP/zQBwulZo2fkHpvheuFzo9+sGOB1HlhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHWUkKSSO0YgsMEp7BOc8qepcbgzHLSzCEaEnBP64LuW3epDWBXsIXqNvz6INEuEMmexUQ8ImFzwQk5WRru83QCKGp2DEM01Mw0vimINdk108EEJ6WM+W7LT8fEogvDKbBv+85wYbGzGAvDG7YbwMajJN63eLIus/1nexzJDvPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S528nEJJ; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2de14227d91so507821fa.2
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 08:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714403202; x=1715008002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQHXVYsUJGkXAyoSx2aDU2oA4c+tlzZFdLvDimlX5cw=;
        b=S528nEJJuVc/ifgNZ4CM3gYn0p5kQA7gZNENBrsSghE92Sj26A/1SSBJBqVhtZNeh/
         J9lEvaCTBbiXiGF4DxPLgU6bCabt/3ngfL7EJ2oAvRgMEEjulbAnuFvkVXtM3e3H1yAr
         gGMPtgjlfzCmST+gYzBzL7rGQQEj3KhLzLKpX60bQnC7XeK3SOQm4KKxIsSz0XckQd1K
         YZ4CFJvwik/xtvoz73aMdsEtUgljll5/qA95DYD+y/9ObG2GufT7Awxbi3S6/2cUR5ey
         tV6hfECq9+cEUGBo8QnNQyMGssrqnITCBFuVI0F69YZdsFFqwsQW+fc19lMke4SQdTB7
         XcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714403202; x=1715008002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQHXVYsUJGkXAyoSx2aDU2oA4c+tlzZFdLvDimlX5cw=;
        b=FkA6qqMk7dlQzM4cyJ5v7uoXepMuQsYBGjnblV5BE8R2bSKQIEYS94A3fCiwHBOjY4
         6dSYBnhxVHjZorg1jzu48F4QzScjz/g6sFNu/eldueFVxSmdIptYRzUoiMA7/q4si314
         q0TUGz76Q3K7ZbQnXefiuIl3Qdh5UHMlxF9pyYrMh7VIeT04lwGMv3B8mDIvbtXs1f+r
         RSZwUGd7i+jWolzb1JwNAbiOgiyyCBvOYSwSP0Jbb+GO4qxnd2dNDsgzC5949EjykvyT
         z3vVND1KxKN0rzNHYIFhoM+igQ37LkSC8iIZygZZkk8f/01yQQLhpVmd3tU1BkR/wnHi
         aBfw==
X-Forwarded-Encrypted: i=1; AJvYcCUe9C0Wc2YhgOlI/KqbpgqsZiUXEPpgmHR73kQFinZb6m0Q2ZeR4v6BJM47Ip8NpDwxjaQQ3FkiqN+v/RCTlqkWehhi
X-Gm-Message-State: AOJu0YwgP4+X+ILa4z+LD87EBr08PLh3digbAqCWYAVUZucUpphCf8RU
	2Opu3QzJnJXw+bMbq2CTCjdAZvd5LZbSOOCjJxSGWGwbc6Uhy/P/C0ub+Ly/oAk=
X-Google-Smtp-Source: AGHT+IF5Vs0aqFA3oJjuIMNqrstrULWJr97uvIHCvJJ63TtvRmaJzQ2/6ase4AtbajSIDHGGP4F5Fw==
X-Received: by 2002:a2e:9ad4:0:b0:2de:1457:9d22 with SMTP id p20-20020a2e9ad4000000b002de14579d22mr7307292ljj.0.1714403200338;
        Mon, 29 Apr 2024 08:06:40 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:2fec:d20:2b60:e334])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b00418f99170f2sm39646638wms.32.2024.04.29.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:06:40 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 08/11] riscv: add ISA extension parsing for Zcmop
Date: Mon, 29 Apr 2024 17:05:01 +0200
Message-ID: <20240429150553.625165-9-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240429150553.625165-1-cleger@rivosinc.com>
References: <20240429150553.625165-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add parsing for Zcmop ISA extension which was ratified in commit
b854a709c00 ("Zcmop is ratified/1.0") of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index b7551bad341b..cff7660de268 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -86,6 +86,7 @@
 #define RISCV_ISA_EXT_ZCB		77
 #define RISCV_ISA_EXT_ZCD		78
 #define RISCV_ISA_EXT_ZCF		79
+#define RISCV_ISA_EXT_ZCMOP		80
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c74bdb9c0a9f..acd745bbf41f 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -315,6 +315,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA_VALIDATE(zcb, RISCV_ISA_EXT_ZCB, riscv_ext_zca_depends),
 	__RISCV_ISA_EXT_DATA_VALIDATE(zcd, RISCV_ISA_EXT_ZCD, riscv_ext_zcd_validate),
 	__RISCV_ISA_EXT_DATA_VALIDATE(zcf, RISCV_ISA_EXT_ZCF, riscv_ext_zcf_validate),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zcmop, RISCV_ISA_EXT_ZCMOP, riscv_ext_zca_depends),
 	__RISCV_ISA_EXT_DATA(zba, RISCV_ISA_EXT_ZBA),
 	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
 	__RISCV_ISA_EXT_DATA(zbc, RISCV_ISA_EXT_ZBC),
-- 
2.43.0


