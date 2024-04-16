Return-Path: <kvm+bounces-14833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 893918A738F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3203B22D06
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0D513BC31;
	Tue, 16 Apr 2024 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="pU92mXUn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DBA13B2A9
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293098; cv=none; b=JOamCB6Rl5thZ8Y0+8wQ0ryHQUsclYl1KS0xo+OjZQDUSvevNjkncikbxHXhsZhlTKIVP8dQ0rdzC6twPkQhDCrjnOS7E5wMDrOETC1yvrfFX23kuSo2Gi0X8o0XzYBbWytnwXobKIty8W6eo3/rNgcyqf2/0pG0JhZzByfqGvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293098; c=relaxed/simple;
	bh=i4/+SnhxIOkVH6jnqRPVGKLSvQvEdBjQqHeh5YP3SQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FsyryCUSu/91HV+92esPydEquL9+GpH4FVWI8SAQybK+ji/DNXLFTjazDXyeLlmIr4xyavH8TOKkyrppYbwg6UbdX5i4TzOI4+5gQCqkxpjOL6+oThAdPDqdUyYF92Udust1lDED2GKv70mgacmVKBCxIoYMWF5HUkG0Jk/5RWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=pU92mXUn; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2a78c2e253aso2280793a91.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713293095; x=1713897895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3Hu7DESDZEmcgrq2jc0sr2sorL47aa7h3H8SzaxXXM=;
        b=pU92mXUn3chFfAWKly7r0IXT8AqER8I1anwhMtEkZOFJpBhLtgIOAY067BpK23DBKJ
         /90TPJmwWM1GRnh+iGj6j6D2Xqubf98xQ7Gx31dD1d8bm7FQT17DL5dQIIBHxjJrtzAt
         4r0/J5wpFyp/AyQAauSYdWqCQl4WQTc2Uvi5NTGFRA9+OQVZGRl+F4+elcXpn1vhwz7h
         FKMgXB/Y7MPBrdD04fYJgOraN26QhQUTK9v6Ci+EdhhGRwIevK56aZdXAf4Jer6RB9PE
         wjCNV8IDf+3xh7yKy3OkfSgs2DzNkmiTkmysII0fDy6gcEZJ4s5/h6Y54Pm1uug46wtn
         uHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293095; x=1713897895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3Hu7DESDZEmcgrq2jc0sr2sorL47aa7h3H8SzaxXXM=;
        b=rIgM+crQu24dTiiwZnMk4n/6OzXzdrx+Gd5VN/9gbmK/qNy/jlrpPi0lBmLqDGVj8A
         KfkNuLqcqk4ZZwqlkj1zltWJIMLwhzX4PSHWWdhxtBi+8qzxlQawxsv8eQIVXM5mOz/Q
         G8mRPsPlah6HSRnE3Oqzfwo5hIiS1zXHdx4iJ9Z6vUh4qyjtJk2Su9rYdzGZxm0oo9RX
         ElhNHREMejaLITC/3Luug0iTQHmzo26G1F/vYtrmBfPRIR8lfMHtKwac77HA0aIqmHUS
         cUQ7YdRHJ8ZEmd5J/jQJVXpQz+3D4WuP9zeAWLYC0IvhbL0dJ83lxWZDNyTQ/grO1UbR
         e1Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUqfcCjaO8ebErJcy61VLimYCVNScPed9pfSwyaInQMiS+FB4cQgWWFaTyvrU0xZXnXUgT5RyIslz7X84e/d46alYtQ
X-Gm-Message-State: AOJu0YwKkYu5loZUgW+XGqk/H0v5XigCQPJcy4lo7vcun+DQojyWTz5n
	CcKu32MTxj+B09Y99G+HA/qQp/EYf75FW8Emm87p69ZV9nmZqK3yL4xRB0nf5wE=
X-Google-Smtp-Source: AGHT+IHMrJmnJNbaJLJrDUHsyvS17+PaYjcpk56OE5mezOqfopuoWKSQzyxBPEpMmbqXUeSJxlz5IA==
X-Received: by 2002:a17:90a:d511:b0:2a4:8706:ed44 with SMTP id t17-20020a17090ad51100b002a48706ed44mr10231042pju.19.1713293095691;
        Tue, 16 Apr 2024 11:44:55 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b002a269828bb8sm8883645pjq.40.2024.04.16.11.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 11:44:55 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
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
Subject: [PATCH v7 10/24] RISC-V: KVM: Fix the initial sample period value
Date: Tue, 16 Apr 2024 11:44:07 -0700
Message-Id: <20240416184421.3693802-11-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240416184421.3693802-1-atishp@rivosinc.com>
References: <20240416184421.3693802-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The initial sample period value when counter value is not assigned
should be set to maximum value supported by the counter width.
Otherwise, it may result in spurious interrupts.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..cee1b9ca4ec4 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -39,7 +39,7 @@ static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
 	u64 sample_period;
 
 	if (!pmc->counter_val)
-		sample_period = counter_val_mask + 1;
+		sample_period = counter_val_mask;
 	else
 		sample_period = (-pmc->counter_val) & counter_val_mask;
 
-- 
2.34.1


