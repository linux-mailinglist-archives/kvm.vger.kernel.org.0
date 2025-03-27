Return-Path: <kvm+bounces-42143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8F0A73EAF
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7505B3BBB9B
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6E521D5AF;
	Thu, 27 Mar 2025 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IarHJmdW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCCF21B9DB
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104181; cv=none; b=JjUxu+A3RxGAuqP0OEsInku7mXw9Tri+CkW+/ATV6sRZbHDNc0XmB77IawGGetDiy97OQi3fIKcRNVHjs6Ud6Ds+AjzFMDezbKmOStpw32bb+CPNEWDtijCYM7Sg/y7yrdYh/P+FSvIg5z91tPFc+QpUJRcFU+keUvqt07Vrs1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104181; c=relaxed/simple;
	bh=xjlrrmRpuMjoXE1KshRtMZxjuBhYnjW8AtjVKdZkUuw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=satnUAD8YfBWj/ojl0SliUrhazHpDY9Wwb8j7opiGn+YeFzcK9v6/oIKqTORAl8LIXi0K8syD7okBnf1LltAnDY5vv2VHeVKcYpAqKJx7gaX+68jAT81PO02k/1wbWgxz1QR4n0LlNcnYIPq6baemXOtINbk7jVgVMqNZbfQbkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IarHJmdW; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3014ae35534so1991836a91.0
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104178; x=1743708978; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6J8uS8Dr+ClMIERwU7Q7iLa9i915e3rRw4ioKbElXo=;
        b=IarHJmdWaMKaVpExaLxjvT5CC85g/Jt3QiNUMgiOTz0hi3YaEpOJNZFi+C3rTQaLt6
         J+ea8yKN4qAX6WrQ6pLYyBSGYP4DIHdYbI/bM2L7t0/gJbHc+/A20WQRmrJNV+mgBTbX
         LldfiOBmWmlTAT9swm/Bj1uPu/JwCjlLJTLkNrfpfgIFRyCpHiP+ALlyuBaCAyFZqqo/
         wkyrOA4V6cpjqgIjrN/zHss7xxcU9pgVrpyOaZsG+qlT9Lgn3D6CcL/riSaQwGu1/cTJ
         E6fnkq7gD9IJSSfHNptqqOW1qLRdhuEt34KkKGm+UTCcXpAdbjUECFp0DwMR7L2zOYHl
         XZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104178; x=1743708978;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6J8uS8Dr+ClMIERwU7Q7iLa9i915e3rRw4ioKbElXo=;
        b=I9wnf1RqOdBf//q/gWcmZ9N89piA+xLUPVs5bUTtVslVayJONrACIMtB13dbitYF5G
         rF8hi2qkRUs67d0WmYoHUwHB01c042RLintYQ2pabaKMQa6hO8hz+gm1PCqmEk3d54Jz
         CiZAbG9WBjNUPNMCeMDiynqBrGm7p7PwvTaGezt/rTNL1rCKA1B3Dtvt6P4Grt19d68F
         hqxIEC6SbFsM5XuP9kWHMPF0bQDliFlkQlOaWTvQtNa47cAc6o2feMQak3yvlfOE6PUl
         NxK2dP2IrUQO7mHLAGlw/nrh5SbdkpSvpJn/rfYj4QPCO15hnZjSLohGE83p+mmMKIBD
         IlNw==
X-Forwarded-Encrypted: i=1; AJvYcCXpF4zdfot4xL71Ywq7uNk2QeiR3wRO1QR7ONRgkwQKGEwdshho2IDi5Xy655OKUzODoXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJp9f5JHO/DreJZOCjefRBxzWoQ1bBntuhnTI2apm5XOSo8HCt
	cvZcS2ShK2YK7nivdiBlQm+vyCkx2p3uVkcXPm3aovZ5e00gUhj6mYSp7XbS1P0/F5jCGUfzs+j
	G
X-Gm-Gg: ASbGncvGg97hCG/awQ2rw7cOXF3W27AzLYZGyge6j//bsmjPbsAfmu3xktShynQJKTw
	EvfC1hI1xKotmnKRhK3GbxC1RHFcQyIo6Og+F459s9aAt0rUqT1VAHhp5XwsTPFhMvSt0q+GMoX
	Zp8/XfE5m63XGH2dId4ARgWZARgBeQbVRrwUGGuYkdIfjr33Yi0MEQzQ5lPIS3PCdc2Y4lmM4dw
	jscLHWEG+V9S6Fegla89+CJwWon4UpOZHHk1W9MRqVw1zlQTjA7D/PGwjwXeLfdNMuWWMrEDdff
	/sZDGRChhZSuv8CPqzaeF9GiG9UpewLiPOXDbVwhcb0TlRhrwLtHNLbN4byvcBerSmPG
X-Google-Smtp-Source: AGHT+IFOxM4SmbXuuTZ7zfbjNBSt3NF5qSX8XxUdDdxMSJ9Gbp2tgCBb+BZDCQPwqEBKt7x+Gq+pcQ==
X-Received: by 2002:a17:90b:2801:b0:301:98fc:9b51 with SMTP id 98e67ed59e1d1-303a7d5b724mr6622802a91.5.1743104178125;
        Thu, 27 Mar 2025 12:36:18 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:17 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:45 -0700
Subject: [PATCH v5 04/21] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-counter_delegation-v5-4-1ee538468d1b@rivosinc.com>
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

Add the S[m|s]csrind ISA extension description.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index a63b994e0763..0520a9d8b1cd 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -128,6 +128,14 @@ properties:
             changes to interrupts as frozen at commit ccbddab ("Merge pull
             request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
 
+        - const: smcsrind
+          description: |
+            The standard Smcsrind supervisor-level extension extends the
+            indirect CSR access mechanism defined by the Smaia extension. This
+            extension allows other ISA extension to use indirect CSR access
+            mechanism in M-mode as ratified in the 20240326 version of the
+            privileged ISA specification.
+
         - const: smmpm
           description: |
             The standard Smmpm extension for M-mode pointer masking as
@@ -146,6 +154,14 @@ properties:
             added by other RISC-V extensions in H/S/VS/U/VU modes and as
             ratified at commit a28bfae (Ratified (#7)) of riscv-state-enable.
 
+        - const: sscsrind
+          description: |
+            The standard Sscsrind supervisor-level extension extends the
+            indirect CSR access mechanism defined by the Ssaia extension. This
+            extension allows other ISA extension to use indirect CSR access
+            mechanism in S-mode as ratified in the 20240326 version of the
+            privileged ISA specification.
+
         - const: ssaia
           description: |
             The standard Ssaia supervisor-level extension for the advanced

-- 
2.43.0


