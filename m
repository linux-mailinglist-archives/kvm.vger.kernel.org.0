Return-Path: <kvm+bounces-27474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F81E98655B
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EEB61F24B7E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2711129E93;
	Wed, 25 Sep 2024 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XopwAThq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76EC5A4D5
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284309; cv=none; b=Y0pFPGGx6la3Kh78ceDoVqpt1L8DSrmxtA7PpHddCpHtm60NGvP9lwWIrVxquZ9wC6kqc6KfYOF5AMzDW+EVYBQsGAWwWARGLGynijKcf2xmTt8DGPFI1jl/XqJMuotT6ln2qbvbCaCKYq7dO9eMN4oIBhHSgENqcQfzMksDhPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284309; c=relaxed/simple;
	bh=rejTLlmEywekzznG1nIH3X4+6fny6a5P2XpjF5WUYog=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=IKQpMmcI5POiCXkL585RluqCtEzGta+sjmPeN3NJYtOrKS/rjv8ti0Iw6odc+PSICvqE6/Y+ETcupTexNz/2oVDVXWRImERZmBZXyimYJRQw9ixtFI3Zb/S7CqCqoFDy8pYn6Gd3OAcBLzU7mY9JkLNePQHX15sUDjagOw+bu8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XopwAThq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42e7b7bef42so146435e9.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284305; x=1727889105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YKiMcMVIgaI1u5EOrQ7wt/HfEOtyQ4ZcHqLFruvQEk8=;
        b=XopwAThq+ZfZGqHTrVA9QJ3ylm/4TApxT38EL9JvrkNBF/SvIjeI20LEP6ktx0KSzx
         Oyj3HPgsqB2DzRnzhLkqxTxjl0DfF/U1AxHefNCs57MB87eJDWWzru7lKf8PcOXCCG9+
         d7kccppSu5X7S0ekdWCfHds6w5W+uBeDiRlljbZNgUhGhYNnObrHDhVfq83w6/l96Bge
         m9UfxlCm6YPbaKcZE81BUP9cMfQtJlDAS9H4NW0ke8ItRQXdzUbnVOd2B2fKswvzlHbX
         l9Kgm3fK7RXznh+TK+hRxpldiIj48kEeG3cy1H2Uy8UCT2DvgK88ea7Eg/IWB5KcuoDB
         Ih5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284305; x=1727889105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKiMcMVIgaI1u5EOrQ7wt/HfEOtyQ4ZcHqLFruvQEk8=;
        b=eP6/XRtc4WRUU9kX2iSx3Uv2TH8m46EkPEaK24HyVlIP6FxNzCuoEa3OLKjjeWRm9a
         7lncguukakSKvbTdaFN25NKqtrkoF77j18JJYWlwkNzH/VVewfXXvwr3k2zpepGh91++
         FbW4soaQQCtUhgXOse8jkSWi6V5hsXi4hOCy4cv0yn4rtBjhSz501BDlNyMJPb/LEnuy
         mke6GactNXzAmcwsj73YGGx75y33RQUjgEs6dlH1KjlNAvt67fWf9sdrKHZVR6siaMWv
         drYCsCldCC1naPemi5AhBc4yg9AqRTFZEwMF3v1xSEqyQ/65gR+eBeId1mqY9596bRXf
         ajXg==
X-Forwarded-Encrypted: i=1; AJvYcCWA9bOEh6qPWrs3Lj4Ia+EfX3326rXTb+bbq+xEqGOAUuTMIT/Extr08faCWGcX3jQF5fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwWhyT5TCpF8LReNWu3BSp5L1gNHrI98mVCRFd+DN3J6ufXuOH
	rq2oyGJ4Yo0kaBs9VkYPQT99Jzvp3pKtZR4oIB3GaPSSHtfiSs+s18A9byT48f4=
X-Google-Smtp-Source: AGHT+IGlSP0Jlk8NPTfdGfqLOuwAKaNghDViO1/OMw6Z7pw6Tee/O07cZuWwhv/1xXRFpiFAXO7XGg==
X-Received: by 2002:adf:fac5:0:b0:374:b685:672 with SMTP id ffacd0b85a97d-37cc248b5b4mr2184119f8f.26.1727284304867;
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2c226esm4455006f8f.36.2024.09.25.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:41 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 542CF5F8E4;
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
Subject: [PATCH 00/10] maintainer updates (testing, gdbstub)
Date: Wed, 25 Sep 2024 18:11:30 +0100
Message-Id: <20240925171140.1307033-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Welcome to the first post KVM forum series. We have:

  - fix from Ilya for microblaze atomics
  - Pierrick's tsan updates
  - I've added my testing and gdbstub trees to MAINTAINERS
  - enabled a very basic aarch64_be-linux-user test
  - fixed the missing gdb XML fails that cause aarch64_be-linux-user to assert
  - finally I've made the mips64el cross compiler bookworm and allow_fail

Alex Bennée (6):
  testing: bump mips64el cross to bookworm and allow to fail
  tests/docker: add NOFETCH env variable for testing
  MAINTAINERS: mention my testing/next tree
  MAINTAINERS: mention my gdbstub/next tree
  config/targets: update aarch64_be-linux-user gdb XML list
  tests/tcg: enable basic testing for aarch64_be-linux-user

Ilya Leoshkevich (1):
  tests/docker: Fix microblaze atomics

Pierrick Bouvier (3):
  meson: hide tsan related warnings
  target/i386: fix build warning (gcc-12 -fsanitize=thread)
  docs/devel: update tsan build documentation

 MAINTAINERS                                   |  2 ++
 docs/devel/testing/main.rst                   | 26 +++++++++++---
 configure                                     |  5 +++
 configs/targets/aarch64_be-linux-user.mak     |  2 +-
 meson.build                                   | 10 +++++-
 target/i386/kvm/kvm.c                         |  4 +--
 tests/tcg/aarch64_be/hello.c                  | 35 +++++++++++++++++++
 .gitlab-ci.d/container-cross.yml              |  3 ++
 tests/docker/Makefile.include                 |  5 +--
 .../build-toolchain.sh                        |  8 +++++
 .../dockerfiles/debian-mips64el-cross.docker  | 10 +++---
 .../dockerfiles/debian-toolchain.docker       |  7 ++++
 tests/lcitool/refresh                         |  2 +-
 tests/tcg/Makefile.target                     |  7 +++-
 tests/tcg/aarch64_be/Makefile.target          | 17 +++++++++
 15 files changed, 125 insertions(+), 18 deletions(-)
 create mode 100644 tests/tcg/aarch64_be/hello.c
 create mode 100644 tests/tcg/aarch64_be/Makefile.target

-- 
2.39.5


