Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE833DA33
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhCPREq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239022AbhCPRDX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 13:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615914202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HItyjyZcbtCvMy4s0YVycY317vpBiXf9N2dPwfYqxMU=;
        b=JBsDElpccYc85YmZchkIz3JBdlNnpXlDSvnRIN9vUUeYnei7GGKLlJiq8Bv90cD40LUFHX
        8iQ8BEoSZuWhHBwsNk1MKHz1ZLs7dx7VrRUsTnJVTlZwg2gaB7c8BEYf//JCIPV+/igbxM
        VXi5RO8YgytStJld68+39SEO8RlcgQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-mcT-AsiUNk2T8Mq71IehwQ-1; Tue, 16 Mar 2021 13:03:20 -0400
X-MC-Unique: mcT-AsiUNk2T8Mq71IehwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 743638189CA;
        Tue, 16 Mar 2021 17:03:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEB6F60C13;
        Tue, 16 Mar 2021 17:03:17 +0000 (UTC)
Date:   Tue, 16 Mar 2021 18:03:15 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 0/4] Fix the devicetree parser for
 stdout-path
Message-ID: <20210316170315.332uljbqwe7t7w4q@kamzik.brq.redhat.com>
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316152405.50363-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:24:01PM +0000, Nikos Nikoleris wrote:
> This set of patches fixes the way we parse the stdout-path which is
> used to set up the console. Prior to this, the code ignored the fact
> that stdout-path is made of the path to the uart node as well as
> parameters and as a result it would fail to find the relevant DT
> node. In addition to minor fixes in the device tree code, this series
> pulls a new version of libfdt from upstream.
> 
> Thanks,
> 
> Nikos
> 
> Nikos Nikoleris (4):
>   lib/string: add strnlen and strrchr
>   libfdt: Pull v1.6.0
>   Makefile: Avoid double definition of libfdt_clean
>   devicetree: Parse correctly the stdout-path
> 
>  lib/libfdt/README            |   3 +-
>  Makefile                     |  12 +-
>  lib/libfdt/Makefile.libfdt   |  10 +-
>  lib/libfdt/version.lds       |  24 +-
>  lib/libfdt/fdt.h             |  53 +--
>  lib/libfdt/libfdt.h          | 766 +++++++++++++++++++++++++-----
>  lib/libfdt/libfdt_env.h      | 109 ++---
>  lib/libfdt/libfdt_internal.h | 206 +++++---
>  lib/string.h                 |   5 +-
>  lib/devicetree.c             |  15 +-
>  lib/libfdt/fdt.c             | 200 +++++---
>  lib/libfdt/fdt_addresses.c   | 101 ++++
>  lib/libfdt/fdt_check.c       |  74 +++
>  lib/libfdt/fdt_empty_tree.c  |  48 +-
>  lib/libfdt/fdt_overlay.c     | 881 +++++++++++++++++++++++++++++++++++
>  lib/libfdt/fdt_ro.c          | 512 +++++++++++++++-----
>  lib/libfdt/fdt_rw.c          | 231 +++++----
>  lib/libfdt/fdt_strerror.c    |  53 +--
>  lib/libfdt/fdt_sw.c          | 297 ++++++++----
>  lib/libfdt/fdt_wip.c         |  90 ++--
>  lib/string.c                 |  30 +-
>  21 files changed, 2890 insertions(+), 830 deletions(-)
>  create mode 100644 lib/libfdt/fdt_addresses.c
>  create mode 100644 lib/libfdt/fdt_check.c
>  create mode 100644 lib/libfdt/fdt_overlay.c
> 
> -- 
> 2.25.1
>

Just tried to give this a test run, but I couldn't compile it on my x86
Fedora machine with my cross compiler:

  gcc-aarch64-linux-gnu-9.2.1-3.fc32.1.x86_64 

Every file that includes libfdt_env.h gives me a message like this

In file included from lib/libfdt/fdt_overlay.c:7:
lib/libfdt/libfdt_env.h:13:10: fatal error: stdlib.h: No such file or directory
   13 | #include <stdlib.h>
      |          ^~~~~~~~~~
compilation terminated

So I commented out the #include line to see why it was there. We need
strtoul(). I quick hacked an incomplete one (below) and was able to
compile and run tests. However I see that 'make clean' is leaving behind
several libfdt files

$ git clean -ndx
Would remove lib/libfdt/.fdt.d
Would remove lib/libfdt/.fdt_addresses.d
Would remove lib/libfdt/.fdt_check.d
Would remove lib/libfdt/.fdt_empty_tree.d
Would remove lib/libfdt/.fdt_overlay.d
Would remove lib/libfdt/.fdt_ro.d
Would remove lib/libfdt/.fdt_rw.d
Would remove lib/libfdt/.fdt_strerror.d
Would remove lib/libfdt/.fdt_sw.d
Would remove lib/libfdt/.fdt_wip.d

Thanks,
drew

diff --git a/lib/stdlib.h b/lib/stdlib.h
new file mode 100644
index 000000000000..23a3f318d526
--- /dev/null
+++ b/lib/stdlib.h
@@ -0,0 +1,4 @@
+#ifndef _STDLIB_H_
+#define _STDLIB_H_
+unsigned long int strtoul(const char *nptr, char **endptr, int base);
+#endif
diff --git a/lib/string.c b/lib/string.c
index 9258625c3d15..2336559cd5a1 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -6,6 +6,7 @@
  */
 
 #include "libcflat.h"
+#include "stdlib.h"
 
 size_t strlen(const char *buf)
 {
@@ -161,7 +162,7 @@ void *memchr(const void *s, int c, size_t n)
     return NULL;
 }
 
-long atol(const char *ptr)
+static long __atol(const char *ptr, char **endptr)
 {
     long acc = 0;
     const char *s = ptr;
@@ -189,9 +190,23 @@ long atol(const char *ptr)
     if (neg)
         acc = -acc;
 
+    if (endptr)
+        *endptr = (char *)s;
+
     return acc;
 }
 
+long atol(const char *ptr)
+{
+       return __atol(ptr, NULL);
+}
+
+unsigned long int strtoul(const char *nptr, char **endptr, int base)
+{
+       assert(base == 10);
+       return __atol(nptr, endptr);
+}
+
 extern char **environ;
 
 char *getenv(const char *name)

