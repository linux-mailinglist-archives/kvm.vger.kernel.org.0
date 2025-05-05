Return-Path: <kvm+bounces-45371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4A1AA8AD1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC4473B406F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE841DE3CA;
	Mon,  5 May 2025 01:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V7XyDWz/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126611D6DBB
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409972; cv=none; b=okAUOF69Db6MTv7xH70fjfBqk6QXBkfxU3pM8Gc+Ko5BExQdiHqxpxLAbF5Apbo9NIX/SG9LP/Ps6MzmPml8KXekZLjWGFchWhNkwfnf2Uutr/RAIM/nKwkNTUMigEzoYXeVkPtyUWVW565XID6K/aWiJP+1UTlWjFBqoDSPkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409972; c=relaxed/simple;
	bh=sOxadGRh6q8JpsoyihDnsqMHi2X7Vww7qOjy9/V9yqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amIlWgKTVFqDU4wR3orC/9cPz3uYGlLzG/4t4qcQXBEpKQHOwMl6MxVs7l9Jtd3YVUywM77TWpi0guHlfCgE3Sj1RRJ+dd/Xki8EVEq3OSi3cYIJkV9guIE1+tqD0sZkrnEWdmBsVEZkJtHyNPBjlfm97a7jKerYP4+dsZ0Mq+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V7XyDWz/; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7403f3ece96so5124361b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409970; x=1747014770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tgtkzpe8JxmQvRJXZCyTrKxE1atR2TmNo3Re2v0+pHY=;
        b=V7XyDWz/k0owyuVIO3WaPDQD7cOsOTG+mOgkmq/jbUhvAXEFs+oK9sBpd0PZ510BNS
         Ow1KPjgeQ5HTAK7+N8IJ5p22qx1wjwlTudn6Zcyzd3u4neYaNfpdo4G6MnMGVsNEmTKx
         gM/w/09uWtF5u5IB4BYJX0iRjQQ37BrO+IpIgLfcew24c375H+RS+sAsuHeFOR0j8xFy
         7ope3/kLpVlUkiw1mvvOM9H/AQwFaUNYHdvvJNLw2wqSmUzGqI1Tdxiq4T2ybOh1VcCr
         65yoUTS1jiOWlJuifomAFnIDhzZgWXghn2i/DJJnVZajUCVuxISd14fvA0pl6nTIkB9B
         Bp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409970; x=1747014770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tgtkzpe8JxmQvRJXZCyTrKxE1atR2TmNo3Re2v0+pHY=;
        b=gqu+2MGmcAXfP9P1STfQv/jR3PrTOZ8H4bbr/1tvygwp9HbQKH96qgXeoym9lWchuW
         NPoxoX2x6kBIw8HzQz+UaU/MZ2gnmjFrT8VYb0y3pfd/6VlL+LOFbdAFEwI7EFHgMGsp
         dAtywvEW9biWG4p/LjXcZqUOPasOUVEl5WKDoHyUTgd+QmlHSOAxZcjcCbNnRvosXDYn
         050cDQ69Nxht/m+I891jF2BSEnIC+FmKE9cpLq0w04JCsqSkLGc3lC48+sf7/zuWfarG
         H0NZE1hJrtucPIIGj3rAC1Cn6Km2KUIM/odFxa/JVHlPsYFQ3Yixl0bzxTXlqsDNe0vH
         6PjA==
X-Forwarded-Encrypted: i=1; AJvYcCX4ULCH6MW+R09L44oCntsRy1I5ODjihYPwlshJQVofQ7alHm9grAfwt7xwz3rHUIaEKZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBgobi+GOam7+Hx9ZFJmllNP8HX6fZZFLuZg0tMtjOZvvX8CFW
	noyQEDzs+xkYTDySnPR/Ao8+hLnowLBHvBdRx3+PHJ3qBbJPLCkcfle4APeqT/E=
X-Gm-Gg: ASbGnctfYZ3Q0xkRP5wPdR8WBK9sSdeTH0U0C3oVBadkFKnsUWdgzU/t+ttKuJFVTjw
	N85szkoy41ya6gzDlhlWIVBDHFrZebfndZWO2pb7BA+aENV6kVojexSJBn7HMnXtFjxi/f09eYr
	s/fE00Y74nZZ55Zs7OKyUSgcIH93ii364sV8pHVvjScXZv252+MKNzElfYwzqENgdZYn2oeFfzp
	NxUFH27oPEHMZEW9ODDOzqtTbUOSp3Po2EYvkKk8G4hIpf3E56+0IgQas5W7Kz6B2eT4Jz6jCTU
	7RWeBpdBVtEzHuYGmtA0+zOIB2eKvaYOil5qaTmf
X-Google-Smtp-Source: AGHT+IGhu4YzGN/5F6xNrrGQWE7WcyTSjX3jY7dpyCfW22wf11Z/aLnaJEKYbWVBhB6LZTzsmoKOng==
X-Received: by 2002:a05:6a21:9189:b0:1f5:8d30:a4db with SMTP id adf61e73a8af0-20e96205dafmr7605597637.9.1746409970184;
        Sun, 04 May 2025 18:52:50 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:49 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 24/48] target/arm/helper: remove remaining TARGET_AARCH64
Date: Sun,  4 May 2025 18:51:59 -0700
Message-ID: <20250505015223.3895275-25-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7e07ed04a5b..ef9594eec29 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6565,9 +6565,7 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
 
@@ -10625,9 +10623,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
-#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
-#endif
     }
 
     if (cur_el < new_el) {
@@ -11527,7 +11523,6 @@ void cpu_get_tb_cpu_state(CPUARMState *env, vaddr *pc,
     *cs_base = flags.flags2;
 }
 
-#ifdef TARGET_AARCH64
 /*
  * The manual says that when SVE is enabled and VQ is widened the
  * implementation is allowed to zero the previously inaccessible
@@ -11639,12 +11634,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
     /* When changing vector length, clear inaccessible state.  */
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
-#endif
 
 #ifndef CONFIG_USER_ONLY
 ARMSecuritySpace arm_security_space(CPUARMState *env)
-- 
2.47.2


