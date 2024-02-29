Return-Path: <kvm+bounces-10322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964C586BDDE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5274E2820E7
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D2E44C61;
	Thu, 29 Feb 2024 01:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bgMFZF6y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126636AEE
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168507; cv=none; b=pjf60Udvr1lGKg2fy0b1mcJcli7V5GVmAJgxb7Q4ICuRycbNbEWrS6W1fQAOi3i2zRdeu3S4iQnIWQwMUefSXdOFdLPqeiWyP/D/U0813DzK8Kr7aF0Oh3L6s9P7kO4BOdVLjmVdu3GtNpvXOmPw8RM+PvwFNdlW2TybqhFDv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168507; c=relaxed/simple;
	bh=hew4y+I2ZwxnUWJiiBDPEFX0UFTuwMtFtu+Jm5jVN7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dmZGmuKRf0anpSbAgJFdA+zCBvk7nwIbdGzof3Y9yq4XEhvSXoPOeepj5K79390DzhqJ6JVMAZpQlnOKncdIdpjOBYRqRBUtsezVmw2x2rSMf77PI4cogS6zkO9j5GhW1EQNexGNkCgfQhBk5iKVKoz/nZv9kWRe6c+uhxbaRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bgMFZF6y; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6da9c834646so258361b3a.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168505; x=1709773305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLy+8VlwwjDgbFB2RXfd5pFPLlTjZXh8WK6dInm8wBw=;
        b=bgMFZF6yxUuK1LBakJg/M+If2xOwW2CZM5IqgXM6FFo0Wo44shRo1J78vOBKGVN5gp
         NiYiZRk90b0f75g/Ps/R4wCFNmlodDPbwESPQntaLcv/72U1qq5sCTZ0uaym+adJQaKM
         xTQJ6/LgSp8jvM7rEYvNUqqFFLOiNpT+nHTf2Jxq6ZQUM6oIvxTsBa8zNx5ZVxhy1Tsj
         u+/lPqFInfTg8FAKPDoCIRtsDt0wSHDt+5SC/4cLFS7TOAvwAfBNU278rgw+MjQVVP+/
         jFuhFLNOTZmIXcwuwta/RtAUPGNlp51rivm0E4DmfYuhLealQ1r1vOSi4S1FK2I90eUu
         EVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168505; x=1709773305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GLy+8VlwwjDgbFB2RXfd5pFPLlTjZXh8WK6dInm8wBw=;
        b=wJhfv1QdVpEfObNjHiYaiC2WBDLubZYqLsuYrQb2zWorcVJFmXOKOdQyphMpwucl1C
         p9apGVMkiQD7blYGinjRarZSONUxFfOWFHg+uI4Xxuq5zP5yA+KYt832+HOxuacyR5Uh
         8CZcdQ9Gx6+yN7/HNuakN/1XxbgB+b43Kqcw57Egubr41BJSmlmILzJK151j1LUcwc70
         GmbuliikgMWTYk80eugA/mv76B1yx1er7Izzq1FeQ3YiratGij8Dn3VeuCzDxaM9pmZC
         82YF8hsoIpuAmk9zTbsKu2bAap9hd8ZxXUPYsBNIQ/s5MDfIQbB5sP7rqCl7BpsdQ5xu
         rGag==
X-Forwarded-Encrypted: i=1; AJvYcCU2CcAWpmXcB7NTgJJFP8AkzX11SKqSZfcJBohOQyYNEemUuc2yBqM8qSQpZM1qQXLtRpnaEEcKxMtAuxbdSjG8umi+
X-Gm-Message-State: AOJu0Yx8UV6+TfcJ5yD9ASMyhhy0rPReDGRP/5uTirE7VFBJZ6L9pB8Q
	lE9PAv6T3bF5p2Q8lJk8oCfuIF6bdvrtLkPuWa1qCNLB3y2pnnQgBOrsIjDZ+Hs=
X-Google-Smtp-Source: AGHT+IGxkE16GaWCr7h3vOiqKSFFkVBq/RgbzEX11wPQh5/H9Sj4tZ1+Pt3HAldP7q69kBSazwBKRw==
X-Received: by 2002:a05:6a20:9e4b:b0:1a0:e819:877b with SMTP id mt11-20020a056a209e4b00b001a0e819877bmr1342746pzb.9.1709168505252;
        Wed, 28 Feb 2024 17:01:45 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:01:44 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
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
Subject: [PATCH v4 02/15] RISC-V: Add FIRMWARE_READ_HI definition
Date: Wed, 28 Feb 2024 17:01:17 -0800
Message-Id: <20240229010130.1380926-3-atishp@rivosinc.com>
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

SBI v2.0 added another function to SBI PMU extension to read
the upper bits of a counter with width larger than XLEN.

Add the definition for that function.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 6e68f8dff76b..ef8311dafb91 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -131,6 +131,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_START,
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
+	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 };
 
 union sbi_pmu_ctr_info {
-- 
2.34.1


