Return-Path: <kvm+bounces-8669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A50B2854928
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44E85B286C7
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D7033CF6;
	Wed, 14 Feb 2024 12:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JbUBtiSz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6361BC23
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913344; cv=none; b=EYqECfoWz/D5D2/xsUpChe5mdAXyHOT0ASEfjB9/6G0SZVeRaAQtpm6jKETKeCzaOdq5rUGMHUKyOS4r+KSmCHJngJXey6+bAcqYpTbB40f0rI8ZnEeSP0a1sEuKlDPHJzd5VlFYEDSJPoiP3id6A1jmcjbp/6CDw6q6Z5ecQ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913344; c=relaxed/simple;
	bh=xlPbLZBvKkdxUBtEAJ+L9SekTqD+Hm03KeTB7HFipLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CD3XUibSD7+xiJGNbVmSoN2CtWCXnm6iIRbCknhzCc+R57Zm2MH7bTl22oDOjwQOev5QYM4jsY6p+UszKbZlfjix1R4GgbTBHJ3wnDID27z++aV29CzF4yWdDWx2tgLIEm2MBwVTyo7mCet7M3oHONb/cB2Kqv0OCJTR8I5eEbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JbUBtiSz; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e0f4e3bc59so1481029b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913342; x=1708518142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIXRz6EyWQfNdjp5qvvOmQztA9TRpuUypiRGbNjXHSw=;
        b=JbUBtiSzRfHNGNVaI8ys8xyZv6VYZWQZZidWnbveGXD/wdBo4jsPx/0o/HVua1WtCw
         MI5BkZZiMvxDwFWkCvmcAGXf1Zljen6KhMkryxwPLNNpKgD+PAIcpOmQ9736svwGJd8v
         Hjafdekqp4FjHCCY656pGdfgzTHuD/R4HoC0TQjkp1zMPVmCsnIUGoDiIht6oZ5doPFc
         sY0/MF/0M4q4plr3z4msT4T/e+gxo9EreC9k05M4fyE4OqRlavR94gHZhqnPvpLf2IJS
         HbkquUDF7LAcTZ02KGkeQKPb+tJR9WAwT/7S/HDMkJABMTMDeMuTjcoIUqk3Pf2hyzWY
         lqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913342; x=1708518142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BIXRz6EyWQfNdjp5qvvOmQztA9TRpuUypiRGbNjXHSw=;
        b=d/JGRuYCTWTHZYlafr15aoPqOa0yk/wk6BC+walP7rjyFkhjTrKHZ8Gebdj4KSGLvO
         syIsbJxn/FEJP67h8DkP7m9Uq9bDyeD9/7Q9w2+eAgknB4uIKhNJ2B/0PWu7K3iRuJ+T
         MDZYShCXglCJiI3QZT62WkH5D/es7LfSj5FK5U/5tNVBdEsPnB05cc3TYtZLcXkenkpK
         b97pDwp2TGt6pYfAxfPhhWTC/Tcezwi2l/hd7ALJbCys1C/qMroBA9CfrjClJ/AF7HjB
         sO3B92TwoNUIDVSqXcUTtIJDsFLL0JvVwOYj5s3jEDIMSnmgb9A4B81/Nfq6DJnwXZZs
         LGIA==
X-Forwarded-Encrypted: i=1; AJvYcCXNVS8AsK+H2f4hClJlvuUNiHNeUZkZKqPXXomfbJg11BMx5fPtCcexDYlhqpxkRuvFc/wOb1/Id0wHgqfB6mevJfDt
X-Gm-Message-State: AOJu0Yy7HDU9jiG3j77wEP1dEdIGQHBDPOZIeDA6vQuhAY0pBYZi9XWB
	LqlP1KoQ88X0vKRAXWFoCHoLUWgX57L807AWoIpV5Abx2oFPq31EZuHszWickZA=
X-Google-Smtp-Source: AGHT+IF4SBbzY4krg7h3GKfiSobUOEAfykSn0IYuhmfqB8DaaXEewiw2EnzFMNOALrIVbhuOkUQ+vA==
X-Received: by 2002:a62:ce42:0:b0:6e1:159e:a5ba with SMTP id y63-20020a62ce42000000b006e1159ea5bamr335556pfg.31.1707913342503;
        Wed, 14 Feb 2024 04:22:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAhfRZfHNE/DpcS65XvdUoKpo2xtOVeSlMP8h8N2LMX3NZH1cyXN367oRd7FJAKi7BvsEKsFdP25wjrsyoSTnWrDfdXcxHbuxdZ/bOBJe2vqHC/W6e/X5PGb9vv9xDQuCDdUBQw+N5MIHSx6+JjY2KyXSo/3PwG1E+a6H4Hsq0MZNeFLfa0AsYC5bDXgjX0UAchOXRwg8wSLCvRUVLXC2+Mp+chVWkXnd3efUuvV9RZnl/pMFBw31cWkQQDF4PLibMMaXbDlPvn578Sni9JWNoG1EY6Sn369if1drVx9vPtomGTBPmsJF+OJdS96j0Iw==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:22 -0800 (PST)
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
Subject: [kvmtool PATCH 09/10] riscv: Add Zfa extensiona support
Date: Wed, 14 Feb 2024 17:51:40 +0530
Message-Id: <20240214122141.305126-10-apatel@ventanamicro.com>
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

When the Zfa extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 005301e..cc8070d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -29,6 +29,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 10ca3b8..6415d3d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -64,6 +64,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfa",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
+		    "Disable Zfa Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfh",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
 		    "Disable Zfh Extension"),				\
-- 
2.34.1


