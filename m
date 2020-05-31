Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86371E98FE
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgEaQkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728397AbgEaQkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EasuWk6m0BoiPz6F4JYRddSpg6v+5LpuTCzT8S/4Pwk=;
        b=G8HQgLfKC5SofY1e2cEjvW3B+Ve5JSLdPx3WLl9MTJ1v8BlWeVDYpPvmhlTNy0msBq/DkH
        woPVnwBUxGAqsE7A6K6Mav14AgcgpzRKCxV1Lv3/DPkC/JdBZjNs5BHpllsBkaVTalJk+B
        svpiWxwE9t7fBzwcwDuh0NiI4YY27VU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-qvGR3IAvOauNMX844ZCQLw-1; Sun, 31 May 2020 12:40:48 -0400
X-MC-Unique: qvGR3IAvOauNMX844ZCQLw-1
Received: by mail-wr1-f71.google.com with SMTP id p9so2660168wrx.10
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EasuWk6m0BoiPz6F4JYRddSpg6v+5LpuTCzT8S/4Pwk=;
        b=DNevcA00j04byQdJejAqn1kOpXb2oGDekEbmsL7tpRNNdlF+FLf5oMzxkroG17VPzA
         +mSo361N0sq5aHLw335pbXXfAEm6k/M5dY+pDs3Bi9hK6FdsH34bMEMCCMGNSOEunlgU
         McNk2B17eQw5a2eX3AW8nx6Eae6TYJt+AjQZ73YzU1OtsGE2zaY+PoAVvi+mcG4FO5y9
         91n9zMdjBrwOyB22XG30TOYgG53wqqcXsFxNjV4z1WQS43fYTvvpSaYZDqaeAB3Pztyb
         4dx3QC0aQFmkhqEKeSUm9WTalLS2C2hXrFTbUOZh5VDt/bpr9pvFvkLjWjZUNYcTtRI+
         hzwg==
X-Gm-Message-State: AOAM530cgNkWjZN5WHPsXWS8PTH8NlVcXIMrBzuRECUcW9bVb+T5UOBk
        TcjcqYGSq9hzWH5RV/IEPtQmvfzIOCuq9WOUwQ9YhKtM3PhHb+/iaQWg3UBpy7F4gLU6Vkghh1m
        /HE4zzMKTFI1V
X-Received: by 2002:a05:600c:2147:: with SMTP id v7mr17849642wml.101.1590943246923;
        Sun, 31 May 2020 09:40:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyI6LDvlfCZPK9wwqdms85yxMc4JSYt7zQlkz8yplSypRhy6I1JyG6cFZgTmZSSCpBd31os2g==
X-Received: by 2002:a05:600c:2147:: with SMTP id v7mr17849613wml.101.1590943246702;
        Sun, 31 May 2020 09:40:46 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id a6sm17634729wrn.38.2020.05.31.09.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:46 -0700 (PDT)
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
        Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>,
        Willian Rampazzo <willianr@redhat.com>
Subject: [PULL 23/25] tests/acceptance: allow console interaction with specific VMs
Date:   Sun, 31 May 2020 18:38:44 +0200
Message-Id: <20200531163846.25363-24-philmd@redhat.com>
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

Console interaction in avocado scripts was possible only with single
default VM.
This patch modifies the function parameters to allow passing a specific
VM as a parameter to interact with it.

Signed-off-by: Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>
Reviewed-by: Willian Rampazzo <willianr@redhat.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <159073587933.20809.5122618715976660635.stgit@pasha-ThinkPad-X280>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 tests/acceptance/avocado_qemu/__init__.py | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tests/acceptance/avocado_qemu/__init__.py b/tests/acceptance/avocado_qemu/__init__.py
index 59e7b4f763..77d1c1d9ff 100644
--- a/tests/acceptance/avocado_qemu/__init__.py
+++ b/tests/acceptance/avocado_qemu/__init__.py
@@ -69,13 +69,15 @@ def pick_default_qemu_bin(arch=None):
 
 
 def _console_interaction(test, success_message, failure_message,
-                         send_string, keep_sending=False):
+                         send_string, keep_sending=False, vm=None):
     assert not keep_sending or send_string
-    console = test.vm.console_socket.makefile()
+    if vm is None:
+        vm = test.vm
+    console = vm.console_socket.makefile()
     console_logger = logging.getLogger('console')
     while True:
         if send_string:
-            test.vm.console_socket.sendall(send_string.encode())
+            vm.console_socket.sendall(send_string.encode())
             if not keep_sending:
                 send_string = None # send only once
         msg = console.readline().strip()
@@ -115,7 +117,8 @@ def interrupt_interactive_console_until_pattern(test, success_message,
     _console_interaction(test, success_message, failure_message,
                          interrupt_string, True)
 
-def wait_for_console_pattern(test, success_message, failure_message=None):
+def wait_for_console_pattern(test, success_message, failure_message=None,
+                             vm=None):
     """
     Waits for messages to appear on the console, while logging the content
 
@@ -125,7 +128,7 @@ def wait_for_console_pattern(test, success_message, failure_message=None):
     :param success_message: if this message appears, test succeeds
     :param failure_message: if this message appears, test fails
     """
-    _console_interaction(test, success_message, failure_message, None)
+    _console_interaction(test, success_message, failure_message, None, vm=vm)
 
 def exec_command_and_wait_for_pattern(test, command,
                                       success_message, failure_message=None):
-- 
2.21.3

