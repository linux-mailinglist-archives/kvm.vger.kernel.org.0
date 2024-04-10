Return-Path: <kvm+bounces-14100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE0889EE69
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E55AB24166
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8398C15E7E1;
	Wed, 10 Apr 2024 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="htGHThrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245315B135
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712740280; cv=none; b=Svwu5tfuZGejFFWL04Fy5W68kn3oUhUoTT+vrSBvQklyIrgl9m6NvlV2AbRAaNIWZaRn21YxR42sznn4Bz5o3vzXtt+BbmcIBVsDC7okwtVhjqKlIREKzwn5j24ghTy52kl5uTGJSF4gMefM1PQvr2WXaNcnXffdYjKDa6xvVoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712740280; c=relaxed/simple;
	bh=bL0yXhZgH/0/PkNBvTy00J8zOdW+K5v1x8a4cTFvpqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/+ayS8TD+KLefVlFrdAbzEEFZ8vyRhgsaJrmofK/SB1YTzIUyklZ41Snd/fAtMbwakz71sJQWWe/WDV1lGgjPLho2ZUrGsTkEHe+jquOCdQkSZDqVDHg+6ITHQ4P+c4QQcCqrO9GTE81ARGYtxYBRhlnh45C5REkmRDr8KEH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=htGHThrK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-343c8d7064aso1125251f8f.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 02:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712740276; x=1713345076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Bj6qFEBTQkW22oNb4zguAXGn3Gn0KYF9aSmL0IcZwU=;
        b=htGHThrKH3aJXSd8MMxCynmfLVxPlj21oWwoBB6Tc8KA61s2IGOXIS5ZAp2c7XFu/L
         4xOUm3PlBrQDvfghdzG8VDCyZlmpJbCoXUdX9rZNMxWZv5sBtizqf/Uyl2pxcGCtmbHa
         s/GsS6VmqOXJdEwKz9tC7TvwB7x3JFDYMmbXkYTDCAXqUYmtaXYgCMr+n6lSxjWVbCvB
         gQyUxcz0a2lwNL+Ob5/wm5uxw1XpGdwxDYvbz89KLpNrlKqNZebuZtORdVFWLOSeR1jS
         YXFZREoYIRbaNJH+viItZW8razKORT67r/z98TOT970BGGoYI2pLUC+8R77W9nSHaYcI
         ZPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712740276; x=1713345076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Bj6qFEBTQkW22oNb4zguAXGn3Gn0KYF9aSmL0IcZwU=;
        b=C5laMijOhOflxuDuAZqAFvyCLYKsO785NIRxbBqVC27SATlKsPQb3yuAc31WjHniGx
         1Sn9EBz4u88yesaE8ujJ+AxQTp7a1iNLHK+ViallwnlotuVjTkisYsBqSwz+AP6OSj6u
         kzIvFXSOrgDYp7iDWMg/t1gt8kglKCQ1bfCPOYR9F4uw7gp4REtWyLEoXsDtWEHVxcZF
         Wmita/uDjx0Bl3OQ1NIO11NWsvTve+6p7wVd7JBnuOGiAksvGMa4wTGYKyhk7CpkTKr/
         Aqn8HgaKt9TmEvcOv0PQztKaalPBQUHhzdW++ckWao8j55lU2cyq2hdSLwGRPqklOb3+
         Atyg==
X-Forwarded-Encrypted: i=1; AJvYcCWFpHAbutljpALhg+VfEiSXDYA7jCAKoVcR23bsgMEB5pfWGnZ9/OBnd1FcmzNk8l7U5SIviWpAadM6TNLIr45NBSNQ
X-Gm-Message-State: AOJu0Ywd/GCQj+PpIE42h8f6VMQCNaRu3gbKrVmJHLBy5cAJdoN4M+Rr
	d/J0QyD5V4L7JFJOcs0DqOJbcEZTSzkViubqXlmuYbLTPOPJMlaAxr33f1aMSFQ=
X-Google-Smtp-Source: AGHT+IFAB0sJwJ6MYsANct+Q6sx/TH9SG9iB1/Tv2iCf5OGRfMeMXNSvy6Zvyw0SeigYNf2ZXmUcCg==
X-Received: by 2002:a05:6000:1448:b0:346:65dd:55f5 with SMTP id v8-20020a056000144800b0034665dd55f5mr1201789wrx.2.1712740276476;
        Wed, 10 Apr 2024 02:11:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:d4a6:5856:3e6c:3dff])
        by smtp.gmail.com with ESMTPSA id d6-20020a056000114600b003456c693fa4sm9079086wrx.93.2024.04.10.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 02:11:15 -0700 (PDT)
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
Subject: [PATCH 05/10] KVM: riscv: selftests: Add some Zc* extensions to get-reg-list test
Date: Wed, 10 Apr 2024 11:10:58 +0200
Message-ID: <20240410091106.749233-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240410091106.749233-1-cleger@rivosinc.com>
References: <20240410091106.749233-1-cleger@rivosinc.com>
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


