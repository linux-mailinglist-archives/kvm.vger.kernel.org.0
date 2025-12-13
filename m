Return-Path: <kvm+bounces-65929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D9046CBB0AC
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 30D57301558F
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 15:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9AD2609C5;
	Sat, 13 Dec 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDcsC5Hp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A7B261B8D
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638554; cv=none; b=hWjfP3gWQ9cVL/XQwg60ttkQzXnjilZ7PSYnFDT/RfIOX3+vkWMIDvVTO/rjicSBzphyTH5bkdOBUeIaSATaCIMB1P8pTi+tNqWUx2L0eD5mGAbFkQFKInaYBU5RjdquDQDFztKOu3WriZAL63UWDl+kBzyPbhLmrgwYf87Ba3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638554; c=relaxed/simple;
	bh=pw7ARqByStDWYULVrmpA+Je8JaXhud/DmSByWx7D8BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2vaq/aQquTdFvBxhRwrgEPYr3eKZkFNoTBiakz1NrPvYY8bO/wQsM5bb4SCydeDNLXt9yhVvyd8iKkz3O+Zb122tuKKgprzDnTsR4coL6FW3qfWhf52ylG+DRg1MLpv9wFN48u6rXqnLSx2/zHO6vQAOglKWr+KdnylJ2ipzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDcsC5Hp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a099233e8dso3218405ad.3
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 07:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765638552; x=1766243352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gz8I5jl1qyQO0MpJuF22MiSS1lFlGXvXKCb0VFWa7N0=;
        b=iDcsC5Hpm87o1K2SJUVtYsNhc/NUP0Z0z5aXeCCP61A78zLmfxZ2A7YxvE72+LV2LY
         EHLL6ZzG1wXttlkNi3nKxfXV2nDm+TOQdTwgXYfcX1bP+nmYv/HVEHJjgEb0DF+D56fo
         hbFF0JeVOnCcGSBkB4vNvGhvjBxVVv+ZVRZtejwx0fBuqFWuimTy3cw7ay8qePIrkMNA
         8S028sfR+IBMwcv2eY0CwlKGpTHrvCNTjU9A3vkz3a8/nlGCF8qQUxJmmOsVw853ZfAK
         0aj3hkJWJ5xrMCfz/Zzh8Czjeou/IlQVdaOBnBzGeYl1JKoGg/t79MgbJ+xb+DNtsjUG
         u3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765638552; x=1766243352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gz8I5jl1qyQO0MpJuF22MiSS1lFlGXvXKCb0VFWa7N0=;
        b=cCibbzjSquk2i4aigb83JB1no9rJ4f2nysAS8+84Z6FtvbyVNzIF19AAm7Y3ZEd+bb
         xbxSUL2vUhdVPIrILPa4kQ62+3Lw7e1pscx8m3hIqSQ0HLmnYxHbAK6pOoMrEHZ1B+qJ
         fK0e/n0HpNpl4/Ln06s7+NVuCS8rTfDsVDHEFlm0hFzNKUMJEr3NGIK/e9t+iNZ7Ft7w
         no/thkscfyVTH8XDTcy3gNZPXK9yC6stALOSx8dnmDGwq2Sukj68BRdkdyW5rYckaDKP
         eGxik6gBLvRvM9epPMkRBQ6XCH8zoYwb/scmSyyEX7kPNzwFOFgTlIJ+aziEpHN58x3E
         pNTQ==
X-Gm-Message-State: AOJu0Yxr3kenxCBkqg62EVr11VN2ferTGfoI3JCCu72+7aknMLdnCwX1
	FlM5vIaqJYRwHTJGjHWHZG3k8/HqTYS1fWavrF12vOSthirLXPiLmyzsr34T2D/AGpT6FQ==
X-Gm-Gg: AY/fxX7SmUsOME4obXpRTDVUifwft/o3jF25/7CihbdDJlqDsJJWMNsqbERunTAcppz
	f85T4e4VCTdY3NhqZMvu3aaCa4aPnOLjBQGaoWjHDSAmvVTu9Ym72GXNM/tzjq8EjpKrYi6MVFO
	fhVS/kJgmbEDaQIh1Mekt01HXkmKKMNdFJjjqENVAQjgbgt3HYsKE7feSJ4t3Erwkal0VmtJCdn
	DGLQggbjcP529qALo6uIEtyQNiS3K6rdL39WLW9YvbeDH22Ue5J1X113NhK1W1XGhXolGz5ihQl
	cCRceE1CgmMavHxqNSVQEW4cVeBdSqhjX5NHOpZLdUhOEzGFLI4B2XyBNOCLKxeslCkeAd2kSCF
	EnlqgPTX/7xjUVh2ZjIt3cLO+KgudrnMvO/u3bAr2ey+QvRfL9Sp7rlWJLRrS7Hs//dWQyuO38H
	4hjX88YMzJruwIwlAJ
X-Google-Smtp-Source: AGHT+IHhr/NTcyCI0sQBcui69+ks4sJWgn/BIWiamUG1k98Zmrlr/Bt9eoe/k8Ql/eMzC92DGm9lfQ==
X-Received: by 2002:a17:903:2308:b0:295:5945:2930 with SMTP id d9443c01a7336-29f23dd7126mr61354455ad.2.1765638551861;
        Sat, 13 Dec 2025 07:09:11 -0800 (PST)
