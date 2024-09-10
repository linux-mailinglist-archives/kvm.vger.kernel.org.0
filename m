Return-Path: <kvm+bounces-26329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7B09740EC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A784B29A77
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EB81A707E;
	Tue, 10 Sep 2024 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hzw+1jp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5D419E7E0
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990025; cv=none; b=Z0vxfU1VIp6/YBlUJ7+YyaS4GQxn0uipHXKAS2gsVkfg6ciUNYlDB49ar0PEmyOVv1bWsyEWHzspEas6fxnCvKgwQkOITI2rav8qGUzhYceeFoxzUtXq25gWVil1BCuWXUC3g69aCNyARzNun53pFC/ZcBIdqx+GQa+CxN1Ep7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990025; c=relaxed/simple;
	bh=aA0WW/1yWrYVllqWDzAQlSXu/FtRYFRaq8LhdH9+qFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rc8l+pHS90mw7NP8gqtkiGYH4iNlhOZy3C+KIzG7SZPDWmQhsNR+UnuvOxqgwlCm03oStsAHu4TLWnhPT+KXWZFiE8GmFJ0mlywy4DpA7sf9b/20dIArVecfEOsUBK4C//b89MY8nYdPoZ0Cz8nHfiEqTPMX5DiuY+PssgPd5cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hzw+1jp7; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d877dab61fso3776543a91.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725990023; x=1726594823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Z1RdXPVj5atb8+PpKq/fmgLYxIn7PDouvny9pPcuV8=;
        b=Hzw+1jp7uFYjmT1UaldW59xGVG1IN4P1iruy1yY3h66daXa+iswddJ4J60/t4aw9t1
         dvcFkqcJpWXkh+1UHy8t5PoM4zIhGnxSubpAtjOoSyJC4HhJT6IPLTTIzcMQkgpUYtPX
         P5J2q6uW0f5Ymz4yt/vcYMEmKxpMnwtkIXI2Js3gqGHAtB8s2DDDGNARpPW1Chk/SRmJ
         1AXVgdp+BIWqxbDHeIkHrXQIs8T6zXkji/rdH5SJ+mkAC8mDylvb2wMbk/Dnz+HT0lHi
         uulN1y7v72QR7hJiqJ8tKmx1DNb6bqSNGuWXyr/ZSaXWnDZcMby54YbWc4jkFZWVc5mJ
         74xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990023; x=1726594823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Z1RdXPVj5atb8+PpKq/fmgLYxIn7PDouvny9pPcuV8=;
        b=bn4ZdtmPKOkQjO08AxwH9Ib3FTHuWFaB5JcAqeh4YzJekvs1o3HpJeVTESAUuyaAnJ
         CF9IdW4O+pzNi7bN872K2bo6t90CZtFLjzs3ILdRQTJnwyldE9bsE4kCRk//DFdP7TSu
         QZrQ7MltoerMZLyAdW2VKATh+Sx1dAwFvNXvSddSdL0vrsr8Fvq0wkC1ZsZX8rsSIfoI
         YswT9FQuTimZr4MijdaeqPPCDxGNQlWbisGIp1HLM1J01RRhFoX+OUTo9Yh4lzGuyRe2
         /0rjU3PPCNh8vCrxzpyevC56KOxuPNwn6YIsRr/HByy7H8W0fqzjZnWap/n9eP8a3JWN
         VqxQ==
X-Forwarded-Encrypted: i=1; AJvYcCURA6bzj1KapJdksCoQiS1EegZKGdaFvak8XNQGB4Pjn1sFyiY7i66KQmv7SHpvfIAfVnI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0nmaMn0myJN89dYmJLU1I7Ye8+5EZDUM91syrKRt6XH4hjn6e
	tSzHsaNVdNlzNQHxv+rprUAp9/oqMJv4MQe2E56Tpc4TAkt62D4qs0DOI7I+mC4=
X-Google-Smtp-Source: AGHT+IG6zIVst4fam3ycj2QQzyd81h1e4xxXf0bTor2s5c8iE8a6MWU0szq+VZSbcxp0XJSKGVESRA==
X-Received: by 2002:a17:90a:3f8b:b0:2d8:ee39:47d with SMTP id 98e67ed59e1d1-2dad4efe336mr14872686a91.2.1725990022993;
        Tue, 10 Sep 2024 10:40:22 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db04966d3asm6682751a91.38.2024.09.10.10.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 10:40:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-s390x@nongnu.org,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 1/3] meson: hide tsan related warnings
Date: Tue, 10 Sep 2024 10:40:11 -0700
Message-Id: <20240910174013.1433331-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 meson.build | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index fbda17c987e..8a587bd52cc 100644
--- a/meson.build
+++ b/meson.build
@@ -504,7 +504,15 @@ if get_option('tsan')
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


