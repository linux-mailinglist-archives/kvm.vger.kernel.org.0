Return-Path: <kvm+bounces-41915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EACA6E914
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06808188A3E1
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F1C1ACECD;
	Tue, 25 Mar 2025 04:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sku19Q8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D471F37DA
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878787; cv=none; b=As8/E7XknTOxAbNQTKG7gTn4rt5yl3L51vzFObBfXTbrq+5ufs3FQpFgZCo+HO37TM5TEHeOXLnykHmQVVskJQx+1JgPj+2kBcy0a8o6uBpDNEZJTgv22IAXnV8tryvwn0MX5GESi/Ksak2p87qChvSU9XbjroThq39NA2KqCbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878787; c=relaxed/simple;
	bh=1fyu1R4cCuh5c1xSkGMT2pnttjK4G8iwHPAbTmQEGug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MkLu8vAaY+skwmdPxqb1PlBAgycTVThrCtKNWY7mBUIN/Zv7LB+6vxsrBJpLPKjPtlgA99hGYayp6d/ybQHorr4vd5iSV6nN9PoD9vy+nrxyMyd6Ibu8pzyYBRxVzE0GnUj0XFo0W5okMNtCNYw6S/gq2y2srUhi9Viojlhzuzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sku19Q8Q; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so8530605a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878786; x=1743483586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pArVD1rsNNhsePjAEu6qC315uMjwLbUtwsk4rPFCwig=;
        b=sku19Q8QZCnXqB6G8ArLFmyleOGoFy5yFr0FaZwDd0b3o3k3OeFPSX+AkTkIRuHoQK
         teuWxPgLB3LDg+oM5pBmwKA7S8RKTlsyTryyJ3OCvk01bL8AWkpUbXE08MxSwQeGMGiu
         U5DwWITixLULqKPqHOTLT6OsIjYHMQ0rahthHTUtamNZXhzDS/CtZvrtYSUPkEYqVUxn
         c9gjV4QQmlOLSUJprT8LzxVuy0oFREF7ffJZ9RzysxK7cO35fKx4wgIkIFwBG23cgRWR
         O7eMGhPynRZ5bks4Zkj5DlabRhOsUTyUVGw+FWq/3pKJASPTtbhYGQLohy8xy+Q/zv7m
         64mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878786; x=1743483586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pArVD1rsNNhsePjAEu6qC315uMjwLbUtwsk4rPFCwig=;
        b=c/4IvLh4wCUWmg+fSHvJjygiJFPqq+SdZCmAxko8ItsqE71J7bMxz8ftOTCjqFQbg+
         JEasTNpI3ziOKF4BO5BSjkZ2ARKBYbcmizVfPjlFxLjhd96ne//a9U94YgKY3z1Dalxd
         EzBFZf+2bGm6ELSh+pSVC8TRYBVZ8/3CUSecx+e9QL5+z6WQWO5W1P4OmPWv6YZ2BfdM
         AmvCa7i4zUufFcEOmwePWdtGeZZPldgUxp7uct1DTJ+usnbIL/HhnhiwmlU+xOMcLswp
         yHUzin36nL8qxYKAVi9OiBnSOpEEwj6TdavRbNrtjfnLOcl3BLMfou0/HvajODLQ4ipu
         QsoA==
X-Forwarded-Encrypted: i=1; AJvYcCVb/f7KlTGE9NGNVtv1nMBc7wa/1q946aqV0y4EgGWnG6+XHe6mY9E9NnFU/3sOf+g7RlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRA+BuVYajTYWlKvwu9NmHyk97/nB1jSdOLkBhTz2E5+7gtBqu
	fXRXfkDlNGKc3HmQbnoFYBx8SH+5LN5zmqGoUqX3L+Aj0reyDqBJi6SoIDqMim4=
X-Gm-Gg: ASbGnctjZJK74r8zqGNubzuCEylPgQdhxYP0Bk48gqqSuFB8t4HiNno4huA5EIKN9r/
	yifPv0uzz1btDQVjct7WHqskTfZ+i/4VIDtk/RPcb1nPMnmDTJvZBGXRxFmcE2n3J528lNAbQdg
	GQBYB0IqBGzHF9CI/nsZHWX96vcAa80QHYChrrR/hMT3Xz/G5SV6LA8FPf8eNNCQqtjeMXSO3Y5
	fzLcVsuVyIZNV8ly2JPK8Bh4Gmqo/TtZZQtTjv3U3nFzjRcGrb3H4SewRT994MkkXSfTv2RhX+1
	BZRveYpEQrhVG8iqU0OYLKwQi8fVwO+1qzFG+y7Iukdn
X-Google-Smtp-Source: AGHT+IGR/KzZA1+eUmHk6ei4WiiUVCtTEYWPQAWgs9sRPdujUcwem0sIhUGOyH56NiEPvMBjKDnRdw==
X-Received: by 2002:a17:90b:2b8b:b0:2ee:f076:20fb with SMTP id 98e67ed59e1d1-3030feaa4b2mr29857443a91.17.1742878785454;
        Mon, 24 Mar 2025 21:59:45 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:45 -0700 (PDT)
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
Subject: [PATCH v3 25/29] hw/arm/armv7m: prepare compilation unit to be common
Date: Mon, 24 Mar 2025 21:59:10 -0700
Message-Id: <20250325045915.994760-26-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/armv7m.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index 98a69846119..854498ac51c 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -140,7 +140,7 @@ static MemTxResult v7m_sysreg_ns_write(void *opaque, hwaddr addr,
         /* S accesses to the alias act like NS accesses to the real region */
         attrs.secure = 0;
         return memory_region_dispatch_write(mr, addr, value,
-                                            size_memop(size) | MO_TE, attrs);
+                                            size_memop(size) | MO_LE, attrs);
     } else {
         /* NS attrs are RAZ/WI for privileged, and BusFault for user */
         if (attrs.user) {
@@ -160,7 +160,7 @@ static MemTxResult v7m_sysreg_ns_read(void *opaque, hwaddr addr,
         /* S accesses to the alias act like NS accesses to the real region */
         attrs.secure = 0;
         return memory_region_dispatch_read(mr, addr, data,
-                                           size_memop(size) | MO_TE, attrs);
+                                           size_memop(size) | MO_LE, attrs);
     } else {
         /* NS attrs are RAZ/WI for privileged, and BusFault for user */
         if (attrs.user) {
@@ -187,7 +187,7 @@ static MemTxResult v7m_systick_write(void *opaque, hwaddr addr,
     /* Direct the access to the correct systick */
     mr = sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->systick[attrs.secure]), 0);
     return memory_region_dispatch_write(mr, addr, value,
-                                        size_memop(size) | MO_TE, attrs);
+                                        size_memop(size) | MO_LE, attrs);
 }
 
 static MemTxResult v7m_systick_read(void *opaque, hwaddr addr,
@@ -199,7 +199,7 @@ static MemTxResult v7m_systick_read(void *opaque, hwaddr addr,
 
     /* Direct the access to the correct systick */
     mr = sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->systick[attrs.secure]), 0);
-    return memory_region_dispatch_read(mr, addr, data, size_memop(size) | MO_TE,
+    return memory_region_dispatch_read(mr, addr, data, size_memop(size) | MO_LE,
                                        attrs);
 }
 
-- 
2.39.5