Received: from JRT-PC.. ([111.94.32.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c6esm85494715ad.59.2025.12.13.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 07:09:11 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 2/4] lib: riscv: Add SBI PMU support
Date: Sat, 13 Dec 2025 23:08:46 +0800
Message-ID: <20251213150848.149729-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251213150848.149729-1-jamestiotio@gmail.com>
References: <20251213150848.149729-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for all of the SBI PMU functions, which will be used by the
SBI tests.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 22 ++++++++++++++
 lib/riscv/sbi.c     | 73 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 35dbf508..8794c126 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -390,5 +390,27 @@ struct sbiret sbi_fwft_set(uint32_t feature, unsigned long value, unsigned long
 struct sbiret sbi_fwft_get_raw(unsigned long feature);
 struct sbiret sbi_fwft_get(uint32_t feature);
 
+struct sbiret sbi_pmu_num_counters(void);
+struct sbiret sbi_pmu_counter_get_info(unsigned long counter_idx);
+struct sbiret sbi_pmu_counter_config_matching(unsigned long counter_idx_base,
+					      unsigned long counter_idx_mask,
+					      unsigned long config_flags,
+					      unsigned long event_idx,
+					      unsigned long event_data);
+struct sbiret sbi_pmu_counter_start(unsigned long counter_idx_base, unsigned long counter_idx_mask,
+				    unsigned long start_flags, unsigned long initial_value);
+struct sbiret sbi_pmu_counter_stop(unsigned long counter_idx_base, unsigned long counter_idx_mask,
+				   unsigned long stop_flags);
+struct sbiret sbi_pmu_counter_fw_read(unsigned long counter_idx);
+struct sbiret sbi_pmu_counter_fw_read_hi(unsigned long counter_idx);
+struct sbiret sbi_pmu_snapshot_set_shmem_raw(unsigned long shmem_phys_lo,
+					     unsigned long shmem_phys_hi,
+					     unsigned long flags);
+struct sbiret sbi_pmu_snapshot_set_shmem(unsigned long *shmem, unsigned long flags);
+struct sbiret sbi_pmu_event_get_info_raw(unsigned long shmem_phys_lo, unsigned long shmem_phys_hi,
+					 unsigned long num_entries, unsigned long flags);
+struct sbiret sbi_pmu_event_get_info(unsigned long *shmem, unsigned long num_entries,
+				     unsigned long flags);
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 39f6138f..ca8f3d33 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -32,6 +32,79 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
+struct sbiret sbi_pmu_num_counters(void)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_NUM_COUNTERS, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_counter_get_info(unsigned long counter_idx)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, counter_idx, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_counter_config_matching(unsigned long counter_idx_base,
+					      unsigned long counter_idx_mask,
+					      unsigned long config_flags,
+					      unsigned long event_idx,
+					      unsigned long event_data)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CONFIG_MATCHING, counter_idx_base,
+			 counter_idx_mask, config_flags, event_idx, event_data, 0);
+}
+
+struct sbiret sbi_pmu_counter_start(unsigned long counter_idx_base, unsigned long counter_idx_mask,
+				    unsigned long start_flags, unsigned long initial_value)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, counter_idx_base,
+			 counter_idx_mask, start_flags, initial_value, 0, 0);
+}
+
+struct sbiret sbi_pmu_counter_stop(unsigned long counter_idx_base, unsigned long counter_idx_mask,
+				   unsigned long stop_flags)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, counter_idx_base,
+			 counter_idx_mask, stop_flags, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_counter_fw_read(unsigned long counter_idx)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ, counter_idx, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_counter_fw_read_hi(unsigned long counter_idx)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI, counter_idx, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_snapshot_set_shmem_raw(unsigned long shmem_phys_lo, unsigned long shmem_phys_hi,
+					     unsigned long flags)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, shmem_phys_lo,
+			 shmem_phys_hi, flags, 0, 0, 0);
+}
+
+struct sbiret sbi_pmu_snapshot_set_shmem(unsigned long *shmem, unsigned long flags)
+{
+	phys_addr_t p = virt_to_phys(shmem);
+
+	return sbi_pmu_snapshot_set_shmem_raw(lower_32_bits(p), upper_32_bits(p), flags);
+}
+
+struct sbiret sbi_pmu_event_get_info_raw(unsigned long shmem_phys_lo, unsigned long shmem_phys_hi,
+					 unsigned long num_entries, unsigned long flags)
+{
+	return sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO, shmem_phys_lo,
+			 shmem_phys_hi, num_entries, flags, 0, 0);
+}
+
+struct sbiret sbi_pmu_event_get_info(unsigned long *shmem, unsigned long num_entries,
+				     unsigned long flags)
+{
+	phys_addr_t p = virt_to_phys(shmem);
+
+	return sbi_pmu_event_get_info_raw(lower_32_bits(p), upper_32_bits(p), num_entries, flags);
+}
+
 struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
 				     unsigned long attr_count, unsigned long phys_lo,
 				     unsigned long phys_hi)
-- 
2.43.0


