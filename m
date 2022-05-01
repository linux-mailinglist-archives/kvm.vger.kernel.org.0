Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEA51687A
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359529AbiEAWLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355597AbiEAWL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:27 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE301C93F;
        Sun,  1 May 2022 15:08:00 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjM-0008Mj-L7; Mon, 02 May 2022 00:07:52 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/12] KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0
Date:   Mon,  2 May 2022 00:07:26 +0200
Message-Id: <35426af6e123cbe91ec7ce5132ce72521f02b1b5.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Don't BUG/WARN on interrupt injection due to GIF being cleared,
since it's trivial for userspace to force the situation via
KVM_SET_VCPU_EVENTS (even if having at least a WARN there would be correct
for KVM internally generated injections).

  kernel BUG at arch/x86/kvm/svm/svm.c:3386!
  invalid opcode: 0000 [#1] SMP
  CPU: 15 PID: 926 Comm: smm_test Not tainted 5.17.0-rc3+ #264
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_inject_irq+0xab/0xb0 [kvm_amd]
  Code: <0f> 0b 0f 1f 00 0f 1f 44 00 00 80 3d ac b3 01 00 00 55 48 89 f5 53
  RSP: 0018:ffffc90000b37d88 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff88810a234ac0 RCX: 0000000000000006
  RDX: 0000000000000000 RSI: ffffc90000b37df7 RDI: ffff88810a234ac0
  RBP: ffffc90000b37df7 R08: ffff88810a1fa410 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff888109571000 R14: ffff88810a234ac0 R15: 0000000000000000
  FS:  0000000001821380(0000) GS:ffff88846fdc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f74fc550008 CR3: 000000010a6fe000 CR4: 0000000000350ea0
  Call Trace:
   <TASK>
   inject_pending_event+0x2f7/0x4c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x791/0x17a0 [kvm]
   kvm_vcpu_ioctl+0x26d/0x650 [kvm]
   __x64_sys_ioctl+0x82/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: 219b65dcf6c0 ("KVM: SVM: Improve nested interrupt injection")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 75b4f3ac8b1a..1cec671fc668 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3384,8 +3384,6 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(gif_set(svm)));
-
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
