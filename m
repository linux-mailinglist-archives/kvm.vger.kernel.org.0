Return-Path: <kvm+bounces-35941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1C7A16690
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BCD03AA3D5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206E5185924;
	Mon, 20 Jan 2025 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kFTVmkgw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C42770C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353603; cv=none; b=lydCIG/5CSJEvSJoZwwR9F5kd2HZJ7nJuHogdD6efFo/IidfPA9V8ae4IS1lqkSuPt/Pk366KGDY4Cv07fr03+MdPvVGI10hwrwwX3EvIBkae7XRhCLRTSOvzESsBChitHeziD95FNcU2FbUiIuZamefQ/f1eo3wJyI4jkk3mfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353603; c=relaxed/simple;
	bh=nBm5pU1gzAxoC2u1NtkzEOYzWlZNkb3YdQBF/KeGaho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EO/q1EWX3L+jJK2SW2jgudnuVkbVTmjtOTZWzs+W8AaepygPPYV5oLOQ2vFXekTuq735geWbK4n/wlvTQvbygL61ANP78jWUgL6PJOhcq2qigNpIJ3f3uRxWNbk24blF4bf5wzM+QqMpKk4h7RNxr4pDPiV0pGYl1eoeFO/UXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kFTVmkgw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4361e89b6daso27419435e9.3
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353598; x=1737958398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVL2az4j7grkf0qpeZ/bU6JW0afYQ4Cxffri4sj4Phk=;
        b=kFTVmkgwZ2QgUGCqpBOoiZ6D7YRBvDOVLAd3U6AOg2ppgDjPHIzs9QaGTCQ76emmk/
         cwLDnYrsfu8X2dBlYFIWfyb7TVq4yai56jI37LO8fQpr2oULuIa4vaa5rPIsBezANYzx
         sGvz6yiozOhDSk+Ou5rqp3ZWAg4wI9o0TKClBWprYQI5O4AT1e7lZf4g8c6l8PUzs4i4
         vzrE8vf1Dzj/QTNGAsq9uz2t5R16CUZNPfaQnB9RUPVDHzqiVR3cL90+k88v/VT6twV3
         Ht7O8XFTOrUHmYmMCwnDsiFMyYun0z7wZ1Gv0W3IWuGiCCFo9k+9kXi6VhVWNZVeQhX+
         gB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353598; x=1737958398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVL2az4j7grkf0qpeZ/bU6JW0afYQ4Cxffri4sj4Phk=;
        b=XyjQuK4JTD4qygkGZWZ11qp9Dd7VjrZr5HbgKS1dl3UrM/f6rzEi4RQ94fM2Cjodm7
         4TJtfqB4j99YtUCrkuehXiexbFrDyVA0UMxFDWxSd8k0J3dEzvf/D3K7AbcRRg5iG0sl
         X33t4FIQNyMxdRSmRfMkG7rvLIcoNnWeYXqdPR4FOusgRZQ1uXZFmbqwE5dkn/kT5SZC
         zFW9Ls6jGmzigafA5OeYIMZSoTqziicHcr9zwBqdCrd6DZlVWRLczH1YRSiGk5G2vQkh
         g3R0RWuGCa93gKMtedpNOO8pZSLEdBg+icFdITBKrTsMND8erIfOVunoKlg+1auM5kFL
         RIcA==
X-Forwarded-Encrypted: i=1; AJvYcCWXSFj8vKzie2sU5WO7J6SVhvftFCy19bGSUPX4GqqYsHA/ou5v3mRXRtZMuJvddhmMobw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0FYkvZY7mwv9/rjcH6HMGSfTGkLF5cGSyRXhs8No5Jh1T8Lds
	PaDt/OCwYR/CI7cdthFeM+Hg21gUx/ibTQp0Wt1IMtLSg4FX4QVmlUVsUnO7jQM=
