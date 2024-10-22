Return-Path: <kvm+bounces-29366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF419AA093
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F676B20EBE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FFB19CC39;
	Tue, 22 Oct 2024 10:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KmY2lg68"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564AD19B5B8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594590; cv=none; b=AwIMRE348WnyHBIK+AX2jzVqODuW6kTPFZFTB4EEB0thxvr6kj1NPQtXTHL1ubenLvbqSg76Cx/XdlTpwTGTCMtgeFEAE9FQEv4R9ruhquY9jhxvFI4lwgdgXhEya7aeS2yy1IYfeJeOBihyaemCDUrdNk7VRP5+meas1vcV5Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594590; c=relaxed/simple;
	bh=od+F5J8tr7tzJhSZj6WjI5rrEwFyDywA1WQXm44ZMVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDzV7xwg+bW8rt6MtrrK9a+M0M/WDjVRJyKqpLGfq9mWX2+fZSLMOv3xhl8cnwJmu2PqUgFBepmf91iOvFH8UnBol6Pvf84yUeNSSJil/0K4wvsmwe1bJw8qqb9j8rfDlzelXcGFkHoyKBHU9Zxd1yTwHRBX41r8V1LRYB3yEb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KmY2lg68; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cb74434bc5so1915033a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594586; x=1730199386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc/d/VIiG49L+/d6qxDj8y/ZsZGo0rIznhJwT5hb3KQ=;
        b=KmY2lg68xR9hxtlaRvZg+n3Ofg4rH2R40PYnlcxVtxx6Bq7YkANUEHzHEG2t2AirWq
         aZdZZSz95WS+q8qAmGZ31Lhn6b1/VjXSWv+jbTlKc8LwI3oSkgQj16CujSZejEWH192r
         8rsuhrDLkSxOKbiZv9OIcY4UclcGzDL4ahJrrYEL6Q0Dw2az8XzKa9fMBCQU8U64G/Eu
         dPHoqmZHNJffSUW8M4BT5KIXAfZTu/JZM8IrtawcU9d0kq0shfimWKBMSrQR3xRk+YdM
         A5sNfp4rg+pgU8oCTvfhz33iiUKzFkz1t9oK8mx8WXJg/uG6wjMxTXJ7A4fHV1oCWxuc
         MgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594586; x=1730199386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc/d/VIiG49L+/d6qxDj8y/ZsZGo0rIznhJwT5hb3KQ=;
        b=vQieyp75iEiKJrd9BNhYnXxVGflcWksEGVL7jwJSANJqkhGSu9Req9Kve9+tnuAyl2
         zjhGfPE3ATS8IvAtPrK6IDB4sscitMfSV3+cmzn8WFIvmHRl6EAy0GyMe1J8rwAGMp5B
         3wohak1KAlKhDibWDRcLPwJNvvOKZ6tk1cfq0ZWfHYRKy6NL5y3a2epgkX25iFswUUho
         Spm3irP5kQQibx6cLIMT3eT+FHX8vbVi91Fvlr8eIvfbtKFCBWRwekHgnUB+TtGV2owk
         Nc5pbFMLgihA92SZvs1J5C/zs00A1am5Ls7YOcOh02sMWGUvi9w5q6kzuvXVJuZ+L9dW
         HSuw==
X-Forwarded-Encrypted: i=1; AJvYcCUDvLdxvPWSF9lcoDLEsjwXqd0ZEQhXCWFyn4Yg4lKCSLDaIPwA8WWtM37Iwq9xnTgnuK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBUYMC3z0stolTLQFl/u4Q+3tqREIKU63aoHtYm2InfVa7IkHU
	lDDdTgcJz15/xn1aLTe/Ax4/uf16XEm7tEuFgz8Yeq6GMU94nhAjbZLXA29dDjo=
X-Google-Smtp-Source: AGHT+IGl+hAC7xKg+0Mp16pdpeeXIDIYDU6WjhEFWtxxGSyLoudl/zJKvx6zmb4I/Li5Y9q95p5HIQ==
X-Received: by 2002:a05:6402:358a:b0:5c9:85dc:5b9f with SMTP id 4fb4d7f45d1cf-5ca0ac43593mr11802716a12.2.1729594586471;
        Tue, 22 Oct 2024 03:56:26 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c737c4sm2963632a12.96.2024.10.22.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 711A35F9DD;
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
Subject: [PATCH v2 09/20] dockerfiles: fix default targets for debian-loongarch-cross
Date: Tue, 22 Oct 2024 11:56:03 +0100
Message-Id: <20241022105614.839199-10-alex.bennee@linaro.org>
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


