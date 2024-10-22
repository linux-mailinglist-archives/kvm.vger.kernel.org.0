Return-Path: <kvm+bounces-29360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F24709AA08C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E2D11C21D3C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EB819B581;
	Tue, 22 Oct 2024 10:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tsDYHGnk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524C199254
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594581; cv=none; b=ojK/+lQAIkCFpOEfR6aD/kQQAZ+t+0qYTbPZs9470cSVF1UD4GVxSWmbKRvDoE9i/vk4+c/XCd93CH7yrRoUNUE5+07JanzJYuSltbUulqDijEmLUuqgzMwvIxRdH+V14VfIjJQoige3TCGpRMRJDDTKIr3d4pJiHJD21N/60DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594581; c=relaxed/simple;
	bh=XnfPRDxBufLEWEv2UlqxttDJgXzO5PyF2hrAqzQmkzc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qnepvX7OK0b7qmScxuOjim/IB6o41w6+VagbuyPcSog/K3WwNPvBsnLfDd0QHHsc1gBKdZWv0G6S1FdZyxcgEif1mXAcoQ/0dvvFt2tknW/XFz9YMCGSTbczjoIZtuEwcWJOsLFEUjEMAO2ZF4I0q06Cf+Wo5lu832gdD1YBODw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tsDYHGnk; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a0472306cso740796166b.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594576; x=1730199376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=COpfR9RLf2CLdazvbIhqB2YmojRnRaS7PX4PKuRZwh4=;
        b=tsDYHGnkisVOa5BZ6ORvyj46JNVvn91VddurlSLemPZSXhU6s0LYUMDPLoqW9wOC07
         ZJ6ysB0anCHOzXG0kH1cgsLcBT6ZlklXPQkohMLCzvbzFnQz9ONhggZiBhz0FdA+SkKL
         bz2R4vmU8U8Ipo1ekPcSWieHYiDiskmkUHz8bdkgB83MLTKADoMXFX2q84LCvgq6LZTG
         Wg7xRg97u8x+xcaNm+SX4/Iku7CongYAa01aClFwA1f/2vyPJ634BwIt74TF/VqJ7jVh
         nB3WuvV0mat0KZ/gnf7wGHjLEwSH4EdPcaewFW6ukZVi+/pItYJe74J8S5t5ThN794fr
         M3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594576; x=1730199376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COpfR9RLf2CLdazvbIhqB2YmojRnRaS7PX4PKuRZwh4=;
        b=rNoPCCP7cMabXJ8UvCoJ0jolwCILrjgLNQVQ+kyLRsqmLZAfdKV/Qz0acEPmOQ0qoq
         rmcXEP08jYTRjYB1oimzVzBIWDGpwFQnkNyyr6Ik82N6T6TpfghTm0aj66uwjcD9k+jc
         bdX82mrnm/QwszQ18sktZ6XpDu02xLC+SIu3cIum0BwSGx+8b2h5RRtTxpkSiCgTpDDn
         BpWzsLafmH2IK1jcFPEI+RnnlprRWP9rb1LBH9Y7p2YVZA1VVKpkZlFKWlCOkNySQwus
         r7J/TbxQxmg30R0TJ1kasvUvTVE/qUxw+EKCvRhg/gtzXu4P5Ifkz9HL1Kyt2SeCVqLD
         mWuA==
X-Forwarded-Encrypted: i=1; AJvYcCUSiCDnCnzrYWoGyfHf6mIEGGzWIjJ7wQNnXgDyeZkPeCwRH+h0EnwbdYfNHSY8CZJVEx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFCn1T73aIDIo4XkLICt/RBHaRjzBq2v1JQ2zJdoTq+E0VbCJH
	JmZhPySqgp8+W6H34yDVEoSk1OEvs0+6wJluDZdb8ZbipFUbk26bB0bAHpZYVlw=
X-Google-Smtp-Source: AGHT+IFvyKkyeRPJrAKRyY3MStdAXndUKfD+I3lEe2ovrB6KLCkuexA+w8IhgFRYygmb+9drojBW0Q==
X-Received: by 2002:a17:906:c150:b0:a9a:47a:8908 with SMTP id a640c23a62f3a-a9aace2551cmr208312266b.9.1729594576427;
        Tue, 22 Oct 2024 03:56:16 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edc33sm321447866b.58.2024.10.22.03.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:15 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A8D0D5F89C;
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
Subject: [PATCH v2 00/20] maintainer updates (testing, gdbstub, plugins)
Date: Tue, 22 Oct 2024 11:55:54 +0100
Message-Id: <20241022105614.839199-1-alex.bennee@linaro.org>
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
and plugins/next). I didn't include the plugins on the last post as I
hadn't had a chance to do my sweep through patches before travelling.
I've also updated MAINTAINERS to point at my next trees.

