Return-Path: <kvm+bounces-27121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A3C97C36D
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA9741F21F3B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EE51B28A;
	Thu, 19 Sep 2024 04:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F9TUXtm7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38741BC46
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721209; cv=none; b=ZhYUx0sJUb7K9XAsDBIWBGv1vhuu5RCmRaINiVwhf4KNuQIvSk8PVbxXtLNz0SctnQwhGQ+GhXgglFxSPOLwLPjafNH4ziO7Zh5g0OYKAhEYTr9ZKv0d59gaPW4tpEctEE1uaXl3yIYegbdKN9fO6m2tQREL03kEAlQYI3/5xw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721209; c=relaxed/simple;
	bh=LOW5dlyXFN0fbsV3pZUBsfmJUvK7b3SUazvap5/jqoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=UV7DBGtJJ7vsxBrtwXeJrTg2UboK1xAL45fECAvOmJ02BKKXxn7z+LpVVuAd7tfN2HuUu9OhFNxkMohWBO29oXbxjDlPNj/8JQ94E8ZFMHoAviQqjYf8inttWuvRhAb3Xhh/fMu2LpPqj8WLg7BXaS4LJb4CWq5AkONcochSfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F9TUXtm7; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-656d8b346d2so243049a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721207; x=1727326007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=okWQnCc9i+a9qTeP/CljeFJtPOK3zSl+MYdGWF+XBiU=;
        b=F9TUXtm74oMThHq3MTmvKrFCjpwPpr3pI1UEG42MMq4MndmXFvuYcS0SXvJt19FT3a
         FkwgAunM6sc1LC17hQVwI9LKWDIYxjJmCGpJ12v9BvqyOcDgEcrhY9kwoIOwHsK3myux
         OYJg6wRQpFYaX0gXRnucliLHgGSH+16uGSpnnOdOTwHmRSh9/PXygfQc/GtS+ZmVnEI1
         53xo23e3BFQL7cr1T9m0YvT3lw179HTec7+hRE3EQb4yEIBQOUl05930QEWnscGzQJMr
         mP3ZtsdsJhaO7AF5O2PNWqH2afztBtBNAxarnfH2uyH6/+qebWTQdiydBTl6gooaEcAr
         5oCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721207; x=1727326007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=okWQnCc9i+a9qTeP/CljeFJtPOK3zSl+MYdGWF+XBiU=;
        b=acAikMRjG/PkdzEyWsabcZWPCYBmvmZR07JBSbVyKitRfZe1Tq861W0XVjiSzplrFS
         KwshU9ZzHzwr2/mUj/wQOvU/H23HOfjr+daUIMRuK/MePFNjaP/k1NuZwiLPpe0lKsyy
         9cK+6pLWCaHfswGRJKEgh56fVMttj0/RSOdJzVqyx3E61ruTKiEAmdCokly6VTFrhK0U
         Atbz0YShZYATGKV1iwFMTaUH7IuGqiK09ZkD6W2DTUQH+VRlgF+TznHcXZL6mf4Op6Yz
         n2AP3x7v0otNmtYczpiGwDUzCJw9bPl7fHN5NwtoUK4tJUkDX+SziSX38fUQlf+leXoY
         hc6A==
X-Forwarded-Encrypted: i=1; AJvYcCU7ne/bsvczqBlrvCOGNQZm3aALDWxDvxhEIkSjjOX2N+ZKQkTRhu1N15Rb0dbwn4HOgBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgKDULgKmrIKb68gqtvTBO5acFVDzlbAdz/3IYmCPireWhnyd8
	zfqHPHsnXQYVOxuBmQenJyFhjxsV9CK1TCoLgSUJljopwS9cYk02s8tu8Lu5j1E=
X-Google-Smtp-Source: AGHT+IFTeoz0sc18zegnRwG9uqK1i/tdvMiZIsB+jYHs0tQzrYbWKu22/eeI4GvU6Dyul2n7o0JIuw==
X-Received: by 2002:a05:6a21:1690:b0:1cf:4348:d5c8 with SMTP id adf61e73a8af0-1d112e8bfaemr31800828637.39.1726721206933;
        Wed, 18 Sep 2024 21:46:46 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:46:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 00/34] Use g_assert_not_reached instead of (g_)assert(0,false)
