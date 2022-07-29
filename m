Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B60585040
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiG2NBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiG2NBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:01:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A84C41D35
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlYPqOwXF8kEqxkm8xop27cvQNh7ZouuY1kfQAMVKXY=;
        b=fbLYysWkdIRF61kN8MsYtbjhg1NwUY3OrhpblMBMTLQJrMoCb/FzKe4a4PXJhn4USx3Mxb
        qH+u5p9z2J/00uOAY0Qs4qpvWtqvnlD/sa4zKOXBTr92OahB+uK+sdyUkJvri0ZZ942RPQ
        WoH13tzet0FmEbvaYJVZc6HQZC/9jgU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-NYTDOgrTNfuIYcfbwtKTrA-1; Fri, 29 Jul 2022 09:01:34 -0400
X-MC-Unique: NYTDOgrTNfuIYcfbwtKTrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45970811E76;
        Fri, 29 Jul 2022 13:01:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 232482026D64;
        Fri, 29 Jul 2022 13:01:22 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [RFC v2 03/10] static-analyzer: Support adding tests to checks
Date:   Fri, 29 Jul 2022 14:00:32 +0100
Message-Id: <20220729130040.1428779-4-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce an add_check_tests() method to add output-comparison tests to
checks, and add some tests to the "return-value-never-used" check.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 static-analyzer.py                         | 133 ++++++++++++++++++++-
 static_analyzer/__init__.py                |  39 +++++-
 static_analyzer/return_value_never_used.py | 103 ++++++++++++++++
 3 files changed, 267 insertions(+), 8 deletions(-)

diff --git a/static-analyzer.py b/static-analyzer.py
index 3ade422dbf..16e331000d 100755
--- a/static-analyzer.py
+++ b/static-analyzer.py
@@ -11,17 +11,26 @@
 import subprocess
 import sys
 import re
-from argparse import ArgumentParser, Namespace, RawDescriptionHelpFormatter
+from argparse import (
+    Action,
+    ArgumentParser,
+    Namespace,
+    RawDescriptionHelpFormatter,
+)
 from multiprocessing import Pool
 from pathlib import Path
+from tempfile import TemporaryDirectory
 import textwrap
 import time
+from traceback import print_exc
 from typing import (
+    Callable,
     Iterable,
     Iterator,
     List,
     Mapping,
     NoReturn,
+    Optional,
     Sequence,
     Union,
 )
@@ -37,7 +46,7 @@
 def parse_args() -> Namespace:
 
     available_checks = "\n".join(
-        f"  {name}   {' '.join((CHECKS[name].__doc__ or '').split())}"
+        f"  {name}   {' '.join((CHECKS[name].checker.__doc__ or '').split())}"
         for name in sorted(CHECKS)
     )
 
@@ -134,14 +143,37 @@ def parse_args() -> Namespace:
         help="Do everything except actually running the checks.",
     )
 
+    dev_options.add_argument(
+        "--test",
+        action=TestAction,
+        nargs=0,
+        help="Run tests for all checks and exit.",
+    )
+
     # parse arguments
 
-    args = parser.parse_args()
+    try:
+        args = parser.parse_args()
+    except TestSentinelError:
+        # --test was specified
+        if len(sys.argv) > 2:
+            parser.error("--test must be given alone")
+        return Namespace(test=True)
+
     args.check_names = sorted(set(args.check_names or CHECKS))
 
     return args
 
 
+class TestAction(Action):
+    def __call__(self, parser, namespace, values, option_string=None):
+        raise TestSentinelError
+
+
+class TestSentinelError(Exception):
+    pass
+
+
 # ---------------------------------------------------------------------------- #
 # Main
 
@@ -150,7 +182,11 @@ def main() -> int:
 
     args = parse_args()
 
-    if args.profile:
+    if args.test:
+
+        return test()
+
+    elif args.profile:
 
         import cProfile
         import pstats
@@ -170,6 +206,18 @@ def main() -> int:
         return analyze(args)
 
 
+def test() -> int:
+
+    for (check_name, check) in CHECKS.items():
+        for group in check.test_groups:
+            for input in group.inputs:
+                run_test(
+                    check_name, group.location, input, group.expected_output
+                )
+
+    return 0
+
+
 def analyze(args: Namespace) -> int:
 
     tr_units = get_translation_units(args)
