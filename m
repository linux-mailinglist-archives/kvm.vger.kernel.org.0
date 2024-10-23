Return-Path: <kvm+bounces-29485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 787FE9AC908
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34A53283A38
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB6F1AE01F;
	Wed, 23 Oct 2024 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GSl8wOXN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE7B1AC89A
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683256; cv=none; b=E9hb25i/zVHXoMfrZFtRMNRCrKWgNJasKht1pm1h1BNAxQ8yeodfJ9qBp2v3zynSJviNnJfj2TqqOIyreRBBey7JNwQzEDZIxZIcmTw9G61W4p/t3tLMW/iXEuLyHs4WfHHCtPkr/dT9loeJVUJYVZv0omuC8Ek+AKsRIk9evuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683256; c=relaxed/simple;
	bh=qgtwopJJcC6olDOCrmTZyC+pkSUAHmnAVccyfpTSh4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSXdQgtIgbyk5A9pNoEC63ZIduDm1GP7Z9otrAK8Dc2Zg4AJIm4Qy+L9jsYIvnrtkizjpPNWj6h3ipdL8SKIqK3p2HeXpS49qUXtazhFKJjYKT+s+UrRSV+HIQzG+oYczwl3aW6A9PBFKvKolCiH9akfRiAzzcIPBXvc30v+264=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GSl8wOXN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a850270e2so693626266b.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683253; x=1730288053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofWiMJKewV0PnnRBMLTuVVpoKKxPWtTmA16jFFUgpg0=;
        b=GSl8wOXN98kejlnV1Bta5OrZGJt4Tg/4cVJD5Tln58LQlI5skv0wpnkM5cxM63zu7M
         XuQFsJ8O0GlmUOq1Ios2Y5e16dvAmhxh0fFiIHbWT9+Zu0ut1Q0OcmZDAG3hVJz4eSje
         VWbVPcmtIJXY+Cw78V7bqt9tSIC0lzPsrO0dnMc8AwPuE72ZGNn1AkWLVJtw6zs7EYdj
         P/lc9XHpGNUbR+Hlwdqnlheg5eP5kNQtdmznbdO1ho4lsjN7FnOPq512ZE14SNHUEj89
         9G4/pkMA/De/xL94VsjIgdYQsGKwQV/Taz9CoQgHndQbNuJDrDRILAB6C8F+exxPwPz6
         FV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683253; x=1730288053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ofWiMJKewV0PnnRBMLTuVVpoKKxPWtTmA16jFFUgpg0=;
        b=A8aHjmj9/kLVOK/OAom91nvms6hjQ7ZemlpOub/8irzzQpPbT/ajKa6nRkYE0SbYPC
         EfAdhP6EMcRFo6X1IP2sAb3W8iHzJpqPwxgc9AE64nSCjkB2AQgQFyyW9U7Ov6RporsX
         eyFi0ARj7Mcm3DaiWF/2HN+G2lJo28WPPhtjj2e63GoE9kAGJEEourSbLkiXBzhW7zHc
         h+QzebSe0k7gHkdjN09R+fTv4Mv99w7ErBb9iknRlVIyM7Rom8m3oCOY4+SBozxKM7lt
         C/BjeH7GEGhYsK23W6LoY34mR8XOL1+Re/dQLe/GNUxacNvbeO/jzMNQuSVjZ7Z9sZaD
         mjGw==
X-Forwarded-Encrypted: i=1; AJvYcCWEm5DEO9PjIUowsjNSkj5j2ZkKOHrl2Hd5A2Pcjjg99iCSBCqpCR6apqXSv3QMpYYie9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyId74K5fQA9+tSRoaqLYoWeIyLkITmdzgwLZCjieoc6nkQavwO
	fCq8pTmb8RRzUVdJzI6pfnWGjg4c8ZDq9r6jkm7hn+k2ykoyUgqvFd6/01HKllo=
X-Google-Smtp-Source: AGHT+IH6LD8izGG0fQyfdgk338W7DLPNBs5ZUdS1p76Oj9fZr0LteRIITT1zzZ5ZY2DdWfnetXrtlA==
X-Received: by 2002:a17:907:7e97:b0:a99:e619:260e with SMTP id a640c23a62f3a-a9abf8acd51mr195736866b.28.1729683252885;
        Wed, 23 Oct 2024 04:34:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370744sm465054866b.131.2024.10.23.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E3FA95F9DD;
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
Subject: [PATCH v3 10/18] gitlab: make check-[dco|patch] a little more verbose
Date: Wed, 23 Oct 2024 12:33:58 +0100
Message-Id: <20241023113406.1284676-11-alex.bennee@linaro.org>
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

When git fails the rather terse backtrace only indicates it failed
without some useful context. Add some to make the log a little more
useful.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - keep check_call, just don't redirect stdout/err
---
 .gitlab-ci.d/check-dco.py   | 5 ++---
 .gitlab-ci.d/check-patch.py | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/.gitlab-ci.d/check-dco.py b/.gitlab-ci.d/check-dco.py
index 632c8bcce8..d221b16bd5 100755
--- a/.gitlab-ci.d/check-dco.py
+++ b/.gitlab-ci.d/check-dco.py
@@ -19,10 +19,9 @@
 reponame = os.path.basename(cwd)
 repourl = "https://gitlab.com/%s/%s.git" % (namespace, reponame)
 
+print(f"adding upstream git repo @ {repourl}")
 subprocess.check_call(["git", "remote", "add", "check-dco", repourl])
-subprocess.check_call(["git", "fetch", "check-dco", "master"],
-                      stdout=subprocess.DEVNULL,
-                      stderr=subprocess.DEVNULL)
+subprocess.check_call(["git", "fetch", "check-dco", "master"])
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-dco/master", "HEAD"],
diff --git a/.gitlab-ci.d/check-patch.py b/.gitlab-ci.d/check-patch.py
index 39e2b403c9..68c549a146 100755
--- a/.gitlab-ci.d/check-patch.py
+++ b/.gitlab-ci.d/check-patch.py
@@ -19,13 +19,12 @@
 reponame = os.path.basename(cwd)
 repourl = "https://gitlab.com/%s/%s.git" % (namespace, reponame)
 
+print(f"adding upstream git repo @ {repourl}")
 # GitLab CI environment does not give us any direct info about the
 # base for the user's branch. We thus need to figure out a common
 # ancestor between the user's branch and current git master.
 subprocess.check_call(["git", "remote", "add", "check-patch", repourl])
-subprocess.check_call(["git", "fetch", "check-patch", "master"],
-                      stdout=subprocess.DEVNULL,
-                      stderr=subprocess.DEVNULL)
+subprocess.check_call(["git", "fetch", "check-patch", "master"])
 
 ancestor = subprocess.check_output(["git", "merge-base",
                                     "check-patch/master", "HEAD"],
-- 
2.39.5


