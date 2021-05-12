Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28537EF56
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 01:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347612AbhELXE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 19:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388524AbhELVtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 17:49:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E79C061260
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 14:45:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so29611327ybn.21
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 14:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SSP4iK7kQof7O+I0mY5Yx7zKhq95LDgOK3FrtnCssfc=;
        b=WYmdCGITKjUOQQSZswfLUeNGLxUkRHPTAVYlSBsC9FXawghwF25YW7fD6LHQiXpZoV
         Y/zUoelCiLBKEj1zL/r1oV6g+hJZxnrDqVYXrIPkBw86ysHxuA+lMCwOvdAeXFr6uu2H
         GxDmEcEEMUmKNaq0FbXVHhNu5yAFr9e2WjRYnBXtYzhpbLgxLXKEYkFew3g3PAF0RTpY
         knBGHyGcISUKVmt6pZdhaWt8iYuJG5J3Jue6SOxF4rzEbfg0jc1AT0jaQdWvBxZwN+DW
         hrRX90XUub3WRf7M3yYCGJzePD8d7PKwDuycNVqd+QS5krQVpGJSphRvW+9EqaSp3A5j
         GQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SSP4iK7kQof7O+I0mY5Yx7zKhq95LDgOK3FrtnCssfc=;
        b=IoJiDswMyXC29dj6PnO7WtBEUclipQN6Q1hiBPTuk/egBVIpg/+itsKeKPL3/PzpTY
         oHO6F12GktxZhFwkjmI7LhpHiEPaCEqV8hBxOERlFp5e5byeG/ZqWtuiBtKZT+UGGnxG
         uNInq2mSqfKAPMDsdLl5R/xmotvtW0Q71Foqp/dGDZ4bGT0anybnQ0OqdyAvs7GDDjaY
         1siY3BtyW7QWIQRfBCz0fGFG8RVd0mbabupvWTTQA/RjIGQ05mj8bTUKemEjf1LyNKFV
         D8Lt3kpCMpHCwVYW3gVDBPHZpFoEQzNuKmNuqOWmeWsIpXnMfDr1nCiZOq/QKDeN0naq
         ++Iw==
X-Gm-Message-State: AOAM532UjU7G0py6XhD3bYgva0miAf7H2AcYlaAW9DA6AhK+lJW7Du0Y
        WM9qYLHLzEHunGS5fIU0cALl2wyxd8MzsDizbBjW
X-Google-Smtp-Source: ABdhPJwqmFAoNNkGc7hecA9VlWtADbzv/7DZGn54W2mNkU4f/bU+2cysakOIUeg/gBZANgkKjybDmotUdnpfozeZDGqZ
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:29e5:10fc:1128:b0c0])
 (user=axelrasmussen job=sendgmr) by 2002:a25:9bc6:: with SMTP id
 w6mr51455382ybo.159.1620855911479; Wed, 12 May 2021 14:45:11 -0700 (PDT)
Date:   Wed, 12 May 2021 14:45:00 -0700
In-Reply-To: <20210512214502.2047008-1-axelrasmussen@google.com>
Message-Id: <20210512214502.2047008-4-axelrasmussen@google.com>
Mime-Version: 1.0
References: <20210512214502.2047008-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH 3/5] KVM: selftests: create alias mappings when using shared memory
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a memory region is added with a src_type specifying that it should
use some kind of shared memory, also create an alias mapping to the same
underlying physical pages.

And, add an API so tests can get access to these alias addresses.
Basically, for a guest physical address, let us look up the analogous
host *alias* address.

In a future commit, we'll modify the demand paging test to take
advantage of this to exercise UFFD minor faults. The idea is, we
pre-fault the underlying pages *via the alias*. When the *guest*
faults, it gets a "minor" fault (PTEs don't exist yet, but a page is
already in the page cache). Then, the userfaultfd theads can handle the
fault: they could potentially modify the underlying memory *via the
alias* if they wanted to, and then they install the PTEs and let the
guest carry on via a UFFDIO_CONTINUE ioctl.

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 50 +++++++++++++++++++
 .../selftests/kvm/lib/kvm_util_internal.h     |  2 +
 3 files changed, 53 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8f022794ce3..0624f25a6803 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -146,6 +146,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
 /*
  * Address Guest Virtual to Guest Physical
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6fbe124e0e16..838d58633f7e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -809,6 +809,19 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	/* Add to linked-list of memory regions. */
 	list_add(&region->list, &vm->userspace_mem_regions);
+
+	/* If shared memory, create an alias. */
+	if (region->fd >= 0) {
+		region->mmap_alias = mmap(NULL, region->mmap_size,
+					  PROT_READ | PROT_WRITE,
+					  vm_mem_backing_src_alias(src_type)->flag,
+					  region->fd, 0);
+		TEST_ASSERT(region->mmap_alias != MAP_FAILED,
+			    "mmap of alias failed, errno: %i", errno);
+
+		/* Align host alias address */
+		region->host_alias = align(region->mmap_alias, alignment);
+	}
 }
 
 /*
@@ -1237,6 +1250,43 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 	return -1;
 }
 
+/*
+ * Address VM physical to Host Virtual *alias*.
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gpa - VM physical address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Equivalent address within the host virtual *alias* area, or NULL
+ *   (without failing the test) if the guest memory is not shared (so
+ *   no alias exists).
+ *
+ * When vm_create() and related functions are called with a shared memory
+ * src_type, we also create a writable, shared alias mapping of the
+ * underlying guest memory. This allows the host to manipulate guest memory,
+ * e.g. to implement demand paging.
+ */
+void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	struct userspace_mem_region *region;
+
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
+		if (!region->host_alias)
+			continue;
+
+		if ((gpa >= region->region.guest_phys_addr)
+			&& (gpa <= (region->region.guest_phys_addr
+				+ region->region.memory_size - 1)))
+			return (void *) ((uintptr_t) region->host_alias
+				+ (gpa - region->region.guest_phys_addr));
+	}
+
+	return NULL;
+}
+
 /*
  * VM Create IRQ Chip
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 91ce1b5d480b..a25af33d4a9c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -16,7 +16,9 @@ struct userspace_mem_region {
 	int fd;
 	off_t offset;
 	void *host_mem;
+	void *host_alias;
 	void *mmap_start;
+	void *mmap_alias;
 	size_t mmap_size;
 	struct list_head list;
 };
-- 
2.31.1.607.g51e8a6a459-goog

