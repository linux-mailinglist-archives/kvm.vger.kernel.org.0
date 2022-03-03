Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B444CC53D
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbiCCSeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiCCSeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:34:17 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F6310819B
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:33:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u10-20020a63df0a000000b0037886b8707bso3145037pgg.23
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ByYgcJhQM+VKaA7st6465Fl4wdo//J4vr4WNBD1jK30=;
        b=fdKP3NJ08v2Hrg5I8d0nw4qVBIrkdQJXkIb7djGhcTa9Q9Tz2xy3JDpfMpiu73bhOO
         0OUQnFma3H+DCOuTUreU8ltZowSvetvt1homKnDhUFm6rlW5NunGpqIh38H01BhEQzXM
         YUz020Wu9WQV2hlY4ucUYdT0cTOAemzBHpppNodYbgswWjZskQ/k76JRCE/YSq1cPNCo
         c17+TDitioaBHY5NJcTntHHlR4ugtUfLAeMG0Dg3n/jCHCIay9B4EA/J4YC6nY4SVapp
         qn6Bh6UaIr6SpLERvUUu98gFWW2Dqtao+Iv+6kwojPH59vQAHpBP38nFyV5R4aH6y1th
         dJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ByYgcJhQM+VKaA7st6465Fl4wdo//J4vr4WNBD1jK30=;
        b=idAGcgHWmpk6ZVCmzU+yb6sU94B6haD/2orFSyJGxCAXjY3sdYgaCfrO/U0lcC32ET
         Cq9rFINgbNd/nfcb/l3bInxuT4epwd6njhkawRXGOFrmZ6b1zmgT4wSRaDMBZhOBb7Og
         D1Iq1aQJ1x8pfOvXMFvFtloYgyWBLDDF2biTIqU+WKK3fgSSXijDFjkbJwsuFuKVD5aJ
         dKW9/5cVlV7IwMEC4gh52sOnr3g0BsXghOjr/TMLXQEyShqMzR5ko98/pTYrWxuiL8Xa
         eWKZWXz2Tdmd41rN9avRKXE5zwBqHXYnJA9qEGQ5z5cpeOPo2tt4saQyCaS8iJEiLnRK
         jlrQ==
X-Gm-Message-State: AOAM533ox0IEnY9tA7FtCHYMFVugRsTOpUij+Ma1OSnUZ3SxWuDbgpem
        xSs0+d3SM1D4TTvot2JdFV520dtB+Lk36w==
X-Google-Smtp-Source: ABdhPJzFhpkmnxzuJYA5elwXYSs1CFC68fG9b4V9ixncgnkrONbkxLln2oKhEFJVmY87JwWbFhfthYAFvYWahQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1a8b:b0:4e1:e24b:88a8 with SMTP
 id e11-20020a056a001a8b00b004e1e24b88a8mr39212740pfv.80.1646332411135; Thu,
 03 Mar 2022 10:33:31 -0800 (PST)
Date:   Thu,  3 Mar 2022 18:33:26 +0000
Message-Id: <20220303183328.1499189-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH RESEND 0/2] KVM: Prevent module exit until all VMs are freed
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Resending with --cc-cover to fix CCs.]

This series fixes a long-standing theoretical bug where the KVM module
can be unloaded while there are still references to a struct kvm. This
can be reproduced with a simple patch [1] to run some delayed work 10
seconds after a VM file descriptor is released.

This bug was originally fixed by Ben Gardon <bgardon@google.com> in
Google's kernel due to a race with an internal kernel daemon.

KVM's async_pf code looks susceptible to this race since its inception,
but clearly no one has noticed. Upcoming changes to the TDP MMU will
move zapping to asynchronous workers which is much more likely to hit
this issue. Fix it now to close the gap in async_pf and prepare for the
TDP MMU zapping changes.

While here I noticed some further cleanups that could be done in the
async_pf code. It seems unnecessary for the async_pf code to grab a
reference via kvm_get_kvm() because there's code to synchronously drain
its queue of work in kvm_destroy_vm() -> ... ->
kvm_clear_async_pf_completion_queue() (at least on x86). This is
actually dead code because kvm_destroy_vm() will never be called while
there are references to kvm.users_count (which the async_pf callbacks
themselves hold). It seems we could either drop the reference grabbing
in async_pf.c or drop the call to kvm_clear_async_pf_completion_queue().

These patches apply on the latest kvm/queue commit b13a3befc815 ("KVM:
selftests: Add test to populate a VM with the max possible guest mem")
after reverting commit c9bdd0aa6800 ("KVM: allow struct kvm to outlive
the file descriptors").

Cc: kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM))
Cc: Marcelo Tosatti <mtosatti@redhat.com> (blamed_fixes:1/1=100%)
Cc: Gleb Natapov <gleb@redhat.com> (blamed_fixes:1/1=100%)
Cc: Rik van Riel <riel@redhat.com> (blamed_fixes:1/1=100%)
Cc: seanjc@google.com
Cc: bgardon@google.com

[1] To repro: Apply the following patch, run a KVM selftest, and then
unload the KVM module within 10 seconds of the selftest finishing. The
kernel will panic. With the fix applied, module unloading will fail
until the final struct kvm reference is put.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9536ffa0473b..db827cf6a7a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -771,6 +771,8 @@ struct kvm {
        struct notifier_block pm_notifier;
 #endif
        char stats_id[KVM_STATS_NAME_SIZE];
+
+       struct delayed_work run_after_vm_release_work;
 };

 #define kvm_err(fmt, ...) \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64eb99444688..35ae6d32dae5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1258,12 +1258,25 @@ void kvm_put_kvm_no_destroy(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);

+static void run_after_vm_release(struct work_struct *work)
+{
+       struct delayed_work *dwork = to_delayed_work(work);
+       struct kvm *kvm = container_of(dwork, struct kvm, run_after_vm_release_work);
+
+       pr_info("I'm still alive!\n");
+       kvm_put_kvm(kvm);
+}
+
 static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
        struct kvm *kvm = filp->private_data;

        kvm_irqfd_release(kvm);

+       kvm_get_kvm(kvm);
+       INIT_DELAYED_WORK(&kvm->run_after_vm_release_work, run_after_vm_release);
+       schedule_delayed_work(&kvm->run_after_vm_release_work, 10 * HZ);
+
        kvm_put_kvm(kvm);
        return 0;
 }


David Matlack (2):
  KVM: Prevent module exit until all VMs are freed
  Revert "KVM: set owner of cpu and vm file operations"

 virt/kvm/kvm_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


base-commit: b13a3befc815eae574d87e6249f973dfbb6ad6cd
prerequisite-patch-id: 38f66d60319bf0bc9bf49f91f0f9119e5441629b
prerequisite-patch-id: 51aa921d68ea649d436ea68e1b8f4aabc3805156
-- 
2.35.1.574.g5d30c73bfb-goog

