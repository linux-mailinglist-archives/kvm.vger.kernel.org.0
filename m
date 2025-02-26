Return-Path: <kvm+bounces-39401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50292A46C58
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 546F416DE0F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A564E25A2A5;
	Wed, 26 Feb 2025 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="f5A/MGIS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AC24438B
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601514; cv=none; b=cR7pFcGb96jswtrbl7nB398g+JieZULT/J8t2w+Z5O1NUtKD0fLf3XMOSMtGg/Alj0gFLn5yq6lWjB3E2o9LTOyrMIdLNwVMW3sICJuq9S1QE+sS7HIXO4J239IsNj5nnkOuN8tEkxtSaljsGWGryeoYNJr6P5OwdWJXs85bdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601514; c=relaxed/simple;
	bh=QBL/O8yP4cmvHwkIXxg+UQn9RcAHq1y3i0H/8OMhFUE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HoptCsqPjuY0sJ+/iqifTiU9N/5a9mg8fupChy2U53ks/e+8zQAb8rg4q+H559G7OuPLxXpOsTHO/9q9Ic+j9KhfX6YBO7hl9xDaB3anW8FwFa9ptCr1VpGWQaiM2sZBKC2XXbWzOLQmRwbmZyqu6Z6sYhGnCsGCVPqxbujdEJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=f5A/MGIS; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2232b12cd36so2457965ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740601512; x=1741206312; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElQVVHGvy1PCJJEf3x7O3Wq4GDtnkpov0IINkskU+dk=;
        b=f5A/MGISzjFSrplNEjJKnl/3POUBYwbI696oW9ISqocm+RF1moBEyuauSmL798Jm2B
         MaIDz2DygXuvQ5sxD+ZRUZZHl9d/hR2lirJHDU0rRb99bRnu/8zoxv0s2B8tAMeHldtO
         R3RYksblxEoXwgRvEEmnjpJmfcgrrM2fHD3r8u9ZI4E3lw4ODDkJf8AjZZA2oasdM6HH
         9cm7j/eWlYrpPviN77cd2OWi8gvte12UeduYszP5VcEsBCN2hGRo4NiO8h4Ff9cbQJ3w
         OC5pUMOpSoypJBBFsQMrB+a+5TcCUcNQjE5s4vMtbb6NjFpHxOT62uYrfI6RHUrHSS+r
         g6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740601512; x=1741206312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElQVVHGvy1PCJJEf3x7O3Wq4GDtnkpov0IINkskU+dk=;
        b=fumKQzgKBs2d/LxYAmDaeqsdu5WL2py8/6cArDUbTH+xbWaQ84mxhNakgkQ/pefbY8
         4Xu7HQ4bMolmZCVHamAP+Sp33/0aeApSJmYZjQAHNyxk7oPCeQ4Js5tPU9BuKB4g3kE9
         66hYeOu9sEYgWyjgowS3/iyke1yGrtyDa4jmw4FqHatawSSwzK5qE8FPYn1Z7aZxz/3Y
         ZU0GMKUTj6/iUjQSg0LfJRcdymd429dPDPIrDVEDEwsfYEBkLsf6aTH853euOCv9W5zX
         C8gFHqBxhWzAyiZehjIOg/S+O90ycjK1Ya5a6ibSG0MAq+te3hnCHoibiDbeBC3uFME2
         lJXQ==
X-Gm-Message-State: AOJu0YwRsVAOAlPuTAfQTZqhUsRX8Iie2AcpJ8LXiq5jElRTExDVbQ0F
	gjrEjczAZrr4LMHOlt2iF0PNhtsDHHo15qlJP8wAMGsAHDoOxoCUcpiOv9TanH4=
X-Gm-Gg: ASbGncuyfM83n4jpPq0F/l624ggfDbIVfLpDhU+hy3kIRuhdUDS4/qnbmCiv157ckyj
	wb8rvetjKiqEuWPlcXFarzWDRFjM0TfVPbo4rdeKiucI4ltIOHup8FF7nuvA2dKX3aeLsd9+x8t
	MSJfug6I3kyu2WI20iFtIlnEHSGodr8tXog5h8xQSntjM2hUe/8o9yqT38NCxDFYrxRbdGdFF10
	d+X86whFuJL1n6j/DGiK7ABlTr32KZbbi/5ieJLPhasgF9GoF2iTmapwKSiNJ7Vj8aBFj9n6Iou
	tgosZzfBwhY6E8calwyfkHDqQVL7KbCOKjdmn+M=
X-Google-Smtp-Source: AGHT+IFqbgodjU8bkbuDJlr/kSmLoWQ/SEWprjRdiuzVEUOwMd31NiSuNQgBjPeic2eXnfkR3SMW9w==
X-Received: by 2002:a05:6a00:a1e:b0:732:22e3:7de6 with SMTP id d2e1a72fcca58-7348be4650cmr6595071b3a.17.1740601512524;
        Wed, 26 Feb 2025 12:25:12 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a7f7de2sm4100963b3a.106.2025.02.26.12.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:25:12 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 26 Feb 2025 12:25:04 -0800
Subject: [PATCH 2/4] KVM: riscv: selftests: Do not start the counter in the
 overflow handler
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-kvm_pmu_improve-v1-2-74c058c2bf6d@rivosinc.com>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
In-Reply-To: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

There is no need to start the counter in the overflow handler as we
intend to trigger precise number of LCOFI interrupts through these
tests. The overflow irq handler has already stopped the counter. As
a result, the stop call from the test function may return already
supported error which is fine as well.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index f45c0ecc902d..284bc80193bd 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -118,8 +118,8 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
 
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, counter, 1, stop_flags,
 			0, 0, 0);
-	__GUEST_ASSERT(ret.error == 0, "Unable to stop counter %ld error %ld\n",
-			       counter, ret.error);
+	__GUEST_ASSERT(ret.error == 0 || ret.error == SBI_ERR_ALREADY_STOPPED,
+		       "Unable to stop counter %ld error %ld\n", counter, ret.error);
 }
 
 static void guest_illegal_exception_handler(struct ex_regs *regs)
@@ -137,7 +137,6 @@ static void guest_irq_handler(struct ex_regs *regs)
 	unsigned int irq_num = regs->cause & ~CAUSE_IRQ_FLAG;
 	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
 	unsigned long overflown_mask;
-	unsigned long counter_val = 0;
 
 	/* Validate that we are in the correct irq handler */
 	GUEST_ASSERT_EQ(irq_num, IRQ_PMU_OVF);
@@ -151,10 +150,6 @@ static void guest_irq_handler(struct ex_regs *regs)
 	GUEST_ASSERT(overflown_mask & 0x01);
 
 	WRITE_ONCE(vcpu_shared_irq_count, vcpu_shared_irq_count+1);
-
-	counter_val = READ_ONCE(snapshot_data->ctr_values[0]);
-	/* Now start the counter to mimick the real driver behavior */
-	start_counter(counter_in_use, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_val);
 }
 
 static unsigned long get_counter_index(unsigned long cbase, unsigned long cmask,

-- 
2.43.0


