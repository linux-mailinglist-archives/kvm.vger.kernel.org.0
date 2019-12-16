Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46308121BFE
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfLPVj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 16:39:28 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:44862 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbfLPVjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 16:39:24 -0500
Received: by mail-pg1-f201.google.com with SMTP id o21so4750478pgm.11
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 13:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rowy0fulnWlicWAYnRVZ1Dd1A8eU5tnc0eErNEZ+z80=;
        b=MuHMhVLT/JPmloUwrLfNYvZW2n4et7Jp6otDiIOqsAgsXxhPw0pD+sf+K2Wz1bcwcE
         umHcmexYa3XVrNTFitMJMBYyqjDaET0ivXVKpA1RqVyD8V4224NfFmieT+WL8wxCP9Uf
         TeyVGVkrZUBRPuOJOeUyhrRYRParc+bz/foA7OITtQlAv8YjLXySbTVB+rFX/btl5eqr
         XV2jZIQBXqTrzmvmmJ11xow6XVm8OAB0UlReGxO9v7l0id98TbLh6QDJoZETRv2fkiPo
         RwZ+5HAYVciPWg/rBIsxuRno1YegprlFb+LVfcvaBjDfj2oNEeKU+ibtPCaeMIQ0tu6z
         r+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rowy0fulnWlicWAYnRVZ1Dd1A8eU5tnc0eErNEZ+z80=;
        b=avqdvW8KaeDKzUf3zB4A1+0MjhEA4bYhbZ1WCqfH7uOHLkv6QNKH5cErnIDG34Vhbg
         YHdOk83ifWfhW1yA071Q0a5bkSqjHUrf/JKHD2cMhF6Up600mypd42/wIXKaqiG6rMF4
         TReuoVF7AlRQUX7yJ3utGa6lj042e2DtvoDQypOA8JQfRNNg/QCova2WpPif6e8aV1Ns
         +3Dfz6QD77Q/PXrIb6pLG1s70TrHHN5N3NzZfv7MoCqxbWbA3JYjBgHKOt/y4rKUvMq+
         Sb9HX5z/AoY9p5iMg+KfVBaJFjOdJO0uFQHbSJjbAAhekiLSdwbXfrWlaDrrTIQFDcHJ
         L54g==
X-Gm-Message-State: APjAAAUYYpr8IX5N4ZXVBEb6DdiIYul2xkUnYUtUVrejEETGKteeQR4w
        uUaw/uFmCeHTCE3ejJzy1y+/KNHLcSod
X-Google-Smtp-Source: APXvYqzpGDXOtRuYa0WgsWK7wz+wgL2YlTBvmIVTv2h8YGbeupjQc/AMbR9FD0fpw5V/MIPOI8j2lg0uDdbH
X-Received: by 2002:a63:1c13:: with SMTP id c19mr21194582pgc.450.1576532362335;
 Mon, 16 Dec 2019 13:39:22 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:39:01 -0800
In-Reply-To: <20191216213901.106941-1-bgardon@google.com>
Message-Id: <20191216213901.106941-9-bgardon@google.com>
Mime-Version: 1.0
References: <20191216213901.106941-1-bgardon@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 8/8] KVM: selftests: Move large memslots above KVM internal
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

