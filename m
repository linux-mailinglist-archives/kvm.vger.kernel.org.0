Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE11E98EA
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgEaQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24028 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728206AbgEaQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZt0ZLdOqej/uZqX1RjbopdK4bZJfrI0RxnWBLQtXiE=;
        b=hGS+duYj1oyLsLVoz8a3tExgKn5AEctyfYX7iDxbwKR+DZ4796r9KzwJ5lIifE1eSVfoD3
        0kU32fnBGA6CGl8o6STtdnznjMwGki03Gqx/e9qyVHzWojY92Pvy/9ZAjpKtPSvG2pi1F5
        z1ZxTjeb4gW9OEvkhdQ5nJ0fNORiQJo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-nsr2OUb2NjuNAHz8khJDIw-1; Sun, 31 May 2020 12:39:26 -0400
X-MC-Unique: nsr2OUb2NjuNAHz8khJDIw-1
Received: by mail-wr1-f72.google.com with SMTP id e7so3139282wrp.14
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZt0ZLdOqej/uZqX1RjbopdK4bZJfrI0RxnWBLQtXiE=;
        b=D/5+8xDfzGW8dJY6WdJty2u4resHmzLm2Vbem1vSL5EBtjmxaQo8ujmEll7amRtiVU
         P9E6BXN3bXoygbOb48Yd1jUmvgSES3fdqDWjzzNZVUYJt8d9wROfXcp72kPm+VVTsm28
         YhBup/+N5bCeFfIfrI0G108FhfQ3YCyN0JychvSRilB7xA3mGO9vXzXjxgdDLn9zwqBx
         nl0OjN5WinxTdB2ce5ujR++Z6k9xD6mbhSjdUAoQgp9vN86NuIOg6SdE9qnbqLz5ye4p
         FR+Nul82J40VVi8Bl/d3wC1n7z9Hy70CAhvBEHztc3AaFEj3RQ1CR7Z7SPN82ZiYZ4Hh
         EWWw==
X-Gm-Message-State: AOAM530GPuL3eckYL7XPjCwwyEYr6Gd/8e6KGh+YqGlLzSw1+DDurscb
        eJ5qPI06WGwzmuL+p6oAlTOcIDWSj5oAgevlYJcML+oLaKKQNSOhKi7MJvStgw9YMFdsY/IbRvN
        qKWusWMRL/0vG
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr17434906wmj.164.1590943165707;
        Sun, 31 May 2020 09:39:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIDhiif77BD+2zEWATjb7OO4Dc+CJOan/ZMSwN3fOg17GLcrYigbcO8xtgQZm9pifBoM5w8w==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr17434886wmj.164.1590943165498;
        Sun, 31 May 2020 09:39:25 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d18sm17660706wrn.34.2020.05.31.09.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:24 -0700 (PDT)
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
Subject: [PULL 07/25] python: remove more instances of sys.version_info
Date:   Sun, 31 May 2020 18:38:28 +0200
Message-Id: <20200531163846.25363-8-philmd@redhat.com>
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

We guarantee 3.5+ everywhere; remove more dead checks. In general, try
to avoid using version checks and instead prefer to attempt behavior
when possible.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514035230.25756-1-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/analyze-migration.py             |  5 -----
 scripts/decodetree.py                    | 25 +++++++++---------------
 scripts/qmp/qmp-shell                    |  3 ---
 tests/docker/docker.py                   |  5 +++--
 tests/qemu-iotests/nbd-fault-injector.py |  5 +----
 5 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/scripts/analyze-migration.py b/scripts/analyze-migration.py
index 96a31d3974..95838cbff3 100755
--- a/scripts/analyze-migration.py
+++ b/scripts/analyze-migration.py
@@ -25,11 +25,6 @@
 import sys
 
 
-MIN_PYTHON = (3, 2)
-if sys.version_info < MIN_PYTHON:
-    sys.exit("Python %s.%s or later is required.\n" % MIN_PYTHON)
-
-
 def mkdir_p(path):
     try:
         os.makedirs(path)
diff --git a/scripts/decodetree.py b/scripts/decodetree.py
index 46ab917807..f9d204aa36 100755
--- a/scripts/decodetree.py
+++ b/scripts/decodetree.py
@@ -75,13 +75,6 @@ def output(*args):
         output_fd.write(a)
 
 
-if sys.version_info >= (3, 4):
-    re_fullmatch = re.fullmatch
-else:
-    def re_fullmatch(pat, str):
-        return re.match('^' + pat + '$', str)
-
-
 def output_autogen():
     output('/* This file is autogenerated by scripts/decodetree.py.  */\n\n')
 
@@ -428,18 +421,18 @@ def parse_field(lineno, name, toks):
     width = 0
     func = None
     for t in toks:
