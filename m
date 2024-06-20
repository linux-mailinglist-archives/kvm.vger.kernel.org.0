Return-Path: <kvm+bounces-20099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1599109AA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC2AB1F2276B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5F41B0115;
	Thu, 20 Jun 2024 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="olnsNHCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810D1AF6B1
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896953; cv=none; b=X/7/vMtoP76W/txMID7nI1c58NaNSH9YsDHP/ANfi0wBRl0KSjmIE4qrB4cfMo781PnXPOMGzTqTQ1qTwFaJCVi6ZorHx5QwkvfRVy9uzuqv9ra4iDEPYxc0hNAB9Zfga5digm6UpYo2wpkAaMovSd1alJ3UIhoSg0Luvod83Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896953; c=relaxed/simple;
	bh=VEQ56xyItML+3tsJHWOD0QpeSFTmo5CLhf/r/phMT0o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=FHuv2I7rr1kVv08Tu/hBHwipF3K5dyIB5GsV2oI+NnoGYoJZA8MgAh6aYC1G+OYn23IlMro0+63DMmi9LXQYX28gZ+ELPa2ukeJCRzoUwa8Bta3ZjeVgmS6mwkqW8LKMK1APTaPv5ypmo588xk+C7n1VCIRbs8LRXbPwcMmr35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=olnsNHCr; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52bc29c79fdso1122489e87.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896949; x=1719501749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GwfYtHiFW+MpVchR1W1uIXCNJBxRS/LzmnaKh+rSEqQ=;
        b=olnsNHCrJk+cu5bDfPSuLI37jeXenra2xeWkcUT3xG6agjrCSFqRbTO6p6T5zxJRao
         n/lXeMuOibzkMu4N8iciGRVSkf/21qjTBIEcNADKdnGqp0HehbSPtLaQte4RwQ0hx+PY
         8OgzDKBPK/+C/cEiK+GOnBrZ6fAhqiMMrmxCPGg9CJyy2tLSamBfTirB5lPjp69Lc6W7
         a84aCQLJnKTs1YGGSItcAg6JeEun+amkc0azH6sEAf5xMIQ8MXiSVkrzUDLy3uJbuo9a
         n/iZxJ/7zzwp9x8xPWyBVKHtidE/nOqkQ7HJs5bbnkl479aQy7j0ketzl0buOc+ybXss
         QxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896949; x=1719501749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GwfYtHiFW+MpVchR1W1uIXCNJBxRS/LzmnaKh+rSEqQ=;
        b=DK57i1hevc0y3ifCUcRNiv9GWZJqC2DMWyFwjtLH6N5QVlyU6G32Fj3u7gm/28VFVz
         wKCeUeETGrbmuRvfSbDawREKiEdIP8qqYzxxyTiy14qBmgdMEQVd81RPT8Ye+EZdlDD/
         v7xWK1K/PqGrRdwEhC5Lrqz081AL6+AW2qnRleP4fDNr8EqyQtls8FBySd9NMShdwc5c
         tmi3dt03dX9m+AtUBX9h9GkGrPOACAkMktS8v2nkNdEPcsoIL0hnk/RiCocC2e6x0bqT
         GIhlkz4mgHibGB9zsIhnzyxd9U3g6gahUL8nX5nydwptwlnhIjGkoRet7eWMxh3c0Nqm
         jSXg==
X-Forwarded-Encrypted: i=1; AJvYcCXterjvlbERiwBfETxgi0RFWUmUNx05yVge/FXr6fE20uw3bJWjChtXMygxid6l7oEAPuocotz92NRXAtfmJBrQZ2qL
X-Gm-Message-State: AOJu0YzrE+oZQWO6TeiMv/wt+l4Ub33lz1ZG5Trfsm0rOXG+Ja0pddFN
	2trCYOW8nTqFgNtlpPu1gt7ZwibvfUeUCYG0Qy4in9KBQUl1YVIAMTSL7r2oPHU=
