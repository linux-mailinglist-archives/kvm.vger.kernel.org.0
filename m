Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F88101191
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 04:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKSDIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 22:08:21 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49378 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727018AbfKSDIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 22:08:21 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A434E11915CCDBACB518;
        Tue, 19 Nov 2019 11:08:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 19 Nov 2019 11:08:11 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] KVM: x86: remove set but not used variable 'called'
Date:   Tue, 19 Nov 2019 11:06:40 +0800
Message-ID: <20191119030640.25097-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
used [-Wunused-but-set-variable]

It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
IOAPIC scan request to target vCPUs")

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d0a682..870f0bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7908,12 +7908,11 @@ void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap)
 {
 	cpumask_var_t cpus;
-	bool called;
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
-	called = kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
-					     vcpu_bitmap, cpus);
+	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
+				    vcpu_bitmap, cpus);
 
 	free_cpumask_var(cpus);
 }
-- 
2.7.4

