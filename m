Return-Path: <kvm+bounces-59411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA710BB357B
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57D25560692
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0D9313263;
	Thu,  2 Oct 2025 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eujKxqdG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CFA2F363A
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394571; cv=none; b=ZEXOqzKAEuRRjhpLPAYI+o1SDuaZTJ++um/7gbAQKJzSkVrRGdn2AVxBsgVLDVCtwwuz6732qX5B90HMvLNAaFp91Is0B9Y5yiBq5u2K3HwFZiJWhjUntNqQlWlZpoPk12zP8zQII8z5AYEDjVeZgHjJZLnZ+om41KWXZkiHZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394571; c=relaxed/simple;
	bh=0+hw7bdgPnG3Ntfo1aWBObdjdoG6Y8p2BdXpWSbhUZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3CQSXnBsdeCpX55pS5LQw6snz9KIJachkCWfMlMlhK0UhubfJyup5me5gjgwARm32C9GM4n6T55lrXn/2mSeR5G37Uvj9O/1JxKV5dmMYGIfSraHUIMee3/8MqiPDv/b7amDZbmKFMlIqMgG4+phzbC70l29NiSG5IVX9c78p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eujKxqdG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e5980471eso3729975e9.2
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394568; x=1759999368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZW6KOJbHUgA0vcevzhPmMJNHgyRN0rHSvzpaRdIptI=;
        b=eujKxqdGvBhUDWkU+l055N9+UBkNdR8TgCzVncMZ/NyZ5n6N+xi4SoAThtFZQ+cPxE
         FyzKEKu9RRooIge1wl/H+YdXfWpqbLHHKKQWIxz3abo8X3OmgN/qXtb7tDr89k4OzCCl
         X+Clj+vI5ikNitQf0n9PO4CS9VRfGB4Oct7j39xnp1auBuuoOqc4tJ+mcl4yWA5sGamn
         zm+Hvmt85IXIBaecDytuQv0BQhYT7D9tFamnwEVsn0WFhLgWWcRihEDlYtKu2tk+z03z
         sb0+vfLNQl1uVX8VWgZuo2sE0AQpYLGd1cKaBOrQ5/vmHAdbm9scqWH06iOsHzK4jxIJ
         TVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394568; x=1759999368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qZW6KOJbHUgA0vcevzhPmMJNHgyRN0rHSvzpaRdIptI=;
        b=kA45vS47eDdXGkgGNBAYbjsMW6NOyPyM7SiV1uSrPbmIPy1eRfpG7l+h8nD/oZnYma
         L1CfhBKQc9iHciDOTGJ9cpLqXivY2YrK5xIsrEsjxNWh09fKsE3qTtrZj+cohcg0qr89
         j7t91Es71qsE0zMysSA5UzuhqXYP5odyokOjAMp5LOAiKT+0bQyiI7fNT9OwM9Q/Gijg
         cvggrqFapOI+rsKqcI9/fE48sCBTWRDe2DyoWv/LuHr1ZGMQq26b7FTKOnEiXAvvBWHQ
         qoaThcjZtE7pZWk6PlBEZ64iC0gsPzwu+rYcEJbJuqgCERN4P3e2zuh1EIQr1uDOT5hH
         DNfg==
X-Forwarded-Encrypted: i=1; AJvYcCUeDIx+HHz5lNFhK52b2C2tOWi1TfIID4E75P5wmB2yyf/v7H7ZKe0XDf8rHSciZNUlLLo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5EodiyQKViIUSwAI0z1Q6JBFihQzTj6BTB7t0ICRS8CE68bMe
	e0JxFCrfyIbgPHRsKl1d0c6WVtC6u6ATFaeb/cWvPaYqwBo0Iqi8Pz2F1xK3gFyghhE=
X-Gm-Gg: ASbGncu6i6TlS3nOrVkhHFeMKhu3+nNsYbfZ96hA3LnBtDP78Gid98AEhg3OU8u+jyB
	Ygh6ZIxwWGhrwpCIbKy1NHH0WvUdoJHSkxloNjjFurgK2Sa8+5Fa2+tdpMTwIQGDIxYJme8lXR7
	p4ge5ontrsxzWB6SKBNOB4YOqawsz6Y0FSLwof5UtND86aDHfpJ4Q6o5+H+h5CvcDhcc8GD0KH6
	pfzupvRqoFCHPvIk8CCbk3QS/HHQEghcGuE2eYuwkBxI8OGL6ZD70KD2ExX6hp3wV10XK8uNrJb
	objV9G81EPtX/WCFdoryK/SniaSimVmyEgKkePQSEX0IRTMao+1WDg66IX7XJiYPLD/K9ynxrd5
	Zo5SoST2XAbtP707UA1u+RzgfCTLQ13dlmYdCCkNwQMcAlQYPNdrliziAVdRHUMqTKuF9NlCpmt
	NYoFcL19LzxgA9VKiwAyZtSrQhBTkV2w==
X-Google-Smtp-Source: AGHT+IFq5U4u2A5oX9CLBB2lvkndRGUc5Ro2dPOckjD4hsAueX9T9m8XX4dTf+0cKHrb84/7PaVvaw==
X-Received: by 2002:a05:6000:420a:b0:3e5:5822:ec9d with SMTP id ffacd0b85a97d-425578154f6mr3598474f8f.41.1759394568264;
        Thu, 02 Oct 2025 01:42:48 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4abcsm2621643f8f.53.2025.10.02.01.42.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH v4 09/17] target/i386/whpx: Replace legacy cpu_physical_memory_rw() call
Date: Thu,  2 Oct 2025 10:41:54 +0200
Message-ID: <20251002084203.63899-10-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Get the vCPU address space and convert the legacy
cpu_physical_memory_rw() by address_space_rw().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/whpx/whpx-all.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 2a85168ed51..82ba177c4a5 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -788,8 +788,11 @@ static HRESULT CALLBACK whpx_emu_mmio_callback(
     void *ctx,
     WHV_EMULATOR_MEMORY_ACCESS_INFO *ma)
 {
-    cpu_physical_memory_rw(ma->GpaAddress, ma->Data, ma->AccessSize,
-                           ma->Direction);
+    CPUState *cpu = (CPUState *)ctx;
+    AddressSpace *as = cpu_addressspace(cs, MEMTXATTRS_UNSPECIFIED);
+
+    address_space_rw(as, ma->GpaAddress, MEMTXATTRS_UNSPECIFIED,
+                     ma->Data, ma->AccessSize, ma->Direction);
     return S_OK;
 }
 
-- 
2.51.0


