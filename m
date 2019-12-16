Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3181E121BE4
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 22:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfLPVgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 16:36:14 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:37962 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbfLPVgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 16:36:09 -0500
Received: by mail-pj1-f73.google.com with SMTP id k93so5236995pjh.5
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 13:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rowy0fulnWlicWAYnRVZ1Dd1A8eU5tnc0eErNEZ+z80=;
        b=PsqTJlOqPYyiihmLOLIb6xAhTBSJvttAVNodws3FJbnnkfYipi8xAJuaOwtmKyQzpV
         IFuLnz58ISep0HZjvSM64NS2Zp27Ri/mgzV8FI5s45OLWRWCs7RfCJ30GkYKJF3VG39B
         32PeBFBUiqKu0qqajQ/mVKYHcsPnQnJnB8w+eab63fDZ5tI1IVP27ChhOjD6mhb18f6J
         TlEGQtJHefr8CyAZHH6HxW80kFb1RJ1o7EA1mXWqzoWX7A39js6GAPJIUZp7v34dhOc6
         WeHxvOpYbKrACctym1WFD+zuP11y2mPIyqqk2dplT8wd1ozEtHp79GU169FWnKEMwEMv
         qGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rowy0fulnWlicWAYnRVZ1Dd1A8eU5tnc0eErNEZ+z80=;
        b=iDcxTN9iECsYYQYeWDhFZVyF0imJy7gikys2HyKhtpDOhrilmOWMhU/c7oYxygqKNl
         96MKab/d1XwkFKQBSN5bYI2VbGSmHvDYYKX6mdwAT/JOHuTp/dZxiS+jTlhef+zynvR4
         sWW5dh7YGtZ0pwY9rHUD+rlhV2p8Eht4eKSDSbos3TkGT/hXQu5ot0c+MbBSlApRSGfn
         2fPWHhWehgZrf9GrBYrxRzbMxqvcKz5H6Im8YxJlLqQLXpDtQ+Tuq3hQdjbIH+hqbiP9
         VVcXIHAK8a+pzw/8ovBu3bG6Lc2F3EibOGyqwliW18f6ww7AKHZkLrJG6gV546725kYM
         Jlnw==
X-Gm-Message-State: APjAAAWe7jLmi7OzIBKCXND8yhOzFMsZlY3tsoDTUku155/h5ZWAiRIY
        i8NHSNalD4pf2UHdm/pkWrdoUmvHaRnE
X-Google-Smtp-Source: APXvYqxiDfgt93rcM0223tSoye1p3mg8HWLc1oSc+SjuoE4GYYqQkL10qTfDmi9hqrbIbU4HmdRZj2Z32jnW
X-Received: by 2002:a63:1447:: with SMTP id 7mr20829842pgu.22.1576532168726;
 Mon, 16 Dec 2019 13:36:08 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:35:32 -0800
In-Reply-To: <20191216213532.91237-1-bgardon@google.com>
Message-Id: <20191216213532.91237-10-bgardon@google.com>
Mime-Version: 1.0
References: <20191216213532.91237-1-bgardon@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v2 8/8] KVM: selftests: Move large memslots above KVM internal
 memslots in _vm_create
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
memslots an causes vCPU creation to fail. When requesting more than 3G,
start memslot 0 at 4G in _vm_create.

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

