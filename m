Return-Path: <kvm+bounces-51436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0439EAF7133
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F82A16D49B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5D72E2F1F;
	Thu,  3 Jul 2025 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ghSrnDi8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CFB29C33E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540321; cv=none; b=m0jrFk6d2/dRpzvnW5JVqLnYdn8wi2Ix+4Br+HTK0mEDVSyptKdF8ej6ls+KdQl8sbcEGA1osSwVxVgbR6Ink6CBLNN2h5hpPJKrloewCkBihRpYQRgUrojBVeUCYI12HOttQel53S/65KI6KHHlx0Xb0oEwK4YzvtaNdYWsNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540321; c=relaxed/simple;
	bh=MiAyjbPyHROBCXFeYtbj2oqtMznIjqfeFEkSMF5n2dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PdZevVcLLONnTgiCSs2SfvNbDXgmTUtjTh/FurcACLtH/HaobHox4y3j9Httn4Vsa8PKjYBqoGClfh2GQsnyo9IzFxnTAQYUsj42D0rxF9oGQCdn9s0gQzPpzqJXnbiA8phQwrMukslmY6vnJUC6cH3AHgNP+kom32K4ll98fjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ghSrnDi8; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4f379662cso4653925f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540318; x=1752145118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXEwQpLJNPRsbrPUQjvTni2WYpP8FdNuXX6y2BMbIXo=;
        b=ghSrnDi8o4VRUiqYzQKCRJjpa0BbpADMuuK5EdEJiOyhDVzjoHhYELhYxLu/UkeeLe
         6Lg0uUVJmfc07+KIas9P1K3hQle1ZDy8X0bgYds0Fs/E1yg+wdsyCF0Qi0yNhfQSg2ZP
         lUxpgQZh7VuLWmV4PCVEn6VUTk6WCkr8vdmykb8iSyb2VrrCP3jQkzzDqALF6XG3+IQX
         0Z4cOvYA40nAyhX2Vne82BG7X87JdhHK6Ju60/QPcSnpBoRronwcDGhxquoLJxfB7AMI
         TfQouD32IYxSb7ZwQZUYx1z4H8SLsd+/T/REJwKSrm8PdOXcspwW4ta9T8pNThukO4c3
         L8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540318; x=1752145118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXEwQpLJNPRsbrPUQjvTni2WYpP8FdNuXX6y2BMbIXo=;
        b=fXKXurcBU3tgrZfC3uzvyxNWbWzw21ogVeEw9wBqxG8P8d/L2xRcIFblI470FSckG+
         gNMPyZXKYoIzcCbHxs/Gv9St0yMwjTQtj+dYFSc2xceAza961pq/tInvThxr4WTmdtTi
         SJz1vg0meh3NrAmR/0F6+GMd1B1O4ESTsjD//dnU1jRrUN9EPW1ygALDEcqNiYPj7Kpo
         OimhsZ4pi1bFq4Z9r7xhrn1zD5dAwal1Gc4xSvEp22BBeOUid14Uv3NUCDf/RKPztJ01
         HwAZW2nu4GPnuvuXKgYoAgU43dP2ceE5pn8g2dgK9hLAOHU1habcxqq+z7TAfoHbVm+Z
         Oo5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWQazWGVCG+/1p1Y/UrXzTxQdFFHr9hUED1ZylECJ6E2ojYl+SUmIQNAOLaT4ephWfDc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFMfdyaWGePaBWJpht08ZjuzbG3j+f0kTTjPsV3Phjyg3GEBhc
	m4LNQRYK8FhINZStwCEHFRWiE5W2Ij82F27xqeFJ6TaYNo8sBBhAzN44wljB1OrNI7g=
X-Gm-Gg: ASbGncspVCg1meEOhlrlpHJFocMK6R7epffY7oPHdzrylEechlYS2kieALDzJ7AjavW
	eaOoN0feWEQcHDperqQ4Ing1kixEX3C9xsF5qw61Tm1Oyv8Q4S/ST+FOVCHZK5kC9a9hGvNwrF8
	1SkdyucitYWcoAZb3Z5o1tdxDoIlLlDa7v0L44QYbyy4T0Bt5w2TIFrdYnhQqqVyDXriHTbVBKZ
	1IrMNrkdAH89RlwfQhJAWIc6smURrm2NI0oP6JrGt2VJQipAZ0RTZSUFt2sm/qvdtHWdISi9jCN
	4tp9CY7uk3yIssc9rRQ/hrhLN0Mpm3upxEBV69eqxYV6Vg1r7huvjUZLKPX2fSKCkMfilAmppEv
	Lfy8J+qnVZes=
X-Google-Smtp-Source: AGHT+IEDeve+hxPyKdiNduihX+UkbzFqIDkknGnvYLjOBdrA0tfyF6dpvjNV99JhtblwgCC6TQDZjw==
X-Received: by 2002:a5d:5f92:0:b0:3a5:1471:d885 with SMTP id ffacd0b85a97d-3b2019b7da6mr5691035f8f.56.1751540317731;
        Thu, 03 Jul 2025 03:58:37 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99c1186sm23334265e9.36.2025.07.03.03.58.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:36 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Shatyuka <shatyuka@qq.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 33/69] accel/hvf: Report missing com.apple.security.hypervisor entitlement
Date: Thu,  3 Jul 2025 12:54:59 +0200
Message-ID: <20250703105540.67664-34-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We need the QEMU binary signed to be able to use HVF.
Improve the following:

  $ ./qemu-system-aarch64-unsigned -M virt -accel hvf
  qemu-system-aarch64-unsigned: -accel hvf: Error: ret = HV_DENIED (0xfae94007, at ../../accel/hvf/hvf-accel-ops.c:339)
  Abort trap: 6

to:

  $ ./qemu-system-aarch64-unsigned -M virt -accel hvf
  qemu-system-aarch64-unsigned: -accel hvf: Could not access HVF. Is the executable signed with com.apple.security.hypervisor entitlement?

Suggested-by: Shatyuka <shatyuka@qq.com>
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/2800
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/hvf/hvf-accel-ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index c07ebf8a652..ada2a3357eb 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -337,6 +337,11 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
     }
 
     ret = hvf_arch_vm_create(ms, (uint32_t)pa_range);
+    if (ret == HV_DENIED) {
+        error_report("Could not access HVF. Is the executable signed"
+                     " with com.apple.security.hypervisor entitlement?");
+        exit(1);
+    }
     assert_hvf_ok(ret);
 
     s->num_slots = ARRAY_SIZE(s->slots);
-- 
2.49.0


