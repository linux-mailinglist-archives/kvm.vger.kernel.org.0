Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25659553E
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiHPI3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 04:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiHPI22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 04:28:28 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4115A262D
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h7-20020a636c07000000b0042971e3dc0cso1591824pgc.0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=skGptlYSAIkNioboOWdTtVjKMphwIbs6TtQs5aeYl+s=;
        b=pwDyzALfifJ8QU9VWJqYVhqejiqFqRO/pH2ZsDVM0/CkmGlIe/N96B8xAufRL3xN2Q
         eLJdjHM89WUPzLZq+EC+iDGoXzTy5k86cFQ6hU5Kxi3TS6SLMkInHj70W/G1yDZTl4f9
         wFTyffSAdEYI83JujVIIlKRblYBnMbO1C0qWQEltC0vHsQrRHZICN6gc+uXZSUK6Lrts
         ucs+qy1P8iwfTYnFRGCL0kwxI9PSpsm2zKRAtXOIHnWo1DLXtqIvR6Bv6AxA9gF2S6gu
         Bif5++IorVmC1Ix+isaNgz8TBtqYIHu0WCauI1yT7ONALrnKXlYScXR3yIRYAuuKTjUK
         UW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=skGptlYSAIkNioboOWdTtVjKMphwIbs6TtQs5aeYl+s=;
        b=o3MsBOnF3DQsZThYoHctki7JBkAMP91JPsh4QXnLpBnNmRlIWDKda9OfQCjQIL09G8
         71lDQpQJoyB98GbqBtppstLwjCTaLvCg0loZpdNg/RgvW+CxL6x3CnMKQZgmFmyZTF/c
         InKo/VFpnWSRpib1Vmj8I0qjG9KEmbAZG/1ArkFMr2Gxlrvr+Ncm7YMHUHz/60u7h53j
         ou0IGlC87uwVbClfF3OumEpZhVV6/y7sB+C3537wAr1NXrBSRRAfRmUrb4hCWD4C8LYd
         5dAypCBnhLPl4Iu+8pc66Y5BLIbnyrYNpFW7iyr9WurreoqBFOfmWSszYX80+ZHelxpF
         h/dQ==
X-Gm-Message-State: ACgBeo0hzyiu4UnMLi++Fnvgg6yf1zSWokzTAxMfgBQX6y2aSHgI5WM2
        EFU7IsuHhxV7MsZj6mR4TmE4lE/kS7o=
X-Google-Smtp-Source: AA6agR5Rpgp8wfskZI0juUnm1LesEj7cjcUSq/OZRJIUcd4NimonmLJczgvBixLWjZ2nChW8uv4Yot2OcVg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr138439pje.0.1660628386353; Mon, 15 Aug
 2022 22:39:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Aug 2022 05:39:37 +0000
In-Reply-To: <20220816053937.2477106-1-seanjc@google.com>
Message-Id: <20220816053937.2477106-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220816053937.2477106-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 3/3] KVM: Move coalesced MMIO initialization (back) into kvm_create_vm()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
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

Invoke kvm_coalesced_mmio_init() from kvm_create_vm() now that allocating
and initializing coalesced MMIO objects is separate from registering any
associated devices.  Moving coalesced MMIO cleans up the last oddity
where KVM does VM creation/initialization after kvm_create_vm(), and more
importantly after kvm_arch_post_init_vm() is called and the VM is added
to the global vm_list, i.e. after the VM is fully created as far as KVM
is concerned.

Originally, kvm_coalesced_mmio_init() was called by kvm_create_vm(), but
the original implementation was completely devoid of error handling.
Commit 6ce5a090a9a0 ("KVM: coalesced_mmio: fix kvm_coalesced_mmio_init()'s
error handling" fixed the various bugs, and in doing so rightly moved the
call to after kvm_create_vm() because kvm_coalesced_mmio_init() also
registered the coalesced MMIO device.  Commit 2b3c246a682c ("KVM: Make
coalesced mmio use a device per zone") cleaned up that mess by having
each zone register a separate device, i.e. moved device registration to
its logical home in kvm_vm_ioctl_register_coalesced_mmio().  As a result,
kvm_coalesced_mmio_init() is now a "pure" initialization helper and can
be safely called from kvm_create_vm().

Opportunstically drop the #ifdef, KVM provides stubs for
kvm_coalesced_mmio_{init,free}() when CONFIG_KVM_MMIO=n (arm).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 15e304e059d4..44b92d773156 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1214,6 +1214,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_mmu_notifier;
 
+	r = kvm_coalesced_mmio_init(kvm);
+	if (r < 0)
+		goto out_no_coalesced_mmio;
+
 	r = kvm_create_vm_debugfs(kvm, fdname);
 	if (r)
 		goto out_err_no_debugfs;
@@ -1234,6 +1238,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err:
 	kvm_destroy_vm_debugfs(kvm);
 out_err_no_debugfs:
+	kvm_coalesced_mmio_free(kvm);
+out_no_coalesced_mmio:
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	if (kvm->mmu_notifier.ops)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
@@ -4907,11 +4913,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 		goto put_fd;
 	}
 
-#ifdef CONFIG_KVM_MMIO
-	r = kvm_coalesced_mmio_init(kvm);
-	if (r < 0)
-		goto put_kvm;
-#endif
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
 		r = PTR_ERR(file);
-- 
2.37.1.595.g718a3a8f04-goog

