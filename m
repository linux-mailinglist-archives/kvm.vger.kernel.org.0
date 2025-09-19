Return-Path: <kvm+bounces-58119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4461EB88349
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B22013ACB36
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D2C2D2383;
	Fri, 19 Sep 2025 07:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gllcGJn0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699D92D3217
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267461; cv=none; b=RyFOQV+u1DHKTfKoFSBIsuaDJ3/LtWnLMM4Bc+h/IVhBobsmGUmV7wEU49ljaqzV6EfazdK+iEWSDhlUjhd1TV2R19O4o/nB8+SOoYcjtC5fVoO43n+uD4IkCyc3rvk3E7dHqAxD4e6R/7eJ/Gy1iSjtY4prR1jHifWJSBmMDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267461; c=relaxed/simple;
	bh=AHBUSWC6NQwt5gipootBG6lu9YU2EyCEcBy5+RZx010=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsGtUXV8+Bz9SPI3c1LUw8JlyAUBE8KIYMswFNmm2EoUaHJ9/+9IQQT5TfWN6B92m6JnNIqaWqTWksgSf/w3Z2DGn0Sel78WHvuI0SUdrHW/HA7x1iRpT2RaSMwyAG5bg6dEXdmw0qY0Bqx1n9gf/Mu1W5/vzbR9JeBz+Y4NTZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=gllcGJn0; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso1418491a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758267460; x=1758872260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4l4TBk/LGXRpjovIOSrhrLfanQNTxjIirl6+Uo+sE8=;
        b=gllcGJn09UVCHw6TO3crg5th31HrYA6XFrKKbFQJnThh1EcSieCckcpfi+kDmYEgdI
         l4fdMRU8Sm0yU7bJB5zd3GWz14lg9sVydri94GTknI6lzxwKXkRjZCnGvFmFXsVU03Gc
         Ok1nisTt4VKl5x/Pg6Ga1tK1vLtaKfaPh/5CFSkFd7xyVdpKcJZSJIxlsEtikQP6UOYX
         qm6UQ04BfM8LZoZ2WN1HSOGRnizzrwqMGR1PYCVvPLJbiFelsXCoPT5Yq7ODr3TWBj5x
         WNXEuCYNbOAbykwmaNnH3qhHm+FQsFzQDW6j29/KM4d1w7A77dt/JF7PVGHpjnukelyq
         OAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267460; x=1758872260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4l4TBk/LGXRpjovIOSrhrLfanQNTxjIirl6+Uo+sE8=;
        b=bpoo+2On3uSi+qv/kSuCnc7aEDRl6S04PLTyB7C79xa+h34z06cLkm49lxwq/rWh5C
         edDdfwaJobTZ8HRbPR7U/AYnizrF0SyLf7PnEb131fEYCia8CsKvE0qA6K+SBpt1eMhf
         xkmVdFnpwcA32KScj+Ja2Rdq5a/Q3lhGsvVVJHtby3+XkosMp2l3ltoDS6PWxNYz3ThO
         pZ15Sis+CTBjZhJ8tOtg5bNzxR6LOaFbckTLyQTpYCBc+Ca7Pm+KubnivQUhiELoWoIQ
         LeyBvv5WhPqAgkX9k5Zunp0V7OqxER3CsVLs+Uom2J/kaLV4nDxc8SeHUbyFV7ft/mMU
         iymw==
X-Forwarded-Encrypted: i=1; AJvYcCUnloRktOmTHtVdmLHeRArChH8Hl7ELdMkcl8J5L+2rtsRvqlBo9irXVcS741Zuy95ig9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2QcngzAGcjnkKlY3yF9NB8o1wGr/ElgYww9eSPonpBnaJoC/N
	K7Fn5HfE4WSCHT0Pqp48tSdiX49x9TKcel4OvKYvWl7AmwMMbSf9s027XfDGzp7Ubpo=
X-Gm-Gg: ASbGncv+vlJXvTSdtHWINVETjygJUzcBgTzG4wBYODJrQezOnXLa5e3AvoTlly2Gmgi
	5dYq2PL3hk1sywoY7Rt7L4H1VHrdycBbAAcnh2qIIIbQPKCchD/zQtUg8ngcXWX7+LG25PdAgNU
	8DLnvvujRCPs2IKU5nKLtlnSOFZcS1xmtErTjUxlB0du4OsodZQQMi8GfsfbDS8vbIGIM0a9jj/
	rQzp9PHeeV2Nb3oLZQ0hlLiQELhI5a/32406tUjEcWDAk0J6iLvCnsFQYBS3hauGH1EsAcduD8I
	ghSJQRO1x4oRZ2M+JgJe4Aqr0/saACrBSwZ+/8bpCSxkKB4IXx/rO9jwrNhUc/krz83pk7vpRgv
	pK9odfunQ4Qqy+hYiNSM3etaCk0Qqh3RJ0cGwTzTyOwLEAEeSZuVilJqo718SnujWbVS9x3iFb8
	7OGB+BOCQMft0wdxlXq94QCAJ2UNJPbIa/ELbROMq7mA==
X-Google-Smtp-Source: AGHT+IGqA40UuZYCJLJHFfbOR75YQDLCIeiJK76C6SxyMFnU0ZZChhSlvmZdfbgczrzCrLP8RN4dig==
X-Received: by 2002:a17:90a:dfcf:b0:32e:9a0b:1d1 with SMTP id 98e67ed59e1d1-33097fed9a6mr2718272a91.9.1758267459588;
        Fri, 19 Sep 2025 00:37:39 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b550fd7ebc7sm2679096a12.19.2025.09.19.00.37.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 00:37:39 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v3 1/8] riscv: add ISA extension parsing for Zalasr
Date: Fri, 19 Sep 2025 15:37:07 +0800
Message-ID: <20250919073714.83063-2-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919073714.83063-1-luxu.kernel@bytedance.com>
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add parsing for Zalasr ISA extension.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a3..ae3852c4f2ca2 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,7 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_ZALASR		100
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 743d53415572e..bf9d3d92bf372 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -472,6 +472,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zaamo, RISCV_ISA_EXT_ZAAMO),
 	__RISCV_ISA_EXT_DATA(zabha, RISCV_ISA_EXT_ZABHA),
 	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
+	__RISCV_ISA_EXT_DATA(zalasr, RISCV_ISA_EXT_ZALASR),
 	__RISCV_ISA_EXT_DATA(zalrsc, RISCV_ISA_EXT_ZALRSC),
 	__RISCV_ISA_EXT_DATA(zawrs, RISCV_ISA_EXT_ZAWRS),
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
-- 
2.20.1


