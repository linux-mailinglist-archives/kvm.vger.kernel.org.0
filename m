Return-Path: <kvm+bounces-16162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3EFF8B5D11
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4DA281BFE
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CFC130483;
	Mon, 29 Apr 2024 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ieLUpllq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995E212F5B7
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403201; cv=none; b=amj+nDfkbsNxcL2PabzpwJ5Xa+c2N/iivWOeUoCjphpvjWik2xwuQEsQAky3Q2/Mcun7F6Gze+Dtxcflddxx181Z6jbGe3XlYlPRHwqbCaGG+XLQ3mzsgUriXP/yzykLh9cDXTvZUNg9HkJiHZqxIjOtWMXiU2BSz5BcYW3z/A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403201; c=relaxed/simple;
	bh=u6ulU0BPQmNSIcLbsuogo6WHzBJ6ZqZxhPCHBhuLYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CWapTrVY53ewoLJkPfgzaqSoSMOuG5JQ67E4pV5asD57uL8Wv2ymK4IKhYPj1ivU+chCrGVanoMyVhJShszoAFp6jbvf82HPRR/421sddshyD6fm4XrnhdZRbfT+jec3w+Na1UtvSr0ARF3xnn3hbdpGonEzTftOXVIaHsOzdVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ieLUpllq; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-34aa836b948so784788f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714403198; x=1715007998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HO1pUvU0QFRoXzPxVhmpQLKjzbVC9RycGYDtZgzkuNE=;
        b=ieLUpllqsARfwt/7I7ww4PVq6V4fj512DDDiiNtBQYMKJ0pfEhUfQJpkZZRi0U9S90
         q7qaSK00zTLFkN5/PrsStN4/+0bjZTPqjP1Lui9fML18g9qa+z492lIZFSdRu5FZX5C8
         xYvIh6rW4bMkDWPjrz9wi1L1C8A/mRsT9rJx3dlPkziUh+pOth7BL6nxvlOMd5CuJJmG
         CQ3AUuqPNyipmYt1AldKBigKA0hDWu+XkhhX2cFJZXEjyO/DqKNHmnSY5cnIhG/gST6q
         Wk/Bm0tozjLMKXOUqZQ70kpZkUb3S+fOk1mPmw9jp5sTX16BKo54/4YVT8UwL+9xgcIk
         nj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714403198; x=1715007998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HO1pUvU0QFRoXzPxVhmpQLKjzbVC9RycGYDtZgzkuNE=;
        b=sHp4KVbBIoGopA7KX2Wj/bGk1rKCY8Kzr3yvQHt/xEhfdYCIbdOv4t2om3LgA7zTvi
         cHkDWWJFD4ompb+/7r+WpZ613RoeG9+b2ECaGazi8XGofeRTy8zOShYJnbKnyG60q+MA
         R2tnkWCdUK/NzGcYKn/sggTqX0uxASIN+UiWC3meUK9EL3PRNCJvhEZVb0ZPlZ1Safs+
         BMmHRHKED5Uo/ol4nWq80cPIilIeQn8D/EhO0K+tTeTxCufLLGW6Q7pMgShEDJ81vdtU
         wUDubx+0hFpTqi+hxP0ipbQDbPcLj4x2nDbTqVYsr4XS+FAK/9U95oH+QRT0qWhu4JcO
         Rtuw==
X-Forwarded-Encrypted: i=1; AJvYcCUUTW7xzz+oI79E8zpUAP6RbHVuz3m7w+HnWkCRo4x7OzZA1KJatwIGNWldD/BEk4Zx+T1OfsEhc6s6Nto8c+Ew+z0r
X-Gm-Message-State: AOJu0YxKnuX3QDaZjfxWTRA2DU2RQzJjhtuDF//pQv6oEknhzTJ19T6U
	VT00Um8GLDjAFMmhuSgDsnN/zMMvybPsb7KuzHWJkDgSVChqRlgBJyMKOLn02F8=
X-Google-Smtp-Source: AGHT+IFiWS0wkp40gKDZAfxGi0j9Hx+FE3RcRH6ARajQSpFlwAjMjBZPph1zEUrLoQbUy23CTem/ew==
X-Received: by 2002:a05:600c:3b17:b0:418:2719:6b14 with SMTP id m23-20020a05600c3b1700b0041827196b14mr8083792wms.3.1714403198041;
        Mon, 29 Apr 2024 08:06:38 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:2fec:d20:2b60:e334])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b00418f99170f2sm39646638wms.32.2024.04.29.08.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:06:37 -0700 (PDT)
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
Subject: [PATCH v4 06/11] KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
Date: Mon, 29 Apr 2024 17:04:59 +0200
Message-ID: <20240429150553.625165-7-cleger@rivosinc.com>
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

The KVM RISC-V allows Zca, Zcf, Zcd and Zcb extensions for Guest/VM so
add these extensions to get-reg-list test.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 40107bb61975..61cad4514197 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -55,6 +55,10 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBKC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBKX:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBS:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCA:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCD:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZCF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZFHMIN:
@@ -421,6 +425,10 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZBKC),
 		KVM_ISA_EXT_ARR(ZBKX),
 		KVM_ISA_EXT_ARR(ZBS),
+		KVM_ISA_EXT_ARR(ZCA),
+		KVM_ISA_EXT_ARR(ZCB),
+		KVM_ISA_EXT_ARR(ZCD),
+		KVM_ISA_EXT_ARR(ZCF),
 		KVM_ISA_EXT_ARR(ZFA),
 		KVM_ISA_EXT_ARR(ZFH),
 		KVM_ISA_EXT_ARR(ZFHMIN),
@@ -945,6 +953,10 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zbkb, ZBKB);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkc, ZBKC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbkx, ZBKX);
 KVM_ISA_EXT_SIMPLE_CONFIG(zbs, ZBS);
+KVM_ISA_EXT_SIMPLE_CONFIG(zca, ZCA),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcb, ZCB),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcd, ZCD),
+KVM_ISA_EXT_SIMPLE_CONFIG(zcf, ZCF),
 KVM_ISA_EXT_SIMPLE_CONFIG(zfa, ZFA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfh, ZFH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zfhmin, ZFHMIN);
@@ -1001,6 +1013,10 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zbkc,
 	&config_zbkx,
 	&config_zbs,
+	&config_zca,
+	&config_zcb,
+	&config_zcd,
+	&config_zcf,
 	&config_zfa,
 	&config_zfh,
 	&config_zfhmin,
-- 
2.43.0


