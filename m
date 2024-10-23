Return-Path: <kvm+bounces-29489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CF49AC910
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45671F20FEA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343A31B5336;
	Wed, 23 Oct 2024 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d14wI9yK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76191B372C
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683259; cv=none; b=ahKNKd6LW3Jep9IX/7ioW3fBErcdyuftD1bwev83z3bWCSchJBrRnQGDAtCPHJM2f8APSYcAIWD15+cMsDY62wyYOTKjy+u3pk7e1oo432We/ijKWYnNl/ZRQwgrKYdinTzDShPqJHlydR/1kVRRJ2ArPa0bn5IEUuNVFeOHuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683259; c=relaxed/simple;
	bh=Q5mzuGLqF37xBsfrxu2F605v7jw6CLbKILyEGO55HYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZ5Mvd1UTzdetRzBkqAUjM9NTvTmRh127o1+XRXoTIxmywU1R0kp5zfuQmyTFkw3UvTTaGBIn1Wde5KU3HA7o1KFqM4epa3nG6tAlEfVYUhzByetRLY6G5aufJUdKMZ2ixfNOyXoEEhRDpZ+SnC+ngDHOYjdTtb6STAuH1ROXq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d14wI9yK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9a1b71d7ffso1044094466b.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683256; x=1730288056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F14s2fuGgke3fc+cUXWbJXkLt5Skh4xTYd/t6sQdYbY=;
        b=d14wI9yKloexMaEaV6CPoWpN0pSxuPdkxMNRtXtveuQXSxmBini9D+90jY/AK93Riw
         GNNX5PKwsaRvxmk0BvPZaNmWPVR6pPXkRfVDpkao4dQkhoHECBBq+VOK+FPy2Dsx6HRS
         3NaK7pbTHGgPbJFuTMI2ZH6t2njM/qyCWh2ujgw6m3NJhtXtck7Fa0WH8+JkDoz6gTaD
         9Wsn+czPNW4JdmQcAx58ARhbY/CCCBta7SvbBc9jXY+lHZUhU4rlKyhW2IbZTvMMZli3
         w4ESvJmoSqjerGy/0w3i+Z5bfjxB+Fk9P7J5GEyRJSeWVMtmsZJb9vWWT7aKjv8rFNcj
         nHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683256; x=1730288056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F14s2fuGgke3fc+cUXWbJXkLt5Skh4xTYd/t6sQdYbY=;
        b=saUEmLhcul8/k8AFip8YdKALYPTNya+sJZ14DxYaWkyhFflktacLWklTv/1QV2xpvi
         jI5y8khkXTN5/XhC3qpJEDp567Hd2SEhxyXoHOvUUFJQVewywv+oZx2BODv57Bls01I6
         x706nEz3EpvIN8l5Sv08fEvZ+VkgneemAPQ+dLfwY4u1GeGKWV+GKB0wzPYKWKqCd6GK
         +sTSJRIqJgWZ+rcC9hnVG1cCkYNv4zDLe/34dx8o5henNl9i2IpDeNGui6U+nDCv1Y9q
         0vLn22amqPiBffl9XxRqJm2inuk0yCYCjUeQYROOdmIfTG+4MPzNR2tE98ni941g4ktO
         8nkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKnBrG10SRx6yeXALkU54MOcfIIb/qutyUYVCpF482fhx60Yf9kH/sCPOW1aLw4UddQ68=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUZQTuNBrX9IR8oFL2Oyfl63E9NywGiTEVOjXfWm3vdxTBPv1U
	Q3gnXi/3zLx6j2Mwop5riJB4Zal995Hp6XoZKJf2dUAae3gvsV5g7L6T0MUhNPE=
X-Google-Smtp-Source: AGHT+IGGBc55QM3qFCMBExtGsk6ICJf3Ug5DueFxLCCWUUU5RTVe6iZgYe//4a3K0VY6A0U2IduvZw==
X-Received: by 2002:a17:907:97cb:b0:a99:fff3:2eb0 with SMTP id a640c23a62f3a-a9abf92cf40mr200716666b.40.1729683256020;
        Wed, 23 Oct 2024 04:34:16 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91559f15sm463603866b.133.2024.10.23.04.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 84B6C5F925;
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
Subject: [PATCH v3 06/18] scripts/ci: remove architecture checks for build-environment updates
Date: Wed, 23 Oct 2024 12:33:54 +0100
Message-Id: <20241023113406.1284676-7-alex.bennee@linaro.org>
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

We were missing s390x here. There isn't much point testing for the
architecture here as we will fail anyway if the appropriate package
list is missing.

Message-Id: <20241022105614.839199-7-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/ci/setup/ubuntu/build-environment.yml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/ci/setup/ubuntu/build-environment.yml b/scripts/ci/setup/ubuntu/build-environment.yml
index edf1900b3e..56b51609e3 100644
--- a/scripts/ci/setup/ubuntu/build-environment.yml
+++ b/scripts/ci/setup/ubuntu/build-environment.yml
@@ -39,7 +39,6 @@
       when:
         - ansible_facts['distribution'] == 'Ubuntu'
         - ansible_facts['distribution_version'] == '22.04'
-        - ansible_facts['architecture'] == 'aarch64' or ansible_facts['architecture'] == 'x86_64'
 
     - name: Install packages for QEMU on Ubuntu 22.04
       package:
@@ -47,7 +46,6 @@
       when:
         - ansible_facts['distribution'] == 'Ubuntu'
         - ansible_facts['distribution_version'] == '22.04'
-        - ansible_facts['architecture'] == 'aarch64' or ansible_facts['architecture'] == 'x86_64'
 
     - name: Install armhf cross-compile packages to build QEMU on AArch64 Ubuntu 22.04
       package:
-- 
2.39.5