X-Gm-Gg: ASbGnctUGZJeCSuTpw1xA0uokNfY/nnmuKckLs0HhmgGg3KBTuHYy8n+/kSmAfrZlP5
	walQKeYzHsmgyOW2lr0albwatpCg2aJAKxiQZap9iPU/6owA+NUel75b/SnY9m6ZmJ3gapr3iVz
	MvAHlFN5ehyJPrE0KFAl5aQL7/NmKn5zsfr+TRxtrt/bKD0WaIyH/NTtmnTPsGo54xaeOP8SGjd
	6Uc/rngHKJduQQ3c4Ohho3MoQ/ABTr9hihfLa0eKNJl7kWr08vn+KXsSLyX2v/B5ju0rqf6R04o
	TKhMUUyT/baAJI8NvSoLH7bbolcpDzl77HAXOGAHofdB
X-Google-Smtp-Source: AGHT+IElhXM/cZbYJG22wApGe0jXZ0HnvOE8NRrV4VhWeR5vhlK+q5cpTVUzAya0a0V/IceREZwvnA==
X-Received: by 2002:a05:600c:5486:b0:434:a10f:c3 with SMTP id 5b1f17b1804b1-438913cae48mr96975745e9.9.1737353598565;
        Sun, 19 Jan 2025 22:13:18 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499884sm189455365e9.5.2025.01.19.22.13.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:18 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 1/7] qemu/thread: Constify qemu_thread_get_affinity() 'thread' argument
Date: Mon, 20 Jan 2025 07:13:04 +0100
Message-ID: <20250120061310.81368-2-philmd@linaro.org>
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
 include/qemu/thread.h    | 4 ++--
 util/qemu-thread-posix.c | 4 ++--
 util/qemu-thread-win32.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/qemu/thread.h b/include/qemu/thread.h
index 7eba27a7049..d4f44241ef0 100644
--- a/include/qemu/thread.h
+++ b/include/qemu/thread.h
@@ -191,8 +191,8 @@ void qemu_thread_create(QemuThread *thread, const char *name,
                         void *arg, int mode);
 int qemu_thread_set_affinity(QemuThread *thread, unsigned long *host_cpus,
                              unsigned long nbits);
-int qemu_thread_get_affinity(QemuThread *thread, unsigned long **host_cpus,
-                             unsigned long *nbits);
+int qemu_thread_get_affinity(const QemuThread *thread,
+                             unsigned long **host_cpus, unsigned long *nbits);
 void *qemu_thread_join(QemuThread *thread);
 void qemu_thread_get_self(QemuThread *thread);
 bool qemu_thread_is_self(QemuThread *thread);
diff --git a/util/qemu-thread-posix.c b/util/qemu-thread-posix.c
index 6fff4162ac6..0fc3003ec46 100644
--- a/util/qemu-thread-posix.c
+++ b/util/qemu-thread-posix.c
@@ -617,8 +617,8 @@ int qemu_thread_set_affinity(QemuThread *thread, unsigned long *host_cpus,
 #endif
 }
 
-int qemu_thread_get_affinity(QemuThread *thread, unsigned long **host_cpus,
-                             unsigned long *nbits)
+int qemu_thread_get_affinity(const QemuThread *thread,
+                             unsigned long **host_cpus, unsigned long *nbits)
 {
 #if defined(CONFIG_PTHREAD_AFFINITY_NP)
     unsigned long tmpbits;
diff --git a/util/qemu-thread-win32.c b/util/qemu-thread-win32.c
index a7fe3cc345f..0d512c0188e 100644
--- a/util/qemu-thread-win32.c
+++ b/util/qemu-thread-win32.c
@@ -513,8 +513,8 @@ int qemu_thread_set_affinity(QemuThread *thread, unsigned long *host_cpus,
     return -ENOSYS;
 }
 
-int qemu_thread_get_affinity(QemuThread *thread, unsigned long **host_cpus,
-                             unsigned long *nbits)
+int qemu_thread_get_affinity(const QemuThread *thread,
+                             unsigned long **host_cpus, unsigned long *nbits)
 {
     return -ENOSYS;
 }
-- 
2.47.1


