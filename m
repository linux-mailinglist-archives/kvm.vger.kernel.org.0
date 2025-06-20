Return-Path: <kvm+bounces-50072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DC3AE1B72
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 245B1188F22F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C570F28C037;
	Fri, 20 Jun 2025 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bLQ1bTlj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E95628C5DB
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424862; cv=none; b=flV5viNdSxQ/KsaVBoF9b1SloS44HdaQGTX/QAEOlFdzzGDxyN5Cxj+0QOAdpNofJHm/PYIZVBFPTjsyeZfpxIpNp7kOpGym65XltNgdbfAXHg6QI3tTUtPY00+D3CwwnDRmYde7BI/kgz0RhFVZovMlW9Hw9WLdsqLIo3nVDjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424862; c=relaxed/simple;
	bh=9hPmivV/bNQ3iD0mbuT0b0MMDsEXSaytQTLAWbzxfXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JTx+oshtvylpRVuIpQzx0QbJIxSSX5Joi3NRgHNidWFJ9YDxLYr8eQH6lEpvvGzBYuCgkPEKdMT7w7oZgtZVPQ2SamnrL/OOTRfZbFMTxuzS3rryffOwpN30ffaKlDw/xJYCj64I6/e65oIENQaQ4Qg1+LQkcO6ucAYrqkpaj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bLQ1bTlj; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-450ce671a08so11771725e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424860; x=1751029660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XksfEnABhqse0vfJxYZJ+Lf0uyahV9aipIl1Sny7z0o=;
        b=bLQ1bTljbXwjhIRUW1ei4Wex2qTCDL2Jp+DZcIfvgxKCdVE8gOUNerafRBfIKdfsYu
         Oi2+PeGmt43Cn/CTeiyvQuPF/UUo85Yd9tdZlflI2NiMAysR9KpRZKKg/LSj46ze4hBy
         XrgS+RdOr5upJ/fYaje1dGraaR0EpL3Di+8ViP1TntYKzeQYtGIGyVGdv8JdSbOrOG7A
         SmMMBJPzbKzqXoW0LPJ12S40cgHykwLmczXikW7nMgkd/45H2fn7GAUX8QII8H8KLxwY
         U1zIeyybu3Z5dH3EkEsTj0ssCDqyfh2sKTwSLiFhucgO69C4sBP3J2GiQzg8WZeMOshI
         cURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424860; x=1751029660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XksfEnABhqse0vfJxYZJ+Lf0uyahV9aipIl1Sny7z0o=;
        b=SJW6OsuziOnvf4z6UFudGp6okLbf7rUhuyk3neL3EwGUrwi1peNgIJd5OJD0yreAgq
         nDauCceZJWoDSFMxT1G46U0WUlZ71ElRsW9iwct71UrrOIv5ahMOoayYksGo1wgqJ/6i
         8xroAaSDGUcUv5Xc74LvvtjE8yxm9wMNwmTzAWG9sYxlTqSOp+WdCwdQ76V+dCiO9JJZ
         D5P7aXLkip9Gc16OfqGYs6WUB5F0Xh1Ku11/ACH3UrPcCrTsC1BMMCgJRcu8sPTEcIQ7
         k51NgkJR0ic1Ez/Kv8lJ6pbVQYqQDycxMrZkzDDH9FHbwe+FDp4ZaYWhUFT0HDYx+wmN
         uJHw==
X-Forwarded-Encrypted: i=1; AJvYcCWr8yHncCW1loSU7IbkPHHGUsj7usQv1ZsMf4P4k8dwKhZjBEoLkRb7dPvlKMt1RM+w2zs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz586dSDY8+0ffGDKcMwbk6UqKWFWebZPMTHMJmXZITv9qNIlKm
	X7xJFLs17+q4VcuU0itoWACQMfK0vs5478Cs4b1rMsysO6JGd3X6bsRLLWJ14AMc8Oc=
X-Gm-Gg: ASbGncs4WE116kslMfMfwn0qWJC314x5HapeT8RxzXawzvFUJCYen9eaEUj2S6+IQcG
	i76cKhVFI4Trde8EgLaR2A6VtM5pEfuGYHtNjkIE1+UrbfbrnP2sIKRWgNw+xE4O/csrwra4gon
	IsIzWIYcSIz3WT3MUdJR/fSm7pJGy98zMEbtKmG/WnOLNY/0+Kpie2bLQbvfmMDMtGMlswgX2NW
	oAamitGLJ+D5JdFmTX6PXCYdWo3FsiLcMS+82CzJb1nMj3ljGmQHFrSYLaPHE5EqJr6pBoz4v4a
	8FBcLRN7iggwNBVY1iuSCZ924Ytg+MranvJJJobw1D7QPgQLhPBXRx/rvX1AKiibphShqgBL++n
	NSHINcCksPHs7CoobONy2+LPSx8CDnz81SpS/
X-Google-Smtp-Source: AGHT+IE/7BsLb9TONAHrydupa8DFXSIV1OrSggLSDyPpvWjke04D0dS/jXyuRBj9Ay/VLjM8ny9caw==
X-Received: by 2002:a05:600c:c103:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-45368787924mr6185275e9.19.1750424859628;
        Fri, 20 Jun 2025 06:07:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eac8edbsm58978705e9.24.2025.06.20.06.07.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 05/26] target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
Date: Fri, 20 Jun 2025 15:06:48 +0200
Message-ID: <20250620130709.31073-6-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Keep bql_unlock() / bql_lock() close.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index c1ed8b510db..ef76dcd28de 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1914,7 +1914,9 @@ int hvf_vcpu_exec(CPUState *cpu)
     flush_cpu_state(cpu);
 
     bql_unlock();
-    assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
+    r = hv_vcpu_run(cpu->accel->fd);
+    bql_lock();
+    assert_hvf_ok(r);
 
     /* handle VMEXIT */
     uint64_t exit_reason = hvf_exit->reason;
@@ -1922,7 +1924,6 @@ int hvf_vcpu_exec(CPUState *cpu)
     uint32_t ec = syn_get_ec(syndrome);
 
     ret = 0;
-    bql_lock();
     switch (exit_reason) {
     case HV_EXIT_REASON_EXCEPTION:
         /* This is the main one, handle below. */
-- 
2.49.0


