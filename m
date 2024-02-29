Return-Path: <kvm+bounces-10331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF87B86BDF8
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64631B26302
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841DD53E0A;
	Thu, 29 Feb 2024 01:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="cTPAzz74"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB5250A93
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168522; cv=none; b=UmHdfELgcQTm8YAD24qtp4SBV0N5t4u7/xQuXsTPQv355JkROOcdKeW+OCSVO5hMVB0NlxK7sGxDMxC1awoBgGIkvCVDtlTQv2luCdtCF/Z/L6WYDIcZlkiwu7IyY8S8LXkC5zr/Qzc4NwE+F1yO06JVAMnbtTMb0yR4fL15NCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168522; c=relaxed/simple;
	bh=9zwOLVexvBGlI0m4Mhk4kV7ojBkQ2+FV0JWidMYV7HM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ht5SWKuGltO+6GiEkpXs/IiPvcdLypkahClylAG+1UYUbDWF5oqXzsYm0tj09924dLCQ2LzgEBeAPV68sDR+BRGc1GMFc3EBaW+6FNQmLjsjkNl2VeddMp/8dXNbsIur54UVDVvqKbajzBSNcO7RV3FmpRLghWEEqhtMNLWXn2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=cTPAzz74; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dcc7f4717fso4049325ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168520; x=1709773320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wdj/IM2T1N8fRp4s3UGf7t+cLrV7XEBMNyC4UJYNwlU=;
        b=cTPAzz742v5noWkl/GKyyby5rhm+NPSvb/mpYmbIPKTwinD/XXF8QjSAtm7zCkiYR+
         iBIyNoiTN0Sraa3HAvNZpqiPzoTY+/1kQkpp0WLbIoHqwJ3DhOmHjvXlxa2SlbdfYHsv
         Tncu6CLSK9hnTkqq2VJ8+zrCc39rrKzoxQN9l5eZ15llj/VS+VD+VcdpzWkYzvvjLvIN
         uuBeBX/5WyyWxuJ0Z8Xo3pjNI3jblaaOX/y5ufJ4MCHlc0HSPg3oceuckz4On6/IJAcW
         LdScHRSIKK6L43g1kt3LZ7YpgF1zsWuTxd74x6Teexw8ajhxc8XmK9hrxca4HNTepWz+
         Fpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168520; x=1709773320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wdj/IM2T1N8fRp4s3UGf7t+cLrV7XEBMNyC4UJYNwlU=;
        b=FGz7Di0e/ockvnBEES9GdtJfX2OKmOaM43gAZQWH1c18STcuZrqLNBXSHF1yr43aqk
         HloP6G/EOW2YADa5Zn3m+kHy2VFdm5dpIiNtNesss1LTZ2Q1lEr0L0HqU4hGk8BbOfHW
         tUoJLfHTRn+vCgA9FavZDnWRjzDiNy2aI/BSMWtNIFTmi4XGOcS4Y9EbC4uFFeSAO8YA
         U8eYDTwSmShigtbh5TZCpC4Rs6/1ff798FNvlUbJw37cpO+GvQ6gZCz1y7SslQBio7zr
         fuMoP6c7M1xntS8yoYlohX8B+jcd+HM+j3WHnCt6sNRld71a1tpoAwJ76TOZp5nEC7et
         9PAA==
X-Forwarded-Encrypted: i=1; AJvYcCUTlE9s8l4+Ch7SGvbhJ5HzZy64buPendWgD1M3VZqEFOq75ir2RLh3Ze1J394AeIJj9kqlC/IqCXjKBrBvhFCDt8jQ
X-Gm-Message-State: AOJu0YzH5BhqoraSvbPG4m20Ew8wIcfHax8druIIl8E14sq2Y93NkuRs
	qdOPglZPOxHe8/pNunnyOAU2u9ly6OLRDUC0uEBfFn3XtpGO3ntNQ93E2xjpjTs=
X-Google-Smtp-Source: AGHT+IHtgz/3aN9/6IGHFaoY3zOkodaD7W2xNlaR8Hf1IQmcwst3CPEKmznAT/uxd+CVNZPaUomG9A==
X-Received: by 2002:a17:902:d50a:b0:1dc:d515:79c8 with SMTP id b10-20020a170902d50a00b001dcd51579c8mr691775plg.23.1709168520546;
        Wed, 28 Feb 2024 17:02:00 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:02:00 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 11/15] KVM: riscv: selftests: Add Sscofpmf to get-reg-list test
Date: Wed, 28 Feb 2024 17:01:26 -0800
Message-Id: <20240229010130.1380926-12-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229010130.1380926-1-atishp@rivosinc.com>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Sscofpmf extension for Guest/VM so let us
add this extension to get-reg-list test.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 8cece02ca23a..ca6d98a5dce5 100644
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
@@ -406,6 +407,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(V),
 		KVM_ISA_EXT_ARR(SMSTATEEN),
 		KVM_ISA_EXT_ARR(SSAIA),
+		KVM_ISA_EXT_ARR(SSCOFPMF),
 		KVM_ISA_EXT_ARR(SSTC),
 		KVM_ISA_EXT_ARR(SVINVAL),
 		KVM_ISA_EXT_ARR(SVNAPOT),
@@ -927,6 +929,7 @@ KVM_ISA_EXT_SUBLIST_CONFIG(fp_f, FP_F);
 KVM_ISA_EXT_SUBLIST_CONFIG(fp_d, FP_D);
 KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
+KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
 KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
 KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
 KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
@@ -980,6 +983,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_fp_d,
 	&config_h,
 	&config_smstateen,
+	&config_sscofpmf,
 	&config_sstc,
 	&config_svinval,
 	&config_svnapot,
-- 
2.34.1


