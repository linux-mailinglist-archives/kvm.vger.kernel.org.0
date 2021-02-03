Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E29F30DD76
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhBCPCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhBCPCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A57C06178B
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WxoQ1CqwF7NNgJE6+LIgARHmwqvU7OUu+oZngDmfLnM=; b=Xdu3hUP226GQm/2LfyeFIk/N7W
        AGSHJL6qtt2FJEj9pMOEi4T/D7ZIPBEIRnTSnbfImn8jkGXIn96b0IEKyHr1F8j5PhIQkalZd5uxz
        zf51xk3dXudpQAGdhSaxeHptbeen7zEBDgDwsZZ2HIGWh3MYl/6XXKKnvlvtj0JwvD7D2bEY29lnd
        bD/UOUrne3mz/BhkKpzwt2xUxaKBVSNme6XJoCuEr/kfxJT1lI4TNq47BqhoHkzmbnbTqrQvVVQW5
        P4VxSvF2J96dT09YQ5KdWufoSVeQPfPmKBYxemyis1AWOiJntXvWodARam5I0Dm85DtkMPllcTzuP
        RwJE8DBw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015h-4o; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reB-1j; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 01/19] KVM: x86/xen: fix Xen hypercall page msr handling
Date:   Wed,  3 Feb 2021 15:00:56 +0000
Message-Id: <20210203150114.920335-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
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
index 76bce832cade..40be21f7c359 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3008,6 +3008,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
+	if (msr && msr == vcpu->kvm->arch.xen_hvm_config.msr)
+		return xen_hvm_config(vcpu, data);
+
 	switch (msr) {
 	case MSR_AMD64_NB_CFG:
 	case MSR_IA32_UCODE_WRITE:
@@ -3295,8 +3298,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