@@ -247,6 +295,7 @@ class TranslationUnit:
     build_command: str
     system_include_paths: Sequence[str]
     check_names: Sequence[str]
+    custom_printer: Optional[Callable[[str], None]]
 
 
 def get_translation_units(args: Namespace) -> Sequence["TranslationUnit"]:
@@ -264,6 +313,7 @@ def get_translation_units(args: Namespace) -> Sequence["TranslationUnit"]:
             build_command=cmd["command"],
             system_include_paths=system_include_paths,
             check_names=args.check_names,
+            custom_printer=None,
         )
         for cmd in compile_commands
     )
@@ -380,7 +430,7 @@ def analyze_translation_unit(tr_unit: TranslationUnit) -> bool:
 
     try:
         for name in tr_unit.check_names:
-            CHECKS[name](check_context)
+            CHECKS[name].checker(check_context)
     except Exception as e:
         raise RuntimeError(f"Error analyzing {check_context._rel_path}") from e
 
@@ -428,7 +478,9 @@ def get_check_context(tr_unit: TranslationUnit) -> CheckContext:
         except clang.cindex.TranslationUnitLoadError as e:
             raise RuntimeError(f"Failed to load {rel_path}") from e
 
-    if sys.stdout.isatty():
+    if tr_unit.custom_printer is not None:
+        printer = tr_unit.custom_printer
+    elif sys.stdout.isatty():
         # add padding to fully overwrite progress message
         printer = lambda s: print(s.ljust(50))
     else:
@@ -457,6 +509,75 @@ def get_check_context(tr_unit: TranslationUnit) -> CheckContext:
     return check_context
 
 
+# ---------------------------------------------------------------------------- #
+# Tests
+
+
+def run_test(
+    check_name: str, location: str, input: str, expected_output: str
+) -> None:
+
+    with TemporaryDirectory() as temp_dir:
+
+        os.chdir(temp_dir)
+
+        input_path = Path(temp_dir) / "file.c"
+        input_path.write_text(input)
+
+        actual_output_list = []
+
+        tu_context = TranslationUnit(
+            absolute_path=str(input_path),
+            build_working_dir=str(input_path.parent),
+            build_command=f"cc {shlex.quote(str(input_path))}",
+            system_include_paths=[],
+            check_names=[check_name],
+            custom_printer=lambda s: actual_output_list.append(s + "\n"),
+        )
+
+        check_context = get_check_context(tu_context)
+
+        # analyze translation unit
+
+        try:
+
+            for name in tu_context.check_names:
+                CHECKS[name].checker(check_context)
+
+        except Exception:
+
+            print(
+                f"\033[0;31mTest defined at {location} raised an"
+                f" exception.\033[0m"
+            )
+            print(f"\033[0;31mInput:\033[0m")
+            print(input, end="")
+            print(f"\033[0;31mExpected output:\033[0m")
+            print(expected_output, end="")
+            print(f"\033[0;31mException:\033[0m")
+            print_exc(file=sys.stdout)
+            print(f"\033[0;31mAST:\033[0m")
+            check_context.print_tree(check_context.translation_unit.cursor)
+
+            sys.exit(1)
+
+        actual_output = "".join(actual_output_list)
+
+        if actual_output != expected_output:
+
+            print(f"\033[0;33mTest defined at {location} failed.\033[0m")
+            print(f"\033[0;33mInput:\033[0m")
+            print(input, end="")
+            print(f"\033[0;33mExpected output:\033[0m")
+            print(expected_output, end="")
+            print(f"\033[0;33mActual output:\033[0m")
+            print(actual_output, end="")
+            print(f"\033[0;33mAST:\033[0m")
+            check_context.print_tree(check_context.translation_unit.cursor)
+
+            sys.exit(3)
+
+
 # ---------------------------------------------------------------------------- #
 # Utilities
 
diff --git a/static_analyzer/__init__.py b/static_analyzer/__init__.py
index e6ca48d714..36028724b1 100644
--- a/static_analyzer/__init__.py
+++ b/static_analyzer/__init__.py
@@ -3,16 +3,20 @@
 from ctypes import CFUNCTYPE, c_int, py_object
 from dataclasses import dataclass
 from enum import Enum
