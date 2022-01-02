Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8290C482A98
	for <lists+kvm@lfdr.de>; Sun,  2 Jan 2022 09:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiABIWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jan 2022 03:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiABIWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jan 2022 03:22:14 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8F8C061574;
        Sun,  2 Jan 2022 00:22:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 7so15107891pgn.0;
        Sun, 02 Jan 2022 00:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFB6LeqgULhilOO4+NT/Y/zSijzYFfbA0zvCt4dGG50=;
        b=G6H9Y+13OeUv6MdrtZRXr/B4eUmK4nDrY14bxz6brch8JxABFOyGymCkwgKIXcDfjx
         5rarPL+ttKyyTeRtiM1vnhb3dhiSWGwtEEP+WegOF6F/nTKoOsqPUkgBCOnBaju6j7ZQ
         9MPiqc3LgQPhFBysiqy7k4czW3NBZHcJtdQZxdjBVyZhmZ+E9ObYUPrrBqub5SO8R28r
         f7xnK0kJ+kCr7CMv3GboSQyWwwjQcSzY9CTJjt+heV8pPqfqxL9rbzx61tWoAvPjaID9
         91doRGhPAo16scin3bcle0myXVsy0JkprT9DZN1XcgLiM9cCkBBm27Q1UL0sTGXFg0E5
         JZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFB6LeqgULhilOO4+NT/Y/zSijzYFfbA0zvCt4dGG50=;
        b=wW6qIZ38a7fyuMVvzODWQVTj6Jztw7J38ypo5lIeKyKTsDHThtN54s1rxaRYu8ImV+
         gnAiicr4D5gttBEm0bDL9abMcfGvTZ1M2Rnz8fp+9WlQLlaNlUfuyl0hqmmUWhQrmtun
         lSDUC2lgiYa1yc26O5qaL1V7zGE+XeYlhtvSeeMS8kXXfZTPuEX+QpmbyJpVtrKagGQo
         NluMfW46W8/t0q3t9Rc9IZa/UundhXUhVQDNvFM/oaPe+g5eEbMi/E/EFpt7Qb94dQeX
         qGC96HoOkDmlse0emHEURLFvscHjVLJNZWA0hkOoX5Twn38fOEM+fJuTGikP/n8MI/k8
         4how==
X-Gm-Message-State: AOAM530XKOvn/+6x3u7gjrY1PcKp/AtEtqdMWPNFIeJoSW6gHR2ndjAB
        ruEWlo8KBvAJsya1jjs/neRQ322iug==
X-Google-Smtp-Source: ABdhPJxQdOcZ2+fWvyG0pjWD8/qzpgUfPhnlP3Zj8lGFwaYNHBBglFPqzFKE211KBNgHf5OGHxVtaw==
X-Received: by 2002:aa7:8d99:0:b0:4bb:8e5e:9ae4 with SMTP id i25-20020aa78d99000000b004bb8e5e9ae4mr39742848pfr.68.1641111733767;
        Sun, 02 Jan 2022 00:22:13 -0800 (PST)
Received: from localhost.localdomain ([66.90.115.98])
        by smtp.gmail.com with ESMTPSA id g5sm37044757pfj.143.2022.01.02.00.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 00:22:13 -0800 (PST)
From:   Jietao Xiao <shawtao1125@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jietao Xiao <shawtao1125@gmail.com>
Subject: [PATCH] KVM:x86: Let kvm-pit thread inherit the cgroups of the calling process
Date:   Sun,  2 Jan 2022 16:22:07 +0800
Message-Id: <20220102082207.10485-1-shawtao1125@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Qemu-kvm will create several kernel threads for each VM including
kvm-nx-lpage-re, vhost, and so on. Both of them properly inherit
the cgroups of the calling process,so they are easy to attach to
the VMM process's cgroups.

Kubernetes has a feature Pod Overhead for accounting for the resources
consumed by the Pod infrastructure(e.g overhead brought by qemu-kvm),
and sandbox container runtime usually creates a sandbox or sandbox
overhead cgroup for this feature. By just simply adding the runtime or
the VMM process to the sandbox's cgroup, vhost and kvm-nx-lpage-re thread
can successfully attach to the sanbox's cgroup but kvm-pit thread cannot.
Besides, in some scenarios, kvm-pit thread can bring some CPU overhead.
So it's better to let the kvm-pit inherit the cgroups of the calling
userspace process.

By queuing the attach cgroup work as the first work after the creation
of the kvm-pit worker thread, the worker thread can successfully attach
to the callings process's cgroups.

Signed-off-by: Jietao Xiao <shawtao1125@gmail.com>
---
 arch/x86/kvm/i8254.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 0b65a764ed3a..c8dcfd6a9ed4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -34,6 +34,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
+#include <linux/cgroup.h>
 
 #include "ioapic.h"
 #include "irq.h"
@@ -647,6 +648,32 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 		kvm_pit_reset_reinject(pit);
 }
 
+struct pit_attach_cgroups_struct {
+	struct kthread_work work;
+	struct task_struct *owner;
+	int ret;
+};
+
+static void pit_attach_cgroups_work(struct kthread_work *work)
+{
+	struct pit_attach_cgroups_struct *attach;
+
+	attach = container_of(work, struct pit_attach_cgroups_struct, work);
+	attach->ret = cgroup_attach_task_all(attach->owner, current);
+}
+
+
+static int pit_attach_cgroups(struct kvm_pit *pit)
+{
+	struct pit_attach_cgroups_struct attach;
+
+	attach.owner = current;
+	kthread_init_work(&attach.work, pit_attach_cgroups_work);
+	kthread_queue_work(pit->worker, &attach.work);
+	kthread_flush_work(&attach.work);
+	return attach.ret;
+}
+
 static const struct kvm_io_device_ops pit_dev_ops = {
 	.read     = pit_ioport_read,
 	.write    = pit_ioport_write,
@@ -683,6 +710,10 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	if (IS_ERR(pit->worker))
 		goto fail_kthread;
 
+	ret = pit_attach_cgroups(pit);
+	if (ret < 0)
+		goto fail_attach_cgroups;
+
 	kthread_init_work(&pit->expired, pit_do_work);
 
 	pit->kvm = kvm;
@@ -723,6 +754,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 fail_register_pit:
 	mutex_unlock(&kvm->slots_lock);
 	kvm_pit_set_reinject(pit, false);
+fail_attach_cgroups:
 	kthread_destroy_worker(pit->worker);
 fail_kthread:
 	kvm_free_irq_source_id(kvm, pit->irq_source_id);
-- 
2.20.1

