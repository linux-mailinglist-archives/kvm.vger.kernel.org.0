Return-Path: <kvm+bounces-50073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34959AE1B76
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A196189F0B8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277D428C867;
	Fri, 20 Jun 2025 13:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I/xCXEnq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF628C5DB
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424868; cv=none; b=VZcvByeJf/Z8NwxsGGxj2J/UetNYkj9LPT+Uczln9PhiAoH35cSmInKVZsHhuM4BxGI5ReU4TRuIZe7PeIL14Q4RWPZDUCf5ZjPOOjR2f1vW36vnw5+MVk191R+IEcQAn9jOwhfNOa4TJFHqmIwmvsbLeCgKyR94jOJYzkODTgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424868; c=relaxed/simple;
	bh=s8AYUJVhitMgriSi44XbBBxGZLmELZPQQnl/IAtiIRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvPBiNVi1IvZgRb2QafY+kkFG92jfe46VcFFPHDdgv6XQIGei8vVhSuaSLAOKEvyyWEqZ4dOXYyCz8xaXdz/vPKdIZmkp6zB+ACTpLeDsvLW0u8KOWmoyrjRiu39qORCen2nOSrm+PWnvl8WkiZtMFi7Of0wUmroaBbsGTofQd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I/xCXEnq; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso1475142f8f.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424865; x=1751029665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FtS7m+vqlh7Qr+Y7luF/PvAhAhpP9RBj3It7GX3FL/4=;
        b=I/xCXEnqWWpYXlICwQ+w91sWY7Fq0BDpZB+J7nRFnwPzeh7d4mUP7r2cjnuxww6b0X
         LFMEBKbXz6xxQZqwOYkOhCZ9z4YJo8btFGArqCRHX9H8/SV/QLxz+RRSVXWylKQvYYZm
         YPuIY0FfFM+WRmaSTsL8JGRtONjksKIpSB6DRNLEbhUOv2hDQp9yanZCVD/7ts0p35ep
         uvlGFzXItcIJ2OI8zE5A6ZQJxn2T/2hQR1A15DUIHIsFHTInhhWkK/c8mA4NHlhRPQDS
         XKKTABm4SV7J0ONPKrYnO8svGsWZ1Lt3/jiWGE95A3+8wZ3DALN2qNEgGbO5Xs0HaDL3
         YIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424865; x=1751029665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FtS7m+vqlh7Qr+Y7luF/PvAhAhpP9RBj3It7GX3FL/4=;
        b=l/FLHM9o9UjDjYC2We32zXMJBnij/+aiO4XwRzTkChwAy7aA8kq5J3+CegwNVlvrPi
         MJeZnEF7MdU856aULEDsjYX9KavwuaFxUp0XfBdL/bI2mTYXN+iPYuR8eE7FHECVDm0y
         VX+5YQf14x0EIG0Gnr+V9KwXivKzA4xlg1HEf9bQvUoBnnwBt9Te0GqJ285bXB/Ehz0A
         L0qNtDd+8WMufqVQPekx8bbos0z5f42OQ8DjHwEdBo7ZDLD22UA/slgyuo23JSAC8xFS
         zRSdIResDGHfFq65BxsDcHe785jrmjjRuuYtsR3PJDEGkeCja5G09+/UX05G1v8R6pic
         JEUg==
X-Forwarded-Encrypted: i=1; AJvYcCXRZ6GUuRra8JhBvYyoLmjfKUS97rXBy9Bw7eex0/l8IsMxd8m1OUEJvnTWDyX85PX4zeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLDyouwjD7LdNYCiph+3wkExaag70OuTg04IiVCZP31nzN5OHe
	lEjdWae3iaG+jDht/Dx+R0WfVS8lP4FmRcmhh79Y9zgoePBb08Ik6aLswbAtmDBtMVs=
X-Gm-Gg: ASbGncudr3/IiJGVira7/ncGJGuPJnuL6u87KnupH7dpJA7pErdR1kdqabXHr/xdrXi
	E2uUmRfdllld93EnOllHKgKJAydBVud+gDM7ydEadekUOgU5TbYY0F3bNHqbibxABwK00eM3TEh
	/kiW+eaon0ZTizu/KD2jwci6EY2Mh0KjBiHBd/JCQkAsDXSdYSTOtutKu6vPRkWFnCuVElOvhh9
	t2Bq/euFzy85g1MeaYJ8dD3W7hFFa6QCNF2ajp1qCZwO5VPvw16SY5epIB4+/Lj4n4IKP837owp
	Rf62L1Nilj38K1RgMwbEIw2bB1q1XtlDukTtqBacdkgQznUVxmLrrdujelIqadq0cqjZIZboY0W
	3pXo7ffGza2Oow0es7gcskLdKWYognVBj0sHC
X-Google-Smtp-Source: AGHT+IEu8ioD15jbsMdE6dCvAm9djKzVzv/o3I1P7WHIydoF4yyDTcP15aw9RWPaSxBAHXijuGZgUA==
X-Received: by 2002:a05:6000:310a:b0:3a5:8cc2:10aa with SMTP id ffacd0b85a97d-3a6d12fbab7mr2059859f8f.32.1750424864938;
        Fri, 20 Jun 2025 06:07:44 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646fd6efsm24774235e9.19.2025.06.20.06.07.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:44 -0700 (PDT)
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
Subject: [PATCH v2 06/26] target/arm/hvf: Trace hv_vcpu_run() failures
Date: Fri, 20 Jun 2025 15:06:49 +0200
Message-ID: <20250620130709.31073-7-philmd@linaro.org>
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

Allow distinguishing HV_ILLEGAL_GUEST_STATE in trace events.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c        | 10 +++++++++-
 target/arm/hvf/trace-events |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index ef76dcd28de..cc5bbc155d2 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1916,7 +1916,15 @@ int hvf_vcpu_exec(CPUState *cpu)
     bql_unlock();
     r = hv_vcpu_run(cpu->accel->fd);
     bql_lock();
-    assert_hvf_ok(r);
+    switch (r) {
+    case HV_SUCCESS:
+        break;
+    case HV_ILLEGAL_GUEST_STATE:
+        trace_hvf_illegal_guest_state();
+        /* fall through */
+    default:
+        g_assert_not_reached();
+    }
 
     /* handle VMEXIT */
     uint64_t exit_reason = hvf_exit->reason;
diff --git a/target/arm/hvf/trace-events b/target/arm/hvf/trace-events
index 4fbbe4b45ec..a4870e0a5c4 100644
--- a/target/arm/hvf/trace-events
+++ b/target/arm/hvf/trace-events
@@ -11,3 +11,4 @@ hvf_exit(uint64_t syndrome, uint32_t ec, uint64_t pc) "exit: 0x%"PRIx64" [ec=0x%
 hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid) "PSCI Call x0=0x%016"PRIx64" x1=0x%016"PRIx64" x2=0x%016"PRIx64" x3=0x%016"PRIx64" cpu=0x%x"
 hvf_vgic_write(const char *name, uint64_t val) "vgic write to %s [val=0x%016"PRIx64"]"
 hvf_vgic_read(const char *name, uint64_t val) "vgic read from %s [val=0x%016"PRIx64"]"
+hvf_illegal_guest_state(void) "HV_ILLEGAL_GUEST_STATE"
-- 
2.49.0


