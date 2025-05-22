Return-Path: <kvm+bounces-47406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C29EAC1452
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DA467BA271
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D0D2BD582;
	Thu, 22 May 2025 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0p11iUaT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D1E29CB42
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940637; cv=none; b=pxZZYl4cNW49bTb4W9NDgilEQuYHoyp4973aBCpXfpSnJV0Bhdf3LP6mSk9Wvwa2vGk2c5nBEPy5+jByz4xqxVotYiK8FO4RdPLTdCmnplWBp11wAYX/AAtFHnruAUnPXtVNpAGem2HLiyz2R30xVD2qUafNcNHM7DEXEGhqeYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940637; c=relaxed/simple;
	bh=+prUsGSfboQFhKZbNUw86ACE/0BQoa8YLYJgH17nChg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JMfD45HIZ9jQP+MnmFvadkWLkyDnb/I8Rc4iZcfO6Edy0788XeRNIbvg+yvG74WII+vArA915YXB+bbniZOPn8PRchnyT3jglvx/T4p5mUw9xWZN4gPJcq0zGeZ2n2d70r7LPVRU6kb86GQ9nsv/D3emyW1NTw/G4rPYFeLurYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=0p11iUaT; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-af908bb32fdso163028a12.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940634; x=1748545434; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NL+JjaCkPLIbpCFGEZpnZEqKtEvm89wxDo8gtW9i88g=;
        b=0p11iUaT8U4KfYVX4wsHjz+PP/4MPkc1EZ4dobSvBL2m+uaZJu3V0I0YtNCbn8UEXd
         k0hct8l550QR/JewSlGF284F6tyolOwrOyV6Tt3OGWEaQA8O61FLbybHclWBmV/vg9B+
         adUL+2a0H5wxZc6X45yaHisMnuBV7YLT2pH2NnK4ZEB6L3dqFjFSk4o+m6lKprpHSy1X
         pmrCByxvo/SYlKMwe785Z8WQB4guoCG6qZxhcOQDnMBlGV4FQXpqfG14XfUtTIr/oHzX
         LLJ6Myecm6QOtTtPpYAJHCaFexbvy6PCOoZcRFxgRkwJDRwN9744e6wXGFs8CQswXe8b
         T39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940634; x=1748545434;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NL+JjaCkPLIbpCFGEZpnZEqKtEvm89wxDo8gtW9i88g=;
        b=n9+LmErBzaTpXNqSby2YCcHQjePV1mmW91EGR4aScPZMXkw8FLeZ1kJRvsKLAJaldy
         V4qPGiybFn25GHJclDQnJfmnt6QiD66pwTqc7R9ItDCMcopVNcs7Y5DACUvxEkpBN/UA
         c3uywcMP7HCipteUvuW/uC6DA+/xn7gx5D1bYhB3OUY5RKkvcHRjVQ0XZ/zNPVUuKT+s
         QKRL0G5pvX61Cr/V0wkAtmQ2CJ4i01yDByl3Zta4CZm2AyK7cv6v1WqQgpu7RSPrYKYS
         1zhF1h1d9BiBzJU5XeAzQ/mmAuejObXwE+rqH14KQrxuedlDbbYWFxTXpsLzLum9HwoA
         RPlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNEsU1cMp0lIOa8VdBmHv7EROAQJaykK82/ZT4i/kWYB3cJVUvGXC2I7DX8GjN2Yv4ijQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsgP2d0D8gH5PhAkO74RHpBC/tY4OzOo77AgOyZSCuSgzYc/05
	oWtGT45aDrrnkvNC+wofRENlyzuJ0rxDMrpmB+GHQYmLvYuDWyOLtMvEQcRA4ny7JoQ=
X-Gm-Gg: ASbGnctxHR2UapAl+75hHIvHr1AUWzwVE0AWYTuDilqfIF5E1PRVjgvjIsNG9rWHwdN
	N8KVxmAbwlRYYKhk5CvlAVZfd5yp5oeFVs/pQcdC5VzKkzMv/Fv9/yFpamLExsnbt0wX85y6DFB
	e7lmvMV4MvbaHcg4cuh5yqVUKMl4PEpG3w1+4sa2FRw/rCVeyq05bFmXYbYJ4nsj0UQuDCptz3R
	ILPAICPHJ2a5pl004+cNI4mEA1DRez/o3xf0vb87IqlfiawXEmpZ27uh0F0zaXWzLtIX972gW6N
	NoBGsa8TWiDcbBxV69MnrsGQGNfY0UfAQsBzqOs+1lQRj3xaI1NkxaqRMC+7yizd
X-Google-Smtp-Source: AGHT+IE7MkEZajOwtulJ1pSoS+YJGY/C1JUznV8zU99zjbdE3O1pdB4nhaqsx7X0UH6Pko2Lha+e4w==
X-Received: by 2002:a17:902:e545:b0:232:1d89:722f with SMTP id d9443c01a7336-233f067c489mr6091775ad.15.1747940634357;
        Thu, 22 May 2025 12:03:54 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:54 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:43 -0700
Subject: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Upgrade the SBI version to v3.0 so that corresponding features
can be enabled in the guest.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 4ed6203cdd30..194299e0ab0e 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,7 +11,7 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 2
+#define KVM_SBI_VERSION_MAJOR 3
 #define KVM_SBI_VERSION_MINOR 0
 
 enum kvm_riscv_sbi_ext_status {

-- 
2.43.0


