Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2580152AF3C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 02:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiERAis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiERAiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 20:38:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B536E0C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 17:38:45 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g63-20020a636b42000000b003db2a3daf30so348833pgc.22
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 17:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LGbbxigQqvj2d1gNOUXULeQzWXDgRFfQt5JUWxbBJtI=;
        b=OLr0GTsKpYz7DOVNUyHdtfSO9gvBn+Z3wfyVlTwgKqGeATz80J9Z0nXGu3jtfbXU4C
         E2E7qEXlOCws6x0G0V268v0nYIKI0LjAzdl2Jbqptqlgn17OoTsCIaFE72Fw6oMkfHwe
         UuGe6UaDcCow9I1rrSFDOv+9cE7Da9pH3Oh8YY/kM13dq8HGNAA0xz2Ii90qYCNW1GzI
         eEu8GSOC0xV8TuFqom/F2BqL2Ut7VEOoeD9V943bj6s78JP8i9zkO0YPsxyrCSWxodHK
         jJNkJcsJnha6p2XIa/vsa6E1b+XcSOh6S4O56hJmVL6AkjrKR67DWN9ZGWac+7OIoV4t
         SHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LGbbxigQqvj2d1gNOUXULeQzWXDgRFfQt5JUWxbBJtI=;
        b=TQ6xs4CbPj2eSLgKVvTgkUMNHkl9LlWFSQIOERH529Li6fpYuvliAFE1aebeVgPR9B
         v4N1GH7KTYCJjviJzGGvzR8uV5x8yGbmA4tmUJNq3LRaCc95xBPcLz6E0zBdKzG2+mTs
         U/fKi+9DIZ112bvuJNjIkNNbz/Rzk3gJLIYJOxfTxoXhJ4tLM669pfVILeq2MubSwZ9J
         BlULOLluRmisMnwogueDFrhUMqff/23CNx45kVOCpTIcWyaa1FM5Yi8zxJcB1pPhQ+1h
         l23mp+O8oiMSE/QPVnCbtMZ9b86AeHBz/e+Mj5lKwQU4Ztmxl5O35r1oA5zAJlFK81m7
         ok4w==
X-Gm-Message-State: AOAM531DsdCHsCkIEGewcQ7DOnYkIG2XokchfA80vkUht39b0d5pys87
        er8pyNeGkJWoQVLU7yMHZ2vuky+jdEs=
X-Google-Smtp-Source: ABdhPJz5lZewEaYbNOGPXWgqz8o5dYa+s4DyyMYyBpvVTxq2pp+sRl4AS0w8RYm8QAU8eRP8KAMrrEKlqlM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP id
 d3-20020a17090a8d8300b001dd258c7c55mr63468pjo.1.1652834324479; Tue, 17 May
 2022 17:38:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 May 2022 00:38:42 +0000
Message-Id: <20220518003842.1341782-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH] KVM: Free new dirty bitmap if creating a new memslot fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8606b8a9cc97a63f1c87@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a goof in kvm_prepare_memory_region() where KVM fails to free the
new memslot's dirty bitmap during a CREATE action if
kvm_arch_prepare_memory_region() fails.  The logic is supposed to detect
if the bitmap was allocated and thus needs to be freed, versus if the
bitmap was inherited from the old memslot and thus needs to be kept.  If
there is no old memslot, then obviously the bitmap can't have been
inherited

The bug was exposed by commit 86931ff7207b ("KVM: x86/mmu: Do not create
SPTEs for GFNs that exceed host.MAXPHYADDR"), which made it trivally easy
for syzkaller to trigger failure during kvm_arch_prepare_memory_region(),
but the bug can be hit other ways too, e.g. due to -ENOMEM when
allocating x86's memslot metadata.

The backtrace from kmemleak:

  __vmalloc_node_range+0xb40/0xbd0 mm/vmalloc.c:3195
  __vmalloc_node mm/vmalloc.c:3232 [inline]
  __vmalloc+0x49/0x50 mm/vmalloc.c:3246
  __vmalloc_array mm/util.c:671 [inline]
  __vcalloc+0x49/0x70 mm/util.c:694
  kvm_alloc_dirty_bitmap virt/kvm/kvm_main.c:1319
  kvm_prepare_memory_region virt/kvm/kvm_main.c:1551
  kvm_set_memslot+0x1bd/0x690 virt/kvm/kvm_main.c:1782
  __kvm_set_memory_region+0x689/0x750 virt/kvm/kvm_main.c:1949
  kvm_set_memory_region virt/kvm/kvm_main.c:1962
  kvm_vm_ioctl_set_memory_region virt/kvm/kvm_main.c:1974
  kvm_vm_ioctl+0x377/0x13a0 virt/kvm/kvm_main.c:4528
  vfs_ioctl fs/ioctl.c:51
  __do_sys_ioctl fs/ioctl.c:870
  __se_sys_ioctl fs/ioctl.c:856
  __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:856
  do_syscall_x64 arch/x86/entry/common.c:50
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

And the relevant sequence of KVM events:

  ioctl(3, KVM_CREATE_VM, 0)              = 4
  ioctl(4, KVM_SET_USER_MEMORY_REGION, {slot=0,
                                        flags=KVM_MEM_LOG_DIRTY_PAGES,
                                        guest_phys_addr=0x10000000000000,
                                        memory_size=4096,
                                        userspace_addr=0x20fe8000}
       ) = -1 EINVAL (Invalid argument)

Fixes: 244893fa2859 ("KVM: Dynamically allocate "new" memslots from the get-go")
Cc: stable@vger.kernel.org
Reported-by: syzbot+8606b8a9cc97a63f1c87@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6d971fb1b08d..5ab12214e18d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1560,7 +1560,7 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
 	/* Free the bitmap on failure if it was allocated above. */
-	if (r && new && new->dirty_bitmap && old && !old->dirty_bitmap)
+	if (r && new && new->dirty_bitmap && (!old || !old->dirty_bitmap))
 		kvm_destroy_dirty_bitmap(new);
 
 	return r;

base-commit: b28cb0cd2c5e80a8c0feb408a0e4b0dbb6d132c5
-- 
2.36.0.550.gb090851708-goog

