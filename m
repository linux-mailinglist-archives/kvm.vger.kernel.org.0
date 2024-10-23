Return-Path: <kvm+bounces-29484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3649AC907
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ACC11F20F44
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C801AE017;
	Wed, 23 Oct 2024 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ftPanHCt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8781AC885
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683256; cv=none; b=NnaaXc+4jVtO63SZ2bno9eXqEyG4rdfNokfgCr6kbjguBoNjY0WupnHYyIEkSSvCBa8Eqy9zHulwg1/z2lwVOIQdjMBN/MR+yJBSI1CpEbQ/geMaKGvFtBO+AZ2nkDwz+ERfQZFfvbEAJjr2hd6z8btTZ8qSfevD5gTX8KO5I9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683256; c=relaxed/simple;
	bh=od+F5J8tr7tzJhSZj6WjI5rrEwFyDywA1WQXm44ZMVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKbpU2uX2Ry5sstalQk4Db+PaHI4e5JT91V8Bd+ld1m8ZoeVzEoWiS1Dl7U6JRYahFDpSsXuswqaHKfFIuKMjSH8m+hhANgTdOLuC1ijZrHdYLu+D7BqA0WxLab5AvQFXPAdpEdvce44r0Sel81jp6ZbSfZ+uA+dsEeYvDEpbXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ftPanHCt; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a628b68a7so874621666b.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683252; x=1730288052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc/d/VIiG49L+/d6qxDj8y/ZsZGo0rIznhJwT5hb3KQ=;
        b=ftPanHCt9JFVCDASxv4e5EvPlnjSB72CFEkn61P/aNb6/orJicOOCr3+4K0m5b7poF
         YiHv8pch8yc6Ur0yG1CnpFX6AtASSDwq1M4ULycKqlJJJM3t4UfGJxSLPJCndV5sylVb
         eTB7etFvlMllXdNDoho3FVwPPE+aCk13UidMgBpGfBn/EGocP5fcbUX2LGVHaX1IkDBp
         rxu7SSaSuH5WZQhar/yV2ef9jP3XWflOJSwj3IWMm8jX/cWI/+4RYeWiLB/cS0lbuNap
         mnPvO0935rXU8vVQLT7kD1Flni4Ys2kLDxHEffdbO+KN7+IIegBd3Un6xsCMCu3gYOro
         KRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683252; x=1730288052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc/d/VIiG49L+/d6qxDj8y/ZsZGo0rIznhJwT5hb3KQ=;
        b=txtmMsYfGjJjO7/cULapgHWzMzwY9SEZT6xxtqA/Ka7YElgGxi+S2NV8lIH1aCMcsj
         PPeaFmJ+/8UJyi/xS7l/yCyN5iq3b/Z9j272MxZzXdq8dtJCqlRr+fSU0d8cE2RU4EGm
         wZ7Hr667yErLfhMtTGLHfQeK8F5nx88zTpKlkOca5qzpLmPnIU8hO79NxV/SWNQ2mu8P
         1jSj1W8koX6hEEj6SlyHjQMWuvXWFDmuqVNAfcsj+SL1k0eHvJcxOo3z4Cum15AZPT4k
         oRCAm2YlSC/ZB12vTVXfdgImiBFdcIwWT0OUf98Q57hsrFDeVmT0SihGR3vpcuqTE6Yy
         TRtA==
X-Forwarded-Encrypted: i=1; AJvYcCVyF3UyCrn2/hQ2mEjchxHh6btId4hG3np7ezTdLg5ummB/Inff7CyRTfvIbWJ3bfdfcQo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGI8RiOqaAkUh8awhulHAqa4jw08Tvx2sgFviZKdPFPipO6koE
	yktN0qBxjvTOZsg4hwqds4U8LfxGj0xT/A0su81Oflkcc2Wmfmr5WtCXxsZUvkY=
X-Google-Smtp-Source: AGHT+IGX9kLBYLMntAv2Zyd9NwAZDoBf7ZcI7j6Q9Uo1J6BYAqdZAtewejuvnJX4RHJtRVe8E9G1qg==
X-Received: by 2002:a17:907:3f98:b0:a99:ebbb:12fd with SMTP id a640c23a62f3a-a9abf96f557mr195597966b.65.1729683252535;
        Wed, 23 Oct 2024 04:34:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee125sm463814566b.75.2024.10.23.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CBBA05F9D0;
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
Subject: [PATCH v3 09/18] dockerfiles: fix default targets for debian-loongarch-cross
Date: Wed, 23 Oct 2024 12:33:57 +0100
Message-Id: <20241023113406.1284676-10-alex.bennee@linaro.org>
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

fix system target name, and remove --disable-system (which deactivates
system target).

Found using: make docker-test-build@debian-loongarch-cross V=1

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20241020213759.2168248-1-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/docker/dockerfiles/debian-loongarch-cross.docker | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/docker/dockerfiles/debian-loongarch-cross.docker b/tests/docker/dockerfiles/debian-loongarch-cross.docker
index 79eab5621e..538ab53490 100644
--- a/tests/docker/dockerfiles/debian-loongarch-cross.docker
+++ b/tests/docker/dockerfiles/debian-loongarch-cross.docker
@@ -43,8 +43,8 @@ RUN curl -#SL https://github.com/loongson/build-tools/releases/download/2023.08.
 ENV PATH $PATH:/opt/cross-tools/bin
 ENV LD_LIBRARY_PATH /opt/cross-tools/lib:/opt/cross-tools/loongarch64-unknown-linux-gnu/lib:$LD_LIBRARY_PATH
 
-ENV QEMU_CONFIGURE_OPTS --disable-system --disable-docs --disable-tools
-ENV DEF_TARGET_LIST loongarch64-linux-user,loongarch-softmmu
+ENV QEMU_CONFIGURE_OPTS --disable-docs --disable-tools
+ENV DEF_TARGET_LIST loongarch64-linux-user,loongarch64-softmmu
 ENV MAKE /usr/bin/make
 
 # As a final step configure the user (if env is defined)
-- 
2.39.5


