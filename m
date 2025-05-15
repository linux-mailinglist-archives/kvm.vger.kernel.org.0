Return-Path: <kvm+bounces-46740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFA8AB92AF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 01:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 358404E6F75
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 23:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A48828C5DF;
	Thu, 15 May 2025 23:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SYwYp2hp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992219FA93
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747350686; cv=none; b=a/UQxhdwUQzIKGRYRsY60mrThn3Gm3+GlVTB+BXIASTUz/LmRxjNDVvQwLIdxF7GtKInDems2jC7WAI6SFyWOH2PaCq9WjMWmUEqAVWLYM0MqKvEzC+gZ79tLi5UhxahRa35gSaiaFVZdQscmCaW+H44V+Y0I/nAfUEkZkOizXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747350686; c=relaxed/simple;
	bh=21b1u916IrRdgMckSAzBYsh9RmVZZAX9kLZjKilFMOk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=pgfizDWVSqaCBbioZ71kilfVgwHvDAvG7G1w7qLbwnwt3x+manz220eDVArqeXCNuedOgNFJKYIh6EjbJ9shi8rS3aEVsetAiX9yZOhiSkXHShfBg1Qixbss4NavFrPIT50uvCGxnDAIRBfeIZ2WLqSFX7OumjPokczEApP3+X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SYwYp2hp; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30e0fa34d55so1399449a91.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 16:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747350684; x=1747955484; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cWXRh7r2vJxZ/1lbG9aXXgAmYeOBerYG9mBks7QssNI=;
        b=SYwYp2hpAUJDo9/caghrPj4jjrxNQVe/et247O7c9+VFWx0PIc8UNWFjwxQGLZ39nJ
         9p0AHbgO9RgCqYUmZg1mKQWn74HW740kULhs3NoW8ZZShoCWCWQky4Q3FOF8UeXThY5Z
         vfIEJsdIZIoFfs1tc6+cjDt+YDVwPuqK/ngKHU0FCdNIlkgHjXRcOcQ8eBm4g67ao0kW
         LT5xAYZeL6tHCDPSqTRLAeMze/vEz9Vn43KEvEDKFJl2LXVgnSDz0KMneqE0gQVjj6yH
         U+ZShYBgFuQzwoJSzs4S5JcZe+vBxZ//m0ynZmcgr5p5PjP068EoFIwJZf0Vco1aLhVa
         a0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747350684; x=1747955484;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cWXRh7r2vJxZ/1lbG9aXXgAmYeOBerYG9mBks7QssNI=;
        b=YQT3cM4+UWDE/tmqPV3PmN/UxqmsWXk1N7GywDucTN3/ffpFB6Rb9pV3jrc18vj8bn
         NuNzRKS8K4kwDq9uL3ToiwKB3PXvMRukzue2nXISRtAKjzfNYgdTFQjjkbD5Vj8mpnt7
         FQkf6acOaS5qsaPZi+kp8+ll1bMxx+Yy5QpOuM2Nxsxxuo9/YBK8I2ElQobCRiIf71E7
         oWEifSX3FvSRRuGHZ5gBJibjuQeEZOCzoQcR5gS3sw4oi5kuf2drAEBZ9qgbK+igzN5d
         g9WD15DHBev4l96bvKZlpMjy/FWU0IVjxfpyw9R8aWn1foS3jrZG5cS1Y0Q/q4rJ1MH1
         eJSg==
X-Gm-Message-State: AOJu0YxE2uZhnPv0nE+UHWQvvPv2sFeXCgBDCGY5OCqusPOPc9pCp08S
	iXECPC33WdM0g3lThU58cjRoUgwNfEMgDUgau/UUmWHosRqfosf8jJjAdZKT4lMu+bo=
X-Gm-Gg: ASbGncuz1YptPhtZIoiiGEwFCELHrxNSPjiyZdhM8IXiAbYbqI4YMf+IF6SUYSgYwUi
	nUZZlH1DeIiBgadydCAYrDGi68ke6mjrgmhQKJ56gHkDDMtPazKdithchAH3dAN+ENXpz12aOMs
	HVcGCgfxFhq2NUgoXQA2wqC04EyOa+p6y/Ag+F/xR7FGEjXNp/9Y+KQwrnBq7KhRL6wJh3B4c8x
	IKyPt0g3z1wSmlXeZDJV6apyJeOZ4hS+IzNBz0l/E7Qf7ev1GHEWrj7Fu9hu4a9i2srCQdmx/KU
	ShwTC4McaagIaRMuK+JiqubAvkqiyj6uwAADuDgCgEGiLmjBZ4Y8tY77RziBx3WFsYkj5MJkZvc
	=
X-Google-Smtp-Source: AGHT+IGAW4cvTanI5pu+NrHheJagZj7AR+lLIMA5PpkVtQFo51HmALe79lqxHvRdT0WW08MROjTyIQ==
X-Received: by 2002:a17:90b:548f:b0:2ff:7ad4:77b1 with SMTP id 98e67ed59e1d1-30e830c50a5mr457868a91.2.1747350683748;
        Thu, 15 May 2025 16:11:23 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d46f4bfsm406016a91.5.2025.05.15.16.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 16:11:23 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 15 May 2025 16:11:18 -0700
Subject: [PATCH v3] RISC-V: KVM: Remove scounteren initialization
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAJV0JmgC/33NzQ7CIAzA8VdZOIsZEPbhyfcwZpmluB4EA5NoF
 t5dtpMxxuO/aX9dWMRAGNmhWljARJG8K6F2FYNpdFfkZEozWUtda6G4pecQwT/cjAHdkCK3xnS
 N1BraS8vK3T1gWdrM07n0RHH24bW9SGKd/tOS4IKDsFqOtlfQ9sdAyUdysAd/YyuY5CeifyGyI
 MKazkDd9Aq7LyTn/Aa1I//2+gAAAA==
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
Changes in v3:
- Removed the redundant declaration 
- Link to v2: https://lore.kernel.org/r/20250515-fix_scounteren_vs-v2-1-1fd8dc0693e8@rivosinc.com

Changes in v2:
- Remove the scounteren initialization instead of just setting the TM bit. 
- Link to v1: https://lore.kernel.org/r/20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com
---
 arch/riscv/kvm/vcpu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 60d684c76c58..9bfaae9a11ea 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -111,7 +111,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int rc;
 	struct kvm_cpu_context *cntx;
-	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 
 	spin_lock_init(&vcpu->arch.mp_state_lock);
 
@@ -146,9 +145,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
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


