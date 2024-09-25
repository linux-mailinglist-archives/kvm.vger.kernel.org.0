Return-Path: <kvm+bounces-27481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B9D986562
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25729289B71
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F4A13CA9C;
	Wed, 25 Sep 2024 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JYwKNOCS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729B13B5AF
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284314; cv=none; b=lvDYpU5K95z04ICJeIdQ56O4dBGqYIBRNavj4gAFKYRlB29JjMAJMUIAseXmCe0S3k358sDsrAuUrfirTY5kMmo+VCgirhMtBqwuONQlyYxgp1JVe5fVz/N/Elwov0+1J/oXUtQGWBAhMXU7wdkz4YHIg2SMRCZFX2knz+cyg0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284314; c=relaxed/simple;
	bh=rPqdeMZHjsIWZRK4nVVQap0ga9cDd7eG9O38cGJ5E8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=My97xwci0O0r9nmGNxGXiOfql0G0QiaeveTOndGPL9PC2cdI2omAQwwfmfasObEhl7CS8bdJC7416CxwcoyM7TFFkoDX8BKl9YqVMJK1hzcaAu7rjw0XuNFtok5pUqBeLIuQWYLUFksqNHGE1rOlU6t/1sG39BpZ6F7e5KiPcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JYwKNOCS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42cbe624c59so137725e9.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284311; x=1727889111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=JYwKNOCSqjfhEutUz0FnhXlUBEElYxDIpTT/qGJfF2pWQsGT0rOZiiS7dMgbtOZ5Qn
         v/rrkTabiITvodbTzYccFzZce9m5izkq3iVm5oQ6jNYzZl0CwLVmhzgCiNSaaOkcUGPF
         Gi/UpU3LLgG2rz4uUvI+T5hdGRlW5qavGmxbHw23DAJ5tjejuvVVvV8QP+tOmQZ32IYM
         AmJ8kwLk8d6GhV5QvjlyoJfnb5ZkDv9OKuZEU9kAyv/XAqao1bO3c79ObROSTFjp9Atj
         lisFrFmB0Y9B+99vJ/DskF+zDXhM0PCISDEI5nMzOWvQkwmL8s9/m28cw/JUAfHOoQb7
         Cw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284311; x=1727889111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=K88LzDdcO3fOhkB0/52/1Y4exEh+Rq+jffoSHDMWCK5AJYcj7lqq2W4z7XexEChWNg
         XCHwBZE8nO0pr4zxx9gWFTtALfKkk/oBjFLeYLMJq13rcUGzWSHE+16TC+vjWDRE08eT
         AXazsMvQ/D/4qW67O4KmAsI0uVdGGHRjxz6yzOHu24Ls0f9Uxu52DUHaqWG0ceU2QODw
         2Mor+ZpQLXekgi9Ydoz74MMf7r/ddcr5xEswrQZ4cu/JZ8jEZHAqs4wsgSiFQQwXFLFV
         V12yyeOgzhathB9errNIlc0KtWK9YRtN4cIEL7NUAc6W6jJlIvqcezereuuw7ImOsYJ3
         4u2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVSJpMpQby7/8Z3YzfXLr69bXoaQ0ObjE8p4fYhFbsRJl4LyGM//A0rEhkpJpkVYSCa8fM=@vger.kernel.org
X-Gm-Message-State: AOJu0YykfDejG17qp8Efod8lJF19MudzOW/G5fnO2nAeVBl57lD290nh
	DTYcwo4oTUzg3725NPCQ3ZG8IbyB1CM1bkZLa931kumKuhkMyQht7gmK9tLPRLo=
X-Google-Smtp-Source: AGHT+IFF+UGt9GzWgAvvLZ7Qs1yQKbnDMQ6FQT6ids8iYDWVRm/vi2jxBGcUDOaNTjhDnY7/U8c6BQ==
X-Received: by 2002:a05:600c:468b:b0:42c:c401:6d8b with SMTP id 5b1f17b1804b1-42e96103b5emr22700045e9.7.1727284311162;
        Wed, 25 Sep 2024 10:11:51 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a36287sm24053595e9.29.2024.09.25.10.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 05F675FA4B;
	Wed, 25 Sep 2024 18:11:41 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	devel@lists.libvirt.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH 07/10] docs/devel: update tsan build documentation
Date: Wed, 25 Sep 2024 18:11:37 +0100
Message-Id: <20240925171140.1307033-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Mention it's now possible to build with gcc, instead of clang, and
explain how to build a sanitized glib version.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20240910174013.1433331-4-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 docs/devel/testing/main.rst | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/docs/devel/testing/main.rst b/docs/devel/testing/main.rst
index 09725e8ea9..91f4dc61fb 100644
--- a/docs/devel/testing/main.rst
+++ b/docs/devel/testing/main.rst
@@ -628,20 +628,38 @@ Building and Testing with TSan
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
2.39.5


