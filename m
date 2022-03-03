Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6404CC532
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiCCS1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbiCCS1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:27:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822BC1A41F4
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:26:55 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 203-20020a6217d4000000b004f66d3542a5so1785153pfx.11
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Xujim9Bw7o48AnpWvrwTaqWcK3vUJC8uiYu4QquOuRM=;
        b=pvgOxDV9suu13bQG/L1YOWNaqB054X9Ya+hnVPaew/wAeZwqsn7MrrYf/yxMh8iKO1
         6pE1kFS57aQtKAghl9U51iRytGBMniiX2lpPnJ+ElNq0c/24UD0AT0gbX45XsgtYfseG
         eVrOHlQ/vqMs1VaYB6mYO8+8x/S5IooThU3OXmxRoVNPHWeXvvJ2efaX9Crm9H0ZzpgZ
         GIIGNTTrN8WRSHxaiZytEiSIZCpv0ygp91nua2ezKxoeV1ifyQ0M4Gw8vg9rDMLVZKz5
         TimpUyKgOmcVKfX1V1SbVPWnFWqCVh4CDTUIJFjQc91nv7st1nER3X7VXSd3yHn/1Mi1
         0HTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Xujim9Bw7o48AnpWvrwTaqWcK3vUJC8uiYu4QquOuRM=;
        b=WKeoPtVBZQ1Gu4intTvhve6FJKdXSXIhhgyb/7t+UHP+2lIdKv+cfJgu+IO2gIWm6N
         U3CZS3EFIbHEG/vJ1TIfinq/COrLlKJYYQ64Rnk4/vyH0VdKp8qZXmPxyN+WsdYY3DJx
         F/RFDVLsFfpk4/ENqLOEgckyUyW1IB1FME57ogHq7zAfose6x9PcxpcEZ+HU0VYWzCdM
         Cbn1G2B1+N1mIHKy68nvdgl6aj0g1oDJO+J708kb20B0YQZmkSkCDmevqHlRY1yU8UgB
         mcCyDTKRRrUGKH4UdkUZzOIPKRC3PCxpbsxUf3T4uvxSPm3fDhLJ+GNft2SWj8mprUTw
         lv/Q==
X-Gm-Message-State: AOAM531MtZndUHnWzHCvRgI6z3ZFUK4xC9EnrOFQlEsp5G+pv5bAO3vU
        owkFkeZEFWAI2PmmQZPHGuc4h6fGHwp6EA==
X-Google-Smtp-Source: ABdhPJxCShFtdZIzOEndhZeDnYXV1fQ2uOXPl7fbJVQbzOXrKoOvAkyw8bnlzY8WXh+mXc3ycHtWsJnvQmIcfg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4f43:b0:1bc:7e5c:e024 with SMTP
 id pj3-20020a17090b4f4300b001bc7e5ce024mr59601pjb.0.1646332014776; Thu, 03
 Mar 2022 10:26:54 -0800 (PST)
Date:   Thu,  3 Mar 2022 18:26:50 +0000
Message-Id: <20220303182652.1496761-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 0/2] KVM: Prevent module exit until all VMs are freed
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

[1] To repro: Apply the following patch, run a KVM selftest, and then
unload the KVM module within 10 seconds of the selftest finishing. The
kernel will panic. With the fix applied, module unloading will fail
until the final struct kvm reference is put.

Cc: kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM))
Cc: Marcelo Tosatti <mtosatti@redhat.com> (blamed_fixes:1/1=100%)
Cc: Gleb Natapov <gleb@redhat.com> (blamed_fixes:1/1=100%)
Cc: Rik van Riel <riel@redhat.com> (blamed_fixes:1/1=100%)
Cc: seanjc@google.com
Cc: bgardon@google.com

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

