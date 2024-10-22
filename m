Return-Path: <kvm+bounces-29363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD129AA08F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17AE71C21EA4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12B419C57D;
	Tue, 22 Oct 2024 10:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FqBZ+GWQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170F19ABD5
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594583; cv=none; b=lscoHLfb0EIUohv1COj62plOlXLyz3OSSMSMeZ/S2SwNVfVlT5cgz4rgiPtIuPeHyu3qeGE2XDv90B2qK/jPp8/LWT9KFwOFUhREz6B+YUzQ95yOAhjj7slLqa8f29d1QwEP/xQ8R7WXerZT872ZENkfgxz0xsZHcw3pbC3hNmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594583; c=relaxed/simple;
	bh=aS2l+vmDfLF2uLItNIzgkZDSryR40qUXakZxJbkgV9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wj+3eRbk+Bc7y1VSKpXLDSxNyRykwz3DN+ZvZnDNcPk4QEDYPEdAX1CBxvnTGUxvqyJff4xin6gl2Y4O8jUuH463JJrHxwm5gra1dZoJV07XvUg7T4jWES47fMQ6wCRMvHj4+mtcOGvH7GrY/O9AapnFij3mauYKGlsEvKaNT8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FqBZ+GWQ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c99be0a4bbso7348791a12.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594580; x=1730199380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfxPswSzpy5PJY7wIfJ4Znven71oBCSA3p2JUb9OqOg=;
        b=FqBZ+GWQvug7iZSPtu+eRwtit9ZFbQ6GAnVhkiAzvmI1cbOZ84YttoaDwashOVNkyc
         B6g2eGIrs4yvOeIS52d9sDxsSbZgrv4shKSl3OyrF8Vy6Hha/SXCRhdY/0Yt8pZl9UQn
         aF8YaQNJptbgCy52iMJPkbA0HQKMb0ny9VPMjZKGhVzIhFElfORMua2bi7VrxD+0f/cU
         HUGFDaRW+uEQcVktWRSHDc5mfNHE1LeR0PLVCoUTV9CM5KFOgHde4QaMITguWcxky/sE
         sDVcW2cu/XoJNwn5T6MZCkWsqHPnv5q5uGXtVBQhAETMzN58YAWxfQPWRFvFqWNnYcDT
         Z3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594580; x=1730199380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LfxPswSzpy5PJY7wIfJ4Znven71oBCSA3p2JUb9OqOg=;
        b=pz4znYn5MjWjbfgFCug0iFXgLpAIvWH6IQeDmomzo/mrYRQ3hHW5f2MMfKiqVTudr0
         uEsgq7LJn4n+Mxs8yNv36avZ9pEcIHA2i0905Ec7HDyk/WKpj5RyBYqF4Ea5dmm2jAKD
         DdTdRYOCQWbSRIlFWRcc4K3dQNafitZ+p37AzpNkxwz5fv5dFCeZtLenuAnjzUJneiHQ
         AmUaXHw8SsjBe6BRWRM2rYGr0fTzV4fxOxoaqRc5JoVjBnPxIXjko5XOMfVDrahBVVIr
         zW2Y8uIrlRKudP3Zi0mHbtGZpwsOmr7cf3ixcqUbBbwhQ/LXJHs0yPyAd3bkjf7tiLZ2
         005Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnt3SIuz14iUf2/JiGc6V4QnZFN3ULNtWK+GZgoMsefK1M+h0bpLxxlf6b6WSEX5qMVTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxviJwlVjhqTtYffLL2+2iCdGFxBJJkiBUcg3NOw89V6OniITLy
	V2vZyDlCre78yZRtLtzI83inY8mmegj6WytKWkQhzjhM4vdLxXoO9xjOZKb9Xds=
X-Google-Smtp-Source: AGHT+IEWTHq0nZKsD5+vd+nTSltz6qRpJ8m1ZUA3e2J9fRXNb4Q6Dz/tYps28BHQ7v9MYQ4wj/pQ1w==
X-Received: by 2002:a05:6402:1d49:b0:5c9:57bd:e9d with SMTP id 4fb4d7f45d1cf-5cb782f9e3fmr2351410a12.19.1729594579617;
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c7262bsm2981150a12.82.2024.10.22.03.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:15 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D35445F8CC;
	Tue, 22 Oct 2024 11:56:14 +0100 (BST)
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
Subject: [PATCH v2 02/20] tests/docker: add NOFETCH env variable for testing
Date: Tue, 22 Oct 2024 11:55:56 +0100
Message-Id: <20241022105614.839199-3-alex.bennee@linaro.org>
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

Testing non-auto built docker containers (i.e. custom built compilers)
is a bit fiddly as you couldn't continue a build with a previously
locally built container. While you can play games with REGISTRY its
simpler to allow a NOFETCH that will go through the cached build
process when you run the tests.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/docker/Makefile.include | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/docker/Makefile.include b/tests/docker/Makefile.include
index 681feae744..fead7d3abe 100644
--- a/tests/docker/Makefile.include
+++ b/tests/docker/Makefile.include
@@ -92,10 +92,10 @@ endif
 docker-image-alpine: NOUSER=1
 
 debian-toolchain-run = \
-	$(if $(NOCACHE), 						\
+	$(if $(NOCACHE)$(NOFETCH),					\
 		$(call quiet-command,					\
 			$(DOCKER_SCRIPT) build -t qemu/$1 -f $< 	\
-			$(if $V,,--quiet) --no-cache 			\
+			$(if $V,,--quiet) $(if $(NOCACHE),--no-cache)	\
 			--registry $(DOCKER_REGISTRY) --extra-files	\
 			$(DOCKER_FILES_DIR)/$1.d/build-toolchain.sh,	\
 			"BUILD", $1),				        \
@@ -177,6 +177,7 @@ docker:
 	@echo '    NETWORK=$$BACKEND     Enable virtual network interface with $$BACKEND.'
 	@echo '    NOUSER=1             Define to disable adding current user to containers passwd.'
 	@echo '    NOCACHE=1            Ignore cache when build images.'
+	@echo '    NOFETCH=1            Do not fetch from the registry.'
 	@echo '    EXECUTABLE=<path>    Include executable in image.'
 	@echo '    EXTRA_FILES="<path> [... <path>]"'
 	@echo '                         Include extra files in image.'
-- 
2.39.5


