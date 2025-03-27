Return-Path: <kvm+bounces-42158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9135BA73EDF
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C04911B60960
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BF5236433;
	Thu, 27 Mar 2025 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aKcPq3io"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75A92356C3
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104205; cv=none; b=A0AJvutHaIIbUYDcL+TCNeTLNrSJtMbBNHbwk3lJdglXNmEE+d6ZwV20lmGkepVKSITJQMwP05qNUFYE9KwKEHCGnFPJ1NwIpsGscjAuYJONs7qQiHh4SL69j+153imD//ktSFBKF3s5/H1aAJio6mya4zrE4/1PEfqF3zG7B3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104205; c=relaxed/simple;
	bh=kRGau/48mTGJ2xTWuPcdi0eoSaf9cQvclbky87zpLn4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j6leNU55Tx3AwmsHEKg/QEd/3CFHSGU216HNc2OnwBy3BjzVOydBTh+da22uwVAfY+qPOkGyhJv1Q+RCgsYahz5fFAR24Lr1m+37+OUyc7+AnQfG099CUqV4Y2raVqv5wt4SePCiZ4Zbum9qzS91gLov7dcX0p9ZoVlj7naMz3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aKcPq3io; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-301d6cbbd5bso2242373a91.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104203; x=1743709003; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJwNDXXlYjKjGqwwgKGhwlhZINc8dMq3L7uwB92VzFc=;
        b=aKcPq3io0myLMqyKgCWWNP9yJlar9YDkGvBa0uOQjm4sUHv/aptzwVzJSeH7pM01Zb
         NdMgKR6Lu1yBRE8AVe83m1OmwlcqcKxAFTIbhVoNp1PwqJzJHsEjtuhVILUCIs1049Rp
         ohpVcIMAYHCKafBE3BQzN7T676Ohomioza+WuPi5sKD3TYv/8ijFiuKWK7pw/LnoErPP
         jCHzTvT9ydfaXHTXajxqmxY805k6lZNxejOHESIuvY0VZWaYxryqFmNvppUsbko/s6mm
         K5to8GXAExmOdE3eBKoFN6qNnNKhyGzUIKlWzQAoBcj6pM+eR9A4kFZZpGOIk2ZVfIS9
         2LeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104203; x=1743709003;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJwNDXXlYjKjGqwwgKGhwlhZINc8dMq3L7uwB92VzFc=;
        b=czYVF4gRsjc5kXS/4umLvVY09B/MX2f3lKpzDde27ttUq9J4GQ0Gg4cjX2PyF4DvxN
         EBQLKOO2dPY9DgYGUwL8k87VPLg2vu9LdZ3+MXWwpteOqoRcuCDnxNqnQcsrPKPgqXn4
         LfsT8RDcbYGkSnb8I7P7yngpt144A/wFe/IRPSyZlYW130Ev99R7HybW3bbq+BbzYrSo
         4Z7RrUzOpCTEXI0ydXP5DD1HmTLZzMe6PHqURe2lgCD34Ie6X3z+7mrUbBGt/1tQ9nZ3
         ckxkq4GzqLpqUp2b/856RQU2why3begeOzfpCo85lR4qVAjXXbpswvZ0mwhAvQKlFHZA
         mB1A==
X-Forwarded-Encrypted: i=1; AJvYcCV/nEHjysWWeuOMSV0v2DNmYgJcAP+tAl4+yKmq/IcaTx50ol4slsF2121IKYtM85SehzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDo0V2NKQajpwB0gcVIpiF7Z327VT1lVjfhB1zON8wMGWja8cv
	h6Y4kAaWb2Q2neVkWc4Zuu2sNCYVAGWMWR0hZp/Fo6M5CvXQgJ2czIuVqlnGtbg=
X-Gm-Gg: ASbGnctOPhWp4Y8VAF9A4LZHXcqGlSqL2uwV6c7wpMQwca2PM3ZjPIWZPdqlJEHMfN7
	oB6+W+IqNvQqgn+XiOWiXf5a1jMhMmkzOnNHg4hfNgt4EG6WJEGtunRgNkQVs9NknJPBa2v4YQQ
	LPW+IrUJilBmVFL1gP7hJTHJma2SBf0hi/80I6IawFpyqhfvAfU2fX0rrKPiU1rAKUmdncn74ZX
	DOP8bcVxYo0Zt2AVIOkYu0lb9U0OhPFTnLXKLcwGoZp1BVzfCdGKTovB9ula4n4l6MbaLD67HpS
	f7xTzGcdANE6XMh1/BM2DTCAXQLiGgcQLKmxOhjBXHh4BCTqzLHsyMA0sA==
X-Google-Smtp-Source: AGHT+IHr9lkacen5G6bNal8x27vd0zlzKk1gXvQpJoZ6ZU4fSbwcKifIx6nJFU8JTt0ZbyyT81dbnQ==
X-Received: by 2002:a17:90b:4d05:b0:2ee:b8ac:73b0 with SMTP id 98e67ed59e1d1-303a7c5b9eemr7219789a91.2.1743104202835;
        Thu, 27 Mar 2025 12:36:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:42 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:36:00 -0700
Subject: [PATCH v5 19/21] tools/perf: Support event code for arch standard
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-counter_delegation-v5-19-1ee538468d1b@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
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
X-Mailer: b4 0.15-dev-42535

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
index fa7c466a5ef3..fdb7ddf093d2 100755
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


