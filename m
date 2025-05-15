Return-Path: <kvm+bounces-46737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4F8AB922B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 00:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 535CD16DBC9
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6CF288531;
	Thu, 15 May 2025 22:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="zfeFT7WZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684E228B3E4
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747346772; cv=none; b=uLM18lbifRNcSpj/rK08m6SN1IRYQ5LoSwPWXPOcHl3/ix4gFWBdrpv0gJe+rBqq3BZCuafcbghm8Lal1W4MCGG5Mt9RJTt/VSO2hV6xEqp6JdbFBacjrELrwNUEe+5NJq6iZ82684cnWT8d+WmS7NW+tdeShel3huozSic2m/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747346772; c=relaxed/simple;
	bh=u/EaVaHKx9F1SHv14qeTnwcVtfcQnc0b+jYaydTMHlE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=m8XbYZQZuNtfLaP0r5hmpT8FXnGzjs49gBFTlEsZpzjJrBKN4JZZgywgssAcvQ7+IMM7PMF9p6fGtGUF5BeXhSP4Ttph+jzyvD8wV7EKQb5P2vWQwRl9EvgMKHCMyhrOnw6cNFU2Yb3gdEPZtHoGtjAUc1SSP4ZdJbEe1Gtiq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=zfeFT7WZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22fbbf9c01bso12655435ad.3
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747346769; x=1747951569; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pKEzAEjPYjOvvo8wW1NKB/AseRp560F6iFtwwKSA2eo=;
        b=zfeFT7WZ5WjSHFEw9NPu91v9Yj8cRuhhsCo5Ld1JRZnIIhJ9u1rzjwXqep7bKH2dlt
         DFGBNOZQM5PkuRyteA8fMo5zpctStytekeEV/JvPrDf78vKDIflzLUtjcqPf4/Z37wcC
         YIltQPpLPqLFBrdHbQo2QIXZF/2/sotC3CBd+MAIXux9wOqwE4GLjs+i95UDn0kH6iWj
         WP1fsR1/0nP+vLThP/fPLWMDpVwprG/KfJFeJ/5CIcGMDi/HDQHgzm5xSMP428ilODmV
         CbikMHj5R8r4DkZGXONLYTjQ4GaYlcEB0Pypf61tAsAH7GDjyhpkuTD/Og7w7DGNqLZq
         G+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747346769; x=1747951569;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKEzAEjPYjOvvo8wW1NKB/AseRp560F6iFtwwKSA2eo=;
        b=FIhfJlzwIVA5iqtwlQke5DF7cRhm9pVTNGES5rkxcQG/EdoS3zKMpaykM/KLLGDYjg
         y7M9pkJcH8ibJByosOuu0BtrldXGABRLJeO/F9/uer6pn/HyvJ63nTqjBecLMz2zQeB1
         vJe4bk9/U5/1ate5fxdwnbSSjHe0mvDRDud3OHoXWKIQMcxEj+weoGIDjvt6KwZ/qHkn
         HLf72FvzIwPd1fxknT0SjnLo8Ca1DXBU9Id+yusJ6Fak7Z/U03wfQcYKbUT4B6dYrgVD
         O1GqovFniR6HqXsXdSG3bFJ0d0Njb4hCASYVrwmpgbipgst2pTRFnSq9qQSTont80qrq
         2O/w==
X-Gm-Message-State: AOJu0Yw+Ke6lFiikBD/ZW1twmFpvjuK/hD9Wz9bjcnLoqeIVRkuFC5IQ
	chhJzjjsMCXUZ9Z9rofPlc3N9WHqn8ESxE5TYoY4dUVifJYtvEJy0pvRU3SdVetOPS8=
X-Gm-Gg: ASbGncvKjgWrvs3KobXsxR3ibIjT1+kYsiKklwEG7GhidD4ICJZYEDGTKKbaa+tB40B
	CRn00MO9ABXNKuySIzA26hXtE+QBjiuV1BOegP5KKNiMBa9ncpB/SsHp08HER6yg1zkne15UfZh
	Gwn+n18M/dUkWJ3ddT7yElQIHD3h1X+dhKhzFOj0qwtxATx5Pj9wPAbrVNUS9RTjOBMdUZa6KmP
	79m+HgHt8ocBqQuF0toCTRhNoQkrWpwXleqBwDlYhO0sa2qDbJH3RRpE1llKPAD3Xbx4sk9vTET
	Fp2b1+zPYfwikHwWOqgS0eKa2K0HidL1GGvMe5MCH75LUI5aJ/jZV+ZTDEy+u0Ck
X-Google-Smtp-Source: AGHT+IFiKNNYtzCEg6C6XYe7DP0nZARy3KIK4XDqNnkJzROZ4X9NmluwSJ7FFKC6yeImxQGIHZ2cIQ==
X-Received: by 2002:a17:902:e805:b0:22c:33e4:fa5a with SMTP id d9443c01a7336-231d43d9c05mr11341725ad.9.1747346769141;
        Thu, 15 May 2025 15:06:09 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed25a9sm2470515ad.223.2025.05.15.15.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 15:06:08 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 15 May 2025 15:06:05 -0700
Subject: [PATCH v2] RISC-V: KVM: Remove scounteren initialization
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250515-fix_scounteren_vs-v2-1-1fd8dc0693e8@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAExlJmgC/32NQQ6CMBBFr0JmbQ0tqYgr72EIwWEqs7AlHWw0p
 He3cgCX7+f/9zcQikwCl2qDSImFgy9gDhXgPPoHKZ4Kg6mNra1ulOP3IBhefqVIfkii3DSdT8Z
 abO8tlN0SqZR2560vPLOsIX72i6R/6T9b0kor1M6a0XUNtt01cgrCHo8YntDnnL+d7uw+tQAAA
 A==
X-Change-ID: 20250513-fix_scounteren_vs-fdd86255c7b7
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Scounteren CSR controls the direct access the hpmcounters and cycle/
instret/time from the userspace. It's the supervisor's responsibility
to set it up correctly for it's user space. They hypervisor doesn't
need to decide the policy on behalf of the supervisor.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v2:
- Remove the scounteren initialization instead of just setting the TM bit. 
- Link to v1: https://lore.kernel.org/r/20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com
---
 arch/riscv/kvm/vcpu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 60d684c76c58..fa3713b5a41b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -146,9 +146,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
 		return -ENOMEM;
 
-	/* By default, make CY, TM, and IR counters accessible in VU mode */
-	reset_csr->scounteren = 0x7;
-
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
 

---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
--
Regards,
Atish patra


