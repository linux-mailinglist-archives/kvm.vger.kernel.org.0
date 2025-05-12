Return-Path: <kvm+bounces-46247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD708AB42C7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E43117F2CE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7332C1E37;
	Mon, 12 May 2025 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eIDM+VmS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E082C2AA4
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073338; cv=none; b=IE+ZMH4HtGP5CFUg+14dUxSjcJn76Utb6Zgc2nEluY9HafLQp6nrtwspFH5KzX+dC/lAcc2Hb8iWrRyb5POzJraDzbppK1pkAwJOMI+jiMjcUJHxuhL3AG+7/vqTY74EEfmZzgkMwFmYXD0hpodgwv+10fmYsM9TA92DZN1Kz7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073338; c=relaxed/simple;
	bh=VoAc0T1lgVrHiNKX1r4LTa3RI22PUvZKcynFgbUha88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7KbOcG6scKyQ9+AwwY4ANeEZq5aPd5TKHdVmlDlpmJYk8desWG9gA8mn9+TzYbHqIzxDuJR2zpcpgRkicjB+GjFTuXa8wnJgat6GX0KN04/ypr00H/KfVwBdySbkrYxgh5G/epKvmMCW6zZKFKyFWyRyJr6rK1+VF0rcV+E/pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eIDM+VmS; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7398d65476eso3974561b3a.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073336; x=1747678136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A9pY26zaQMqZMR17IM27tzI2vbhn1j1ig8REcOyHb8s=;
        b=eIDM+VmSHEIfmuNay7T7dao+7VZKcWKzZ2dr/sE1fJEfCVI4sT3tp969n92Al+DCiB
         4SR63rOYCeZvVpCNa5xUlw3aCa4A9LjVXP83l0/I0e242WIRhbhymUUJwQr9KlRJ7Zb7
         UOAUeM9yMK2KDNf5SJ8+ROk+kz85s+FZ3ir5jTfxVOzgp2lodLBKBuaBg0HLPwFq3jpV
         Qwzx4LiiCWQ50xmia5Xxisz9/wiBC2JVmVK/cyRbG5/0fuNPvm2JdcA0TlezSBdC8Hf+
         R8mL0Aa63JCbvckB5N2/Ic6I37iolnhTVQaJnsKqaM5ovfnv0+CI11T2h4ikDu059F26
         4RuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073336; x=1747678136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A9pY26zaQMqZMR17IM27tzI2vbhn1j1ig8REcOyHb8s=;
        b=sdHJvCN+7Ym39tUq0W9h+B4trlyc2PDvDuIUMMqiWNSBUa5i7LiLj4l4qLJ0NshbJv
         ItC5cV6FsGqgWobER+aBCk1yqvgFEbJQ4niT5IOneoBAspVC0iVydw5MARBgoSj/ohai
         akW2pLjm2JGBFJJcYWktVdmxzipL6wD2hl0mIV4MmxIQ8uRX3UryQ+irG/xjPJzbL1C0
         KOMW4pLF+Vgh3gOPeN/RBbmlbi85DcO1y5S2XkQq3gIf2GRdlO7OOMRWR/MIljrggKwZ
         OhW4x4oS3jSFEfC8PCGOtRYRh7UdwtLywbQz6H5jTmjDVCvvqFW5LKMfX/AcDwWIBi58
         5w3g==
X-Forwarded-Encrypted: i=1; AJvYcCXXdLW3NxaZOLOv8ovn9BQPxQYI1gIRr2DbNiUKrrX17jNWV4+B/jCrrHdW0WrbVdapgrE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+CU+uhrs4oLQYbKtWTDfSwZHuf+IfJrGmjiFTdQw23c39MuN2
	jBfPk1aHrzvvebr6aPMwGhDWJ74ZkBg0uDYrjo+HBJ6ayFAV7eii5PHs0ob9mXo=
X-Gm-Gg: ASbGnctsK6Bn3ZFw2QIsbJCC/Xn0dOWSbJr84Y6H9CYr9gOVkDS3g/TiDjrHv6NUR91
	l/Bh9yajtqooAt1SDhiPmOCxHMDj4y0eyIgxdcFbpcXApV2K9rfTrNJMq/rkFHw7VVsY3jRnMjJ
	EcwYC9Se10SAQ6KWZI/4SRNKY3SmUMcpS6AJsRV2VPlAyGmMkpoHTbkG/h6BfsT0ba60GWw5/qw
	LZc/RSANI7e6THyUNTh8fb0IlwlIaDzKuP2v2Y31V40kEkGWA83PegunCt4HyEs+An7Wof93/wA
	Kljiv6ydCk9MUUTTM4roCjjCBL7c0SvVw8ZZjX2MNm21sOmHHXA=
X-Google-Smtp-Source: AGHT+IEpgv+2XV0Zbgxq0jroyNZr0Hhc8tUXZJKtGzmiJs+oD+973KGXRHevMub/LwmkpCtxJP8WNw==
X-Received: by 2002:a05:6a00:4d8f:b0:732:706c:c4ff with SMTP id d2e1a72fcca58-742791784dbmr459306b3a.7.1747073336612;
        Mon, 12 May 2025 11:08:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 45/48] target/arm/helper: restrict define_tlb_insn_regs to system target
Date: Mon, 12 May 2025 11:04:59 -0700
Message-ID: <20250512180502.2395029-46-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows to include target/arm/tcg/tlb-insns.c only for system targets.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index aae8554e8f2..76312102879 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7764,7 +7764,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_arm_cp_regs(cpu, not_v8_cp_reginfo);
     }
 
+#ifndef CONFIG_USER_ONLY
     define_tlb_insn_regs(cpu);
+#endif
 
     if (arm_feature(env, ARM_FEATURE_V6)) {
         /* The ID registers all have impdef reset values */
-- 
2.47.2


