Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E3127C72F
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 13:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgI2LwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 07:52:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730546AbgI2LwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 07:52:03 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C36F43EC24B5F0C375CC;
        Tue, 29 Sep 2020 19:51:58 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 29 Sep 2020
 19:51:52 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
CC:     <weiyongjun1@huawei.com>, <huawei.libin@huawei.com>,
        <cj.chengjian@huawei.com>, <pbonzini@redhat.com>,
        <sean.j.christopherson@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH -next] x86/kvm: Fix build with CONFIG_SMP disabled
Date:   Tue, 29 Sep 2020 19:50:13 +0800
Message-ID: <20200929115013.3913359-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When CONFIG_SMP is disabled, build failed like this:

arch/x86/kernel/kvm.c: In function ‘kvm_alloc_cpumask’:
arch/x86/kernel/kvm.c:823:35: error: ‘kvm_send_ipi_mask_allbutself’
 undeclared (first use in this function); did you mean ‘apic_send_IPI_allbutself’?
  apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                   apic_send_IPI_allbutself
arch/x86/kernel/kvm.c:823:35: note: each undeclared identifier
 is reported only once for each function it appears in

It is because the declaration of kvm_send_ipi_mask_allbutself() is guarded
by CONFIG_SMP. kvm_send_ipi_mask_allbutself() do not need do anything at
this time.

Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
---
 arch/x86/kernel/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a44398d2bc44..47d65864e29c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -611,6 +611,13 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	local_irq_enable();
 	return 0;
 }
+
+#else /* !CONFIG_SMP */
+
+static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
+{
+}
+
 #endif
 
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
-- 
2.25.1

