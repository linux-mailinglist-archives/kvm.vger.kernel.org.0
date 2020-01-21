Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703B914359A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 03:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAUCQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 21:16:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgAUCQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 21:16:50 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D0602624C87E6C663BEB;
        Tue, 21 Jan 2020 10:16:47 +0800 (CST)
Received: from huawei.com (10.175.104.201) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 10:16:41 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: VMX: remove duplicated segment cache clear
Date:   Tue, 21 Jan 2020 10:15:18 -0500
Message-ID: <20200121151518.27530-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.201]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_set_segment() clears segment cache unconditionally, so we should not
clear it again by calling vmx_segment_cache_clear().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b5a0c2e05825..b32236e6b513 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2688,8 +2688,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	vmx->rmode.vm86_active = 0;
 
-	vmx_segment_cache_clear(vmx);
-
 	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-- 
2.19.1