Date: Wed, 18 Sep 2024 21:46:07 -0700
Message-Id: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
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

If a maintainer could pull the whole series, this would be much more easier than
integrating various parts of it in different subsystems. Thanks!

v3
- drop changes on .promela files
- some changes were already merged

v2
- align backslashes for some changes
- add summary in all commits message
- remove redundant comment

v1
https://lore.kernel.org/qemu-devel/20240910221606.1817478-1-pierrick.bouvier@linaro.org/T/#t

Pierrick Bouvier (34):
  hw/acpi: replace assert(0) with g_assert_not_reached()
  hw/arm: replace assert(0) with g_assert_not_reached()
  hw/net: replace assert(0) with g_assert_not_reached()
  migration: replace assert(0) with g_assert_not_reached()
  qobject: replace assert(0) with g_assert_not_reached()
  target/ppc: replace assert(0) with g_assert_not_reached()
  block: replace assert(false) with g_assert_not_reached()
  hw/hyperv: replace assert(false) with g_assert_not_reached()
  hw/net: replace assert(false) with g_assert_not_reached()
  hw/nvme: replace assert(false) with g_assert_not_reached()
  hw/pci: replace assert(false) with g_assert_not_reached()
  hw/ppc: replace assert(false) with g_assert_not_reached()
  migration: replace assert(false) with g_assert_not_reached()
  target/i386/kvm: replace assert(false) with g_assert_not_reached()
  accel/tcg: remove break after g_assert_not_reached()
  block: remove break after g_assert_not_reached()
  hw/acpi: remove break after g_assert_not_reached()
  hw/net: remove break after g_assert_not_reached()
  hw/scsi: remove break after g_assert_not_reached()
  hw/tpm: remove break after g_assert_not_reached()
  target/arm: remove break after g_assert_not_reached()
  target/riscv: remove break after g_assert_not_reached()
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

 include/qemu/pmem.h                     |  1 -
 accel/tcg/plugin-gen.c                  |  1 -
 block/qcow2.c                           |  2 +-
 block/ssh.c                             |  1 -
 hw/acpi/aml-build.c                     |  3 +--
 hw/arm/highbank.c                       |  2 +-
 hw/hyperv/hyperv_testdev.c              |  7 +++----
 hw/hyperv/vmbus.c                       | 15 ++++++---------
 hw/net/e1000e_core.c                    |  4 +---
 hw/net/i82596.c                         |  2 +-
 hw/net/igb_core.c                       |  4 +---
 hw/net/net_rx_pkt.c                     |  3 +--
 hw/net/vmxnet3.c                        |  1 -
 hw/nvme/ctrl.c                          |  8 ++++----
 hw/pci/pci-stub.c                       |  6 ++----
 hw/ppc/ppc.c                            |  1 -
 hw/ppc/spapr_events.c                   |  3 +--
 hw/scsi/virtio-scsi.c                   |  1 -
 hw/tpm/tpm_spapr.c                      |  1 -
 migration/dirtyrate.c                   |  3 +--
 migration/migration-hmp-cmds.c          |  2 +-
 migration/postcopy-ram.c                | 21 +++++++--------------
 migration/ram.c                         |  8 +++-----
 qobject/qlit.c                          |  2 +-
 qobject/qnum.c                          | 12 ++++--------
 qom/object.c                            |  1 -
 target/arm/hyp_gdbstub.c                |  1 -
 target/i386/kvm/kvm.c                   |  4 ++--
 target/ppc/dfp_helper.c                 |  8 ++++----
 target/ppc/mmu_helper.c                 |  2 +-
 target/riscv/monitor.c                  |  1 -
 tests/qtest/acpi-utils.c                |  1 -
 fpu/softfloat-parts.c.inc               |  2 --
 target/riscv/insn_trans/trans_rvv.c.inc |  2 --
 tcg/loongarch64/tcg-target.c.inc        |  1 -
 scripts/checkpatch.pl                   |  3 +++
 36 files changed, 50 insertions(+), 90 deletions(-)

-- 
2.39.5


