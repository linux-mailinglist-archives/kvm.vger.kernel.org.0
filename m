Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62DB4B07F4
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbiBJIRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:17:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiBJIRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:17:41 -0500
X-Greylist: delayed 918 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 00:17:39 PST
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8026C5;
        Thu, 10 Feb 2022 00:17:39 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JvTfJ3SzxzdZbx;
        Thu, 10 Feb 2022 15:59:04 +0800 (CST)
Received: from dggpemm500003.china.huawei.com (7.185.36.56) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 16:02:17 +0800
Received: from huawei.com (10.175.104.170) by dggpemm500003.china.huawei.com
 (7.185.36.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 10 Feb
 2022 16:02:16 +0800
From:   Liang Zhang <zhangliang5@huawei.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhigang17@huawei.com>, <zhangliang5@huawei.com>
Subject: [PATCH] KVM: x86/mmu: make apf token non-zero to fix bug
Date:   Thu, 10 Feb 2022 16:41:13 +0800
Message-ID: <20220210084113.73005-1-zhangliang5@huawei.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.170]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500003.china.huawei.com (7.185.36.56)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In current async pagefault logic, when a page is ready, KVM relies on
kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
a READY event to the Guest. This function test token value of struct
kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
READY event is finished by Guest. If value is zero meaning that a READY
event is done, so the KVM can deliver another.
But the kvm_arch_setup_async_pf() may produce a valid token with zero
value, which is confused with previous mention and may lead the loss of
this READY event.

This bug may cause task blocked forever in Guest:
 INFO: task stress:7532 blocked for more than 1254 seconds.
       Not tainted 5.10.0 #16
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:stress          state:D stack:    0 pid: 7532 ppid:  1409
 flags:0x00000080
 Call Trace:
  __schedule+0x1e7/0x650
  schedule+0x46/0xb0
  kvm_async_pf_task_wait_schedule+0xad/0xe0
  ? exit_to_user_mode_prepare+0x60/0x70
  __kvm_handle_async_pf+0x4f/0xb0
  ? asm_exc_page_fault+0x8/0x30
  exc_page_fault+0x6f/0x110
  ? asm_exc_page_fault+0x8/0x30
  asm_exc_page_fault+0x1e/0x30
 RIP: 0033:0x402d00
 RSP: 002b:00007ffd31912500 EFLAGS: 00010206
 RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
 RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
 RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
 R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
 R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000

Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 593093b52395..8e24f73bf60b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	walk_shadow_page_lockless_end(vcpu);
 }
 
+static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
+{
+	/* make sure the token value is not 0 */
+	u32 id = vcpu->arch.apf.id;
+
+	if (id << 12 == 0)
+		vcpu->arch.apf.id = 1;
+
+	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+}
+
 static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				    gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
 
-	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
-- 
2.30.0

