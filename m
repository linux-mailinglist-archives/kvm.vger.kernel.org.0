Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD581D3D6B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgENT1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42414 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728068AbgENT1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 15:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=EE7x2n/yIQY1b6jXYkvSag9LroLzvwnGE1ytGCl9bIM=;
        b=iPhADVtb8gWI2drrJJ8jOI2rSIxg4gcSpZjAdRK13JorDx16vgchikv2uUCSqUzA+tqj2O
        /ezjF8DSOQd441f8Wxcfs7D2ienVzQ5ibQ6Q7YCeNjj0KC9A6W54u0RCc9OK3ZjHgauvc7
        amCmjRTTfhQ62IrS16zhCv57M2YXi5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-sUdo_T4WN5m4tiGpC6dmQQ-1; Thu, 14 May 2020 15:26:58 -0400
X-MC-Unique: sUdo_T4WN5m4tiGpC6dmQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D2EF18FF669;
        Thu, 14 May 2020 19:26:57 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DEFE5C1BE;
        Thu, 14 May 2020 19:26:54 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 06/11] Fix powerpc issue with the linker from Fedora 32
Date:   Thu, 14 May 2020 21:26:21 +0200
Message-Id: <20200514192626.9950-7-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The linker from Fedora 32 complains:

powerpc64-linux-gnu-ld: powerpc/selftest.elf: error: PHDR segment not
 covered by LOAD segment

Let's introduce some fake PHDRs to the linker script to get this
working again.

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

