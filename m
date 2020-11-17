Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C02B5711
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 03:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgKQCtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 21:49:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7546 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgKQCty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 21:49:54 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZr4y23RgzhYvN;
        Tue, 17 Nov 2020 10:49:38 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Nov 2020 10:49:42 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>
CC:     <hpa@zytor.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH] KVM: SVM: fix error return code in svm_create_vcpu()
Date:   Tue, 17 Nov 2020 10:54:26 +0800
Message-ID: <20201117025426.167824-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix to return a negative error code from the error handling case
instead of 0 in function svm_create_vcpu(), as done elsewhere in this
function.

Fixes: f4c847a95654 ("KVM: SVM: refactor msr permission bitmap allocation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 arch/x86/kvm/svm/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1e81cfebd491..79b3a564f1c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1309,8 +1309,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		svm->avic_is_running = true;
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
-	if (!svm->msrpm)
+	if (!svm->msrpm) {
+		err = -ENOMEM;
 		goto error_free_vmcb_page;
+	}
 
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
-- 
2.20.1

