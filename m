Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9BE121BE0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 22:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfLPVgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 16:36:08 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:43587 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfLPVgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 16:36:07 -0500
Received: by mail-pf1-f202.google.com with SMTP id x199so7715409pfc.10
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 13:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uVc2axwkCnCZhi+X312ppAdnVSbc0L4toMqGqZnNMKw=;
        b=WpvSEkDZ3zGJQkjjyek7brDRW8CLSSj/z+kyUghXynSz0CIPG/Pkh7uHpylMv+lsCV
         TBEOmtduByp41X120yvyW+L8fCIYUmgUBI2aEGCvxzdYsI003XS4/mLtP0CVM1msY+Hk
         5WO1bpSwfIZ7uZQCdxwxrvfo2tA7Ek7XaxrYgUxw9C2BdjXTgXH9m8uVA2BgZNxcZJ5S
         /NOeN4RMYprVaCR06rF4KVOnuh8Dj7m4BetXNrBKpZt0L7wLeuagWrJS0QyOcKe/dODK
         sID4umEhHdU1D/KEoA6ciVgckNKpatKM3u+B/Qu76ggC+9Fw1kJa86qkXsaUrnSxE8kA
         XBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uVc2axwkCnCZhi+X312ppAdnVSbc0L4toMqGqZnNMKw=;
        b=qe/MPJPwpVLrzuDjqEzxer2+SelbdLp92ZQNWD3R+DvqkTXxlSAeHdekaI9fMjuKc2
         xSoxeIyuaUzz8CkGWoeGf5XdC9ZRkDPeBn8E4xjHJWkQZUGec6q/pmvLODRn6vIKh2y7
         IomALZGcUXzUI8nbxysE58oxmdQzUHMGn5LodqFHca6nsczUIMp8tjbCoQwYRdcHOdyb
         W3goUhIcJXzdZBopAkr7+93GMpxhzva0CozMMTYJRGFgUTcfcxayRsRQwUtGqpyZtTzh
         MhR0SznULGAib8lLA2Zh9WGWlPMWQxEhJzGfeRZdoh3g/TwMtp7Xl6ehlnoTZUUDwp8m
         J5bw==
X-Gm-Message-State: APjAAAXiPYmCPF9j6jPHTnhgj6fCP0TsnzpDW4lr5ViYcvAtJ1HF0Ex0
        0DLy6EPFhFjtF3vtL8cUsXhuonw1M8o3
X-Google-Smtp-Source: APXvYqxAvjI7NezKNIRCnRAWCElstJUl5eVy0r8/FtYh7zCfXc8erNLof+lG3knmkBtIjjVxutbT4Tg4gE8y
X-Received: by 2002:a63:1662:: with SMTP id 34mr20427182pgw.77.1576532166453;
 Mon, 16 Dec 2019 13:36:06 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:35:31 -0800
In-Reply-To: <20191216213532.91237-1-bgardon@google.com>
Message-Id: <20191216213532.91237-9-bgardon@google.com>
Mime-Version: 1.0
References: <20191216213532.91237-1-bgardon@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v2 8/8] KVM: selftests: Add parameter to _vm_create for
 memslot 0 base paddr
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM creates internal memslots between 3 and 4 GiB paddrs on the first
vCPU creation. If memslot 0 is large enough it collides with these
memslots an causes vCPU creation to fail. Add a paddr parameter for
memslot 0 so that tests which support large VMs can relocate memslot 0
above 4 GiB.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 41cf45416060f..886d58e6cac39 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -113,6 +113,8 @@ const char * const vm_guest_mode_string[] = {
 _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
 	       "Missing new mode strings?");
 
+#define KVM_INTERNAL_MEMSLOTS_START_PADDR (3UL << 30)
+#define KVM_INTERNAL_MEMSLOTS_END_PADDR (4UL << 30)
 /*
  * VM Create
  *
@@ -128,13 +130,16 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
  *
  * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
  * When phy_pages is non-zero, a memory region of phy_pages physical pages
- * is created and mapped starting at guest physical address 0.  The file
- * descriptor to control the created VM is created with the permissions
- * given by perm (e.g. O_RDWR).
+ * is created. If phy_pages is less that 3G, it is mapped starting at guest
+ * physical address 0. If phy_pages is greater than 3G it is mapped starting
+ * 4G into the guest physical address space to avoid KVM internal memslots
+ * which map the region between 3G and 4G. The file descriptor to control the
+ * created VM is created with the permissions given by perm (e.g. O_RDWR).
  */
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
+	uint64_t guest_paddr = 0;
 
 	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
@@ -227,9 +232,11 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
+	if (guest_paddr + phy_pages > KVM_INTERNAL_MEMSLOTS_START_PADDR)
+		guest_paddr = KVM_INTERNAL_MEMSLOTS_END_PADDR;
 	if (phy_pages != 0)
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    0, 0, phy_pages, 0);
+					    guest_paddr, 0, phy_pages, 0);
 
 	return vm;
 }
-- 
2.24.1.735.g03f4e72817-goog

