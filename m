Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599A345FF6
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhCWNll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:41:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231614AbhCWNlc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 09:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616506891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PAu5IaeDsUmeRreZhd7DmiQP94yHSG5C2o5FekMnq1c=;
        b=hCpSaEekeN9VVB4UN45cBLDgmqZb+fsg9yfMNY1YobXwEAl6JLLcTQgX+UfMxkUWm6YuhA
        orR2y21GhEqCVPa8gM2rAEt43Wg4Bub4lUW29w35HL/Ox6vDPCBFDF2faNVWrEVB3T5F8L
        vNBy+LilBNNV5ZXIzFds3lRz7kroX5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-5zc7UbpuOj-wcACe4tWQQQ-1; Tue, 23 Mar 2021 09:41:27 -0400
X-MC-Unique: 5zc7UbpuOj-wcACe4tWQQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49C5E100746C;
        Tue, 23 Mar 2021 13:41:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A63875C1C5;
        Tue, 23 Mar 2021 13:41:24 +0000 (UTC)
Date:   Tue, 23 Mar 2021 14:41:21 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210323134121.h4pybwqqwruhomrr@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
 <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
 <20210323130001.7f160eaa@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323130001.7f160eaa@slackpad.fritz.box>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 01:00:01PM +0000, Andre Przywara wrote:
> On Tue, 23 Mar 2021 13:14:15 +0100
> Andrew Jones <drjones@redhat.com> wrote:
> 
> Hi,
> 
> > On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:
> > > @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
> > >              c = *s - 'A' + 10;
> > >          else
> > >              break;
> > > -        acc = acc * base + c;
> > > +
> > > +        if (is_signed) {
> > > +            long __acc = (long)acc;
> > > +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> > > +            assert(!overflow);
> > > +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> > > +            assert(!overflow);
> > > +            acc = (unsigned long)__acc;
> > > +        } else {
> > > +            overflow = __builtin_umull_overflow(acc, base, &acc);
> > > +            assert(!overflow);
> > > +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> > > +            assert(!overflow);
> > > +        }
> > > +  
> > 
> > Unfortunately my use of these builtins isn't loved by older compilers,
> > like the one used by the build-centos7 pipeline in our gitlab CI. I
> > could wrap them in an #if GCC_VERSION >= 50100 and just have the old
> > 'acc = acc * base + c' as the fallback, but that's not pretty and
> > would also mean that clang would use the fallback too. Maybe we can
> > try and make our compiler.h more fancy in order to provide a
> > COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
> > both gcc and clang. Or, we could just forgot the overflow checking.
> 
> In line with my email from yesterday:
> Before we go down the path of all evil (premature optimisation!), can't
> we just copy
> https://git.kernel.org/pub/scm/libs/klibc/klibc.git/tree/usr/klibc/strntoumax.c
> and have a tested version that works everywhere? This is BSD/GPL dual
> licensed, IIUC.
> I don't really see the reason to performance optimise strtol in the
> context of kvm-unit-tests.
>

Using the builtin isn't to optimize, it's to simplify. Checking for
overflow on multiplication is ugly business. As I said yesterday,
klibc doesn't do any error checking. We could choose to go that
way too, but I'd prefer we give a best effort to making the test
framework robust.

I quick pulled together the diff below. This gives us the overflow
checking when not using old compilers, but just falls back to the
simple math otherwise. Unless people have strong opinions about
that, then I'm inclined to go with it.

Thanks,
drew


diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 2d72f18c36e5..311da9807932 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -8,6 +8,20 @@
 
 #ifndef __ASSEMBLY__
 
+#define GCC_VERSION (__GNUC__ * 10000           \
+                    + __GNUC_MINOR__ * 100     \
+                    + __GNUC_PATCHLEVEL__)
+
+#ifdef __clang__
+#if __has_builtin(__builtin_mul_overflow) && \
+    __has_builtin(__builtin_add_overflow) && \
+    __has_builtin(__builtin_sub_overflow)
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+#elif GCC_VERSION >= 50100
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+
 #include <stdint.h>
 
 #define barrier()      asm volatile("" : : : "memory")
diff --git a/lib/string.c b/lib/string.c
index b684271bb18f..e323908fe24e 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -7,6 +7,7 @@
 
 #include "libcflat.h"
 #include "stdlib.h"
+#include "linux/compiler.h"
 
 size_t strlen(const char *buf)
 {
@@ -171,7 +172,6 @@ static unsigned long __strtol(const char *nptr, char **endptr,
                               int base, bool is_signed) {
     unsigned long acc = 0;
     const char *s = nptr;
-    bool overflow;
     int neg, c;
 
     assert(base == 0 || (base >= 2 && base <= 36));
@@ -210,19 +210,23 @@ static unsigned long __strtol(const char *nptr, char **endptr,
         else
             break;
 
+#ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
         if (is_signed) {
             long __acc = (long)acc;
-            overflow = __builtin_smull_overflow(__acc, base, &__acc);
+            bool overflow = __builtin_smull_overflow(__acc, base, &__acc);
             assert(!overflow);
             overflow = __builtin_saddl_overflow(__acc, c, &__acc);
             assert(!overflow);
             acc = (unsigned long)__acc;
         } else {
-            overflow = __builtin_umull_overflow(acc, base, &acc);
+            bool overflow = __builtin_umull_overflow(acc, base, &acc);
             assert(!overflow);
             overflow = __builtin_uaddl_overflow(acc, c, &acc);
             assert(!overflow);
         }
+#else
+        acc = acc * base + c;
+#endif
 
         s++;
     }

