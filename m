Return-Path: <kvm+bounces-36740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E98A203D3
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D0E93A64AF
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED2A1F9439;
	Tue, 28 Jan 2025 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="jswm+Eb8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F331F78F2
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040423; cv=none; b=mJY4Lz0HTfY7bUngHxNO5DWDyiRmY3tbVHbKXNcffgZgEENVobLVE3EFnDMIj0mbOpeG3Xbjl60zNirAjFVR5OOojfoKObzqPCbnKt+JkPIjMT7/snek3y9xlwTsZ8CDSyaAXTjWwj/SBmoeHaX+pxTHNHEp2dlVY0J+5JaEVMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040423; c=relaxed/simple;
	bh=XLVT31H4OpbUW1OFu7GetTjAoQ6wx83TWJr3zQGW1j8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HizSnyXt76M9XXrjA1iJpcMtBMsqv/52jNHePZP8jQxNB+tL2oqbwW/LKBDzw8vxH9CN0M2oUZHtRdAeqmZ6zX8Yr4GLi8CqxZ1rLCf/Zjo98NE0Ej6A3agCWvpBYdj9ZKBB6Gg/XF2XQhhpu/jFHsiWC9BzlayNkUr62+GN0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=jswm+Eb8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ee50ffcf14so9698694a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040420; x=1738645220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NGMQ1cPPzFcGB6lbht2UloHcbpdvl9Eg+C6+XEyyV4=;
        b=jswm+Eb8hNtgHeC/tQi5TkzSonB4gAtEL1V8yy3IQhiKGGPB7cbliSgXn2aemvR6qh
         +6iado6hboVaw7HdksEBBBXb+NGeFfJV4q7jMmCKaSeDQki6Jtb+LLjywQYLk67i/Lg8
         aURCO8dlBsNuu+NGvQcH+q3KjxU2mTHTTS7LN0TaB0VhwjmXd4zSzFX5CHNq+5fvP1Ew
         97qvRVoQTyac1UgmF3TTx7zF+opsDRtg4+BsqQE5YjiB3K8iPw9+UMwoRe/dz/RgYCiz
         4FLoo0N/8OEJLbS9gOWFXzG87Aygh+mFW19ePTYcU7OBooulnzO+hT2w73DBatnHjqDH
         Olpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040420; x=1738645220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NGMQ1cPPzFcGB6lbht2UloHcbpdvl9Eg+C6+XEyyV4=;
        b=Nqpr61JQrD3MbghUqZqvzuuo4sv/YHo5tY6EDCuTeJIQxHpDhx/txUbCLAe4EbDHUo
         s20lkEUNkKlsMX1DBl+1d1C9quZ54NW7E0VvrGg96lEuQvJyKvSMhflQ7rdBnJN490YN
         acG0kEg5P9eQfAcN2k6DbzEkLGJI1BWGsail6zmLXKTf3Wz99yeuTCZG1Kdz6JwZspHC
         PsH3OLbDS4a8S6OnJ9oZ6FQWwlusyBQyUQBFcm13Ga1S/i/MpR4+95XfDj+rSCVhAr9H
         HKQwZHlWBZu+LF5Rlcg22hZl5AtmpSU7pLrbSry88i1D7RHjZhnzsOpCIyS/PCgR+vrh
         6fjA==
X-Forwarded-Encrypted: i=1; AJvYcCXrRuK2T7t2FshD4VeLsKnU5lw0pdNLHFYXYmWF92cB/qfagmbufhUjZfTIyM77VFqMRR8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3ZYq2OoWVakff0LkZT2T3ei3Bwe2LZhO93eAmEECDa88eWnB9
	TQNDvEFRlUQnp3gYUo9Kp8AUQJiPgZFlgnJgx4qYYHQoNJkYFRkN0+Yv5IySnyc=
X-Gm-Gg: ASbGncvAjkwTlzPBfm6ejxx6ztu2LC4A+yyPRNRAb6zeb/x1Ajpdaz8MqIqRbwBGOGg
	Ay40zxt+9YGA5yHuDuWbR9xgU4TI7In6o/IYX8KEyo46M4UdVn7Zc74sLE60nNs3MLmsBMSKDJh
	Kx4/iHN/y8dPOhYefBNTOZPVwQtTMNzdLd/thrQ3uOmYf/7YdOjaIFMM1xdykPnIq8Bbou3zczv
	lRHNg018Bfsp7bq3T8IREwu3jOPCsalz68AyEr3AXpxtYo6cQasaUjkNKJhHLxbwkZcWgwt2Yyo
	rFDBWWPX5l4BYOsx4i0ZNoDaU2M3
X-Google-Smtp-Source: AGHT+IHlFzD2fu330ZMELwraV6ApNuAJVZ8yRk70aKuZKIqzynWDWx6XkmlUYZuDD9VCxD1qqsAaLQ==
X-Received: by 2002:a17:90b:6c6:b0:2f2:a974:1e45 with SMTP id 98e67ed59e1d1-2f82c0775e4mr3067861a91.16.1738040420191;
        Mon, 27 Jan 2025 21:00:20 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:19 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 21:00:00 -0800
Subject: [PATCH v3 19/21] tools/perf: Support event code for arch standard
 events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-19-64894d7e16d5@rivosinc.com>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
In-Reply-To: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
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
2.34.1


