Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093D94D2703
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 05:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiCIDxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 22:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiCIDx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 22:53:29 -0500
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 19:52:29 PST
Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3105F93;
        Tue,  8 Mar 2022 19:52:28 -0800 (PST)
Received: from mxde.zte.com.cn (unknown [10.35.8.63])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4KCymf24yFz1FH2k;
        Wed,  9 Mar 2022 11:46:42 +0800 (CST)
Received: from mxus.zte.com.cn (unknown [10.207.168.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxde.zte.com.cn (FangMail) with ESMTPS id 4KCymL6cn9z9vxpP;
        Wed,  9 Mar 2022 11:46:26 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.137])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4KCymH2jSgzdmX8h;
        Wed,  9 Mar 2022 11:46:23 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4KCymC4rBbzCBHnN;
        Wed,  9 Mar 2022 11:46:19 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 2293kAWN075179;
        Wed, 9 Mar 2022 11:46:10 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-cloudhost8.localdomain (unknown [10.234.72.110])
        by smtp (Zmail) with SMTP;
        Wed, 9 Mar 2022 11:46:10 +0800
X-Zmail-TransId: 3e8162282301005-d1ec4
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn,
        Yi Liu <liu.yi24@zte.com.cn>
Subject: [PATCH] KVM: SVM: fix panic on out-of-bounds guest IRQ
Date:   Wed,  9 Mar 2022 19:30:25 +0800
Message-Id: <20220309113025.44469-1-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 2.33.0.rc0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2293kAWN075179
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.14.novalocal with ID 62282321.000 by FangMail milter!
X-FangMail-Envelope: 1646797602/4KCymf24yFz1FH2k/62282321.000/10.35.8.63/[10.35.8.63]/mxde.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 62282321.000/4KCymf24yFz1FH2k
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As guest_irq is coming from KVM_IRQFD API call, it may trigger
crash in svm_update_pi_irte() due to out-of-bounds:

crash> bt
PID: 22218  TASK: ffff951a6ad74980  CPU: 73  COMMAND: "vcpu8"
 #0 [ffffb1ba6707fa40] machine_kexec at ffffffff8565b397
 #1 [ffffb1ba6707fa90] __crash_kexec at ffffffff85788a6d
 #2 [ffffb1ba6707fb58] crash_kexec at ffffffff8578995d
 #3 [ffffb1ba6707fb70] oops_end at ffffffff85623c0d
 #4 [ffffb1ba6707fb90] no_context at ffffffff856692c9
 #5 [ffffb1ba6707fbf8] exc_page_fault at ffffffff85f95b51
 #6 [ffffb1ba6707fc50] asm_exc_page_fault at ffffffff86000ace
    [exception RIP: svm_update_pi_irte+227]
    RIP: ffffffffc0761b53  RSP: ffffb1ba6707fd08  RFLAGS: 00010086
    RAX: ffffb1ba6707fd78  RBX: ffffb1ba66d91000  RCX: 0000000000000001
    RDX: 00003c803f63f1c0  RSI: 000000000000019a  RDI: ffffb1ba66db2ab8
    RBP: 000000000000019a   R8: 0000000000000040   R9: ffff94ca41b82200
    R10: ffffffffffffffcf  R11: 0000000000000001  R12: 0000000000000001
    R13: 0000000000000001  R14: ffffffffffffffcf  R15: 000000000000005f
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb1ba6707fdb8] kvm_irq_routing_update at ffffffffc09f19a1 [kvm]
 #8 [ffffb1ba6707fde0] kvm_set_irq_routing at ffffffffc09f2133 [kvm]
 #9 [ffffb1ba6707fe18] kvm_vm_ioctl at ffffffffc09ef544 [kvm]
#10 [ffffb1ba6707ff10] __x64_sys_ioctl at ffffffff85935474
#11 [ffffb1ba6707ff40] do_syscall_64 at ffffffff85f921d3
#12 [ffffb1ba6707ff50] entry_SYSCALL_64_after_hwframe at ffffffff8600007c
    RIP: 00007f143c36488b  RSP: 00007f143a4e04b8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 00007f05780041d0  RCX: 00007f143c36488b
    RDX: 00007f05780041d0  RSI: 000000004008ae6a  RDI: 0000000000000020
    RBP: 00000000000004e8   R8: 0000000000000008   R9: 00007f05780041e0
    R10: 00007f0578004560  R11: 0000000000000246  R12: 00000000000004e0
    R13: 000000000000001a  R14: 00007f1424001c60  R15: 00007f0578003bc0
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

Vmx have been fix this in commit 3a8b0677fc61 (KVM: VMX: Do not BUG() on
out-of-bounds guest IRQ), so we can just copy source from that to fix
this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Yi Liu <liu.yi24@zte.com.cn>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index fb3e20791338..f59b93d8e95a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -783,7 +783,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
-	int idx, ret = -EINVAL;
+	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
 	    !irq_remapping_cap(IRQ_POSTING_CAP))
@@ -794,7 +794,13 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	WARN_ON(guest_irq >= irq_rt->nr_rt_entries);
+
+	if (guest_irq >= irq_rt->nr_rt_entries ||
+		hlist_empty(&irq_rt->map[guest_irq])) {
+		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
+			     guest_irq, irq_rt->nr_rt_entries);
+		goto out;
+	}
 
 	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
 		struct vcpu_data vcpu_info;
-- 
2.33.0.rc0.dirty
