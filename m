Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F8E67ACDC
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 09:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbjAYIyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 03:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjAYIxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 03:53:49 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B0829159
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 00:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674636826; x=1706172826;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=A8gmcN6JKfeSEuDQLAdBHz86LKi0XImCOBNbrUmMCYA=;
  b=LiMb5sqk2sLGBeyb1Tayk64Rohdsc54etxOnCD7xHal6+MC+3mmdaa7R
   BmLHCUQLckwbdz/KjHKwzF15W02vGt8plS02BD9sveKnf3c0dGQVYZF5z
   iauqDLKY7Vs0hA394YrkUnF4zOHN/J6PSfrTWgMQXvoMR0CNa/h5QUzxn
   otzMmXZg2BAwcBHhWo04fMorhMEzXkdgDzaoVVb7zu7NwNbsx+AEvPM+v
   cBnHW3vJx106WwWbqoj9mmhOpT+giakfLERM5ldfKyIA2KFt+V2/fwtIn
   3x5Xoi2yBqF5uRI50NzFJkyeOLeV6jnKv1JEw1W0goqWQmSrkBT0W1j7r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306862595"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="306862595"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 00:53:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="694672205"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="694672205"
Received: from wangbolu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.33])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 00:53:44 -0800
Date:   Wed, 25 Jan 2023 16:53:50 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com
Subject: A question of KVM selftests' makefile
Message-ID: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

  Currently, unlike the build system of Linux kernel, KVM selftests will
have to run "make clean && make" to rebuild the entire test suite, once
a header file is modified.

  Is it designed like this on purpose, or does anyone wanna change it?

  I hacked the makefile by using "-MD" as EXTRA_CFLAGS, so that dependency
rules can be generated for each target object, whose prerequisites contains
the source file and the included header files as well.

  However, this change has its own costs. E.g., new ".o" and ".d" files will
occupy more storage. And performance-wise, the benifit could be limited,
because for now, most header files are needed by almost every ".c" files.
But with the evolution of KVM selftests, more ".h" files may be added. Some
of which may be of special usage. E.g., file "include/x86_64/mce.h" is only
used by "x86_64/ucna_injection_test". Having to rebuild the whole test suite
just because one specific header is touched would be annoying.

  I am not sure if this change is worthy, or if there's a better solution.
So does anyone have any suggestion? 

  Below are my current hack in KVM selftest's makefile in case someone is
interested. It can not be optimal and any comment is welcome. Thanks!

B.R.
Yu

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..b329e0d1a460 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -180,6 +180,8 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
 LIBKVM += $(LIBKVM_$(ARCH_DIR))

+OVERRIDE_TARGETS = 1
+
 # lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
 # importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
 # which causes the environment variable to override the makefile).
@@ -198,9 +200,11 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
        -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
        -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
        -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-       -I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
+       -I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. \
        $(KHDR_INCLUDES)

+EXTRA_CFLAGS += -MD
+
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)

@@ -218,11 +222,22 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)

-EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
+TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_OBJ))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
+-include $(TEST_DEP_FILES)
+
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
+       $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM_OBJS) $(LDLIBS) -o $@
+$(TEST_GEN_OBJ): %.o: %.c
+       $(CC) $(CFLAGS) $(CPPFLAGS) $(EXTRA_CFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+EXTRA_CLEAN += $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) cscope.*

 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
-       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+       $(CC) $(CFLAGS) $(CPPFLAGS) $(EXTRA_CFLAGS) $(TARGET_ARCH) -c $< -o $@

 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
        $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

