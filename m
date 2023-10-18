Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06A87CE951
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjJRUqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjJRUqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:46:39 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60290FE
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:37 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id 5614622812f47-3b2e2d3560bso2670043b6e.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697661996; x=1698266796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AxQtUaL497jm8Kvv+JzkijCCW6oqSLgiPCMTJq7eWjY=;
        b=qHUULQsSo3Ub018clPnEeoGy1KFO9nj/b12yYOWutZRQBYALkbLj/B2C+oF0XuLbcR
         NLeJjUPJAz0tFXBku3c22stWEspn5R2O4ncJx0EvYY7DolE9X5pB3I+LJWgZcuLKloqt
         PiT7noNmG96kEbTH0XsmnICSTFzgyoRdU1F3MhtJe4koukZUBoikGDcr1D+WJX1mmb2h
         73HmsFByuSSZnPR6AQQdzUeqpc7x54czTNbpa5Zk9BjWN8+l3z/jO9xXwPI60qqAp8OW
         +Yqed/Fmzo0XRFg1nG4AVH8v3UiV6MTSiMx+oZ36n8hhz7F7kVQ28Wwvk+5en1RPGiGn
         IkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697661996; x=1698266796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxQtUaL497jm8Kvv+JzkijCCW6oqSLgiPCMTJq7eWjY=;
        b=uFzkSdVSUNAhz4IHVUKHF1zASOdTZD8NbPEd9X5qA3c+NBapcu5TdRMGHb2ieRDwkV
         lOo7/f+uqWTpDxHyvLJZH9SfKvQzAtvpIMa+E5hwSWRC+D4l7Z8aKp109A1dHovjRwe/
         /xJOAQ+d64tL+HlxJp5PMQSPh3mRevvQU8qxMquurGCOjAVDk+y1qD+LW+BxYtiRIK2C
         bg6sq0EuLyeKfBlSSxBV/9oFEJQiD+ztY7RAEZHAyN709z2XC1ePeblaroxeLn0eXdmD
         dX35rihQoYavuji2zyOdpeG7mpHfxJDfkKENUy2WIktb9bx6kJpBIg5AwXIkB+s4Fpwg
         Jl3g==
X-Gm-Message-State: AOJu0YzdXct0Fn3HP/5ePFqQJEAAcS5VPKPrQ7HvFMb6btfc6Ax5HDwJ
        Mz4fctMU2fTvUYJ26qxr/LPFTapS+UY=
X-Google-Smtp-Source: AGHT+IE+HSvc8NfeaZoWmMmsZSX78eAKPODu7osocTukqqL8LuYcEH25gkg/9rvnxgtnl9ETHnlyRSBM6Fo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6808:1884:b0:3a9:d030:5023 with SMTP id
 bi4-20020a056808188400b003a9d0305023mr94020oib.3.1697661996735; Wed, 18 Oct
 2023 13:46:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 13:46:24 -0700
In-Reply-To: <20231018204624.1905300-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231018204624.1905300-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018204624.1905300-4-seanjc@google.com>
Subject: [PATCH 3/3] Revert "KVM: Prevent module exit until all VMs are freed"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert KVM's misguided attempt to "fix" a use-after-module-unload bug that
was actually due to failure to flush a workqueue, not a lack of module
refcounting.  Pinning the KVM module until kvm_vm_destroy() doesn't
prevent use-after-free due to the module being unloaded, as userspace can
invoke delete_module() the instant the last reference to KVM is put, i.e.
can cause all KVM code to be unmapped while KVM is actively executing said
code.

Generally speaking, the many instances of module_put(THIS_MODULE)
notwithstanding, outside of a few special paths, a module can never safely
put the last reference to itself without creating deadlock, i.e. something
external to the module *must* put the last reference.  In other words,
having VMs grab a reference to the KVM module is futile, pointless, and as
evidenced by the now-reverted commit 70375c2d8fa3 ("Revert "KVM: set owner
of cpu and vm file operations""), actively dangerous.

This reverts commit 405294f29faee5de8c10cb9d4a90e229c2835279 and commit
5f6de5cbebee925a612856fce6f9182bb3eee0db.

Fixes: 405294f29fae ("KVM: Unconditionally get a ref to /dev/kvm module when creating a VM")
Fixes: 5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1e65a506985f..3b1b9e8dd70c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -115,8 +115,6 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static const struct file_operations stat_fops_per_vm;
 
-static struct file_operations kvm_chardev_ops;
-
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -1157,9 +1155,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
-	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
-	__module_get(kvm_chardev_ops.owner);
-
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
@@ -1279,7 +1274,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
-	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
 
@@ -1348,7 +1342,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
-	module_put(kvm_chardev_ops.owner);
 }
 
 void kvm_get_kvm(struct kvm *kvm)
-- 
2.42.0.655.g421f12c284-goog

