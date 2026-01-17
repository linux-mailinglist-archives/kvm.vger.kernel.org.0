Return-Path: <kvm+bounces-68436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9C1D38FC7
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 17:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 574E53027CC7
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 16:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF71233D88;
	Sat, 17 Jan 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WzG5j0Ap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F8314A4F9
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768667379; cv=none; b=cVDABTNUgr1IavraucyPg6M2dPJVxRwRh2ndlb7VH1aVydh3+XcUn0ua7PZCHhLKEOPn63Q898cAAyaR7gOV6cftgo4Bdxm+X/djV/P3oErbBgYDtSzH2fY6a8zyNB1MKzQ1r/55ylls28FYErMv7emWrqjpA1bpNDTuIHfkKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768667379; c=relaxed/simple;
	bh=KXsiQgsAl8ZTKHvyYwy61yycEahETMgxXFT/jaPbp1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KDVLssZagaTnO7MXR5wGPmS09Clw+JoEZqzuO8KDouXsJJLBK6f3SuD6w74XKdCDy09ldsDjA/K8ZSvetfWNKHqtFdX4VTIhu08Uw36V6fgVZfHGC31cSF4rgCkAqd01edZM/3qLmc4CeCA2zbOFNCjhGwmBggudEBNKvhG6hx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WzG5j0Ap; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4801c314c84so16638035e9.0
        for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 08:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768667376; x=1769272176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxWCcW++Lxcknn8mz+ztokq5YZ0Nmxk+SbAcg0xOxLM=;
        b=WzG5j0ApKaEBv2WwkVg6HbPendbGWrluG8KcepeU/aK7Lx61txVY/bffAvL5+0mNJn
         vlPe6HYam/5+8QWEJ82zT2hT4HSJhzKfh2f7FpTRvRszqhvf94zv0/H/c3Z2/VTQZN1u
         71uftJacxVR2H6ZsZUXliWAc/Nnztoy3WhdP11Z5sp+w4agYrL6UUjrCyNy1uVb3M2mE
         XOLI9yCi4usTZqDeyLJ1dLRe1x7rlkkRS41AExDpnLFcAuBzczPNevdCdTaJezF/SWxq
         leXjh9vEpabidSjhVlP15HwRo2At0/Y9oSd/CuFPA9uAEmunEgAcD7v3kTjoZBT2nlHb
         3IJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768667376; x=1769272176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LxWCcW++Lxcknn8mz+ztokq5YZ0Nmxk+SbAcg0xOxLM=;
        b=xLtEyDwHRlGO9bNoDKW70JXpoOpcyj6EchdT9d08nYCyKWk9iaHjFs4HGXXHc8n7Es
         oBQY02Hmj0cgLCGBlAtU20YfTabEOHuYGxOWzY7OoOiELcYmiRp6bUYm6PN2rj/e33Ca
         FONnXTEQdMIbAw7UVRDQf6Ga2QvMsYp1AVoVhG0/CXN7dVDzfXKSVmk20qY6MK8Foiga
         hsY6Qp9sH6ZkHdjbA6WYtnYwV8MmBfrqh8RAeTnAm6Rq+UXPL6ivAYi7tMU+BEdpcuqF
         aL/Jyyu11ykaGAnVsKMBAbV0u22qilBK+t7T95HL22Wx0myULSFfVNaKNRuRHLjn7yh/
         1gqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkkekuVT9kHl0IxV8haHtANC5rZ8yWa9x1ym/av+Us9+h/o6FgrRkUgh8gD5EmiFGe4M8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1q04oBGw0A3oquPFheDiVYQvvVe9+/7ejbuIFvXBxnVJ9HjyJ
	TaMV+ohw7D8mAOR9BIjtM1nYkGPYwxwa0AepgUnVaZ9M+d61i9WZkkZ0YzAD0yHjWWg=
X-Gm-Gg: AY/fxX4qXr3YVlMFlFQwkTaRIXMRBZu++hvBKoRX+/AS0dK7sjwNC5YrBxWH/BoocWc
	qAbxmLnv+B1PNdYDQdCuheGCeOEjNxaodg4ruYhH2SW9uFgplsaPFuxQQ9KQiEJmhCopV+IJOMw
	IBgkT6E7u9n8fWBEVh2pA9gX/XX53su4SwceS/XVRgu+sp78LgPvHW6rNgDuI/2+2MSSwTyBzl0
	RXB4JUfBUE3UCvO3QdE3vHA11Y5B94Z87H1CO6ym3HOUyRSH9dhjA7aTMDmaAn7HoLQeI4VpbC9
	VllgPCNyObSNvVdJ6OeXajiGDex3scstooke2lmk1YB/I85FnIM8P72Y9N0H1lpLTzoe0wHuWtJ
	OhL5onk50p//xxbwvwHJDGVKBr7dTXp+j0Iyyk0UnaPoC0cJF/yHb6pQuzGU1ypficTG3VMTGPK
	TJhJ7pWM4fu9bm6rWTdXh3zfn70RY6TR1drgREOEk+XBoe57UwlnY2vy7WamKq
X-Received: by 2002:a05:600c:1991:b0:47e:e4ff:e2ac with SMTP id 5b1f17b1804b1-4801e356cebmr78919055e9.33.1768667376019;
        Sat, 17 Jan 2026 08:29:36 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e86c197sm101328235e9.1.2026.01.17.08.29.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Jan 2026 08:29:35 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v2 1/8] target/i386: Include missing 'svm.h' header in 'sev.h'
Date: Sat, 17 Jan 2026 17:29:19 +0100
Message-ID: <20260117162926.74225-2-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117162926.74225-1-philmd@linaro.org>
References: <20260117162926.74225-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

otarget/i386/cpu.h:2820:#include "svm.h"
target/i386/sev.h:17:#include "target/i386/svm.h"

"target/i386/sev.h" uses the vmcb_seg structure type, which
is defined in "target/i386/svm.h". Current builds succeed
because the files including "target/i386/sev.h" also include
"monitor/hmp-target.h", itself including "cpu.h" and finally
"target/i386/svm.h".

Include the latter, otherwise removing "cpu.h" from
"monitor/hmp-target.h" triggers:

  ../target/i386/sev.h:62:21: error: field has incomplete type 'struct vmcb_seg'
     62 |     struct vmcb_seg es;
        |                     ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/sev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 9db1a802f6b..4358df40e48 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -14,6 +14,8 @@
 #ifndef I386_SEV_H
 #define I386_SEV_H
 
+#include "target/i386/svm.h"
+
 #ifndef CONFIG_USER_ONLY
 #include CONFIG_DEVICES /* CONFIG_SEV */
 #endif
-- 
2.52.0


