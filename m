Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B532A73B846
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjFWMzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjFWMzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 08:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514D810C1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687524867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9FlVKICNiWWOTLAUDVXkMHSMxYT88XK2ozTojvfz0A=;
        b=J6LZkQBjJkYW3wA9sw9JG802GcjICKARFu7oCNjvtG5qUJSSndJk2D3GgqbF9UTyyqDuLB
        45v04xoGPSCubirVx6mofN4hVVi0xZb1zK5nxFRPbEs8otMGKbqC/XUQZcTdk2QLpVVipn
        Kez9mBM4Hdyl82bTSheLO0nO5Hp8BRE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-rj93KqrSNS6LOwWJEI-KbQ-1; Fri, 23 Jun 2023 08:54:24 -0400
X-MC-Unique: rj93KqrSNS6LOwWJEI-KbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAB3E3C11CD3;
        Fri, 23 Jun 2023 12:54:23 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEF0CF41C8;
        Fri, 23 Jun 2023 12:54:21 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PATCH 1/2] Rework the common LDFLAGS to become more useful again
Date:   Fri, 23 Jun 2023 14:54:15 +0200
Message-Id: <20230623125416.481755-2-thuth@redhat.com>
In-Reply-To: <20230623125416.481755-1-thuth@redhat.com>
References: <20230623125416.481755-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the LDFLAGS settings from the main Makefile are ignored in
most architecture specific directories (except s390x), which is very
confusing when you try to add a linker switch for all architectures.

Let's change this so that all architectures extend the common LDFLAGS
instead of replacing them. So it is sufficient now to specify the
"-nostdlib" switch in the main Makefile now instead of repeating it
everywhere.

While we're at it, avoid to repeat the whole set of CFLAGS in the
common LDFLAGS - the options that are meant for the C compiler should
not be exposed unconditionally to the linker.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile                | 2 +-
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 s390x/Makefile          | 2 +-
 x86/Makefile.common     | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 6ed5deac..0e5d85a1 100644
--- a/Makefile
+++ b/Makefile
@@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
-LDFLAGS += $(CFLAGS)
+LDFLAGS += -nostdlib
 
 $(libcflat): $(cflatobjs)
 	$(AR) rcs $@ $^
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 1bbec64f..e2cb1a56 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -60,7 +60,7 @@ libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
-%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
+%.elf: LDFLAGS += $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.elf=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 8ce00340..f8f47490 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -49,7 +49,7 @@ OBJDIRS += lib/powerpc
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS += $(arch_CFLAGS)
-%.elf: LDFLAGS = $(arch_LDFLAGS) -nostdlib -pie -n
+%.elf: LDFLAGS += $(arch_LDFLAGS) -pie -n
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$@\"
diff --git a/s390x/Makefile b/s390x/Makefile
index a80db538..d75e86c2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,7 +76,7 @@ CFLAGS += -O2
 CFLAGS += -march=zEC12
 CFLAGS += -mbackchain
 CFLAGS += -fno-delete-null-pointer-checks
-LDFLAGS += -nostdlib -Wl,--build-id=none
+LDFLAGS += -Wl,--build-id=none
 
 # We want to keep intermediate files
 .PRECIOUS: %.o %.lds
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 365e199f..e64aac52 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -31,7 +31,7 @@ endif
 
 OBJDIRS += lib/x86
 
-$(libcflat): LDFLAGS += -nostdlib $(arch_LDFLAGS)
+$(libcflat): LDFLAGS += $(arch_LDFLAGS)
 $(libcflat): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I lib
 
 COMMON_CFLAGS += -m$(bits)
@@ -62,7 +62,7 @@ else
 # We want to keep intermediate file: %.elf and %.o
 .PRECIOUS: %.elf %.o
 
-%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
+%.elf: LDFLAGS += $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
 	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
-- 
2.39.3

