Return-Path: <kvm+bounces-36659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE55EA1D695
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E68B18875E0
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CD61FF7D6;
	Mon, 27 Jan 2025 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hsZXkmQy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D29C1FF7B3
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984309; cv=none; b=I0JroE3TsK0XUL8ryv3uvtWsa7fifiKGC19SPaw7ifWedWgVQXDQBc445IgOLIYS5XK/AU5dqWbV31vh+Ww+8bRSRdXInuOHC79Cdj6ksdU1+hghxyePMndiHRFyVEhp9/Jh4y0rYpwicFhZZbZTZs+6K7edjGxryF8D19WE7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984309; c=relaxed/simple;
	bh=ohOC8GmOOlj+zRPNrtoqlc+GFSoK5kQme+m2VArIkms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pG15qqJK4wirfQRo5+5l+ZOP+lo/6OVS9jY1KEQ0EmRL2yW8wJ9+aifyI9EBvbD5tsdXKJFl9QEk6lftubzP5Mihko/Zi5uzE7ySafYcOSg9DWbL6GkJJAZ+OSLYl/SqJlCbt11DYnqEmhVX0WUvs5x3V8H487ZVr8bE4RO2zU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hsZXkmQy; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2164b662090so84389235ad.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984307; x=1738589107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLm0gl8QnGcQ7zFQ0FaNaPt8MyfRUgwPTIjeTPLiH3w=;
        b=hsZXkmQyffqxcE4b8vr6IkVzPZxD88bwovZzLFoy9X2YxzexpsHbhtG87jeXZdch1l
         aZxqu/vua5uUqqjBWG76LhuC4ZR69qtc8wlfg/6lQGaInWH05f3r2e3lMhdzABOHo2Tj
         jf8XHyUpmTNwl44KBChi19Q5hPapNgr8XBPvME40eYlewLwUzBX0vARNcc8X5AkjuSOR
         +1m49rwPI/CPxVJshcRAkpvTMFkFnaX4VBPJe3JGnGSvlbSzZdCoB8/UH9C4XgOw7FFC
         BJZXSj83xdve8pd+sNA4MMHqEWoB9Qn/BuHPhwIbUkYbF//hllontODizN15qY7P1E4G
         oAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984307; x=1738589107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLm0gl8QnGcQ7zFQ0FaNaPt8MyfRUgwPTIjeTPLiH3w=;
        b=LeEoEfywEbiVcyCOX6fL+5ipksdSSWUkBqKtdbYnqcEydWob7jhlLck5Kcumq4aG+M
         wK2h5SexAPh2bq6R/vcXMbEgv6LUPwIqsbR3vM5FwcoWTycZKeuoinpJwoNwPkA5B5da
         kzyYbauZC0uQeX+MZstYzRTeN2BU97rBj2lsxj8s0jDJlQlcr1EXrhYPC/Mo4V8+jww5
         /dbx43SAV/Rh1SYwtOsfIWFBoLnTa9CWIH7LCnNbPkyeA+v3BzZ4zJ+gWNxf5LVCkdYX
         Apexs39TmZZtePkjyqZSH1RpAKBOhVa90qk8fBbxRZwynchJOridVgZu+hCKxuHd/DVX
         OZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEaH7kF+lobZECKaCwgw1dPR/hJR3uifOkPWslvb7HsWRBztiZfD1isvRjf50Vi4kPSqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxb3BwqBQoKqP952XC/WYOr/eUqEzc+xzNj0aKsXA+m8N7pkZV
	gbuJSppy43Mf/wfc8Qjr1/SFC88Ph/dPjRtYzmT4QDYMhjIOP6T8ToX3bvkmXVg=
X-Gm-Gg: ASbGncsNlZbEF/Jh6yJiHc1bJUOlhNsCwRvIk0ALXFFF5xhDx1xww3S/JcvK0T4OWkL
	hBh+x6k0uDEZe17jxwdT/0Y4r2mZBcRQ6DvN6IBVLjKgzo/FFEm4/dwdP7AVkTZWzf6VXXxoAxS
	M3eVp5HY6+maU+AOoIixTgPfnzsMnTCO0M1pzgrmfWPlBEMxpNQKCp/iJeqKrwrC9vbqmEBGf6Z
	9AmaQFdF9TQJOO3gkkRp1J7p+AaOE83tTvtVMwIWwwdCXiBk3W6IJVlRIffxCC5g0yEDD05qs6R
	SIpueeszlMHYzo+0iUc/+JT0vyv6ZfWVmZvlM/L1kXX7
X-Google-Smtp-Source: AGHT+IFiGzZakhdLd1LspGV1QVZQ5QdzJe3CiSjx3xREUdTHgpSJnCrOlJjbHDpzw3fA6t8lwz8Trg==
X-Received: by 2002:a05:6a00:4c18:b0:725:c8ea:b320 with SMTP id d2e1a72fcca58-72daf99ec6dmr55413407b3a.14.1737984307586;
        Mon, 27 Jan 2025 05:25:07 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:25:07 -0800 (PST)
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
Subject: [kvmtool PATCH 6/6] riscv: Add Ssnpm extension support
Date: Mon, 27 Jan 2025 18:54:24 +0530
Message-ID: <20250127132424.339957-7-apatel@ventanamicro.com>
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

When the Ssnpm extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 4c9dbc1..03113cc 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -20,6 +20,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
+	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svade", KVM_RISCV_ISA_EXT_SVADE},
 	{"svadu", KVM_RISCV_ISA_EXT_SVADU},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 5eccdd0..e56610b 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -37,6 +37,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-sscofpmf",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSCOFPMF],	\
 		    "Disable Sscofpmf Extension"),			\
+	OPT_BOOLEAN('\0', "disable-ssnpm",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSNPM],	\
+		    "Disable Ssnpm Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
-- 
2.43.0


