Return-Path: <kvm+bounces-60503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C05BF09CC
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9771189A1E0
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC522FAC17;
	Mon, 20 Oct 2025 10:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nN8I7Vb/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BF9242D89
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956739; cv=none; b=AhpNkJTQnAjd63U2aDBVS8M9UAsl+KIHbEF8+2FzaHOHmGtMfvBfOuNmUoikfhNVI5+kS1QH5tA5cBQ29OrOON4DM/m9HZonVB0540WHMWpZEhtXwtRsAdaIjHzYKEFHO04oyHnAKm+wPKe4WC6LTKzE5VpW3e+xP15Qth3CzLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956739; c=relaxed/simple;
	bh=G1iuQahJsrYJ21IJS0Epi55ij3/ZHOuu0j/lP0L/reY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grbYvRRRtXTGV9Twq/BpwSF5AOC9iznQ1IkrygtFd+LfjsmxswY0+kQV9HXpvGFZ2jQCkKYgciC0odmadL8tnsJK+4tFiO67DHDiI8unWWJWo5vr9CdtZ9djJefPDaq2RzEDFnBYbntE48+oKTI8/EtUxB0Trxywl4l2yoZeNQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nN8I7Vb/; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e542196c7so33457675e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956737; x=1761561537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI+hF79G3saS4cJM9gBn0qvW7x/aK3K4EItDfXm9eIU=;
        b=nN8I7Vb/ZQaGIQNyQmAd8GA8oQrL7fkQ3GEerKwc6NnnV1IGPH5CQfRmFCr3QcQOBA
         0WfLo5U5hdu44+4difjNLte5PQcFaM14cxH6mlxSde7ujWBzjDQg2F7mUJ/tnGzsS98e
         b4NLiGWaiClnOGriDO2iNNT1fQ3AllBZLDnu3gq7B3bSXbvCo6s5+BJaXb2Wvz4SNRQj
         rcsbvTbA4I3CZMWhtTlCuc9NOF8Hx4wJuWz4L38LNP9Ocepil+AXTEovtxhXnuo4lLGs
         xi1DbyZ2Otj3/mU9Xa3geGtWik7IVaaZMnPmVjcU0QINwUnAH1pnGySC2yWtLgRnwFot
         zUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956737; x=1761561537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qI+hF79G3saS4cJM9gBn0qvW7x/aK3K4EItDfXm9eIU=;
        b=EjPHs6RMe+XH36dq9NorwtXNxQmd8xcnof1t6uPf1H+u4wuS1TAL67eZSeWxVFgQfU
         Bnux17zJmHr553x3IJTnA/BX9c+QmWWdXnbtbuhZFWfjHnWrznhcSaRTqidI9bmyUCzN
         syIIxVvbpFx3lNlbmZzdJAJNaMUHK7ON9wn/au7ew3agU3gvv4NANdKcKp2mBSwxvcXh
         GeMquqOX4BdHkJBYB9fF8l1hqw57gdSDH1FCQ8EhyWonXBVlQE3F7BhmUL1rIJLFHzOh
         SfmopBv/f5r1jKwub7+Ut123tnOpH0XkE621L3Wywmp5EKtDvA2McAEWL81X/uh5EU/p
         cuYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxN3iX05QdalWcKNlRDF4ISe26fhzV50hAFjkYVmQL9aIwpQ1d3MQyzlGK0Hmmji9Rkj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF8ZKlvqBkwgXyELxUJ/KtjjCZ+3mwYgqZeUjc5YxGibMV4yWm
	OJKHbm90qXQ0lZsn9LARiFMRnPkFqFe41xSpM4BmhVIn9xhi6wtvtwAtr4fwCTfnFLU=
X-Gm-Gg: ASbGncvZGGATQRehCHHZ460oSALahYJGPt7gOqcCuRYmlz27qIKTda030HL8VwXtgXw
	O/De7jtPfJdmXQwqSgjJRW7dzMr/y9xZoNwcF2UIh0B/kOadSplbuMNUnBtgPxx0mYN5356jQQF
	PJSCpnu73SkTaqM35jFHtAsjzPPMxNu3ZgI9oQoKAtte037JRLk76T3CnhwTix0qH4Im3cpVpO0
	V+BY2laCjLM5eGUHGqMPUI9cDQ8BuJVxpngsGcNb2M45s2kuwt89bngBzxhkg6H2gGMWrLUgg67
	GkKSTjN9bG+5BxqSBxsgmfHY0px+nfHlO9UsjxqWw8DF2g1LwPXEiuM5r1rYl0m5W5tpK4QziOZ
	1QGB55k+9E+pc3NN+OQBf3aDsKmTz4gcHuhqFLn9OQRqyS0EoOu56Bfqdu3Zr/W0mWrit/cXBCq
	NfoYZwjS7K3niT8KKh8/H4sAJ336GPfdgtTs74hcB/HTbmpGHEhQ==
X-Google-Smtp-Source: AGHT+IGkiVeRk8iHXbbwarjONT3Tc41KOvva+qopWq1+Dk4GjlVt2+f7Q0Q/jxdpBNdogpqMLN5a2w==
X-Received: by 2002:adf:a30a:0:b0:427:537:39e0 with SMTP id ffacd0b85a97d-42705373ac1mr6211391f8f.14.1760956736641;
        Mon, 20 Oct 2025 03:38:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d972sm141722655e9.1.2025.10.20.03.38.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 08/18] target/ppc/kvm: Remove kvmppc_get_host_model() as unused
Date: Mon, 20 Oct 2025 12:38:04 +0200
Message-ID: <20251020103815.78415-9-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 6 ------
 target/ppc/kvm.c     | 5 -----
 2 files changed, 11 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index f24cc4de3c2..742881231e1 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -21,7 +21,6 @@
 
 uint32_t kvmppc_get_tbfreq(void);
 uint64_t kvmppc_get_clockfreq(void);
-bool kvmppc_get_host_model(char **buf);
 int kvmppc_get_hasidle(CPUPPCState *env);
 int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
 int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
@@ -128,11 +127,6 @@ static inline uint32_t kvmppc_get_tbfreq(void)
     return 0;
 }
 
-static inline bool kvmppc_get_host_model(char **buf)
-{
-    return false;
-}
-
 static inline uint64_t kvmppc_get_clockfreq(void)
 {
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index cb61e99f9d4..43124bf1c78 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1864,11 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
     return cached_tbfreq;
 }
 
-bool kvmppc_get_host_model(char **value)
-{
-    return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
-}
-
 /* Try to find a device tree node for a CPU with clock-frequency property */
 static int kvmppc_find_cpu_dt(char *buf, int buf_len)
 {
-- 
2.51.0


