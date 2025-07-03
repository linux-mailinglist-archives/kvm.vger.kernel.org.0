Return-Path: <kvm+bounces-51411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB3AAF7117
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21FC53B8A41
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556272E3AEB;
	Thu,  3 Jul 2025 10:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c4kJhuwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC022D78F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540187; cv=none; b=oP20ob6EFo3ZPTrC1R0tFpaMB/HmPSHW8WulfM05ynfsbBUxtin+cCCbqrSbTNGkOvEwJx4KG6ecOuv5WF7MoEKDlBbFjnoKCUHgVP5ImQ1rS+EDrJTSN8+9WF0LvI8IA3oQDxPQJI3gXorOBdG8XmjAinY8zxBmLOMRVUWtKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540187; c=relaxed/simple;
	bh=4KDm+9RfFQyZb64EFhKrtF4Y23m5BvXW3KljR85Cew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K2A83GUoKRx437iQubyWFLbQ8K5NLxuOl+te8QFTEYQ0HuoC9UKcABO7qk4BCy4sqJ6zzms1I8lA7c2wIkMNaXIOOv4/mdYM28Ryi2qj40S/eoj0kHd2GM6ml5PaKk4/rROB+9yZACSsqjTSskywI+fnYWT+IMU+HLDcmKcTeXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c4kJhuwC; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451d3f72391so57611285e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540184; x=1752144984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=c4kJhuwCJMe/4+wJR13L3OyxZ87DJCBikU6HQIAn/x1O5bbf1G0+vjmEBUyAzhYT83
         Q7zxE76QzFTGan7zyduVgkUv+nCXnEMiaYnPk6FoJ3q0JUMmLTGuj5xUzVb83q4P+s4W
         q0xcX7Ll4X+cnOnTlyiXhO/mbkgWEGoVjSeQA67brgm1gMcdIFRVGkX1KgYJX5S7B0cX
         O7SyBCzIx5PyGrmQNglOBTwAqAzbN4f+rJCzxsVWUhhAi3aiob3eYidrgcAqFMOg2Fj9
         8CU/5E9sloZNF/u8g39nd8AOOdaZeAaVMEHCm4GbadpF3wPtnz+ROKPRNDRNruUnHV7M
         cwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540184; x=1752144984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=o2LnA0Y6w5Dcbmwo4mFxseoE+uLMROuB1j+X+3cYLBJd+80s1hDrFzrGm+3AK3/l3g
         y7oo3q1a/hRsxnt55y9i4YtfQKM+ubHXaCJGncUT8I88O7ys/Bj2fqr7dwJ9gDKx1xGG
         +pWoLcCawcFBiMZg1EMRmbfAAzdF/9djFudXhs6GkdDRVI2nnJbzenMNcxLIHSiMxWjG
         I9uRYtLh0dN0c6TEeickxhKc6obFIuTd8ZzO9TFchqHnOKcYDSA3gUTG10Z3vQrg2QUz
         qquJxFcgx10+1pwfYZR0QHrjEBL0xNhc5VWzjsDlDYvuCgcAsVTKPpy20GJPa1QUJtai
         irKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEkiPjae8e3wNL7qBoXcsyVsJ7LssxA4wJbGEZh+JCgIDSAxuzGcZwCvXKC5PIDSxnZoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFntPTkvGS9Jx+NVngvQoKLqWtHcsE1BYP6jTpQVan+z41/fIh
	cMnygaTX6E7ytANCClM+yoigl19LirMF4/QRcToxAm/2t6sq85nYafDGEE9bbWdDxmU=
X-Gm-Gg: ASbGncsFE41+5wRcUixW4hNxq0Fnv5BZ4bCG/bTxv5Recj9v2OUiNdACScu0OeSyIC5
	ZAbnifsv+9RFa+Vzu898Pv3418QUm/MljCcxsJ2n4Y/PhEG4qnz4DT1fuUmWUT1uf8qcUomRN1V
	evktbGWFrpHvz8ZhKbEfNhGv34+8GIn9uf0YswWnKVymRFbeL8uaFHlSJBeSRdWJcH1qUJyEJQD
	L/YjeG+HFqI3yBcDtCdz2F+XW6Yi5n+ZdKjK0iAvvsEzBaEFgEso3POBx05ASuXsFjGHLocT5fp
	9uOq/6YYmKj4qGsQOvlQzi6+KDbTBfY3efY3vK//d82ON1BK4LIuClT4uyVJWWM65F65YyOJii2
	Nv37MJ3ya8GQ=
X-Google-Smtp-Source: AGHT+IE76e2TUYigPs3T1c0SvOpyckwxGPcmZStVjGAVMA/07iDRifoqinW9ikXlsT4NJ0pneko+hQ==
X-Received: by 2002:a05:600c:5308:b0:44d:a244:4983 with SMTP id 5b1f17b1804b1-454a9c605e4mr38453455e9.3.1751540184293;
        Thu, 03 Jul 2025 03:56:24 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9989423sm23505035e9.19.2025.07.03.03.56.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 08/69] accel/kvm: Remove kvm_init_cpu_signals() stub
Date: Thu,  3 Jul 2025 12:54:34 +0200
Message-ID: <20250703105540.67664-9-philmd@linaro.org>
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

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_init_cpu_signals() stub is not necessary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index ecfd7636f5f..b9b4427c919 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -105,11 +105,6 @@ unsigned int kvm_get_free_memslots(void)
     return 0;
 }
 
-void kvm_init_cpu_signals(CPUState *cpu)
-{
-    abort();
-}
-
 bool kvm_arm_supports_user_irq(void)
 {
     return false;
-- 
2.49.0


