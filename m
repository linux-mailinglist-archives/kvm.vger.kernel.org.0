Return-Path: <kvm+bounces-29479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FBE9AC901
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE8071F22FAA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006B31ABEC6;
	Wed, 23 Oct 2024 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VflBqNXB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE021AB53F
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683252; cv=none; b=TvU2rFvM+umAdMiP2TSpSeL03rDkvT3nT5X2CIOVlSLuLUzHGck2DSf4iz33OVoqx673ZtrLsvbK8SWCTjBA46ke7iul53fSt8jalAHOMjfJpK2XQ5496ifIin+Iv5oE5X47SWCBt3bCn8YTxSt8QO34x4npKoZ5VLbS2kkVK2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683252; c=relaxed/simple;
	bh=ye5ijEHAC2Zg82PqdLR2zjJXCiVpRE13j4jYSK7QO64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=TUZVVzk0alphO8V//Uyw9NABox4bQDmt3R1q71fjF2Q5hgw4CYT8QG4IFzNEgbFvR7W3L035+f/8ULp8mT3KGFG1LaQwnwxFpcu0zu1W5DzVqa7aPUNkJRv/BceZuFV+cJXyP/OYP+mD8ZjFRHW6DQJkRtXm0MD5/So44Xn6mOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VflBqNXB; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so810698366b.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683248; x=1730288048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pQbsv9+HLFwPElqDt1cQPCWQiM+jUl6LhMnJxHgBrO8=;
        b=VflBqNXBzLjxZUKxGnVMA0tmQVOScr1fs76rpoQv3ANqIBSXX41SYzA9xFahL/O7lv
         WerStfuwVmgr59jb1kCg+TgXODd5Gnj71ONNlqvF6ah1OQu1hgDyBSd+dWvr+MWd/d3d
         9ctm8tib0LJwEV4jziqiBrR3KKz6QyOaj262iEggoYzyNuUycF5/EKRvW2GP4P/1N0X4
         8ZwDohZB6j2bGmXBFzuja8ELFiXb+hksGCTt5PRON8lVHwLsOt98+amSzwEG9bq9en8g
         Q3pvr1fvUpzsIrYQWiPHDzEYWQicDPFdWu9Sn0fEoQRRgWAFwLhLa6Nx+z/3cBGFlFb2
         o4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683248; x=1730288048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pQbsv9+HLFwPElqDt1cQPCWQiM+jUl6LhMnJxHgBrO8=;
        b=CCacsoy+JeHypgyfj5UHShBCXlbGg8ymUohRMF5gRwzil6bjEyeDd7jyIwyoBYCO/M
         OZ5syaWUriwOynsswsxDndDmUswm0QOgxGKHSLGbExG36zerX56YzXWXEKtFVk6f7EAU
         k5mlfhAid8G9eeh3wFdUPYvn+zvdFcDjzO1wMfl2Gw/xQBEtFbJjyMq13S78qwRWF8S+
         Fq0+NUnDYYt9BswSdYb6SDIqySMCzqde3hvRgvSe7Bl76vxWJ8wvqiNDhUXQMtWFKW58
         0ZWlbpvSLLceHKRkzFlOQ8zGAPGzUqc4rrwEy1PURHbMbQ1ecrw2ErVh9r/hPDHUyz//
         fAKA==
X-Forwarded-Encrypted: i=1; AJvYcCWbXlEZRvzt83V+vlRAluKpEUxeOjPRu0WyUxniJfdVUGBx2jmEtOUc/yDcad0NWMMcHiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtZF1iHhRyOqtaVFWcOEv/TdghtfMPf5meuKwh4u+H9MMXxwHq
	IZO/qOTr/CIW+hGHknL6O0uQ3cEfAspXjZYTkWq+hQTi3M/SFd8kslD5abFk64U=
