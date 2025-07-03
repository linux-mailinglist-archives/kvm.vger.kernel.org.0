Return-Path: <kvm+bounces-51471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F1BAF7185
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 123384A3F96
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5219A2E5430;
	Thu,  3 Jul 2025 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="beH8M4ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37CB2E5422
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540506; cv=none; b=VIxT0ed7QMe3LLuEArowTI91fVsRVjnHd+IwkPVqM8qzfepC35OHtOtft0jQW1AoQbbcl7YbmRmou1doKBmMCfGbzGCVCQpGap0eWPPqv2Tr6KmNQzTd795UqEzLYDsjG1dB985hzyra06FFGx8sADOQ06+u8ordJlOAdCcWh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540506; c=relaxed/simple;
	bh=YWru+Jlu+RytbCYbJQvqgKkd8EHbgKRBHGNL506WWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ty0GYvlKXI8KQUhz1Lyru0gauCYDZrilMFJ5WZIPKEDns8lD9JMy4qmO0xkCBcl9DMvC/ZVFfETOCch/BfBhwwMk6tXrRD//es+gRCa9PK3xt/aJ8dG8tL4vngpTsPtIyOdtzTX+mTmSb86pfpciCqMjDXtBFY9O/IAv61qYcME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=beH8M4ls; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-454ac069223so3003185e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540503; x=1752145303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYnKEElTC5IwOmZPbnF1VDHeVLYo+K3YiqWHHRzMLu0=;
        b=beH8M4ls9AJR8+11l9uOEWxC8rp0St8A6gNH77By5EgXe32rvE8zRhtomBvSfTSzEK
         C2YUgAqrvhOH6qTzxVnHaZrwMgYGdkZLWbadeQ2eFVXP4DlL3Cm5Km2Z2AsC7hqNAMCF
         /ribF6F8z0kD2jZ7wjDq1pjjcSs+KLYJr1PM/QqWUo2kFI6r05nmypWFDMjqFlEnPpIH
         iQTeoklItelAQquOz6aZgqoe6K4kx4i0ywkD6SCh+ET2KYd3uJkrYmvfwJ0dJ+qtZzvz
         fAziE2snTyKajYSjX1kr2TgQjmJ9ExGn25ccDDcvSW6Glulk5zIRc6tYRkH25jraISJI
         Hb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540503; x=1752145303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYnKEElTC5IwOmZPbnF1VDHeVLYo+K3YiqWHHRzMLu0=;
        b=ALVpiGwynZL5Bk43vEVQrmLvTb6wLilqWaQhiK3aTAdJ9/P74TTkFE0kl2i2f7iuLI
         QwClLXhFuLymXHfOTaS1/0RChkLa3OrY7zM0MC7+tWGwc/JKIDlhUVQL/Ai5ljPcvz45
         CDsDLglwt5RhqqE93wlEDS00ldxAcdayt4UN0jsr/PpWGx7WIsFZu1fMZgtIAp9U0qV6
         abJ+qSIAfPDDBJe5JszwE/96QQJAMB4aCb73OmKFzYDD+4VQn4xKuTIa79ndxJI7UT/8
         W0/ksOGxvt5bY/YNEpZNiQDhGY2JHgMYe9qE2f/xteY9nLOH4s9diEHJ+NEFwfRoHzpT
         2/Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUi6Ms7vkmEE/s3FffL7Gs9Tovqau7Og+YhwaNjSmweZdKtT8AXMnY82F3WBPjhjtXc1hg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8RveTYTbn7tdkR7WlULddNXqcIhiz3zvduxUtHi/8TXlO0o0m
	7jvqvtIj2klb7jFkbXNCfiUjtiwmg0zgcPNOGzVaRvR99z/ygVDuGzBTZ0qmIcgqOlo=
X-Gm-Gg: ASbGncspTN9dsUNj5g8at9/FJguw7GrIC8fCiBwM56Wfq2g0ALFJpNkCnJ3JVuCCqIy
	OlO85qDV+40bcn7fw6/+Cvpf8xgsknFoogJdMEkK14UM6WSi6IgRQ99Rx/tKEKdOqYnxI/YJlst
	TNgiJhXDNxdLCpY1xPDTBPzTqIFizHVM+wFYkIR2J45XHVDsMV0kAOdUnFDME1aNDdIAWoAK4ot
	3x22rPiqFFa5CpI4fSNuEOj1GflBB7nBM3Q8MdvBkKnShLTsOQ9PQcV0CcNugmmkbj8OC7cs/FC
	RRJuP4jUJzhp3/90OjUqrCaQ0GiEB0VDfXiR9R4NzFfQC4m1HjiRn6I4ywhIgDQe42f+O32sgIo
	j9PlaDu5A2s4=
X-Google-Smtp-Source: AGHT+IFdCajdFy7GoXw0aUuDzxPHqkPrhDSt0yuUGVOtUqyp9f38GDPXrJ+aNvB1mENvYSYuw0+u+Q==
X-Received: by 2002:a05:600c:3f10:b0:43c:ed33:a500 with SMTP id 5b1f17b1804b1-454ab34622dmr22700395e9.10.1751540502931;
        Thu, 03 Jul 2025 04:01:42 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde3b9sm23907695e9.28.2025.07.03.04.01.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 68/69] accel/tcg: Clear exit_request once in tcg_cpu_exec()
Date: Thu,  3 Jul 2025 12:55:34 +0200
Message-ID: <20250703105540.67664-69-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops-mttcg.c | 1 -
 accel/tcg/tcg-accel-ops.c       | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index 6f2a992efad..543c4effa0e 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -112,7 +112,6 @@ void *mttcg_cpu_thread_routine(void *arg)
             }
         }
 
-        qatomic_set_mb(&cpu->exit_request, 0);
         qemu_wait_io_event(cpu);
     } while (!cpu->unplug || cpu_can_run(cpu));
 
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 6823f31d8ad..c5784f420f0 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -96,6 +96,9 @@ int tcg_cpu_exec(CPUState *cpu)
     cpu_exec_start(cpu);
     ret = cpu_exec(cpu);
     cpu_exec_end(cpu);
+
+    qatomic_set_mb(&cpu->exit_request, 0);
+
     return ret;
 }
 
-- 
2.49.0


