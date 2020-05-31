Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512361E9901
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgEaQlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:41:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39854 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728394AbgEaQlD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5BS+2d4i/ahG24dd/tHPN0fLUUFmd8jGntUYE3MrX0=;
        b=DFymAV+QzviYD825qDTd1pRFR9GTyX61uN3hhaOt+T8dYlpS78LtsW9jHY189nu1cqBUSL
        468WT3y/BA4lkNP9SRuhGZkvkXynvm0OTuj5RFlxIm9N16DW0MusTlQ2VIPbK8KiG4I1jL
        3Q94h2QuIRKR9m4Acz9bAFr8scef2nY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-sNTjGaloPnajb6u4G0-rpg-1; Sun, 31 May 2020 12:40:58 -0400
X-MC-Unique: sNTjGaloPnajb6u4G0-rpg-1
Received: by mail-wr1-f70.google.com with SMTP id c14so3592484wrw.11
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j5BS+2d4i/ahG24dd/tHPN0fLUUFmd8jGntUYE3MrX0=;
        b=PFro2frEB2nnjaT+xNsK5Q3wdQWZ7twFJrLh38YxtkT74GK2enQ2y6cKAJ4WKcbql4
         XFgbzOJc65VxFVzxWqG/LzCdQUZBw3GtcO3vwQY7aXXE/MlUw+SlozCg1Ng0ue41L+lm
         Oen9YpYPDkXMj+GrXemGxCHwLDXsAHc44LdAmraivyg4LuSzIEL3X0j/g/Z5D6zEiXlj
         S565ZTJqEjxm2VUId1PTSUxL+AcGLXiYipT+vXhBcDi3ohAT7G7wb/Di6RyuBUMBn5hk
         mTgbR5F1OvyT3WrmC+NEdLZ7NbXP5mspGsVmXmYivcDnxX4Jc/mD4AA61E73J0H3GXiZ
         y55Q==
X-Gm-Message-State: AOAM530/d+gxkyyu45WsX3bs3M/I7hFqReMkycKLCzdvqNucmX1rHVgv
        szLlJAAdD3qBpayLJOjZ4IO43p7TzdxZ+2Z0oREChcHUwHXqP4J+jrbDqCl7JU+tw/VCKCqmUvA
        bsPBLFsdLGQLI
X-Received: by 2002:adf:b354:: with SMTP id k20mr18137770wrd.412.1590943256926;
        Sun, 31 May 2020 09:40:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0HkzqO5UvunzkIevQCS8DP8RYc0sFupFoLUZyl6tgkem6GKu1Knj86ln8moQU3+6mIDc99g==
X-Received: by 2002:adf:b354:: with SMTP id k20mr18137753wrd.412.1590943256749;
        Sun, 31 May 2020 09:40:56 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d15sm18060321wrq.30.2020.05.31.09.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:56 -0700 (PDT)
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
Subject: [PULL 25/25] tests/acceptance: refactor boot_linux to allow code reuse
Date:   Sun, 31 May 2020 18:38:46 +0200
Message-Id: <20200531163846.25363-26-philmd@redhat.com>
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

This patch moves image downloading functions to the separate class to allow
reusing them from record/replay tests.

Signed-off-by: Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <159073593167.20809.17582679291556188984.stgit@pasha-ThinkPad-X280>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/acceptance/boot_linux.py | 49 ++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/tests/acceptance/boot_linux.py b/tests/acceptance/boot_linux.py
index 075a386300..3aa57e88b0 100644
--- a/tests/acceptance/boot_linux.py
+++ b/tests/acceptance/boot_linux.py
@@ -26,22 +26,8 @@
 TCG_NOT_AVAILABLE = ACCEL_NOT_AVAILABLE_FMT % "TCG"
 
 
-class BootLinux(Test):
-    """
-    Boots a Linux system, checking for a successful initialization
-    """
-
-    timeout = 900
-    chksum = None
-
-    def setUp(self):
-        super(BootLinux, self).setUp()
-        self.vm.add_args('-smp', '2')
-        self.vm.add_args('-m', '1024')
-        self.prepare_boot()
-        self.prepare_cloudinit()
-
-    def prepare_boot(self):
+class BootLinuxBase(Test):
+    def download_boot(self):
         self.log.debug('Looking for and selecting a qemu-img binary to be '
                        'used to create the bootable snapshot image')
         # If qemu-img has been built, use it, otherwise the system wide one
@@ -60,17 +46,17 @@ def prepare_boot(self):
         if image_arch == 'ppc64':
             image_arch = 'ppc64le'
         try:
-            self.boot = vmimage.get(
+            boot = vmimage.get(
                 'fedora', arch=image_arch, version='31',
                 checksum=self.chksum,
                 algorithm='sha256',
                 cache_dir=self.cache_dirs[0],
                 snapshot_dir=self.workdir)
-            self.vm.add_args('-drive', 'file=%s' % self.boot.path)
         except:
             self.cancel('Failed to download/prepare boot image')
+        return boot.path
 
-    def prepare_cloudinit(self):
+    def download_cloudinit(self):
         self.log.info('Preparing cloudinit image')
         try:
             cloudinit_iso = os.path.join(self.workdir, 'cloudinit.iso')
@@ -81,9 +67,32 @@ def prepare_cloudinit(self):
                           # QEMU's hard coded usermode router address
                           phone_home_host='10.0.2.2',
                           phone_home_port=self.phone_home_port)
-            self.vm.add_args('-drive', 'file=%s,format=raw' % cloudinit_iso)
         except Exception:
             self.cancel('Failed to prepared cloudinit image')
+        return cloudinit_iso
+
+class BootLinux(BootLinuxBase):
+    """
+    Boots a Linux system, checking for a successful initialization
+    """
+
+    timeout = 900
+    chksum = None
+
+    def setUp(self):
+        super(BootLinux, self).setUp()
+        self.vm.add_args('-smp', '2')
+        self.vm.add_args('-m', '1024')
+        self.prepare_boot()
+        self.prepare_cloudinit()
+
+    def prepare_boot(self):
+        path = self.download_boot()
+        self.vm.add_args('-drive', 'file=%s' % path)
+
+    def prepare_cloudinit(self):
+        cloudinit_iso = self.download_cloudinit()
+        self.vm.add_args('-drive', 'file=%s,format=raw' % cloudinit_iso)
 
     def launch_and_wait(self):
         self.vm.set_console()
-- 
2.21.3

