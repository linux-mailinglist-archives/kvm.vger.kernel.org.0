Return-Path: <kvm+bounces-14834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F088A7393
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D4511C21449
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70E013C3E7;
	Tue, 16 Apr 2024 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S5b5U4zv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C213BC00
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293099; cv=none; b=Xm7aMSOlcbD2l2BwSK+4LmgyVMcB+lxvQnQL2PZLvfeif0Y3AtjksJGIbz6u2iXMZjlOuti8giVYJJnI1xzVpAGXnl7JuxGkPV/D44O9ai29BA7ohMhtVAAzwbS7c7nMeAPfm+Oug/fFuUQGn1fO14aLMXt26SVEefd8YEx+m+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293099; c=relaxed/simple;
	bh=+BS7mctHpN9iWLFPEwC2/74zIoWzY97OXSTjHAOIU1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8RMW4gQy8NAdr/swbgHW3OyF/zC3ZbuoHJUjTWVPRcKK4ralWUITQGVN0iSQLMNH7YeZjCh0tC7ReoxszSOheiqWOhY/t4MDmtdywA8TrFUmh+W/vzOE9rP5niLAU/fnE8oY7YZEVFQxUBvEfQFYn/AYWBDiMXuAMdxEfcQHTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S5b5U4zv; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a53e810f10so2946330a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713293097; x=1713897897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=S5b5U4zvMHVQd6WP/hv3XBA4A7JnXSNAicRi0OPpfkC1OuSlA9LKaZ5mFWowO0fMqt
         4JsHZWhwF1IqMOYettWtnoFyEnQIxS46EmoKrLb3YyjBoSytqKjHvBP/2leTi7uFBTt1
         mQG0xUst6pNBvHFBsFX+pUsl86gtkyF1ZPel+55fGjW4lzHNJA+8GPy7OF28Gld44PL7
         vBcD5uDI5LAyVBtC6XK0gxd5d6/w2IL+H1OXce5LLgKhvQKD/3d/XIID+SU0bLskF+4t
         VZfUOlnGG1WLgB+szrfgv+tmJt7338jK3OnLX4eDfUeh79csCNfNfQVcsZ/pK42SquDN
         qRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293097; x=1713897897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=nNpdaudGDEscdfBiNtn4lvFGOTbFeOz8D14OPoXCHnFHQamBTmK4i6cL9mlZLJAygb
         2dVRyIU6hC6qgt9nyVQg6yb/CupR+NR8oFJciOP4j/RlkzwXyHtBTwaLQbb/vjrmVELP
         x4rvx10t1v5fBdQx4Vum27ca+bxl1hkNbPTbRCH0sOkhqhsVqSkbvFroU1jRLpAOEprN
         210Xe62MYsyUPR+w5y+IV1Nuawf6ehX2TghZaleOZ7Hub66NxQGBjeXzSkvKClK4xK+Z
         j7Qwg89ypM9r4TNjxK5JkvSvL/w74G0FEFtu7Qr+iVXD2571QR5yepum8Qi6+HglMGLw
         PAcA==
X-Forwarded-Encrypted: i=1; AJvYcCWnIKrAgb0IiAYAOzG3frGltQTGpv/g/LQm5R99bc1a/GGJDAX7Q+JLNKBK4wkFtV06skQXuFWxUUHx1wIzTU3p4/zP
X-Gm-Message-State: AOJu0YxaCfKLw1BssYSlwsBLu1u32Hy5A+iq3xHjFHiPIR0hGo5p8OGH
	xgdDXdnPDrb5guQjXIVTBXSwFGWIUinzo1eZ2Zahr1od7j7Y7WtfKLrGyfHpJTw=
X-Google-Smtp-Source: AGHT+IFO7WHFR9Rl28v65gUEiDT2PQZV3q/4Cya2K/e1Lz1G/MiHbevY0IrWH/uczf0ujzNAu6TxBA==
X-Received: by 2002:a17:90a:130c:b0:2a6:f414:4e0b with SMTP id h12-20020a17090a130c00b002a6f4144e0bmr9113440pja.41.1713293097058;
        Tue, 16 Apr 2024 11:44:57 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b002a269828bb8sm8883645pjq.40.2024.04.16.11.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 11:44:56 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
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
Subject: [PATCH v7 11/24] RISC-V: KVM: No need to update the counter value during reset
Date: Tue, 16 Apr 2024 11:44:08 -0700
Message-Id: <20240416184421.3693802-12-atishp@rivosinc.com>
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

The virtual counter value is updated during pmu_ctr_read. There is no need
to update it in reset case. Otherwise, it will be counted twice which is
incorrect.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index cee1b9ca4ec4..b5159ce4592d 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -397,7 +397,6 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, pmc_index, sbiret = 0;
-	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
 
@@ -432,12 +431,9 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				sbiret = SBI_ERR_ALREADY_STOPPED;
 			}
 
-			if (flags & SBI_PMU_STOP_FLAG_RESET) {
-				/* Relase the counter if this is a reset request */
-				pmc->counter_val += perf_event_read_value(pmc->perf_event,
-									  &enabled, &running);
+			if (flags & SBI_PMU_STOP_FLAG_RESET)
+				/* Release the counter if this is a reset request */
 				kvm_pmu_release_perf_event(pmc);
-			}
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
-- 
2.34.1


