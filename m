Return-Path: <kvm+bounces-24213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAFB9525E6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 925441C2150D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C037A14F136;
	Wed, 14 Aug 2024 22:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bIQNjZ4u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8033114D457
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675303; cv=none; b=XgWZk7eiUU+RwDJNnJSj8o+H+jabG6R4chg/L7FMWBxSlztbVCzvVuBc4V7jIOVUYdQlS/09K1E5U63XxUnUPfK/3IXQA9uQzFAX6StMN/hYrqATrbU+UAFgDxm7m646RL9+HyX0tCEwPl2ZGoK0NLVE5DpTNrNeBtVHCHf/h6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675303; c=relaxed/simple;
	bh=ykIn1kLLxwvSuVLDjaHFIirswR/aRePw/kLRAtdkwpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iP9lSrnTTANlIkxLTFqtuPLrE11sIOkKANuXXAT4BP8FKZ27ynxrx58yhdMRzv5vaQ7jGUqW4u2PU6e/UhgrcNNfG/oYt4ZisL2RyydRLmCEQd5jBis6zFHRUFq+0TH4dHFH+IFfpFLNjXKXnj0xhKwdwl0lSgleghTKi3k8ewE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bIQNjZ4u; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-201d6ac1426so3093065ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675301; x=1724280101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJho7r2KSIGZArJtcY0/tQGk0chbARupwvgFA11PnCQ=;
        b=bIQNjZ4u9VeqZ1paJO+/rSI1LTHX6ZwjaHYEWkiR8Z030ySU3VzkuQ+8Xov/UZk4oy
         b0DrIIK4rX6hzYg49MeYTaMsCkI1QPQpZHedmukThZbuhAa/paOxssoIqD7J3xVHttS8
         epAw2R6ykRo1mIFGA660ssNZo54Mj2r077QGxkbzzUd+oTMw7UuOx2SXvgB00DkRAoKl
         aaWi4jm92mC08aRhKtdpjgLcowyiwXcIhjkY/3L4A9VTNjNFfgk6ysupEx6fHjMf/c/Z
         96uBKeyHUfSa7fYgoxsRiRik/PixHOfwM1tFHlbc8qBiPxFg8Uu9lWL0utA6fQgH8GI1
         qUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675301; x=1724280101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJho7r2KSIGZArJtcY0/tQGk0chbARupwvgFA11PnCQ=;
        b=EDp0maPrWO4a7p8StXTnFsspUOrCDbVXge/H9/DO13IIVCFeaAUXGKu0JVDVFLvydW
         Gr8STeGTA8vhKaMFXcXnv5cYW3onTBYQnyYemkcWoEFwzsTD++c5kC5zFPaTCuF31z5W
         EkDVk4WDvu4xdM5PVSUDzP8Ki9EBmwnfS8g9Jy408/6qVUOXFXTRywmfmASgZAxRHIZg
         7SHCtVsp2MtAhzeqtFTkqbkuhgyY6nfsL+5MIEur/bY5xOUT/3Rc+egpmEkkDjuU3MXx
         EKTp0nQgIsQptaUBEwg+X2MrztQOr87bgU0ypqLala6i1J/dalyqvB0BB8pR1mIBG0xA
         Bw2g==
X-Forwarded-Encrypted: i=1; AJvYcCXpk+kgIyyznArIUQXPHfpPEpVfYYCwBlajCmSiQdYurfz79cWvE+lURiw+EoFQfFntgNJtbKLoVr0bPeHSI3X+B7u5
X-Gm-Message-State: AOJu0YwPHDGnw5mu8NjXl/5xbTFPKaa1i9P2K7TdKCPmPxanfLTcenB2
	XhS+Bg6jxPKdOlztGjpcHtrgFsonZTyou9wDAdmoDXNWQw3GkjzFuT5K/335CVs=
X-Google-Smtp-Source: AGHT+IHfpUHmltRgG/gVjytdo0w2YyJNJqcCukrC0Pgjx2S3EMn+ubfqhC4bAxsC2vTGIUfXWKdtyQ==
X-Received: by 2002:a17:903:11c8:b0:1ff:49c:1562 with SMTP id d9443c01a7336-201d64d8afcmr48133095ad.56.1723675300659;
        Wed, 14 Aug 2024 15:41:40 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03b2874sm1225595ad.308.2024.08.14.15.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:41:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 4/4] docs/devel: update tsan build documentation
Date: Wed, 14 Aug 2024 15:41:32 -0700
Message-Id: <20240814224132.897098-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mention it's now possible to build with gcc, instead of clang, and
explain how to build a sanitized glib version.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
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


