Return-Path: <kvm+bounces-35466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDD7A114B9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DC5B16931A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0427722578B;
	Tue, 14 Jan 2025 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bRkvnBJz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8082253E6
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895514; cv=none; b=hD+enTes1l/6Ab/UO3t9EKyv5IdKQyfyQRUtZUZ0YRekVHEL20M1qX0NauC5qNAzOWHRj40PjGFjuarxZYeM2ugKh9Mms2/ITxB2PsM+ICjN2SrgK7zLtVgzzuOihoWALuu6nX1+t1fzTCsOcXaBmiHILWjnxaDU/7TJUHQLefI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895514; c=relaxed/simple;
	bh=qgt8CBKBjjf1pXbLg4nyI/opS5gZuaUjt8a3Zl80Jzg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H2NiZNwb29K5pwpj84Z0YBwU+GLAB7pRjxu5Ovoo2CAkMMnd/BsQpzvUfbSsBP5qaQayBKS3NGNBW1zariL9l4eQj8dwF5UvhthNAB3Em+HfvmtTkcKx11uIwDkwI4J9P1rSXS5Siu/LdfCRdfK3mi9cmo/SkDhsE8uM0HAh+HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bRkvnBJz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21634338cfdso100827145ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895511; x=1737500311; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zp+Ban9UqcPtxcekhEzEgx0H42XNY1XoD8n/tlKqBKQ=;
        b=bRkvnBJzvp5aw+J+GMvSbA0yo9sBhhQP7QDmDK6OaFgq/QEeE3RiYdEy7fFac4SjAE
         R43AE7qiqTTVbMZepBwoW1XbcduYdRK5kWESTRvgTUw51LPthmwG1jz0Qx7OjKhPOG/L
         HtfXtav+SQGHoDBwjIt8oaVcdXAKRHGmXT/pSeklvsqsYs8UiKYf6zeLCONquAsEHUgw
         Gqh22UumTVrAhsBDUmIQdkCkrIpblZPz9nMr2wOPz83bohzJ37h6gjYWwhQGguN9w/fS
         ic0CtBXorSVB2sqFztOxiHlMyv8ORKIihg1+Wx6xtOFTz/IapklkrOndMF7WvyXSAcjD
         GMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895511; x=1737500311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zp+Ban9UqcPtxcekhEzEgx0H42XNY1XoD8n/tlKqBKQ=;
        b=Cw/xK06lzKA96R8tQIXIX7ETiMsRvAsUGGc52eaXbzDtnAUM6T6XciRJ65PEUVc/9Y
         hxDS5inI2Nbfkjdarpf3jsfecm2VqREaptQsqijgagXg+IFo2gMdorgkqvxkFyAHpiCA
         ZO+9hliTXopXaJnYPJGzSt0/fd5vYTPNTn1rSk4kc5PtFZaStoWSVOdDlXqXVI4MNe9S
         XVGdriKkhpegKMYS+E0oZFlxbsv2mtGMM3TBZgC5Ff61faUNMTSZfhBzbkr1xyReJ6XO
         oiF1v4DNXbWUNUlDWbGChhM5a5iNSrAymVUHbnCeZ+lI6y18dos4nKr1xPMbaEVHeNZv
         x8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCXTHeiOUFABnL6ktwB95SzmFSNK+UCHWUEnPL3H0/rkQQKtr+G3fscoTJFLbUw7Bx4ZIgs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh+gkZsfKXLV/MMbvbD0tfC+/9RxzeCvrqEcuIN5S832tFiVew
	Q2Mf5RQkhTzxV/MGXhzEp+kC01B2P6XW1Id4tCumPg6d4Uv+EgBeZthINTEW+N0=
X-Gm-Gg: ASbGnctjVlOFGmA6Us46zxJXQcLz+rpr509/z0T8/uCfW/OOR9ye+koWK5dYpXjKH17
	PXNBwwUb+dnWs/NYz3Z5+a5qN4FsY7knP30RTAyOKezbFgENRMwFELsFTC066Hzami92ss+dg1r
	wSSvJxWoEtWzyyclvbQ0mwmGlljRqoT9JayO/JxQ44IgZ6hA2+HAtSwQL44Z/njU7zF9tvOZNkr
	cWA5qBA3wBsJm+hNGJZOjD94bUPWuMFHkP8Qr167XJSyYhsL9UOCh0IZQ94nyIfNavltA==
X-Google-Smtp-Source: AGHT+IFw2aOxa/RiLQrRWKk2z3D3w1uFmOOWORKNifbT2/MJ7FdclBZ5ykBjK1s8a/t6cnrYBG/h2Q==
X-Received: by 2002:a17:902:fc8f:b0:216:48dd:d15c with SMTP id d9443c01a7336-21a83f65a79mr399235235ad.27.1736895511537;
        Tue, 14 Jan 2025 14:58:31 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:31 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:33 -0800
Subject: [PATCH v2 08/21] dt-bindings: riscv: add Ssccfg ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-8-8ba74cdb851b@rivosinc.com>
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

Add description for the Ssccfg extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 0cfdaa4552a6..c8685fb1fb42 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -128,6 +128,13 @@ properties:
             changes to interrupts as frozen at commit ccbddab ("Merge pull
             request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
 
+	- const: smcdeleg
+	  description: |
+	    The standard Smcdeleg supervisor-level extension for the machine mode
+	    to delegate the hpmcounters to supvervisor mode so that they are
+	    directlyi accessible in the supervisor mode. This extension depend
+	    on Sscsrind, Zihpm, Zicntr extensions.
+
         - const: smmpm
           description: |
             The standard Smmpm extension for M-mode pointer masking as
@@ -166,6 +173,12 @@ properties:
             interrupt architecture for supervisor-mode-visible csr and
             behavioural changes to interrupts as frozen at commit ccbddab
             ("Merge pull request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
+	- const: ssccfg
+	  description: |
+	    The standard Ssccfg supervisor-level extension for configuring
+            the delegated hpmcounters to be accessible directly in supervisor
+            mode. This extension depend on Sscsrind, Smcdeleg, Zihpm, Zicntr
+            extensions.
 
         - const: sscofpmf
           description: |

-- 
2.34.1


