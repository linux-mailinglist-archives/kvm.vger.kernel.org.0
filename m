Return-Path: <kvm+bounces-35478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE54A114DF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0162D160D0C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8542206AC;
	Tue, 14 Jan 2025 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sJ/kB4SG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7D228CB7
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895536; cv=none; b=GDA6bHaEx9fBbCggM//4rJsA/GBp3KG9ZY09QiUsjZDApvmkG5N3mMbjtdW95R4QSeAXUAaS5uNX4FQ7nfnCMuQSU43m53EpxwpeIIyx3bY6Dji8GIaFFmLzMCAsCzTJ7Mr/0W/Ypj1wZiJbh8ApfoYIqdxMMVGXX13XWoaIkoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895536; c=relaxed/simple;
	bh=GjWW1PZeSMVVp/YE0YLQ4xt4IwvJzVvhTdWUcKrLGJ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qHBt+uIZuwqQipRUTkXyi3DjOhNUgeowq456hIQNwmr/3PBr2Fmw+9CjzTzkl3wm9Dt50g+VoneThOwp+9qy6eaGi7k0FdCnkAt+SjAPzNwkd11OZdfeGqJWl70+gV+ReZgBYQ3vEU78BVLOVRY+90h26YrE4UKJZujnpd7QqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sJ/kB4SG; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2156e078563so90292925ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895533; x=1737500333; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Msmauk788mzUDGMUfQ29+G0+6TVWgLFLPWjnpzGrxFY=;
        b=sJ/kB4SGi8na+gbFnBYd8OP+47A3uEraV7hRXgqe29hgDtc6Erznu4IVKv7n7K8zYL
         Pkk2kcR6yjJ4Ccb8bmjoEdc2dPr95mW25hlLevoBGRuL1vmdw7KfavKYzfieBEnjyrZy
         HF0La35wl9X9CjQHimsvbPVBR/Z2lVAhB61WuN+oCwUw1uRvuoi3W1/LDPdLj2PlL0c9
         OtzVR4ELGppP7gjS5aulzB0yYsooNotbePH+tOnfHGQIGFW+uRx/ChBgCNnqHJDdUHnV
         97m1OpCcJ/P429f1NiXOeTRnsslaEhweIBgFIS3Shj3nG2v2GAdkhfxgbslVyhJ8Y+Iv
         fggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895533; x=1737500333;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Msmauk788mzUDGMUfQ29+G0+6TVWgLFLPWjnpzGrxFY=;
        b=kWVkJw3+fVca+cPPHANORCabOZ0cr/M/+3TXoqU7YHfASPw65Hvtwb2pxQGamK4qKo
         /vS28h58VABZGc1JHqUn/qL848of1MHe/tdlzcOHtwNdrHd6NC3qY1o+voMM24KhQxwn
         WrE4apg+7gKdMdlNxXgcmfWG3rMJYONbc3wMliM8makcvvUw2j5wC83/R5sWUKhfZ/2C
         7ILOIKuzeEumfef2KXmbG5pOC4lPih8iyTOcqIPqRrOq5MqbY2CuQEvkbKYU6kAJvnhe
         fv+UUsT1olaspZq2ToAlDUnupZqxk5FRbp1nu7rnKhCNdiKnkrIw59oSCWTh4n7C5Vop
         wYvg==
X-Forwarded-Encrypted: i=1; AJvYcCUD5Q8c3cVGGSg06rWzcIw7UHoMMhC3aNE3iG6xeHZd/ZHje2thnatiLTTQIyTp9qlSCEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgPmDnVkLbydyTlD0xofg63eEMEmBxuZbjhb44TctaWKxevyaE
	MD9PRrszb4eAse1M8GU6QjH7xc3Z2cLtggNPJ5676ZoBwt/D1UMkZRoJBy0frO0=
X-Gm-Gg: ASbGncvkFAWoKPrKCvwM4MPSx8claX2efLFfYzj5WYeodrYpLZgL1bplDAGGjfAAYMA
	9TB1h1tTKwSBJt2oe4NpxEg/yHVGmLMNJIndYDEFKQmo8uLPvnCYB5LPy634ONRKPagwPEhsTU2
	AQsLnV809KAcEL9u+I6/puworJYns7rc0KchkSRZCsVg+mYNM8NaN3dg0gruAgV86CDfG/TG7E3
	TF5OUOkxqhOC/eA0t91JXmAWutYhx/Ab++b+BcM0vTLXQL05xeTJGunlgBA9/mhmjSwUQ==
X-Google-Smtp-Source: AGHT+IHVlOGIv+9Uh+Dng9Z5glMQS7vdErpemdoZ1TuQIxVK5mxZMQQK+rAFLrYfNXcGXxNvYIFeiA==
X-Received: by 2002:a17:903:1cf:b0:21a:8300:b9d5 with SMTP id d9443c01a7336-21a83f4cd36mr432431955ad.23.1736895533476;
        Tue, 14 Jan 2025 14:58:53 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:53 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:45 -0800
Subject: [PATCH v2 20/21] tools/perf: Pass the Counter constraint values in
 the pmu events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-20-8ba74cdb851b@rivosinc.com>
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

RISC-V doesn't have any standard event to counter mapping discovery
mechanism in the ISA. The ISA defines 29 programmable counters and
platforms can choose to implement any number of them and map any
events to any counters. Thus, the perf tool need to inform the driver
about the counter mapping of each events.

The current perf infrastructure only parses the 'Counter' constraints
in metrics. This patch extends that to pass in the pmu events so that
any driver can retrieve those values via perf attributes if defined
accordingly.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/perf/pmu-events/jevents.py | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 28acd598dd7c..c21945238469 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -274,6 +274,11 @@ class JsonEvent:
         return fixed[name.lower()]
       return event
 
+    def counter_list_to_bitmask(counterlist):
+      counter_ids = list(map(int, counterlist.split(',')))
+      bitmask = sum(1 << pos for pos in counter_ids)
+      return bitmask
+
     def unit_to_pmu(unit: str) -> Optional[str]:
       """Convert a JSON Unit to Linux PMU name."""
       if not unit or unit == "core":
@@ -427,6 +432,10 @@ class JsonEvent:
       else:
         raise argparse.ArgumentTypeError('Cannot find arch std event:', arch_std)
 
+    if self.counters['list']:
+      bitmask = counter_list_to_bitmask(self.counters['list'])
+      event += f',counterid_mask={bitmask:#x}'
+
     self.event = real_event(self.name, event)
 
   def __repr__(self) -> str:

-- 
2.34.1


