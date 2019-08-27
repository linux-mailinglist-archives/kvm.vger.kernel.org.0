Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C279E8C3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfH0NKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfH0NKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:10:33 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC2B291764
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 13:10:32 +0000 (UTC)
Received: by mail-pl1-f197.google.com with SMTP id g9so11978071plo.21
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 06:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aWwznrHbktCysNaadwrasS9SqCvefDZhspO3NcJLJag=;
        b=sTHaPjpZBaZPMoh/yK/cCPTZrdvnvMZQl4h4cBo+YvqHyTjnQYAgxRkmY35FDjVsar
         Ia7vmOw1wfIY/DfhKHXREVUJ20dygCoBp3BgQ9wWGSwHF1LIRUqlqmGftLyqtcQFSuUi
         +aRMmnSLo5NZ6xYiyYL6ro1Jjj1gpju9WUfwDuw3vIWGK6sy4kFJ19siHJI4HBotHGgs
         xKUj38XnutGFXNMtyxoi/LKDRN3ohRT4Cd8v3e4b6ydeFO/2yI9xOjrjb+4gCVMK1B7T
         8JsgQ5ShKZHUtEoBl3MaiCsxR/sDBH5Bkf3D7T8WvT01Yrtc5gmEwy7nwobW9e8QsY/B
         E5MA==
X-Gm-Message-State: APjAAAUg3P2mR02IV5JKfeB202rJ5AzA0nezfDCTfHH04edMVUuks4mL
        iun6DQFuq6RTCwGGhKA377Z5abuHTgYU0rmtS35m9re76JuUhOGGwT9XDeDrtDd1zlIx+5emEoC
        P8n0tHj2tL0kr
X-Received: by 2002:aa7:92d1:: with SMTP id k17mr14949042pfa.160.1566911432417;
        Tue, 27 Aug 2019 06:10:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx48z0+CCC4eCbKlPab7hOWex06NfVdp+8FiKZGqLijkMIxQzf/mIKsGnead5K0rz9xsUdHIQ==
X-Received: by 2002:aa7:92d1:: with SMTP id k17mr14949023pfa.160.1566911432195;
        Tue, 27 Aug 2019 06:10:32 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o67sm24393050pfb.39.2019.08.27.06.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 06:10:31 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH 1/4] KVM: selftests: Move vm type into _vm_create() internally
Date:   Tue, 27 Aug 2019 21:10:12 +0800
Message-Id: <20190827131015.21691-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827131015.21691-1-peterx@redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 12 +++--------
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 20 ++++++++++++-------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index dc3346e090f5..424efcf8c734 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -249,14 +249,13 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 }
 
 static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
-				uint64_t extra_mem_pages, void *guest_code,
-				unsigned long type)
+				uint64_t extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
 	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
 
 	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
-			O_RDWR, type);
+			O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
@@ -273,7 +272,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	struct kvm_vm *vm;
 	uint64_t max_gfn;
 	unsigned long *bmap;
-	unsigned long type = 0;
 
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
@@ -314,10 +312,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
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
@@ -351,7 +345,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code, type);
+	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
 
 #ifdef USE_CLEAR_DIRTY_LOG
 	struct kvm_enable_cap cap = {};
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5463b7896a0a..cfc079f20815 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -61,7 +61,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
-			  int perm, unsigned long type);
+			  int perm);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6e49bb039376..0c7c4368bc14 100644
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
@@ -131,7 +131,7 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
  * given by perm (e.g. O_RDWR).
  */
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
-			  int perm, unsigned long type)
+			  int perm)
 {
 	struct kvm_vm *vm;
 
@@ -139,8 +139,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
 	vm->mode = mode;
-	vm->type = type;
-	vm_open(vm, perm, type);
+	vm->type = 0;
 
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
@@ -190,6 +189,13 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
 
+#ifdef __aarch64__
+	if (vm->pa_bits != 40)
+		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
+#endif
+
+	vm_open(vm, perm);
+
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
 	sparsebit_set_num(vm->vpages_valid,
@@ -212,7 +218,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
-	return _vm_create(mode, phy_pages, perm, 0);
+	return _vm_create(mode, phy_pages, perm);
 }
 
 /*
@@ -232,7 +238,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 {
 	struct userspace_mem_region *region;
 
-	vm_open(vmp, perm, vmp->type);
+	vm_open(vmp, perm);
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
-- 
2.21.0

