Return-Path: <kvm+bounces-62476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2F1C44D6E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 91F564E6AB5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F7B286412;
	Mon, 10 Nov 2025 03:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdUGXTRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA328E59E
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762745583; cv=none; b=spwfUVvNPJyujcXCup+OzA+DLJjaB933vYx9SLx9drlmpEuUjK8LC6Lq2stbLuzSy9nZ7FjsXyS0vxZMDYOgMjx8ElEaYzgwmW3byb0KqZv+95cNp09UpCAYsfPk9PX8i3zxiGqgaCeUUreISfvLYSqQp9ZcKN/9BcMZedS9nqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762745583; c=relaxed/simple;
	bh=wUyiywX8HHaEWbLEv2lmqnlnMpiUcQdXEeaTse2sVjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLX71dc3Tytm1F5wMffLqtVZ1OdEXaKSVFSnvCa1zdT8+EpKXE/t7IBWNJh6OK+x/i/QxGiWV0qBV0Xod8br7nZyFOZYti/6odkuCBWqGGJS+2W/psrFhnPOX/fbltJdox1z2MLsFyXPqNaQtGe3Y+g5ebodc6el4q2o+ggIziU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdUGXTRp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3438231df5fso978412a91.2
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762745581; x=1763350381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ybWNsbg/E05WgR7p5k3lqGaIc94oz7znz8JCSDp+Uo=;
        b=ZdUGXTRpC3pFdmNnKuSkPtZQ+rHg5XmEf8ygqOGLWJZFkCGPjR5/Z5HGlcYWyQoiQm
         XU/Uu40lmqaY4gTxMD7BTPW3FWd1u95cPmiKpuRUqaYG3S3LLIyjcas2rgfkU7BK5BRe
         dpqtfzjqtUQ19xzgDci+QmCBShikH3k6agDlCNgDp0vAu06e9xfbWgL2Z7AR+9hDQW0u
         6uHbqnXunVfgHolvuhprMUihHBZSVq7cUG1ZlI2k6KgjzyXXOfUxCamdbUlexVEUoyUw
         jOo+l6jBgVHwJoIheI3Js93XbgDDdPev0pKYAaOjn5/RPF2p5VGH85KH7ua39kwtUq83
         1i1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762745581; x=1763350381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ybWNsbg/E05WgR7p5k3lqGaIc94oz7znz8JCSDp+Uo=;
        b=KkwQAHLAd7vwPUA0Jfx1OYwhscN0Ah0rXxbLhMD7+dC04j9OxRQzrqqu9coZaYHKfW
         3L6Zc5eDqUzjFFEA/B6v+Ll3O9swuQcbBJAh8wDo4bDU4lkiXhRWQDwyp0P3fuaEB+Fc
         Xq8VYfU14CqSoQ+vIFmi/13yxPBRHMo1JfLZ9ZTT9hPDawr99jo+uAOce3Uepj8F7XqF
         D3VKYwjPEIjbW0FnZOwLoJZV7Idgb5Rm3g71iu6T2ldnqM7IMa2snN1XcI1dRFoRvcx3
         nPwWZI+rSBFvkAewwHhvOIv72+aQ1vJNCCQfpSl3ASP+S7yi1lDOMEDC5bCJ5gPLuw7t
         zNOg==
X-Forwarded-Encrypted: i=1; AJvYcCUkndEioPw7hxC0mSEdTcXkgW6buKNA0Hogs5b+LqDJVPuBizckN/aPHy0FtsXAR3JUOrk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Ph7qaN11aM8Z2++0GyAhTfAovvc2NVR5Rzlx/85ODwLvcbUo
	2KLiibzmi+OyXKGNflVXIo6WkJazm2x4OstKwCouAd46MkDcKpn/meUu
X-Gm-Gg: ASbGnctCDKfrpN+QA2kHsanUN2cBJb8JkLNvSIkeZdX945aFUl6wB38Z9u898TmQDUw
	DmC6bMZxbvcNVYCmDQTViKlntP9rJo1kw3+8t8/RdzzigKCONE2UrP+pReGrsf7PrFA0HDLc63D
	S1ORUs7UYbCDxbFGN6d5q+/aHkk/ArohKPpWTaNHwa4UjvjlYZ8ZmHbrBq+LfTUCwqP/m8fJ8kT
	yWEh+BQDRbLOC4EvoAz83jF/ayfAYGMwBN8A3X28NluQQrII/WX36JvHR8Py9xkaORm/2y1ERFu
	Qkgc/fzXURe8ZuvtbA7jiAq+fdG8TcfG88Vu18/csDzORAzRb6JLl3GrM8TWQy/iWteHZYdbzx2
	THdBXyKDdqyTOwbRYCqopsuIAFI132887axmgfdX2IABnitnWAxSg55WSRNUNXCOphWOcxu28PQ
	==
X-Google-Smtp-Source: AGHT+IGB0ChoFCeyPh389xbUK5wIixXaUmpWEyfozp174FCz0qkbFk4vEPQ2Z/4r106b3OFiDjFdOg==
X-Received: by 2002:a17:90b:270a:b0:340:ff89:8b62 with SMTP id 98e67ed59e1d1-3436cbb4076mr8133343a91.21.1762745581630;
        Sun, 09 Nov 2025 19:33:01 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ba900fa571esm10913877a12.26.2025.11.09.19.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:33:01 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 06/10] KVM: Fix last_boosted_vcpu index assignment bug
Date: Mon, 10 Nov 2025 11:32:27 +0800
Message-ID: <20251110033232.12538-7-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

From: Wanpeng Li <wanpengli@tencent.com>

In kvm_vcpu_on_spin(), the loop counter 'i' is incorrectly written to
last_boosted_vcpu instead of the actual vCPU index 'idx'. This causes
last_boosted_vcpu to store the loop iteration count rather than the
vCPU index, leading to incorrect round-robin behavior in subsequent
directed yield operations.

Fix this by using 'idx' instead of 'i' in the assignment.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..cde1eddbaa91 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4026,7 +4026,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 		yielded = kvm_vcpu_yield_to(vcpu);
 		if (yielded > 0) {
-			WRITE_ONCE(kvm->last_boosted_vcpu, i);
+			WRITE_ONCE(kvm->last_boosted_vcpu, idx);
 			break;
 		} else if (yielded < 0 && !--try) {
 			break;
-- 
2.43.0


