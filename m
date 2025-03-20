Return-Path: <kvm+bounces-41626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3F6A6B0E8
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F8B0987663
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833E322D7AD;
	Thu, 20 Mar 2025 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xqAzJ8yW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382A222D7B3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509836; cv=none; b=O4lWznN4zOcgQYyKeQWMlqz4InrpN6yhMWOvfkrGKn/kkAJVF1DPbnB2jOqtTPOpA3dFCgbZ1qkSLhbBNkJeC140Jcf/wXRVWB/kOOzBFy3+0Yn9AyFEiKFSaDpt0XD47LmprPJA5jO5oe4ecQiVX1LS91RrKQW+oKlkULaGEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509836; c=relaxed/simple;
	bh=eyp31h1ymGkhzH7vsNkhWl+vP5IO408e3NiNTO94ttk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZmlwnzfTt46b7qGeIV+PhrIPkKS7aM95EuJENHVc/BqS+Dd99eXvf1hs1ZcZiZrgzbpqdz8Q/Gk4IHd9cd/ZsLCvKqg5enliZPZe7lBj5OgVeyfY+D3lOjIBTA0BxOztsfZcsnaw9p+anyVy6v9K5Q/f6M3yvCXMhFjxXDi4c04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xqAzJ8yW; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fd89d036so26353125ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509834; x=1743114634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUQD3Wdd1LujT1Sus7xanYZ7bZ9IH7iAgdXy0WNcaNg=;
        b=xqAzJ8yWnkbkcgiBzVy5EuVBiJUx+Aohkh0U9O2MlTdyzzmF3vFYcJCAu2zRpoGyV8
         QkSotAJ6E3mtB5QDuGNyv5eINTjYkdqxY5+YpzJnai/jb17QJ4MqqP9NJrz9rxFdNt3g
         2vRfUiNd2hNLTTcZ4VefVeazsw7+GI3rucRw5flB8eqx+o1zVjepG6XZarvjLPo3ARvE
         cLp4mwtZku4RkNSxw6GNfU6N032paCHmaw4ey5rFIuU9UrhfgydDPELZK34JvZ1o92vk
         9KECAUcu0bdkUilgSswMuZ5n3MwM/pqYmYpXNRAGMWxsHZZj5a7BZAc4Lej7vLmsymNM
         Mp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509834; x=1743114634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aUQD3Wdd1LujT1Sus7xanYZ7bZ9IH7iAgdXy0WNcaNg=;
        b=orYSuPOn0rz5e2t/RzRmiINXXfPP1HKFHKDW7xbMEypilWwlFVUFUX1zrPlDdm0MDt
         bjcYbkhtHs6VLpDgEr3h4i+H2qB6ASGQtuzucsSFWyX92GySx5VBgXnEdltUze7U3r2I
         8XWByMOJE3JDCyfwSpOeQwBCjBvXyjhwpFJV9q1hXBWMkUhH/D5aKy7cIm4OJiW1KhDM
         79sE0YjpBUEmCVqLdiy29MP2tSw7K3ZysqGaWbY4oOHirRDbbhc9ARxAcwNk17Kf4zx9
         dDYj+txy9EfI9PRw68rQGZh0tD28NnqYOtbnWGdVzIc7k1AJuForJ9reuHAMwn11sWI8
         bUuA==
X-Gm-Message-State: AOJu0YzhR9pj0tpnKNCg50xUmNrXJbVnHh0J31Wsifk0RO6VHO/j9NZk
	+YkbPSfz3fqfn4XjrWayJkohjQw8JQLIJ3+FtHGthHCBOdvfRZMxhyIywlNsZXg=
X-Gm-Gg: ASbGnctuE0lPLyeC3ttZBMss2v6AS9kJQYbrFPZQU6dAi8E6QtC5/vWQrC1Mouoz2Sl
	O52UEGmPV5tkTG1a+sYFJivCSqC+g15Rfy4enBTty3TDZ6vgoTcPMrxaxdsj77o3iElKBgZniS7
	ZaUeGD3H3wA6Zw/OVV7LuMFMMwBJwmb3CX5iUj7IImoG2cF5gsJpLs25q+soOiYMNSt82/gZ6we
	2sku+J2Yq971wtl7vFW26RBdvGrwErYNLNRQQlD396nrp0j42vyq3PUH748XLgyAli5wb/80JAq
	xe3sFohdh4Mvop2AyNrMt6j8TDz4cj7BGHV0mK/0ZTZulJNifyxVQvs=
X-Google-Smtp-Source: AGHT+IGlfrWg0bBEua+CzOZalX3WCoH9cy+wc/InKanm94Z9NrDL7g5YrDWENrVtS87EAmZz7TQInQ==
X-Received: by 2002:a17:903:2284:b0:215:b473:1dc9 with SMTP id d9443c01a7336-22780e5ffb1mr15478685ad.46.1742509834560;
        Thu, 20 Mar 2025 15:30:34 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:34 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 23/30] target/arm/cpu: remove inline stubs for aarch32 emulation
Date: Thu, 20 Mar 2025 15:29:55 -0700
Message-Id: <20250320223002.2915728-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
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


