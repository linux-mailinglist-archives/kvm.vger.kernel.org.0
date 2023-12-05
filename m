Return-Path: <kvm+bounces-3438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4002B804538
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF2D7281194
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24268F53;
	Tue,  5 Dec 2023 02:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rhY+hiRg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45744109
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:36 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6d8d28e4bbeso1502126a34.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744215; x=1702349015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0t/9Xz5DiK/wXH2NqGUZGNOtmRM2KXduxsMbe0LSN5g=;
        b=rhY+hiRgeh/1Mf/In9gQYD8QCUPWj5f5fJw3PNkcHgOKcvUSSRsski2xZ28ICISpcx
         tSBr1mmxDtP2iTQ92wjrdaEQw7EYLSroqUbJfeIbPC8U4WX/7rfj7LgBZHuJ2EmAXTfe
         Ioa2oMUtrGS9yF9R8HurzNp7K1GL0LkHEtvscFgS+EZ8GM4f00uN3BEPQL0eJObse9Ch
         GxYlBmWIhUDPSDDhN9M/fgixu5pemWX4hSJ9HNTQ9A6yqO1pZaRhcTWLfHcCX1vkbulc
         OhM8JkU9H5BDp49zqmaTxbFYy/9Q48uwsu+/Fleh7D33rsyC+fBHdiQH7xwBKwS0YM4f
         SvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744215; x=1702349015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0t/9Xz5DiK/wXH2NqGUZGNOtmRM2KXduxsMbe0LSN5g=;
        b=bi9im7Zu1AMaLwqfaAdX9iFxoZ9utxwKS32uOBJEDrpr+hsAFA0Id25Ck7jbekAu/5
         +A25Zw3Bp0gZqMzSPueMf4o9eW6l5yzt1U0Xv219/5XxgdkwGHS3+7HM2j9AzJZboTWo
         pIYA4sLHcooJcxa9dOcwB+cpQyIGRTVziAdV4c9LTNjGIqrhgAtlQ5t6Af76Hr1N47Nr
         7JGR5qATi6mf0f1N2yrbvGFdBkjkhgE7yw/quIUWCc6OnY6ePRveDRDxwWmAUPJxSRUJ
         jYbd/1wRsAprWJSpcigJpK2Q8iuB7kaqricuDMUpIAWTJWXOF+AHUc/egAA3sCynq1v0
         76cQ==
X-Gm-Message-State: AOJu0YyKjETKKsGdZCLD0X45t9ZPiHjRv64A93gKaXMn9CIcT6U8qVDg
	1dy8a0dhuxBzBH3efeK6uerxEw==
X-Google-Smtp-Source: AGHT+IF/knJEBDAyziZ5bGsFkd0zgoM9yPDKanU8wPN8v+9Xu+OCLihiseLcaJtMfQMkMK0rGT1qkg==
X-Received: by 2002:a05:6830:100f:b0:6d8:a456:d99d with SMTP id a15-20020a056830100f00b006d8a456d99dmr3450114otp.5.1701744215637;
        Mon, 04 Dec 2023 18:43:35 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:35 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC 3/9] RISC-V: Add FIRMWARE_READ_HI definition
Date: Mon,  4 Dec 2023 18:43:04 -0800
Message-Id: <20231205024310.1593100-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231205024310.1593100-1-atishp@rivosinc.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
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

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 0892f4421bc4..f3eeca79a02d 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -121,6 +121,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_START,
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
+	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 };
 
 union sbi_pmu_ctr_info {
-- 
2.34.1


