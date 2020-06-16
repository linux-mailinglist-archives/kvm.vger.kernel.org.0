Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFFF1FBE96
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgFPS4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56768 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730312AbgFPS4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=6OpF2PS0+M7A0UkOIJJrI29Srt4ywHknxIiHcFjvmY8=;
        b=Rl9iHZcysq1BJk1LLJtkbB7YiX2zmsL15J/9YOBldTpycHs0Ivjxn9GQV5B0gSuZdFt+Fk
        JQF5PkPCyTsU4acXhEXPNbkjMYZGeV3euwo0eOu9YjgzZO/PclnJ/OALDNNjTYm4X8KK29
        POAoANgMzdyTQF/xh6pLhBd6zZIKp40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-agPJjcitNg6tXZztgXZpeg-1; Tue, 16 Jun 2020 14:56:32 -0400
X-MC-Unique: agPJjcitNg6tXZztgXZpeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B76EE81EE22
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:31 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E90F7891C2;
        Tue, 16 Jun 2020 18:56:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 05/12] Fix powerpc issue with the linker from Fedora 32
Date:   Tue, 16 Jun 2020 20:56:15 +0200
Message-Id: <20200616185622.8644-6-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The linker from Fedora 32 complains:

powerpc64-linux-gnu-ld: powerpc/selftest.elf: error: PHDR segment not
 covered by LOAD segment

Let's introduce some fake PHDRs to the linker script to get this
working again.

Message-Id: <20200514192626.9950-7-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 powerpc/flat.lds | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/powerpc/flat.lds b/powerpc/flat.lds
index 53221e8..5eed368 100644
--- a/powerpc/flat.lds
+++ b/powerpc/flat.lds
@@ -1,7 +1,17 @@
 
+PHDRS
+{
+    text PT_LOAD FLAGS(5);
+    data PT_LOAD FLAGS(6);
+}
+
 SECTIONS
 {
-    .text : { *(.init) *(.text) *(.text.*) }
+    .text : {
+        *(.init)
+        *(.text)
+        *(.text.*)
+    } :text
     . = ALIGN(64K);
     etext = .;
     .opd : { *(.opd) }
@@ -19,9 +29,12 @@ SECTIONS
     .data : {
         *(.data)
         *(.data.rel*)
-    }
+    } :data
     . = ALIGN(16);
-    .rodata : { *(.rodata) *(.rodata.*) }
+    .rodata : {
+        *(.rodata)
+        *(.rodata.*)
+    } :data
     . = ALIGN(16);
     .bss : { *(.bss) }
     . = ALIGN(256);
-- 
2.18.1

