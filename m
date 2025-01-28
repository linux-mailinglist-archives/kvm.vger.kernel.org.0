Return-Path: <kvm+bounces-36741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C74EAA203D5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:07:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 175493A2EAA
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41BE1F9AB7;
	Tue, 28 Jan 2025 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fq70pdjD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B8B1DDC11
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040424; cv=none; b=awSHURwgyixYEfgkF5WuYpNjQu3TT6bnVITKqpaMkNPv6npIxoq0PxCgpHd8B0Q0MVh/cqNa1idiOxOi+QAgOO9+fk0Rt4noKzZ57XsFrbzHUWPz+NUK8/eaCwaWGCeBg/xOfxhlJsKaWmKErKah7+90Swrzkij2NRpgLXcfnBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040424; c=relaxed/simple;
	bh=GjWW1PZeSMVVp/YE0YLQ4xt4IwvJzVvhTdWUcKrLGJ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lSCL8symQ3b/hhSsKOt5LSVk2qYVE1NVRmYnLVIkK2hEl15CBPvS4QZ/VwaXQudL6rwCsJk5BzeBApRPaiW1rs+Yf1vNkGqqtY/bVEIRqbwmmE7xl/swUqsHKcM5ZLoZwZBkoydkEY7e5uGwMtlGkSTBuJ6et8wscsj4tMMREjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fq70pdjD; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2eeb4d643a5so9141380a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040422; x=1738645222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Msmauk788mzUDGMUfQ29+G0+6TVWgLFLPWjnpzGrxFY=;
        b=fq70pdjDp+tFzPDZdeItpKIjxTiitr55X65s0lc8Is5V9I9s6cXTf8pIbArfblzVXt
         8l/jdbE9BwcPFzCn2//5AkTnmaA5dKNBfe5LXCujtrCa2Uvs2tuUUgFzu0llJYM2a/DM
         1/MHrxpNQKZqBJlzstd7cXnqNgixi0NXyr7zIY6q62dwPWApWQrYBCrwz5vM+vI/F07j
         3iKnfM1LYYJB9cuQIhMvE2crGQcFGhqRCqerYo0qSCPlnnIk1IWwMjtdNhc/lEDjz/gw
         q9uQSlLXmYlZOhkEA1sqhry5FBDNwsykz4ofg0L/XuFXzIV/hbFn8JG3RF/6TB94JMmZ
         zaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040422; x=1738645222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Msmauk788mzUDGMUfQ29+G0+6TVWgLFLPWjnpzGrxFY=;
        b=B6AsdeP37dhu7vC9t22UzQoWlP7zhQKM2nCaW1ZYq5u37JWppfYZGms6xaYtWu9uQu
         tN0/nnBHzVj80biOFKHEJjBJOWmhyCneJO2/DAbv6shNejK/lh0RhPzcB0BRKv1uEhoV
         VIDTrFuc+m4OEb/V+W5yh/KfkQOiiKcKEpMH/VmVkn78QtqFVkgy65eXgma+WjDtGKOd
         lXq0HcS3Urco+exDfCswQVykSkNvcB4f6GIG3HRBgTwmO9/qwkLl0cekcj0uV236G1he
         1X+YChpbOdegJ8rQQD+iO+7rc4F/iY+J4OrPRoNSPp7XeWVB3+8YE/V1+qM37QGDslDP
         NjQg==
X-Forwarded-Encrypted: i=1; AJvYcCUf58V98EAsPpIxSiGjRdiX/6FgxiyVSKSTwL3U+yltkcZbOKhXt/6cLoyjc6jwvHw/UjE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1EmTORtmlW1sN9E4MipDxPFl4ghokH3AFpHV1HpYYEq8wgda2
	hwSYppuKb9lmkFENPV6cSq/Z3hE7xS0RjAgn9xIj1bgsYI0Zqn68WqBvH543SvQ=
X-Gm-Gg: ASbGncvSzrh7cGeP6rzS045URjtV7Uzd0dhCdm5G/85Q2ggeTpp6Z8uiD59UFJ7y+5W
	5zoQ9cRT1bcHzqzvjMyP5ognoN4K6RZt3ULwUu+X6FuNJC7HqDE4VH7X4W4cc0I2ZTYyP5dvDeI
	Wn+sAyNGseCqM1ovdv0zC8S0xqFxfB/cMh+orFdWAYeSMecH1UYt1BWU4oVpn/3oCdnCAuCD52R
	X1WzAHo7xOiPUWl9aqh+cTl2gYnih96mKSEzJNNurnZLyu0Ny5IjRlH3gz/2AHN9XqE9GB2yYWU
	Eckczp5MICnTkOb9bh2ZSpAEoee4
X-Google-Smtp-Source: AGHT+IELryn7Li8G6uRsK1ux9a/8YArLklBlMT1VjVPaGUmGZLNmSMTAlEJHZzc25zLYxiYqH+BJ4A==
X-Received: by 2002:a17:90b:1f8a:b0:2ee:f687:6acb with SMTP id 98e67ed59e1d1-2f782c94b50mr63592948a91.13.1738040422123;
        Mon, 27 Jan 2025 21:00:22 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:21 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 21:00:01 -0800
Subject: [PATCH v3 20/21] tools/perf: Pass the Counter constraint values in
 the pmu events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-20-64894d7e16d5@rivosinc.com>
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


