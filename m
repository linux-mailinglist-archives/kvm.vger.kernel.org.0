Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920E42F9B84
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbhARIsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 03:48:51 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11108 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387957AbhARIsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 03:48:18 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DK5413sQLz15vJr;
        Mon, 18 Jan 2021 16:46:25 +0800 (CST)
Received: from localhost (10.174.150.219) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Mon, 18 Jan 2021
 16:47:22 +0800
From:   Jay Zhou <jianjay.zhou@huawei.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <weidong.huang@huawei.com>,
        <wangxinxin.wang@huawei.com>, <jianjay.zhou@huawei.com>,
        <zhuangshengen@huawei.com>
Subject: [PATCH] KVM: x86: get smi pending status correctly
Date:   Mon, 18 Jan 2021 16:47:20 +0800
Message-ID: <20210118084720.1585-1-jianjay.zhou@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.150.219]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The injection process of smi has two steps:

    Qemu                        KVM
Step1:
    cpu->interrupt_request &= \
        ~CPU_INTERRUPT_SMI;
    kvm_vcpu_ioctl(cpu, KVM_SMI)

                                call kvm_vcpu_ioctl_smi() and
                                kvm_make_request(KVM_REQ_SMI, vcpu);

Step2:
    kvm_vcpu_ioctl(cpu, KVM_RUN, 0)

                                call process_smi() if
                                kvm_check_request(KVM_REQ_SMI, vcpu) is
                                true, mark vcpu->arch.smi_pending = true;

The vcpu->arch.smi_pending will be set true in step2, unfortunately if
vcpu paused between step1 and step2, the kvm_run->immediate_exit will be
set and vcpu has to exit to Qemu immediately during step2 before mark
vcpu->arch.smi_pending true.
During VM migration, Qemu will get the smi pending status from KVM using
KVM_GET_VCPU_EVENTS ioctl at the downtime, then the smi pending status
will be lost.

Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
Signed-off-by: Shengen Zhuang <zhuangshengen@huawei.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a..9025c76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -105,6 +105,7 @@
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
+static void process_smi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
@@ -4230,6 +4231,9 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 {
 	process_nmi(vcpu);
 
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+
 	/*
 	 * In guest mode, payload delivery should be deferred,
 	 * so that the L1 hypervisor can intercept #PF before
-- 
1.8.3.1

