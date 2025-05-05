Return-Path: <kvm+bounces-45357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96183AA8AB8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF1FB3A7A91
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E611A83F4;
	Mon,  5 May 2025 01:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cfdR6dUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0949C1A8F9A
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409959; cv=none; b=V7gWe3H8M1xV80ya2I38/ckMBY+CU2breojAnRobKs9jCaMo8dccX7PAldin226ik169aRwmuEHUqimuCFErbCThcaQnz+TsrDWV8aPGUbcXyGSGmL2MlZqFO/D7/t9w1EqyAa+lRceXY4YgNV5Rm0ipF/w59GfOKSPPKWqdJGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409959; c=relaxed/simple;
	bh=BNFujmsKrmM2bZBmRA8jtPvMWhPu772BZRFsylHF7nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAQvZhFUtYzxEhZxAhDArTAgypTdMkAb25RvgzZznSeL5Co/5B3x7213UamKcvUXRTQ4d8Yxs6aL7NYF88bDKrmtb5/ZbNwNr7ALLWyd3ZqIrPVsZpVHWUvbSuBWT/N4wwR9heRSJAchvMCJJ+eFuKaSzp7P0A+5VTg534O65fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cfdR6dUP; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736bfa487c3so3407042b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409957; x=1747014757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=cfdR6dUPHDrk52usIl4RuZYwQKjzpKCtXzAebUBLVGNYb5ZyAXat5NiMiqu2iwerPr
         rjZ4SigKA8sOc9yHxy2sOsa7p98AHLsbdo5MxNThGTKROmNxGpM1eSYCPUPyA3FnpT0H
         zVDJefgvQC940cCjqGgP0k7eXoBlUDQ8ycAUSSdDgIk5+MRRzXaEak6mqGXamnyCVF2I
         oSX2mTdAm/DkidoEGaOgkvWazJz5uagpW/rajkwG+m8nLvBtqZhm3dGFgJPF6wvFThmQ
         D33HAZOp00S0F8DFwmSR5BsKEi3aaOw8p9e/9Ics6xZkIUcfcpSwxT9YtZEtT9re1L/Z
         6RQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409957; x=1747014757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+98FJCPUkZxLytRMJNRmc7jhTB2VJSy0tbuhiYCP08=;
        b=Zi0Jr7eiwAXHHH3Fy3CuPKPOTsZuW5fHEh/0dUPtJcBdAT1/OzLZuvHAwcHZqvBh1Q
         ovnUo7g/rlV7dCSON/xcIJ9pXnt7AY0vyS7xK8hoASOKw1XzSVdKBnK7pj3ji1FBiBuf
         2hqobnPvi6dZbgDh0EGiUVwvx9wAvcESTpef6x7kINurq8AZN1HlIuFfXwU7UAJq8kqJ
         WqUhyvT+mDuTubW+KB+Vt5iK/NPOK1bfPnm9cV58vZnXGi8jDGC/oe7aoBT9su99yMji
         TZDgkMUyhMlVyP7cfnrE7an+C6t9/rsOqSgVY4zXPeXKBAVgYyIFnJYZp7BqE8IxJjZi
         59hg==
X-Forwarded-Encrypted: i=1; AJvYcCUJmnkQaO5CMnLF3WYiUu0HDuNf/tfbc6m6SeGoc13csAgWEIpiYiKCB/cG9fO7Zm9BlYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx69p6sNlrSfGNAJNMVKnoM5Mlu+OID/B/hdDWZqC5OdoOL/UPy
	tXBUgHISFVLCWVdz5Stw6ZoSxVtyeVkhUmzXXFmn9ClJMd0uwa3iu4Nmv8akQ2U=
X-Gm-Gg: ASbGnct1D4rmQF5XO4oj+4gB2vK8IEx7HQRKVwtVLdyh69NwTVwLTb14y4aDDH3qGXy
	dnDr8VI42YEooERdnETsPBtnX4Fh/uafwa5DmhwclG+qdz3FtW63NN5VUw6qxVL25wK3RDlmyWy
	EN2DoBIuNQ21DbQtvL2CmKkAB6hHImbdhPHwTNRW11DUrXlZ9D2k8yP/HdjQPDYHHoaOqKvn/Qg
	JC2aktzvhc4ddDknQiU8AFpgTwg/U5sfipgIYqG7xaiEmhJW+ThsbrO6qlwxqxYpScaHbEWnKQ0
	ajryJlVHdJhHlfiPsorLm6C9jaPIScJG0zjU4eHh
X-Google-Smtp-Source: AGHT+IGTUMuWkiXDF+7B4A5RoXeueVtcJqUBJGl4G++uLi5Bx9kadv1aMwlRDeZ/N40AZk3TB+EU+g==
X-Received: by 2002:a05:6a21:918b:b0:1f5:85f9:4ce6 with SMTP id adf61e73a8af0-20e966058bdmr6970804637.11.1746409957268;
        Sun, 04 May 2025 18:52:37 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:36 -0700 (PDT)
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
Subject: [PATCH v5 10/48] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Sun,  4 May 2025 18:51:45 -0700
Message-ID: <20250505015223.3895275-11-pierrick.bouvier@linaro.org>
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

Call is guarded by is_a64(env), so it's safe to expose without needing
to assert anything.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 37b11e8866f..00ae2778058 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