+import inspect
 import os
 import os.path
 from pathlib import Path
 from importlib import import_module
+import textwrap
 from typing import (
     Any,
     Callable,
     Dict,
+    Iterable,
     List,
     Optional,
+    Sequence,
     Union,
 )
 
@@ -218,18 +222,49 @@ def print_tree(
 
 Checker = Callable[[CheckContext], None]
 
-CHECKS: Dict[str, Checker] = {}
+
+class CheckTestGroup:
+
+    inputs: Sequence[str]
+    expected_output: str
+
+    location: str
+
+    def __init__(self, inputs: Iterable[str], expected_output: str) -> None:
+        def reformat_string(s: str) -> str:
+            return "".join(
+                line + "\n" for line in textwrap.dedent(s).strip().splitlines()
+            )
+
+        self.inputs = [reformat_string(input) for input in inputs]
+        self.expected_output = reformat_string(expected_output)
+
+        caller = inspect.stack()[1]
+        self.location = f"{os.path.relpath(caller.filename)}:{caller.lineno}"
+
+
+@dataclass
+class Check:
+    checker: Checker
+    test_groups: List[CheckTestGroup]
+
+
+CHECKS: Dict[str, Check] = {}
 
 
 def check(name: str) -> Callable[[Checker], Checker]:
     def decorator(checker: Checker) -> Checker:
         assert name not in CHECKS
-        CHECKS[name] = checker
+        CHECKS[name] = Check(checker=checker, test_groups=[])
         return checker
 
     return decorator
 
 
+def add_check_tests(check_name: str, *groups: CheckTestGroup) -> None:
+    CHECKS[check_name].test_groups.extend(groups)
+
+
 # ---------------------------------------------------------------------------- #
 # Import all checks
 
diff --git a/static_analyzer/return_value_never_used.py b/static_analyzer/return_value_never_used.py
index 05c06cd4c2..de1a6542d1 100644
--- a/static_analyzer/return_value_never_used.py
+++ b/static_analyzer/return_value_never_used.py
@@ -11,7 +11,9 @@
 
 from static_analyzer import (
     CheckContext,
+    CheckTestGroup,
     VisitorResult,
+    add_check_tests,
     check,
     might_have_attribute,
     visit,
@@ -115,3 +117,104 @@ def get_parent_if_unexposed_expr(node: Cursor) -> Cursor:
 
 
 # ---------------------------------------------------------------------------- #
+
+add_check_tests(
+    "return-value-never-used",
+    CheckTestGroup(
+        inputs=[
+            R"""
+                static void f(void) { }
+                """,
+            R"""
+                static __attribute__((unused)) int f(void) { }
+                """,
+            R"""
+                #define ATTR __attribute__((unused))
+                static __attribute__((unused)) int f(void) { }
+                """,
+            R"""
+                #define FUNC static __attribute__((unused)) int f(void) { }
+                FUNC
+                """,
+            R"""
+                static __attribute__((unused, constructor)) int f(void) { }
+                """,
+            R"""
+                static __attribute__((constructor, unused)) int f(void) { }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    int x = f();
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    for (0; f(); 0) { }
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    for (f(); ; ) { }
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    for ( ; f(); ) { }
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    for ( ; ; f()) { }
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    int (*ptr)(void) = 0;
+                    __atomic_store_n(&ptr, f, __ATOMIC_RELAXED);
+                }
+                """,
+        ],
+        expected_output=R"""
+            """,
+    ),
+    CheckTestGroup(
+        inputs=[
+            R"""
+                static int f(void) { return 42; }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    f();
+                }
+                """,
+            R"""
+                static int f(void) { return 42; }
+                static void g(void) {
+                    for (f(); 0; f()) { }
+                }
+                """,
+        ],
+        expected_output=R"""
+            file.c:1:12: f() return value is never used
+            """,
+    ),
+    CheckTestGroup(
+        inputs=[
+            R"""
+                static __attribute__((constructor)) int f(void) { }
+                """,
+        ],
+        expected_output=R"""
+            file.c:1:41: f() return value is never used
+            """,
+    ),
+)
+
+# ---------------------------------------------------------------------------- #
-- 
2.37.1

