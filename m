Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941AFA2C63
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfH3Bgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH3Bgh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:36:37 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE01D2A09D8
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 01:36:36 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id t2so3102980plq.11
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 18:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OKXdosyqABi9C2gUBPMdwJsytKQYxgvWS0ODiVfOX34=;
        b=Z0r9rS2BNoxYY/KQY/G1aZ1CI70pOvNmIn+6PVFRDwS3GBRp3DrRECdTWs12bHBPzh
         kNDcgTqWidH2NrYK1wx921hpYgJqbYzpHu5NtbxPYSORvHzAyrIMf/9QhcwUcorcoKWi
         22eZq+Q5qVPjaz1i9y503eaeU4dqBRecLW+bVoYEtMUR0O3qJkBSr5peVVDYv+GE27R+
         AuGprDibSXMiGniBGc5OdK29q9lIq/Rl6DhBc7ee65qHkMfsV+9BeFWKfWzA7OHeY6Dy
         OlgecBu1mVPmqHd4EhIyaEWuhab8nveHmQ63QmO5jK8jo0ElDSSRtIwhGfPkKzHXEA7k
         iVjA==
X-Gm-Message-State: APjAAAVlD6gMoVXo5mlbhQnm90nN14DG9FU1837Ac1MNf0+4xwsoK8qx
        9hJ8S6J68Om+0rXXKPyR6GPLgojmw1brtsbjXG9hM/8tT4wOc/0w6Oles9GX+2hCoAB6ogRTo8k
        wngL5gdb9y0sW
X-Received: by 2002:a17:902:bd0b:: with SMTP id p11mr6892600pls.46.1567128996389;
        Thu, 29 Aug 2019 18:36:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyvKrzcXJdENL8MNxQqyEtgoGbu1tY0m/pNl+n78glEILSI7LJ8m8DvTz1e/5Z6rrYimREzuQ==
X-Received: by 2002:a17:902:bd0b:: with SMTP id p11mr6892590pls.46.1567128996150;
        Thu, 29 Aug 2019 18:36:36 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3sm3426323pjq.24.2019.08.29.18.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:36:35 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH v3 1/4] KVM: selftests: Move vm type into _vm_create() internally
Date:   Fri, 30 Aug 2019 09:36:16 +0800
Message-Id: <20190830013619.18867-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190830013619.18867-1-peterx@redhat.com>
References: <20190830013619.18867-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than passing the vm type from the top level to the end of vm
creation, let's simply keep that as an internal of kvm_vm struct and
decide the type in _vm_create().  Several reasons for doing this:

- The vm type is only decided by physical address width and currently
  only used in aarch64, so we've got enough information as long as
  we're passing vm_guest_mode into _vm_create(),

- This removes a loop dependency between the vm->type and creation of
  vms.  That's why now we need to parse vm_guest_mode twice sometimes,
  once in run_test() and then again in _vm_create().  The follow up
  patches will move on to clean up that as well so we can have a
  single place to decide guest machine types and so.

Note that this patch will slightly change the behavior of aarch64
tests in that previously most vm_create() callers will directly pass
in type==0 into _vm_create() but now the type will depend on
vm_guest_mode, however it shouldn't affect any user because all
vm_create() users of aarch64 will be using VM_MODE_DEFAULT guest
mode (which is VM_MODE_P40V48_4K) so at last type will still be zero.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 13 +++---------
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 ++++++++++++-------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ceb52b952637..135cba5c6d0d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -216,14 +216,12 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 }
 
 static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
-				uint64_t extra_mem_pages, void *guest_code,
-				unsigned long type)
+				uint64_t extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
 	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
 
-	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
-			O_RDWR, type);
+	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
@@ -240,7 +238,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	struct kvm_vm *vm;
 	uint64_t max_gfn;
 	unsigned long *bmap;
-	unsigned long type = 0;
 
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
@@ -281,10 +278,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	 * bits we can change to 39.
 	 */
 	guest_pa_bits = 39;
-#endif
-#ifdef __aarch64__
-	if (guest_pa_bits != 40)
-		type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
 #endif
 	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
 	guest_page_size = (1ul << guest_page_shift);
@@ -309,7 +302,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code, type);
+	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
 
 #ifdef USE_CLEAR_DIRTY_LOG
 	struct kvm_enable_cap cap = {};
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e0e66b115ef2..c78faa2ff7f3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -60,8 +60,7 @@ int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
-struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
-			  int perm, unsigned long type);
+struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6e49bb039376..34a8a6572c7c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -84,7 +84,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 	return ret;
 }
 
-static void vm_open(struct kvm_vm *vm, int perm, unsigned long type)
+static void vm_open(struct kvm_vm *vm, int perm)
 {
 	vm->kvm_fd = open(KVM_DEV_PATH, perm);
 	if (vm->kvm_fd < 0)
@@ -95,7 +95,7 @@ static void vm_open(struct kvm_vm *vm, int perm, unsigned long type)
 		exit(KSFT_SKIP);
 	}
 
-	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, type);
+	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
 	TEST_ASSERT(vm->fd >= 0, "KVM_CREATE_VM ioctl failed, "
 		"rc: %i errno: %i", vm->fd, errno);
 }
@@ -130,8 +130,7 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
  * descriptor to control the created VM is created with the permissions
  * given by perm (e.g. O_RDWR).
  */
-struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
-			  int perm, unsigned long type)
+struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
 
@@ -139,8 +138,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
 	vm->mode = mode;
-	vm->type = type;
-	vm_open(vm, perm, type);
+	vm->type = 0;
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
@@ -190,6 +188,13 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
 
+#ifdef __aarch64__
+	if (vm->pa_bits != 40)
+		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
+#endif
+
+	vm_open(vm, perm);
+
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
 	sparsebit_set_num(vm->vpages_valid,
@@ -212,7 +217,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
-	return _vm_create(mode, phy_pages, perm, 0);
+	return _vm_create(mode, phy_pages, perm);
 }
 
 /*
@@ -232,7 +237,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 {
 	struct userspace_mem_region *region;
 
-	vm_open(vmp, perm, vmp->type);
+	vm_open(vmp, perm);
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
-- 
2.21.0

