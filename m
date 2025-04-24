Return-Path: <kvm+bounces-44189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D57A9B261
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBDE94A4515
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AEC214A91;
	Thu, 24 Apr 2025 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bqlnHlkA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C491A9B3D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508748; cv=none; b=ZnnnSU09VG+jyistz2C7jwDagcf86ryHIES3GkOxVHZ3kGObiXMuqVAcCc3mlWFsA5ZSpGLryA4tSPh0jKTa94UQrhOqtXFW7Wvte/KsPzN+iPwn8247lXn/AEwWk/i3AAUynTHMkWEJynFO+1lNvDP+OPg0xyt4zbM1iXjXyrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508748; c=relaxed/simple;
	bh=mM0z+Py5asgRfQ7PGAt/36YgTUgSINGwQ/hKbI4b/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8i6SKLV0MKNSgiwlGI31AcwoNy1nXe2Fy9qhaMQ5RxrBkdzJRv4utgKx6P9th4P2obADW1gvcSKGJCVpNkp5xkfCp57uZAh6OmpahRC36eeep7k3tbP1DSYxnxbz7BbGMZTGoShTtUN3I6PUeU2XFjUyR0iNUaWqOI8XaUJamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bqlnHlkA; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736b98acaadso1199768b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508746; x=1746113546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izVZE3MINqb+sB5P+aMg5WCU4bsWOfV4in60wkm/uDE=;
        b=bqlnHlkAFQxDC9TTgxP1zjgcilEHIhaNNkX0AVV5QVMfyv6ubPXUebw24FHu/QxRNM
         WFkylRlV9NMmKsc3s5iMgUHrjZaULkJjcvzD8Co+CVgwb6owJh/mcro1YHSeJ++XcPSo
         iSmGoQSbDVWDbH0Yc+QGw8Nocgzypl3dsrwJoZjFpvNi1Lvzrr3ULzClbZSV2800qRZE
         QuJLd7pjjDcDHUDanxb0reIjkRv5sLO1Va5+Okeso8WfkBR5N5uA4S882x/RTHuknOMC
         kwbOrJIsmRs/hE9przKt0nOXwrVZOthsPTxwquJRP1ea16qrSvoSGlAeD98GcgRjtvk4
         LA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508746; x=1746113546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izVZE3MINqb+sB5P+aMg5WCU4bsWOfV4in60wkm/uDE=;
        b=lim7Y0nS4mSEMjKKN2gkOg7+CgKCok6FnEIy+42RCnNW2F2AcyMwnyioCBLD9+1O54
         lGFFZsBSOXSrY/yp/9G78qcMggREdtTTsMW8wsof8B14dAEgWSdF8zdCoLqhWdj/bG5J
         QVTM8d3v7LZkYiukFrQZzUW/TRi1Puh1QaYeOb9cwUu8/N2gu7x1/KEnXXd32ejQ2lwO
         Y0/PVFy7vq03tT8ASEIOHIYbOHO8KZkgwpA6eRZ5qeEVlWCbJvvoL0YpJeVYhVV28FOv
         1JE7lFj5L1TWLW/SLEn0zYY2oEuvcdRxQMDfSvck2KLy8TXdwSVV6bKjX61We1rvgrSv
         kssA==
X-Forwarded-Encrypted: i=1; AJvYcCUsoxwN2BD3+wJ02QqludPd6ZGrw37ZAwC/XSR466+6In0lXrP2BaWTrp67XHe7szz3lmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAEywKVOA/Yj/l9Vo2EKOzNaiFzHj2l/H3KUKCGbUFFRfuDw8d
	2MppwRP7xdWiiED3LPrflS3oqdWzhk97XcFUQIvmt14JvGEKyoSLA/FyAYVry5s=
X-Gm-Gg: ASbGnctnUF0a8z1aK3rg0SSz1q00sD1/8gmDnZWyxK/xIZ8Amq9mvfCVsKC+f2BV037
	KxB7Jn0W0JDRs/NYz1IyOC/bma9Viv1XgeGinAwfWNJjWZAkrqu+UsKQrYmhTwmyPS3kQHK6VW9
	vpaBogcYGS1eWzvM3rSn0+45w3KaMluI3wZMCXkdf1hNhRAf5j4xYf63fi94KRsapWezFBQqdgu
	4oA9F0/oGTwxYM+lhWfHNoskFCW9LsHFC+h7HP9H9Vx/qY2/rPdMH+84PeguNofCzXf0+GVg//w
	LM7mkh7V+NRjOOLsi8KX+qaK5hj0J4JfVwbWtIESXQybaZd6aSMFXNUmaGaGjAU9cCdkGgUAu4t
	9tDtN
X-Google-Smtp-Source: AGHT+IEIo+KQcAt4FBEBc9biRhcHayIF0n3hD0byvs4INh+54nGh8ILdZYKcnUAKj0+pbTQOyH6fKg==
X-Received: by 2002:a05:6a00:8087:b0:736:a540:c9ad with SMTP id d2e1a72fcca58-73e24afd361mr4472196b3a.20.1745508746281;
        Thu, 24 Apr 2025 08:32:26 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:25 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 04/10] riscv: Add Ziccrse extension support
Date: Thu, 24 Apr 2025 21:01:53 +0530
Message-ID: <20250424153159.289441-5-apatel@ventanamicro.com>
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

When the Ziccrse extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index ddd0b28..3ee20a9 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -48,6 +48,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
+	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
 	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index d86158d..5badb74 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -121,6 +121,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicboz",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
 		    "Disable Zicboz Extension"),			\
+	OPT_BOOLEAN('\0', "disable-ziccrse",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICCRSE],	\
+		    "Disable Ziccrse Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicntr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
 		    "Disable Zicntr Extension"),			\
-- 
2.43.0


