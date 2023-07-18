Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168657589B1
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 01:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjGRXx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 19:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjGRXwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 19:52:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192473AA9
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:50:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57704aa6c69so55494427b3.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 16:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724165; x=1692316165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGXSnNz9o61Nw72V9XtLKU+I8mKv7z4NMyFHcn8MEno=;
        b=GviMnBBwU8oJFlQ10qq8pyNxF7L9mJcuxalCPWoh/bF9ok9oEX2NUjJa9KKrHhYi87
         XvlFcjanaIMk8EerhhIcwP5vtcQhJw/XsBuHfBW7ujLq/QBtekbPZhEy0L3zssjX4Os4
         HCkDWaXzBMGWrEbehtYy6wCVBKkJl3f6UoLTxyqF6qjG/S5GIRtbBPwaqMWsXI2EE2Ex
         NTvB3XEVI69qVZ02zJuKcraIox6wsBhFnvj0wE9fUxuTn7iTtsBzcdr5PGVMvlBBbZgO
         uGQ5KBwtnA8Asre36kaUD4NkR+B+Hy37JeEBxvmqP4a9xALjBPGXbUZlkCkQaErZ6C1E
         xXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724165; x=1692316165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGXSnNz9o61Nw72V9XtLKU+I8mKv7z4NMyFHcn8MEno=;
        b=OBPmvT8KBv2zwnHA1/5piK1fbVAkkNJrxEUofr0azYEwL20cX0mUyrqX3UpyPfgICu
         q9qMfVJ6x3cHNwEp+3Xk3Ut3M5lX8Y3VaBfTkZ3qEIAxZ9fP+4o+oEgMiNKNuOoOFXsf
         4xsKiJDcGJnBsKsufSHrah1KOfdKyMHVNy7QJiJ/9nAoM3Kav0l53RdaEeHq1XesM1Zb
         wdF4mUtO3MQBZ7YgzcRpJMNP07dmTMCOo3irwMEmIVql6qfTRynM5xrQzVbDwX8DnCxA
         618tXpBUmhSxjvX1lRUknam8HOf33nNcySd/eBB2ErUUzIHJcWmyXbez1Gb3kBCYgwp6
         jEhQ==
X-Gm-Message-State: ABy/qLZC4rrsq8pH70/loqXe8CYAl1v6wPdKtMEYthNT7vr0G3guU45Y
        0vbSWBk2Lbuz/H5qwPHRkbQxh8HDn/0=
X-Google-Smtp-Source: APBJJlGDd5tbMIE4K9RYtlnEKXGejfF7CjNXrlXhKKgJKz78WoWlRr188h2THM+j/ruWPDM9LNr5r2ORq68=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:378a:0:b0:c6e:269e:953a with SMTP id
 e132-20020a25378a000000b00c6e269e953amr12921yba.3.1689724165651; Tue, 18 Jul
 2023 16:49:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 18 Jul 2023 16:45:11 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-29-seanjc@google.com>
Subject: [RFC PATCH v11 28/29] KVM: selftests: Add basic selftest for guest_memfd()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to verify the basic functionality of guest_memfd():

+ file descriptor created with the guest_memfd() ioctl does not allow
  read/write/mmap operations
+ file size and block size as returned from fstat are as expected
+ fallocate on the fd checks that offset/length on
  fallocate(FALLOC_FL_PUNCH_HOLE) should be page aligned

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 114 ++++++++++++++++++
 2 files changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index fdc7dff8d6ae..18c43336ede3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -123,6 +123,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_memfd_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
new file mode 100644
index 000000000000..d698f9fde987
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright Intel Corporation, 2023
+ *
+ * Author: Chao Peng <chao.p.peng@linux.intel.com>
+ */
+
+#define _GNU_SOURCE
+#include "test_util.h"
+#include "kvm_util_base.h"
+#include <linux/falloc.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+
+static void test_file_read_write(int fd)
+{
+	char buf[64];
+
+	TEST_ASSERT(read(fd, buf, sizeof(buf)) < 0,
+		    "read on a guest_mem fd should fail");
+	TEST_ASSERT(write(fd, buf, sizeof(buf)) < 0,
+		    "write on a guest_mem fd should fail");
+	TEST_ASSERT(pread(fd, buf, sizeof(buf), 0) < 0,
+		    "pread on a guest_mem fd should fail");
+	TEST_ASSERT(pwrite(fd, buf, sizeof(buf), 0) < 0,
+		    "pwrite on a guest_mem fd should fail");
+}
+
+static void test_mmap(int fd, size_t page_size)
+{
+	char *mem;
+
+	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	ASSERT_EQ(mem, MAP_FAILED);
+}
+
+static void test_file_size(int fd, size_t page_size, size_t total_size)
+{
+	struct stat sb;
+	int ret;
+
+	ret = fstat(fd, &sb);
+	TEST_ASSERT(!ret, "fstat should succeed");
+	ASSERT_EQ(sb.st_size, total_size);
+	ASSERT_EQ(sb.st_blksize, page_size);
+}
+
+static void test_fallocate(int fd, size_t page_size, size_t total_size)
+{
+	int ret;
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, total_size);
+	TEST_ASSERT(!ret, "fallocate with aligned offset and size should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			page_size - 1, page_size);
+	TEST_ASSERT(ret, "fallocate with unaligned offset should fail");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size, page_size);
+	TEST_ASSERT(ret, "fallocate beginning at total_size should fail");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size + page_size, page_size);
+	TEST_ASSERT(ret, "fallocate beginning at total_size should fail");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			total_size, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at total_size should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			total_size + page_size, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) after total_size should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			page_size, page_size - 1);
+	TEST_ASSERT(ret, "fallocate with unaligned size should fail");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			page_size, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) with aligned offset and size should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, page_size, page_size);
+	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
+}
+
+
+int main(int argc, char *argv[])
+{
+	size_t page_size;
+	size_t total_size;
+	int fd;
+	struct kvm_vm *vm;
+
+	page_size = getpagesize();
+	total_size = page_size * 4;
+
+	vm = vm_create_barebones();
+
+	fd = vm_create_guest_memfd(vm, total_size, 0);
+
+	test_file_read_write(fd);
+	test_mmap(fd, page_size);
+	test_file_size(fd, page_size, total_size);
+	test_fallocate(fd, page_size, total_size);
+
+	close(fd);
+}
-- 
2.41.0.255.g8b1d071c50-goog

