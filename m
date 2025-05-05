Return-Path: <kvm+bounces-45392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17446AA8AF0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F63B16876E
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DC619C54E;
	Mon,  5 May 2025 01:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aozEJOr/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3244919D09C
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410190; cv=none; b=EJciEkJCr1lFOq2tZTnzwYWgpkB/e1lnqAC8PRbqCq/5CApmOkPySh+R1etERWnOv2hdCwQ2BAFlG29AMNQnXfu6lR0VCSi7q3TVjkNZD8IGzWEfAJn15XXZQvWC+7uyKdQB/30XXM2m5MWgwgqun4/Y/f9ARnNXAtmZiK3zc/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410190; c=relaxed/simple;
	bh=a6kkYOQqj08h2rctHySNgs02RKRHZiL3GfTnEUzLU5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyrq+8Ec6qaWvZPnba/gK5Q19QqBapxg+gAhWTBIqDFLfBDbDtNx1o68IpVGmxdT0QThjPAadQbCvqh94/cwjn++KQ5/+GSD5dLEczkhyui9PwSKqEagXnSkIGzT/7ryGp6yADrbu/+tPiCE/oE/aj65i5o+N7XMLL7G/MFBZhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aozEJOr/; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so3440444a91.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410188; x=1747014988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGt1YesVdMfmP76X8zMo/3VD34v2vwkTupFXjn4DlBU=;
        b=aozEJOr/nw9IJxi/H61F9BLjnSRGqSwmGLcdZZQQaHWohBPOw4Ha0TcQmpUhTZb2go
         SRd7ZknObi3mvDleiXRaFhzK2Z/W/OQdAHxW1uhgPmNofKTYY3UYDxqdtVvj5bHYqjEz
         xB42VbSbyeAEisd4z6ScNp8AsS9zwXWbtD4jA9GJroPFtYS7McJ7Yqq7ySSJaSoj6nWN
         mOj1dVOkGGkBMr98Yo5p4h6Kc2CqGaLfy8Kl6weqQmjVUK/JOApnJPh4TBhs1P3oumRA
         liX40hdAQSpqn2DDTucogCfAx+62b1Uvr9McBHV8IX7RoVovPlW2qUisRY3NOfmpipek
         kLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410188; x=1747014988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yGt1YesVdMfmP76X8zMo/3VD34v2vwkTupFXjn4DlBU=;
        b=bhuec/9kota+LLFssUh38GTqpV2HCeH0BxNYUcxUhAKNNUvkjMgLjtnz/3sn1QTO8+
         5E9/YeG6GGOX4O7uL5RPJBeZqzJTk0T3jvBqzWAGnfBThcP6WTVYzo6qSZyTuJyU07Om
         GeLsHvsWtY24CPtZJYUlLOFplmS3ZWaQnLDXZA1BL+LeeSrrWaRhbKoBHMr3bLVJlRfs
         K60EKfMFSmVXKE0Va1D+XQFtgqbFUH439rU8DMrGZmrs8AadvY2CAgJLCx14D1qzpGUn
         DBonLsYte4CDTeJzPtyyaZNtpxSO+11NWJTCxbBGXkfDHWOkIJbPUsuYAvyDmtk/dkHO
         YUSg==
X-Forwarded-Encrypted: i=1; AJvYcCUmez92EvTS1Opv/A4Cv5UQDbijeam+DyY3ygpetEPYbnUmwznf8l+yXoh6K84iUVje8V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyegywCssHbtjgdYCrLM/JtWUGob8/9mF/HEOQD8hQhvDLFJlI2
	8HXGpSjMqinh1nNzp7RXD/ZNjRBKaHj9I+eYSkXcDoVeIQROPI9URfEM0dTNhCA=
X-Gm-Gg: ASbGnctgQfrimuhyTCmeA6VYq+yA1kOkDjEVykKLM7ClFuysx0llp9zhdKLHQD78OnE
	VTnhet56Ysy6Tv88NPkEcR8ImGz4V4BpV1gQCmCADc/vx3NMrkBvuNPRJeaV3gVICrGCCrhjlxM
	Dlo/CsGvlaA104+owUxu5b425U8/IyBBXBPmlLQPq67KuXRyyVesvgQYFKhIZvvNBcf9IfsDgv2
	x2YqqlHVBHVj0gPLrtzGYLyG5cUYFPqdXYAqvopbOFGM+561aqROck2DhjsTzR6GEnpxREDTbPF
	rOWk1xb1EB3TYYPu9V2oY7VrpA34Mk0nUXqC2hU8
X-Google-Smtp-Source: AGHT+IFfSDgDcOkgnrJb7vQb4Qf1FWNpsAlqKI0tyW5JpiO/Eoz46KZiZLg87R1U0m/zOjIMxixIKQ==
X-Received: by 2002:a17:90b:548b:b0:2ff:5a9d:937f with SMTP id 98e67ed59e1d1-30a5aec1bdemr12746063a91.24.1746410188524;
        Sun, 04 May 2025 18:56:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 45/48] target/arm/tcg/tlb_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:20 -0700
Message-ID: <20250505015223.3895275-46-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/tlb_helper.c | 3 ++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index 4e3e96a2af0..feaa6025fc6 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -10,8 +10,9 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "exec/exec-all.h"
-#include "exec/helper-proto.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /*
  * Returns true if the stage 1 translation regime is using LPAE format page
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index ec087076b8c..9669eab89e3 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -33,7 +33,6 @@ arm_ss.add(files(
   'm_helper.c',
   'mve_helper.c',
   'op_helper.c',
-  'tlb_helper.c',
   'vec_helper.c',
   'tlb-insns.c',
   'arith_helper.c',
@@ -65,10 +64,12 @@ arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
 arm_user_ss.add(files(
   'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
-- 
2.47.2


