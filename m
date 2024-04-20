Return-Path: <kvm+bounces-15400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FB48AB7DB
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B784A1C208A7
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4E614D422;
	Fri, 19 Apr 2024 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WpNrGv36"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053614A617
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713570501; cv=none; b=JQk/toorBodnc1Flu2p8J2Jz3k/9bAoriQ0hR3YgqdlleBSyOttI56e45JMyEYUTm0xcndgv8JBHOzRhpfrhan6WyheK3PpOwwrIT994nC6lEtxXE+fYCBVXyiVfZI8kVmUmG5Bu1jXqfmGjzvnx3UDV1nq88Rvj87Y8QpmM8BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713570501; c=relaxed/simple;
	bh=kGDqdfAz5O6jd2BlwqWEgDKuhCYmFyrLfaexp9eWGuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OVJU82U79oFRZkM85MzmYjKJFUkdwRm7aCvlTdjUBJhXrua2L+C/v49TVGFMgNN9+B9qmtEmtdF5Ag332aEJV9iyZFQPUv00d96CIxHtc934oIEdf6B9kVSxok8E3vRJHGic5nOqxcVDwHgChRnr6fL5Ex13W1mamjQ92Nyk0WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WpNrGv36; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e2c725e234so28949035ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713570499; x=1714175299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZMdAGbGUb3Pn/mM6S9aCTNbs+MKWuMa25SVPrHMqxo=;
        b=WpNrGv36H8E/UYzVROVYOaZ1ziS+X/bZdoifrnVDXCUBclz4bA6ZyhCjpTg+Gkwanw
         jklDpJ7yEL7d9EFdZeCsMkRX6H5DomteHdqUndm7ce2rZFRf/OH3B+CL6mW55BcphVXH
         zQweK/pqGTSTzwNeRJz2HyxSbtCBAWk284oVHJSeafx/s5jTHJ3mGN5CduN18HQXppHm
         L0sjED0RezxSawtoZj1wDeE1FnkBzKJxkRDSIlCrm8sOQjBZq/a77smnqXsZUXcdSyD0
         oYukYG7LUEmYGV/fy/vFpwnKymPIYuayB5xbTU7uEZhbaVw0U5tyUhQjObfPavFC/0zi
         4cWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713570499; x=1714175299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZMdAGbGUb3Pn/mM6S9aCTNbs+MKWuMa25SVPrHMqxo=;
        b=kv6ULy975g9jkdBqqBLwq0hf6JDBaQ7x/B+u7pjOHCJuc4sg4iBBwoRNrkbNl6fnQ3
         5kLjbFZMhWncUQ0+pw5laqCJ9bfTW1GlnYEkfk7+rQPxUZ5RYZ9+0LmKg8UGfySXleE+
         xcwPIcGb3P4vCBRCKhDEGnYT6gQKqUET/asudU2Q9CGVXsWTeBFvJRdikDF4nzl6zBAj
         ZiZAVboqtvyA1Twe2CJuwSpRuwCgKlwx0oUrLI5gpOS5eMu6jTgrh3/ruAFcPGOy8BVM
         /+1GEOR+fK1RIXMVE6NbGwsUAt10t3BQ4r1Yf22ISJTvDLXzJoZdBc7OJAbhBEWmYK3j
         ZTQg==
X-Forwarded-Encrypted: i=1; AJvYcCWeJqeyCocz02sWe4n/Y6kiih6n+0ZOErGPwCKwgt63lXksGmf3zTpyvODYeCz8oWr487N1EV8YaDyoqUc33fmKjFA5
X-Gm-Message-State: AOJu0Yx6QyNRKEMBccz2KM/FaXJkebpOOMb/RrJY39iH52jwgnOKZ+r5
	OP9t2Ft3lzBMuyxtB1sucN1i2NHp91wGXmq+XV0s2wK6dKsa1HD1Cfua672DJE09c1Ba1c3ST7M
	1
X-Google-Smtp-Source: AGHT+IH94ZDu/qiw6Yoj8MWg6zwqoinf1KpfcrzFJNX+17e2PlQXtFOUT/DN+eICy7GP3aaT34hoHA==
X-Received: by 2002:a17:902:d50a:b0:1e4:1fb8:321f with SMTP id b10-20020a170902d50a00b001e41fb8321fmr5727941plg.20.1713570499356;
        Fri, 19 Apr 2024 16:48:19 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902d11100b001e42f215f33sm3924017plw.85.2024.04.19.16.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:48:19 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	samuel.holland@sifive.com,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v8 19/24] KVM: riscv: selftests: Add Sscofpmf to get-reg-list test
Date: Sat, 20 Apr 2024 08:17:35 -0700
Message-Id: <20240420151741.962500-20-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240420151741.962500-1-atishp@rivosinc.com>
References: <20240420151741.962500-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Sscofpmf extension for Guest/VM so let us
add this extension to get-reg-list test.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index b882b7b9b785..222198dd6d04 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -43,6 +43,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_V:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SMSTATEEN:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
@@ -408,6 +409,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(V),
 		KVM_ISA_EXT_ARR(SMSTATEEN),
 		KVM_ISA_EXT_ARR(SSAIA),
+		KVM_ISA_EXT_ARR(SSCOFPMF),
 		KVM_ISA_EXT_ARR(SSTC),
 		KVM_ISA_EXT_ARR(SVINVAL),
 		KVM_ISA_EXT_ARR(SVNAPOT),
@@ -931,6 +933,7 @@ KVM_ISA_EXT_SUBLIST_CONFIG(fp_f, FP_F);
 KVM_ISA_EXT_SUBLIST_CONFIG(fp_d, FP_D);
 KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
+KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
 KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
 KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
 KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
@@ -986,6 +989,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_fp_d,
 	&config_h,
 	&config_smstateen,
+	&config_sscofpmf,
 	&config_sstc,
 	&config_svinval,
 	&config_svnapot,
-- 
2.34.1


