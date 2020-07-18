Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED9A224A07
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 11:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgGRJL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 05:11:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgGRJL5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jul 2020 05:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595063515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YXOyeyfK3ACOD6XEjJUczttBFVxRcGvCcA2SsYw5mIg=;
        b=Dht1ICi+kezNktMHFziX1jzu5fEw2zZADXcvF7V5nNtzAvCSRzjcrh2grefmG4OOiG3/gl
        1GKvB7UQQHxyXsH4HIdpOddZG08PJuKmb4lu0QjjbHDA6BOsj0Kif4vhAAzCOWz9EBeYYE
        nkcAy1EZ5MTGf193kes7hcT/4o2q4YI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-_T1zoGe8MImMO1oaIkj20Q-1; Sat, 18 Jul 2020 05:11:51 -0400
X-MC-Unique: _T1zoGe8MImMO1oaIkj20Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 894FA800463;
        Sat, 18 Jul 2020 09:11:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09EF460BE2;
        Sat, 18 Jul 2020 09:11:48 +0000 (UTC)
Date:   Sat, 18 Jul 2020 11:11:45 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics
 for GCC >= 10
Message-ID: <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
References: <20200717164727.75580-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717164727.75580-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 17, 2020 at 05:47:27PM +0100, Alexandru Elisei wrote:
> GCC 10.1.0 introduced the -m{,no-}outline-atomics flags which, according to
> man 1 gcc:
> 
> "Enable or disable calls to out-of-line helpers to implement atomic
> operations.  These helpers will, at runtime, determine if the LSE
> instructions from ARMv8.1-A can be used; if not, they will use the
> load/store-exclusive instructions that are present in the base ARMv8.0 ISA.
> [..] This option is on by default."
> 
> Unfortunately the option causes the following error at compile time:
> 
> aarch64-linux-gnu-ld -nostdlib -pie -n -o arm/spinlock-test.elf -T /path/to/kvm-unit-tests/arm/flat.lds \
> 	arm/spinlock-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a lib/arm/libeabi.a arm/spinlock-test.aux.o
> aarch64-linux-gnu-ld: /usr/lib/gcc/aarch64-linux-gnu/10.1.0/libgcc.a(lse-init.o): in function `init_have_lse_atomics':
> lse-init.c:(.text.startup+0xc): undefined reference to `__getauxval'
> 
> This is happening because we are linking against our own libcflat which
> doesn't implement the function __getauxval().
> 
> Disable the use of the out-of-line functions by compiling with
> -mno-outline-atomics if we detect a GCC version greater than 10.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> 
> Tested with gcc versions 10.1.0 and 5.4.0 (cross-compilation), 9.3.0
> (native).
> 
> I've been able to suss out the reason for the build failure from this
> rejected gcc patch [1].
> 
> [1] https://patches.openembedded.org/patch/172460/
> 
>  arm/Makefile.arm64 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index dfd0c56fe8fb..3223cb966789 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -9,6 +9,12 @@ ldarch = elf64-littleaarch64
>  arch_LDFLAGS = -pie -n
>  CFLAGS += -mstrict-align
>  
> +# The -mno-outline-atomics flag is only valid for GCC versions 10 and greater.
> +GCC_MAJOR_VERSION=$(shell $(CC) -dumpversion 2> /dev/null | cut -f1 -d.)
> +ifeq ($(shell expr "$(GCC_MAJOR_VERSION)" ">=" "10"), 1)
> +CFLAGS += -mno-outline-atomics
> +endif

How about this patch instead?

diff --git a/Makefile b/Makefile
index 3ff2f91600f6..0e21a49096ba 100644
--- a/Makefile
+++ b/Makefile
@@ -17,6 +17,11 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
 
 .PHONY: arch_clean clean distclean cscope
 
+# cc-option
+# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
+cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
+              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+
 #make sure env CFLAGS variable is not used
 CFLAGS =
 
@@ -43,12 +48,6 @@ OBJDIRS += $(LIBFDT_objdir)
 #include architecture specific make rules
 include $(SRCDIR)/$(TEST_DIR)/Makefile
 
-# cc-option
-# Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
-
-cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
-              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
-
 COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
 COMMON_CFLAGS += -Wignored-qualifiers -Werror
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index dfd0c56fe8fb..dbc7524d3070 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,9 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 CFLAGS += -mstrict-align
 
+mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
+CFLAGS += $(mno_outline_atomics)
+
 define arch_elf_check =
 	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
 		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))


Thanks,
drew

> +
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
>  		$(error $(shell $(OBJDUMP) -R $(1) 2>&1)))
> -- 
> 2.27.0
> 

