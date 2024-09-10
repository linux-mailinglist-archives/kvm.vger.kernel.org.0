Return-Path: <kvm+bounces-26350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2510497457A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83556B2430A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85C21AB53E;
	Tue, 10 Sep 2024 22:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vXkRinR7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF017622D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006573; cv=none; b=Jpp4wKIx2hgYFEh9ytGwxqHOoiMgcK/XLMRYsPqvINBepb1UWfNFpsZ0rcBgbf+A2f6VOb6O+RGrjJAcYcI+oZXGycfx+5gpOCngO6vC745sBn/8OLGGSQPu2Zpysgvmq/mwMj8tNw6QR9DBKdT0+CPNkqITaqhmcaWgMiXyd2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006573; c=relaxed/simple;
	bh=P8NkKuyeBZj4+kkwnfXX2dn6JWq/ANG/uqh2PJhUPws=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=qD6e8FIVJZZEIJ8jlADZdDga6DmwhtkbIao+PUXtN31xkBbUAB6TDDO1UdyCP4FdoCAJCrQjk+DO85VMiuoLmNjf6Sk/9JaaoVlMgkiB6lmrgJcFPJa1Z+YVZruzwhG8DiWtlcM1GZEwXcl8s1yZWjkVB+GFBFwixpJT7lOVlmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vXkRinR7; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71798661a52so233951b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006571; x=1726611371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YSyqJppZZS4UpzgxKNiY6ieJzLYfceDr8xhPE0xjFbI=;
        b=vXkRinR7FVyi2JqVa0xerKK5sSz5vgSG86IicS7YmbHodVGtzXC+eA2csu/u1BSPqg
         Os5wHzucOh7L7i9mFQeEPqTzQZxHbFtS8gsLqaQ/zexauyOkHggy3S4s1Sb/qH+vJf0i
         XYTmMrIyZJlf4SskZ9Q2sSOIABwMwstX7/h8/bMak1v3/nXl0WSOSvsePq0S68JcvaJL
         /ewEfs07NwMd6BJ0sXkdT6S+7BtkSFICf60DJwCO9dXSwEXJG0I07+bAjmkvFNnMJ9D+
         tlkzhjYwO4v1UkiGy9uWX4FpFh6zlHLR+xEsOPOc6FJ8DJ7uL1P64KRBPuDKnhlHA/cR
         yMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006571; x=1726611371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSyqJppZZS4UpzgxKNiY6ieJzLYfceDr8xhPE0xjFbI=;
        b=B0fyFgmehH/IKx2wukMAjceym2YMal0W9bOP6/L6raEu2hpLCL4nQlsl79ZHdWFwZ0
         UPwGd8+C5M5FUdkb6hE+g/lMBy6G9QcU0ecTnYeQKtlndEI+wr/K6vPhmwxnpXj5Jx5U
         A+R58y6IAXEh8q1HebH9TVYAZhXMns1/iz0Mjzh6ftR+Oo3Yje1Atct3qXKeT4EypLx/
         hD+FMIzBRKWUSkMPtkI5sRsD5dCSkVBTW8ac6PnT2dP6m+4dr3oiFU//h2ZRRUgkD5Bn
         3AtJnwpPuc4NeRtt7SnXbiJ6+0pDvqXOUQuCCYG279g0MUXgv1p/aJwo/ZMi+k5WVr1c
         eV+A==
X-Forwarded-Encrypted: i=1; AJvYcCUsSMOgT4UpiN+bRWjVwvsGeuK16ozILK9nK0yLrEwuVLMVwl296ZGLbJFaeAGwK7e1aXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvjKKzbXcSQM0Em98xytli1O7Yx6YWUaUyEsS5Q8iOu4fk/3yE
	R30e8LfKkzSKyaFT5BpP85XJ3XIGe0sYgtj9e1tNpvSbJFYrNKJO4xJS0gxl6MA=
X-Google-Smtp-Source: AGHT+IFq8D12w3lrLR9iZPp9dBLWaCbloOusYWBwljwNqw7WFauubajh8SDyD921iLBgiiedqovYTQ==
X-Received: by 2002:a05:6a00:9484:b0:712:7512:add9 with SMTP id d2e1a72fcca58-71907f2dc50mr6196737b3a.13.1726006570484;
        Tue, 10 Sep 2024 15:16:10 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:10 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 00/39] Use g_assert_not_reached instead of (g_)assert(0,false)
Date: Tue, 10 Sep 2024 15:15:27 -0700
Message-Id: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up all usages of assert/g_assert who are supposed to stop
execution of QEMU. We replace those by g_assert_not_reached().
It was suggested recently when cleaning codebase to build QEMU with gcc
and tsan: https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/.

In more, cleanup useless break after g_assert_not_reached();

And finally, ensure with scripts/checkpatch.pl that we don't reintroduce
(g_)assert(false) in the future.

