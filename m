Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC691E98FF
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgEaQk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728408AbgEaQk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5kh3KwB/jxedDy9sx3WKrEz/2+qdiWFHqjY6mnOtPis=;
        b=eAQDFuu4DWxSdrg21aWyOUFMK+8xdM+GLYQGPtczUVJQFuZbrVKOlyUfkEs5/H8LsVDVu8
        LLnyjVLVC0144TI15+AcrQLeQjpKkp15P+KlNwEcNQlc3eTUDqULxn49nA280nYo0ebqpE
        qjg87L+Ohr9CjQf7J+dt2IVqnQDN5o0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-CTDLEOYfOw2YWxz8dpXi9Q-1; Sun, 31 May 2020 12:40:53 -0400
X-MC-Unique: CTDLEOYfOw2YWxz8dpXi9Q-1
Received: by mail-wr1-f72.google.com with SMTP id e1so3635565wrm.3
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5kh3KwB/jxedDy9sx3WKrEz/2+qdiWFHqjY6mnOtPis=;
        b=oix1IRUy4KkiRsl7/mBd72k9+7oFdkyYtrGJv2lHOXoB1Y+PaA7NIDllz4iZNHeHYg
         b2jhbDgdL5bGF9yujLzudXIPLbuVvHOTewn9t2oS3uZ48RFZhlRG47Jdd9x/7nbHQJVt
         MjtqwD6Bat6U6YViF9O/EqzQ0WrVWvxfxupjFbPVEd4MFc/dURUnH5ZO8WE5VW8+ZOSv
         L4VYsLV6hmX8BqCFzGDpMHBvlNztpEKAMv2ngWs+zZi1A140GXSMyHOOLDMiBSWlIKls
         HdyeT/TT4NnINVewNNirz/Dj8A9HCjIVRROGe8S0KgN6hctsPwdEwutv77/6UMLS0FKb
         iYsA==
X-Gm-Message-State: AOAM532YDnN7HkvK1lVzKOyS7QV9C13ZpNWZ5iouAX1C6qtdmPadZUmI
        PfUG4NkQd7HRLI1Vt3rUsaknIhEp5zh7d5dsNH5yx+dBPDhhB0ni9RzQ6JuU64Cx5howcjvH8W4
        WU+8Kf8vho+rg
X-Received: by 2002:a1c:7517:: with SMTP id o23mr3694859wmc.7.1590943251918;
        Sun, 31 May 2020 09:40:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgg7fWuhgUuVeOwz5AFukgiuotsYWI2AIs/F0Y1zcZ15fa/CgxkrebrEP3uzeGGoMSBlmEew==
X-Received: by 2002:a1c:7517:: with SMTP id o23mr3694845wmc.7.1590943251774;
        Sun, 31 May 2020 09:40:51 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id e15sm9223356wme.9.2020.05.31.09.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:51 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        Pavel Dovgalyuk <Pavel.Dovgaluk@gmail.com>,
        Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>
Subject: [PULL 24/25] tests/acceptance: refactor boot_linux_console test to allow code reuse
Date:   Sun, 31 May 2020 18:38:45 +0200
Message-Id: <20200531163846.25363-25-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pavel Dovgalyuk <Pavel.Dovgaluk@gmail.com>

This patch splits code in BootLinuxConsole class into two different
classes to allow reusing it by record/replay tests.

Signed-off-by: Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <159073588490.20809.13942096070255577558.stgit@pasha-ThinkPad-X280>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/acceptance/boot_linux_console.py | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tests/acceptance/boot_linux_console.py b/tests/acceptance/boot_linux_console.py
index c6b06a1a13..12725d4529 100644
--- a/tests/acceptance/boot_linux_console.py
+++ b/tests/acceptance/boot_linux_console.py
@@ -28,19 +28,13 @@
 except CmdNotFoundError:
     P7ZIP_AVAILABLE = False
 
-class BootLinuxConsole(Test):
-    """
-    Boots a Linux kernel and checks that the console is operational and the
-    kernel command line is properly passed from QEMU to the kernel
-    """
-
-    timeout = 90
-
+class LinuxKernelTest(Test):
     KERNEL_COMMON_COMMAND_LINE = 'printk.time=0 '
 
-    def wait_for_console_pattern(self, success_message):
+    def wait_for_console_pattern(self, success_message, vm=None):
         wait_for_console_pattern(self, success_message,
-                                 failure_message='Kernel panic - not syncing')
+                                 failure_message='Kernel panic - not syncing',
+                                 vm=vm)
 
     def extract_from_deb(self, deb, path):
         """
@@ -79,6 +73,13 @@ def extract_from_rpm(self, rpm, path):
         os.chdir(cwd)
         return os.path.normpath(os.path.join(self.workdir, path))
 
+class BootLinuxConsole(LinuxKernelTest):
+    """
+    Boots a Linux kernel and checks that the console is operational and the
+    kernel command line is properly passed from QEMU to the kernel
+    """
+    timeout = 90
+
     def test_x86_64_pc(self):
         """
         :avocado: tags=arch:x86_64
-- 
2.21.3

