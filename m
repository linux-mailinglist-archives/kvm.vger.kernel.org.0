Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AFB595541
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 10:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiHPI3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 04:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiHPI21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 04:28:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E9B6BD70
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q11-20020a170902dacb00b0016efd6984c3so6122919plx.17
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 22:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=/mb/4kA68DuEk+etiSxItbDhS1o312Y9/FSzPon3SwU=;
        b=E/qmMTDg2mnLIRqmZ/h0BV2xJPkV0YxMHFVoLTvK/m0l5eKcjvYe7Zs4cjq3foQ8DG
         XcXMqto2Rrn733cK+JUdoPaHanFJx4f8VMzwOJpE/N9fgyhTZK+y5sIbR6ieG9QOOL37
         RW6GJwft95tp/9Bs9OQrOQ0z95G6TVpIyueG0TfruZQabzNGWUa6bqAEET4qItWN3XsO
         ingzWu6BKh2Ndo7UBJshY/BIRkdfcw0/C0mLSdqDlYhbJZX+VGJIkxs245ImtKPCkNHs
         kIddymjEooD8ywYCmBhhdT/cwcNipE9ZDjxD1O+xSnKLKwBMf2HEUfiaPgsyRkoOXDnP
         E6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=/mb/4kA68DuEk+etiSxItbDhS1o312Y9/FSzPon3SwU=;
        b=srPxnYhYBJxGL9W3+2fjW845NSzaXU6v4THm9UPhfiol0dSrG7c57+BXD+9zTZRk+4
         FZScgF6QZsdh0R6J+BhPoBuzIJ25RDC5p30Y887mHjiwdELMJbRxB21bp205tyyIyPcM
         OAgCRkQhXMx6KftNoaSpo14Nogpxt+UaPQdh0MMb55aMWD88sFBxgHpjXsGz4FyBrSxC
         c1C3eLVfbdaW2hLF5L8qcFZXMv/Jd+1G3xTiUCL7hJWgGyQOlnKYuXNlf1n0RfzuUhkm
         +6imEoRs7y92nIjAq+C5JSYmbNTcgGBKRhDoFykNgD/P81kbNhJwfa1u76qQv6fztnNR
         d3tA==
X-Gm-Message-State: ACgBeo2fyhaaGYVJsZ1rU73yUyDFi9j11JxTU7QNOVOzbVVimgP3xAvO
        1qx1lIVqsiha6Trv76X2fB9+tQ2EdtQ=
X-Google-Smtp-Source: AA6agR70sGsTjN7dC8+jZ09qVGsPAvplulRvw7CVOG4hsyKlS270660wcNWG8ynhv46MwbzLr4dE907QsxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4147:b0:52e:2d56:17c8 with SMTP id
 bv7-20020a056a00414700b0052e2d5617c8mr19678854pfb.51.1660628384621; Mon, 15
 Aug 2022 22:39:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 16 Aug 2022 05:39:36 +0000
In-Reply-To: <20220816053937.2477106-1-seanjc@google.com>
Message-Id: <20220816053937.2477106-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220816053937.2477106-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 2/3] KVM: Unconditionally get a ref to /dev/kvm module when
 creating a VM
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally get a reference to the /dev/kvm module when creating a VM
instead of using try_get_module(), which will fail if the module is in
the process of being forcefully unloaded.  The error handling when
try_get_module() fails doesn't properly unwind all that has been done,
e.g. doesn't call kvm_arch_pre_destroy_vm() and doesn't remove the VM
from the global list.  Not removing VMs from the global list tends to be
fatal, e.g. leads to use-after-free explosions.

The obvious alternative would be to add proper unwinding, but the
justification for using try_get_module(), "rmmod --wait", is completely
bogus as support for "rmmod --wait", i.e. delete_module() without
O_NONBLOCK, was removed by commit 3f2b9c9cdf38 ("module: remove rmmod
--wait option.") nearly a decade ago.

It's still possible for try_get_module() to fail due to the module dying
(more like being killed), as the module will be tagged MODULE_STATE_GOING
by "rmmod --force", i.e. delete_module(..., O_TRUNC), but playing nice
with forced unloading is an exercise in futility and gives a falsea sense
of security.  Using try_get_module() only prevents acquiring _new_
references, it doesn't magically put the references held by other VMs,
and forced unloading doesn't wait, i.e. "rmmod --force" on KVM is all but
guaranteed to cause spectacular fireworks; the window where KVM will fail
try_get_module() is tiny compared to the window where KVM is building and
running the VM with an elevated module refcount.

Addressing KVM's inability to play nice with "rmmod --force" is firmly
out-of-scope.  Forcefully unloading any module taints kernel (for obvious
reasons)  _and_ requires the kernel to be built with
CONFIG_MODULE_FORCE_UNLOAD=y, which is off by default and comes with the
amusing disclaimer that it's "mainly for kernel developers and desperate
users".  In other words, KVM is free to scoff at bug reports due to using
"rmmod --force" while VMs may be running.

Fixes: 5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee5f48cc100b..15e304e059d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1134,6 +1134,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
+	__module_get(kvm_chardev_ops.owner);
+
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
@@ -1226,16 +1229,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
-	/*
-	 * When the fd passed to this ioctl() is opened it pins the module,
-	 * but try_module_get() also prevents getting a reference if the module
-	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
-	 */
-	if (!try_module_get(kvm_chardev_ops.owner)) {
-		r = -ENODEV;
-		goto out_err;
-	}
-
 	return kvm;
 
 out_err:
@@ -1259,6 +1252,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
+	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

