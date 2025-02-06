Return-Path: <kvm+bounces-37450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B01C2A2A245
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3398D163033
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2BA22687E;
	Thu,  6 Feb 2025 07:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RWAb6xQK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF76F230D3F
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826629; cv=none; b=OQjIo+CO5ul7VHEfj5JH4THzttv0ZFedTrEjC4g70PkHw/axA58T17fNnoUI/V0v+bJ+7qDVg4EwqMzWbYqUBcbMO0ZLyrpNSW0+w04nc7tFmMGIgPlm4ExOth0FMMI3gAOV2TsbbOmBGwMHqVBANGEbV7/F/QTZduNtA9kKdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826629; c=relaxed/simple;
	bh=IBxnU3ydPG0bB2kpeX0BkhHAerzpJvmDLUPlDz6jJ8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XtnOtQTVfHc2OyiexJbznNN71fBLVK+bXz+Z0GYxklDFxD5+hiFjGSXeN7wV9CqrEWXEz5HDEabhuW8+3EnftyJ9r3YKXdxWoGc3Rpd422wVDPXax8jjsdRWPqQI2LYeLwp36HOFUNT4+wC1PvEeiZGEY7Sd7EqwqnzlbX0XSBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RWAb6xQK; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f9d5e0e365so787748a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826626; x=1739431426; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0m90EFTzPOvQUeRyWgUOuFclvonVx+b+5YG0+Kl+Is=;
        b=RWAb6xQKu6eQBf/J6luhZqudt3fw9BqwB9NrOi4TZekhL6YTPPPyX4wd3jsadMtivp
         9AYjT8ZMrN8VegnUSj/7fLVg5Un7OtoxlOZ/TQuNJyJSFlDwi9XozgEcPBhmuUNVbygD
         szQ/aHhmg/OfQRLROU9KA7kREbDYvUMGaY841LrHv/72FtZBYKFXqP3FlVL9MuJxS6D7
         XJF0Ydu2gY3G0bbBI82iJMy8QSR77baD29TJxoQOi7cJeE0fuahR5qF99EHSzsBek6d5
         VO0344JOayC4d6X3USvGfNh753kWbEOEx1F/jJb7COvfiaegGhTlIODN0C41GCe2UqeY
         TfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826626; x=1739431426;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0m90EFTzPOvQUeRyWgUOuFclvonVx+b+5YG0+Kl+Is=;
        b=BfBpeksbzX7khlRQ2fFu/sISJpscA84AU5fB/TZn+yvLjEhbjAzJhkYaFtWJM+PwI4
         3kj2hZl1TYOesdPj1o5AFSEbjsMZ4wa6vnD1dcVRr+OWitiG4iFr7T1gcJJZ2olEbWS2
         OwGyb0/z0uDZq604mmfDbjfVe7A2DLsI8uAEn4Ginwrq2Godzd+HNctPhOIGrvEMQh6N
         8HIKxDcNWI2jXtFA6Zemz/BuTHeQTMEGb8pF+e0/ZT6sUMIpKmpShW8ubAtafbUrKNte
         7hIVo8pd1CxKICAHtFvvCvubIgilzN0fxJTxuC8wAbx8ekWVa+gRihC/frmRiwAKDiBk
         spqA==
X-Forwarded-Encrypted: i=1; AJvYcCVZucHYzCOGy6CF3oc4EcWwDHuUJnJhL7X5ttob89I7NodpWpPDiUtV3ph8rO2+Lpb4VdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUZYwvUVp2gbGilvTxQpfZrfOjo5Olc2k6Q4ALHwJwdMQxCaLp
	2s0yYv9hsgIpz3/8gzBBbXcOl1Rk9DrFD7Cm7n7ahSP3KEV13w2xEHVayBzYORM=
X-Gm-Gg: ASbGncsRiWCegPvYbtcfB5UuRQfVRufVfCJaYZsa1qvjFSxApV2F/m99XAzpIZ7/SxW
	0P4bNA9DTxNZ/UY03weJ8adiNfmtzaOk0oyLWjOu+Sub0tPW5E2evgmSSo+Az2XPECYX4mblI8Z
	ywTBlSkOjOK7SYuxIB9LeKye6KR3tEuE1/o6Q5sbcVJQCWK/K/2X9OQUHoeoiIqGFwYGl/5UuzX
	73sCMDqhWfWdQH+HC35EMlom86Hvy29gNRSxNjPDszcYAjDsE3AzGxpxFCIlcfZcWBRILBCPZHz
	qq7vspVr56BlujWPIxAOc7Yt/tQp
X-Google-Smtp-Source: AGHT+IEr4tlm3eTboE2LI3UyhaNgjHemEhg+pKT/VKS7IwKjrB4u5O4IbJdLoprF/7S1D0FzPib5Yg==
X-Received: by 2002:a17:90b:1e4d:b0:2f6:be57:49cd with SMTP id 98e67ed59e1d1-2f9e080012dmr8950112a91.25.1738826626207;
        Wed, 05 Feb 2025 23:23:46 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:45 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:24 -0800
Subject: [PATCH v4 19/21] tools/perf: Support event code for arch standard
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-19-835cfa88e3b1@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

RISC-V relies on the event encoding from the json file. That includes
arch standard events. If event code is present, event is already updated
with correct encoding. No need to update it again which results in losing
the event encoding.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/perf/pmu-events/arch/riscv/arch-standard.json | 10 ++++++++++
 tools/perf/pmu-events/jevents.py                    |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/riscv/arch-standard.json b/tools/perf/pmu-events/arch/riscv/arch-standard.json
new file mode 100644
index 000000000000..96e21f088558
--- /dev/null
+++ b/tools/perf/pmu-events/arch/riscv/arch-standard.json
@@ -0,0 +1,10 @@
+[
+  {
+    "EventName": "cycles",
+    "BriefDescription": "cycle executed"
+  },
+  {
+    "EventName": "instructions",
+    "BriefDescription": "instruction retired"
+  }
+]
diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 5fd906ac6642..28acd598dd7c 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -417,7 +417,9 @@ class JsonEvent:
       self.long_desc += extra_desc
     if arch_std:
       if arch_std.lower() in _arch_std_events:
-        event = _arch_std_events[arch_std.lower()].event
+        # No need to replace as evencode would have updated the event before
+        if not eventcode:
+          event = _arch_std_events[arch_std.lower()].event
         # Copy from the architecture standard event to self for undefined fields.
         for attr, value in _arch_std_events[arch_std.lower()].__dict__.items():
           if hasattr(self, attr) and not getattr(self, attr):

-- 
2.43.0


