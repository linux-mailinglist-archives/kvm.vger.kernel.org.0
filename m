Return-Path: <kvm+bounces-46230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A67AB42AD
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:25:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB7537B431A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3332BFC72;
	Mon, 12 May 2025 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IyWsrN8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F42B2BFC99
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073140; cv=none; b=HVD796jayIL7SNEv1sxy4i+EfeWh4sV5qsDNHrU8jcVATw7S7x7OLAn6g7EBeV4ON5RHWPc+ismoz1a1jQ6Wt33UYsit6XV/UdZfJX2nVEVVW6ZQDPzKH+z+8BzNRXfTQ4vycjsChVgFYsV9ICxedHKRAE8MKDTfm8TTZuqPXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073140; c=relaxed/simple;
	bh=QNqT5wxUJw1JENK4ivUPpOR9HvorI3Vo5lP0Q5Hpzc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VykIVEJJWI5M+k2tvd8TO//QbcUY52GAuamakpg9CPzv5BgWcR2wOgacAoByRf4nxuOiZUis0I5+EmNeQdiQWO/aq2OG+khNgwfwVOLI3VnHGIXPwi3YxY2kOqTDu+6cvCBlz4whz2euqZe6Pr+JlsKO/vWMFW8Ej+824l8u1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IyWsrN8S; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22e70a9c6bdso66817475ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073138; x=1747677938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AGfH/it6XrbUjxeSHUy0wlg4nMt2R7aYVYgAEJcCXI=;
        b=IyWsrN8SvZKuml/jd+S6s23w8RFOflKZMvT6eDiaJ9Y+SZVi4c5LrAHlSTKPeS7s0l
         vgKbcAN2HHyElaIHUKBNHRJh7QH7bhv04z/QuBK0xf0NLJUWv5XEafuB5cqopXJ/6vL0
         ge2i71gmQHik6oAGrt2Por2XiTO3oZcwo9VLD05KkGkdlP8DiS4RXT5aQTiT+wjQ55OD
         Np+MeVApOpcmGtDQW65J7CzcG4Qt7JGl/l1ZvV9E+WnxCiDy1E7EsKSNcIMeY0QRU2Yo
         mpRzuJiCRlt/bhJWT0Lq+toB5R/KRbiEXGN1hbYWc2MMSavrDlG2zr0XnPokFQ5OlncI
         yksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073138; x=1747677938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AGfH/it6XrbUjxeSHUy0wlg4nMt2R7aYVYgAEJcCXI=;
        b=tnZ19wKbBoPCxtEji0uWrq7tX0VEq8jFC1vWoMpqNbOA/03F+Bqp89qUfbxDdybwqm
         vo5SYZSgqegh8y10oYFdDKMaEAC4bGzjiDed6wiC2tX0gUECHiXVeZJVGr66AXLbIuwJ
         dpBRmkBcZ4xmZrsyUL+HQ3JY2oYGrUwzHAyGmJl5GFq1kyXDM4x2qN1WyZptz/wsQ1IK
         f6r9+nUsglK46df/1s43/EiHK1ELSyzjGiXy8w6yjiiLD3nexhLDLu50eM/YWHCj952V
         /s7N3UHKDiBO/5uZ3SrRq0PZseBMHU76MmvBsk5G5JT0vWULhIr5aQ7PA4ZVfEGfVwEJ
         zgGw==
X-Forwarded-Encrypted: i=1; AJvYcCU5DsULqqb+pjZVCpdQJO7e532hAJJrDTPGq+5Qj35OcPCpK0sYsiKoVZpmyOh0qNv48jA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW+s4th+Nkz9AOmbDEuef0KEKBvoS7cIUKb4qsC+xgSyxED3pg
	fnUYn/HBj8GS7ak+0TsK3LBjwKq2lhDBMj1NEZX6QHZpjvo66A6A7IAYRn7vHK4j9lI5qCNBvfi
	+
X-Gm-Gg: ASbGncvAzkLnyYQ2FG7joS7/L8vB2i7gPsey9zssu3BkSyhe4yWtIq9MYGhz+JWC2bl
	htmQOBaUjjMcVPXQ9rMmUH3QBRkYCmhpvnbJUe9OFgNNViN/CmzhpeZ1kSj/a+HshwgUa0JMo0j
	bEFHMsUPhpJSilus01F0jxDIWNthTUdNOZ2njCmRv8GpTk/xzJzT3nZ+3mv7u3XvjHmz4aegRwE
	0f5FrRVOQzeGpH7nBQN4Q5ooMIxCVkJ79oxEQ7mEvLFcK61l3GHanW3TcQ8WNzRXR9tGaFk1t8r
	od9HbbmxY8cO0GfZjjYb399qpIkqfSt74Gwp9P22wmitXYouWwo=
X-Google-Smtp-Source: AGHT+IFqLZqdqiB4vnCiLX+YhBjMM+mS8XRugjCd2bR2uEmufjtP7iuEmrJPLIQL55DxmxoR6NT1qQ==
X-Received: by 2002:a17:903:2344:b0:216:644f:bc0e with SMTP id d9443c01a7336-22fc8b58ed5mr234792585ad.24.1747073137679;
        Mon, 12 May 2025 11:05:37 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:37 -0700 (PDT)
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
Subject: [PATCH v8 29/48] target/arm/ptw: replace target_ulong with int64_t
Date: Mon, 12 May 2025 11:04:43 -0700
Message-ID: <20250512180502.2395029-30-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sextract64 returns a signed value.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 89979c07e5a..68ec3f5e755 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
     uint64_t ttbr;
     hwaddr descaddr, indexmask, indexmask_grainsize;
     uint32_t tableattrs;
-    target_ulong page_size;
+    uint64_t page_size;
     uint64_t attrs;
     int32_t stride;
     int addrsize, inputsize, outputsize;
@@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
      * validation to do here.
      */
     if (inputsize < addrsize) {
-        target_ulong top_bits = sextract64(address, inputsize,
+        uint64_t top_bits = sextract64(address, inputsize,
                                            addrsize - inputsize);
         if (-top_bits != param.select) {
             /* The gap between the two regions is a Translation fault */
-- 
2.47.2


