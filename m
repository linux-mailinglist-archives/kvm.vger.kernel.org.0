Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F244186FB8
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbgCPQND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:13:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42076 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731505AbgCPQND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:13:03 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 12:13:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=P5yP2gI3jZwVa/ROqUBqAiUPezN5j8lwPUWA/Pi42tY=;
        b=SOJHqX1OpTIwds4NuTinOwQkasmLOaVUm1Q2HuJ04+YF1bjV27gxqNI9np6mddxt/G7eUn
        Pvxt/t+/8BuY48AKAfa42PVtd1/BzVkektRmcpypYMSOof3qhtNlMG26D3bmzwsO17M/OQ
        XGugJ+FxXsdrWh3jF9eQ4Cicfh0Ty9s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-OlHjdzvbNV6Tcz7aIiRruQ-1; Mon, 16 Mar 2020 12:06:38 -0400
X-MC-Unique: OlHjdzvbNV6Tcz7aIiRruQ-1
Received: by mail-wr1-f70.google.com with SMTP id t4so6313645wrv.9
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P5yP2gI3jZwVa/ROqUBqAiUPezN5j8lwPUWA/Pi42tY=;
        b=g/8Tow63oxbfeYofC29Aolgdu3fVMOY5jFVvrmYcnysMxkaVCwu/qCQVgtmzlupwEa
         rRBbf28ol7Euz4hBoMxHCBnERWh3xYlI7N/VHRUrQ1nJ2Lv1AqnjBiuCBFcPieXkNhGB
         vbiYWZuiDbyXO6XFjWoalMCxCXlDyMqPgnM88LR4iRVpJE028GSxLD6KKMUG7HBqaaQw
         wvQAxbWRy46hsMMdoAV4qMLhO1td+h9mNrLEDl2Er+UfZhJBnzZ09EhbD4BmLA8SnkLD
         O48KCpUNGH3bg0xBi2M3FPXGN/pue11WKLZwNE95Fes8Z6ylRZ0LXr1+kn5nU6iZ7Bmc
         q0yw==
X-Gm-Message-State: ANhLgQ0cMxD1/xuf909CCI5LpIEh9j0Xaqsjp2MjBCTbTWOlGuuUYiNf
        URn63U/wL59rwIX/T98JStQAOmZJ30DVyeNjR1BT7krpw8pvRGbPJcyv8/7to9RPktWqSEI6r2L
        8nS91CYKKq5V2
X-Received: by 2002:adf:a343:: with SMTP id d3mr105732wrb.50.1584374797652;
        Mon, 16 Mar 2020 09:06:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt2iuZ7H3FhJLGjMjjY+SMihUpUN452/lUvxyCtpgGQsOh0snwxYqeNt3N03YZvD05ipB9yBA==
X-Received: by 2002:adf:a343:: with SMTP id d3mr105710wrb.50.1584374797395;
        Mon, 16 Mar 2020 09:06:37 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id s7sm478457wri.61.2020.03.16.09.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:06:36 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 00/19] Support disabling TCG on ARM (part 2)
Date:   Mon, 16 Mar 2020 17:06:15 +0100
Message-Id: <20200316160634.3386-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cover from Samuel Ortiz from (part 1) [1]:

  This patchset allows for building and running ARM targets with TCG
  disabled. [...]

  The rationale behind this work comes from the NEMU project where we're
  trying to only support x86 and ARM 64-bit architectures, without
  including the TCG code base. We can only do so if we can build and run
  ARM binaries with TCG disabled.

v3 almost 18 months later:
- Rebased
- Addressed Thomas review comments
- Added Travis-CI job to keep building --disable-tcg on ARM

v2 [2]:
- Addressed review comments from Richard and Thomas from v1 [3]

Regards,

Phil.

[1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html
[2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html
[3]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html

Based-on: <20200316120049.11225-1-philmd@redhat.com>
"accel: Allow targets to use Kconfig, disable semihosting by default"
https://lists.gnu.org/archive/html/qemu-devel/2020-03/msg04653.html

Philippe Mathieu-Daudé (15):
  target/arm: Rename KVM set_feature() as kvm_set_feature()
  target/arm: Restrict DC-CVAP instruction to TCG accel
  target/arm: Restric the Address Translate operations to TCG accel
  target/arm: Restrict Virtualization Host Extensions instructions to
    TCG
  target/arm: Move Makefile variable restricted to CONFIG_TCG
  target/arm: Add semihosting stub to allow building without TCG
  target/arm: Move ARM_V7M Kconfig from hw/ to target/
  target/arm: Restrict ARMv4 cpus to TCG accel
  target/arm: Restrict ARMv5 cpus to TCG accel
  target/arm: Restrict ARMv6 cpus to TCG accel
  target/arm: Restrict ARMv7 R-profile cpus to TCG accel
  target/arm: Restrict ARMv7 M-profile cpus to TCG accel
  hw/arm: Automatically select the 'virt' machine on KVM
  hw/arm: Do not build to 'virt' machine on Xen
  .travis.yml: Add a KVM-only Aarch64 job

Samuel Ortiz (1):
  target/arm: Do not build TCG objects when TCG is off

Thomas Huth (3):
  target/arm: Make set_feature() available for other files
  target/arm: Make cpu_register() available for other files
  target/arm: Make m_helper.c optional via CONFIG_ARM_V7M

 default-configs/aarch64-softmmu.mak |   1 -
 default-configs/arm-softmmu.mak     |  30 --
 target/arm/cpu-qom.h                |   9 +-
 target/arm/cpu.h                    |   7 +
 target/arm/internals.h              |  10 +
 target/arm/arm-semi-stub.c          |  13 +
 target/arm/cpu.c                    | 651 +---------------------------
 target/arm/cpu64.c                  |  19 +-
 target/arm/cpu_v4.c                 |  65 +++
 target/arm/cpu_v5.c                 | 266 ++++++++++++
 target/arm/cpu_v6.c                 | 171 ++++++++
 target/arm/cpu_v7m.c                | 207 +++++++++
 target/arm/cpu_v7r.c                |  83 ++++
 target/arm/helper.c                 |  54 +--
 target/arm/kvm32.c                  |  10 +-
 target/arm/kvm64.c                  |  16 +-
 target/arm/m_helper-stub.c          |  59 +++
 .travis.yml                         |  32 ++
 hw/arm/Kconfig                      |  17 +-
 target/Kconfig                      |   2 +-
 target/arm/Kconfig                  |  19 +
 target/arm/Makefile.objs            |  17 +-
 22 files changed, 1016 insertions(+), 742 deletions(-)
 create mode 100644 target/arm/arm-semi-stub.c
 create mode 100644 target/arm/cpu_v4.c
 create mode 100644 target/arm/cpu_v5.c
 create mode 100644 target/arm/cpu_v6.c
 create mode 100644 target/arm/cpu_v7m.c
 create mode 100644 target/arm/cpu_v7r.c
 create mode 100644 target/arm/m_helper-stub.c
 create mode 100644 target/arm/Kconfig

-- 
2.21.1

