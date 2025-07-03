Return-Path: <kvm+bounces-51514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF75EAF7EF6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E7614A857B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457D828C03C;
	Thu,  3 Jul 2025 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OxOyZxWv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93C3288C96
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564086; cv=none; b=k9Ro0O3XIbieVS/oGVwfk3dFsUWdtTooz78dhVS/fFLU3/ZSnfqEHzD8w+rb9wnuMo2+MAP1QMffTHH3qQb9n/4+2vlfhcxoIom7EP/FOh27VS5nnNkIkYIGYb6uOUlKcC0Vc4Dyrz+SzECJIL4r0hwIQnWO3DvQURQguSGOELE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564086; c=relaxed/simple;
	bh=p4v5+xFQO3bIoTjIeunVHI9ztp+MZVY9SK6UWvAZyg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iq4Fl7uX2izZrUIdbVR3S9z7APn+AimzH8bKlgrr99AmOaFCR3cjimYcVZ19oULLeTUcmZcTk76Ck6mDeLViofI8+2CGP/Yzf13o1GA0GaJXqYXp4EF4Q3oKTDEW4hOC38chcGpjIbaC3A7Uuc84Opaoc4I7gxmWKh8nOXjnKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OxOyZxWv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-451d3f72391so754055e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564083; x=1752168883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=OxOyZxWv42oquRlBaUj52j99I0q4MJbAxn/kN8NDCW5tamAbliKmJHEoYf0JUwxX0G
         c5PKYpI0k3eZQRVy+lu+0H7CQhRjAnilbQSklEIPIWKIkYlOGuL+3D5XVtgDYbm8ndCQ
         AV6FyJZUw1oqenOP88CUyhYPFOQeB7h4pRDTnlZOXvKcPhb18ZhbJ4kjZM1f+pQ/vjGS
         KDax/gTkn1hUfmwkEQS1G3kM9nBjHsxO8t78+q9yYZnoTGOvv9bDKqnsIU1GYQmb3dms
         6uHslx7WMOHhiDP3U620uTAbugFPbTm+5GuLGpBQRJ8w4pk8eJCzKFVbD48b/lMGYPUL
         1Xow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564083; x=1752168883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=QO9lx9Xj7dR+z6ghc/H4/Der3pHubXLFP26TReD0VPlxRmok0ioodIkbZsVR4uVhby
         L6UL3ncA+OE1zdG3jJT60gpX27hrzDM5YhowOchXO01YRkSy3GjHYNtqNTH9IKYtQ3BO
         CV1Q2FERpKOhtxkb6F2j/ykc8bRTDzNWeQqg9yICRh7kpeQzXpMh7hS9Wja8JPXlgXY/
         8D1eU4bbXvKSyw7YnSY5DFSmPkyOI7nFHPk2g7Y75LTQY06QcA5AGd6ljQZ5VMXXCjEl
         1cP7a9oT1VrfiNcaU4Ja9twPT6z1UFvxdU1c0IPFiRApOra6e+MUL2HSb/YaiElEBA3s
         Zn8g==
X-Forwarded-Encrypted: i=1; AJvYcCXSPwLPccrGyMfM99GceKb4ZhmQGN43HauPDieD0bAivBB+xtLwlwVRfEXoZcToWNJG7n4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlwyvG2vApj7tmCPkpGdig2tWZW7HwB7AiTQhPaYQdEXHiCnk6
	QwF3377BdSzjwV7/k9kmujteNQIFkzvaHRhlQ6Nx8sp1NWkry1XIMc5qCx7od01t0to=
X-Gm-Gg: ASbGncugTyLCtvp7tE816OKFN3zNBkU92xDgi23KCjN9VM1ZRRLx/S+Ft/m+2qqo05E
	CZ/aw7X2yi667PQgKAPxNDZI7K3PR/Phie9D7p3neYTdlkkSBiJwMD5uEOnc0IgLUUnvKIzqa90
	Kbwyn/l1dvSVW7iIxBvG3qLLZ4zp83lU8DDnD7uwI9SpjhvYOza29E4NJIGfFFOonJr0sioRK6J
	M0b/85Gu35y0LwQmsMYhP8aQ8SFVo5jY4qNm1n7mZHZamVYtaQ8b6Nj7AH9Ct2GeGIobB+z64jT
	2EhztuYsuvSpJs5KQ+WQLS7k7N7fpWDb1Q5LKgszTj2xIEglfSOqAmr9QBGQJaNzvh9+Zh2C5bP
	ZDKraltHMB/yMtVzqLza3VYYZ0e0ABWl2ecPq
X-Google-Smtp-Source: AGHT+IEf7t3XY9WG5MiyINoO7fyv1zs6ACiM9J1a/TjKhFcJOEWEm+sjYOgNuSXDyqWbySjiSaOs1w==
X-Received: by 2002:a05:600c:1c9b:b0:453:5c30:a2c2 with SMTP id 5b1f17b1804b1-454ae6124a8mr32945485e9.8.1751564082777;
        Thu, 03 Jul 2025 10:34:42 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47225afefsm311104f8f.82.2025.07.03.10.34.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:34:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 21/39] accel/kvm: Remove kvm_cpu_synchronize_state() stub
Date: Thu,  3 Jul 2025 19:32:27 +0200
Message-ID: <20250703173248.44995-22-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_cpu_synchronize_state() stub is not
necessary.

Fixes: e0715f6abce ("kvm: remove kvm specific functions from global includes")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index b9b4427c919..68cd33ba973 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -29,10 +29,6 @@ void kvm_flush_coalesced_mmio_buffer(void)
 {
 }
 
-void kvm_cpu_synchronize_state(CPUState *cpu)
-{
-}
-
 bool kvm_has_sync_mmu(void)
 {
     return false;
-- 
2.49.0


