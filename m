Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7949B04B
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 10:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574068AbiAYJbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 04:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377051AbiAYJV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:21:59 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFD5C061788;
        Tue, 25 Jan 2022 01:17:51 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i65so19129932pfc.9;
        Tue, 25 Jan 2022 01:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=VI7aOgi8DP+rWss8fUyiKKAKnxyW61GK39+BQqf7IjQ=;
        b=kpoc+jN7Oh0Xh8sqifOd+tY8Ghm2bNiqb4sbBQuTro16HbQ2BbOMHBePTsdlmGr1pl
         hEAewiRLTJx2IXZUrxyIu3hdOmjInM5Zwnk/Td0LTVdcvO2xzKX90rtU7gEpsckEInGI
         1qGxCKElOueff2YWOXMYF4rsdE8eYnztSNWVTPLgRq+ZgXI+wCc8106BGSg0QJpfnULB
         nHYLJ+ehlOpBdZrchedyDpZKJ1xakH48GpLwl0KVdu7myWug/yJ/v9BofVUrnC3NulwC
         W5OrmoishELJOfTHlIPzabjaYu6q8a9egYyQm3Rc6pto0aTgFOFqixSw+g6/Rh66y4uF
         NbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VI7aOgi8DP+rWss8fUyiKKAKnxyW61GK39+BQqf7IjQ=;
        b=ZDV4dS8dtxv7xiaaMiQXkrPRXwxlDjo/gd9aLlyJnp5/8qaWtj7Cc/DV9iy90zgw5J
         jDpLjB50ZS4QHaJ/s5JgJIcYMCNpFnkj6VwPXELweRcS3olIYNsOgWGbq44acmNL5FJM
         PKgThh22VvDTPM/zrc/+Y6bekRRnjawb74KKL2dVAkcjfe8EC1n0EHGI6zQqa7xEkK1O
         ZLGai2juZC+toHMPMnme3ufr8XVH9GwkZwT9nq2wTgsCVOAzl5PM6+OhVbTkMqQr7flD
         481Q1yQ8y4Lii+rnn2xRC93LRc+FZpaFGRBj0uDFmX2+AScZ8OJ4FjCCLhqwdKkXCyGI
         xlcw==
X-Gm-Message-State: AOAM532zswOQT+xttIRKR+NU3MvfFTIBO3mYwBMyGb7KR7f3HDChioZi
        xNptAgBQKHGlEZgsywlWvvh5Vzf4o765GQ==
X-Google-Smtp-Source: ABdhPJzAP7k1ap1vXtrYUwPxmesHj8MzzPsBeIsoCfmfcwnVaT/kuY4a0eAnOru1MxPReVwZLnzPgw==
X-Received: by 2002:a62:7705:0:b0:4c6:d435:573c with SMTP id s5-20020a627705000000b004c6d435573cmr17716034pfc.57.1643102271349;
        Tue, 25 Jan 2022 01:17:51 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id y13sm2114780pfi.2.2022.01.25.01.17.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:17:51 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Also cancel preemption timer during SET_LAPIC
Date:   Tue, 25 Jan 2022 01:17:00 -0800
Message-Id: <1643102220-35667-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The below warning is splatting during guest reboot.

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 1931 at arch/x86/kvm/x86.c:10322 kvm_arch_vcpu_ioctl_run+0x874/0x880 [kvm]
  CPU: 0 PID: 1931 Comm: qemu-system-x86 Tainted: G          I       5.17.0-rc1+ #5
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x874/0x880 [kvm]
  Call Trace:
   <TASK>
   kvm_vcpu_ioctl+0x279/0x710 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7fd39797350b

This can be triggered by not exposing tsc-deadline mode and doing a reboot in
the guest. The lapic_shutdown() function which is called in sys_reboot path
will not disarm the flying timer, it just masks LVTT. lapic_shutdown() clears
APIC state w/ LVT_MASKED and timer-mode bit is 0, this can trigger timer-mode
switch between tsc-deadline and oneshot/periodic, which can result in preemption
timer be cancelled in apic_update_lvtt(). However, We can't depend on this when 
not exposing tsc-deadline mode and oneshot/periodic modes emulated by preemption 
timer. Qemu will synchronise states around reset, let's cancel preemption timer 
under KVM_SET_LAPIC.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index baca9fa37a91..4662469240bc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2629,7 +2629,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_set_version(vcpu);
 
 	apic_update_ppr(apic);
-	hrtimer_cancel(&apic->lapic_timer.timer);
+	cancel_apic_timer(apic);
 	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
-- 
2.25.1

