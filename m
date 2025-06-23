Return-Path: <kvm+bounces-50317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E25D5AE3FE7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CAFA169DB4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F216024A056;
	Mon, 23 Jun 2025 12:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jjcGzoxp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666942472B1
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681162; cv=none; b=hQm7dsEprKkUvYjevESAARpi0oBwUeGs01/jXFNJIIPzLI5N0hKMbD3NKzNwuC8BaJn7AZ13zU4PN379vxdMxPzgciQs/brlNOkSUKPi7rw7+I1PDsvWMZWDirEo1mMagnjLw1HG4jmMyhwHuXALPPRYdKjSL7dUqmiUAaxWKio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681162; c=relaxed/simple;
	bh=s8AYUJVhitMgriSi44XbBBxGZLmELZPQQnl/IAtiIRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWyDEKv+0Z1YziBrsatvfss+cXUD7Yb8dULmYjHqyH755i95d94l+aYt3uEPaa/FAcZgKm4Qcjo+r/T5Jm3tRMPT7jESUWotMMarZ7ydlW290hGuKXRwKE1KY1kGucPKFztWoLsQezdk4xGV1X8CtwxlxUpmVhXcZ8Jf9h/eya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jjcGzoxp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-451d6ade159so30792675e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681159; x=1751285959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FtS7m+vqlh7Qr+Y7luF/PvAhAhpP9RBj3It7GX3FL/4=;
        b=jjcGzoxpgxDPUSO6vRV1pkIajXfcmoXbB5WvP8KYshnJ0mX54L2LX6ZD7oC+z8olQ8
         F2Gve52UwLGr2gmJigrFsTapmnn6ZFu0SHXgXNr0wUZdd19d4N4jTSiEPOsC3M3O6bM8
         EXKPhd+WAgh+iXVWfLMt7lTtgehmn/ZRYGnnMje6Y08OhjoAV2wPAhChfMOe23yS5wXr
         1G93ZDPqcoCj36nAYMgK1iDphHZXsczFVVq4cLKyVHVbDK5XkmPbcKoHp0h3DljvK3Nj
         sUdvTPYHEXR8pFKKlDrqQ2L870MocSp3rdIUwiJVI7WiuLKE0fyE+ohbhR1pOP7SvW/n
         7urA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681159; x=1751285959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FtS7m+vqlh7Qr+Y7luF/PvAhAhpP9RBj3It7GX3FL/4=;
        b=kLykvEUeZW0Ki8DwwJXFdBIeSLr+JRDzMn3ID50WhlwCjrcenv0fhoBhjEAiRx3KMg
         mqTZaa+TxpW6jDFuqAfiERFZygQ3VUOyfwF7SmXB2VD5hJ1h+bxE49IxQJYZY/nP3l1R
         JICn8PZvWBxu6K6OO5/4oGMFRletlOS8nZ0u5TALU1dJGk+z3qlD+WvlZAnATFOjJAXh
         mBdH5/J3XCnA94IcoB7eWyZYJR7HTkPs+LqbJs1dJLx5E7u/mrZYJ0SQCyjlKBKimp47
         MbpVJwz9y1nvWwE1b/1Qb7bOAE0RL8eSIgRiyymWKQPPUS2RIJtdCMZn8QB2eSC8wRm5
         Ya2w==
X-Forwarded-Encrypted: i=1; AJvYcCViV2L3N05TdGJT/M2CS6+a3OG105SEgb3Y2d0tjAfLKZKm9wtktGFWK2W/rdj72PU6BFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU2y4UZVK96hMBM99nWA+yKHUw0BMzxY2WsTCyb80VtaFO9p1b
	m+L/vGzBsMK5wpeyL2m/g2urcVAxNi0h+vT8qSMrn+JZwylHhe4A7bAaGeies+Qv4rE=
X-Gm-Gg: ASbGncu49nZyTzt8K4tAQmHzQ4Kafgqa2xrV8qMjigKZVmML4j+zQWxjqeahq93G7eY
	hqkkCDYHDE1UPcMh5UgQTPESQ/zwxQhhNRjnYrkkeKX4cFznAf8RvxZ1/LGQNwCDRkRjQIHNewW
	og3olTnmjaar3iKupdiT96UhIU3xdmY0WfumjffHk35mh252//43IRQcc/47RbRuNEjNq6YcNm1
	00AA0LdBP4qDsjUqkSapjQTu1XBfCuHo0hjSBHXqvdmxAwO39ga2kNFjUNPOcwJCnLVhgkpTDZ0
	aKz1gl/9FO2hskWOLAqAQoGFjBUDDwm4YiIuEC+mDfVS52xng8R2UHqVuhV4f0tCXAieuIy2ex2
	DhYHFa9oKcFwffAZO5128QPMuN4PVJ6bdRqfr
X-Google-Smtp-Source: AGHT+IFl2eAC2wXLNGcTcgz9pBye6T6IVeM4BN03TDgb6Vv2/UKfmtbrc+hijHKDuuTiPnREIJvcsA==
X-Received: by 2002:a05:600c:314f:b0:43d:8ea:8d7a with SMTP id 5b1f17b1804b1-453656c313fmr101273355e9.28.1750681158702;
        Mon, 23 Jun 2025 05:19:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4536fefd2b4sm51673585e9.36.2025.06.23.05.19.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:18 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 06/26] target/arm/hvf: Trace hv_vcpu_run() failures
Date: Mon, 23 Jun 2025 14:18:25 +0200
Message-ID: <20250623121845.7214-7-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
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


