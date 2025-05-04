Return-Path: <kvm+bounces-45316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F535AA8406
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E887F1886396
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4524419ADA2;
	Sun,  4 May 2025 05:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KYtdJKW6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8F1A00ED
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336582; cv=none; b=Rg5WAO/pT5zF2cBBBpZw2EDBt3aJKa6PeABqfNthqmqhKMB/NDpKS2lGlhfrAb6FuUwDQBQUMQVz1gRQWqe3cUhmjk7sAOF4zgKfsZ3xnd+J6lsG88BWcLYMWzqNBYC5uBD6T05lFpjGb50BfzNLMqgiAmI1P8PXc4fxN16cMqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336582; c=relaxed/simple;
	bh=8LUF4ZOeA96K3cwcmJpkQFjZs2tLqukInLbdbsF9W7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhCyzrgp9bdjZUEDiHVdm49IL51nMeON8J9jdQsF6PvU5ovW7XMpDBgWcI74EHtG5BheT4t9IxgnSAELClxxSzYTefle1pHFdZ/pz184TcsUdRPKIejTM9yAljhDO5IzqxyUPiMVncfoO3UF+aJ8yP0tTE1cbIreDb4bn8UrApw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KYtdJKW6; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736b0c68092so3043416b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336580; x=1746941380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WEHgb3PA0pyGgNPS7z7gsuRl+TMt0z9hzrheqBn6Fo=;
        b=KYtdJKW6yXCkhcYTos/OxKpZPf/WkwWMYzCWIgGFjzSPRFFONaAjjUz1BYmzuRkyhN
         /iXjXEj2LYF5qwNydOxQR/pGpKF7PFv28DdbYhABB88I103DJ0PpubHPp7WfTe9y1r2I
         Za8a2JgI41sIq2Cn6gd5t1Il1sX9pI09BAxonXaEqDAidnbJhu7uTpVxAknAsjIcmNJe
         Ax4uCSJJUxRzgT0QXJykOHPewQwu0WN6U2YxqILDMt4mv9lc9ittILVIJYzKnRjPovh4
         o0MdyD5Fv7SbM0GrK7iIVPivYV7o3Lab2NDL2h8JgqQHGugxhRzhRhaNZUuKyJWZWTh1
         CgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336580; x=1746941380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9WEHgb3PA0pyGgNPS7z7gsuRl+TMt0z9hzrheqBn6Fo=;
        b=Txpmc4TPmaWfsZMDAJ0jiwnUG1SKO8mqlWNy26uDe7OxIJ8DbD5yTu59a3nJMid67y
         tUoA4dlu9KWFdKJKFDGnmVEbw8KhYN9qgNqTCjsVesGfeSsuUr/WeaL1LGnxGHjNkbST
         zMbcmgv2u3vhVswF5kfJy9lkCZT+tvHAc3E0J8rdwa4beCGj4/cmX0Z2xbKIhkr+1c69
         dgvYDQlrveAqIS3ma9f2WskLl0UFi18ioa2KlwsoK7qMufIlpT5jlnqNHDYlXaJ/n8Ur
         kMy5ToO4khdfFQ6vogHcSH2u85xp2D47a473T9E14b81VRQV1Y2Ing1WM4k5JtaMRaMc
         jBFw==
X-Forwarded-Encrypted: i=1; AJvYcCXBUxJnrluSsajJFphoMDMK9Gh9X2/Yqk2cyclZNoU0cNFr3sgHi1NvDmfz8KhbkOH3m+0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwwxu5aWbwiiuP6hHh6k+sY6E0P3tJe4ur+R0WL8MEJisCOXTh
	guM9X9tCx2Me7DiTikJN5qOAeKfhC03jXFWrC+X2DQtqr2Yeocscy92a2jLzFHQ=
X-Gm-Gg: ASbGncvK1o6hb2VcbpHuHuZOdonHYNqD7C9SehCAa6NAm8Oq0WKGyTsesg2hyT1gIRl
	irVHHCZ3ikK/ZqrQIVkE5ZxsQy1RBakbh10elHJZLOvilLv3uhiTvGcGEMRfP0FHdmUNRuZDuHC
	ijpAjQXsPcUH6qeKR7xYHd6aYBvGBYrMqhIBt1kfpnNR8AfGuMAFUdJ9P0Pq7KqxiOHEa32jXCW
	xKFAuTtDlzjoRv8FE0oDT6Pp0BxTPX0At9K6fJBAPI7WKJlf6OrToiBoYL2qU5af7y7vS02t9tW
	eyFfK/XXC/Jt46mYRfkPEizJmYkaJASMtGISOd4I
X-Google-Smtp-Source: AGHT+IFZdCoc3EOd/pC3yget6airBTErnzBtACDv5VxHLSXZtnFHlYBZlNTtgrNT1W+tQ518XpSk9A==
X-Received: by 2002:a05:6a21:c8d:b0:1f5:6d00:ba05 with SMTP id adf61e73a8af0-20ce03ee7a8mr11142737637.38.1746336580375;
        Sat, 03 May 2025 22:29:40 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 23/40] target/arm/helper: expose aarch64 cpu registration
Date: Sat,  3 May 2025 22:28:57 -0700
Message-ID: <20250504052914.3525365-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

associated define_arm_cp_regs are guarded by
"cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
target (32 bit).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 595d9334977..1db40caec38 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6591,7 +6591,6 @@ static const ARMCPRegInfo zcr_reginfo[] = {
       .writefn = zcr_write, .raw_writefn = raw_write },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_tpidr2(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
 {
@@ -6825,7 +6824,6 @@ static const ARMCPRegInfo nmi_reginfo[] = {
       .writefn = aa64_allint_write, .readfn = aa64_allint_read,
       .resetfn = arm_cp_reset_ignore },
 };
-#endif /* TARGET_AARCH64 */
 
 static void define_pmu_regs(ARMCPU *cpu)
 {
@@ -7017,7 +7015,6 @@ static const ARMCPRegInfo lor_reginfo[] = {
       .type = ARM_CP_CONST, .resetvalue = 0 },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_pauth(CPUARMState *env, const ARMCPRegInfo *ri,
                                    bool isread)
 {
@@ -7510,8 +7507,6 @@ static const ARMCPRegInfo nv2_reginfo[] = {
       .fieldoffset = offsetof(CPUARMState, cp15.vncr_el2) },
 };
 
-#endif /* TARGET_AARCH64 */
-
 static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
                                      bool isread)
 {
@@ -8952,7 +8947,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_one_arm_cp_reg(cpu, &hcrx_el2_reginfo);
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sme, cpu)) {
         define_arm_cp_regs(cpu, sme_reginfo);
     }
@@ -9013,7 +9007,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_nmi, cpu)) {
         define_arm_cp_regs(cpu, nmi_reginfo);
     }
-#endif
 
     if (cpu_isar_feature(any_predinv, cpu)) {
         define_arm_cp_regs(cpu, predinv_reginfo);
-- 
2.47.2


