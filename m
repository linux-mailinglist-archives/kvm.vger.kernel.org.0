Return-Path: <kvm+bounces-1944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5207EF2B8
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:37:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F93BB20B7C
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 12:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7583330F8F;
	Fri, 17 Nov 2023 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 617 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Nov 2023 04:36:53 PST
Received: from njjs-sys-mailin01.njjs.baidu.com (mx316.baidu.com [180.101.52.236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7E49B3
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 04:36:53 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 85A787F00067;
	Fri, 17 Nov 2023 20:26:33 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: x86@kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to create vcpu
Date: Fri, 17 Nov 2023 20:26:33 +0800
Message-Id: <20231117122633.47028-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
X-Spam-Level: *
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Static key kvm_has_noapic_vcpu should be reduced when fail
to create vcpu, this patch fixes it

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41cce50..2a22e66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11957,7 +11957,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.mci_ctl2_banks);
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
-	kvm_free_lapic(vcpu);
+	if (!lapic_in_kernel(vcpu))
+		static_branch_dec(&kvm_has_noapic_vcpu);
+	else
+		kvm_free_lapic(vcpu);
 fail_mmu_destroy:
 	kvm_mmu_destroy(vcpu);
 	return r;
-- 
2.9.4


