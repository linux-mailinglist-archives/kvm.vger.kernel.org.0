Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772921E98F9
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgEaQkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30441 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgEaQkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeYhFc6juZkPrqvPgAt2uIQTGjMzeewfSJodiqWwwkw=;
        b=eH7e0ZLWybdf3pWLfmzvw7GWoIfXd2Jxw+SOGRqWpjrdV39Kj4AJiPWPLy/9GE8tJuDwKt
        uakpt1VF6m1RyYNPj5DfQUNoIWjXhm9/WL5ZZm1sLoEl5lz/NzPeb+xuIIxvvV1/+9vNOn
        jD01Pe9ebHjqgzcyIBNzS6gIQh4wdgs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-ikUSMSUfNVKDwYBrsbXVXA-1; Sun, 31 May 2020 12:40:32 -0400
X-MC-Unique: ikUSMSUfNVKDwYBrsbXVXA-1
Received: by mail-wr1-f71.google.com with SMTP id w16so3602493wru.18
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeYhFc6juZkPrqvPgAt2uIQTGjMzeewfSJodiqWwwkw=;
        b=n0YkNr6tw/d6uIc+j0htJaO1gQAHXwsyFjVQ9if+8R7jyBR+PhlJ1uMXKwJYIWu4AD
         vP2lZY+96I8F73TKJrF7m4hD6ElE9iIAXjZ6N0GpQgxt8iJGmVbWysF1dRfm10iv+6sR
         fx9TJMC0KE68BmA9JWsDfir8+Iukj2wa4pmcf7GsICVFabBrbV4yf0TFWlrRIDbmAM7z
         d26NU39M3CPaKHLg4A5yxNierHjUysnSMeann5IeDT3FGCNOny2OY7EGq7x8mTiwKwJt
         eSWK7iMNFCn9Hhu0uaGGzU4KYiS7p1QqpjFz/XCqtC2JxTJCd7/UocyGPcItvmlJr51X
         WRaw==
X-Gm-Message-State: AOAM532yFM0mOfFgVpSQySzHATokiXQtFrvLJKyfjRifpuaMnXGaCp2H
        Hbigik4nw9Adm15QsnIzqFE+Y3itKvAOtGYm/EAk/XFUk7hkdyI256xIwXMBaGQRWs/csGLqJgW
        rexqs14kkVHs5
X-Received: by 2002:a5d:628c:: with SMTP id k12mr17814513wru.211.1590943231325;
        Sun, 31 May 2020 09:40:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQhmvCd9JeaOCqg0GzXFrykGN6A9vNWGNP+OY36M63eNUdY7+avBRNroyItWUmvC8DxOTmCA==
X-Received: by 2002:a5d:628c:: with SMTP id k12mr17814494wru.211.1590943231095;
        Sun, 31 May 2020 09:40:31 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id q4sm9026212wma.47.2020.05.31.09.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:30 -0700 (PDT)
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
        Robert Foley <robert.foley@linaro.org>,
        Peter Puhov <peter.puhov@linaro.org>
Subject: [PULL 20/25] tests/vm: allow wait_ssh() to specify command
Date:   Sun, 31 May 2020 18:38:41 +0200
Message-Id: <20200531163846.25363-21-philmd@redhat.com>
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

From: Robert Foley <robert.foley@linaro.org>

This allows for waiting for completion of arbitrary commands.

Signed-off-by: Robert Foley <robert.foley@linaro.org>
Reviewed-by: Peter Puhov <peter.puhov@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200529203458.1038-7-robert.foley@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/vm/basevm.py | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/vm/basevm.py b/tests/vm/basevm.py
index 5a3ce42281..a80b616a08 100644
--- a/tests/vm/basevm.py
+++ b/tests/vm/basevm.py
@@ -320,24 +320,24 @@ def console_sshd_config(self, prompt):
     def print_step(self, text):
         sys.stderr.write("### %s ...\n" % text)
 
-    def wait_ssh(self, wait_root=False, seconds=300):
+    def wait_ssh(self, wait_root=False, seconds=300, cmd="exit 0"):
         # Allow more time for VM to boot under TCG.
         if not kvm_available(self.arch):
             seconds *= self.tcg_ssh_timeout_multiplier
         starttime = datetime.datetime.now()
         endtime = starttime + datetime.timedelta(seconds=seconds)
-        guest_up = False
+        cmd_success = False
         while datetime.datetime.now() < endtime:
-            if wait_root and self.ssh_root("exit 0") == 0:
-                guest_up = True
+            if wait_root and self.ssh_root(cmd) == 0:
+                cmd_success = True
                 break
-            elif self.ssh("exit 0") == 0:
-                guest_up = True
+            elif self.ssh(cmd) == 0:
+                cmd_success = True
                 break
             seconds = (endtime - datetime.datetime.now()).total_seconds()
             logging.debug("%ds before timeout", seconds)
             time.sleep(1)
-        if not guest_up:
+        if not cmd_success:
             raise Exception("Timeout while waiting for guest ssh")
 
     def shutdown(self):
-- 
2.21.3

