Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03041E98E8
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgEaQjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39439 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgEaQjU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z30VvxAdMFSGdKMqEcqqUvnaAOKiyK2ObUonHxxh/Vo=;
        b=G91Hfw6cDrhKjmYQ8htB13m1Y/EFdJRrDP3QcL776o4VMGwyzd1+NqengueqegaqSxcvEr
        eY1Rm1rhouc5cFof4UtGQmPzx73HNaiHOBOuIaM1wsgxQCFgQ3IKuIFVcD0ZHVh/rKmCpV
        kZdVjWazVlU5rQEHdI4LAhzIajRAnVw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-fiBnBJ54OxKCCP-CheTaXg-1; Sun, 31 May 2020 12:39:17 -0400
X-MC-Unique: fiBnBJ54OxKCCP-CheTaXg-1
Received: by mail-wr1-f70.google.com with SMTP id s7so3618524wrm.16
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z30VvxAdMFSGdKMqEcqqUvnaAOKiyK2ObUonHxxh/Vo=;
        b=bCUYFZyZ3xm5D8uqzvWgshqqffPg+q0IuwC5x87LusCkQwsHRy6cwlT2LJJTfDnhRv
         dpJK/heVJpvQErzPOHCP3CLpiNpu3CozKusAIWHfEBD1zh3LiqWcQ1WmBUXnqhzGkKcz
         tkcreVsyEY2lIHx9vwVU6vE0ublFBASJp1yHriwPFAeawPY4gGVD+M0mUh/0bqCofDdO
         cRGlDcZFR3jt9rTMKNsr+OZ8WbgrtCknyUT+HZln/4CX1ErG9OWKid1QwNgMFlZE3R4p
         DVGVjY2NW/0sIGQYwsFzF3TnNySj8g+ZdjvLVge6DUkC/ufuTKehZl8JAi7JGJZF20Pj
         b53g==
X-Gm-Message-State: AOAM531YI2JRtNoVnXplEfHkoY08b7PQx2Cjjp4HH0gJQdSfXyuXXzqW
        hWeLSHGv69Kmt2Qic4ICKDxINQTaH4JDItPICfyV7TFmqNTJmwk2l3f/QBkw7Zhb+CYR1y1HzzI
        qwc9mslesW3Ig
X-Received: by 2002:a1c:29c2:: with SMTP id p185mr16889178wmp.7.1590943155578;
        Sun, 31 May 2020 09:39:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOLd8dSnD3qnmQhUEm/Dn1hZEFh70mX5LIcVUN2qnXfZwKc4kvuMmAfTDZzOM7VoEzCzWu+g==
X-Received: by 2002:a1c:29c2:: with SMTP id p185mr16889160wmp.7.1590943155392;
        Sun, 31 May 2020 09:39:15 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id l204sm9390658wmf.19.2020.05.31.09.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:14 -0700 (PDT)
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
Subject: [PULL 05/25] scripts/modules/module_block: Use Python 3 interpreter & add pseudo-main
Date:   Sun, 31 May 2020 18:38:26 +0200
Message-Id: <20200531163846.25363-6-philmd@redhat.com>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: John Snow <jsnow@redhat.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Message-Id: <20200512103238.7078-6-philmd@redhat.com>
---
 scripts/modules/module_block.py | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/scripts/modules/module_block.py b/scripts/modules/module_block.py
index f23191fac1..1109df827d 100644
--- a/scripts/modules/module_block.py
+++ b/scripts/modules/module_block.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Module information generator
 #
@@ -80,19 +80,20 @@ def print_bottom(fheader):
 #endif
 ''')
 
-# First argument: output file
-# All other arguments: modules source files (.c)
-output_file = sys.argv[1]
-with open(output_file, 'w') as fheader:
-    print_top(fheader)
+if __name__ == '__main__':
+    # First argument: output file
+    # All other arguments: modules source files (.c)
+    output_file = sys.argv[1]
+    with open(output_file, 'w') as fheader:
+        print_top(fheader)
 
-    for filename in sys.argv[2:]:
-        if os.path.isfile(filename):
-            process_file(fheader, filename)
-        else:
-            print("File " + filename + " does not exist.", file=sys.stderr)
-            sys.exit(1)
+        for filename in sys.argv[2:]:
+            if os.path.isfile(filename):
+                process_file(fheader, filename)
+            else:
+                print("File " + filename + " does not exist.", file=sys.stderr)
+                sys.exit(1)
 
-    print_bottom(fheader)
+        print_bottom(fheader)
 
-sys.exit(0)
+    sys.exit(0)
-- 
2.21.3

