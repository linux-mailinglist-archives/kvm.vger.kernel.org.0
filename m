Return-Path: <kvm+bounces-26617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2339762DF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF115281041
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDA118E04A;
	Thu, 12 Sep 2024 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ehIUDmfi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF1D186E58
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126771; cv=none; b=pNEmECAaUOiGS9V50swrGVjljDzn7dRun0bBRduGasQ1KK8rCbTWbO4TMN+EaAPWQP8QM1+tF0/D085mj1xPphIKyHLMYKTJVt8bnAJV20C3eENtmtuQCbsA4D0JhRquAEtMxFu4KpOO+kZBt0KWT+6gC5JiUMqm8CDjtol5OMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126771; c=relaxed/simple;
	bh=tRyV664IOLkUJ0MBNDIuwbeIZ5/d3zorlDg4PT4NmRc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=lXigs/kUl4po38zWTadC3M6JmVvRUTD7aHivGmEt2KSF6DTa41x7R38NdBrAM2tc7vjxhdx755ouqxwgPeBDowSyA3Q5gCO7etkDTtkYSgTmDdFW98iHgZiA8+C+ETxzJ2druz498Iuaq4Zm6HHF6TR5CByRrTHAJMa1zQ0g38o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ehIUDmfi; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7db12af2f31so660487a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126769; x=1726731569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6KTOZZpVPdK9NLch9CdYyKy3h5bRy7LFaAKYeIfSuvw=;
        b=ehIUDmfixuLkjVRaKAfxSbGlBkzMMqhTvu/sooRFrtbU1gzV3Dp+7vkC2NKUcLPCnw
         yPk0mM67C1SVhKDXFhSF3XSeLnZaxi4LMDPPHPRRcXsHdjdCJ4oNQtr/IcO8ZmVGBdYP
         AnEmfVjWD5reyL/g4yMihv9g5RYN3mQQCacZsj/yrzhCxpLXmLrGE+qWDfp2wZlskJqm
         OPwBDZ1/YELR+4TPySAIIHVAc1A2RRGdMzFqEfOP07NwE1boX3stB567+UVTGicYOpmm
         ngmQUXOhfcKfGP5X24DoO11Wq+QdTLJJl/PZb5JkdpxKByuzc3bkl1Nt8AZewCH3y+sF
         P5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126769; x=1726731569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6KTOZZpVPdK9NLch9CdYyKy3h5bRy7LFaAKYeIfSuvw=;
        b=fKNxA522gHF65ujLzmQa361MHPQA8TMgeaRsYMj0woo4MJVht/jSndwTpZTR4V8LQ0
         cCtbR2WMiI03QmLgfCqG8j/Ab3AziiZZ0/auHhdhUSTKaM06w/Yg1xv1gHzRKuqGbMRL
         vLVC4rRYsMBFrQ/H3GFK7xHBsWWK/8cFHtscVdgzzA0XrYmmNJ2DSFOVRkqo5JZE030X
         8aENYOleNqyBNJ/Mpmz1ZIydalWjNXcn8eh9nciRtQZm5mhMwGN7feXY7hF0PRKMOG/7
         mPsYa/YE9NwdU7AJfAOBf5Cg5fef+sLufeXnoy24XUHZf+hTXKXl1LGE+QUny1kyY101
         /Vdg==
X-Forwarded-Encrypted: i=1; AJvYcCX5QpS++Dv1/74iOHTWBJlBM++uxiqJfSUi+9EL60WYe1+pLly0yB67JDIhuGX/bh3NFrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb+zyZG2FlEO/cZ0tN1WkUNzsjovRA4RhQEIqPUZpA+JlkmL/2
	C+0+NGn1WXUKoBDryqdAEaZgBnoYOcuUMhLqGj9YD38D/T3kL+STQzc1ItPz5zw=
X-Google-Smtp-Source: AGHT+IFDHcH9yYygsOOy6F9cWKwp6ExszFi//61KJ3XywRQafJBSbtA6oO7fB2lrh3DyPlfq88Ey5A==
X-Received: by 2002:a05:6a21:114d:b0:1cc:ce91:8459 with SMTP id adf61e73a8af0-1cf75ea2351mr2933012637.5.1726126766203;
        Thu, 12 Sep 2024 00:39:26 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:25 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 00/48] Use g_assert_not_reached instead of (g_)assert(0,false)
