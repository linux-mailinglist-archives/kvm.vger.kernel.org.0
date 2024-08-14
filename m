Return-Path: <kvm+bounces-24176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE1C9520BF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D720E1F22EA4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0572D1BC08A;
	Wed, 14 Aug 2024 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RbPXRaxP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4951BBBDB
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655531; cv=none; b=l3+YRFenDdIZRvZAPZ6xILMa/a0e6ZQwFe8fX9UxjH34m/uSI3ZbFjjITUNOvd4udNv5bOqPiqVCsj1dVadmUAWauEiXK0kdCAR74tXRfTsPH+tmwaZmDZX8xlckVMniUT8aXWD+cO93WRbsvDJeQlSHsW8Wh0/0ILA6EVbf1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655531; c=relaxed/simple;
	bh=Xy/vYvbIia42LSGQ8AdmhRp7Ex9zDATHON2Ep8y2hqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ddyYMP/ZrZGtZUao28BTsi00Rh+BKyfj9LCVbS5fZ0ak0sIsiiQfdVNWR43y4xjsPJ29V7rRMbpROU/FINS/LRLp0pNOJT20DjuJX/ckX1U8NQ84u8ikSnD8o2wDpcLb6vJAsZPO+J5yKjpHNsX9JCx3nLJ6ahKRkyUIN8Btm7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RbPXRaxP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc60c3ead4so885005ad.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723655529; x=1724260329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUn79WU14zqlH0c8ZH40FfQUSvZAWtp5MDwWi4t6xwQ=;
        b=RbPXRaxPW1W6JdcZxhrtDztvwfAsLb3ih+nZR3xY0vl5HycaU3lUjXZjtUbRwiCgdm
         OA6zodjGQOIR1U715RETEIvLg50UHObYfUQUI0pzh/asG364NVVYMH9YOHqAUN/ZdmxQ
         rCyRwsMqYDxYbCQWO7bFQ76Q36II8n9+nCm8iWWHngtdClR1y5thvbZzHn4C04LoHUX9
         UQsjMN8C1ExxI4QvQV68wrG3oEnmcVXJJh/d28sGHOPTbU+Mk6pZJTwwiIAyPYFXGUwp
         9QRdlnfiYLMGncBtyXMEgjoc4eLZYOmvILjRn9Mvt27fTtLmQk6UHghekO8/LLnSvSoH
         2Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655529; x=1724260329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cUn79WU14zqlH0c8ZH40FfQUSvZAWtp5MDwWi4t6xwQ=;
        b=rJ6nvhKfA1pyvJejetJE6yPOgFlVyYoUiFjShNIuzQN6tVuPWSmPYW7iBrCuTo01YV
         bavWUCeJ3gbW0g3GYsQd3toDEL2yj0ORInhjxDaDr7w/tQYX3xJjpIPIuC8+ieL8/vRB
         UST6oOcE3BDe6qkxvc12i51ElkI0dUFTwXn6QWEtImjTXU9wv7t9B9xymhmwpS3NriZq
         2NQ7UhItIdgCrQohf1HJpuC+x8NsIMk2/VEUepUwDSUYCaFraZdeUON/QiFXc5D/L662
         8y/x45oCHlCLbJNmiyvCHndHFatCxQAze+5MNBmS5QachciFsyEerS3yYuCXjfCi5Tfc
         Z6aw==
X-Forwarded-Encrypted: i=1; AJvYcCUgSRT0SYOsEZEEQ5dZWl83ksh89dRIu3snTxfPFphHGUg8uIafIj5f82qSf1M7gi2b7VkNsWlSha5l/EsIVBui0F6i
X-Gm-Message-State: AOJu0YwYUsVVPfdxGc5l5iF+D3lzamiM8zlaSMYFXLde/qRzTEmog8tz
	2cdSAR/Tv8p7H2rAiXon430lX29SO1MihSmq7GCz6uJPePhTy2bEyIx6GBF1AjI=
X-Google-Smtp-Source: AGHT+IF+qUN2vveY66Ij/WyYMf+GIVFkloNhj3V93djFOJp9OQYrH4QfFyL2zD6FZH+F77yZjz45FQ==
X-Received: by 2002:a17:903:11c8:b0:1ff:49c:1562 with SMTP id d9443c01a7336-201d64d8afcmr37992915ad.56.1723655528927;
        Wed, 14 Aug 2024 10:12:08 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1c8783sm31813895ad.245.2024.08.14.10.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:12:08 -0700 (PDT)
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
Subject: [PATCH 4/4] docs/devel: update tsan build documentation
Date: Wed, 14 Aug 2024 10:11:52 -0700
Message-Id: <20240814171152.575634-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
References: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mention it's now possible to build with gcc, instead of clang, and
explain how to build a sanitized glib version.
---
 docs/devel/testing.rst | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/docs/devel/testing.rst b/docs/devel/testing.rst
index af73d3d64fb..f10cfc3f786 100644
--- a/docs/devel/testing.rst
+++ b/docs/devel/testing.rst
@@ -634,20 +634,38 @@ Building and Testing with TSan
 It is possible to build and test with TSan, with a few additional steps.
 These steps are normally done automatically in the docker.
 
-There is a one time patch needed in clang-9 or clang-10 at this time:
+TSan is supported for clang and gcc.
+One particularity of sanitizers is that all the code, including shared objects
+dependencies, should be built with it.
+In the case of TSan, any synchronization primitive from glib (GMutex for
+instance) will not be recognized, and will lead to false positives.
+
+To build a tsan version of glib:
 
 .. code::
 
-  sed -i 's/^const/static const/g' \
-      /usr/lib/llvm-10/lib/clang/10.0.0/include/sanitizer/tsan_interface.h
+   $ git clone --depth=1 --branch=2.81.0 https://github.com/GNOME/glib.git
+   $ cd glib
+   $ CFLAGS="-O2 -g -fsanitize=thread" meson build
+   $ ninja -C build
 
 To configure the build for TSan:
 
 .. code::
 
-  ../configure --enable-tsan --cc=clang-10 --cxx=clang++-10 \
+  ../configure --enable-tsan \
                --disable-werror --extra-cflags="-O0"
 
+When executing qemu, don't forget to point to tsan glib:
+
+.. code::
+
+   $ glib_dir=/path/to/glib
+   $ export LD_LIBRARY_PATH=$glib_dir/build/gio:$glib_dir/build/glib:$glib_dir/build/gmodule:$glib_dir/build/gobject:$glib_dir/build/gthread
+   # check correct version is used
+   $ ldd build/qemu-x86_64 | grep glib
+   $ qemu-system-x86_64 ...
+
 The runtime behavior of TSAN is controlled by the TSAN_OPTIONS environment
 variable.
 
-- 
2.39.2


