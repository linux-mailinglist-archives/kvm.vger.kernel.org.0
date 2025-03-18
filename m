Return-Path: <kvm+bounces-41359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AB9A668B0
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19507176475
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DC61D6DB5;
	Tue, 18 Mar 2025 04:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DzHcqcEL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7051D47B5
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273506; cv=none; b=KrX4YEwiFSpF5Dzu8DjoNYLT2ploRv/AFD6ihmniVzcdNTkRP110cO2HZE6fKfp+JqLY8CUBjg1Ci0Evogv5d27flMBF+2wUPBurv9g04hDIidnbLJfG9AB1ZmkKPx+Wn+0lMEJ+FhqUUPBjDqP+FEMJ2GZzN38kC8bOwJW5v+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273506; c=relaxed/simple;
	bh=hayFSWDWt4zs275v38pYxwRMiRJXsmkB+bnoqRyCrvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mIxOPQX/NZH0hTr8CBYVA29DIzVuS28+yw9wYCldJmCtm0+ibj6JxTA9AG+p+83ViUMCZeZqNsnnXpmXNQkPW1GqDeLGB7Kk1Ce1/uc1ZSdwCrcVHR5UqWzJeU2jsvPpYxWU8mD9ssSwha/akH0FWBB8s/Kx2bdTh8BPNnLqA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DzHcqcEL; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2260c91576aso31564605ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273503; x=1742878303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff4if22Q9C7/aUOyimjBXuhprbDC9BPiONo3GzzeMnI=;
        b=DzHcqcELKl3fI4HJtQyhVd87qZBsJbNvMEUo87KpBeQRKa8ffN+APOw4yEMSEUYg3d
         QAHfftYVU8zvwmj0+YJvPW1JUVsyxjCsyZSSdnAfwBOlKTyljlX7wrULJ5HqgsLQJxLK
         jTgpiDZlnn77p//8c1pmYatf/MlNFVtFZWo0d9koRUD4apcwAuT7SOMoHaW6TtUekveL
         iqSJydJCB0oa+7JISHK1+7RN+CaFfWhmdkzZ6TrROCZDfxurnZcmLX6I+4EkUelpfpsJ
         XjOOamsisHH68jI3MpObt4bmRP9deSIr5Di6ztJym2sIYDKAvbId5f9aKkf7d+cEue5s
         4qXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273503; x=1742878303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff4if22Q9C7/aUOyimjBXuhprbDC9BPiONo3GzzeMnI=;
        b=g07aGHJVmmSTlEfPuw8ZvMB88H4NYM5+JuBPlIc9jdQL1J0lKL4xteDyVispP/B1Xi
         TghB/pmIQKHPiiEe3/2g0joX+bVeWYpNwvMu6pol/gRKgqarirE+bQRcJjTOVFfdxX+P
         VKQFdWiUKC/RCNF1/GaCc2X7Znak5noLwtvsSg70deT7fpuaEfG15af5ZA94iVQwGYQM
         t8mpXF7uO0iVqtwIS1zVjxK993CG5I5c8tRhXuwa4MXJ6MaAm9gXNLPuqoMUbvuPLmh4
         2fEiPxNrmnCDvg4zupB4/nPlx/Vu/d6rZqrMGQ02e7t4pQhO64OYPp5idKEHGDo4gQ/c
         xR8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/WPaZJYbhtJC2OF2HsaspUt3bFQHlnkqy1rd/LHMaVMMVS0kc1PVZ4egB7+bTvGrjs3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHjjLQKL8IIx8Ipvo+OpSD9/QrTT3+tqmsBR0DsFlGXknfC2Yu
	j9e3GkS1AXs6g1pxYa2as+4euMVZVeTBhYYuzTfxe2bwCrJVLZ8vjQvnefYqfMM=
X-Gm-Gg: ASbGncsVVmyf/181reY7bATiLrv8vzEh1QI5OtXDXYvhcjIj+QqGP/Ua9XwPDXwNNNo
	gyKBaB005SG4ROl4nzAPvKxEkUQjwAthqLN0mkG8/p8kUARgARn6arWhxBlg3gpKz1ybge2QAm+
	zPQS8cFERChKYiG+CZV2OTKXJ+bZ4++BzvuMh6RwYzKyV4XK4nWZco1KGGR3bt5z/MkRIUyENOz
	BVdL2TsBhh4RvbMVE5B8ZDOY37GdGdD/TA9K3xOmfbPOO5Ca8lkEic8NOYdk1xHyhXVE+5zx3pl
	ifQFvE3H0xtOmBLQlDCI2EPwvD3ehYZVcVL8r6NwPFRR
X-Google-Smtp-Source: AGHT+IGwUIS/3wXKGJBQGhbVlXqqVjdKfsJ7yt0C5ebmRfs4P5+hmmLEk6TOEURFfJtw+igxyOPO3Q==
X-Received: by 2002:a05:6a20:244a:b0:1f3:2e85:c052 with SMTP id adf61e73a8af0-1f5c1327783mr23658501637.35.1742273503447;
        Mon, 17 Mar 2025 21:51:43 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:43 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32 emulation
Date: Mon, 17 Mar 2025 21:51:23 -0700
Message-Id: <20250318045125.759259-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Directly condition associated calls in target/arm/helper.c for now.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h    | 8 --------
 target/arm/helper.c | 6 ++++++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 51b6428cfec..9205cbdec43 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1222,7 +1222,6 @@ int arm_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
  */
 void arm_emulate_firmware_reset(CPUState *cpustate, int target_el);
 
-#ifdef TARGET_AARCH64
 int aarch64_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
 int aarch64_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
 void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
@@ -1254,13 +1253,6 @@ static inline uint64_t *sve_bswap64(uint64_t *dst, uint64_t *src, int nr)
 #endif
 }
 
-#else
-static inline void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq) { }
-static inline void aarch64_sve_change_el(CPUARMState *env, int o,
-                                         int n, bool a)
-{ }
-#endif
-
 void aarch64_sync_32_to_64(CPUARMState *env);
 void aarch64_sync_64_to_32(CPUARMState *env);
 
diff --git a/target/arm/helper.c b/target/arm/helper.c
index b46b2bffcf3..774e1ee0245 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6562,7 +6562,9 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
+#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
+#endif
     }
 }
 
@@ -10646,7 +10648,9 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
+#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
+#endif
     }
 
     if (cur_el < new_el) {
@@ -11663,7 +11667,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
     /* When changing vector length, clear inaccessible state.  */
     if (new_len < old_len) {
+#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
+#endif
     }
 }
 #endif
-- 
2.39.5