Date: Thu, 12 Sep 2024 00:38:33 -0700
Message-Id: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

This series cleans up all usages of assert/g_assert who are supposed to stop
execution of QEMU. We replace those by g_assert_not_reached().
It was suggested recently when cleaning codebase to build QEMU with gcc
and tsan: https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/.

In more, cleanup useless break and return after g_assert_not_reached();

And finally, ensure with scripts/checkpatch.pl that we don't reintroduce
(g_)assert(false) in the future.

New commits (removing return) need review.

Tested that it build warning free with gcc and clang.

v2
- align backslashes for some changes
- add summary in all commits message
- remove redundant comment

v1
https://lore.kernel.org/qemu-devel/20240910221606.1817478-1-pierrick.bouvier@linaro.org/T/#t

Pierrick Bouvier (48):
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
  include/qemu: remove return after g_assert_not_reached()
  hw/hyperv: remove return after g_assert_not_reached()
  hw/net: remove return after g_assert_not_reached()
  hw/pci: remove return after g_assert_not_reached()
  hw/ppc: remove return after g_assert_not_reached()
  migration: remove return after g_assert_not_reached()
  qobject: remove return after g_assert_not_reached()
  qom: remove return after g_assert_not_reached()
  tests/qtest: remove return after g_assert_not_reached()
  scripts/checkpatch.pl: emit error when using assert(false)

 docs/spin/aio_notify_accept.promela     |  6 +++---
 docs/spin/aio_notify_bug.promela        |  6 +++---
 include/hw/s390x/cpu-topology.h         |  2 +-
 include/qemu/pmem.h                     |  1 -
 accel/tcg/plugin-gen.c                  |  1 -
 block/qcow2.c                           |  2 +-
 block/ssh.c                             |  1 -
 hw/acpi/aml-build.c                     |  3 +--
 hw/arm/highbank.c                       |  2 +-
 hw/char/avr_usart.c                     |  2 +-
 hw/core/numa.c                          |  2 +-
 hw/gpio/nrf51_gpio.c                    |  1 -
 hw/hyperv/hyperv_testdev.c              |  7 +++----
 hw/hyperv/vmbus.c                       | 15 ++++++---------
 hw/misc/imx6_ccm.c                      |  1 -
 hw/misc/mac_via.c                       |  2 --
 hw/net/e1000e_core.c                    |  4 +---
 hw/net/i82596.c                         |  2 +-
 hw/net/igb_core.c                       |  4 +---
 hw/net/net_rx_pkt.c                     |  3 +--
 hw/net/vmxnet3.c                        |  1 -
 hw/nvme/ctrl.c                          |  8 ++++----
 hw/pci-host/gt64120.c                   |  2 --
 hw/pci/pci-stub.c                       |  6 ++----
 hw/ppc/ppc.c                            |  1 -
 hw/ppc/spapr_events.c                   |  3 +--
 hw/scsi/virtio-scsi.c                   |  1 -
 hw/tpm/tpm_spapr.c                      |  1 -
 hw/watchdog/watchdog.c                  |  2 +-
 migration/dirtyrate.c                   |  3 +--
 migration/migration-hmp-cmds.c          |  2 +-
 migration/postcopy-ram.c                | 21 +++++++--------------
 migration/ram.c                         |  8 +++-----
 qobject/qlit.c                          |  2 +-
 qobject/qnum.c                          | 12 ++++--------
 qom/object.c                            |  1 -
 system/rtc.c                            |  2 +-
 target/arm/hyp_gdbstub.c                |  1 -
 target/i386/kvm/kvm.c                   |  4 ++--
 target/ppc/dfp_helper.c                 |  8 ++++----
 target/ppc/mmu_helper.c                 |  2 +-
 target/riscv/monitor.c                  |  1 -
 tests/qtest/acpi-utils.c                |  1 -
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
 54 files changed, 72 insertions(+), 120 deletions(-)

-- 
2.39.2


