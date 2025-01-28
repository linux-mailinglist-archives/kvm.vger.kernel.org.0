Return-Path: <kvm+bounces-36731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF7BA203B8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC63D7A4D5A
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506A21F7080;
	Tue, 28 Jan 2025 05:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="quL4OjKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D8A1F55ED
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040408; cv=none; b=d4aQjD4a3ibMXUCsMNyESGJ0nVphdW7Oy0gIyl9eVe4pQX0zbtuHW5h3I8Ej/TUyuDdVNPYlq6KgVyUHUKEigEKYzk9vxrpc0kBz+GQFogvxvGVupty7E2kEtAvwrqbPW6D2KnJ+StHeFnLy1EfskcqlcPhxPL90xId9PgIKkLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040408; c=relaxed/simple;
	bh=lgDPl7XeyZ3VsFlwl0qRhI6mGZXrHGPpz/tt601F8DA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tlcm2CYmY9PZWeu4mpNGnYUGAYA93ae/M2wBkF8Jt2OFl3tk6WErrpJNSAYlnqq2ZbPc9DCD6cyi1lfG4kzEIB3GRXXqLyNYwZFDzmQ0bE9OAf9Tp4lskk1Cq1LdD/vfvlCbgjSA7pIcxQq8UT/o6/+WbHGgYCV4tvHgPtY2F6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=quL4OjKC; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f4409fc8fdso7986539a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040405; x=1738645205; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8nwB5ijQXYUTHkLWAXohil6yVgl/NyKIaGqyFvphby4=;
        b=quL4OjKCyDsBiuWswt5xXC8ILMOVGolFt8YnY3xOGkvh8Z699cgyNET8hITBlR1xS1
         SsDttzlCmWrvGKil68AFFzZ1QLEUo1mCaEelWNVEg7VKuu04ydr+v6PGl05HvdaeBb6A
         95fT+iHtjwEgqIRnNMAK9KntDhBZRypAojNuAfclFhCo0ZnIT3C1dvxl+iaatv/B78q6
         80WUXt9jUgRQ66pQZIF/Vtm1Z1datfY3dkRISDisGCMSm6pxht5r/96RtSIoLsjehp0a
         EvdJIe7bxJQSfUy4zvfNgOwNkRqrJxbDROcpbiPBNsdX5zYYGQ81vtjwwkf0g+xqKEHi
         driw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040405; x=1738645205;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nwB5ijQXYUTHkLWAXohil6yVgl/NyKIaGqyFvphby4=;
        b=CUFnd6O9TFT+HOcfUs8H5lE7N4w9+7XvMWDgpEXHrx0VLYCUuQQckQmLamDbqOnsWf
         s6YNHWEN4+QQB//DOH6c0AQdLNDpAIn6wIcqWWfM7G/6MF8YBtHwcMkDHtsT2nKmqs0q
         Ij9pD6lDxY13BL4b6G2/x9vMsPtjIHaiMS1NtyvLpXTb+9Wif44rUDDq7VAXvxep5yY4
         lmJjr0RZf4F30VMiySLuXG+xibD6vqILWtB2yC+KiyXGaMU9eW7FpLdgDxCPx5vUZP7G
         C2frnAfp7Et/geDZLTL0k41LVVeZBdQqNI1DQ5cp4HceVvwfOXnVRgOksz/fD1N0ab3O
         hKLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVL2EnJwvExEqPkkfMPAi5V0Ulu6MKZkoM8ZNE8tTQ5mWcVWBr+Tl9NruG9L2abwS5Z/J0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwSrGGR7bTMdEYTx9EcDUcs7uQlvZGHTjZHrzVdYSlKN61wqFK
	8iArUBJJtdB4vK0KXGfntThQSopP8x7igtC7KOOLiDc+JRCNt82+TkBYl6UnU5I=
X-Gm-Gg: ASbGnctKk7RxoeaIa/pB+R3msfD0eKFzi4KLIc5R60FnzKzSxZmYleb5p327N87bvql
	9YChq7rxR9ts2l8rpdjJgGsMOuQ73Ou34RRguhd+EfI1UhiJwP+fqBypZH6dPyklr3jWZdFrOrN
	yyhVMfpjOR93iQLMG2i4wRfaf4A7rJvckCliTfPodTJRVSZBh9ZwjKxt7k10BwOZ4lj6i4tNykO
	5WtGGNdlHjwlR7t/HlFlU/QIsQy0wgT8T7Y8XfOwk4s1VHdZw0kqzv2k04v9tj8DrpBVQplonK8
	A8Emxwj+kpA8L8KsZy42o8iiSfWi
X-Google-Smtp-Source: AGHT+IFrXpURXC6IeRPpOGWg3/tFzqB6mJrEgvaEoQuFlLXK7BO3fm1YNKQtwAqXg3g7vbpjjvAXGA==
X-Received: by 2002:a17:90b:54c6:b0:2ef:949c:6f6b with SMTP id 98e67ed59e1d1-2f82c0d31e5mr3090153a91.13.1738040405414;
        Mon, 27 Jan 2025 21:00:05 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:05 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:51 -0800
Subject: [PATCH v3 10/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-10-64894d7e16d5@rivosinc.com>
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

Add the description for Smcntrpmf ISA extension

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 1706a77729db..0afe47259c55 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -136,6 +136,14 @@ properties:
             20240213 version of the privileged ISA specification. This extension
             depends on Sscsrind, Zihpm, Zicntr extensions.
 
+        - const: smcntrpmf
+          description: |
+            The standard Smcntrpmf supervisor-level extension for the machine mode
+            to enable privilege mode filtering for cycle and instret counters as
+            ratified in the 20240326 version of the privileged ISA specification.
+            The Ssccfg extension depends on this as *cfg CSRs are available only
+            if smcntrpmf is present.
+
         - const: smmpm
           description: |
             The standard Smmpm extension for M-mode pointer masking as

-- 
2.34.1


