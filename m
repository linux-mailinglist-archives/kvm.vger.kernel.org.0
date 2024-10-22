Return-Path: <kvm+bounces-29369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EBA9AA096
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1A8228399B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892CA19AD93;
	Tue, 22 Oct 2024 10:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SRCPG0kJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CB919B3EE
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594591; cv=none; b=NjrJeOSWi2VLX5DdcauE549Aq2IT3giM4Jr6vuamvhMN7+/ZfRv+bvE2PzRUS2vz/i8IdqengfeCnhuUtANaBr3haG/f31HkkOrr2tWRXHsZCqpIz4D1esXK2XXJlRrs0cq8o9oKOOIIY9oVTMyth642r31AxkjMRl7uBfV2lrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594591; c=relaxed/simple;
	bh=rPqdeMZHjsIWZRK4nVVQap0ga9cDd7eG9O38cGJ5E8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDxPEczEnqPfSr/+Xx5VnggtlLmdJXv/LBMR/jRRtcxfPCWw+6+Sc8xveN4+Ma8JE28Y44zJ1LFinMo8c3ZpC07zjwvaimU6CQe15i6TPPC3aJTF3bfsk4WahzDHzc+NVvBe5wt+34PQ5k7Hu1BejtCap72I5PMHFZkON/t1aK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SRCPG0kJ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c99be0a4bbso7348970a12.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594588; x=1730199388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=SRCPG0kJ5yUPdkxvlfaBwiQqmM4qKllaw7vxOk7aRpWVt6wrofsfteFuSd9bYpvit7
         AESaeJY5p2tYoTpcfzXWUPhdr/LHgU3B7vV6A0TrORwSEbbSzpkn/dzVPnN5O7+cSqOu
         gHUaeTilGc/VaNgKkPJz3wboK+oG51P4W5T8HdhHKX4PAgDtLx1C39x3nSQ9tXrnO0dZ
         fLQ76e7P63pulEz9Mgoa6ZGd6eF5TfQeNT2mhz7MeAbsIQwt0zH2XpH22+98tMBV9m4l
         VhyInp5BM1iA+73qgvQBX1W6ZP8eR3KBE2eC+z6NEKwUbJUFMIOrTzqAL41kv9Qc11Ew
         ZFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594588; x=1730199388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZZo1oPZPqzjBeoixQ7wpptFRyTvJhgIff9wczeHXgQ=;
        b=dn13UmfwzceV15omYz6P5cz67tVE39i6ezEeay/uqU0CBUSyE89fEauewmN0Z6aXzu
         E1/5tUxuObTubYPfkxw+XbRoUP4CJM6p3cJbylIDMhH6cNxDPZiW+CigEyPQAHUZeton
         2GUp2SlFMFZcTh18QXkc2g+nQeJkhRQXc7ML8snQeJ8S8h0Jy22+wZMYQpDicC6FfzgT
         NMG4Chd9x7WowMHYLnZ80Cr/LV51E7UQ80teMlwrL9jt22dW5juUtgB6VonuYqsb5puU
         xO24fRdlLzy0R56+E2r56ePBjXj2I9IphGiYXzWyGZacwuj2PXoBmq4dnnsYvnxrv8sP
         4YPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ1fe7ZHEKhrjiDIINB4wNUrg+78T5TbAkHiO2RGgEIrTi2JNRI6cyw6VXaOuZMjHyIA0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg0cQWyzYJtDvF6jbt2QCFb7ntSsdLAelR//I/Ft+nPXc6YSsp
	wS+lbG4CFl3vfr4fdB6de93jFTPLFXwXuYB7oj38q2rk2lN2VTGzeJ2VZjv9pM8=
X-Google-Smtp-Source: AGHT+IFRsXwXWWZ+1iUXj/NDdR1zmIgl8xhujNIEkYhFmxY8XSoNScTyD+Rf8wUGR1kAm8G1SujWGA==
X-Received: by 2002:a05:6402:3514:b0:5cb:7594:9ece with SMTP id 4fb4d7f45d1cf-5cb782e16e2mr2678552a12.17.1729594588142;
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a657bcsm3124198a12.23.2024.10.22.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1AA775F925;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 05/20] docs/devel: update tsan build documentation
Date: Tue, 22 Oct 2024 11:55:59 +0100
Message-Id: <20241022105614.839199-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
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


