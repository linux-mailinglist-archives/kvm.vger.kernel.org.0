Return-Path: <kvm+bounces-36725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AABA203A3
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D987E3A6B24
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3486A1DF274;
	Tue, 28 Jan 2025 04:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LGwsla0I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817DE1DE8B7
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 04:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040398; cv=none; b=nBMYQSWznYRNwtbt+E8liI5YOnfaZZX4hgd947P7OlLFy5aclSqsc7BYQWqdc0u2//1UqBSOGzJqotRl5wazxkPWdK/C01s3ZHxjkuQaXaKyO+EgHCcBqeLLMIvTpyzYEVI5x4LcL2kga0oH/+LP9L+5gw3DRD2edrnU9csEWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040398; c=relaxed/simple;
	bh=CURFmMM1bMVbBVWFzKB1HrZAF7GWZ+iB6MOdVBx/6BM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uv3ZBqmYG2vN2cqrOgrqE4Xcg2SHsdeYTcKRngrtUeSZ+TQNbicTCApZu2gPLiC/CJCF4jyQIWYhAjP0p1ZAyFUYbeZLWiZ23kjo4CkGs0udOBqHIEml7slthaNZh69bf9c6IaAv23zlGyTFYuWdshiiAjDlN/KL6KFHd4Z6mIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LGwsla0I; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ef748105deso6911387a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 20:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040396; x=1738645196; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3d11Vb185MzE7T3v4uIyT+JXKKpmn0Bb8O6L8LI7W0=;
        b=LGwsla0IrPevAlmJuwmHwMnax/7aeAn9OYkbRoP69kT0j8cbMm2aRjEmwPGMNIN1La
         aevQYwuoqEy1OKvgtptBxSfQ8TFbSYEdDMdJZWOQznznUgCaD+cKBDcPQVa/zFD1JPX1
         IjrVhLq4GBezq0xfqLqJ9b7xiWZ8OBWMqX3D4vb1UmdrCnyC2mtqIrzgivQEAK8qdrT/
         aq14SErZp/aRujbE3tg6SRvXdN7ZTDVhrMEVRL2N7m985RHk39Y5BJuTAWzT5SZPayk5
         Oq5GKy4CnzqR7Sac/zsDJtlBYz2bq1xWpe6fq0c0il+GOTEl2qOqsggVfsfaGBYZs5yo
         wRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040396; x=1738645196;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3d11Vb185MzE7T3v4uIyT+JXKKpmn0Bb8O6L8LI7W0=;
        b=w9j8kkkQBUtHflCd5N7i1cJSQtfTZNg6rMsriBY/rK96YAD+UCDRHxa9Xa6Rxw9f6U
         yZrWLAmR50A5MH7A0oKLXhoHviW88fFRQqNK9g8Mf4Xi+2Tf/kn4oWG+8ipFEAmxXrgM
         LoE0U5tgiIAA46GSdamI8vk+MMyjRwsKbPiqw3CdhZI/4tzUibYSpXZkkRDr1Xoj/AW9
         Azk/KrjiNKMEMqqv7E9PDyT6Nx2InX6ct061zsmu0jfVOtWdqeOnHzDvuciQfq3ZfhmE
         4s6/zIwV9Zgkxa6O4wHxs9JUx0bKTQDRucmIdNsGDBzSF/CGS+ldx5WNvrSvEg50GeY5
         xYRw==
X-Forwarded-Encrypted: i=1; AJvYcCU0IyNY8tZHl3JIgPjYX27uewKt9kvFyinbvxpi60kif3mQV20AjMDu0IsouciGm5iE4/I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+okcOkNtc875t+oWuFMcQGqDa0v/B8ujyh05tTbBEV18by5Ue
	rVUUV9v1FXcJOCyhx9/ZzaTxFkuLxv9GwLAbzAaqJZyIT2d9ljImNoJIlBpUTwg=
X-Gm-Gg: ASbGncti+7Xb/5XGg3vqMPFJK4kNH3KgJUiRrbCof+4dLKMBe1plcjIUnbr26vZBbLj
	l7WOx5RZ8ncuypr5GAeglZwLCpeVn8uG96oS3GYuqlwve07fUbAy+aAKjYG13++S0pEQAc0VzVK
	WQ3mGIIeuZ8khynhxg8o6rCJASnX3bz0NAHlMqSf30R11TCYF+Emr3Yb3MesOP9RTzSAlv3tcq5
	mnTBGKA113oKig3Ox31WNNCtRqTo9NNrkmQdS2Cz5DtgP8fIRWzk03cAVGLlT+zji04s2VXNo69
	WlfWQXQ3GMd/YlbOBqkXWMVrZUwZ
X-Google-Smtp-Source: AGHT+IGKJLoG1w7HBodanThehp9jcOrQlRY8JCeFJh3f5TphJqozkTpJC2i92zo0GQX5LVcI8mvvTg==
X-Received: by 2002:a17:90b:5448:b0:2ea:5dea:eb0a with SMTP id 98e67ed59e1d1-2f782c4d75cmr60425683a91.4.1738040395871;
        Mon, 27 Jan 2025 20:59:55 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.20.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 20:59:55 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:45 -0800
Subject: [PATCH v3 04/21] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-4-64894d7e16d5@rivosinc.com>
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

Add the S[m|s]csrind ISA extension description.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 9c7dd7e75e0c..f47d829545db 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -146,6 +146,22 @@ properties:
             added by other RISC-V extensions in H/S/VS/U/VU modes and as
             ratified at commit a28bfae (Ratified (#7)) of riscv-state-enable.
 
+        - const: smcsrind
+          description: |
+            The standard Smcsrind supervisor-level extension extends the
+            indirect CSR access mechanism defined by the Smaia extension. This
+            extension allows other ISA extension to use indirect CSR access
+            mechanism in M-mode as ratified in the 20240326 version of the
+            privileged ISA specification.
+
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
2.34.1


