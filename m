Return-Path: <kvm+bounces-24173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C789520BC
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5C2282CEA
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C9D1BC068;
	Wed, 14 Aug 2024 17:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbKKhoP1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D512F1B9B28
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655527; cv=none; b=EOH7TrjW06fg1RXw1m7NLIMCDJUiIrEwGtI0xaP2lCOAgUmW8Jv1jEKLYqwS+PTSozyKGGitcm995CteQ2e0t3aOq33gkVgHQQFGDWPDOMV897aRbAgrtLxzURbk38gLDRt95CHQZb59y4Eky5WjazQEa+2w1kgjPgdw/Ob3Nhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655527; c=relaxed/simple;
	bh=Qcb0rwKUAFr4eHH0sEce7cid3hsAqYC+Nbx1b1LMV/s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXY77RJSBPJRTh2g7uwXO/hBkVjQsEq9aiFetvJPBbf0SAO7HWdfUK3jj6rpKVv9/t10AfkKemPBmwUkr9MJhConJg48eyXZ20mh4jbPHyD4yRStmhVRGAIj5easAxafJ9TtF0Zt52TAWNBxvCEz06HmAA9YYsHCIO7NU845q9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fbKKhoP1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-201ee6b084bso630335ad.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723655525; x=1724260325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvLg/jdd02raDyPuokVKWkE8Jw8u8gKV/oNxvgJVSos=;
        b=fbKKhoP1DtDtZ+q1Z3oCM+ZIWfF1KB3oTbJEYkw5TlPy7xILgsnK5o/rai6EkgpcJV
         ovbZMwDnLG8N6WD197TQrb3WIT1HexxzZLs2HZ5aY8orWmidRUMSiCOjLB0HYhdPfZa8
         U3l5CuS9FF/RFy2Nu8Btp88ywEyNAoDKWamibcyU2sqbRYBDQ76ZOuNQPB+lRmvHxVKj
         Ak69QNY5OKxCYT68zhNE2eRSG63F0RSq+nTulupPbi73R/GGhQkDnpbtwcZUVVcbfnG6
         E1LtFXCNQvE4GugAxxcznnxlwFyOC3UMJUa9YXeXfcAIoquCknTm/TzZeiM7CwHqS/LB
         b2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655525; x=1724260325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CvLg/jdd02raDyPuokVKWkE8Jw8u8gKV/oNxvgJVSos=;
        b=p5mghPGJxthedqqCkT/KEnSMA2I4ScmTWqQOG8Cs7BsmBaxrsyX7KcL/QhhT4C1xST
         6CMAhCc3AU+T1PS7tctBPD8xn/NojFhhAlnlQhqW75SHCpUWCSvBIxgb35cA/CmgwJF7
         mVAEY4OuF9tpFaY/shSrB/7KJDVbpJhj7FlK5l77qqS8qhIx70ZSNBrSWzbiQvcZeBGM
         nUODUJ7OnS7u9RAqCYAVIQEh85lldkR6lV18JqY9DHSCpgQubTga5ThiUK9EbpLXdidv
         WtGOMbpAC3SHuZmm4U85efIHbQ5J6nMlDpm1mP6Y0D/kKEyOYmiqkIIMcV7zHWfpiOPm
         nijA==
X-Forwarded-Encrypted: i=1; AJvYcCWSrE8HM9el7D/NkG6UcF7gb+IAwI1KXk3oCjMlRZUoVrv3RB3f/P6LEzGfLkypixZdJZ5tvPmeQIuMDXYSlk8VGAup
X-Gm-Message-State: AOJu0YyAiIGAi5VZCoMZlaqWzOUbYS054OiGU7ilO6vEJMR0lMzLfOAB
	sSi1ZHP84+NVS46Phj21OVQAbmj3CFcgLBjSzo1EiqnQ3TRmo41Q7XTpZAz9hqwHqPnDZ8op28f
	khuw=
X-Google-Smtp-Source: AGHT+IHGIxdu9HiDMdLgXFhSMaVLm1Yyxs1pb8uJgHbAk971dPiwaG4MNBvPtBe9hZnJ8+Wx2Z9WhA==
X-Received: by 2002:a17:903:2449:b0:1f6:e4ab:a1f4 with SMTP id d9443c01a7336-201d638d83cmr44171455ad.12.1723655525122;
        Wed, 14 Aug 2024 10:12:05 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1c8783sm31813895ad.245.2024.08.14.10.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:12:04 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 1/4] meson: hide tsan related warnings
Date: Wed, 14 Aug 2024 10:11:49 -0700
Message-Id: <20240814171152.575634-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
References: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building with gcc-12 -fsanitize=thread, gcc reports some
constructions not supported with tsan.
Found on debian stable.

qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
   36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
      |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---
 meson.build | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index c2a050b8443..899660ef020 100644
--- a/meson.build
+++ b/meson.build
@@ -499,7 +499,15 @@ if get_option('tsan')
                          prefix: '#include <sanitizer/tsan_interface.h>')
     error('Cannot enable TSAN due to missing fiber annotation interface')
   endif
-  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
+  tsan_warn_suppress = []
+  # gcc (>=11) will report constructions not supported by tsan:
+  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
+  # https://gcc.gnu.org/gcc-11/changes.html
+  # However, clang does not support this warning and this triggers an error.
+  if cc.has_argument('-Wno-tsan')
+    tsan_warn_suppress = ['-Wno-tsan']
+  endif
+  qemu_cflags = ['-fsanitize=thread'] + tsan_warn_suppress + qemu_cflags
   qemu_ldflags = ['-fsanitize=thread'] + qemu_ldflags
 endif
 
-- 
2.39.2


