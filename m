Return-Path: <kvm+bounces-41094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE594A617C3
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 406881715B1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E385A204C39;
	Fri, 14 Mar 2025 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aVD9f3jX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58BC20487F
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973515; cv=none; b=n9k6wUBRBbQU0dGdWl6MTRvDanqu2v8Vcc1Q9245thvlvt8sWQdSLxDM3FwsqRTLfJJFCeh0QKUqSvASHg/mDlacGz7bIvmlwFz7ae2hMhXq0fAJ9H/sRESTV2dieKgb96Mxwj/+TYy9EnFSYMr+3NIFmdSzrvGKT4RDUMlwHXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973515; c=relaxed/simple;
	bh=aHcHDSCEQG/Lxg84jg/rjAhvQowTiiMszTRoQh+zwoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=trLgXoGCMZujUvBvjFeSHtLa3LLkzci7eny/2qvfAFIKP/k5i5pVNUN7Lo8b1O3+D1HnJhIalKxzWdvTspBSfBM9sWo+BOgBf5AqdMg+gq7sMxK9d7e9M9Mx2cdn6YDEYKckhH63XVtl4w2UD6PdEhlGqOjwuXnzUknXmmUN7Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aVD9f3jX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-223fb0f619dso42965315ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973513; x=1742578313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=aVD9f3jXh62J5aSyJSStFUMZ0/IeSq5mvR5SNomOB14qChikwRdP2jr0MeG4opqi+g
         Q9k5cUwD6j9AFD8q8YKI6vO6uMUv0ih6Xn0p/iNNvLYqndDbe7Y1kJmeRbGVObp7aHju
         Sg1UcH3XBrXilyC92A+RXTTg72A/SdNzgtTo82aqxXTioeXc0OQVDKJfvtlBR0XkWANU
         QUS7kOyCS3rSQIPHFN8Jgx2YU3FrZcAkqcGHFWF+muwGNFNjYxsnGODSwIZC86Rd4VXE
         YLjTKOzvEJyaxBHaytidMncMQi9efzrqKMpHEFcsorKH2ld4vpLUmAYckAAgD/P4yw/W
         sZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973513; x=1742578313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=AvyenTvC6alVVltJCpJygGr34/eYInTyjitbAaflXflOh4veWjVyzygeLMEx4aE2Ua
         UAQCmGx45pYH3ZxkF1IZHi9dm9H9hOBBQ7HAsNbBymZzL8/TB+DIzA3kGPz0S4sYcBSa
         gywxLRXxtoIb7UE5hU+grXaY5Ips8n/FulzRoa1Wm7fk1jZ+EBLaA7HCOUXF0MEuTAp8
         WpVHDfBIIrUjeM6Ez/1yNg8FbLaW6w++fpVsSbjjEDSzC10Cy6ym02NIjj1yxPbZcS6f
         IsHC3vyHKpYzc0urvNJySIMf4dn4OZTkfxJWhAA5JoQpuAqATZOycTDuA5PBDvTosYC8
         6mSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXke7vBuwlHCfAuehVk0e3ymzdfRL7Vn+kbkIr/wfmTOLob8a78AimTtrerUNa6uLVFpxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL3Q9OAviV4orE1mf4iYfmjGs8IrhJviZitg2LAQApWCHfYIUo
	XfHQwVCxJIoVp1ya2gkogErGJiFKLAbVtRx2czBYvfo8/gIBuSgAisH0MUeHkvI=
X-Gm-Gg: ASbGncuzBK7RjiKkZY2tFxAagFCFXaz9GyXokIGZJeNm1pqXMVv05OgNYSZpVR//Ym7
	zgUtgA1zyuW+N9otXsumqxOiukesxjKJ+Q7Q26viIQkXU1cWJuJvmDlwvcHHAzTXkpJ48cHTWu7
	GyfDSy3afHnuth9eHscUeZg8TxobPYgmRKYH6kmFcr1ARlGCkG+PZ5yboW0lAXbJBzw6LlQkOsx
	Ju/GJtpRokQkSANPnU/gelnL3Opwjdnge7XkkKGHBKcR1qRKBvZlfNtJbHGIxvbGSKD5DYYhNYt
	BgJOSDZlVjBEOHYxKODxv0wCHWrv/UOA1ryZ2tGw6meJ
X-Google-Smtp-Source: AGHT+IHKJWanCd9a3ngVFjdniRCV0nA3qgwDHy2sNxgD5gHXjvzGRnW7PF30BgY1b31dJB7uC0Yy3g==
X-Received: by 2002:a05:6a21:7308:b0:1f5:64fd:68eb with SMTP id adf61e73a8af0-1f5c1137439mr5964561637.7.1741973513079;
        Fri, 14 Mar 2025 10:31:53 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 07/17] exec/exec-all: remove dependency on cpu.h
Date: Fri, 14 Mar 2025 10:31:29 -0700
Message-Id: <20250314173139.2122904-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous commit changed files relying transitively on it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/exec-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index dd5c40f2233..19b0eda44a7 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -20,7 +20,6 @@
 #ifndef EXEC_ALL_H
 #define EXEC_ALL_H
 
-#include "cpu.h"
 #if defined(CONFIG_USER_ONLY)
 #include "exec/cpu_ldst.h"
 #endif
-- 
2.39.5


