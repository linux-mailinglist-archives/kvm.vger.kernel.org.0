Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D577A43A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbfG3JeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:34:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44722 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729793AbfG3JeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:34:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so28640974plr.11;
        Tue, 30 Jul 2019 02:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIGR8x0TECvOo9CdyXSlrLKWHQC1JilrbogeoKsnZE0=;
        b=ODHhJ2MhVHs98ZUhYReVc9M1l3q+VolTtsGd/io1VvhfAp7G52eBT97T/10LJRXrW0
         Sx3zebYKCR4EKymUvEt2PHGLfOuTilh79jd0e455EjLjFZIuPxHhcIMgzVCPrwLM2KIT
         uN6uT4TwqtryKAAXeCkSz4CmcBtCdwS3Kc4K1C5X+PApn9MX8iRCkYvD4TJVVNqdOb1Y
         HWYsCFFMMDlNy8POTIrtSeVLfiZ15tHaYWr8SfeRdmzZeRG7XvY11uwS9oiivVAxH9NA
         6GkamN6NUvXg/q4Pv9g3SWGWhX1Aj3Vi0ogGhqRmULUDPWV6pxt9378HZ26i+5T4KqPb
         hR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIGR8x0TECvOo9CdyXSlrLKWHQC1JilrbogeoKsnZE0=;
        b=Lalv5hWAy2kEUaSkciSsCChQBq2QMnMb/KHHnpuKyyrN4AUZX/FQmgY+f3KdGFrqpf
         mBGCjkbwAls7Os042wbUrlinEQ8uE4pdXQ2izmGKHPb/qC1jWtsqSSR2Myj4t9iXwuf0
         AzDkExkgHSoGKTwT+wB9093hDFX3sRM6VuwRMLwL3axncEDMGdD46v+2rBxKessJ5iJx
         ToQm3DOW89PYv8/Rm336qwYMU0VJA76oYP7sjyamoPLzVus3FH4qi8Ya3/6U+2dw1r3W
         xSFMkKfrdn9rntnTUuli1GqNNQVwOtv/nNai6lavH5TuJjck///MnlDnQ9AQ8RJDVNtE
         OJ0A==
X-Gm-Message-State: APjAAAUvy3xw6CmBBNuDVPwFKFJJcOo1y+WndDG92epQj97dhdXpgKRu
        QjfdYEACZa7doW8PNqkI/sGGvpD+kGY=
X-Google-Smtp-Source: APXvYqzROT6cHu0Ac+/iucteZUCYhv984vcpmhmxGui+4xDy69nik3NBwBh8wvKaFnJHyn7inkEPdA==
X-Received: by 2002:a17:902:3181:: with SMTP id x1mr112092581plb.135.1564479241456;
        Tue, 30 Jul 2019 02:34:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id p15sm61641097pjf.27.2019.07.30.02.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 02:34:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock holder preemption
Date:   Tue, 30 Jul 2019 17:33:55 +0800
Message-Id: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Wake-affine is a feature inside scheduler which we attempt to make processes 
running closely, it gains benefit mostly from cache-hit. When waker tries 
to wakup wakee, it needs to select cpu to run wakee, wake affine heuristic 
mays select the cpu which waker is running on currently instead of the prev 
cpu which wakee was last time running. 

However, in multiple VMs over-subscribe virtualization scenario, it increases 
the probability to incur vCPU stacking which means that the sibling vCPUs from 
the same VM will be stacked on one pCPU. I test three 80 vCPUs VMs running on 
one 80 pCPUs Skylake server(PLE is supported), the ebizzy score can increase 17% 
after disabling wake-affine for vCPU process. 

When qemu/other vCPU inject virtual interrupt to guest through waking up one 
sleeping vCPU, it increases the probability to stack vCPUs/qemu by scheduler
wake-affine. vCPU stacking issue can greately inceases the lock synchronization 
latency in a virtualized environment. This patch disables wake-affine vCPU 
process to mitigtate lock holder preemption.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 include/linux/sched.h | 1 +
 kernel/sched/fair.c   | 3 +++
 virt/kvm/kvm_main.c   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8dc1811..3dd33d8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1468,6 +1468,7 @@ extern struct pid *cad_pid;
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
 #define PF_MEMALLOC_NOCMA	0x10000000	/* All allocation request will have _GFP_MOVABLE cleared */
+#define PF_NO_WAKE_AFFINE	0x20000000	/* This thread should not be wake affine */
 #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 036be95..18eb1fa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5428,6 +5428,9 @@ static int wake_wide(struct task_struct *p)
 	unsigned int slave = p->wakee_flips;
 	int factor = this_cpu_read(sd_llc_size);
 
+	if (unlikely(p->flags & PF_NO_WAKE_AFFINE))
+		return 1;
+
 	if (master < slave)
 		swap(master, slave);
 	if (slave < factor || master < slave * factor)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0..b9f75c3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2680,6 +2680,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
+	current->flags |= PF_NO_WAKE_AFFINE;
 	return r;
 
 unlock_vcpu_destroy:
-- 
2.7.4

