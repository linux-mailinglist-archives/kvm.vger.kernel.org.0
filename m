Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9438456C33
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhKSJUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:20:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbhKSJUR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:20:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637313435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlIlecnzhaAQeRZZJuozVjF80LuOMxu5Kmn9TZdjFTQ=;
        b=cj9F9k/AzxgsZxJJqtg8A5CRXlP+6HUf9EwZFcWIxSYxRx65ijC/0FRzeB+bxkryTIa/q7
        BWyHDBgk67UD0cyBkT5/h7lvRNoktJa7M+SuEJOKGtmkbgKhKRUmB+Q8qQDJXYWByoOU8U
        DLGCz46zw597ANYAf6ppgHNEzfiaLXA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Oz84Wi1yOeqXIoXyS6w_zA-1; Fri, 19 Nov 2021 04:17:14 -0500
X-MC-Unique: Oz84Wi1yOeqXIoXyS6w_zA-1
Received: by mail-wr1-f72.google.com with SMTP id v18-20020a5d5912000000b001815910d2c0so1627113wrd.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 01:17:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlIlecnzhaAQeRZZJuozVjF80LuOMxu5Kmn9TZdjFTQ=;
        b=BgACE1Sv8F7xWzmlWBsdyLYRWKgmsc2KZyDZbJvpIYNr3jALN5JeMNXoP3cWLX/RKb
         74TE+0T/PKAG1IEArbMOI1WbktBHnLCHRBCSDjrJDpLmC1Smj1bneVNrmsLkZIMMJeI8
         q/hSjk/0JmIHukY2sTte6Pxw62WuYZYgn3IzoUa5v0YNIuggC7hdktxiKlRzl6zlBiwY
         pCjw0PfGoVdR2ctGMaAVVal55+x9VgcVHy9MxyaY+zaMhXT05iJZ1ZZsjxuYx99/+GvE
         r7jByV9D2SOZgJUdQuHQkNXSyUi97jmnYGgYBrlKw6iWRBjq8zL4mp9G1pXvZJqO8m+f
         LTDw==
X-Gm-Message-State: AOAM533V2dzY0aM/5WIjLG5r2hfrw2+fdeoZd+QxwfnksV0FhbM96WFz
        Q3Brlsx6OfgN9upr2vR0G0c67jYmy4GHAFJdc7AMq1v9/4Wh8QLuO4J3zm6z0jsN/xV14ZceJm5
        KeCLygZ4xdwX/
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr5442728wri.308.1637313432820;
        Fri, 19 Nov 2021 01:17:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuuy5ZcKAtX3G+Y6lbyhVFc1uLMOQW6OLp6hdOWYScK9KF7wvUtEbMVxgqY5w7QfaBtY2WAw==
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr5442683wri.308.1637313432573;
        Fri, 19 Nov 2021 01:17:12 -0800 (PST)
Received: from x1w.. (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id g13sm3206808wrd.57.2021.11.19.01.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 01:17:12 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, John Snow <jsnow@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Michael Roth <michael.roth@amd.com>, qemu-block@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH-for-6.2? v2 2/3] misc: Spell QEMU all caps
Date:   Fri, 19 Nov 2021 10:17:00 +0100
Message-Id: <20211119091701.277973-3-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119091701.277973-1-philmd@redhat.com>
References: <20211119091701.277973-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU should be written all caps.

Normally checkpatch.pl warns when it is not (see commit
9964d8f9422: "checkpatch: Add QEMU specific rule").

Replace Qemu -> QEMU.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 qapi/block-core.json                   | 2 +-
 python/qemu/machine/machine.py         | 2 +-
 scripts/checkpatch.pl                  | 2 +-
 scripts/render_block_graph.py          | 2 +-
 scripts/simplebench/bench-backup.py    | 4 ++--
 scripts/simplebench/bench_block_job.py | 2 +-
 target/hexagon/README                  | 2 +-
 tests/guest-debug/run-test.py          | 4 ++--
 tests/qemu-iotests/testenv.py          | 2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/qapi/block-core.json b/qapi/block-core.json
index 1d3dd9cb48e..1846a91873a 100644
--- a/qapi/block-core.json
+++ b/qapi/block-core.json
@@ -1839,7 +1839,7 @@
 #
 # @id: Block graph node identifier. This @id is generated only for
 #      x-debug-query-block-graph and does not relate to any other identifiers in
-#      Qemu.
+#      QEMU.
 #
 # @type: Type of graph node. Can be one of block-backend, block-job or
 #        block-driver-state.
