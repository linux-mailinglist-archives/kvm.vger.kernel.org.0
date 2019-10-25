Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A8E48FC
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 12:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502707AbfJYKyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 06:54:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502594AbfJYKyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 06:54:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8D4AF84C3F8D4F971006;
        Fri, 25 Oct 2019 18:54:14 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 18:54:07 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH v2] KVM: x86: get rid of odd out jump label in pdptrs_changed
Date:   Fri, 25 Oct 2019 18:54:34 +0800
Message-ID: <1572000874-28259-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The odd out jump label is really not needed. Get rid of
it by return true directly while r < 0 as suggested by
Paolo. This further lead to var changed being unused.
Remove it too.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/x86.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f812719..8b0d594a3b90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -721,7 +721,6 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.walk_mmu->pdptrs)];
-	bool changed = true;
 	int offset;
 	gfn_t gfn;
 	int r;
@@ -738,11 +737,9 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	r = kvm_read_nested_guest_page(vcpu, gfn, pdpte, offset, sizeof(pdpte),
 				       PFERR_USER_MASK | PFERR_WRITE_MASK);
 	if (r < 0)
-		goto out;
-	changed = memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
-out:
+		return true;
 
-	return changed;
+	return memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
-- 
2.19.1