X-Google-Smtp-Source: AGHT+IHZreEf/CgFmxklps2fJVXNdKgoEAsSXSn/BfkNWtTHxKRx0rK3p7tmSxgo5+bmw/ROdFHpnQ==
X-Received: by 2002:a05:6512:3123:b0:52b:bdbd:2c54 with SMTP id 2adb3069b0e04-52ccaa369acmr4081172e87.34.1718896946911;
        Thu, 20 Jun 2024 08:22:26 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f600cde92sm708227466b.205.2024.06.20.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:22 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F14C35F7B1;
	Thu, 20 Jun 2024 16:22:20 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 00/12] maintainer updates pre-PR (gdbstub, plugins, time control)
Date: Thu, 20 Jun 2024 16:22:08 +0100
Message-Id: <20240620152220.2192768-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

This is the current state of my maintainer trees. The gdbstub patches
are just minor clean-ups. The main feature this brings in is the
ability for plugins to control time. This has been discussed before
but represents the first time plugins can "control" the execution of
the core. The idea would be to eventually deprecate the icount auto
modes in favour of a plugin and just use icount for deterministic
execution and record/replay.

v2
  - merged in Pierrick's fixes
  - added migration blocker
  - added Max's plugin tweak

I'll send the PR on Monday if nothing comes up. The following still need review:

  plugins: add migration blocker

Alex.

Akihiko Odaki (1):
  plugins: Ensure register handles are not NULL

Alex Bennée (7):
  include/exec: add missing include guard comment
  gdbstub: move enums into separate header
  sysemu: add set_virtual_time to accel ops
  qtest: use cpu interface in qtest_clock_warp
  sysemu: generalise qtest_warp_clock as qemu_clock_advance_virtual_time
  plugins: add time control API
  plugins: add migration blocker

Max Chou (1):
  accel/tcg: Avoid unnecessary call overhead from
    qemu_plugin_vcpu_mem_cb

Pierrick Bouvier (3):
  qtest: move qtest_{get, set}_virtual_clock to accel/qtest/qtest.c
  contrib/plugins: add Instructions Per Second (IPS) example for cost
    modeling
  plugins: fix inject_mem_cb rw masking

 include/exec/gdbstub.h                        |  11 +-
 include/gdbstub/enums.h                       |  21 +++
 include/qemu/qemu-plugin.h                    |  27 +++
 include/qemu/timer.h                          |  15 ++
 include/sysemu/accel-ops.h                    |  18 +-
 include/sysemu/cpu-timers.h                   |   3 +-
 include/sysemu/qtest.h                        |   2 -
 accel/hvf/hvf-accel-ops.c                     |   2 +-
 accel/kvm/kvm-all.c                           |   2 +-
 accel/qtest/qtest.c                           |  13 ++
 accel/tcg/plugin-gen.c                        |   4 +-
 accel/tcg/tcg-accel-ops.c                     |   2 +-
 contrib/plugins/ips.c                         | 164 ++++++++++++++++++
 gdbstub/user.c                                |   1 +
 monitor/hmp-cmds.c                            |   3 +-
 plugins/api.c                                 |  47 ++++-
 plugins/core.c                                |   4 +-
 ...t-virtual-clock.c => cpus-virtual-clock.c} |   5 +
 system/cpus.c                                 |  11 ++
 system/qtest.c                                |  37 +---
 system/vl.c                                   |   1 +
 target/arm/hvf/hvf.c                          |   2 +-
 target/arm/hyp_gdbstub.c                      |   2 +-
 target/arm/kvm.c                              |   2 +-
 target/i386/kvm/kvm.c                         |   2 +-
 target/ppc/kvm.c                              |   2 +-
 target/s390x/kvm/kvm.c                        |   2 +-
 util/qemu-timer.c                             |  26 +++
 accel/tcg/ldst_common.c.inc                   |   8 +-
 contrib/plugins/Makefile                      |   1 +
 plugins/qemu-plugins.symbols                  |   2 +
 stubs/meson.build                             |   2 +-
 32 files changed, 377 insertions(+), 67 deletions(-)
 create mode 100644 include/gdbstub/enums.h
 create mode 100644 contrib/plugins/ips.c
 rename stubs/{cpus-get-virtual-clock.c => cpus-virtual-clock.c} (68%)

-- 
2.39.2


