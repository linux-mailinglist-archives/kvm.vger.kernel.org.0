Return-Path: <kvm+bounces-29482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4779AC905
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD51F1F215F4
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0401ACDE8;
	Wed, 23 Oct 2024 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DJIRWssy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6A1AB6ED
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683254; cv=none; b=VH4tHI3l3DPC6RlYLIWbH1l4AFfHT8Zgybscb/ps3X3OiXZ8IkGu6vq2FWJoVHDDV/R8xeyOresd/+J75rdjWIqKS0nLAciOQk0OblAlzOrgg2mNnS/kvxJxL4VTpY4t/Lj+IibR/TjpMnCNcR+EPkokd/V8fr5xlzfsYXDnLWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683254; c=relaxed/simple;
	bh=FPDHoQuPMt65ENXagulYYLLxNsp02Qm7mdL6YjheHFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lvuv2Pze4GqsQp+ADGIUt/0Yf+FKzh3OJqCI8njU7TFTbOWawj44U++6dzcZ2+/DIEoi+7hII9f3yL90wKrePAyCr/BfsqvSxxDyX3yXGv2uokBZ11Qq2d9u2PePTy6P+dmX0jmStiOeHfV/lG2fCH3dM0N1oVhN1qlkkLZ+eMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DJIRWssy; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso969550966b.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683250; x=1730288050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRYAOn92MElnY+r7ZLHmtJJWBk1GGo3GQl/0Duq+UXc=;
        b=DJIRWssy3zTQp1JqsLrgNfkgD4mRkElqY/XLkyJa9qBJaR/ka4OEkwVBgUecB39vS6
         On4K7DiMJgOKXZp45mloJS1EIaxDmQRJnGtYiIcJaYI7IdvSahVOHKbyGEvnyJjGiKRE
         iygkC4t5pJhqyK7ce466CH4b47NBqqEk6TdyCBEBCdrQ1JiI1Yj8b+U+B2a1I3QIQrxC
         qrC/KPGtNmhwH3h852GFI/oX/2HI0uX/yEqJdUb1buhLppbrJm03emL4UFM5ypAjfbRq
         I9VvIUU+zKtY36nIPmSuDyp9FmOeZ7QwIRVglKdf8ILRB5WWxrAi7qXrzhmifkoeeFdr
         TCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683250; x=1730288050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRYAOn92MElnY+r7ZLHmtJJWBk1GGo3GQl/0Duq+UXc=;
        b=J/gtZCrVB21U/uAoJeMMETGCV2MQPuAwJO4cOkIkIVLKdrXNoogwdFw1nz4QbR7U14
         dp+p55Wq9adtFUdaDid/GUh9Myl9GluB4kL+Oi3W+UmzsVgWO2MtwtMqBJ7NJdiZ5EQe
         ojeZpTum2OpOq7nTkMKxoS2uE6eg/l+tIMPT0Tzn8Sa4ZEYQJgw0TMCHgbbGmV4KXTCy
         gL21WpVHqFeEjIPXXmFUFSkc4jbQ7SvHyutVjgshvObI9NIpC5pCd30au7ImhSe/sA8W
         LxK1jokcKGTcuw18CbyfzUvwOIO+Jo6w60p5rot8G6/oSLQcTx+AOgJMpo9FEC9P3sra
         ltNg==
X-Forwarded-Encrypted: i=1; AJvYcCX0vseU7kQqa8ZyOpUdj8HnPl1LxXfOJC4FZtjkWw81LJY/jovkLq3Oy5zM3hf3DQn9vVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6WIqwKXi9KFKIx9IrPp6TrNYZRAn2L808nh8PWubS1s5XEgVB
	SoNho3lPM491sGjsiIGqQhkCGo1I6MMbV0u6POZboIfcaFBCFJjrG3A3Kua5BBg=
X-Google-Smtp-Source: AGHT+IG9ed8D/XA3RQ+vEybFyxLY6xveuq9hk50ZZpmXX0BS0cBlAFS0roggteE+iw+87DvUNNlLRQ==
X-Received: by 2002:a17:907:7291:b0:a9a:9ab:6233 with SMTP id a640c23a62f3a-a9abf8a7feemr201487366b.34.1729683250497;
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d62e4sm461595266b.7.2024.10.23.04.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:07 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 283C55F8B5;
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
Subject: [PATCH v3 02/18] tests/docker: add NOFETCH env variable for testing
Date: Wed, 23 Oct 2024 12:33:50 +0100
Message-Id: <20241023113406.1284676-3-alex.bennee@linaro.org>
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

Testing non-auto built docker containers (i.e. custom built compilers)
is a bit fiddly as you couldn't continue a build with a previously
locally built container. While you can play games with REGISTRY its
simpler to allow a NOFETCH that will go through the cached build
process when you run the tests.

Message-Id: <20241022105614.839199-3-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
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


