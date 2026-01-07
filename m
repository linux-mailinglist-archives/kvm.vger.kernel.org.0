Return-Path: <kvm+bounces-67255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 078CDCFF738
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4CA14300CCDE
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 18:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34F930AD15;
	Wed,  7 Jan 2026 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="djeMXLoB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E75FAD24
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 18:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767810032; cv=none; b=VYparthuuskv17u+soqPl3Dp9HF6XUdNKZALTQk+jfAbU28Ipi/irSDoZVJ5sYbAn42v8+BNzNLQpTCHyDyjHxbnujpsDWfkcxUE6NNnbSeWMl/ghy01+9z3swcSQcVWb9PvVCPi4OlbVg5Y02jXiOm0jo5JBagklfii0xDohqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767810032; c=relaxed/simple;
	bh=ByJflJdrlkWMN4yx0XJP5UbGSVv0+rcoIgL0XpCALuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xcl5sqsKO486NL7HShgwB3SOHPwon7+jtx0XUXz2V7ToSNTcs3qS8A9HQXEOFblBJVxmEAbaOj0Hvg4fIzH2opxscyWib++5migqe5h79ZJmHIvvrEipD4SK+MF+MB2gyWHE53yr6CLaBxub0OyARkwANut+yk/vT5DINnXGK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=djeMXLoB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso22857075e9.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 10:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767810028; x=1768414828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWsSLsG+wvPELoANhMBDw363Hn8CM9W1tE+13sFYpjA=;
        b=djeMXLoBaZle2FsOMaF42yRbS81L5BmrXXgFOeAWFNtFDYnSbIpkIVUq5DtsPbsqE8
         YFd/+anjYznKrfIn6uryzjQS9YPTy2KmeMRHkkD64nKrAw7lAqqv/+oStoqVb+55EyTn
         HFfhmhXz/Ow0wC3DEm9N4UqSWXZtIrSlSLScVWhj2LVcQ67+v+SpP9YhBZCLq0VKBRH7
         7J3y6YxzYakn+U0w+wOEt1RRkeMkLnvjijslVy+tehvCofrwnq22z1biBSXbF7/3JHLK
         Y90niN2e8yR6XcnqKfcBzxo17n1lwjVvHRE5cmQAnMwBbGYdDQWfdnZI+qNbSK18WH3B
         33VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767810028; x=1768414828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tWsSLsG+wvPELoANhMBDw363Hn8CM9W1tE+13sFYpjA=;
        b=Fok/qfyZrdbEwU7ubNecq2GvkzoxjH+rbOWsLyHenhCIFd+eH7mrZ4j/Wu72x0GKMd
         9iZdSeRIYJXa4glTchGV6uNYmXxtlnuPyQw6NC93ySA0e7h9ZXEFZM82OwBTpj4izENS
         j13dC8Gfjg4CUkSriEVnPfnaxtTozgXqApv3xRFpu7QUlAX67Em48PJ+oh/xOa7RBzZ+
         YjW3l/nzVugPMWjVISvmUL9l+ex6s5BGf/Za4oZnqOkoINir+IAYYnr89nIFDKRqJ7Ie
         1oj9r0bcR8sZKQdaWefoJcykIiVTlg35drsvMP094w3llg3Wk3q3XyNtASD2vk0AgtB+
         F+eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK5bBCDtWcD/9QDbUvuCd/7UpHzRNfJ6/yhDwHGfWBdK+JIE0MvEPCjIgvhWBl4TEA3Ng=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMFxS5InEoy10YqUuNLRD1QgOoQwSZkZB0QUk0x3KT+cUL3Msg
	bsUfAz2XfP+PyyW+zS6Wexi1PgIWZRU8IvwDVkWubnhaeC7gpzdkxu6wm3wsHTMcIwQ=
X-Gm-Gg: AY/fxX56aZ88Tu1/tPjNlO1mKuNmaBsmblcRBMyQhN8m1Zc1S0KMbfPujupdpfusAH9
	Q260DlBxoXFt+eKbsJpbRiWYmHtGOuyiJ9GE12skzvl7d6VFBPR4IlWhC+0J70fxUaqowIF3ERt
	jlmZe75F5CukhJ6Ol2MGhw1O4zQsj4+2tlofLOE8rxXm+sLDInsCV0eqcfYDsmnGV5hRNzr3TFp
	GWby2D3Fc8ncmD3qmLXYuTbwlALIBcuRmgPJolbpTJbkUMl+8Wdi7QOmK01G6sSoR+Ae/WDJNE6
	Mi4XD0srY10NqoYMeyAwVYVU1A4JhAKsxW1ciKeRO2tm2DvSDnMl6SKDORzdqZjOD3RXv1WCGXF
	Zd5tT1ktWcwSquZnfbZ1n3srZ7mvXrCllaEF2vR6FVj2Juzs8h8DNS7WFkZiDB2TP7EPH7wYwCv
	OLUiimv4+TqGaWYz7Xpbr6HcYYbceYTFCoT8om18grX02yKrdP88qzn0IBf0st
X-Google-Smtp-Source: AGHT+IGqRyOjtS41sckwiyowNgjcQsad9x2KyCCpTop1x6cKsfJF1oZ8FVI9IOKBIEMgZfP/HRXMXg==
X-Received: by 2002:a05:600c:630f:b0:46e:1abc:1811 with SMTP id 5b1f17b1804b1-47d84b3b75amr39154085e9.27.1767810028459;
        Wed, 07 Jan 2026 10:20:28 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dad8bsm12106291f8f.8.2026.01.07.10.20.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 10:20:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-riscv@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 1/2] target/i386: Include missing 'svm.h' header in 'sev.h'
Date: Wed,  7 Jan 2026 19:20:18 +0100
Message-ID: <20260107182019.51769-2-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107182019.51769-1-philmd@linaro.org>
References: <20260107182019.51769-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

"target/i386/sev.h" uses the vmcb_seg structure type, which
is defined in "target/i386/svm.h". Include the latter, otherwise
the following patch triggers:

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


