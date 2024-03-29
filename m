Return-Path: <kvm+bounces-13059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE848915CD
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F48B1C22A34
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 09:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281544F8B2;
	Fri, 29 Mar 2024 09:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="jfZsineP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2294AEFE
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 09:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711704466; cv=none; b=QaP5byHba3vZ2PaXRbw7ksfo0uXfn/Q7+K+VbQ8gNi+kpzqYfLF5YgSqRJZ0eEopH9hgrlaZySk6t/qP/jIVOXyjCCvz3iAzQxaiWzR49mtd43wMTnpB06YW0bqECVWr5adtQzYQnNxjr4PwFblYxOuvRQ2E4FUfiMyHo2qQtOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711704466; c=relaxed/simple;
	bh=LSg/rLuOsrxnsspgQ4r75KW0fisxGsUYFmGBfMYsNR4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k6GI8vsqM0+/tNYcb8Is/0Gk/MfA79Jgb/RWZHw7/vRiSEjK5XEvXuLGg5XTZqrnmBoe6cJsKMAq/Zs2IJQeGKk72rVnIgjBsMxwmVkVYi45EWWobj8SGlxaaSS1pIbKwJnqlBplruk5ScwpqmugaQQxb32QGBzdSV+iqsepmHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=jfZsineP; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-29f1686ff12so1380837a91.1
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 02:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1711704464; x=1712309264; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36s8w1btdvP+IRdBHf7/8nd9U/EcEkIO6Yh0YtSkXJI=;
        b=jfZsinePGh8GvughMdULBUqVVMU1/IJRkTvq/SnnFQDY0Q+6enwRM+p1Y4Db8388LN
         Ld0i1RVKMNpoau3cAcSqb5TrIJqhYrW7P+fQz3J9IQJwOkKcKowBRgEsvr2lUU4DYjbA
         /0snbQzpo2MYpphrbq8vQGY5i4KqzuiwtPry/z1RnbZD0+6Z7gFRBshffAJ23D5v+uzW
         cxFsXRI/7R2j1NvNuFIxlcuapbcsxuuPFr3lv8UNbBysKwDbWFlx9IMC+SQBuCFDf3vA
         mAtSjLmfnj5tnMuaHSHq+O4ceHaGTfHdGvxbTVd48Jv+s4Ly7qh3TAv1BDpU6+Sp9wHq
         4anQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711704464; x=1712309264;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36s8w1btdvP+IRdBHf7/8nd9U/EcEkIO6Yh0YtSkXJI=;
        b=PP9I2llV+L/+0gkzlbMvNVNBAdIaRk9WlIAsZ27uluTuqBQJOXV9nsQY+trCHwPost
         rXCHcA1NFpGfPzrQ0YODLdtmO/+7wwItJ4IAksynC5CaEznFN0tin+8nq9G5tfoXzjgS
         Z7gkdkn9jVoZt7iPWDtTRf1gogfb0w9+gToQ9XgHSfVgS2qlhsAuobZVxHkIEnwi9zMH
         hLCOrgTI+KMCWTZ00zJnUlhoSnIyW0jYBxg58kVINGemVAoeo1JJPsQ0465qsTe6weUv
         DgdMbgJr/FpJz8Pv+VashCPYcgrZr34TbJpbQukhzlWM4DhhVA9Wf3rATXQ8cMjq1/bM
         836g==
X-Forwarded-Encrypted: i=1; AJvYcCUvL5hpb9nBrRpXMbF14UJIm8HCgSP4pdV/6t3SOOUZjDJogjMYDTpFCrBtAVxSFDo6MkOIVK5nVGDGh1eNxFIjdmoU
X-Gm-Message-State: AOJu0YxRjET43eqYCI8iiuL3BC/0qvaU2yW7AHSlGTM6nT+pwSZJmWdk
	XqPwkayMbrqIgfg4/XkMyyGhZJrXF2E/oP8XBpvjHZH1i1l7MP+MPl7Wpuout2Y=
X-Google-Smtp-Source: AGHT+IFlwBZNBeq8Vspi+hcWxSywtk3eGAD9nkXigHO0/VIsXQXySmGGcQSPVllJIcGqIgMzGVu2Kw==
X-Received: by 2002:a17:90a:6986:b0:2a2:1012:fbbf with SMTP id s6-20020a17090a698600b002a21012fbbfmr1808164pjj.14.1711704464008;
        Fri, 29 Mar 2024 02:27:44 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b002a02f8d350fsm2628830pjb.53.2024.03.29.02.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 02:27:43 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 29 Mar 2024 17:26:17 +0800
Subject: [PATCH RFC 01/11] dt-bindings: riscv: Add Sdtrig ISA extension
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240329-dev-maxh-lin-452-6-9-v1-1-1534f93b94a7@sifive.com>
References: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
In-Reply-To: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 Max Hsu <max.hsu@sifive.com>
X-Mailer: b4 0.13.0

As riscv-debug-spec [1] Chapter 5 introduce Sdtrig extension.

Add an entry for the Sdtrig extension to the riscv,isa-extensions property.

Link: https://github.com/riscv/riscv-debug-spec/releases/download/ar20231208/riscv-debug-stable.pdf [1]
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 468c646247aa..47d82cd35ca7 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -121,6 +121,13 @@ properties:
             version of the privileged ISA specification.
 
         # multi-letter extensions, sorted alphanumerically
+        - const: sdtrig
+          description: |
+            The standard Sdtrig extension for introduce trigger CSRs for
+            cause a breakpoint exception, entry into Debug Mode,
+            or trace action as frozen at commit 359bedc ("Freeze Candidate")
+            of riscv-debug-spec
+
         - const: smaia
           description: |
             The standard Smaia supervisor-level extension for the advanced

-- 
2.43.2


