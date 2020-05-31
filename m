Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7A1E98F2
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgEaQkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43160 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728206AbgEaQkC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGJCD3WtpxESapRsldRYyPkWs2bF0ehM3T5fdkPvFFk=;
        b=C45LUFNqJlE2qEv2/SDgWA2nPEvqetr/nSchzmK20grBNe3GbDEOUkxmOZjlz9xTseQkks
        Y+1mSgLEhFGgSYSU0V1L5tgoEYOtbMNDyfUAL+mrmOk7Oejh08XtCiqzs+X8kBqA3JBsMR
        1iDBhxsuEjnbSKd/Cm07fAdd2uPfCIs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-IBVCgHBlMcC19b_bCSGFjQ-1; Sun, 31 May 2020 12:39:57 -0400
X-MC-Unique: IBVCgHBlMcC19b_bCSGFjQ-1
Received: by mail-wr1-f71.google.com with SMTP id j16so3579026wre.22
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZGJCD3WtpxESapRsldRYyPkWs2bF0ehM3T5fdkPvFFk=;
        b=VlmuqqUm6M+dD8SybecqoghetqRC+nGkKEYSU23yOV/VDS8fGxOAIiCKQvkjRKrLPe
         cqkOdtn+isu4kKOVrXDJ51W98pJjIz3nOxz8C+ZQG7v549wYQcifOPUrT5K/CRNpjQL2
         L1Wn17nEJf0iCnkFnEpyfQY04/YdHMDu4FYHukuGu91wQ9KK2qKPE9QDiQGgHQJhCrnD
         7ZDdj4Q6W6QS6mg6WZ9A3+nhShl8tdWptMVowioMzHF25R17DM7I/3IswG2sqlRpUjWF
         WCzUo28l3b/RBv+Md4KZhQKBTHYkgMMv3aOesP1OFjlFtSgrDiM3Bz5YKYoMSL9D/Jmy
         bW4Q==
X-Gm-Message-State: AOAM530WCxXUEp9QoEIlqMMSalEkUwg+GwtPmnjRMVpuGb9sgBPzWBYg
        qo58G7LGaV4UGEdtlMXj2NqiVylgWbZOiII6YyPZVGdCV3uwNceYnWQVRJlViGkGQJl4o0DXVQw
        L5B3uh2E2Zpzx
X-Received: by 2002:a7b:c201:: with SMTP id x1mr17564251wmi.58.1590943195858;
        Sun, 31 May 2020 09:39:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOEXwNNL/vFr901ND3jDCNFYuC5Y9R8OiJUy3KhCsCICPZclc2nGHqbOnLRtzqs9ghv2iSEA==
X-Received: by 2002:a7b:c201:: with SMTP id x1mr17564238wmi.58.1590943195679;
        Sun, 31 May 2020 09:39:55 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d13sm8387945wmb.39.2020.05.31.09.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:55 -0700 (PDT)
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
        John Snow <jsnow@redhat.com>
Subject: [PULL 13/25] python/qemu: fix socket.makefile() typing
Date:   Sun, 31 May 2020 18:38:34 +0200
Message-Id: <20200531163846.25363-14-philmd@redhat.com>
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

From: John Snow <jsnow@redhat.com>

Note:

A bug in typeshed (https://github.com/python/typeshed/issues/3977)
misinterprets the type of makefile(). Work around this by explicitly
stating that we are opening a text-mode file.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-13-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/qmp.py   | 10 +++++++---
 python/qemu/qtest.py | 12 ++++++++----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/python/qemu/qmp.py b/python/qemu/qmp.py
index 6ae7693965..73d49050ed 100644
--- a/python/qemu/qmp.py
+++ b/python/qemu/qmp.py
@@ -11,6 +11,10 @@
 import errno
 import socket
 import logging
+from typing import (
+    Optional,
+    TextIO,
+)
 
 
 class QMPError(Exception):
@@ -61,7 +65,7 @@ def __init__(self, address, server=False, nickname=None):
         self.__events = []
         self.__address = address
         self.__sock = self.__get_sock()
-        self.__sockfile = None
+        self.__sockfile: Optional[TextIO] = None
         self._nickname = nickname
         if self._nickname:
             self.logger = logging.getLogger('QMP').getChild(self._nickname)
@@ -157,7 +161,7 @@ def connect(self, negotiate=True):
         @raise QMPCapabilitiesError if fails to negotiate capabilities
         """
         self.__sock.connect(self.__address)
-        self.__sockfile = self.__sock.makefile()
+        self.__sockfile = self.__sock.makefile(mode='r')
         if negotiate:
             return self.__negotiate_capabilities()
         return None
@@ -180,7 +184,7 @@ def accept(self, timeout=15.0):
         """
         self.__sock.settimeout(timeout)
         self.__sock, _ = self.__sock.accept()
-        self.__sockfile = self.__sock.makefile()
+        self.__sockfile = self.__sock.makefile(mode='r')
         return self.__negotiate_capabilities()
 
     def cmd_obj(self, qmp_cmd):
diff --git a/python/qemu/qtest.py b/python/qemu/qtest.py
index 7943487c2b..4c88590eb0 100644
--- a/python/qemu/qtest.py
+++ b/python/qemu/qtest.py
@@ -19,6 +19,7 @@
 
 import socket
 import os
+from typing import Optional, TextIO
 
 from .machine import QEMUMachine
 
@@ -40,7 +41,7 @@ class QEMUQtestProtocol:
     def __init__(self, address, server=False):
         self._address = address
         self._sock = self._get_sock()
-        self._sockfile = None
+        self._sockfile: Optional[TextIO] = None
         if server:
             self._sock.bind(self._address)
             self._sock.listen(1)
@@ -59,7 +60,7 @@ def connect(self):
         @raise socket.error on socket connection errors
         """
         self._sock.connect(self._address)
-        self._sockfile = self._sock.makefile()
+        self._sockfile = self._sock.makefile(mode='r')
 
     def accept(self):
         """
@@ -68,7 +69,7 @@ def accept(self):
         @raise socket.error on socket connection errors
         """
         self._sock, _ = self._sock.accept()
-        self._sockfile = self._sock.makefile()
+        self._sockfile = self._sock.makefile(mode='r')
 
     def cmd(self, qtest_cmd):
         """
@@ -76,6 +77,7 @@ def cmd(self, qtest_cmd):
 
         @param qtest_cmd: qtest command text to be sent
         """
+        assert self._sockfile is not None
         self._sock.sendall((qtest_cmd + "\n").encode('utf-8'))
         resp = self._sockfile.readline()
         return resp
@@ -83,7 +85,9 @@ def cmd(self, qtest_cmd):
     def close(self):
         """Close this socket."""
         self._sock.close()
-        self._sockfile.close()
+        if self._sockfile:
+            self._sockfile.close()
+            self._sockfile = None
 
     def settimeout(self, timeout):
         """Set a timeout, in seconds."""
-- 
2.21.3

