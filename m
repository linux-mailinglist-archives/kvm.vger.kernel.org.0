Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4C309415
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhA3KLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhA3B4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:56:11 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA1C061793
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:27 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g10so10625792wrx.1
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDZADzgKI5lXuqqUK6CV2RYB4kAOXUW22/2lumwj8o4=;
        b=e7psjHWNaDe5BRPalel5z+UrUPQyCYHO0ADPAqwnXvE6/jKDRHnq865wvhM3CvcziS
         81EyjqLup5Sso5l2NVZ/0wY2xzImn5JfNEpSNIBoIBengxfy1LzI66lsP+ni/80f/evR
         U7QLC+B3eBq5pi+hy3v4oWie/DVjl15VvVl+DUC7b4bFZ82n+IBpLOg69cciuSH0bv0o
         ugmYLJK5GlHsO6ioN/+OP/utD5jbLp9Mf2b2fwCAn07n5bGBKAg2Ljhf/XruZU6V7ADq
         ieVbF8YOSHcYMgG6rdoDn8FpNs1Ulo8zayvnM2zRRrDOTV3lmjsv5yKhGHhUzizRmIXS
         CcDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dDZADzgKI5lXuqqUK6CV2RYB4kAOXUW22/2lumwj8o4=;
        b=roBg+DPdcXwxsi+xqXnO9F6iTwI/6L3rtATVVxC61n4HQ5K9u2WsxLsomu3jWgEkdd
         PiBlIFrDB0PHjHmf6sOK08Ot30FM13VQyRgFZIBfFLXQvEW76MLbtGC0kOD6BWPPmNXO
         9bYAfim3QnwbDgnUTpr6WfB3s3eWFMdFJwWVUStWhVTnrGVbzuE5lSaAcAZCOwBNFh7s
         6BdGoGh9kE6kH8EfrNSdOeSI2usUnkF23w4q+KNFRCABikR2WqjjnVM5NZwXcQKhqdZs
         FGpWoSwl143VomWbYZIuHUZowaKWkuSOSc/mTAQvHE8RIwuNMKNyLcmXRxFa0vAy4aBY
         bN/w==
X-Gm-Message-State: AOAM533lVl6WAXfdW5wJtkaTjY3SrlcJLJWHiBfUmyP5Y7G0bq1FIga7
        TyQ1lPEO6+L0QPfhp3n2DGE=
X-Google-Smtp-Source: ABdhPJxaH/w2Fme7el93QIXUQzDffvAxEB63h7HSmXGa9jkoVnLMptaWM3d09a23cIwVkku9tHUZXg==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr7559886wrt.404.1611971606779;
        Fri, 29 Jan 2021 17:53:26 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id d13sm14972889wrx.93.2021.01.29.17.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:26 -0800 (PST)
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
        qemu-arm@nongnu.org
Subject: [PATCH v5 11/11] .travis.yml: Add a KVM-only Aarch64 job
Date:   Sat, 30 Jan 2021 02:52:27 +0100
Message-Id: <20210130015227.4071332-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
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

