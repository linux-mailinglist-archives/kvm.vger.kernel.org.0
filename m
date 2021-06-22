Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F153B064B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 15:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhFVN5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231478AbhFVN5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hbAdT4bM0mou8sDcn/BLX3RjewSuzcGuFIqDTa43aKo=;
        b=Y63e5qr3S6ql/xwiFTXq+tlMFsveb5QAyWDjTsB67Ok+Zw8dgFOUjKbWRYqk6+07yO9hEY
        TQlP6uAAmSG5lbitX7xygJ3VPhKm7lVj3KwK6I2JZjS4zd87AxLkz/12NCem5qCzr9LPZg
        tES7HiWweKG3URTeqxTuL1gImqUitpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-EoVkHFfVO0yP28defOzNcw-1; Tue, 22 Jun 2021 09:55:27 -0400
X-MC-Unique: EoVkHFfVO0yP28defOzNcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38BEB101F7A1;
        Tue, 22 Jun 2021 13:55:26 +0000 (UTC)
Received: from thuth.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59BAF1899A;
        Tue, 22 Jun 2021 13:55:24 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 1/4] configure: Add the possibility to specify additional cflags
Date:   Tue, 22 Jun 2021 15:55:14 +0200
Message-Id: <20210622135517.234801-2-thuth@redhat.com>
In-Reply-To: <20210622135517.234801-1-thuth@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For certain compilers or experiments, it might be necessary to
specify additional CFLAGS for the build. Let's add an option to
the configure script to specify such additional compiler flags.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile  |  3 ---
 configure | 10 ++++++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 1afa90e..f7b9f28 100644
--- a/Makefile
+++ b/Makefile
@@ -22,9 +22,6 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
-#make sure env CFLAGS variable is not used
-CFLAGS =
-
 libcflat := lib/libcflat.a
 cflatobjs := \
 	lib/argv.o \
diff --git a/configure b/configure
index d21601f..c48ab3d 100755
--- a/configure
+++ b/configure
@@ -8,6 +8,7 @@ fi
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
+cflags=
 ld=ld
 objcopy=objcopy
 objdump=objdump
@@ -38,8 +39,9 @@ usage() {
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
-	    --cc=CC		   c compiler to use ($cc)
-	    --ld=LD		   ld linker to use ($ld)
+	    --cc=CC                c compiler to use ($cc)
+	    --cflags=FLAGS         extra options to be passed to the c compiler
+	    --ld=LD                ld linker to use ($ld)
 	    --prefix=PREFIX        where to install things ($prefix)
 	    --endian=ENDIAN        endianness to compile for (little or big, ppc64 only)
 	    --[enable|disable]-pretty-print-stacks
@@ -100,6 +102,9 @@ while [[ "$1" = -* ]]; do
 	--cc)
 	    cc="$arg"
 	    ;;
+	--cflags)
+	    cflags="$arg"
+	    ;;
 	--ld)
 	    ld="$arg"
 	    ;;
@@ -316,6 +321,7 @@ ARCH=$arch
 ARCH_NAME=$arch_name
 PROCESSOR=$processor
 CC=$cross_prefix$cc
+CFLAGS=$cflags
 LD=$cross_prefix$ld
 OBJCOPY=$cross_prefix$objcopy
 OBJDUMP=$cross_prefix$objdump
-- 
2.27.0

