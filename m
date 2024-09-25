Return-Path: <kvm+bounces-27471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43316986558
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97EC7282291
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4F55476B;
	Wed, 25 Sep 2024 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VO17VUNc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A4217BB4
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284305; cv=none; b=C2wgnQaLLLKSeen6Vej6TzfzvxvDSL1UewI4CiAz/NQ2pSfZA0yYKeh1VzRhSFmK8fGDgzTtvyCXZppxuGDKvbUcALY4MeYsCLwBcx4M5e9Z1uGR8JI50Zj4IYk5uWGeXUs0+FFj+ISdXnOYQvQnIKO0OCBR5wDphTVEDxVOtwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284305; c=relaxed/simple;
	bh=aS2l+vmDfLF2uLItNIzgkZDSryR40qUXakZxJbkgV9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3+PUoTpUvE/L3gazXzCd/xgfo1W1WQIcvThfRliS3I3z7vAOIukh1DbOz6K5Wk2ztAvwL2a2kLXWSGAMRa60LHQKM5VLGORWcp+qVViWHMSrZQVs9QjVBVYcHF/8Tt0yjC8CXjA2yxhaxB3fomaUMxSdBERQ6k/iPi+2n5uWzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VO17VUNc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42cb60aff1eso235685e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284302; x=1727889102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfxPswSzpy5PJY7wIfJ4Znven71oBCSA3p2JUb9OqOg=;
        b=VO17VUNcgMzvb8c4i2t/HnDfOc7GKe9crW0ZjqHmX+uKDOpQyoSnYLckX/SXoIQg1m
         m8svMDM26+h5xpD7IlBQJDC8LHe0zU5DV8L+uqChDeN0Sp/aLLNw93FRsAYzWAY4Qg9Q
         esDtW2cYw9sh2+mmg5TFgDH+9rQIl51iZyxt6ScKGZChxusfLNAUkSNQ3sf3mOf/jLHt
         lNqWtY2b5xbEdNfk1tJdzuOTiMPAYaI4H4vRFSNTN762AhiB4lW6Lzhk0riMBKNT5nBV
         5bONQiBlvXoKNdB1bGOT7nqCdgss/m53Dl/xrs8rELj12q7xrPTXW8o4vrmenMufz2oY
         VDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284302; x=1727889102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LfxPswSzpy5PJY7wIfJ4Znven71oBCSA3p2JUb9OqOg=;
        b=ajI+U2hH62VX7GkJYg/VjXk4mEC5nv1JW0YbXXyrks3b+aD2f3Ha2PFKStFxaqdxVe
         LjJprqa9B5afgqjZuJt3vWJmgLSoHdsN86YqU+6I5C4L2rXoBieBqsRUGsnM1jIpGVeC
         Z6EK1uSX57nhSg7uyJsnXsBpJKunrCFCwuPe9Ct69VCB4HCU1iV3OFevXSlE+AbTV5m1
         v3cnysj+9utGeFOOszi2UCd3RNsZMVr6B5F+VP32tYHF2p+hcSHmZV0kUsnc3fgmcDtt
         Pt/wJ3+rFiXqJ91aSV5hwMXEs4FB7d0elHP77hwxKtcuE9C0aQjlQWGRyQbSovMlvbvg
         Isaw==
X-Forwarded-Encrypted: i=1; AJvYcCULjaxp9HJ9Bfn/CUFQZfcayP3IqF1/CvBw5BRomp2KsEFklx5vU2rTXPXqcuuFqTk1y1k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsz7HD7wuLuMTiQ9QUBtGbD1pDOYdtkRa0hp8/LfraQiYeEMTk
	tl8+sboITLIpHa5zYmZ90o6Cjl+hRXf9NrqXBcDvb3+0acRNNHR3UsR1+SlQOLE=
X-Google-Smtp-Source: AGHT+IHV5SzRp2SHf6HbaLc2hBK/7UiOfq+WQLl5ES6CuTB3Awe3uqUh07rnjOOYTKUVx2htHojcQw==
X-Received: by 2002:a05:600c:3b18:b0:426:5fe1:ec7a with SMTP id 5b1f17b1804b1-42e96242e81mr22084905e9.31.1727284301933;
        Wed, 25 Sep 2024 10:11:41 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2a8a8fsm4443984f8f.15.2024.09.25.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:41 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9DF1C5F94F;
	Wed, 25 Sep 2024 18:11:40 +0100 (BST)
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
Subject: [PATCH 03/10] tests/docker: add NOFETCH env variable for testing
Date: Wed, 25 Sep 2024 18:11:33 +0100
Message-Id: <20240925171140.1307033-4-alex.bennee@linaro.org>
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


