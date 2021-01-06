Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0722EB6D8
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbhAFAZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhAFAZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 19:25:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D539C06179E
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 16:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rNJwjPQ7Qc7Ainnec/slAm+3+N/HJjvYoiheRUN6QLg=; b=adf91Pk9fRFB2a8juCO2Yx47kB
        Z5D1EuzrSSaqC+lmkjGkMkYSlZdX9cYOo0PdruMpZq9FAj94HczGTZKX9eK6RxX5VdoV09sJDrWqH
        u6N5z4P73xA90ORtJklkVgZEuV1kqPeVGGUY/gYS34c45sMPU/aD8FmUfP34lWxdJz7XHkgoaz/JM
        9kmJhOTdxZS9FStc9Sr0lEEi0f5TsedLW5zkYLvUCoMlz3PwzsV8EmwdjjwwhRYdxqpd6NY/qrB/r
        dn9w5P1vbS4TjCJ1WxgoCfaPyX2f0CveJp9PQ0YZIEQXTvGAQe+BD65QbP7bUz/fuFhI97eJP8tYK
        vZqSTvzA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kwwbh-001pA4-LS; Wed, 06 Jan 2021 00:23:36 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwwbh-001Nin-9W; Wed, 06 Jan 2021 00:23:21 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v4 01/16] KVM: x86/xen: fix Xen hypercall page msr handling
Date:   Wed,  6 Jan 2021 00:22:59 +0000
Message-Id: <20210106002314.328380-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106002314.328380-1-dwmw2@infradead.org>
References: <20210106002314.328380-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Xen usually places its MSR at 0x40000000 or 0x40000200 depending on
whether it is running in viridian mode or not. Note that this is not
ABI guaranteed, so it is possible for Xen to advertise the MSR some
place else.

Given the way xen_hvm_config() is handled, if the former address is
selected, this will conflict with Hyper-V's MSR
(HV_X64_MSR_GUEST_OS_ID) which unconditionally uses the same address.

Given that the MSR location is arbitrary, move the xen_hvm_config()
handling to the top of kvm_set_msr_common() before falling through.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..f219d50b3700 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3007,6 +3007,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
+	if (msr && msr == vcpu->kvm->arch.xen_hvm_config.msr)
+		return xen_hvm_config(vcpu, data);
+
 	switch (msr) {
 	case MSR_AMD64_NB_CFG:
 	case MSR_IA32_UCODE_WRITE:
@@ -3294,8 +3297,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
 	default:
-		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
-			return xen_hvm_config(vcpu, data);
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		return KVM_MSR_RET_INVALID;
-- 
2.29.2

