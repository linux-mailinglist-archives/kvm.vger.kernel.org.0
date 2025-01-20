Return-Path: <kvm+bounces-35942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D961A16691
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C47AB169D5F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868CC176FB0;
	Mon, 20 Jan 2025 06:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrDVwYe6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA832770C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353606; cv=none; b=TdEPltj85cTwBOh0vJOHCo3mBHv27P+ZBkxPmee3eIFTiI0zq7y/j/4WrZvWG1Nv68DQ5c9aQ1BhUfzFVWjExcgTZm0ZVQD3gDaUQGEp/yqH3KCNNVqxw6+ZsGkYJJMNq3OC6qj7t+Hrx23VuKfUfRCBGnXe/CMa6tfysV3/Wjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353606; c=relaxed/simple;
	bh=yTWCY5k3QG3uCP8nBjEF23kcnm2Rje4eSnFKVIQtXLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVocDbL+qHtKyPWNu9g5Pqcweam3z6ZJPa/ZEpyEarYTFosb9oNXw3GleBTzJ5Ec/mzz0FSWgmWLPu1WnsfLKdIKre/5jzBUvn0sjQOBFOiWfm8glfONtIzG07Ff4giKLaGQDDdcZ+JRx3nyasrYkZNVHLjD5S+OaB+A3j/+ZVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UrDVwYe6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4361815b96cso27296865e9.1
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353603; x=1737958403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZ4bgqHK4U63ZyF21ovjhIWwkMXyj56njZ/a/NkbEaQ=;
        b=UrDVwYe6QvRqeXKIFCM86VbctT6IkdfktJ6ru/9F5BRF9QHRcSdWOJ1Nw6nXALK6rI
         LfTF8XHKgzusBZA1gfDkdhsEU53WoH1PZDO+vZc67bvMaLQo3/c1Q15XmSQMdRuAhAhj
         QVhysGIKgCuWJgHvT86N+xlERuF4g52nHqJb3Iot+bH18kw9cSUar2oOcDq4UcTZSdMV
         NnJ8CO6BZWRed2oDjM/ffW3Q4GHfdmyAOt1ALPHC1Y+p3sswwBv1xMl/d5KhYypflfCn
         4/+i1ShkdZBFsVaDKFL/UFEB1RZCHwSJBEUXBr1cQBed0Eh25fu9sQyOl943mVwDK9Wz
         tqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353603; x=1737958403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZ4bgqHK4U63ZyF21ovjhIWwkMXyj56njZ/a/NkbEaQ=;
        b=H58+Gwu2WRXcscjzkGHCjoX6XnxT5Lmc+gycTEZ97N6zqz4eGAJVI/7ez0PBreiDmC
         1GK748iMZwFMXPy7VT9p/GINCEkNfm6NksdUctr0l/qnLDu8A0uLzQgW8tye+z77Db3X
         mWmSNyVdfqLSbOf5Rjhza19PpRydIL41rOdvH0Fk8I7F+ASKuEyuiONf7cMmdv+eCnLu
         jswnPj4OnIjnognE4Q589gmciAlkNEnXKDZQIYuOf0YXJ3LCRQXnddboOE9braFut2j0
         WieZkb85AvuYhW17DWyuEDx9gU9zWADfpqmIsfe692Jo6TIzDZKW8Q9mok9uTie9PQxK
         lCxg==
X-Forwarded-Encrypted: i=1; AJvYcCX0x4fdFHrUgfsFnnSLv3YJO8jIWAkRDcv6qhueWUDrHaS9HcMp/xIPrGi3sLml5d4IlwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR3Ih1qqbx5hnwoOrx5VHEoHD6g/Vngy3BjLMiWCrICWv84IBt
	rRiEw00h9qvJns4O2+96Jbo8TZWcfs4Ff1KDc28Y5uzMah35D/IpiZhHbc8GM7k=
X-Gm-Gg: ASbGncsULEuB4CdUkE2xvGbTjjS3+qsgLgkykJX8ypiimZ5cZJaM/vE8dbHVq5yMVY3
	Bjdr+JjUZIT2MTdOgm4S2ivOneddbVcuPhpy9hjYI11GLv/uiJWYymWyGRi1D0eJSe8ZXjYMxR2
	Dt74jfpszn6GZnL+jMsuFMaPHTzPAVRCBij9qTsATCYVkyywx3ZwYqdrJGAa0ZW8dlzSGYQ0dUe
	dK3ZxRYu38YE+U9Y8LnieydL+DBLha0jyFTMqedsMM4EiSRLJXoBB6EnZpkMkD20QzkukfQ9g2b
	Bt2Du4A6crBJewuxql62ax/WsCLDp6T0x/PEFRc1CFM/
X-Google-Smtp-Source: AGHT+IHsLn5UQ2lGNTqaVfR9uW+ill/b230kCe9JxeG+TeBCDdW/xZDrF+sTByfZht58mwD8OlFP8Q==
X-Received: by 2002:a05:600c:1f10:b0:434:ff9d:a370 with SMTP id 5b1f17b1804b1-438912d1d49mr114113545e9.0.1737353603317;
        Sun, 19 Jan 2025 22:13:23 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499942sm185021665e9.6.2025.01.19.22.13.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:22 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 2/7] qemu/thread: Constify qemu_thread_is_self() argument
Date: Mon, 20 Jan 2025 07:13:05 +0100
Message-ID: <20250120061310.81368-3-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
References: <20250120061310.81368-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

QemuThread structure is not modified, only read.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/thread.h    | 2 +-
 util/qemu-thread-posix.c | 2 +-
 util/qemu-thread-win32.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/qemu/thread.h b/include/qemu/thread.h
index d4f44241ef0..d3027c843bc 100644
--- a/include/qemu/thread.h
+++ b/include/qemu/thread.h
@@ -195,7 +195,7 @@ int qemu_thread_get_affinity(const QemuThread *thread,
                              unsigned long **host_cpus, unsigned long *nbits);
 void *qemu_thread_join(QemuThread *thread);
 void qemu_thread_get_self(QemuThread *thread);
-bool qemu_thread_is_self(QemuThread *thread);
+bool qemu_thread_is_self(const QemuThread *thread);
 G_NORETURN void qemu_thread_exit(void *retval);
 void qemu_thread_naming(bool enable);
 
diff --git a/util/qemu-thread-posix.c b/util/qemu-thread-posix.c
index 0fc3003ec46..c85421f1a0f 100644
--- a/util/qemu-thread-posix.c
+++ b/util/qemu-thread-posix.c
@@ -664,7 +664,7 @@ void qemu_thread_get_self(QemuThread *thread)
     thread->thread = pthread_self();
 }
 
-bool qemu_thread_is_self(QemuThread *thread)
+bool qemu_thread_is_self(const QemuThread *thread)
 {
    return pthread_equal(pthread_self(), thread->thread);
 }
diff --git a/util/qemu-thread-win32.c b/util/qemu-thread-win32.c
index 0d512c0188e..08c6543fe51 100644
--- a/util/qemu-thread-win32.c
+++ b/util/qemu-thread-win32.c
@@ -546,7 +546,7 @@ HANDLE qemu_thread_get_handle(QemuThread *thread)
     return handle;
 }
 
-bool qemu_thread_is_self(QemuThread *thread)
+bool qemu_thread_is_self(const QemuThread *thread)
 {
     return GetCurrentThreadId() == thread->tid;
 }
-- 
2.47.1


