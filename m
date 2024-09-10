Return-Path: <kvm+bounces-26331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A719740DD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 172EF1C24D9F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777641A76C3;
	Tue, 10 Sep 2024 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dfSfqdxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE691A707C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990027; cv=none; b=BWdTAiolEfOPTpES0okZ3ZY83NIpKbChwLuK7t7ePUeLKo+DgZz83U8q43CB0/PEHk9ismpwBDxl8NOa3X0Qt9oeQQ58o2tctV7uCTBuQGyXy+45GlCCTjZ7YoPslVa4rglTHQpRWgx/nPEyH5EBVxofw1KIhy1aJOD1DGPySjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990027; c=relaxed/simple;
	bh=ttAsv3D6Iwp9QivWIaLu03Xlt9EFoz/vJPFHC4td/f8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ee0PoJIovqNrkgIvFdJy0URBVajqSqgUr2ti2mFvqsEDvzV3ee03C3lZpFwtHllC8KvcogIRwBEbDQCc1MZUzD2gngmAOoC87YrwV7IRYV/Laxhjo+yDqGYteoxaLVgcd+eI7cznSFy3UQwVyXBeYiOUCPZJAizrHso831XwBhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dfSfqdxA; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so850187a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725990025; x=1726594825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlCj2ixhxM/epvOBESU4I3HZLS9l35ap6tDyuxDs4dc=;
        b=dfSfqdxAku0B+p8GpK2DNFlHKbEgfd0G7htyiDgv3T8t4m1N2slwU3U8S3H06fTG+Q
         NmjhlRGRwuJv7DyvOK9l26tAwYpC/UhvqRDfzSTYKUL6DDFf8ATWV+iuneopeWlj0c4B
         hMTBFXO8Zt3HTnI3ZyLkL85m+Bl+WZm9DqwaPjRQOiyXA/kbS+m+GeZRO+gRfVcXG63i
         KerM5Ft5B5rQGXYTJTbHn9ZfIzeiqa49Dn+c7D/bUC3F+CLQ+oAO+4NVaTjL/yG7m+dU
         IhYyZjQJ9xIxU0CRGRgYQAlGZpa0VedF3uCx3ilQQ5LbLlOfMWi109E0RN8uRgbLQaAE
         McTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725990025; x=1726594825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IlCj2ixhxM/epvOBESU4I3HZLS9l35ap6tDyuxDs4dc=;
        b=b5peYdr1xvMo5W3bWJhDhbdo2JIpD9AsjlPyZG9uy2o2yMMppob9hzXZRt8Ao57mge
         tc3umbp4Re7zaQEpSH/uCiiJ34ZxG8bueACx96RSHpIm6pPegFwwMfQ7XmY11p/JZzTB
         O6ctyO3yUQ/1ZpowdJUDdQArmONr/nju+sDRPtf5lz5CYBRiNePGkfBof0q55ZpJWnXi
         I5Mx93eMupCjn1BX2WqK53eaISGWYGytvYyuPc2RDVa6Ysg4Wq9fBPGYe/fZaoQBfctF
         tRpgAAYGDq/OonnbrZncSBRjnJhqIXX+rkfS7k4xmAP06qTe49JPFbOiNe6GH5nwFsNE
         UcqA==
X-Forwarded-Encrypted: i=1; AJvYcCVXppf5Xt+s/zdt17KUdmE+sQWgAZJT4kyNy9t0Ro5foVTV7NGCHnRbK6Dx7dAFaZs3CSw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoDWOkvcIEwGIDE2A+lviWjNHed9MdlK5gM4yGLwjOEjkei28O
	GiPnGSX9ExxFnld6EK5FBWol+ZUVUqlpGFrZ2Yu2LFwxIOko2ACs8nJPuhFENr4=
X-Google-Smtp-Source: AGHT+IEDoWGBv7ts4eAbU+3GWSnN9KnHavnhQ7oMRWijIdyG4R93doDvhi7Ldov7owH5gTg/MhEDzw==
X-Received: by 2002:a17:90a:4d81:b0:2d8:5b9f:75ab with SMTP id 98e67ed59e1d1-2db830582dfmr361931a91.29.1725990025406;
        Tue, 10 Sep 2024 10:40:25 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db04966d3asm6682751a91.38.2024.09.10.10.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 10:40:25 -0700 (PDT)
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
Subject: [PATCH v3 3/3] docs/devel: update tsan build documentation
Date: Tue, 10 Sep 2024 10:40:13 -0700
Message-Id: <20240910174013.1433331-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
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
 docs/devel/testing/main.rst | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/docs/devel/testing/main.rst b/docs/devel/testing/main.rst
index e9921a4b10a..2e57390d990 100644
--- a/docs/devel/testing/main.rst
+++ b/docs/devel/testing/main.rst
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


