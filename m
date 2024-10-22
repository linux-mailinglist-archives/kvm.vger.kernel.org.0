Return-Path: <kvm+bounces-29365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4E59AA092
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67011283A82
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8FD19C540;
	Tue, 22 Oct 2024 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ciMtWl7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B0819C579
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594585; cv=none; b=QX4DpNrKohe3H6LRgSY5hSHpduZBpmrUC1G+ddSNLGO1rNVDXrzIdYJy6lX3dZ56BLkE2ovAmnL3H1/eqVaS81uL/QflTwv8kVlux4TH2bUkmc7lZ6/VqOUegsAUf3z6FkabsX9ONE7472k3F8lZDGQ3zXT2FkZtkoZuGZe1svQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594585; c=relaxed/simple;
	bh=mp3Y+13HJt4aLaIDoWu1rAuu6usjzMXR6e+YoqULWZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jo9GFTtnim64d9t5mxTGaoPvF9yzIXWyF6k1X2wvNuh+/AHegbX+uV5R2k+ZmDkFBnz6/kT81LVVHPh34tyTwd2+uW0fIo+6yY7inB0ZJQDeHlWY1GiRLkKr8tkohMH7rtS83AZPFeNFTFJZQXb/zGmwc7ediSwpcZXsQE/1HPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ciMtWl7V; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c94861ee25so2818020a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594582; x=1730199382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/thHQrDD74xWhDO5ZvpNfmAfgwRl7ohsH8B1mB/WTo0=;
        b=ciMtWl7VOYEF32hagQEPQSWhbEF/72/waY54GT7SBVm0sGRgTrDp34wtWQrh1abXCc
         hX6fEAveHsQ9r7tZpnjnyuecEZrF6Ye6Cv053gYEXgMeemuPAa8UpC18PfAIYzU8lNoK
         znxNN9T6szDB7ftjNcbXHHXbkynIhl21osz14QxVpbudbAzvuZ2sMZi+tkaS2dbtHFJ3
         YjwocC5ZuMFVa2CPiqkHp/7kp5Jd1vFp76GKfHVcniLSKdZfMNu10KPyiJeZw8jgv8uU
         W0vzSkwFNS8rCdjy+m2NA4z5SmXHGl1BdB+KTQ6fzFhD/Pl2Pjq7hmHBbMBY2wdWRA2h
         eNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594582; x=1730199382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/thHQrDD74xWhDO5ZvpNfmAfgwRl7ohsH8B1mB/WTo0=;
        b=NmvIdZB/xOot71kxkmj2DFzEdrJMBuiUuiVtDPe/HmTm16dFI+hQwj7BLJ0w+FEoLI
         FFDDtsOl4z6cog3WB0YsyHGNjD3mB+rBwkmfW5z/tK1QF8BCCqhZdgvAYcWtQVBcOCVs
         VtQC0lBt5RwaU514aBhJJPjfFV3ESWC+3glsi0hKF4Wp0o49Weyv6DzFRxqoWRW3wWQE
         /OyaDdXvzrLKVhFFWhkpBRVrlgDIwpE7jQaASAdmYaZxuM6Ew4mUmXDDFWoILwey8gAu
         03XMT7iHEJgf3ZCxKRrt32IDZ8k4GI2E94SPZeKbQOSD/14FBjZUJlwvelIChJzFVDXn
         9ZQw==
X-Forwarded-Encrypted: i=1; AJvYcCWRI40aCeoeCH4rHaS99kt8jHirzHTnsL/1rx8NciuTfT1d7Or/7gpSxrng5LdhlZiucBY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzofb3Z8rEqk3IVvyffOMZfSEvRPpUn06EdyjuCzfEns2d9pq+s
	3VWSgKW6XDhZVyOUmdsjrym/cH9gy/ird9j+c8Yy4QeZG5NHpz5CwZAmvPP8IE4=
X-Google-Smtp-Source: AGHT+IFBxLhqkcFc083FyPJREjZC/bdX6TenkPZv3cJUb/crfFR4k5TS849WsfGhqyrMbpgpzkF9Rg==
X-Received: by 2002:a05:6402:909:b0:5c9:21aa:b145 with SMTP id 4fb4d7f45d1cf-5ca0af87099mr17318763a12.36.1729594582079;
        Tue, 22 Oct 2024 03:56:22 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c72581sm3010588a12.86.2024.10.22.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 86BD95F9EC;
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
Subject: [PATCH v2 10/20] gitlab: make check-[dco|patch] a little more verbose
Date: Tue, 22 Oct 2024 11:56:04 +0100
Message-Id: <20241022105614.839199-11-alex.bennee@linaro.org>
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

When git fails the rather terse backtrace only indicates it failed
without some useful context. Add some to make the log a little more
useful.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .gitlab-ci.d/check-dco.py   | 9 +++++----
 .gitlab-ci.d/check-patch.py | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/.gitlab-ci.d/check-dco.py b/.gitlab-ci.d/check-dco.py
index 632c8bcce8..d29c580d63 100755
--- a/.gitlab-ci.d/check-dco.py
+++ b/.gitlab-ci.d/check-dco.py
@@ -19,10 +19,11 @@
 reponame = os.path.basename(cwd)
 repourl = "https://gitlab.com/%s/%s.git" % (namespace, reponame)
 
-subprocess.check_call(["git", "remote", "add", "check-dco", repourl])
-subprocess.check_call(["git", "fetch", "check-dco", "master"],
-                      stdout=subprocess.DEVNULL,
-                      stderr=subprocess.DEVNULL)
+print(f"adding upstream git repo @ {repourl}")
+subprocess.run(["git", "remote", "add", "check-dco", repourl],
+               check=True, capture_output=True)
+subprocess.run(["git", "fetch", "check-dco", "master"],
+               check=True, capture_output=True)
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-dco/master", "HEAD"],
diff --git a/.gitlab-ci.d/check-patch.py b/.gitlab-ci.d/check-patch.py
index 39e2b403c9..94afdce555 100755
--- a/.gitlab-ci.d/check-patch.py
+++ b/.gitlab-ci.d/check-patch.py
@@ -19,13 +19,14 @@
 reponame = os.path.basename(cwd)
 repourl = "https://gitlab.com/%s/%s.git" % (namespace, reponame)
 
+print(f"adding upstream git repo @ {repourl}")
 # GitLab CI environment does not give us any direct info about the
 # base for the user's branch. We thus need to figure out a common
 # ancestor between the user's branch and current git master.
-subprocess.check_call(["git", "remote", "add", "check-patch", repourl])
-subprocess.check_call(["git", "fetch", "check-patch", "master"],
-                      stdout=subprocess.DEVNULL,
-                      stderr=subprocess.DEVNULL)
+subprocess.run(["git", "remote", "add", "check-patch", repourl],
+               check=True, capture_output=True)
+subprocess.run(["git", "fetch", "check-patch", "master"],
+               check=True, capture_output=True)
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-patch/master", "HEAD"],
-- 
2.39.5


