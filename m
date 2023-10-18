Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5507CE954
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjJRUqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjJRUqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:46:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB17A4
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9cafa90160so102944276.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697661993; x=1698266793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0NC3yqMcGjhIZrhf7725DJ1Gf8NkzsIha09da8LPGz0=;
        b=SmAaQ7putaQ3J9cjAp0JVUn0Kcd12FMuMq4Sl67CevF4CgsKROoWDvmmhp3kRKmGLQ
         3QMt7nCvyNMn7/TFbNaLtmuM7W+jWyrJx6vhg9hOs//AB0sYdKhmYfjuvEDYhfHy+/ju
         hqMbQ99fiBxOGENlnGXhYSN1A2GlE19mlS2vnmOs0GdbeNYKPaYrs/2LZWJ/ohWYLZ6R
         RGqPv03UwwsBO6mI5aqAQQYJa8ot68Pq5M12HKzDhajzxXBa2DsN/Bxc0gXxGr7gxWgn
         eR6jmqBHFekWlaHqzNduMj7a5id4JgQewCu1IAA474hxqINCASw/k/HGprLiHz7ytne+
         Rtsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697661993; x=1698266793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NC3yqMcGjhIZrhf7725DJ1Gf8NkzsIha09da8LPGz0=;
        b=dcOKgJxzmQ9jBS7F6yMX89RwtJXtDiNqPCqiLern9wOZ1AND6UPKGVk990/jNT7Uv1
         q5USJjnomRhMmRLSsJPONNH8CxiI7bvMc62lVc3ERH3qnzQbu49ml9OJE/825L/zHTpD
         GFzFk7zDN0MtRGFV37TmSKaxoW8W7asi3f2MP5xmJH1dnnirx/ypQf+fGERFv0Jhlihb
         bY941DJmKuS0k8yp9EGjfXbSSUiYTLos6rMHy4NrVnxzIsIZG2EvXXaaoW79wQKJNuqL
         4u1IO5VLT5O7rEO5tgyAR0lPjs6/WupLIoV4fHu0Nf9nykjEUCpvsijpQh6ozfIygdic
         KaAA==
X-Gm-Message-State: AOJu0Yz2OukAUaR3aND1jCQL0dZzSqSYl88cv6CDipdu7hfIfSZwiGXJ
        ML1/y8kwXuYRw6YMb+jZNr6A16H+l0w=
X-Google-Smtp-Source: AGHT+IG+aew8QqUeKJhMjafkL3+AfUCVwG2CQNeHZsBiKSQcnY9Z1RYn+qlTT/sPLTnhnGPz3wPUHZUiY+E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:134a:b0:d9a:58e0:c7c7 with SMTP id
 g10-20020a056902134a00b00d9a58e0c7c7mr11788ybu.1.1697661993300; Wed, 18 Oct
 2023 13:46:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 13:46:22 -0700
In-Reply-To: <20231018204624.1905300-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231018204624.1905300-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018204624.1905300-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: Set file_operations.owner appropriately for all such structures
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set .owner for all KVM-owned filed types so that the KVM module is pinned
until any files with callbacks back into KVM are completely freed.  Using
"struct kvm" as a proxy for the module, i.e. keeping KVM-the-module alive
while there are active VMs, doesn't provide full protection.

Userspace can invoke delete_module() the instant the last reference to KVM
is put.  If KVM itself puts the last reference, e.g. via kvm_destroy_vm(),
then it's possible for KVM to be preempted and deleted/unloaded before KVM
fully exits, e.g. when the task running kvm_destroy_vm() is scheduled back
in, it will jump to a code page that is no longer mapped.

Note, file types that can call into sub-module code, e.g. kvm-intel.ko or
kvm-amd.ko on x86, must use the module pointer passed to kvm_init(), not
THIS_MODULE (which points at kvm.ko).  KVM assumes that if /dev/kvm is
reachable, e.g. VMs are active, then the vendor module is loaded.

To reduce the probability of forgetting to set .owner entirely, use
THIS_MODULE for stats files where KVM does not call back into vendor code.

This reverts commit 70375c2d8fa3fb9b0b59207a9c5df1e2e1205c10, and fixes
several other file types that have been buggy since their introduction.

Fixes: 70375c2d8fa3 ("Revert "KVM: set owner of cpu and vm file operations"")
Fixes: 3bcd0662d66f ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/all/20231010003746.GN800259@ZenIV
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/debugfs.c |  1 +
 virt/kvm/kvm_main.c    | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index ee8c4c3496ed..eea6ea7f14af 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -182,6 +182,7 @@ static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations mmu_rmaps_stat_fops = {
+	.owner		= THIS_MODULE,
 	.open		= kvm_mmu_rmaps_stat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..1e65a506985f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3887,7 +3887,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static const struct file_operations kvm_vcpu_fops = {
+static struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
@@ -4081,6 +4081,7 @@ static int kvm_vcpu_stats_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations kvm_vcpu_stats_fops = {
+	.owner = THIS_MODULE,
 	.read = kvm_vcpu_stats_read,
 	.release = kvm_vcpu_stats_release,
 	.llseek = noop_llseek,
@@ -4431,7 +4432,7 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static const struct file_operations kvm_device_fops = {
+static struct file_operations kvm_device_fops = {
 	.unlocked_ioctl = kvm_device_ioctl,
 	.release = kvm_device_release,
 	KVM_COMPAT(kvm_device_ioctl),
@@ -4759,6 +4760,7 @@ static int kvm_vm_stats_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations kvm_vm_stats_fops = {
+	.owner = THIS_MODULE,
 	.read = kvm_vm_stats_read,
 	.release = kvm_vm_stats_release,
 	.llseek = noop_llseek,
@@ -5060,7 +5062,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
 
-static const struct file_operations kvm_vm_fops = {
+static struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.llseek		= noop_llseek,
@@ -6095,6 +6097,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		goto err_async_pf;
 
 	kvm_chardev_ops.owner = module;
+	kvm_vm_fops.owner = module;
+	kvm_vcpu_fops.owner = module;
+	kvm_device_fops.owner = module;
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
-- 
2.42.0.655.g421f12c284-goog

