Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623C558503E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiG2NBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiG2NBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71B931F624
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uihxe1Ohk/aqUd0Yn39RrKWqrEEKFcQdal2v63T1yFQ=;
        b=SVUnb1kiMkQaJb+YFwt63YB/lrOX5Z4tTHt7asyGcDVLyanqVqomZn4Gn3uecOvUNETS5a
        iZKcccISLOqqyWkLIqyWc1UPwL8IGcQSuYVQP9smr+GR4zA89sc+YhWEEymolax+3nmjRo
        ZQsMbu1ctDNkXnEu6BQxMgfuiGPfshk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-vkuqeZkiPNCXfZ3xGEH8MQ-1; Fri, 29 Jul 2022 09:01:13 -0400
X-MC-Unique: vkuqeZkiPNCXfZ3xGEH8MQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56849185A7B2;
        Fri, 29 Jul 2022 13:01:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21D442026D64;
        Fri, 29 Jul 2022 13:01:00 +0000 (UTC)
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
Subject: [RFC v2 01/10] Add an extensible static analyzer
Date:   Fri, 29 Jul 2022 14:00:30 +0100
Message-Id: <20220729130040.1428779-2-afaria@redhat.com>
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

Add a static-analyzer.py script that uses libclang's Python bindings to
provide a common framework on which arbitrary static analysis checks can
be developed and run against QEMU's code base.

As an example, a simple "return-value-never-used" check is included that
verifies that the return value of static, non-void functions is used by
at least one caller.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 static-analyzer.py                         | 486 +++++++++++++++++++++
 static_analyzer/__init__.py                | 242 ++++++++++
 static_analyzer/return_value_never_used.py | 117 +++++
 3 files changed, 845 insertions(+)
 create mode 100755 static-analyzer.py
 create mode 100644 static_analyzer/__init__.py
 create mode 100644 static_analyzer/return_value_never_used.py

diff --git a/static-analyzer.py b/static-analyzer.py
new file mode 100755
index 0000000000..3ade422dbf
--- /dev/null
+++ b/static-analyzer.py
@@ -0,0 +1,486 @@
+#!/usr/bin/env python3
+# ---------------------------------------------------------------------------- #
+
+from configparser import ConfigParser
+from contextlib import contextmanager
+from dataclasses import dataclass
+import json
+import os
+import os.path
+import shlex
+import subprocess
+import sys
+import re
+from argparse import ArgumentParser, Namespace, RawDescriptionHelpFormatter
+from multiprocessing import Pool
+from pathlib import Path
+import textwrap
+import time
+from typing import (
+    Iterable,
+    Iterator,
+    List,
+    Mapping,
+    NoReturn,
+    Sequence,
+    Union,
+)
+
+import clang.cindex  # type: ignore
+
+from static_analyzer import CHECKS, CheckContext
+
+# ---------------------------------------------------------------------------- #
+# Usage
+
+
+def parse_args() -> Namespace:
+
+    available_checks = "\n".join(
+        f"  {name}   {' '.join((CHECKS[name].__doc__ or '').split())}"
+        for name in sorted(CHECKS)
+    )
+
+    parser = ArgumentParser(
+        allow_abbrev=False,
+        formatter_class=RawDescriptionHelpFormatter,
+        description=textwrap.dedent(
+            """
+            Checks are best-effort, but should never report false positives.
+
+            This only considers translation units enabled under the given QEMU
+            build configuration. Note that a single .c file may give rise to
+            several translation units.
+
+            You should build QEMU before running this, since some translation
+            units depend on files that are generated during the build. If you
+            don't, you'll get errors, but should never get false negatives.
+            """
+        ),
+        epilog=textwrap.dedent(
+            f"""
+            available checks:
+            {available_checks}
+
+            exit codes:
+            0  No problems found.
+            1  Internal failure.
+            2  Bad usage.
+            3  Problems found in one or more translation units.
+            """
+        ),
+    )
+
+    parser.add_argument(
+        "build_dir",
+        type=Path,
+        help="Path to the build directory.",
+    )
+
+    parser.add_argument(
+        "translation_units",
+        type=Path,
+        nargs="*",
+        help=(
+            "Analyze only translation units whose root source file matches or"
+            " is under one of the given paths."
+        ),
+    )
+
+    # add regular options
+
+    parser.add_argument(
+        "-c",
+        "--check",
+        metavar="CHECK",
+        dest="check_names",
+        choices=sorted(CHECKS),
+        action="append",
+        help=(
+            "Enable the given check. Can be given multiple times. If not given,"
+            " all checks are enabled."
+        ),
+    )
+
+    parser.add_argument(
+        "-j",
+        "--jobs",
+        dest="threads",
+        type=int,
+        default=os.cpu_count() or 1,
+        help=(
+            f"Number of threads to employ. Defaults to {os.cpu_count() or 1} on"
+            f" this machine."
+        ),
+    )
+
+    # add development options
+
+    dev_options = parser.add_argument_group("development options")
+
+    dev_options.add_argument(
+        "--profile",
+        metavar="SORT_KEY",
+        help=(
+            "Profile execution. Forces single-threaded execution. The argument"
+            " specifies how to sort the results; see"
+            " https://docs.python.org/3/library/profile.html#pstats.Stats.sort_stats"
+        ),
+    )
+
+    dev_options.add_argument(
+        "--skip-checks",
+        action="store_true",
+        help="Do everything except actually running the checks.",
+    )
+
+    # parse arguments
+
+    args = parser.parse_args()
+    args.check_names = sorted(set(args.check_names or CHECKS))
+
+    return args
+
+
+# ---------------------------------------------------------------------------- #
+# Main
+
+
+def main() -> int:
+
+    args = parse_args()
+
+    if args.profile:
+
+        import cProfile
+        import pstats
+
+        profile = cProfile.Profile()
+
+        try:
+            return profile.runcall(lambda: analyze(args))
+        finally:
+            stats = pstats.Stats(profile, stream=sys.stderr)
+            stats.strip_dirs()
+            stats.sort_stats(args.profile)
+            stats.print_stats()
+
+    else:
+
+        return analyze(args)
+
+
+def analyze(args: Namespace) -> int:
+
+    tr_units = get_translation_units(args)
+
+    # analyze translation units
+
+    start_time = time.monotonic()
+    results: List[bool] = []
+
+    if len(tr_units) == 1:
+        progress_suffix = " of 1 translation unit...\033[0m\r"
+    else:
+        progress_suffix = f" of {len(tr_units)} translation units...\033[0m\r"
+
+    def print_progress() -> None:
+        print(f"\033[0;34mAnalyzed {len(results)}" + progress_suffix, end="")
+
+    print_progress()
+
+    def collect_results(results_iter: Iterable[bool]) -> None:
+        if sys.stdout.isatty():
+            for r in results_iter:
+                results.append(r)
+                print_progress()
+        else:
+            for r in results_iter:
+                results.append(r)
+
+    if tr_units:
+
+        if args.threads == 1:
+
+            collect_results(map(analyze_translation_unit, tr_units))
+
+        else:
+
+            # Mimic Python's default pool.map() chunk size, but limit it to
+            # 5 to avoid very big chunks when analyzing thousands of
+            # translation units.
+            chunk_size = min(5, -(-len(tr_units) // (args.threads * 4)))
+
+            with Pool(processes=args.threads) as pool:
+                collect_results(
+                    pool.imap_unordered(
+                        analyze_translation_unit, tr_units, chunk_size
+                    )
+                )
+
+    end_time = time.monotonic()
+
+    # print summary
+
+    if len(tr_units) == 1:
+        message = "Analyzed 1 translation unit"
+    else:
+        message = f"Analyzed {len(tr_units)} translation units"
+
+    message += f" in {end_time - start_time:.1f} seconds."
+
+    print(f"\033[0;34m{message}\033[0m")
+
+    # exit
+
+    return 0 if all(results) else 3
+
+
+# ---------------------------------------------------------------------------- #
+# Translation units
+
+
+@dataclass
+class TranslationUnit:
+    absolute_path: str
+    build_working_dir: str
+    build_command: str
+    system_include_paths: Sequence[str]
+    check_names: Sequence[str]
+
+
+def get_translation_units(args: Namespace) -> Sequence["TranslationUnit"]:
+    """Return a list of translation units to be analyzed."""
+
+    system_include_paths = get_clang_system_include_paths()
+    compile_commands = load_compilation_database(args.build_dir)
+
+    # get all translation units
+
+    tr_units: Iterable[TranslationUnit] = (
+        TranslationUnit(
+            absolute_path=str(Path(cmd["directory"], cmd["file"]).resolve()),
+            build_working_dir=cmd["directory"],
+            build_command=cmd["command"],
+            system_include_paths=system_include_paths,
+            check_names=args.check_names,
+        )
+        for cmd in compile_commands
+    )
+
+    # ignore translation units from git submodules
+
+    repo_root = (args.build_dir / "Makefile").resolve(strict=True).parent
+    module_file = repo_root / ".gitmodules"
+    assert module_file.exists()
+
+    modules = ConfigParser()
+    modules.read(module_file)
+
+    disallowed_prefixes = [
+        # ensure path is slash-terminated
+        os.path.join(repo_root, section["path"], "")
+        for section in modules.values()
+        if "path" in section
+    ]
+
+    tr_units = (
+        ctx
+        for ctx in tr_units
+        if all(
+            not ctx.absolute_path.startswith(prefix)
+            for prefix in disallowed_prefixes
+        )
+    )
+
+    # filter translation units by command line arguments
+
+    if args.translation_units:
+
+        allowed_prefixes = [
+            # ensure path exists and is slash-terminated (even if it is a file)
+            os.path.join(path.resolve(strict=True), "")
+            for path in args.translation_units
+        ]
+
+        tr_units = (
+            ctx
+            for ctx in tr_units
+            if any(
+                (ctx.absolute_path + "/").startswith(prefix)
+                for prefix in allowed_prefixes
+            )
+        )
+
+    # ensure that at least one translation unit is selected
+
+    tr_unit_list = list(tr_units)
+
+    if not tr_unit_list:
+        fatal("No translation units to analyze")
+
+    # disable all checks if --skip-checks was given
+
+    if args.skip_checks:
+        for context in tr_unit_list:
+            context.check_names = []
+
+    return tr_unit_list
+
+
+def get_clang_system_include_paths() -> Sequence[str]:
+
+    # libclang does not automatically include clang's standard system include
+    # paths, so we ask clang what they are and include them ourselves.
+
+    result = subprocess.run(
+        ["clang", "-E", "-", "-v"],
+        stdin=subprocess.DEVNULL,
+        stdout=subprocess.DEVNULL,
+        stderr=subprocess.PIPE,
+        universal_newlines=True,  # decode output using default encoding
+        check=True,
+    )
+
+    # Module `re` does not support repeated group captures.
+    pattern = (
+        r"#include <...> search starts here:\n"
+        r"((?: \S*\n)+)"
+        r"End of search list."
+    )
+
+    match = re.search(pattern, result.stderr, re.MULTILINE)
+    assert match is not None
+
+    return [line[1:] for line in match.group(1).splitlines()]
+
+
+def load_compilation_database(build_dir: Path) -> Sequence[Mapping[str, str]]:
+
+    # clang.cindex.CompilationDatabase.getCompileCommands() apparently produces
+    # entries for files not listed in compile_commands.json in a best-effort
+    # manner, which we don't want, so we parse the JSON ourselves instead.
+
+    path = build_dir / "compile_commands.json"
+
+    try:
+        with path.open("r") as f:
+            return json.load(f)
+    except FileNotFoundError:
+        fatal(f"{path} does not exist")
+
+
+# ---------------------------------------------------------------------------- #
+# Analysis
+
+
+def analyze_translation_unit(tr_unit: TranslationUnit) -> bool:
+
+    check_context = get_check_context(tr_unit)
+
+    try:
+        for name in tr_unit.check_names:
+            CHECKS[name](check_context)
+    except Exception as e:
+        raise RuntimeError(f"Error analyzing {check_context._rel_path}") from e
+
+    return not check_context._problems_found
+
+
+def get_check_context(tr_unit: TranslationUnit) -> CheckContext:
+
+    # relative to script's original working directory
+    rel_path = os.path.relpath(tr_unit.absolute_path)
+
+    # load translation unit
+
+    command = shlex.split(tr_unit.build_command)
+
+    adjusted_command = [
+        # keep the original compilation command name
+        command[0],
+        # ignore unknown GCC warning options
+        "-Wno-unknown-warning-option",
+        # keep all other arguments but the last, which is the file name
+        *command[1:-1],
+        # add clang system include paths
+        *(
+            arg
+            for path in tr_unit.system_include_paths
+            for arg in ("-isystem", path)
+        ),
+        # replace relative path to get absolute location information
+        tr_unit.absolute_path,
+    ]
+
+    # clang can warn about things that GCC doesn't
+    if "-Werror" in adjusted_command:
+        adjusted_command.remove("-Werror")
+
+    # We change directory for options like -I to work, but have to change back
+    # to have correct relative paths in messages.
+    with cwd(tr_unit.build_working_dir):
+
+        try:
+            tu = clang.cindex.TranslationUnit.from_source(
+                filename=None, args=adjusted_command
+            )
+        except clang.cindex.TranslationUnitLoadError as e:
+            raise RuntimeError(f"Failed to load {rel_path}") from e
+
+    if sys.stdout.isatty():
+        # add padding to fully overwrite progress message
+        printer = lambda s: print(s.ljust(50))
+    else:
+        printer = print
+
+    check_context = CheckContext(
+        translation_unit=tu,
+        translation_unit_path=tr_unit.absolute_path,
+        _rel_path=rel_path,
+        _build_working_dir=Path(tr_unit.build_working_dir),
+        _problems_found=False,
+        _printer=printer,
+    )
+
+    # check for error/fatal diagnostics
+
+    for diag in tu.diagnostics:
+        if diag.severity >= clang.cindex.Diagnostic.Error:
+            check_context._problems_found = True
+            location = check_context.format_location(diag)
+            check_context._printer(
+                f"\033[0;33m{location}: {diag.spelling}; this may lead to false"
+                f" positives and negatives\033[0m"
+            )
+
+    return check_context
+
+
+# ---------------------------------------------------------------------------- #
+# Utilities
+
+
+@contextmanager
+def cwd(path: Union[str, Path]) -> Iterator[None]:
+
+    original_cwd = os.getcwd()
+    os.chdir(path)
+
+    try:
+        yield
+    finally:
+        os.chdir(original_cwd)
+
+
+def fatal(message: str) -> NoReturn:
+    print(f"\033[0;31mERROR: {message}\033[0m")
+    sys.exit(1)
+
+
+# ---------------------------------------------------------------------------- #
+
+if __name__ == "__main__":
+    sys.exit(main())
+
+# ---------------------------------------------------------------------------- #
diff --git a/static_analyzer/__init__.py b/static_analyzer/__init__.py
new file mode 100644
index 0000000000..e6ca48d714
--- /dev/null
+++ b/static_analyzer/__init__.py
@@ -0,0 +1,242 @@
+# ---------------------------------------------------------------------------- #
+
+from ctypes import CFUNCTYPE, c_int, py_object
+from dataclasses import dataclass
+from enum import Enum
+import os
+import os.path
+from pathlib import Path
+from importlib import import_module
+from typing import (
+    Any,
+    Callable,
+    Dict,
+    List,
+    Optional,
+    Union,
+)
+
+from clang.cindex import (  # type: ignore
+    Cursor,
+    CursorKind,
+    TranslationUnit,
+    SourceLocation,
+    conf,
+)
+
+# ---------------------------------------------------------------------------- #
+# Monkeypatch clang.cindex
+
+Cursor.__hash__ = lambda self: self.hash  # so `Cursor`s can be dict keys
+
+# ---------------------------------------------------------------------------- #
+# Traversal
+
+
+class VisitorResult(Enum):
+
+    BREAK = 0
+    """Terminates the cursor traversal."""
+
+    CONTINUE = 1
+    """Continues the cursor traversal with the next sibling of the cursor just
+    visited, without visiting its children."""
+
+    RECURSE = 2
+    """Recursively traverse the children of this cursor."""
+
+
+def visit(root: Cursor, visitor: Callable[[Cursor], VisitorResult]) -> bool:
+    """
+    A simple wrapper around `clang_visitChildren()`.
+
+    The `visitor` callback is called for each visited node, with that node as
+    its argument. `root` is NOT visited.
+
+    Unlike a standard `Cursor`, the callback argument will have a `parent` field
+    that points to its parent in the AST. The `parent` will also have its own
+    `parent` field, and so on, unless it is `root`, in which case its `parent`
+    field is `None`. We add this because libclang's `lexical_parent` field is
+    almost always `None` for some reason.
+
+    Returns `false` if the visitation was aborted by the callback returning
+    `VisitorResult.BREAK`. Returns `true` otherwise.
+    """
+
+    tu = root._tu
+    root.parent = None
+
+    # Stores the path from `root` to the node being visited. We need this to set
+    # `node.parent`.
+    path: List[Cursor] = [root]
+
+    exception: List[BaseException] = []
+
+    @CFUNCTYPE(c_int, Cursor, Cursor, py_object)
+    def actual_visitor(node: Cursor, parent: Cursor, client_data: None) -> int:
+
+        try:
+
+            # The `node` and `parent` `Cursor` objects are NOT reused in between
+            # invocations of this visitor callback, so we can't assume that
+            # `parent.parent` is set.
+
+            while path[-1] != parent:
+                path.pop()
+
+            node.parent = path[-1]
+            path.append(node)
+
+            # several clang.cindex methods need Cursor._tu to be set
+            node._tu = tu
+
+            return visitor(node).value
+
+        except BaseException as e:
+
+            # Exceptions can't cross into C. Stash it, abort the visitation, and
+            # reraise it.
+
+            exception.append(e)
+            return VisitorResult.BREAK.value
+
+    result = conf.lib.clang_visitChildren(root, actual_visitor, None)
+
+    if exception:
+        raise exception[0]
+
+    return result == 0
+
+
+# ---------------------------------------------------------------------------- #
+# Node predicates
+
+
+def might_have_attribute(node: Cursor, attr: Union[CursorKind, str]) -> bool:
+    """
+    Check whether any of `node`'s children are an attribute of the given kind,
+    or an attribute of kind `UNEXPOSED_ATTR` with the given `str` spelling.
+
+    This check is best-effort and may erroneously return `True`.
+    """
+
+    if isinstance(attr, CursorKind):
+
+        assert attr.is_attribute()
+
+        def matcher(n: Cursor) -> bool:
+            return n.kind == attr
+
+    else:
+
+        def matcher(n: Cursor) -> bool:
+            if n.kind != CursorKind.UNEXPOSED_ATTR:
+                return False
+            tokens = list(n.get_tokens())
+            # `tokens` can have 0 or more than 1 element when the attribute
+            # comes from a macro expansion. AFAICT, in that case we can't do
+            # better here than tell callers that this might be the attribute
+            # that they're looking for.
+            return len(tokens) != 1 or tokens[0].spelling == attr
+
+    return any(map(matcher, node.get_children()))
+
+
+# ---------------------------------------------------------------------------- #
+# Checks
+
+
+@dataclass
+class CheckContext:
+
+    translation_unit: TranslationUnit
+    translation_unit_path: str  # exactly as reported by libclang
+
+    _rel_path: str
+    _build_working_dir: Path
+    _problems_found: bool
+
+    _printer: Callable[[str], None]
+
+    def format_location(self, obj: Any) -> str:
+        """obj must have a location field/property that is a
+        `SourceLocation`."""
+        return self._format_location(obj.location)
+
+    def _format_location(self, loc: SourceLocation) -> str:
+
+        if loc.file is None:
+            return self._rel_path
+        else:
+            abs_path = (self._build_working_dir / loc.file.name).resolve()
+            rel_path = os.path.relpath(abs_path)
+            return f"{rel_path}:{loc.line}:{loc.column}"
+
+    def report(self, node: Cursor, message: str) -> None:
+        self._problems_found = True
+        self._printer(f"{self.format_location(node)}: {message}")
+
+    def print_node(self, node: Cursor) -> None:
+        """This can be handy when developing checks."""
+
+        print(f"{self.format_location(node)}: kind = {node.kind.name}", end="")
+
+        if node.spelling:
+            print(f", spelling = {node.spelling!r}", end="")
+
+        if node.type is not None:
+            print(f", type = {node.type.get_canonical().spelling!r}", end="")
+
+        if node.referenced is not None:
+            print(f", referenced = {node.referenced.spelling!r}", end="")
+
+        start = self._format_location(node.extent.start)
+        end = self._format_location(node.extent.end)
+        print(f", extent = {start}--{end}")
+
+    def print_tree(
+        self,
+        node: Cursor,
+        *,
+        max_depth: Optional[int] = None,
+        indentation_level: int = 0,
+    ) -> None:
+        """This can be handy when developing checks."""
+
+        if max_depth is None or max_depth >= 0:
+
+            print("  " * indentation_level, end="")
+            self.print_node(node)
+
+            for child in node.get_children():
+                self.print_tree(
+                    child,
+                    max_depth=None if max_depth is None else max_depth - 1,
+                    indentation_level=indentation_level + 1,
+                )
+
+
+Checker = Callable[[CheckContext], None]
+
+CHECKS: Dict[str, Checker] = {}
+
+
+def check(name: str) -> Callable[[Checker], Checker]:
+    def decorator(checker: Checker) -> Checker:
+        assert name not in CHECKS
+        CHECKS[name] = checker
+        return checker
+
+    return decorator
+
+
+# ---------------------------------------------------------------------------- #
+# Import all checks
+
+for path in Path(__file__).parent.glob("**/*.py"):
+    if path.name != "__init__.py":
+        rel_path = path.relative_to(Path(__file__).parent)
+        module = "." + ".".join([*rel_path.parts[:-1], rel_path.stem])
+        import_module(module, __package__)
+
+# ---------------------------------------------------------------------------- #
diff --git a/static_analyzer/return_value_never_used.py b/static_analyzer/return_value_never_used.py
new file mode 100644
index 0000000000..05c06cd4c2
--- /dev/null
+++ b/static_analyzer/return_value_never_used.py
@@ -0,0 +1,117 @@
+# ---------------------------------------------------------------------------- #
+
+from typing import Dict
+
+from clang.cindex import (  # type: ignore
+    Cursor,
+    CursorKind,
+    StorageClass,
+    TypeKind,
+)
+
+from static_analyzer import (
+    CheckContext,
+    VisitorResult,
+    check,
+    might_have_attribute,
+    visit,
+)
+
+# ---------------------------------------------------------------------------- #
+
+
+@check("return-value-never-used")
+def check_return_value_never_used(context: CheckContext) -> None:
+    """Report static functions with a non-void return value that no caller ever
+    uses."""
+
+    # Maps canonical function `Cursor`s to whether we found a place that maybe
+    # uses their return value. Only includes static functions that don't return
+    # void, don't have __attribute__((unused)), and belong to the translation
+    # unit's root file (i.e., were not brought in by an #include).
+    funcs: Dict[Cursor, bool] = {}
+
+    def visitor(node: Cursor) -> VisitorResult:
+
+        if (
+            node.kind == CursorKind.FUNCTION_DECL
+            and node.storage_class == StorageClass.STATIC
+            and node.location.file.name == context.translation_unit_path
+            and node.type.get_result().get_canonical().kind != TypeKind.VOID
+            and not might_have_attribute(node, "unused")
+        ):
+            funcs.setdefault(node.canonical, False)
+
+        if (
+            node.kind == CursorKind.DECL_REF_EXPR
+            and node.referenced.kind == CursorKind.FUNCTION_DECL
+            and node.referenced.canonical in funcs
+            and function_occurrence_might_use_return_value(node)
+        ):
+            funcs[node.referenced.canonical] = True
+
+        return VisitorResult.RECURSE
+
+    visit(context.translation_unit.cursor, visitor)
+
+    for (cursor, return_value_maybe_used) in funcs.items():
+        if not return_value_maybe_used:
+            context.report(
+                cursor, f"{cursor.spelling}() return value is never used"
+            )
+
+
+def function_occurrence_might_use_return_value(node: Cursor) -> bool:
+
+    parent = get_parent_if_unexposed_expr(node.parent)
+
+    if parent.kind.is_statement():
+
+        return False
+
+    elif (
+        parent.kind == CursorKind.CALL_EXPR
+        and parent.referenced == node.referenced
+    ):
+
+        grandparent = get_parent_if_unexposed_expr(parent.parent)
+
+        if not grandparent.kind.is_statement():
+            return True
+
+        if grandparent.kind in [
+            CursorKind.IF_STMT,
+            CursorKind.SWITCH_STMT,
+            CursorKind.WHILE_STMT,
+            CursorKind.DO_STMT,
+            CursorKind.RETURN_STMT,
+        ]:
+            return True
+
+        if grandparent.kind == CursorKind.FOR_STMT:
+
+            [*for_parts, for_body] = grandparent.get_children()
+            if len(for_parts) == 0:
+                return False
+            elif len(for_parts) in [1, 2]:
+                return True  # call may be in condition part of for loop
+            elif len(for_parts) == 3:
+                # Comparison doesn't work properly with `Cursor`s originating
+                # from nested visitations, so we compare the extent instead.
+                return parent.extent == for_parts[1].extent
+            else:
+                assert False
+
+        return False
+
+    else:
+
+        # might be doing something with a pointer to the function
+        return True
+
+
+def get_parent_if_unexposed_expr(node: Cursor) -> Cursor:
+    return node.parent if node.kind == CursorKind.UNEXPOSED_EXPR else node
+
+
+# ---------------------------------------------------------------------------- #
-- 
2.37.1