diff --git a/python/qemu/machine/machine.py b/python/qemu/machine/machine.py
index a487c397459..627c9013946 100644
--- a/python/qemu/machine/machine.py
+++ b/python/qemu/machine/machine.py
@@ -122,7 +122,7 @@ def __init__(self,
         @param console_log: (optional) path to console log file
         @param log_dir: where to create and keep log files
         @param qmp_timer: (optional) default QMP socket timeout
-        @note: Qemu process is not started until launch() is used.
+        @note: QEMU process is not started until launch() is used.
         '''
         # pylint: disable=too-many-arguments
 
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cb8eff233e0..aedf9beaed0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2910,7 +2910,7 @@ sub process {
 			ERROR("use QEMU instead of Qemu or QEmu\n" . $herecurr);
 		}
 
-# Qemu error function tests
+# QEMU error function tests
 
 	# Find newlines in error messages
 	my $qemu_error_funcs = qr{error_setg|
diff --git a/scripts/render_block_graph.py b/scripts/render_block_graph.py
index da6acf050d1..3147b0b843b 100755
--- a/scripts/render_block_graph.py
+++ b/scripts/render_block_graph.py
@@ -1,6 +1,6 @@
 #!/usr/bin/env python3
 #
-# Render Qemu Block Graph
+# Render QEMU Block Graph
 #
 # Copyright (c) 2018 Virtuozzo International GmbH. All rights reserved.
 #
diff --git a/scripts/simplebench/bench-backup.py b/scripts/simplebench/bench-backup.py
index 5a0675c593c..ad37af3e719 100755
--- a/scripts/simplebench/bench-backup.py
+++ b/scripts/simplebench/bench-backup.py
@@ -183,7 +183,7 @@ def __call__(self, parser, namespace, values, option_string=None):
     mirror               use mirror job instead of backup''',
                                 formatter_class=argparse.RawTextHelpFormatter)
     p.add_argument('--env', nargs='+', help='''\
-Qemu binaries with labels and options, see below
+QEMU binaries with labels and options, see below
 "ENV format" section''',
                    action=ExtendAction)
     p.add_argument('--dir', nargs='+', help='''\
@@ -209,7 +209,7 @@ def __call__(self, parser, namespace, values, option_string=None):
     p.add_argument('--target-cache', help='''\
 Setup cache for target nodes. Options:
    direct: default, use O_DIRECT and aio=native
-   cached: use system cache (Qemu default) and aio=threads (Qemu default)
+   cached: use system cache (QEMU default) and aio=threads (QEMU default)
    both: generate two test cases for each src:dst pair''',
                    default='direct', choices=('direct', 'cached', 'both'))
 
diff --git a/scripts/simplebench/bench_block_job.py b/scripts/simplebench/bench_block_job.py
index a403c35b08f..ecbcd535bcb 100755
--- a/scripts/simplebench/bench_block_job.py
+++ b/scripts/simplebench/bench_block_job.py
@@ -36,7 +36,7 @@ def bench_block_job(cmd, cmd_args, qemu_args):
 
     cmd       -- qmp command to run block-job (like blockdev-backup)
     cmd_args  -- dict of qmp command arguments
-    qemu_args -- list of Qemu command line arguments, including path to Qemu
+    qemu_args -- list of QEMU command line arguments, including path to QEMU
                  binary
 
     Returns {'seconds': int} on success and {'error': str} on failure, dict may
diff --git a/target/hexagon/README b/target/hexagon/README
index 372e24747c9..b02dbbd1701 100644
--- a/target/hexagon/README
+++ b/target/hexagon/README
@@ -48,7 +48,7 @@ header files in <BUILD_DIR>/target/hexagon
         gen_tcg_func_table.py           -> tcg_func_table_generated.c.inc
         gen_helper_funcs.py             -> helper_funcs_generated.c.inc
 
-Qemu helper functions have 3 parts
+QEMU helper functions have 3 parts
     DEF_HELPER declaration indicates the signature of the helper
     gen_helper_<NAME> will generate a TCG call to the helper function
     The helper implementation
diff --git a/tests/guest-debug/run-test.py b/tests/guest-debug/run-test.py
index 2e58795a100..268a230ecc3 100755
--- a/tests/guest-debug/run-test.py
+++ b/tests/guest-debug/run-test.py
@@ -21,9 +21,9 @@
 
 def get_args():
     parser = argparse.ArgumentParser(description="A gdbstub test runner")
-    parser.add_argument("--qemu", help="Qemu binary for test",
+    parser.add_argument("--qemu", help="QEMU binary for test",
                         required=True)
-    parser.add_argument("--qargs", help="Qemu arguments for test")
+    parser.add_argument("--qargs", help="QEMU arguments for test")
     parser.add_argument("--binary", help="Binary to debug",
                         required=True)
     parser.add_argument("--test", help="GDB test script",
diff --git a/tests/qemu-iotests/testenv.py b/tests/qemu-iotests/testenv.py
index c33454fa685..b563b6d5e6d 100644
--- a/tests/qemu-iotests/testenv.py
+++ b/tests/qemu-iotests/testenv.py
@@ -157,7 +157,7 @@ def root(*names: str) -> str:
                 progs = sorted(glob.iglob(pattern))
                 self.qemu_prog = next(p for p in progs if isxfile(p))
             except StopIteration:
-                sys.exit("Not found any Qemu executable binary by pattern "
+                sys.exit("Not found any QEMU executable binary by pattern "
                          f"'{pattern}'")
 
         self.qemu_img_prog = os.getenv('QEMU_IMG_PROG', root('qemu-img'))
-- 
2.31.1