For testing we have mostly tweaks and cleanups. I've included some
tracepoints tweaks for cpu_loop_exit_atomic purely as there was no
where else to but it. There are also some cleanups to the tsan support
from Pierrick. The mipsel tweaks have already been applied directly to
the tree.

For gdbstub more cleanups as well as fixing some gdbstub breakage of
the untested aarch64-be linux-user target. I've added a very basic
some test to prevent silly regressions in the future.

For plugins again more cleanups. The GDB trigger patch will probably
not get merged and should be considered an experimental hack for now.

The following still need review:

  plugins: add ability to register a GDB triggered callback
  tests/tcg: enable basic testing for aarch64_be-linux-user
  config/targets: update aarch64_be-linux-user gdb XML list
  MAINTAINERS: mention my gdbstub/next tree
  gitlab: make check-[dco|patch] a little more verbose
  scripts/ci: remove architecture checks for build-environment updates
  MAINTAINERS: mention my testing/next tree
  tests/docker: add NOFETCH env variable for testing
  MAINTAINERS: mention my plugins/next tree

Alex Bennée (10):
  tests/docker: add NOFETCH env variable for testing
  MAINTAINERS: mention my testing/next tree
  scripts/ci: remove architecture checks for build-environment updates
  accel/tcg: add tracepoints for cpu_loop_exit_atomic
  gitlab: make check-[dco|patch] a little more verbose
  MAINTAINERS: mention my gdbstub/next tree
  config/targets: update aarch64_be-linux-user gdb XML list
  tests/tcg: enable basic testing for aarch64_be-linux-user
  MAINTAINERS: mention my plugins/next tree
  plugins: add ability to register a GDB triggered callback

Gustavo Romero (2):
  tests/tcg/aarch64: Use raw strings for regexes in test-mte.py
  testing: Enhance gdb probe script

Ilya Leoshkevich (2):
  tests/docker: Fix microblaze atomics
  tests/tcg/x86_64: Add cross-modifying code test

Pierrick Bouvier (6):
  meson: hide tsan related warnings
  docs/devel: update tsan build documentation
  dockerfiles: fix default targets for debian-loongarch-cross
  meson: build contrib/plugins with meson
  contrib/plugins: remove Makefile for contrib/plugins
  plugins: fix qemu_plugin_reset

 MAINTAINERS                                   |  3 +
 docs/devel/testing/main.rst                   | 26 +++++-
 configure                                     | 23 ++---
 Makefile                                      | 10 ---
 configs/targets/aarch64_be-linux-user.mak     |  2 +-
 meson.build                                   | 14 ++-
 include/qemu/plugin-event.h                   |  1 +
 include/qemu/qemu-plugin.h                    | 16 ++++
 plugins/plugin.h                              |  9 ++
 accel/tcg/plugin-gen.c                        |  4 +
 accel/tcg/user-exec.c                         |  2 +-
 plugins/api.c                                 | 18 ++++
 plugins/core.c                                | 37 ++++++++
 tests/tcg/aarch64_be/hello.c                  | 35 ++++++++
 tests/tcg/plugins/mem.c                       | 11 ++-
 tests/tcg/x86_64/cross-modifying-code.c       | 80 +++++++++++++++++
 accel/tcg/ldst_atomicity.c.inc                |  9 ++
 .gitlab-ci.d/check-dco.py                     |  9 +-
 .gitlab-ci.d/check-patch.py                   |  9 +-
 accel/tcg/trace-events                        | 12 +++
 contrib/plugins/Makefile                      | 87 -------------------
 contrib/plugins/meson.build                   | 23 +++++
 plugins/qemu-plugins.symbols                  |  1 +
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
 33 files changed, 397 insertions(+), 177 deletions(-)
 create mode 100644 tests/tcg/aarch64_be/hello.c
 create mode 100644 tests/tcg/x86_64/cross-modifying-code.c
 delete mode 100644 contrib/plugins/Makefile
 create mode 100644 contrib/plugins/meson.build
 create mode 100644 tests/tcg/aarch64_be/Makefile.target

-- 
2.39.5