Pierrick Bouvier (39):
  docs/spin: replace assert(0) with g_assert_not_reached()
  hw/acpi: replace assert(0) with g_assert_not_reached()
  hw/arm: replace assert(0) with g_assert_not_reached()
  hw/char: replace assert(0) with g_assert_not_reached()
  hw/core: replace assert(0) with g_assert_not_reached()
  hw/net: replace assert(0) with g_assert_not_reached()
  hw/watchdog: replace assert(0) with g_assert_not_reached()
  migration: replace assert(0) with g_assert_not_reached()
  qobject: replace assert(0) with g_assert_not_reached()
  system: replace assert(0) with g_assert_not_reached()
  target/ppc: replace assert(0) with g_assert_not_reached()
  tests/qtest: replace assert(0) with g_assert_not_reached()
  tests/unit: replace assert(0) with g_assert_not_reached()
  include/hw/s390x: replace assert(false) with g_assert_not_reached()
  block: replace assert(false) with g_assert_not_reached()
  hw/hyperv: replace assert(false) with g_assert_not_reached()
  hw/net: replace assert(false) with g_assert_not_reached()
  hw/nvme: replace assert(false) with g_assert_not_reached()
  hw/pci: replace assert(false) with g_assert_not_reached()
  hw/ppc: replace assert(false) with g_assert_not_reached()
  migration: replace assert(false) with g_assert_not_reached()
  target/i386/kvm: replace assert(false) with g_assert_not_reached()
  tests/qtest: replace assert(false) with g_assert_not_reached()
  accel/tcg: remove break after g_assert_not_reached()
  block: remove break after g_assert_not_reached()
  hw/acpi: remove break after g_assert_not_reached()
  hw/gpio: remove break after g_assert_not_reached()
  hw/misc: remove break after g_assert_not_reached()
  hw/net: remove break after g_assert_not_reached()
  hw/pci-host: remove break after g_assert_not_reached()
  hw/scsi: remove break after g_assert_not_reached()
  hw/tpm: remove break after g_assert_not_reached()
  target/arm: remove break after g_assert_not_reached()
  target/riscv: remove break after g_assert_not_reached()
  tests/qtest: remove break after g_assert_not_reached()
  ui: remove break after g_assert_not_reached()
  fpu: remove break after g_assert_not_reached()
  tcg/loongarch64: remove break after g_assert_not_reached()
  scripts/checkpatch.pl: emit error when using assert(false)

 docs/spin/aio_notify_accept.promela     |  6 +++---
 docs/spin/aio_notify_bug.promela        |  6 +++---
 include/hw/s390x/cpu-topology.h         |  2 +-
 accel/tcg/plugin-gen.c                  |  1 -
 block/qcow2.c                           |  2 +-
 block/ssh.c                             |  1 -
 hw/acpi/aml-build.c                     |  3 +--
 hw/arm/highbank.c                       |  2 +-
 hw/char/avr_usart.c                     |  2 +-
 hw/core/numa.c                          |  2 +-
 hw/gpio/nrf51_gpio.c                    |  1 -
 hw/hyperv/hyperv_testdev.c              |  6 +++---
 hw/hyperv/vmbus.c                       | 12 ++++++------
 hw/misc/imx6_ccm.c                      |  1 -
 hw/misc/mac_via.c                       |  2 --
 hw/net/e1000e_core.c                    |  2 +-
 hw/net/i82596.c                         |  2 +-
 hw/net/igb_core.c                       |  2 +-
 hw/net/net_rx_pkt.c                     |  3 +--
 hw/nvme/ctrl.c                          |  8 ++++----
 hw/pci-host/gt64120.c                   |  2 --
 hw/pci/pci-stub.c                       |  4 ++--
 hw/ppc/spapr_events.c                   |  2 +-
 hw/scsi/virtio-scsi.c                   |  1 -
 hw/tpm/tpm_spapr.c                      |  1 -
 hw/watchdog/watchdog.c                  |  2 +-
 migration/dirtyrate.c                   |  2 +-
 migration/migration-hmp-cmds.c          |  2 +-
 migration/postcopy-ram.c                | 14 +++++++-------
 migration/ram.c                         |  6 +++---
 qobject/qlit.c                          |  2 +-
 qobject/qnum.c                          |  8 ++++----
 system/rtc.c                            |  2 +-
 target/arm/hyp_gdbstub.c                |  1 -
 target/i386/kvm/kvm.c                   |  4 ++--
 target/ppc/dfp_helper.c                 |  8 ++++----
 target/ppc/mmu_helper.c                 |  2 +-
 target/riscv/monitor.c                  |  1 -
 tests/qtest/ipmi-bt-test.c              |  2 +-
 tests/qtest/ipmi-kcs-test.c             |  4 ++--
 tests/qtest/migration-helpers.c         |  1 -
 tests/qtest/numa-test.c                 | 10 +++++-----
 tests/qtest/rtl8139-test.c              |  2 +-
 tests/unit/test-xs-node.c               |  4 ++--
 ui/qemu-pixman.c                        |  1 -
 fpu/softfloat-parts.c.inc               |  2 --
 target/riscv/insn_trans/trans_rvv.c.inc |  2 --
 tcg/loongarch64/tcg-target.c.inc        |  1 -
 scripts/checkpatch.pl                   |  3 +++
 49 files changed, 72 insertions(+), 90 deletions(-)

-- 
2.39.2


