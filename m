Return-Path: <kvm+bounces-44195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39AB3A9B26B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48F849A2A74
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DF427E1A7;
	Thu, 24 Apr 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WRthvDQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E16C1A8412
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508775; cv=none; b=QF5upbY37hK32YiLI/jADFWIVMGCJtbzesEX5XrEzX94/YY5IhrNFCdMr2dxZmcrOGJzPxMd7iggvdAF5F/R3njsct3LaIQEwqZ/1kwmxgzr1PEeko7qt10V+Rc8qi5i0eDQqrOltc0MRZgpts/1VPioBCRSC6w5tI5Dc9vHzKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508775; c=relaxed/simple;
	bh=eLv+kIz/NBZCaV0n6yGkozR94xne7e5VjroAOCHQbtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClAX6nK31bloD8T1jRUDEIe1W2w9JSHLiR4kwL7MYeaGpiwU9pSB9+ew0nGyZiNO8PfBA6iWzh8eByHwSBCCvqqjTqDLpw+WFjZeYmzR/6lqletUNLZXOUsDEQkoEIgh5tT19ZhetEOJFbtxJB3DhWkpBQ19VOcl17Mq89jUlNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WRthvDQ0; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-af52a624283so1140943a12.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508774; x=1746113574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5rgWea79y8XM1Rmre4RzXC+CKYfWGoladFiChG1Ddo=;
        b=WRthvDQ0hRa1bLt178LgwyU/NKOyTyUjtolsJmsVfc/a5zEWujIVa2SnfI6dn/VT1W
         Rn64yUsnZ2dCZbASLbDRloyIH+uBY/0tvpSiqcHiEpdHCXrhX97thkVwXotx7wlioB9h
         xx++UdneeWqbYZ6nSb2RrIbQh7qpa96yzLctkI9BJ3t9nwYUSGS+8x8xKNeGxuIkcQeg
         z25zoZ2e5JSaoV95H6PaipfKPwzxH4aYQC4aiB/QQCoPXPIBppRwjiFnehKzoqig9ZIU
         TnsE12BD1hUup2VedCpDYuFYu94T1/pyoT/D48QfxcN9bTAnjYJd5fV2qCj0dMxo6ycK
         VFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508774; x=1746113574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5rgWea79y8XM1Rmre4RzXC+CKYfWGoladFiChG1Ddo=;
        b=D/9z59TLEjo4imDnJM7AejM0bdZmS9RwOEKwoxY/m0DeYBpTj7mOmqdb1NVVcSJs41
         lk4XS1GY8lfe2VFR6UKQyXU4QhuOVanQFUYyEjgiiTDUaB8NaNpw9zT8EaLK4smw361J
         XeZ/TxmiBeDL/urPpJ7NMpOrkpADtFtWPewYToHdGP9kyEIlAowXilLIE4Is6kW6NKAv
         yRyO9SIEoU7MhZyL1JnJvdm12sUqZRj8bltDgX2hNHb5RB+yN670ocKgo9F5SfGmcQZu
         VBhppOW7Y108c5m4voaEYT8Ukukz6N1y7o8+vSaoLo8a+irehcbyjoNDgQJ3Gdh5XViW
         4WxA==
X-Forwarded-Encrypted: i=1; AJvYcCX+Bt9j6SBsvuV7040my6Ia00QXJWiigC/55LgHhxgPi+A1Ms/ag0XXFjwqQVSKvgkqZ8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb6z3BAFvldOfVW2CJt/gVfcJd88tY7t7er8beCLsrxQjMpIrC
	gXsJocGZqm6oO65R9e+ZXisUElGH+c8+MFh2HmJOEKHh8s6YxzcOHNm3x2U43nE=
X-Gm-Gg: ASbGnctgfuamfla+B1pnUK4lKRQ1dz86OBnRNJJnDNVd4xweynGEn41T9tLigNMab0q
	WauWgHSNN8VNAWQgPAnMZdSXRJ0d3xt3ffwtADfUL1oVtBvz0XVk7HM8Qo78Ljpd0DLveelDQl5
	mUyL74JTAzZgLdqe4Hj6aHB0gPYYlksYxwoZTH/4z8yn9V4DkkWBNOdYKqss6hYa2pTP6NRG2VS
	oi7Wu3nmj8jWnkk/u2WFiMbU3QG2iUh4fU3QN9lkZCXz9OLpOlsYF6fsjHP4fDiXpx9Q1o+5csz
	16BeQa0KzVi7cu8AFwrieOUVmyTlnmWznT+5rw51qvkFmmauXmfKc1894V2gQm/5tYYnCW43YfL
	0lydo
X-Google-Smtp-Source: AGHT+IFUEL3cvBn3Xa+5y9+6Ep9PHHPOhZ073kDTv8bDaXeS7TN4XiGHlAG6LN6mhNJpmz9BKqz+rA==
X-Received: by 2002:a05:6a20:6f9c:b0:1f0:e2d0:fb65 with SMTP id adf61e73a8af0-20445d26bb9mr3931698637.2.1745508773521;
        Thu, 24 Apr 2025 08:32:53 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:53 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 10/10] riscv: Allow including extensions in the min CPU type using command-line
Date: Thu, 24 Apr 2025 21:01:59 +0530
Message-ID: <20250424153159.289441-11-apatel@ventanamicro.com>
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

It is useful to allow including extensions in the min CPU type on need
basis via command-line. To achieve this, parse extension names as comma
separated values appended to the "min" CPU type using command-line.

For example, to include Sstc and Ssaia in the min CPU type use
"--cpu-type min,sstc,ssaia" command-line option.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 5d9b9bf..722493a 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info
 	return true;
 }
 
+static void __min_enable(const char *ext, size_t ext_len)
+{
+	struct isa_ext_info *info;
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
+		info = &isa_info_arr[i];
+		if (strlen(info->name) != ext_len)
+			continue;
+		if (!strncmp(ext, info->name, ext_len))
+			info->min_enabled = true;
+	}
+}
+
 bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 {
 	struct isa_ext_info *info = NULL;
@@ -128,15 +142,38 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
 {
 	struct kvm *kvm = opt->ptr;
+	const char *str, *nstr;
+	int len;
 
-	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
+	if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
+	    (strncmp(arg, "max", 3) || strlen(arg) != 3))
 		die("Invalid CPU type %s\n", arg);
 
-	if (!strcmp(arg, "max"))
+	if (!strcmp(arg, "max")) {
 		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MAX;
-	else
+	} else {
 		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MIN;
 
+		str = arg;
+		str += 3;
+		while (*str) {
+			if (*str == ',') {
+				str++;
+				continue;
+			}
+
+			nstr = strchr(str, ',');
+			if (!nstr)
+				nstr = str + strlen(str);
+
+			len = nstr - str;
+			if (len) {
+				__min_enable(str, len);
+				str += len;
+			}
+		}
+	}
+
 	return 0;
 }
 
-- 
2.43.0


