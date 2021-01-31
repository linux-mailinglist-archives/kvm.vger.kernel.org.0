Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D910D309BD6
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhAaL6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 06:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhAaLyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:54:18 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B498C0617A9
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:27 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id u14so10752275wmq.4
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDZADzgKI5lXuqqUK6CV2RYB4kAOXUW22/2lumwj8o4=;
        b=GPA3cPX5JqpAFpzVcjZKg1cO1/9FihznwxhN41y6BZVikFsYSNE6B0F3b9X4VO71cp
         GyaFWx06W4d8AT7wOOpbEv7rWLR6Qtiz0j5zPdW4jmA03AE7iBWAl+qefDWnlBg1V4z9
         2hzf0FUOYthAF2ms02+vvuipScW5aEoQfhM5Srd93RmxYebfiQUiVZHh2JesAfrjbQB0
         cMFWV7UC3rXS0EBZiWNOOLMzmTv768bnbQkOi/XMIRHsBx16z36CUzwuUgCR8NuoQrgW
         IawFdKNFLz9n71Y6SFOU0j45CXgLpwvg9ZqphDDITLGf2fxUdnKHiy3pt17p/Z2oEROU
         U1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dDZADzgKI5lXuqqUK6CV2RYB4kAOXUW22/2lumwj8o4=;
        b=D0TfeT5kU4Jb7j27ucYFapxxr9o1IQGh0udzlYJcmT8L5dShtVbHOv/3D9+lRNUWkR
         EI8x9IA7HHmmZUzVxkmSNU51Fbs32ZcEilGVYmF6pKiu/sw+rTtXu4RJYr88PO5Ouna4
         xDI4ylZOO/N4M1YMmLlx2m4h+Vp4ZsLBmOIe/tuDZvdjJRxT3wzmqkV2og4epgiw5PKF
         8YNEBD7wp4IqTBR3sgleTfLqF7MylopkwE+EQDfUzl1LcJUH/WjwW7Eq/biDG+5ZqcBu
         7eL/re+qldWGd4MFKA/8+x+fLHy74R1StY8nbJkBpwX0RQaf5jGD/h5cqu06HYh/1QLv
         LNkg==
X-Gm-Message-State: AOAM532c78zQhiFRjzON7xxolPeXEe1AIiVWEweZn5zMVU75tR8QeL4J
        k857r10z4x67DOZWbyM+phY=
X-Google-Smtp-Source: ABdhPJw2bZG4ateZlH907WN0fRnTRmRpW0onowzIJAbKbCMmlTsxOnsYabaEy2SQ4dqJh8Bjumsguw==
X-Received: by 2002:a1c:6289:: with SMTP id w131mr2722637wmb.0.1612093886306;
        Sun, 31 Jan 2021 03:51:26 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id n19sm17298998wmq.25.2021.01.31.03.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:51:25 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v6 11/11] .travis.yml: Add a KVM-only Aarch64 job
Date:   Sun, 31 Jan 2021 12:50:22 +0100
Message-Id: <20210131115022.242570-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <philmd@redhat.com>

Add a job to build QEMU on Aarch64 with TCG disabled, so
this configuration won't bitrot over time.

We explicitly modify default-configs/aarch64-softmmu.mak to
only select the 'virt' and 'SBSA-REF' machines.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
Job ran for 7 min 30 sec
https://travis-ci.org/github/philmd/qemu/jobs/731428859
---
 .travis.yml | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index 5f1dea873ec..4f1d662b5fc 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -264,6 +264,38 @@ jobs:
         - CONFIG="--disable-containers --target-list=${MAIN_SOFTMMU_TARGETS}"
         - UNRELIABLE=true
 
+    - name: "[aarch64] GCC (disable-tcg)"
+      arch: arm64
+      dist: focal
+      addons:
+        apt_packages:
+          - libaio-dev
+          - libattr1-dev
+          - libbrlapi-dev
+          - libcap-ng-dev
+          - libgcrypt20-dev
+          - libgnutls28-dev
+          - libgtk-3-dev
+          - libiscsi-dev
+          - liblttng-ust-dev
+          - libncurses5-dev
+          - libnfs-dev
+          - libnss3-dev
+          - libpixman-1-dev
+          - libpng-dev
+          - librados-dev
+          - libsdl2-dev
+          - libseccomp-dev
+          - liburcu-dev
+          - libusb-1.0-0-dev
+          - libvdeplug-dev
+          - libvte-2.91-dev
+          - ninja-build
+      env:
+        - CONFIG="--disable-containers --disable-tcg --enable-kvm --disable-xen --disable-tools --disable-docs"
+        - TEST_CMD="make check-unit"
+        - CACHE_NAME="${TRAVIS_BRANCH}-linux-gcc-aarch64"
+
     - name: "[ppc64] GCC check-tcg"
       arch: ppc64le
       dist: focal
-- 
2.26.2

