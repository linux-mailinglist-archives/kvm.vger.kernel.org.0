Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3069D52CEA4
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 10:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiESIuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 04:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiESIuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 04:50:07 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671E09C2EA;
        Thu, 19 May 2022 01:50:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u15so4542082pfi.3;
        Thu, 19 May 2022 01:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=3XkJqMzIT7yz4CKyXUBxz4w4fAs7UkUmXH0W4BT/7W8=;
        b=n1mCNZHUe4ovgg3yfpu6pUERAgUVRG1zsB6BUoxgbNNr3Lnhg/oeXSGOndvSRtSfWD
         dMmX7cA0U/sFSAicvg+f4kRaY6xakDFIU/wUUSLXn8JCMdYns3xgntTT2SxyYviJQXTC
         a6ea3YAJ7bJWiHbz3AuLL/bX0STqTjs1n6/aXodw7QqPoVcfZmsb2VjJMhS47iJgWxBx
         TD7uhK3p2bSHb6NsnDC2HWpN4e/yMP4lVRddQheY32ZUhDGt0+3G6gykd+2x4W8EeBEf
         iXVgd8l/wfl5ZGWMYpP3sj295BejXYTJkbl0M1hjL0qtGa+Df6Tx8Fnx/8j8N1TB8Gbi
         36cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3XkJqMzIT7yz4CKyXUBxz4w4fAs7UkUmXH0W4BT/7W8=;
        b=R8kz+tI88+JQzG1xmY4NtpFPq5qTFA+cvnqtaNz4DXx7OohG4bmFaROuEkHGPzmDpJ
         g4eUrqwbm8xyk4vzSHHYejepWPnThdiH5LSt2HkBHCRgLf13cRi8oXSibQP25wpEZ77N
         1Um8gCTQQFRWr7bftUrdYDO0TXigqT6RVy8CgEV+w7/ufJd/ycyn3x12fqlGDYmI1nAk
         GXwpPXOqYLx9RnbnQbyt2deGEmJjbKfLPK6/pztEMeAEdSS5jpUTYn74KGO4I2UWxCso
         MZHYfI433nQ/1A3vaBargL83lXcjtYkP+8D14x2d1krS509inmkjpSSFDiXxKNLuZPwF
         OZFQ==
X-Gm-Message-State: AOAM530uNWhkCN5+eH+rFrad9nZwFoUVN3o6DG+VWR+bWqLciDceZNFt
        rYrDADgCQW815kN/Q7co/uNDBuPLYF4=
X-Google-Smtp-Source: ABdhPJzg+ucf7JA/MR7KeLOdvkun7oa5j/LfwORuKmFSUEigc9js36dXS+WdztpISTps7LqP1AFCwg==
X-Received: by 2002:a05:6a00:1a89:b0:50d:fee4:cdb1 with SMTP id e9-20020a056a001a8900b0050dfee4cdb1mr3622808pfv.85.1652950204611;
        Thu, 19 May 2022 01:50:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.84])
        by smtp.googlemail.com with ESMTPSA id t18-20020a1709028c9200b0015e8d4eb2b4sm3121541plo.254.2022.05.19.01.50.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 May 2022 01:50:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: eventfd: Fix false positive RCU usage warning
Date:   Thu, 19 May 2022 01:49:13 -0700
Message-Id: <1652950153-12489-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The below is splatting when running kvm-unit-test.

     =============================
     WARNING: suspicious RCU usage
     5.18.0-rc7 #5 Tainted: G          IOE
     -----------------------------
     /home/kernel/linux/arch/x86/kvm/../../../virt/kvm/eventfd.c:80 RCU-list traversed in non-reader section!!
    
     other info that might help us debug this:
    
    
     rcu_scheduler_active = 2, debug_locks = 1
     4 locks held by qemu-system-x86/35124:
      #0: ffff9725391d80b8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x77/0x710 [kvm]
      #1: ffffbd25cfb2a0b8 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0xdeb/0x1900 [kvm]
      #2: ffffbd25cfb2b920 (&kvm->irq_srcu){....}-{0:0}, at: kvm_hv_notify_acked_sint+0x79/0x1e0 [kvm]
      #3: ffffbd25cfb2b920 (&kvm->irq_srcu){....}-{0:0}, at: irqfd_resampler_ack+0x5/0x110 [kvm]
    
     stack backtrace:
     CPU: 2 PID: 35124 Comm: qemu-system-x86 Tainted: G          IOE     5.18.0-rc7 #5
     Call Trace:
      <TASK>
      dump_stack_lvl+0x6c/0x9b
      irqfd_resampler_ack+0xfd/0x110 [kvm]
      kvm_notify_acked_gsi+0x32/0x90 [kvm]
      kvm_hv_notify_acked_sint+0xc5/0x1e0 [kvm]
      kvm_hv_set_msr_common+0xec1/0x1160 [kvm]
      kvm_set_msr_common+0x7c3/0xf60 [kvm]
      vmx_set_msr+0x394/0x1240 [kvm_intel]
      kvm_set_msr_ignored_check+0x86/0x200 [kvm]
      kvm_emulate_wrmsr+0x4f/0x1f0 [kvm]
      vmx_handle_exit+0x6fb/0x7e0 [kvm_intel]
      vcpu_enter_guest+0xe5a/0x1900 [kvm]
      kvm_arch_vcpu_ioctl_run+0x16e/0xac0 [kvm]
      kvm_vcpu_ioctl+0x279/0x710 [kvm]
      __x64_sys_ioctl+0x83/0xb0
      do_syscall_64+0x3b/0x90
      entry_SYSCALL_64_after_hwframe+0x44/0xae

resampler-list is traversed using srcu_read_lock() in irqfd_resampler_ack, 
let's fix this false positive by list_for_each_entry_srcu() instead and 
lockdep expression srcu_read_lock_head() be passed as the cond argument.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/eventfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 59b1dd4a549e..2a3ed401ce46 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -77,7 +77,8 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 
-	list_for_each_entry_rcu(irqfd, &resampler->list, resampler_link)
+	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
+	    srcu_read_lock_held(&kvm->irq_srcu))
 		eventfd_signal(irqfd->resamplefd, 1);
 
 	srcu_read_unlock(&kvm->irq_srcu, idx);
-- 
2.25.1

