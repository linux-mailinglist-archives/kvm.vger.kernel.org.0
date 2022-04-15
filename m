Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F97501FC4
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 02:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348158AbiDOAsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 20:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343765AbiDOAsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 20:48:51 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47688B8217
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:46:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a16-20020a62d410000000b00505734b752aso3856894pfh.4
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=71BQZu/sNQ1rStCLl5rLaYGw9VdEBlajvzPCVRYsEdY=;
        b=YqR97q+gjjpXN+NvVA9gwzmrBsczjhgwfMXlEEQ/T8uMYwN4ozqb1OIa1YSM6TrEE7
         9a4GOudHI50AJnDFyOtmtC5VIfoFzhc7z5oZST7LIBnUE616sn7IBW7yVlEUIh4BPNTq
         Ph7v22KbOlFppsp3XYpnmrfi0c6ZI1a5wdqYcYkP1lrNiEU4Z6b7IYWRKdxfzkr/pbqP
         1frRpwFM/kNTRpaE2XDHECaR82Nt+ICopiRU4uOv/ZTsExNLXc2noGsmcowgdH1YgHUA
         Jluf+X2mKjAiu+NEEepp86jRxqKFnsO2uOHW5PN8L041iYMe05R7iK6RR7Sdc5FnNSEd
         x80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=71BQZu/sNQ1rStCLl5rLaYGw9VdEBlajvzPCVRYsEdY=;
        b=TFm/vnhLdiTH5d510+6y0GT5pTlxwoPU3XbOEC5oCOtjLv7c435jbnYUcIPK3V6eoC
         +lrBUdNibtmAl//djaK4dGfP3DUAV+H8T7s9Y5Qv4D6BLjphmAWkrp20JOKwyRc2Z5Om
         EJ6sRk9AckqxGJk49RhxQJfwrnjc463PZ2d5ar7T4gq5ds8g1VvspcQGQ6kTr8JboqUm
         lumjjjQoRVjo8EzkaFgqyaew26dX0wVDa5bw5X1NBwCiDkUXLEhkpKJmGtuDZnmLOoyQ
         KfqIi7CZQLLXOSnYFxUjt3rGna3G+dgFauWtWT4ZfR/k+YneKh4qdb6DTVhNUp3Tzk4G
         ArEw==
X-Gm-Message-State: AOAM532IIQkZCAFZrueYa3yyY9bWwhdQ8YgogtoQzYtz4/l88Wkx0OD0
        iBP0flBWMVppOl3aw87VIs/8xzfGJVw=
X-Google-Smtp-Source: ABdhPJwtbePT6BMnjqeS2btxHX/za7QwUYBdgnhFqLOZDf2IDB/ZiBuLFk6ZR9svaix7w0p5xtKLq4iDN7M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:711:b0:4fa:daf1:94c1 with SMTP id
 17-20020a056a00071100b004fadaf194c1mr6386178pfl.52.1649983584803; Thu, 14 Apr
 2022 17:46:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Apr 2022 00:46:22 +0000
Message-Id: <20220415004622.2207751-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] KVM: Initialize debugfs_dentry when a VM is created to avoid
 NULL deref
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com,
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

Initialize debugfs_entry to its semi-magical -ENOENT value when the VM
is created.  KVM's teardown when VM creation fails is kludgy and calls
kvm_uevent_notify_change() and kvm_destroy_vm_debugfs() even if KVM never
attempted kvm_create_vm_debugfs().  Because debugfs_entry is zero
initialized, the IS_ERR() checks pass and KVM derefs a NULL pointer.

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 1068b1067 P4D 1068b1067 PUD 1068b0067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 871 Comm: repro Not tainted 5.18.0-rc1+ #825
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__dentry_path+0x7b/0x130
  Call Trace:
   <TASK>
   dentry_path_raw+0x42/0x70
   kvm_uevent_notify_change.part.0+0x10c/0x200 [kvm]
   kvm_put_kvm+0x63/0x2b0 [kvm]
   kvm_dev_ioctl+0x43a/0x920 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x31/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  Modules linked in: kvm_intel kvm irqbypass

Fixes: a44a4cc1c969 ("KVM: Don't create VM debugfs files outside of the VM directory")
Cc: stable@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@google.com>
Reported-by: syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfb7dabdbc63..d292c4397579 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -955,12 +955,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created.
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	if (!debugfs_initialized())
 		return 0;
 
@@ -1081,6 +1075,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created (by kvm_create_vm_debugfs()).
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog

