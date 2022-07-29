Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAB585043
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiG2NCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiG2NCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:02:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 290EE41989
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aq34TDaSxwi9e349XzPmgkZI0FYYnHKISwQlOSnwFY=;
        b=Z5JmtVWImSYvc+vxA2l33IyhBBOycFGDYFhDDZ3sSTSWv4PsKUwbMEkm3CiPEu5c4QOhom
        iXZt9McZK/39nwxyOzcN3PcpEJUDFpcBXiD5pPrOYkZrFYBQroa8wlusxbKiQCYbsN36sa
        agZqJ01A8InWiWlFc1S0ekNU3T8qBdk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-pTpng5WZMaWrS0heup9pHg-1; Fri, 29 Jul 2022 09:02:14 -0400
X-MC-Unique: pTpng5WZMaWrS0heup9pHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C62678039A1;
        Fri, 29 Jul 2022 13:02:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20E5D2026D64;
        Fri, 29 Jul 2022 13:02:03 +0000 (UTC)
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
Subject: [RFC v2 07/10] static-analyzer: Enforce coroutine_fn restrictions on function pointers
Date:   Fri, 29 Jul 2022 14:00:36 +0100
Message-Id: <20220729130040.1428779-8-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend static-analyzer.py's "coroutine_fn" check to enforce coroutine_fn
restrictions on function pointer operations.

Invalid operations include assigning a coroutine_fn value to a
non-coroutine_fn function pointer, and invoking a coroutine_fn function
pointer from a non-coroutine_fn function.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 static_analyzer/__init__.py     |  27 ++++++++
 static_analyzer/coroutine_fn.py | 115 ++++++++++++++++++++++++++++++--
 2 files changed, 138 insertions(+), 4 deletions(-)

diff --git a/static_analyzer/__init__.py b/static_analyzer/__init__.py
index 5abdbd21a3..90992d3500 100644
--- a/static_analyzer/__init__.py
+++ b/static_analyzer/__init__.py
@@ -24,6 +24,8 @@
     Cursor,
     CursorKind,
     SourceLocation,
+    SourceRange,
+    TokenGroup,
     TranslationUnit,
     TypeKind,
     conf,
@@ -117,6 +119,31 @@ def actual_visitor(node: Cursor, parent: Cursor, client_data: None) -> int:
 # Node predicates
 
 
+def is_binary_operator(node: Cursor, operator: str) -> bool:
+    return (
+        node.kind == CursorKind.BINARY_OPERATOR
+        and get_binary_operator_spelling(node) == operator
+    )
+
+
+def get_binary_operator_spelling(node: Cursor) -> Optional[str]:
+
+    assert node.kind == CursorKind.BINARY_OPERATOR
+
+    [left, right] = node.get_children()
+
+    op_range = SourceRange.from_locations(left.extent.end, right.extent.start)
+
+    tokens = list(TokenGroup.get_tokens(node.translation_unit, op_range))
+    if not tokens:
+        # Can occur when left and right children extents overlap due to
+        # misparsing.
+        return None
+
+    [op_token, *_] = tokens
+    return op_token.spelling
+
+
 def might_have_attribute(node: Cursor, attr: Union[CursorKind, str]) -> bool:
     """
     Check whether any of `node`'s children are an attribute of the given kind,
diff --git a/static_analyzer/coroutine_fn.py b/static_analyzer/coroutine_fn.py
index f70a3167eb..a16dcbeb52 100644
--- a/static_analyzer/coroutine_fn.py
+++ b/static_analyzer/coroutine_fn.py
@@ -8,6 +8,7 @@
     check,
     is_annotated_with,
     is_annotation,
+    is_binary_operator,
     is_comma_wrapper,
     visit,
 )
@@ -22,6 +23,7 @@ def check_coroutine_fn(context: CheckContext) -> None:
     def visitor(node: Cursor) -> VisitorResult:
 
         validate_annotations(context, node)
+        check_function_pointers(context, node)
 
         if node.kind == CursorKind.FUNCTION_DECL and node.is_definition():
             check_direct_calls(context, node)
@@ -91,6 +93,83 @@ def visitor(node: Cursor) -> VisitorResult:
         visit(caller, visitor)
 
 
+def check_function_pointers(context: CheckContext, node: Cursor) -> None:
+
+    # What we would really like is to associate annotation attributes with types
+    # directly, but that doesn't seem possible. Instead, we have to look at the
+    # relevant variable/field/parameter declarations, and follow typedefs.
+
+    # This doesn't check all possible ways of assigning to a coroutine_fn
+    # field/variable/parameter. That would probably be too much work.
+
+    # TODO: Check struct/union/array initialization.
+    # TODO: Check assignment to struct/union/array fields.
+
+    # check initialization of variables using coroutine_fn values
+
+    if node.kind == CursorKind.VAR_DECL:
+
+        children = [
+            c
+            for c in node.get_children()
+            if c.kind
+            not in [
+                CursorKind.ANNOTATE_ATTR,
+                CursorKind.INIT_LIST_EXPR,
+                CursorKind.TYPE_REF,
+                CursorKind.UNEXPOSED_ATTR,
+            ]
+        ]
+
+        if (
+            len(children) == 1
+            and not is_coroutine_fn(node)
+            and is_coroutine_fn(children[0])
+        ):
+            context.report(node, "assigning coroutine_fn to non-coroutine_fn")
+
+    # check initialization of fields using coroutine_fn values
+
+    # TODO: This only checks designator initializers.
+
+    if node.kind == CursorKind.INIT_LIST_EXPR:
+
+        for initializer in filter(
+            lambda n: n.kind == CursorKind.UNEXPOSED_EXPR,
+            node.get_children(),
+        ):
+
+            children = list(initializer.get_children())
+
+            if (
+                len(children) == 2
+                and children[0].kind == CursorKind.MEMBER_REF
+                and not is_coroutine_fn(children[0].referenced)
+                and is_coroutine_fn(children[1])
+            ):
+                context.report(
+                    initializer,
+                    "assigning coroutine_fn to non-coroutine_fn",
+                )
+
+    # check assignments of coroutine_fn values to variables or fields
+
+    if is_binary_operator(node, "="):
+
+        [left, right] = node.get_children()
+
+        if (
+            left.kind
+            in [
+                CursorKind.DECL_REF_EXPR,
+                CursorKind.MEMBER_REF_EXPR,
+            ]
+            and not is_coroutine_fn(left.referenced)
+            and is_coroutine_fn(right)
+        ):
+            context.report(node, "assigning coroutine_fn to non-coroutine_fn")
+
+
 # ---------------------------------------------------------------------------- #
 
 
@@ -138,7 +217,13 @@ def is_valid_allow_coroutine_fn_call_usage(node: Cursor) -> bool:
     `node` appears at a valid point in the AST. This is the case if its right
     operand is a call to:
 
-      - A function declared with the `coroutine_fn` annotation.
+      - A function declared with the `coroutine_fn` annotation, OR
+      - A field/variable/parameter whose declaration has the `coroutine_fn`
+        annotation, and of function pointer type, OR
+      - [TODO] A field/variable/parameter of a typedef function pointer type,
+        and the typedef has the `coroutine_fn` annotation, OR
+      - [TODO] A field/variable/parameter of a pointer to typedef function type,
+        and the typedef has the `coroutine_fn` annotation.
 
     TODO: Ensure that `__allow_coroutine_fn_call()` is in the body of a
     non-`coroutine_fn` function.
@@ -165,9 +250,31 @@ def is_coroutine_fn(node: Cursor) -> bool:
         else:
             break
 
-    return node.kind == CursorKind.FUNCTION_DECL and is_annotated_with(
-        node, "coroutine_fn"
-    )
+    if node.kind in [CursorKind.DECL_REF_EXPR, CursorKind.MEMBER_REF_EXPR]:
+        node = node.referenced
+
+    # ---
+
+    if node.kind == CursorKind.FUNCTION_DECL:
+        return is_annotated_with(node, "coroutine_fn")
+
+    if node.kind in [
+        CursorKind.FIELD_DECL,
+        CursorKind.VAR_DECL,
+        CursorKind.PARM_DECL,
+    ]:
+
+        if is_annotated_with(node, "coroutine_fn"):
+            return True
+
+        # TODO: If type is typedef or pointer to typedef, follow typedef.
+
+        return False
+
+    if node.kind == CursorKind.TYPEDEF_DECL:
+        return is_annotated_with(node, "coroutine_fn")
+
+    return False
 
 
 # ---------------------------------------------------------------------------- #
-- 
2.37.1

