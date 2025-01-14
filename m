Return-Path: <kvm+bounces-35462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E190BA11484
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AD243A329F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916E32236E9;
	Tue, 14 Jan 2025 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Jw4kC5Zz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF8E21E091
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895506; cv=none; b=ADngLicEpKhGq9C10lWy0+HaiPhDM7FR+K4Iq+U0AljOb49XIgnx5l2P44yXQ/nqwY1i3ACS2/5NVP/yMEyirPxv+VMczM0/fB66aYrFzy+CMcy3fhQwedgn2WwJw+0SLKrMHD3yE+WPPsBy2JO6zDiNjYp4LzdCJzfIGi3+tsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895506; c=relaxed/simple;
	bh=Vmwsa/ctBo8N43GnV4TfHr9aW95FI1ojPvJ/QsRfYGM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rpFqDZ4EVzFSCR5HzM2NTAFYOEGyv3mUueEaM2uSe4nG2ccDOz8levBjLnJRNbZ1gv1g8zPmL8ZuCDvh9DeV3tNbZQCHjb2WRo38KdSV2PCUA2eG0VOlsGRh3GZwHq/OcC6mGp5V+HN0UZ8uJgtamy4ycF9EDsG7GJMo3Yt9JkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Jw4kC5Zz; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21649a7bcdcso104031515ad.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895504; x=1737500304; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+nuV14UWlVLpKqlK5QJyBaxP+s4wgcBZS80Qr+dhQF8=;
        b=Jw4kC5ZztlXxPgkp43W3EuEe/NdpYEZk+K6frb6Yav7IAz3bHS1VQ4vxn5KNy9u5q3
         sAvPcowJhdTAhmSrs4VL/ML5bPIVheH9WbdVqrV6wEAbln3KBefUp55LMDbDg71YNd4G
         maygkQhQqObjgLuYl/tCHsOX58JNpqAPgCtsd36+70j565yLmAevxF++aiJzEEoTDaIi
         h1I1QTaf+iMU7sB8BZ/fSm2QcOrxF310TgZwamoLAlRen0zUXKT3kaNp6VHBd8puIS/2
         /ynqMmDf6/ddqWxtmeX/fvj6bH2Bmp57NZlwVwnLSxp92GmEgoPp/yn83oM2BKzqvgRy
         meaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895504; x=1737500304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nuV14UWlVLpKqlK5QJyBaxP+s4wgcBZS80Qr+dhQF8=;
        b=iFIY44yhUX1xG5ZzVPlJAhMhhaxa73vZZYer6c+iTyk0udndtK8uyAFiU3J0Xnq0G1
         7Im5OMUpk7yPR+3bFj2krfSLKGIYEdqQNZeWPs8+VR3CWFB/zZvQqhxB/IYRWcDeIu+f
         MwJ/xaYMqQpSNNy5FtssAZDfqJ1gX5tyP3q09bkNJ6t2WJmLn1vZd/Wk5jjKt8J441m6
         VB0NSQY13cKoXnPJKBFwvJZrfjr4DylukGD875hMWlsclII/iF5qUBxvIVmv5GicJpoe
         3tT21i2GAGRvtZYUYkAgiRPBMYIRmgUjn98WPn8FSvBGHhN7d6oMOHMAqA9SX/8kfMzr
         +HbA==
X-Forwarded-Encrypted: i=1; AJvYcCU3Rhzv7ay8/y1Z8WEfGI7ZWYlD/tTVs05OLXj5u2k3U1hSup2gujcdcrEdDfH+9WtutkE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR+LhlgNCSHbJpZkY9Y6WlDKmz2WLyGcFAkx0ByjEX089Ytbeq
	UDySx8xxxvgdVQC4XMyUhEwKLw5mLdSX/bNtiy+DXJbLeKunI3Q63bGLfz0L1t0=
X-Gm-Gg: ASbGnctwQrOFf9V4uVBx44OZSd/IRnx/VW1dPjlCRQMJHqhjtDycVMRTMg3GMvJUdbv
	16x1WsNbQLF9/iOsE5HRez7HMSw86y2BFbuIcRWuyqGn4TcImXrJHpoihfhSWHUF9uA2dlnFtcn
	LsSyHvXLUC7GbVMp/BHi6J1nixlKWedCxqNcAMXNjzjViqdRXPsQN9moy3Ao1xKzuXDDSjHmglJ
	d/QSSqATunq8pEJ3q8t3sb7KEnkyLCF2El73OEMLBzqkk4x60r8MiYsnKAXR3WggYwLAQ==
X-Google-Smtp-Source: AGHT+IEV9xqrGE2EwbwN10kTDKoQE5y094MCv+vKIzLtISYj8DvmatP2DVPnEqTLBoPDrnLS9ZbWpg==
X-Received: by 2002:a17:902:d2ca:b0:211:8404:a957 with SMTP id d9443c01a7336-21a83fc0619mr405796975ad.41.1736895504307;
        Tue, 14 Jan 2025 14:58:24 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:23 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:29 -0800
Subject: [PATCH v2 04/21] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-4-8ba74cdb851b@rivosinc.com>
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

Add the S[m|s]csrind ISA extension description.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 9c7dd7e75e0c..0cfdaa4552a6 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -146,6 +146,20 @@ properties:
             added by other RISC-V extensions in H/S/VS/U/VU modes and as
             ratified at commit a28bfae (Ratified (#7)) of riscv-state-enable.
 
+	- const: smcsrind
+          description: |
+            The standard Smcsrind supervisor-level extension extends the
+	    indirect CSR access mechanism defined by the Smaia extension. This
+	    extension allows other ISA extension to use indirect CSR access
+	    mechanism in M-mode.
+
+	- const: sscsrind
+          description: |
+            The standard Sscsrind supervisor-level extension extends the
+	    indirect CSR access mechanism defined by the Ssaia extension. This
+	    extension allows other ISA extension to use indirect CSR access
+	    mechanism in S-mode.
+
         - const: ssaia
           description: |
             The standard Ssaia supervisor-level extension for the advanced

-- 
2.34.1


