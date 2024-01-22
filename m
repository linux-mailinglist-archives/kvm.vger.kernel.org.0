Return-Path: <kvm+bounces-6546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9735836645
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40C8D1F23E65
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E903441760;
	Mon, 22 Jan 2024 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t8hMYFjG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FEE40C0D
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935375; cv=none; b=TD1nQmlZfWEsA1bcl9PQqTFXc1kxW7jgydRQfUsDbM6oM8VFoTpZWZJeBinmjE/LqS8ooYq3LtT6zOA01KvA5nL9KjD0Ode/+mSSLPJlawGnP3RHCcS32Frl+quqjj5tSMYCF+TzmXjB7xc4fFUgSDogGmXPPZi5rjf3Y51foxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935375; c=relaxed/simple;
	bh=sSgC0SGxhQOduWN+iPZ2dvU6XGMI6S0duW7WENkrp2g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=h/ZVJTMwCddfbQknU07a+5ygX0DLkDyeBxaV5EX6ufL8EClKNvoLekVe8k6NnIvG8oQsLdCSY05PlFDyuWCGp218TIKP8gcquflxwDszGpy+PAFRjRmVP19EM0FwEfj8ufP3F1OBX0qZUGCJJb3E/RyPU1DuhO4p3CRKPgjoGK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t8hMYFjG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40eaf973eb4so7608865e9.0
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935371; x=1706540171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bb/KYUiaTsna6vJuXI/9siaZWs98wLSaDxs6Hv4zkgU=;
        b=t8hMYFjG6eXHNMYNF9NyUTYI8BR+qicDoSYd0tDgkWmJQx2iL+FCyVKuetV2qMPgah
         0GOgoT6P8dcLwA4EEOP8/T+isaWafkDnTd+z/+FcPIDfomaoqGhJNmwiFwWkgWape0s5
         aWxp+hal0C/SSSytMkVST7NOj3cwUnM7VlhCQm4SWTjxyADbJmaO1qrZjlAEmr7oG4kZ
         PJXKC7I78KSaqfEOlIkhQ3TjleMkPKopl/iIcQsXdG8g/YsF2iwhnlelhM27UyTXgG7x
         qiFnUHJhkavFqj4rSkweruM1ZrHiCV6y1padLp+kxtLkIdSacJNYyuiaahdYdduhmHYQ
         3RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935371; x=1706540171;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb/KYUiaTsna6vJuXI/9siaZWs98wLSaDxs6Hv4zkgU=;
        b=KJEuzRfxjOe+T3MOBIQIF/qCxw0TfvGonQubt9G3wNBov5VthY4u21MzXTeFcdDoNs
         dJREsht5cwyBoE+GsiF4v44npcsI7WU9GdjXTKR/OdAupy//BqdxMsOPOJppZPKs0LPp
         tnd/BeNXG8X7pfg3W0x4o/vwqOq8cJ1uppUNIPxcJev635B72ksgq1U4pOeSEYDozMG6
         qG+d9aNGoa/yE1uLYI3sRzRC6UBwEtPL1Jd4FWGg+3mEXebex6LhHN2LS8RlAoDyMATw
         vLUKo1l21hMAhTNKSsf93Hqkk2jqW1NrKVsCSPoaX+vw4yo6f5dak9KmA7WBWkHkXR17
         VhLg==
X-Gm-Message-State: AOJu0YzrtTjz/fbNdy3wbN0kZQDR7PtHvSDfCc3wJiazU2TMW16FJrEb
	T84rKCT4uvVTtz2qyw/SDbMAet9NQyOeizRiQGi7B8j2Rwbd/Am2wkojffSrHpQ=
X-Google-Smtp-Source: AGHT+IFRKwbXocgaijT07IhMJdnHqOsm5/GOB25FwCO0EZ5jJroK5Ak40g+nI35wW91C50qu6kEv6g==
X-Received: by 2002:a05:600c:21d1:b0:40e:3b3f:51eb with SMTP id x17-20020a05600c21d100b0040e3b3f51ebmr2307292wmj.81.1705935371471;
        Mon, 22 Jan 2024 06:56:11 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d64a4000000b003392e05fb3esm4592744wrp.24.2024.01.22.06.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:11 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C42EF5F7AE;
	Mon, 22 Jan 2024 14:56:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>
