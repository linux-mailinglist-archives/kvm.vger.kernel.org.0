Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A921CF27F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgELKcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:32:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34903 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729429AbgELKcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o+SFxNiQTSKSfzcy81S2xitOyf6spOQEd9fCWLhnCeY=;
        b=YTX1vGjcF6s24R7sSz0yGitSRFfWV6lJFWD7VA0ILNRdtZJVYnpcYAb63Bwpqe0ooJpjwJ
        9yFuWJ9lS4ywgqj+sV1msAbaTf/DsBqeI7M2evwYYWuWTQYrgNH7K5G/DTUoTjp0DYKVXj
        LTvCIQUWjsn/Icl4+tdjFI/4pAQbvuA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-MgccDOUEOceGvkulRkuBgg-1; Tue, 12 May 2020 06:32:48 -0400
X-MC-Unique: MgccDOUEOceGvkulRkuBgg-1
Received: by mail-wm1-f71.google.com with SMTP id e15so935652wme.1
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+SFxNiQTSKSfzcy81S2xitOyf6spOQEd9fCWLhnCeY=;
        b=gm/gYdwMAhiOyAP8GaPYC80pouJUjd51ZlV7iF9ot7Yvz9+hDQ7+4LaSUrG5yu3Qt/
         hrR3efkI9WjoPAI2XQc9bDeqIyfR1w7BZkrKTk2qAKzAoOvMKaCxE5c0XKfwISi/KdfH
         QoGA4TddStjCsNuVsEUBl2hQi/tpzNw2nRmicqTMb2DSvmnesQ5Qw0Ic5O98PEM6Dov/
         HVO1veenmRc9pRdEaMYP9KxbZRwYuV/WTno80mSeDWLKo5QrhPtBfXweNQD8e/CGUy8U
         0LWZVt8b9g/uhGquA6mxMrAUWAKNXFX64c9/cDsgrV9TLV+MSgt8Eacz2l3ctewIqOV5
         yHiA==
X-Gm-Message-State: AGi0PuYVdB/vbf+b0WTzPsCBkh+aNwNoIDNnGC8U0cQvwCCDmPcO9iJL
        dJND69jLCUCvoJrE3s3AuE7lpnMInhjWsvXSP9qUn1OXZJO3h3l/SGML37mpk4uXP+JGbTlNXoi
        PdAS0DLoQQ0tJ
X-Received: by 2002:adf:cc81:: with SMTP id p1mr23275929wrj.192.1589279565427;
        Tue, 12 May 2020 03:32:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypIdq6xklNhE6zF2ex6riiZ2WEeaRBZwdbLSVo8fxAyW06Ghhyjcwp0kiKh5i+SK1pgUYQQIhQ==
X-Received: by 2002:adf:cc81:: with SMTP id p1mr23275905wrj.192.1589279565172;
        Tue, 12 May 2020 03:32:45 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id u16sm21863464wrq.17.2020.05.12.03.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:32:44 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v4 1/6] scripts/qemugdb: Remove shebang header
Date:   Tue, 12 May 2020 12:32:33 +0200
Message-Id: <20200512103238.7078-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
References: <20200512103238.7078-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

These scripts are loaded as plugin by GDB (and they don't
have any __main__ entry point). Remove the shebang header.

Acked-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 scripts/qemugdb/__init__.py  | 3 +--
 scripts/qemugdb/aio.py       | 3 +--
 scripts/qemugdb/coroutine.py | 3 +--
 scripts/qemugdb/mtree.py     | 4 +---
 scripts/qemugdb/tcg.py       | 1 -
 scripts/qemugdb/timers.py    | 1 -
 6 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/scripts/qemugdb/__init__.py b/scripts/qemugdb/__init__.py
index 969f552b26..da8ff612e5 100644
--- a/scripts/qemugdb/__init__.py
+++ b/scripts/qemugdb/__init__.py
@@ -1,5 +1,4 @@
-#!/usr/bin/python
-
+#
 # GDB debugging support
 #
 # Copyright (c) 2015 Linaro Ltd
diff --git a/scripts/qemugdb/aio.py b/scripts/qemugdb/aio.py
index 2ba00c4444..d7c1ba0c28 100644
--- a/scripts/qemugdb/aio.py
+++ b/scripts/qemugdb/aio.py
@@ -1,5 +1,4 @@
-#!/usr/bin/python
-
+#
 # GDB debugging support: aio/iohandler debug
 #
 # Copyright (c) 2015 Red Hat, Inc.
diff --git a/scripts/qemugdb/coroutine.py b/scripts/qemugdb/coroutine.py
index 41e079d0e2..db61389022 100644
--- a/scripts/qemugdb/coroutine.py
+++ b/scripts/qemugdb/coroutine.py
@@ -1,5 +1,4 @@
-#!/usr/bin/python
-
+#
 # GDB debugging support
 #
 # Copyright 2012 Red Hat, Inc. and/or its affiliates
diff --git a/scripts/qemugdb/mtree.py b/scripts/qemugdb/mtree.py
index 3030a60d3f..8fe42c3c12 100644
--- a/scripts/qemugdb/mtree.py
+++ b/scripts/qemugdb/mtree.py
@@ -1,5 +1,4 @@
-#!/usr/bin/python
-
+#
 # GDB debugging support
 #
 # Copyright 2012 Red Hat, Inc. and/or its affiliates
@@ -84,4 +83,3 @@ def print_item(self, ptr, offset = gdb.Value(0), level = 0):
         while not isnull(subregion):
             self.print_item(subregion, addr, level)
             subregion = subregion['subregions_link']['tqe_next']
-
diff --git a/scripts/qemugdb/tcg.py b/scripts/qemugdb/tcg.py
index 18880fc9a7..16c03c06a9 100644
--- a/scripts/qemugdb/tcg.py
+++ b/scripts/qemugdb/tcg.py
@@ -1,4 +1,3 @@
-#!/usr/bin/python
 # -*- coding: utf-8 -*-
 #
 # GDB debugging support, TCG status
diff --git a/scripts/qemugdb/timers.py b/scripts/qemugdb/timers.py
index f0e132d27a..46537b27cf 100644
--- a/scripts/qemugdb/timers.py
+++ b/scripts/qemugdb/timers.py
@@ -1,4 +1,3 @@
-#!/usr/bin/python
 # -*- coding: utf-8 -*-
 # GDB debugging support
 #
-- 
2.21.3

