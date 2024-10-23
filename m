Return-Path: <kvm+bounces-29486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C67CD9AC90B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 504C91F20F74
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1A11B4F04;
	Wed, 23 Oct 2024 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fRGqM80f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169A41AAE33
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683256; cv=none; b=YrZuddC2Fl72yAKTQzlsmtw7avttmkivOjssP/wG73B8wuJNJPYd9fagqER/IDB6ua0kQorIgUz7lv7p4gF7NDHOqK4lMcgSaEWtvTOqDNtmlU8MD1lKU4GlHyKR48RQGSDEBhhNsu4Rnef/WDlxBG5SPJDic/HXB+IqBTV6uZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683256; c=relaxed/simple;
	bh=rPqdeMZHjsIWZRK4nVVQap0ga9cDd7eG9O38cGJ5E8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+xeukeWW/JJx0fagX3jX/gPqiFctvlFMtPsXapi0FpEd6+ri9/EXII1vH2cNAj8odbHrZqNa5GGPYuOkGEUYow4g4YL+X2c0K7n8uAJZWBqxxlxLrUvj0594aPfSQKuGUQ+rvjfdYYbSApp5KzCG92sThCcKhu7FnwDZvSEkzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fRGqM80f; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c9709c9b0cso8749033a12.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683253; x=1730288053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=fRGqM80fc6dMIsc1MGECmY6NKgN7vfd+YUICLC//MWg+/KXXRA251W9HlVh9PVuJ4o
         6Woh6qpll14alAkQHbeu5YBhJBcU/MXsvsKJ5jXnbaPzz1xbHOhVwwkOJYgLDBUbLXdx
         GPCxC8vKPyPx80/HldiAnkUb/LduID3ik1RtXLMwb55c2TjXlv/X0ougoFkm1dqIMM2I
         3COUmTkA2w3QnL77qR3abgwtqlyElyrTvXDvGUpv9Y6W1BVnNVk2R2S8smewfyYkppuS
         +msGIgH4dZAKC6fQgSEj2G3QDVPMX3Mgofx8IXHgNCdVAxT+6RRI7uUT5U06dn2SemgT
         IWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683253; x=1730288053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=LkqlPFzeJaSHfHlHxOf+7e8DNpxoWbk9MSqBZpJHjiLWMKtBQ1iUKQztfkjzkaK09C
         trRd+CXmEf3QGXG9DQS5XZcf3CwSXWwkqyR/cGjEt7P+qwInkgW0l3m4AafY2hmTiQOg
         3D8UtBKAODqUKiAzGpE7ljjZLlHnTHqi/ZXybeWnjVdI4kTJrhWCVDmEczBt6PM5iL/z
         7Yd7q5U2YR9OOClZtLILqIxsd6ckR5vapDySDdPCYUKVQ6arsPTuFBNi2o+TOYzLtxcR
         PwR5X88GkayOv2eq9iX3ddvhW4jtxN9klIMXS1TW4aviieq3MI4vG2O4EKr+dl/od9qh
         +/Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWPVrp3EQKWHjKorGJWpiLAb7lZe6S3NizAaV3Nc5uPuaKHnOnR7tTUzDbE9QZPSqQL8is=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDBYby/p4Ra3PKKNLZda0Q1/LiV73QHQTzO19qP5Jca6mLe7zR
	ZS1MgIcPAon4vQTPDhltlDGUES9bZLPtkN0VM2FSMGGmFaK2DGhnkNRXMtMVeno=
X-Google-Smtp-Source: AGHT+IFA0UaPGC8xcZ4LXhrZOMA5j/aP5IXRqvhXDz6QfMISSlPCIVK4HHHGWxBkVlt2kvmppngmEw==
X-Received: by 2002:a05:6402:1955:b0:5cb:6718:7326 with SMTP id 4fb4d7f45d1cf-5cb8ad0734cmr1936187a12.21.1729683253220;
        Wed, 23 Oct 2024 04:34:13 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a654b9sm4351143a12.34.2024.10.23.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6C4CE5F913;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 05/18] docs/devel: update tsan build documentation
Date: Wed, 23 Oct 2024 12:33:53 +0100
Message-Id: <20241023113406.1284676-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
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


