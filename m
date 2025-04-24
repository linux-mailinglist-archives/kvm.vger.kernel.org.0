Return-Path: <kvm+bounces-44232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFD4A9BB3C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF83C9268EA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6DB2900A9;
	Thu, 24 Apr 2025 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rfRrteNh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABDF28D850
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537323; cv=none; b=hqVIbvd8aCk3mGDTSIOxwSUpNHkikAmdcVImyb8EAfbnrP+GLo7PXTw5jYchqXgYKIBQyjkPhAPClz0WNU74QeP658Bv3hzTKUV9W3rfXYTSHKypif/iCLDuMxUu7zI1p3dSaoNVzh8tkxWLMvAgMdVg/nWmQ/nf6eaxIBLvGyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537323; c=relaxed/simple;
	bh=bnOyizBouCz/wGlyaJzON5pz8FQKc+nRttsBMe6DqYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TRDC2Z0ZP/bkP+lwZVHEUEcrwYy8Yw/O6A4lQerne7YLoZxCSysZ1w7t+x3/pdSCTAt4skMZU9oVS7AZPc4totgresxWuQczGU/nbRU11+kGBbQkMOAVSzdGBg+UVUACBKMpLMyh1VCe+qCG3Ww40h6rBV1F5DvcMr3/zLWQmwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rfRrteNh; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736a7e126c7so1597736b3a.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537321; x=1746142121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zd7Ad6nHa6u9MOK7rdz/XNTrIxsns40yasfIIp2oAZ0=;
        b=rfRrteNh3u0+VsrXpMSbANlxBiz9YIue0Ufz6xI4zcHDgXlxYPvfBxIphZG8El81bg
         EwSn1jfYYsthXkT9wSN4pF9TN7adeiGtTCz0WNRZSpDYvPnTCo6H+0wz8ggrkeCVzGqZ
         mXtLVjv6MNad6eFHT6E66xMl2G8UxjBSNyvZYC9+llOeTutE1xN/iLotlJtqvIqC8Mhu
         4DWKkLbdQ5OOnzAxH4YTtxFpnELRAg84catZheTQlBtX8A1Q680nKvcTFnkjCE+3WC9b
         gzMyH3zFt1q3Es6sChGkUhGR9I3eV7LVS8iQPL9ug1Lj19iQGo42o2osYLG2OK1IYGXt
         yjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537321; x=1746142121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zd7Ad6nHa6u9MOK7rdz/XNTrIxsns40yasfIIp2oAZ0=;
        b=DlgJ3qUMNVNc5u7sigdTU+ADEfBa2CzK2DrkGHBwLXb0F8/rjgeN/dTyvoSwrBjMgI
         zRg3BAV0mcV+PZ+o0mMBvYVFKd6abQvX25/reLkvOG7G9RTItFLUwIXqGVj8vZ2BxBuL
         wYHU01LcfEgRqNZd5+k28RzC3qNatu8wx0nf83swZZAa22BrwkTsnRjCOgQ65hNAu8+q
         FKdF8oYPiQq82Nj/3lbAVb7sOANHXDHVGV7AxuxAqrlcZ7rOYbD6VdxhvdIJDcupk4tw
         z5UNZEU0jeiiBKrkVUVOw7BTYvVQQOiRwYj3sEtPdxzw3y2WGPGhGoCmJdGkpcbI6yVJ
         Qriw==
X-Forwarded-Encrypted: i=1; AJvYcCVIXg4nHVUhExRCaos6w0oqIklBx6XO3edCQfS3DnqZIzQj0T6nQSgHmZDDzwSyAJwxW3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyHzvwudZVFqU+YQAFwu1DMferTzrxnplufA97QikYr1i4+wc0
	cVFYLv0Asq8oebtlXGIMC75vNDutKdoGMgkwNi0s4Sjuk2JaVJuiAN5rUJP/UJo=
X-Gm-Gg: ASbGnct/Gy3sMEs6I2O8fRHg1aKrF0yPLjCMIeWIN3akEbR4qrqV+N1LQ8y5ijrmSq1
	Fvb8Dq+/jBkbSRGOcNWpKc6KgNJGYCOKev6P1xW4qPkOp+w9w0GKgbFA3bPFaaxjYBuSW7FLwHC
	aHxWzTAfTzYsCT/JKEztag266Bymu1fhNUbc1X3nZ2WsE+xjqq2UDa5ZVa9pV0tqrODfZeq2DI5
	40IDLTre+rKKUskG/vJO9oMP/580b+tCIrx2aDpwLbjICNM4PMkzfI6PFlG1qC7/x8zIMq3OQ5B
	i44bvtty7MkmyIw7Z1esuaWCVYElUNHn/4gf4rAO
X-Google-Smtp-Source: AGHT+IG77ILEn1SteN+u98VgUPSejRzmZLJ/QaWfPoCnjigSzfBeH4GposY6XKN6Ovxr7oBdOgy2lA==
X-Received: by 2002:a05:6a00:3e0f:b0:736:3c2f:acdd with SMTP id d2e1a72fcca58-73fd74c1c8emr120672b3a.14.1745537321143;
        Thu, 24 Apr 2025 16:28:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 3/8] hw/hyperv/vmbus: common compilation unit
Date: Thu, 24 Apr 2025 16:28:24 -0700
Message-Id: <20250424232829.141163-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
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
 hw/hyperv/vmbus.c     | 2 +-
 hw/hyperv/meson.build | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 98ea968e515..b4f3e12fe1a 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -19,7 +19,7 @@
 #include "hw/hyperv/vmbus.h"
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/sysbus.h"
-#include "cpu.h"
+#include "exec/target_page.h"
 #include "trace.h"
 
 enum {
diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index f4aa0a5ada9..c855fdcf04c 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,6 +1,6 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
-specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
+system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


