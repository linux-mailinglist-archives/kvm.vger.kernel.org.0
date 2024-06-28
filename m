Return-Path: <kvm+bounces-20661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C2291BBA5
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E796B2814EC
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA9B156669;
	Fri, 28 Jun 2024 09:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="YR9Mhgsk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C827155CB8
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567497; cv=none; b=Vn9w5aRHiXOyH2XNqTde8SHBh0cju/u1J4QHjZW3I93RoqtqAF+w7FgXVx4awQWC6LhLclmtPBpoQt1LP6KzZBOKIpFZ5q6p6B2wBBKdsVzpmeH78LZT+3k7jvffQ90KbpyMBq80xkKb0Vh+UyHIopLxSQdQZdPRfUczd4ZkvUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567497; c=relaxed/simple;
	bh=rAYKbcFrJvZXsWHsMuE+Qgzs7qeLTNluD8iqVeBQttI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Kp+bO1GVU4IQW0Jp2xQOIgrzXmRGnJ/IB6+wsMs3jld9st7/areA35r+k0DhyI2RjYXkcQfa2jKn6gmFtjvlAhnTxIMFZLh0xMwK4H5Ej14ONEIn4vlccu30rHejn5RyUGynt+IFu5qT2hkW0XQvOXD6B7umwBGZZQUyjvrW+4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=YR9Mhgsk; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6eab07ae82bso260397a12.3
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719567496; x=1720172296; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PpDCA7CnSWtIO6seFJ4J0hDKtH06inwXMPU5CaySLhw=;
        b=YR9MhgskAfBll9YVySYF9m74I5u4YR5ecQ5lDKH4PtLhrsPXyL/IglGduE9YLGpMpU
         0HV/HvK6tF97pojzwnjS8LNQf5Fb+69hu+tCuTtAxLmJmU5wHuh11g0X6JExpsDsYdUR
         67qYsQL69NXvPY5wBMXLNGwvlC3s81rlUw5FOqMlwKE69nDSXeGt+oT69mDYXDsKrjRP
         JZbagdpzsNGC0Fkr4orlVwPdtv2w43KHh3CZIRZVN4TUQaM6VLj+oKgguDSnsdLjtYEW
         zWX08+m8N/ysbYSI3iSekZuYzDHbbUfsd5TXhGbl38fLV1dhTnUcrkzP6tGBwaX0U8WI
         2/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719567496; x=1720172296;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpDCA7CnSWtIO6seFJ4J0hDKtH06inwXMPU5CaySLhw=;
        b=ARfiAvN6FBKwn5twYtlAIU9aYSljA2/acCd7BmyprIksWkQc+VNwtuPSESgu7SbFRN
         vu0m5DrTiJ4MsSroZ3PbTdjaY0n3i6XuoN/AuWOkNL9Z6V5HPHlVPoFbzLNE1zJDbfKP
         z0ds6FV5KpeC5EFBEIBCe3XP6HaQJVttCPOCc1DGGxlXSsdif4LFPle6A4NtKHYGP/Kz
         xWBRM0KuTc30dGaCJRFirhCWNDnvdUQcQfoxFI/1B1k6GTUCJHN5Eq8Y2RR2vC4oGx0o
         wPeV+fLyl9S+MowjITj3FKWUBVRCyq190i9GTuYG1BknPSEJKY3MiXQqRGkXL4XSRiqK
         3AFw==
X-Forwarded-Encrypted: i=1; AJvYcCXUq5qsh7mmIet8wsyo5nrXYNC9X3057wHdZtQh7Y8Xp2FWI/28zvrHzFlFC4CrzmSI/yHpOrnlj3ZZq+DidH3STNQe
X-Gm-Message-State: AOJu0YzpNnuwwCGaN6wHkp3B/H9V2pqnaz6VyeUaHycFodCUANLT6eNL
	FFbzN+P8jxEsyBRvkt1mpxaCqnwBC/9Mjd4jafoOywP9EIG1NCCafwu924623qpIYnv1aG1Iv2x
	O
X-Google-Smtp-Source: AGHT+IG3L14BlCwHPiIKSplLpOkLLGSwZSlMj6M+WV18XsZAbw/WIXgi64YPVTn0Axv2MFnAlS9dBg==
X-Received: by 2002:a05:6a20:45b:b0:1bd:2703:840 with SMTP id adf61e73a8af0-1bd270308damr8420473637.33.1719567495751;
        Fri, 28 Jun 2024 02:38:15 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10c6c8dsm11087155ad.26.2024.06.28.02.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 02:38:15 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 4/4] KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test
Date: Fri, 28 Jun 2024 17:37:08 +0800
Message-Id: <20240628093711.11716-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240628093711.11716-1-yongxuan.wang@sifive.com>
References: <20240628093711.11716-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Update the get-reg-list test to test the Svade and Svadu Extensions are
available for guest OS.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 222198dd6d04..1d32351ad55e 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -45,6 +45,8 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADE:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADU:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
@@ -411,6 +413,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(SSAIA),
 		KVM_ISA_EXT_ARR(SSCOFPMF),
 		KVM_ISA_EXT_ARR(SSTC),
+		KVM_ISA_EXT_ARR(SVADE),
+		KVM_ISA_EXT_ARR(SVADU),
 		KVM_ISA_EXT_ARR(SVINVAL),
 		KVM_ISA_EXT_ARR(SVNAPOT),
 		KVM_ISA_EXT_ARR(SVPBMT),
@@ -935,6 +939,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
 KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
 KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
+KVM_ISA_EXT_SIMPLE_CONFIG(svade, SVADE);
+KVM_ISA_EXT_SIMPLE_CONFIG(svadu, SVADU);
 KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
 KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
 KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
@@ -991,6 +997,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_smstateen,
 	&config_sscofpmf,
 	&config_sstc,
+	&config_svade,
+	&config_svadu,
 	&config_svinval,
 	&config_svnapot,
 	&config_svpbmt,
-- 
2.17.1


