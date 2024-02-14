Return-Path: <kvm+bounces-8666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C3D854925
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A6741F2A465
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C427B1B95C;
	Wed, 14 Feb 2024 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lRx12hfA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33072D60F
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913334; cv=none; b=YkDn7lfFNMZuwNXESUOlM7HWXqjP6UuALOlhozLSsLh8SNvcmiwN9qkcooxaXAf1TXKPVeWJxeKmQ81J2DtibZgDbD363F9ARk3nbpRaHDH4G/1SEmYKoWUvm4mAwg4IGwUxJqLhcpYYg2FuB94m7oVEgbT6DJjrxSuS6t/A5MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913334; c=relaxed/simple;
	bh=sJCkH+jhw69qz8Jq+Hk9LNI45Ra6IvI/agcwjaFNlfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q70GI2UaiYSYxbfJm8yx/h4Y4J5cag+/STdCFnk1VINyBEhtljhED1obV7rI1MM38zTRo6WTIxOTPVG2wLSkioXt67HOpXteS1yC36Xa0TpoX9eFjORUkJQZ74o66FYQvLrDnL8Q9GR4LTTOMht++VCHZQXEHJthbrpUXho59m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lRx12hfA; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6dc36e501e1so3613721a34.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913332; x=1708518132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdrgspXtjJ8x+TgvCvFfZY4HshcuByVZLxSfDH92JrE=;
        b=lRx12hfASUgzhhWo7P3NIkfyi0/2g5+sVyPP8OoPqV8QbpPm33D2z9XU00g3fgmhiC
         ghT1ewVg7Wt9qOAm3CCCaBKN61LFNBMezkGSmUqknElgtBxWapfZpiqJbmdy4UMYTDxL
         m/3vOjEHzjLLaUNSuRbGxUP33zXs0QHAcxPoPs5J5bs9pq6lJgUdz6CL3hw3iCY+KLs1
         /UyRLeosDUv4d62N5d+1ciOQVg1BiHQ8HJ5vwFDG/kq2/fwXeWYP6/ChN7tQ7Tm25L3l
         v3dAq0Ve48n9jbi8W83mh3jTCI8KkSFXKulVZd2/DweKn7WbpuuOEoYhVFJD3LE/EGx3
         5MIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913332; x=1708518132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdrgspXtjJ8x+TgvCvFfZY4HshcuByVZLxSfDH92JrE=;
        b=UaTwVbHHhJIxhqvHop7l3ZOBDohIfYIXNdcn9wDtbZKKZo2Jlz/1N9Xseu0iYl+QKl
         QqNRjJ8ZSiLeeEexFmQj+f4qPqHb1/DqyrwNRuWl4EikubVCegp40a2FdTCHnDSKquzt
         l/ioPRGngN6K4H9VIrKFJwNNTi6Qn/3i171mtB58ihMQBW73mB3AX41+TDPTjwcXuiAX
         wTTN8k+gy8OBUNkZ/vgyUGMV8GjPeUTM5+VEe1hEShuvDgTiJFq4oDscUVOo4rUvkZL0
         zKnal5rO23M0y+p9ikirRvAVj3gIcfAzFBn51vKqQTZmW/LsBJ4uBHpRSgjG747qqbWs
         er9w==
X-Forwarded-Encrypted: i=1; AJvYcCXZO/O8Qbb9u+1A/xYdM12yjVlS8Fa6Hfz/YDIF3uLFuKYZ2Df/f93KoVNTXgHhNIv/By8XRwO1FYxmSwRk8aoYbuPi
X-Gm-Message-State: AOJu0YxR+XmJRMnGVPbZLfStYr5mCTziq3Eo0JbOKBIVvyfm7BLJZbCl
	s/RqpkMv8HC5tKjD5oOzd1ySLVkxxJ56Y11u2IYwW02Dl0a1BeVgyPI1+HOs3ws=
X-Google-Smtp-Source: AGHT+IEaEo5UJWRqqmuDjnOvwwCBIt89UVG1tUctHZ4EVYrMg4pLuUf2JAAYr6lA6jKWE5/77aIHMw==
X-Received: by 2002:a05:6358:524d:b0:17a:f909:2cef with SMTP id c13-20020a056358524d00b0017af9092cefmr2217115rwa.31.1707913331698;
        Wed, 14 Feb 2024 04:22:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVcL6IAExbu7zEngu3X/DEPUevZaDpQwFlwQprCF4X4MLxUu9XAwAQO/45RjiWdoAH4BJc4GRuW94G8tz6khf3B9Tv9nkKzn9N8oSXcqfqXfp39XFY1UWE0zla0xkG8SR4d66iLRGwmyctkzLxU7ZQnw5toz3q5QIdA0TjN//rIjGnvp/E2ySLO039NCPclrrRKvuxVaohqaJAd2mIkiTknsXejoxoqebf3jHMoOhlwFWxW9PPBJdCCwDUj3umVfVKcTLai09Il0VlhZbm5yEsnlGDiI7lud2lXRlcBp1HDgpGcrcBumz1jia7cvSRVSg==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:11 -0800 (PST)
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
Subject: [kvmtool PATCH 06/10] riscv: Add Zfh[min] extensions support
Date: Wed, 14 Feb 2024 17:51:37 +0530
Message-Id: <20240214122141.305126-7-apatel@ventanamicro.com>
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

When the Zfh[min] extensions are available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 2 ++
 riscv/include/kvm/kvm-config-arch.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 44058dc..7687624 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -29,6 +29,8 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
+	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
+	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index ae648ce..f1ac56b 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -64,6 +64,12 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
+		    "Disable Zfh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zfhmin",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFHMIN],	\
+		    "Disable Zfhmin Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
-- 
2.34.1


