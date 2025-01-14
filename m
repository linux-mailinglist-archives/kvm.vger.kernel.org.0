Return-Path: <kvm+bounces-35477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FBDA114D9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18C04163EBF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC802297F6;
	Tue, 14 Jan 2025 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RvDO2C2h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515FF226887
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895534; cv=none; b=P0nSdy3uflxdg432pJXGw6asyA1SUtSfPu3NOVzOhYU1wQepkph89BJhLagRtOLEc9GfQMnYgldrJA4pkyPxbiipl1xmbAT6tpMkjy9p3nJtVpAdkQNvF/J5oD/d5/MlNF4MhZZPOBMKuZGlhwpSBBjEmIDTZ5nmLyg50qB0xps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895534; c=relaxed/simple;
	bh=XLVT31H4OpbUW1OFu7GetTjAoQ6wx83TWJr3zQGW1j8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rp0bOftyVWvNF+x/jj5ctQU2ZOF55bhg9goMyP0QIOGwsQkkRAuyLWkX83EZeyCr+o9K5TC8GCcqoFllX8WXi2N5KVmuKZHQfGCHwnPea6UAI4HD1+lAobFw5d5mgVI0Q8qG9ai1CiMsfapnjTX7xxJeqoV7NEdRlaVTQN0KGBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RvDO2C2h; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2167141dfa1so4673255ad.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895532; x=1737500332; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NGMQ1cPPzFcGB6lbht2UloHcbpdvl9Eg+C6+XEyyV4=;
        b=RvDO2C2hGJ/WOQl8mgjQbq1/QyLg3EvEk59D2f0wy0xPrZAT7spDO6AmxF5nvs9rEB
         kIEHS8ti2PGlCvih5KXT2Did6741YrWZ5gLpTme8+IGC+IXlKAPYzrYuqPgrr+qR9Stv
         exooGCQWsHZs9K9b7AJX2adyx6jZZSeruQ81KzZ+7+xiJa54t/xlI7Up3ZoD6V73hhMg
         G3bWf9zYOjncsXW1dkZZkMX3BIE2vAP+aLZOF1qHh3GyQtYsZ5o2b3mo9C6UQF/KpSUz
         CxUtj8zCYnd8qGIVe0GOfyTi/1tPd+c9WKTJrVD97Q7TSU7WDzKixUuLSXo+q9Vg02Fc
         L+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895532; x=1737500332;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NGMQ1cPPzFcGB6lbht2UloHcbpdvl9Eg+C6+XEyyV4=;
        b=YvOvQl6pZd6tVhqPKnJlV6LtfKV5w25tAGbZ34csgcnLnq6jw9XFGPKdYpKY4GHY0o
         Mtdo1GnhpE0Crmpcr1g4fTLCNa2crBiLwPr/vZFMOOJKCP7JDCbm9RzSdLz1SjecxtQg
         B93/AO77psdsvaP2oprYpixBLsg4scCn4g/jlTUNjL/qx8AhfUuKx4u2lBr/wrgP1fcU
         C0a6hJqV8fsByBPcorSAoUNpSouqbyZrp/5lYbzps4533waTRzptb33dcu0q02voZvgW
         7alYH3fBzpeDDaImthAcy1DzfetRJ3rxHC4uhMUm3ZiXb5OCP3tDqKZkLCq7r/W6/ym1
         4Q5g==
X-Forwarded-Encrypted: i=1; AJvYcCUtvNt/u3h7h4IPhCNz4bz64bCtzD6vUk8F+wRj36F/K8FW0Tnhnf+GcGagTUW5oeisr9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOCVRaQJWOavSwZ/LqHBLTffUMDF3La9/ER/Ik4AU0PLJ4JMyb
	EzRA+R15nPqRXOnVmU98xKPyeMCG5hTHMnmXRKefxqWJlCMmEgvAxtWt8ZtBGEk=
X-Gm-Gg: ASbGncvlnAkUuKuXxIdv08hest2xmGcMAQtdK0LXAy4OlJLC9YpwA5jzlWTkGnUeXet
	KWMBOxsr4pom3Sr2+RgjfsguMpDv0nY2EczfPdQI3rUkUY/t3jtq10+9vmi9S8zaXIYdIwtvplR
	Rw+8JX9/SMj5QV1mKLqodLzGUEuDXeEmKImL71xX+TwM7Ud9U7d5IzE3nZ6Ps43JnnA3HEXpxdy
	BmlVtWHv24OG60dDpi+Dq7hZA3lWuHK4qn/qpwey9oGwBg6u9Hn5oa3Vf8AmJJYugbNhw==
X-Google-Smtp-Source: AGHT+IGY7+84arGT8AswRpB+pqwECCjX/DmctkDVIPDIQHV61usZj0/p7BRGYknWv9dWJ1AzycUGOg==
X-Received: by 2002:a17:902:e892:b0:215:6c5f:d142 with SMTP id d9443c01a7336-21bf0d16349mr10455835ad.20.1736895531696;
        Tue, 14 Jan 2025 14:58:51 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:51 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:44 -0800
Subject: [PATCH v2 19/21] tools/perf: Support event code for arch standard
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-19-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
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
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
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
2.34.1


