Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36FB4D3C19
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 22:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiCIVdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 16:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiCIVdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 16:33:15 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277B011D79A
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 13:32:16 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 196-20020a6307cd000000b0038027886594so1841956pgh.4
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 13:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DltPH0st+zcTt7ExaGUOnDWmqYAMuLJGnVYZchyVijI=;
        b=TlJAPWd3FIqAPldxeFcHS5vNQk546W45NQ0zFTpfbsBvVJw7yq48JmH0tZV5p7TG16
         Twn5DzqDVjAhfV9hhqDYCR7NP+gqOx1E+c8kPG82pYwAw9NIe+nCx20aXlKfjUlVPwHv
         /SaLs7EyDywSOK7xF8MzAC7zhVcguYQxA3RexiIMe2qgWvCc2fIdQzUoLBglP0nc7IQW
         1vI/vBuCwrJICZ7oMy8j3UG6W97YzjnW1t4mSmIMm7crbLdQhD6zxfT2pnvV6Uk+z1aH
         LKJVpuHZSxhv0zQ40i/gcmuJXb19jmcYc9/NXQHGPVD2mqKzPngqAJRrjpW/ryRER3+L
         MxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DltPH0st+zcTt7ExaGUOnDWmqYAMuLJGnVYZchyVijI=;
        b=Cxn4e/+ubEJ1sf8h+dDoKO8t8FLIy8w1MiKOSNjnLfBX0CaCtpMOVGRVECRpuuNzGj
         a+5qtdN22aDF5tVsjTRJpin6zKNKmisN1upu+cUC6yZajantk3QN2RH3aYEMkFVsfUuE
         AcfNe3XSybifzAWe0IxUUP/dXErBbS1UhlYw4R4iisfuahK+TPm8yIZly0qA7JHcKomI
         oI0zYDyg0Q4RLBvSV1fEjtLOvZS1zK7jSyBO8pm469wflsp1kH9nNCUqx8gbIHMZ40db
         Jyqzgv9UHQobhlu1X8lrGrkFEMlaXjUKsJqWurza8NiGoT4QU3i6o2s3G+6DUIFHEOEl
         k4Lw==
X-Gm-Message-State: AOAM533gDu1BmOYdO/YlsYoOrtOwWsyQOCkPUNm+jyzH/gH6hiJULOfb
        SsQPJtPkkkr8dcxLZ7l6YgEnU5BRgJpCeA==
X-Google-Smtp-Source: ABdhPJzViIpraLXz5IlOTLmdAPsujWcON7wDQ762/bdowz6gfthnBvqnTeK4L5vdhnv/1cVcyKbM13N+5gtmVA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:d4c6:b0:151:d21c:7eb7 with SMTP
 id o6-20020a170902d4c600b00151d21c7eb7mr1765717plg.148.1646861534400; Wed, 09
 Mar 2022 13:32:14 -0800 (PST)
Date:   Wed,  9 Mar 2022 21:32:06 +0000
Message-Id: <20220309213208.872644-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v2 0/2] KVM: Prevent module exit until all VMs are freed
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, seanjc@google.com,
        bgardon@google.com
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

v2:
 - Add comment explaining try variant [Sean]
 - Additional fixes commit to clarify bug not limited to async_pf [Sean]
 - Collect R-b tags.

v1: https://lore.kernel.org/kvm/20220303183328.1499189-1-dmatlack@google.com/

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

 virt/kvm/kvm_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)


base-commit: ce41d078aaa9cf15cbbb4a42878cc6160d76525e
-- 
2.35.1.616.g0bdcbb4464-goog

