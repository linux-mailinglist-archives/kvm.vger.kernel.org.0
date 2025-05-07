Return-Path: <kvm+bounces-45796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D32AAEF7E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81A60462664
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4244F293B43;
	Wed,  7 May 2025 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S1OuGaum"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6408293738
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661391; cv=none; b=Zy52mL6KhK3EZZhI/ctMNo6Jkq69XniqG7mXc2kZqJb6WVKelJfAl7OsCeyJ4t0ONC1plxrkFd/17ETlMPi8304IkKNXe05AcZ9KTlY4+efGw71YO+RouswNStkHOQ55zLPCUbKB/3pMzZjuOSvGcXnUUgPEO/2YyJOFhwbKuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661391; c=relaxed/simple;
	bh=QNqT5wxUJw1JENK4ivUPpOR9HvorI3Vo5lP0Q5Hpzc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAO/N0SEFfe7bikvCe0Qg/Dq8dDFeiB9oIsmykDSt4VNLELGzfAx1HawG39ENvbVBUlgWbfllL2s2U/KMb0T8ekBLyOaAJAem+Q8aOnzOnkfbfZDcJwbnhYCtjQ6a9E+HDLReI+e6JfbtnYqFxm4spMb2bacbPDKn7jV9BTIUlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S1OuGaum; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-30a9718de94so459072a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661389; x=1747266189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AGfH/it6XrbUjxeSHUy0wlg4nMt2R7aYVYgAEJcCXI=;
        b=S1OuGaumjz1Wn9bpYh3IItAjptNSMDPZUXkQSRujRVejDvwl5mNB7iSdxCFG/MrGrR
         mIEHBs8NXstO+vd3tcRvH8pHeWSnCIyrei99DGD2nvuvdNYdzOhQuLbyhlc1xk+aCfQR
         3RGSpkFzvUinsiaMgpCQHhU/HouriYE2tGSK0ab3uhePNSdsaFoeztx/ce/z6Y475ZEV
         2o435ppKkZi2UdX6sXif5uNT/xSxj9LCCBSuXqjerbHIPOm0QUouoar2qhPvK8fM90P7
         DsNHXZPBIlkzoX0rONKoyS+XsMnUh1uuYpfr4bOQF2BQe1zdfiz10onxXz+CBn/XaiEN
         baAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661389; x=1747266189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AGfH/it6XrbUjxeSHUy0wlg4nMt2R7aYVYgAEJcCXI=;
        b=PZWS/kYZhtnVAxcZKnwJqnB9+reLMNCC79l14zxqF7qejr+sE5QEuxNwMFG7kmiEqt
         meAmqqcaCs84/cFh2vBnu1FqiU6WNm+a2pcRQHLYv7uHeXHK2YXgM2ddAOG7fIPceiv9
         wJoDBlPuincVTtdmPj5+XDgwKXQOVFjlwhN6JdaHzu8+3akFa3RmiR/lLh7xbwE2zUqI
         r07x7Ioyz4mEoHXpxHvT+ow/5URgxh3gunOOHJpdZYKRzb1vweppq+Xp02elUFoAG3QH
         NHpuoGS9LrR2gTh9oQ6wo5mWW8AIWQPZWdkCvsLKt5XAMnFkH70MNP4hI0sJIKNnM6IJ
         t8og==
X-Forwarded-Encrypted: i=1; AJvYcCX0kgKYDO+xT1QXGZPUhMDkBazxkQNOcGH6FdPNor4J1envpOJQrbmppM0t1ig9V0BXoCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpxUkpU249SHESnVkaQc67oqgIEF8mbpDsG/3kIi1NeSWbd0Xp
	im4w5So/NCX++yaHRGq1wdllx1qm/POyFQQ4jLo+5Akj9RQbPo6u9SE9LcgHdeE=
X-Gm-Gg: ASbGncu/ShLNFfiHB8KwDbOpTOOf7XgufR2akttwpTN0DCC1sfPrc+6KfKDjOxmTSgx
	0OTsZ0FrGGlpp7cpoYDY7nHIKgetwgdNFTgJ1lAmIyik9lYtO3vURV0IhAOdw6CC69f7VGvDE7d
	iKKJ+/VaIT+4ro5WhvYCTfTF0nyOH3g5AQecqqnohAkCy7isOe+nAzBxWtLG+KhrXpJX8IB5+V9
	wWFdl9bXk3wjkxE4r8oiClg5xP8FD/6yCjnO6GVE1nwUcvAzAh5KfGR6vNpC+UbHbUFUWsqOvLS
	Cb7ZfuqyUch09kBPq+/JVajUi6raRAkKcahcYhgyD0qhFieLxV4=
X-Google-Smtp-Source: AGHT+IHfVFswkH2ailGEzkC8ZP8p7efGOpbhAQWb2RgZin6ra0kY9zWRj1hd1EERwyLNkO1zECZsoQ==
X-Received: by 2002:a17:90b:1d92:b0:305:2d68:8d39 with SMTP id 98e67ed59e1d1-30aac19d869mr9690107a91.12.1746661389236;
        Wed, 07 May 2025 16:43:09 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 30/49] target/arm/ptw: replace target_ulong with int64_t
Date: Wed,  7 May 2025 16:42:21 -0700
Message-ID: <20250507234241.957746-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