Subject: [PATCH v3 00/21] plugin updates (register access) for 9.0 (pre-PR?)
Date: Mon, 22 Jan 2024 14:55:49 +0000
Message-Id: <20240122145610.413836-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Akihiko requested the register support not be merged in its current
state so it's time for another round of review. I've made a few tweaks
to simplify the register and CPU tracking code in execlog and removed
some stale API functions. However from my point of view its ready to
merge.

v3
--
  - split from testing bits (merged)
  - removed unused api funcs
  - keep CPUs in a GArray instead of doing by hand

v2
--

 - Review feedback for register API
 - readthedocs update
 - add expectation docs for plugins

The following still need review:

  contrib/plugins: extend execlog to track register changes
  gdbstub: expose api to find registers

Akihiko Odaki (15):
  hw/riscv: Use misa_mxl instead of misa_mxl_max
  target/riscv: Remove misa_mxl validation
  target/riscv: Move misa_mxl_max to class
  target/riscv: Validate misa_mxl_max only once
  target/arm: Use GDBFeature for dynamic XML
  target/ppc: Use GDBFeature for dynamic XML
  target/riscv: Use GDBFeature for dynamic XML
  gdbstub: Use GDBFeature for gdb_register_coprocessor
  gdbstub: Use GDBFeature for GDBRegisterState
  gdbstub: Change gdb_get_reg_cb and gdb_set_reg_cb
  gdbstub: Simplify XML lookup
  gdbstub: Infer number of core registers from XML
  hw/core/cpu: Remove gdb_get_dynamic_xml member
  gdbstub: Add members to identify registers to GDBFeature
  plugins: Use different helpers when reading registers

Alex Bennée (6):
  gdbstub: expose api to find registers
  plugins: add an API to read registers
  contrib/plugins: fix imatch
  contrib/plugins: extend execlog to track register changes
  docs/devel: lift example and plugin API sections up
  docs/devel: document some plugin assumptions

 docs/devel/tcg-plugins.rst   |  72 +++++++-
 accel/tcg/plugin-helpers.h   |   3 +-
 include/exec/gdbstub.h       |  43 ++++-
 include/hw/core/cpu.h        |   7 +-
 include/qemu/plugin.h        |   1 +
 include/qemu/qemu-plugin.h   |  51 +++++-
 target/arm/cpu.h             |  27 ++-
 target/arm/internals.h       |  14 +-
 target/hexagon/internal.h    |   4 +-
 target/microblaze/cpu.h      |   4 +-
 target/ppc/cpu-qom.h         |   1 +
 target/ppc/cpu.h             |   5 +-
 target/riscv/cpu.h           |   9 +-
 target/s390x/cpu.h           |   2 -
 accel/tcg/plugin-gen.c       |  43 ++++-
 contrib/plugins/execlog.c    | 319 +++++++++++++++++++++++++++++------
 gdbstub/gdbstub.c            | 169 +++++++++++--------
 hw/core/cpu-common.c         |   5 +-
 hw/riscv/boot.c              |   2 +-
 plugins/api.c                | 123 +++++++++++++-
 target/arm/cpu.c             |   2 -
 target/arm/cpu64.c           |   1 -
 target/arm/gdbstub.c         | 230 ++++++++++++-------------
 target/arm/gdbstub64.c       | 122 +++++++-------
 target/avr/cpu.c             |   1 -
 target/hexagon/cpu.c         |   4 +-
 target/hexagon/gdbstub.c     |  10 +-
 target/i386/cpu.c            |   2 -
 target/loongarch/cpu.c       |   2 -
 target/loongarch/gdbstub.c   |  13 +-
 target/m68k/cpu.c            |   1 -
 target/m68k/helper.c         |  26 ++-
 target/microblaze/cpu.c      |   6 +-
 target/microblaze/gdbstub.c  |   9 +-
 target/ppc/cpu_init.c        |   7 -
 target/ppc/gdbstub.c         | 114 +++++++------
 target/riscv/cpu.c           | 193 +++++++++++----------
 target/riscv/gdbstub.c       | 151 +++++++++--------
 target/riscv/kvm/kvm-cpu.c   |  10 +-
 target/riscv/machine.c       |   7 +-
 target/riscv/tcg/tcg-cpu.c   |  44 +----
 target/riscv/translate.c     |   3 +-
 target/rx/cpu.c              |   1 -
 target/s390x/cpu.c           |   1 -
 target/s390x/gdbstub.c       | 105 +++++++-----
 plugins/qemu-plugins.symbols |   2 +
 scripts/feature_to_c.py      |  14 +-
 47 files changed, 1287 insertions(+), 698 deletions(-)

-- 
2.39.2


