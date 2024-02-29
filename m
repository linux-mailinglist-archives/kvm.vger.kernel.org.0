Return-Path: <kvm+bounces-10324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 294FB86BDE4
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAD642811EA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B578F47F5F;
	Thu, 29 Feb 2024 01:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hVDsczk3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6C044C9B
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168510; cv=none; b=XhzB07LV4SoErRAVHTVQDHrN2XAx9JXOJm/LqDAWx2qvzIisJFxzME347svrMibcA2abaXTp2pq+k6Li4ChRmFUuP7Wie6oP8tmfrA7L+Tz3srIWpZjFZC9DG8nZrJ752kPdxEz58Nw1ckNmWfzJKAZGTR8q6sO2li0XnkmGJ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168510; c=relaxed/simple;
	bh=JxDVdSm0uYBTaiw3to0ly84+7T5bBOKxKOHBRjRjqXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dkHkj5C9TtCM+ba0A3efSc2rvdTty22r2mWhM4/1qMyt5YmHZZID2FCC7h4CUb3Y/f/56fl573rnxj2oXohmZRwF7kXLQlr5997z6O8FoLrRIpTiVNmixPtXfafutlnV+MoFX1An5MzIPLDSagUmcNno5O2sWuRaZX1cACV7nxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hVDsczk3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dc13fb0133so3358415ad.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709168509; x=1709773309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bg0Ox/oYKnbNuFBhdI6ydLs8+8yl3bqZRH2qF1RxaPE=;
        b=hVDsczk3nG0JVdnTWsZNyvgv5smdsCDLINu/FsyfeqeJiufmRUXfG/Yxfu7zsFvJww
         6AFF9eYWrgimABrt2Bg6OmS7G+f7D/F3PyDJqbgnKiMoqgvUIPgOaSq5QtlOZrwrQuYn
         JEhMW8gPAMulwlcFaGrrtX1eiW9cvggARIleVRsHza0+mxcQLjXUZtXGlGLDy3kH4maU
         3u+0VlSHVMWg6nwXLk1lND6o33ALSIbx2cx9W5i1FskPId0/YQ3I75d8RrBalulPKPUG
         G9HmAQ3kKLBPeBIp7cuMUsHdVn60Hzbi2dA5ySw7+mYPuan79PSVw/vhf3ESgprWa5fW
         3Kcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168509; x=1709773309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bg0Ox/oYKnbNuFBhdI6ydLs8+8yl3bqZRH2qF1RxaPE=;
        b=HxU1ll7s50m0SxVCb3ag+IFhwX9J0CyGDwO+8/Oqhw99XocxCu3E5T6We4DuBC6JMZ
         GQidnkDKJgw9G+W+lrUoN/WBR1X/IvrAJKYjnCGOcnWLMGL3eUrLt4jCbgHicS9mnqO/
         cVZ9z2j9xPQD5OERpQXD+nQU55NSWDJxsWon8m6jFtUxIVE2XQe3L4qELoLq/XdpW2s2
         /TWLIYI070HScH1kueaA1D/u+fAyvJh8+YLide8zHFEBjv1kahUI/6aDqxcbX3lp6TPa
         qpQrOSQ65tPLd2HH4ZMgb2Bl/DqdM2L4PbB0jaY9mFyYKMjoxjKzjqWnOaXu9NmdCdVQ
         BgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5AS+GtnNKWuTP7ZlVrP60RNkfNpakIzGrqcGa4xqKFJETFzBRIY6VS49q8ekvl1UFyEEP6nqBYFlc5h3/VKG3zCmC
X-Gm-Message-State: AOJu0YyvR1B+NmqGK6KJcrLbfWKmkCBHCAuOy99K+6689CFFkd/JpDE/
	s6mQjde9RN7nChxYadK0o4boeatipb0/6MFfFrGWZcshwVeGyhZvmcgxQ2Qtmhk=
X-Google-Smtp-Source: AGHT+IHAnIYV5Rew8z2wjdklNXOjsKF3XTvJkAk8FD0YrnnyBOoQ4ey66/haaO2Eu8pqRt8AdGvtGw==
X-Received: by 2002:a17:902:ec8f:b0:1dc:696d:ec64 with SMTP id x15-20020a170902ec8f00b001dc696dec64mr829830plg.22.1709168508693;
        Wed, 28 Feb 2024 17:01:48 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b001dc8d6a9d40sm78043plx.144.2024.02.28.17.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:01:48 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
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
Subject: [PATCH v4 04/15] RISC-V: Add SBI PMU snapshot definitions
Date: Wed, 28 Feb 2024 17:01:19 -0800
Message-Id: <20240229010130.1380926-5-atishp@rivosinc.com>
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

SBI PMU Snapshot function optimizes the number of traps to
higher privilege mode by leveraging a shared memory between the S/VS-mode
and the M/HS mode. Add the definitions for that extension and new error
codes.

Reviewed-by: Anup Patel <anup@brainfault.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index ef8311dafb91..dfa830f7d54b 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -132,6 +132,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
+	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
 };
 
 union sbi_pmu_ctr_info {
@@ -148,6 +149,13 @@ union sbi_pmu_ctr_info {
 	};
 };
 
+/* Data structure to contain the pmu snapshot data */
+struct riscv_pmu_snapshot_data {
+	u64 ctr_overflow_mask;
+	u64 ctr_values[64];
+	u64 reserved[447];
+};
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 
@@ -244,9 +252,11 @@ enum sbi_pmu_ctr_type {
 
 /* Flags defined for counter start function */
 #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
+#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT BIT(1)
 
 /* Flags defined for counter stop function */
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
+#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
 
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
@@ -285,6 +295,7 @@ struct sbi_sta_struct {
 #define SBI_ERR_ALREADY_AVAILABLE -6
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
+#define SBI_ERR_NO_SHMEM	-9
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.34.1


