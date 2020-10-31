Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E831E2A184D
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgJaOs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgJaOs7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604155738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OAKgishbcOyJ14kGPjqBQiJlIsNqehaWnVKadYbJ7ZQ=;
        b=Jh/66AJmwe1zkE4kJkkJcLSHalGsta5u1SxqR+Iq1BTDD31sxx5RTpV/DAi+utRKhN0Pd/
        91sJ9k4wUj8AvcdmvfoHmYNCaepjm1p/RqO7B3yeoTGbs+VPQtOFkQcyz6C5eA1z9uioh/
        gIbmT+N7O+6MMX/eyY8ajUcfkTFZ4ts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-zJ9syqC9NLaSDcFs6p-eiA-1; Sat, 31 Oct 2020 10:48:53 -0400
X-MC-Unique: zJ9syqC9NLaSDcFs6p-eiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DBFC802B4C
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 14:48:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0F6A5B4A9
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 14:48:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] port80: remove test
Date:   Sat, 31 Oct 2020 10:48:51 -0400
Message-Id: <20201031144851.3985650-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has not passed port 0x80 directly to the hardware for three years
(commit d59d51f08801, "KVM: VMX: remove I/O port 0x80 bypass on Intel
hosts", 2017-12-05) so the port80 test is a useless duplicate of the
outl_to_pmtimer vmexit test, without the reporting of how long the
access takes and without adaptive choice of the number of iterations.
Remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/Makefile.common |  2 +-
 x86/README          |  1 -
 x86/port80.c        | 12 ------------
 x86/unittests.cfg   |  3 ---
 4 files changed, 1 insertion(+), 17 deletions(-)
 delete mode 100644 x86/port80.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b942086..55f7f28 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -53,7 +53,7 @@ FLATLIBS = lib/libcflat.a $(libgcc)
 	@chmod a-x $@
 
 tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
-               $(TEST_DIR)/smptest.flat  $(TEST_DIR)/port80.flat \
+               $(TEST_DIR)/smptest.flat  \
                $(TEST_DIR)/realmode.flat $(TEST_DIR)/msr.flat \
                $(TEST_DIR)/hypercall.flat $(TEST_DIR)/sieve.flat \
                $(TEST_DIR)/kvmclock_test.flat  $(TEST_DIR)/eventinj.flat \
diff --git a/x86/README b/x86/README
index 218fe1a..8b0b118 100644
--- a/x86/README
+++ b/x86/README
@@ -27,7 +27,6 @@ Tests in this directory and what they do:
  emulator:	move to/from regs, cmps, push, pop, to/from cr8, smsw and lmsw
  hypercall:	intel and amd hypercall insn
  msr:		write to msr (only KERNEL_GS_BASE for now)
- port80:	lots of out to port 80
  realmode:	goes back to realmode, shld, push/pop, mov immediate, cmp
 		immediate, add immediate, io, eflags instructions
 		(clc, cli, etc.), jcc short, jcc near, call, long jmp, xchg
diff --git a/x86/port80.c b/x86/port80.c
deleted file mode 100644
index 791431c..0000000
--- a/x86/port80.c
+++ /dev/null
@@ -1,12 +0,0 @@
-#include "libcflat.h"
-
-int main(void)
-{
-    int i;
-
-    printf("begining port 0x80 write test\n");
-    for (i = 0; i < 10000000; ++i)
-	asm volatile("outb %al, $0x80");
-    printf("done\n");
-    return 0;
-}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index c035c79..b48c98b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -175,9 +175,6 @@ extra_params = -machine vmport=on -cpu host
 check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
 arch = x86_64
 
-[port80]
-file = port80.flat
-
 [realmode]
 file = realmode.flat
 
-- 
2.26.2

