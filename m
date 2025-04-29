Return-Path: <kvm+bounces-44667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C903DAA0180
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1417D1B616EF
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6080F274644;
	Tue, 29 Apr 2025 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T7JqzK2l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BE0269D13
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902820; cv=none; b=Ukn31eXyX9EcMAhin23/MTmSiSNwUmlNBvsIxcNtvIcU0WakgGRyK4W6eAXFOdJ1TsPQe8jW08emZ2m5Z+TXf/fqNUpdaA/tn+BLlukJu4G2IrvR6lHPidC3sjH89eG+NLMzF+M8Pw1kQZ6FWhJei/uEu7D5FEC3Pr/Qx8MSncA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902820; c=relaxed/simple;
	bh=t+WXXRmGx7aPD9jEu9bK1jDI/vcjQD2x35IM2i9mS64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Py+KQLDpVtYyIq7emFQWYVI8YhCKCSVabu5d/0VaqwFK1YLyjBwiY0ZPs5ToQu5Wh+RZmzIJ2m9GbLX6BPPxyyhZyHV36T1RH52dWIkxEWchHxKev66sQ5ZN4Yi+2AXdcjlIlvM3B+w6RlB4n0owo+GadR7yyN/D+4q95i8VTKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T7JqzK2l; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b0da25f5216so3518484a12.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902818; x=1746507618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1+mpgNwQQblB514w6gW7TOdOsjY6yGJh5E66/u+eSU=;
        b=T7JqzK2lG0aYlST6Yl+DRa9ISVtZ5JnTpsj1W6Glz0thuai7li5RsNYL7VJmP58vv7
         1qeDhCGqGai34wsOBVVyhnWIlmdYS8yNIOJ9Jo8Gkzm5QxAythqCI2Etdoj37Wg3apBu
         k/DniHGJnKkKnngwFATFKm7den+myDwM1rL/76ZqTTOtw1GHjP9DViJ8MNkqg8tHYNqG
         vMLPInkJiP+2avNd+pKyxV+G89wB90YIksPLljiq5wlAYdIGndCC6+UqDvYUOFEsKNCV
         PldeNd9hbxA6Pmaqm91hGakRGBTUeSLyZW1bAmxe5Jecm+JSqJBeLauKGGJufdcHkBrd
         dQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902818; x=1746507618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1+mpgNwQQblB514w6gW7TOdOsjY6yGJh5E66/u+eSU=;
        b=MEqhbg5uOtjFBZHzM9lMpS1D5JAqTzNLFhwzVOjIg8DaE0HUrd2onRfki/136LGh9N
         owfVAYuf2Mc2sVm/8GyabUbk32o94JcBUtzhJ+st2zr3nM/SD2sXfMxVnhR9S4Tx0dKe
         /+j2yBp3xGgErF7xTgIv6bHIl6QCBt7235bGLTmwq5sOmpC4Owxw9i5SkqSRZ8mMYpkD
         brAQHvLtz/OocIHnp8WJjifhpCtbilMptDoqMrwyxHJIhoxD4TGM2J1r1D8Xrbx9WV3C
         pRm4g0NAYxY1UD/PNJxCaGhnEIItzwNYG6fjJcJMwtV4yMpCHVnejXU7Vpx2lxgG5kcj
         N+qg==
X-Forwarded-Encrypted: i=1; AJvYcCWr3qtyV1+dFyhQBjY9TeEHzWtZY2Tq/GX+Ho7dVCwJtsmpzjftS4dzM+/QQSBJSgYVK/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcH7PIDcvJvADhCTO2Cu04zdIJZehnGQN6XQMVJorJ17iCfSjb
	P7svWY68zZxwtM1w2D4zwTNFOjE9O2QAjMZXmC5UMHQ8X3wOdNkLOM4nOLIca4s=
X-Gm-Gg: ASbGncsBdCz4T5GCZ5hvELRiV/XQ6zpyM05d1VN7U6XlHLxwujjBu8/A3iPJuSxwYxD
	SJYmo2h0DvjnCSamYHEIKxTNwTmARtGSnE97wXie2DMzc2AeX/sPfYb7pwzuFhPQyn03Ff6Qaxj
	0Nev5DP1JkslhN0QnmEHvUBwPttq8GU+gkabDR7BUhJUciIHlJD1oQD+wxAOh8ESjngRMGvNbDa
	gPbrwgcvNF5qBtpB7SV1spkB7fVbmGbusNsgLNORlYJgnlD/+R2K353c+/wrzIKASDDPAGIDZ4N
	Pqi3tYuySvFZWSDv6dIr1m4zi3hF9t0vnhJldeII
X-Google-Smtp-Source: AGHT+IERHWhMGoawkxhND2r6sOYx5Beqk5TQos+njQ8aQ63QB1/yRMYJ7tUQDCBZu8a/05Bc1162dQ==
X-Received: by 2002:a17:902:d4d1:b0:224:76f:9e59 with SMTP id d9443c01a7336-22dc69f3b0fmr169007685ad.10.1745902818246;
        Mon, 28 Apr 2025 22:00:18 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 02/13] include/system/hvf: missing vaddr include
Date: Mon, 28 Apr 2025 21:59:59 -0700
Message-ID: <20250429050010.971128-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On MacOS x86_64:
In file included from ../target/i386/hvf/x86_task.c:13:
/Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
    vaddr pc;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
    vaddr saved_insn;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
                 ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 730f927f034..356fced63e3 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -15,6 +15,7 @@
 
 #include "qemu/accel.h"
 #include "qom/object.h"
+#include "exec/vaddr.h"
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
-- 
2.47.2


