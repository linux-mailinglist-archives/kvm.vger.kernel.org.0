Return-Path: <kvm+bounces-45379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 626F0AA8ADB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667801893D15
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0F61EB5C3;
	Mon,  5 May 2025 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zWPU58bH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D501A23A0
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409980; cv=none; b=jHL+DcDQyDMpRUBI5o2jSeoAnCEM6yXDtgDHK4v8KIZQ8q0Uabim/3QrMzSxeQxQJcekxxpQXlfQ03zdJue+BVCt5W2p8GGHdqnCkPh1gaUDtItstqVqeGCnHTNnyyRRmkRQtn7Fg1ASJQByH3apbDsCTqhAuUt9lFVV1xlTEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409980; c=relaxed/simple;
	bh=TacGw74bZNQyeDYcxCVjx5Ct3QHr5xUBU58fynumMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRelcLA5KEtUkxuLbOYHWGK/Yt67MJ5tHMFkyNq9T7c29pOA9ORVNwHnP8K5NChfdY+u/sWTNf4hNX/aDCpboRcUWeT1X+pbSkKzfGScJFE/IcNApoHh5mxfAIMwadf5Cty7A3qc95n15vifaOii/ML9gwhWo0c4UEVzd3rwsec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zWPU58bH; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-739be717eddso3066970b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409978; x=1747014778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUmj3qtC0Uxjt25GgPIz4kBx9RjJCUcgOSDgbgc2pqU=;
        b=zWPU58bHuNHxDIfhOM6PLIOHNd0qChZygXoDpHVGJea0uIBa9tKJTDNs4ytvAmGHHx
         /p0DnkY7N7jU/KIq1ZHzkldJB+HWt/dNSL1pG62YKifkP5c+QTiTZnPUItgbC14spdo/
         Adp20VM3YCdW21icgsNTDTUfVDsN+AaxsszD/N/cGfdHLo5/WOWBJjKILEVq32s2+SWh
         d/UASytluE3DE/+f0RLlh7SyCgQ0cqv15HgCODRMMTmydVumD6CMWCbd6Ebuf3yYuo32
         4WC05LDxm/8AyIflk8p8dCUvM/pox39+JWCV1c4ES7xc7qfTD8lFQ6l2cPvJHB89nUu6
         Gamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409978; x=1747014778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUmj3qtC0Uxjt25GgPIz4kBx9RjJCUcgOSDgbgc2pqU=;
        b=wTHxhm6WYLEnbDlwdHxhTQ6CZy8TB1YRxr7q0hXev8dt4fNP+J7CNqH7z9uT/YngdU
         OGhhkCoD61Lj99iAGTi/U2Kumvanc+jKB+K4aRYX4dZ53MEXpoaGHRmdfrs1lzUBLg3m
         oZUqOlw/mO848PbuCUESaNDKynaWDcWQya3XEofNhLyPhL27E+s8upNWGtXPgeBT+Usw
         sWlVuW4Y3O9cO2woXwPAwC2VQuX3nwAOSxuzKmp6dmYjFAioZqjoErpBKhoq8mOV9Xvr
         uOAobVGpoqOuhevkxrCqR499FYkEi2Soiae9H7xdIcYmez7VVy/1GX9YicVpb+tGK6k/
         bbvg==
X-Forwarded-Encrypted: i=1; AJvYcCVA8cv8wu8W0iTVeAEfQQGTllAFWg3sU5zoQf58e9H+agNkssLPiUoBr4Pkk44B220ir4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPrB0nxz4ISLADLM04lGqNhT7MQOwf/Q5d5vu8+uvYWqCAhxba
	0DlWMmJitJ04Uj+GcunOaOJvWb+Tzv2mLFZ6pMIPdg7FiwgR2/ctxe+7yvfcDNQ=
X-Gm-Gg: ASbGncvRreAo2Uyg7jUwa5UWXAWpCxaOBEXJuhU/phHlQNAMMGOkTOlab3b3zNbFkB6
	lJr4fCAkP6aPW8w7aVEH3MALPEgw2JrH5ZAxiyWTYoLt4zneIASwRdChL30NMA+LbPxso7uO/F+
	8XAKKQoOmrf7kP1DDmWfzNNMH3xKCs6+o9gF/RRpcD4VCZHDx3eI9wiZqfZi9C13dOOUE7nvN8h
	tzgii4OvIKr4g79O7kXF+Gr9YyZTWnMKEDsagmT2vcsTks9BGYj1o4OZ/KtG+e+2/YifybPNHRv
	QoFeGYD6Tyvr48f9N8FyMQG8z/evT+YapigqE9MI
X-Google-Smtp-Source: AGHT+IF14+GzXOzwvwVQdwpLvUHkW1dbYN6i+zycvVgUNiek3xtVEptqaBbxaSd7q1Ze+Ybp/RH0Gg==
X-Received: by 2002:a05:6a20:6a26:b0:1f5:8c05:e8f8 with SMTP id adf61e73a8af0-20e0692b072mr11046667637.25.1746409977987;
        Sun, 04 May 2025 18:52:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:57 -0700 (PDT)
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
Subject: [PATCH v5 32/48] target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from arm_casq_ptw
Date: Sun,  4 May 2025 18:52:07 -0700
Message-ID: <20250505015223.3895275-33-pierrick.bouvier@linaro.org>
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

This function needs 64 bit compare exchange, so we hide implementation
for hosts not supporting it (some 32 bit target, which don't run 64 bit
guests anyway).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 26c52e6b03e..c144516aaba 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
                              uint64_t new_val, S1Translate *ptw,
                              ARMMMUFaultInfo *fi)
 {
-#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
+#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
     uint64_t cur_val;
     void *host = ptw->out_host;
 
-- 
2.47.2


