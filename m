Return-Path: <kvm+bounces-41912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 683CDA6E916
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D8A67A4E7B
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027DE1F37D1;
	Tue, 25 Mar 2025 04:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VxJSIPgM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF41AC891
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878785; cv=none; b=TReTNyIoBl43c6Xh548LmImw4bzNSdGP0RkHtnzmj/8ILWd+SdSHGDX5aRjWEq7rqlIQcO0Mqkl3yjumyKVVNj76xxYYOpoE18s2RDRtRmVQDz7/cgNVGbLmrcs/BcrIFNAOlJwRc8fq76znz403XW231vsHqKJiAt06JLJnq/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878785; c=relaxed/simple;
	bh=DOy4Sdbp7kuhxACG/zZQdbJ1CM61tcV1eHB1zY4TrGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fk3Q8/ku60LcYN6Ii4fHqnmNgU2815kIPoP/CNEgCxIzYKgFp6IqHWFHCe5jrLp11fVP5mYyvP2puqUE9WYO9Wssao4nDr1sOhitNnUQC3Mbyu62wslqH5TGSAo0aa5zr00RscX29VZsnfuKngtJkVTtETP2tyFa3Zm88KehbWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VxJSIPgM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-227aaa82fafso44701855ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878783; x=1743483583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtusWKYTrMDoHpdfg0nshB8ODIflkcfJFt+VFvekQoU=;
        b=VxJSIPgMCaHR4UXfeqQ0qLkYAFWUlerXEKWdxPJLO4vqUZbkCaHHTuPhyg31/oFTU6
         TLmcTmqpUX/3mytIWmO+SunXDnRlY96bsvOWJ1aHm/YNfbD+7Y63n4ypA/tW4YzscEMp
         GjbQpKOykR9N4PP3z+gXgM2FRPj8CtjQBNWRjpipkgacM80ab9jyDvVTCFECyC++ApOa
         LHKuLOPguulkWBrct+pA6D2yt7nh+Xrmd6Ee4NsJOgI/MvyNf62Ti6tNX4j+Ue3RFbJx
         kpJgoGoG+j6b7CyGHilRCrQq0G5fEma+l2t3IFhTsaokRL9UhFfPYDqwduuSub3pXLzu
         DcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878783; x=1743483583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtusWKYTrMDoHpdfg0nshB8ODIflkcfJFt+VFvekQoU=;
        b=gJQqvFt4R4muNR9SJ16p/lho9gySUKESn/Dk8LxZI+UqEDo8a38yX2SQod0/6D6+Fq
         +UXEpGmTMJhQSwpuVUgTMgMnkMwoXXBVD6kesMvAASgr2Iu8YZj4y6tXdOyB59l6B56z
         O+jKqq60YtPGHDp2rxHVKD+cueMF2++dJqQ2hnRh6VHwBTkvK3Pi4GWmQ9LQGb849Q0B
         7S9Oq9u/KwkIZucX1uja606XaWUpc6ng8xXEHfAdh6Nyy7bffcbXFmy9gpk1GDP64rMh
         b8JN/Y3Q7ylpEZKh5Gcq3z6iHxfiLj9Ckx5tVokJUn2uNE2BCxhioT0jGLjEZFA9jUsf
         xOeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU96En8/DkUpVYLpBXYps4VM4NNx9mAOPdW0g19bbpvNRd2cCX0W+c2E/eiscazTcEW6XA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ5xg9Pu1eiI0DqbYx0V/nwlZxQ/kNI9AMm0jfoURh6xD/k/OV
	lYM7Xw6i1PhJOSOe9ZfVBBQteSsWmnQm2ZgnHKhalY2GwKgRkkd/OgzDwXyKUVo=
X-Gm-Gg: ASbGncvrMAzJT4aLlkCEUuPuCjq/MA95LY/PRdKDHWU7oqKQqzSXD8YcHz/PuwbtaZk
	0j3/2xovWHk+29g4r3v+joJl0ZB8Rn4GVMNJ+uh3P5NfaWOUBj8o1xyC0tmJRwCpfINiOBMHmYe
	tRXwDanQCabczNXN6BmjNHjGvGywyTLtQXURByENEAyVky2EzmNlFg1IhX69t2o+Ob+IwR5CAqu
	FSwAEbfsWH6rbqAbV8vtdbW/GOIs0kLjF1KviqTUPDmsdHIDyjOve6NfnjHBxZ1BegA5g4Dwfv1
	R7FUdeY67t44uGjVfJ+ologsH6E2uCj9MSvLRxabpnM/HfN/6GI8vqo=
X-Google-Smtp-Source: AGHT+IF7fVNDkEZpxZD3TpaipUefPuzR5blv1e1P/DipQrGSgNSjRKkE8a4ucCi3CcRYcjp1MOK1Kw==
X-Received: by 2002:a17:903:46c3:b0:21b:d2b6:ca7f with SMTP id d9443c01a7336-22780e07919mr289321195ad.32.1742878782353;
        Mon, 24 Mar 2025 21:59:42 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 22/29] target/arm/cpu: remove inline stubs for aarch32 emulation
Date: Mon, 24 Mar 2025 21:59:07 -0700
Message-Id: <20250325045915.994760-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Directly condition associated calls in target/arm/helper.c for now.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h    | 8 --------
 target/arm/helper.c | 6 ++++++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index b1c3e463267..c1a0faed3ad 100644
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
index fa23e309040..73e98532c03 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6564,7 +6564,9 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
+#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
+#endif
     }
 }
 
@@ -10648,7 +10650,9 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
+#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
+#endif
     }
 
     if (cur_el < new_el) {
@@ -11665,7 +11669,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
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