-        if re_fullmatch('!function=' + re_ident, t):
+        if re.fullmatch('!function=' + re_ident, t):
             if func:
                 error(lineno, 'duplicate function')
             func = t.split('=')
             func = func[1]
             continue
 
-        if re_fullmatch('[0-9]+:s[0-9]+', t):
+        if re.fullmatch('[0-9]+:s[0-9]+', t):
             # Signed field extract
             subtoks = t.split(':s')
             sign = True
-        elif re_fullmatch('[0-9]+:[0-9]+', t):
+        elif re.fullmatch('[0-9]+:[0-9]+', t):
             # Unsigned field extract
             subtoks = t.split(':')
             sign = False
@@ -488,11 +481,11 @@ def parse_arguments(lineno, name, toks):
     flds = []
     extern = False
     for t in toks:
-        if re_fullmatch('!extern', t):
+        if re.fullmatch('!extern', t):
             extern = True
             anyextern = True
             continue
-        if not re_fullmatch(re_ident, t):
+        if not re.fullmatch(re_ident, t):
             error(lineno, 'invalid argument set token "{0}"'.format(t))
         if t in flds:
             error(lineno, 'duplicate argument "{0}"'.format(t))
@@ -621,13 +614,13 @@ def parse_generic(lineno, is_format, name, toks):
             continue
 
         # 'Foo=%Bar' imports a field with a different name.
-        if re_fullmatch(re_ident + '=%' + re_ident, t):
+        if re.fullmatch(re_ident + '=%' + re_ident, t):
             (fname, iname) = t.split('=%')
             flds = add_field_byname(lineno, flds, fname, iname)
             continue
 
         # 'Foo=number' sets an argument field to a constant value
-        if re_fullmatch(re_ident + '=[+-]?[0-9]+', t):
+        if re.fullmatch(re_ident + '=[+-]?[0-9]+', t):
             (fname, value) = t.split('=')
             value = int(value)
             flds = add_field(lineno, flds, fname, ConstField(value))
@@ -635,7 +628,7 @@ def parse_generic(lineno, is_format, name, toks):
 
         # Pattern of 0s, 1s, dots and dashes indicate required zeros,
         # required ones, or dont-cares.
-        if re_fullmatch('[01.-]+', t):
+        if re.fullmatch('[01.-]+', t):
             shift = len(t)
             fms = t.replace('0', '1')
             fms = fms.replace('.', '0')
@@ -652,7 +645,7 @@ def parse_generic(lineno, is_format, name, toks):
             fixedmask = (fixedmask << shift) | fms
             undefmask = (undefmask << shift) | ubm
         # Otherwise, fieldname:fieldwidth
-        elif re_fullmatch(re_ident + ':s?[0-9]+', t):
+        elif re.fullmatch(re_ident + ':s?[0-9]+', t):
             (fname, flen) = t.split(':')
             sign = False
             if flen[0] == 's':
diff --git a/scripts/qmp/qmp-shell b/scripts/qmp/qmp-shell
index a01d31de1e..c5eef06f3f 100755
--- a/scripts/qmp/qmp-shell
+++ b/scripts/qmp/qmp-shell
@@ -77,9 +77,6 @@ import re
 sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
 from qemu import qmp
 
-if sys.version_info[0] == 2:
-    input = raw_input
-
 class QMPCompleter(list):
     def complete(self, text, state):
         for cmd in self:
diff --git a/tests/docker/docker.py b/tests/docker/docker.py
index d8268c1111..5a9735db78 100755
--- a/tests/docker/docker.py
+++ b/tests/docker/docker.py
@@ -258,12 +258,13 @@ def _kill_instances(self, *args, **kwargs):
         return self._do_kill_instances(True)
 
     def _output(self, cmd, **kwargs):
-        if sys.version_info[1] >= 6:
+        try:
             return subprocess.check_output(self._command + cmd,
                                            stderr=subprocess.STDOUT,
                                            encoding='utf-8',
                                            **kwargs)
-        else:
+        except TypeError:
+            # 'encoding' argument was added in 3.6+
             return subprocess.check_output(self._command + cmd,
                                            stderr=subprocess.STDOUT,
                                            **kwargs).decode('utf-8')
diff --git a/tests/qemu-iotests/nbd-fault-injector.py b/tests/qemu-iotests/nbd-fault-injector.py
index 588d62aebf..78f42c4214 100755
--- a/tests/qemu-iotests/nbd-fault-injector.py
+++ b/tests/qemu-iotests/nbd-fault-injector.py
@@ -47,10 +47,7 @@
 import socket
 import struct
 import collections
-if sys.version_info.major >= 3:
-    import configparser
-else:
-    import ConfigParser as configparser
+import configparser
 
 FAKE_DISK_SIZE = 8 * 1024 * 1024 * 1024 # 8 GB
 
-- 
2.21.3

