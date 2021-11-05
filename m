Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3E445DD5
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 03:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKECQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 22:16:07 -0400
Received: from mx316.baidu.com ([180.101.52.236]:34196 "EHLO
        njjs-sys-mailin02.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230514AbhKECQG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 22:16:06 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin02.njjs.baidu.com (Postfix) with ESMTP id 2641216540058;
        Fri,  5 Nov 2021 10:13:25 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 0A312D9932;
        Fri,  5 Nov 2021 10:13:25 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, lirongqing@baidu.com
Subject: [PATCH] KVM: x86: disable pv eoi if guest gives a wrong address
Date:   Fri,  5 Nov 2021 10:13:24 +0800
Message-Id: <1636078404-48617-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

disable pv eoi if guest gives a wrong address, this can reduces
the attacked possibility for a malicious guest, and can avoid
unnecessary write/read pv eoi memory

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/lapic.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b1de23e..0f37a8d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2853,6 +2853,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
 	unsigned long new_len;
+	int ret;
 
 	if (!IS_ALIGNED(addr, 4))
 		return 1;
@@ -2866,7 +2867,13 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	else
 		new_len = len;
 
-	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
+	ret = kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
+
+	if (ret && (vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED)) {
+		vcpu->arch.pv_eoi.msr_val &= ~KVM_MSR_ENABLED;
+		pr_warn_once("Disabled PV EOI during wrong address\n");
+	}
+	return ret;
 }
 
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
-- 
1.7.1

