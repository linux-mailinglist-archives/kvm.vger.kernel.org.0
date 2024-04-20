Return-Path: <kvm+bounces-15392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5498AB7B9
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 845321F21B67
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F24A14659C;
	Fri, 19 Apr 2024 23:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0O6iL23/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B811145B3A
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713570486; cv=none; b=VfuVncJiLkTbfIjfllWowGmq0F19fLSHzTbIQYuqCg1Ai5pPbBCFbfGuYS+/uogyZieUz2/Flw+ta8VgMb81tijYP5jUdAyZhwFgLMo1NjOBaag+bWv8tvzw41FCTL3HR/CwrAiLqCr1p/NvliR+zvVugM6kJVQ3oc7lqZmbsUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713570486; c=relaxed/simple;
	bh=+BS7mctHpN9iWLFPEwC2/74zIoWzY97OXSTjHAOIU1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=do+ZSSeZk15vgNsn3SFzsvaRqYh8Z6lexiaD4DhuExBrUCRQvf5W23fLd1ZuEUN0fs206azICGMxPDlExPAH9D9VBWc+YE2gkmEJT+rrOCTWHs2vhHiWDdjfDzapqPK0IcqQSmZa7SnzdgTE8O957D08qjl01n67+O1eLW4qW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=0O6iL23/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e2c725e234so28948205ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713570485; x=1714175285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=0O6iL23/oe+eBGKeMRcBL3gb3aUl9h7Q8dbdGrM2iK3QFSkNNQ/ffKNvsQheHxMRZW
         11eMczk8wu0F2Ltv8hRopaualHCH2usIIDA2fHl3X9lQjOB6RqgQl1fhrQOn50T7lH85
         wYmge7UNBbP93H5hYZHgOsRb/t/EpW8ovXxV3j6Hrutwfei5XWFMj0izTbTPwb78dT/D
         0U4WBgwLGi7glj4uK1DgzKCJXfgLrM0w4zQcir1XwX6UaQbIFWdBZyrAvb18unMMZp/R
         sbSsX/UwssePCJsetUzWp1RcegAK0oh2D46W4TeNe5NDScyiRv9TBSr7bLQzrp8Xzjp8
         NNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713570485; x=1714175285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLadZMY/1E+aj61iqE390ie32fUnJXqsMN5cFXtebck=;
        b=QEhLNd/p/XU+72KvaADMriQmOWi31mYVUEg3hhOP1pMPhc9IYBBK2V6URyNA13n4dL
         LljxI83eg2DBzvPo2Eeyjuic3ycG8IH4dwKwADHbVSSGy2sqPdpdYgcl4Jh1QEidmMd1
         DddxxofaSEPXi5bVGjOB5FYTSCNMLnnewgBU7g4Rw4kmGLovl0LslUaOqnbbz8v+3Ogq
         e4k0ne+3rXaWtChE+yWekj7dBdKHUrwDTxFiaySBv1MOFF3Mj+NgwzOEwgT4HlFiFmt9
         +FpYTzIxx4UHP3VyiddDYlbmJZEPOPM+MmKyawq1qeneOTmQ6/6eIYNwNMhws3s2v6lM
         gzZw==
X-Forwarded-Encrypted: i=1; AJvYcCV4CvqJDvKrx4EzaVyhQ+SJaLlAhDmGFGk5GsReCHITlFL3iR+8OiBpk6H7fZBB02es6RelyaR6GODnDZiux4dobyIt
X-Gm-Message-State: AOJu0YwBMA5DeaL27HFepTOaoBsxXfEdH2FPauaiXn3MSgGbXIqDXz5i
	yXX+hONh75vonLXr9WaRxEt8TST1X7iy64bJwnDWMujoIxohT1CAl9ObpU/OGdI=
X-Google-Smtp-Source: AGHT+IEvBph6MwRCbI7XrCelJMnCCSQbSD7j1tJCROcKUOJKQW1V7Ng3imAkSqKF24OFdFi/RyQiKw==
X-Received: by 2002:a17:902:f544:b0:1e3:f622:f21a with SMTP id h4-20020a170902f54400b001e3f622f21amr10308080plf.24.1713570484830;
        Fri, 19 Apr 2024 16:48:04 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902d11100b001e42f215f33sm3924017plw.85.2024.04.19.16.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:48:04 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	samuel.holland@sifive.com,
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
Subject: [PATCH v8 11/24] RISC-V: KVM: No need to update the counter value during reset
Date: Sat, 20 Apr 2024 08:17:27 -0700
Message-Id: <20240420151741.962500-12-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240420151741.962500-1-atishp@rivosinc.com>
References: <20240420151741.962500-1-atishp@rivosinc.com>
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


