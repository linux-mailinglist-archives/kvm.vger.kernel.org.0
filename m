Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07592309423
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhA3KMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232863AbhA3Bx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:53:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108CEC0613D6
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:52:47 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m1so5253411wml.2
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vcCVSF3XdYkCqqZi7utKwViQKx4YjOvtKjolDPxsZVA=;
        b=uuOQE2bVc/AXhQEPhQ6gdsToWOMtR7/LcnPqZ5MlFP7kxA9NkXZRlPLIuIGcDAICaH
         ssfdEX74NQKHWvbMKF1O0arKgDrgBDsd8FqdoI/5wNZzzclE5eRj9Kpm6bGoGr5+cZdI
         Jg5zG6cmCMmNVfGLW3zUisi7sd7SUqp60e7Hpum16Q1olADlzRwBFv2K8f8X18j8D47y
         58iyx4+nB5prF66v4obJKkL3bwkP1u0ZTkyuBYVj1LfX8505z2oyoDPPp1zNI+EnKisD
         o5O/sJHYTlK/TxPX7i+7nbbtSy/f7B6U9/cTk8WL2l7kXtk/9VzZhNismcBX99UrM8es
         TVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vcCVSF3XdYkCqqZi7utKwViQKx4YjOvtKjolDPxsZVA=;
        b=QA29OcpEEUKi8Wx4sA8Gzwf6e6L6tjDTXBPNyz8XWqgr6w8OLPuTsbAbf3VNf41lQW
         1gCQMR271XXk75dEndR+uiAigsgLJDydRo/4y3C7K1/CyU5WhNuxNVFyhVvSgNu6OUQB
         ySPKTCngeKVQwSmmEwlZIM9Cajp0QBDCNbm8CBtX5dvo/xUI7dp+6CMSyg8MdDakcg2u
         OfzDnx4ehw2gE1pCl11cwcxRqVIKgWoPQ7fqFSXUIJX9Rt2HEZZSC32+Z8IDw2cuKpW1
         aBdaEc/V5dGZaJSwc7z/99smTysDx8wsVg/L0oyWhPVlmf7iagQtG2K1JDRAHiEuCo1H
         nS2A==
X-Gm-Message-State: AOAM533QSAdJdF4Um27yga41r8az53Xu3lzho4CSbPjCxtO7uZ+94Nm1
        nU/bprJqCPDLWB/E/PP8XJ8=
X-Google-Smtp-Source: ABdhPJxjjNgvntexhnAMkjHR5dHZDBe4a6Ehpw1OZ8B2xG9qLvuQMF7WDg1InhxkhCshzCAD0AspzA==
X-Received: by 2002:a05:600c:154f:: with SMTP id f15mr6167686wmg.46.1611971565884;
        Fri, 29 Jan 2021 17:52:45 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id b4sm15215041wrn.12.2021.01.29.17.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:52:45 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
Date:   Sat, 30 Jan 2021 02:52:19 +0100
Message-Id: <20210130015227.4071332-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a cpu based on (at least) the ARMv7 architecture.

Only enable the following ARMv4 CPUs when TCG is available:

  - StrongARM (SA1100/1110)
  - OMAP1510 (TI925T)

The following machines are no more built when TCG is disabled:

  - cheetah              Palm Tungsten|E aka. Cheetah PDA (OMAP310)
  - sx1                  Siemens SX1 (OMAP310) V2
  - sx1-v1               Siemens SX1 (OMAP310) V1

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 2 --
 hw/arm/Kconfig                          | 8 ++++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index 341d439de6f..8a53e637d23 100644
--- a/default-configs/devices/arm-softmmu.mak
+++ b/default-configs/devices/arm-softmmu.mak
@@ -14,8 +14,6 @@ CONFIG_INTEGRATOR=y
 CONFIG_FSL_IMX31=y
 CONFIG_MUSICPAL=y
 CONFIG_MUSCA=y
-CONFIG_CHEETAH=y
-CONFIG_SX1=y
 CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 223016bb4e8..7126d82f6ce 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -1,3 +1,7 @@
+config ARM_V4
+    bool
+    depends on TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -31,6 +35,8 @@ config ARM_VIRT
 
 config CHEETAH
     bool
+    default y if TCG
+    select ARM_V4
     select OMAP
     select TSC210X
 
@@ -249,6 +255,8 @@ config COLLIE
 
 config SX1
     bool
+    default y if TCG
+    select ARM_V4
     select OMAP
 
 config VERSATILE
-- 
2.26.2