X-Google-Smtp-Source: AGHT+IGBTwMIHG5DvbrIefLKC+mBtckDycU3fjYg+qjkN6Z/s4jljjceL04+bmzPzYTy+RSRXwQpbw==
X-Received: by 2002:a17:907:940b:b0:a9a:1739:91e9 with SMTP id a640c23a62f3a-a9abf86af8emr196140166b.24.1729683248352;
        Wed, 23 Oct 2024 04:34:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912f6520sm467109066b.73.2024.10.23.04.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:07 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id EB4FE5F897;
	Wed, 23 Oct 2024 12:34:06 +0100 (BST)
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
Subject: [PATCH v3 00/18] maintainer updates (testing, gdbstub, plugins) pre-PR
Date: Wed, 23 Oct 2024 12:33:48 +0100
Message-Id: <20241023113406.1284676-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

This is an aggregation of three of my maintainer trees which you can
also get from their respective branches (testing/next, gdbstub/next
and plugins/next). It is now ready for a pull request.

Since last post:

  - added r-b tags
  - some minor typo fixes
  - dropped meson plugin contrib build and gdb hook changes

The last thing that still needs review:

  gitlab: make check-[dco|patch] a little more verbose

Alex Bennée (9):
  tests/docker: add NOFETCH env variable for testing
  MAINTAINERS: mention my testing/next tree
  scripts/ci: remove architecture checks for build-environment updates
  accel/tcg: add tracepoints for cpu_loop_exit_atomic
  gitlab: make check-[dco|patch] a little more verbose
  MAINTAINERS: mention my gdbstub/next tree
  config/targets: update aarch64_be-linux-user gdb XML list
  tests/tcg: enable basic testing for aarch64_be-linux-user
  MAINTAINERS: mention my plugins/next tree

Gustavo Romero (2):
  tests/tcg/aarch64: Use raw strings for regexes in test-mte.py
  testing: Enhance gdb probe script

Ilya Leoshkevich (2):
  tests/docker: Fix microblaze atomics
  tests/tcg/x86_64: Add cross-modifying code test

Pierrick Bouvier (5):
  meson: hide tsan related warnings
  docs/devel: update tsan build documentation
  dockerfiles: fix default targets for debian-loongarch-cross
  contrib/plugins: remove Makefile for contrib/plugins
  plugins: fix qemu_plugin_reset

 MAINTAINERS                                   |  3 +
 docs/devel/testing/main.rst                   | 26 +++++-
 configure                                     | 23 ++---
 Makefile                                      | 10 ---
 configs/targets/aarch64_be-linux-user.mak     |  2 +-
 meson.build                                   | 10 ++-
 accel/tcg/plugin-gen.c                        |  4 +
 accel/tcg/user-exec.c                         |  2 +-
 tests/tcg/aarch64_be/hello.c                  | 35 ++++++++
 tests/tcg/x86_64/cross-modifying-code.c       | 80 +++++++++++++++++
 accel/tcg/ldst_atomicity.c.inc                |  9 ++
 .gitlab-ci.d/check-dco.py                     |  5 +-
 .gitlab-ci.d/check-patch.py                   |  5 +-
 accel/tcg/trace-events                        | 12 +++
 contrib/plugins/Makefile                      | 87 -------------------
 scripts/ci/setup/ubuntu/build-environment.yml |  2 -
 scripts/probe-gdb-support.py                  | 75 ++++++++--------
 tests/docker/Makefile.include                 |  5 +-
 .../dockerfiles/debian-loongarch-cross.docker |  4 +-
 .../build-toolchain.sh                        |  8 ++
 .../dockerfiles/debian-toolchain.docker       |  7 ++
 tests/tcg/Makefile.target                     |  7 +-
 tests/tcg/aarch64/gdbstub/test-mte.py         |  4 +-
 tests/tcg/aarch64_be/Makefile.target          | 17 ++++
 tests/tcg/x86_64/Makefile.target              |  4 +
 25 files changed, 273 insertions(+), 173 deletions(-)
 create mode 100644 tests/tcg/aarch64_be/hello.c
 create mode 100644 tests/tcg/x86_64/cross-modifying-code.c
 delete mode 100644 contrib/plugins/Makefile
 create mode 100644 tests/tcg/aarch64_be/Makefile.target

-- 
2.39.5


