Return-Path: <kvm+bounces-40804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B259A5D038
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADB683B9F77
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33878265639;
	Tue, 11 Mar 2025 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IayfFNwO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6C7265622
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723112; cv=none; b=X+VA7M4k3b67fWrtsNJsLn17xzNWCvZg7K5x89mSOhw0wpDo3IH+vaG9yd1N7JyJqCDaS8cc8bTk1TN7VH8B8l4ANf3+wkdbkgHZA0qePbMdbzYyqQX7t4qANWucvGHVtmfszYAPRJf52+Z5XV4MHkWsz8Rigdjhv/gvhjTUvJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723112; c=relaxed/simple;
	bh=BkkUjOWmF7t6i9tbUmPiymzR4gYmq3p8TFOqgr7W9ZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VnGcVuuriTipxzuQ9FiAJeyi7iibEjxJVKGk7MO2751XRfaF5lQ1KKZVkr+NmetTNmx7daqcozYYZa5VodVcokrECN5YuyOM+s0k/4LBr+MdlTGNCoEgr9DlGHKoAWZT4EODCRlQh/Dl7/dFN7szehiFMotEepf7UNhTQEJwb2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IayfFNwO; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22398e09e39so111122395ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723110; x=1742327910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jGKe5PComzh06JRRSjyC3R7ujh2oauOlO5efOCu+zg=;
        b=IayfFNwOHZKJx8zCn29uiZejmDk2eqBAPAltzoCi3lDOxdnjFxTtxgQcJOoV044fPv
         ipVgh4m6LrYtwq5jOfpY2r57FQ1WYXeu4pR7zPCtHYQ18ztojfpjGLgGJEponBXzsCgb
         BSzuHGcAfZw7YrIKG36NGodoypAteAw+TsZL7GrWxOp17VgwWm6rI+jU4XVHhcShuz/0
         sVIRSNTtniud/pYVdrvgfvAvtsoXfOZje8m2jTz0106VpMnRYhvRvtZ+/BLQ4hMQUbGP
         ti4vZ0hFNhV5dRadUkBuxQvlqaatg4a2s0WuZfH3SsKcmkuVJfPWzSOETOpRJMT2GqPS
         GMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723110; x=1742327910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jGKe5PComzh06JRRSjyC3R7ujh2oauOlO5efOCu+zg=;
        b=O2H4+bAos014slVCDYDbHllUfMyKwZTsc4JXrG0PtnLkKs62rYFj38r5CQL2k/VhSb
         t7/cFMoNzeZgD/F2hmJlZkGDYuw62lhOG8dTP8dU+l20VwSrmbXbWQO2AQL02Puoehks
         IImvYCeGhxaWNmxV5k2B8FWOwDQ9kaSXUikJ3BmaBEhHpLGA+3tZgqMY21LOX3VkcNRs
         P2RCADCLjKN8QAeFSpFXK6EVrRMeuNOzYXovqL2e6mW0CSraurNnLf52sR+bJuKOGf7q
         X8lSxOCXt4IPQ30dctPmqjxJkwaAR6hQMia6tewMi0JOT6K1Z5Ft92idU7gA4CBx5EdY
         8HDA==
X-Forwarded-Encrypted: i=1; AJvYcCVGCkmYRgXSpDU26VuugfzBIXOv564B1YOSaXVtVWc0ySrpfBvGCxhbejEHwU+f2AYYeJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV7LpSR2+GFLZbtClpX1Mgct53Ok42yXHkzFq0ADlUyUTziaTf
	ubmVPiYJCUut9KtmaTqSCKW6Tj3iP5cUlSK5n3DF7zl5EYvKb6/Y8PCgb5xsRwM=
X-Gm-Gg: ASbGncvKxcmPtbABPJ/GIaueO5NSQeTkx0Oacx4CoAJFb7VnTeq9xVRNAbjIuDu6iNQ
	8JxRZu3iFXg2Fugx05Qh52Gjh+YyVIiX2OGEiMeICYECzvXvSRcP5gzV2kvTekWfKrybg+0SpJK
	UepRxmymA/qiTTcwlraHK+kZgKtRssxnDwDJX9c2GpMjLkioYPlwP5TzllbjyjkTDgLrs1RUKOs
	h2akf7vgvwnaCts/POGrZv9WWBSMl+wrG06MfcD3a3YHWdHHpNwyDU9cIbmgvhc1l92hg96SpMb
	l9oa4iNvLIRocqbrWU7FbHM44XqgOa/pjO4WEJQ16uBW
X-Google-Smtp-Source: AGHT+IFWRSSWAAZ74eVr+KcVmFNEyBuYNdoBJPeRpIUKcbNy7sibb5A9vNOWSCrzmBmp9nxRDwlIAw==
X-Received: by 2002:a05:6a00:b86:b0:736:50c4:3e0f with SMTP id d2e1a72fcca58-736aaa373b8mr22374606b3a.10.1741723110296;
        Tue, 11 Mar 2025 12:58:30 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 17/17] system/ioport: make compilation unit common
Date: Tue, 11 Mar 2025 12:58:03 -0700
Message-Id: <20250311195803.4115788-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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
 system/ioport.c    | 1 -
 system/meson.build | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/system/ioport.c b/system/ioport.c
index 55c2a752396..89daae9d602 100644
--- a/system/ioport.c
+++ b/system/ioport.c
@@ -26,7 +26,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "cpu.h"
 #include "exec/ioport.h"
 #include "exec/memory.h"
 #include "exec/address-spaces.h"
diff --git a/system/meson.build b/system/meson.build
index 881cb2736fe..3faec7e4dfb 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,6 +1,5 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
-  'ioport.c',
 )])
 
 system_ss.add(files(
@@ -12,6 +11,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ioport.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.39.5


