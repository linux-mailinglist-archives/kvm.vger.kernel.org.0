Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265E545286E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbhKPDTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbhKPDSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:04 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A78C125D62
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:29 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id f206-20020a6238d7000000b004a02dd7156bso9198085pfa.5
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oOs80LZVdiQ4d3q5aPfHR+bsPyznZ55Wbv8FEL1qlus=;
        b=mF0hAH9QLpjpmeGlCCFxRTBcxrivS+KQjuYb3LUyFj60om6rSZzrwpaKaBVGYAQUVo
         G/jC+HFg+lm6Eh2AC0N5nsncCcaS+7aJjaHsxkhKySmn7+tC3Ddrr8oSwGr3v++mQeB5
         lFsvnM9HWxS0dljDtQkQQ0bwGg/Sgo5aQO4sfF6FaxwPMUxaIYWpBW1GYeIUbuzqjJK8
         qS58pJD5z3G1SgA7GNRk6j4QwQGHpxgKWdH8SWYqdN5PuT0UuvA0VmwE2uTRHQj0vqGE
         N2WKHWraNlXVzUWPsNL7fO4Kk8yIac9Peis4ZIoo14kBEVt7cfgkr724txZS75XvQKTc
         qupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oOs80LZVdiQ4d3q5aPfHR+bsPyznZ55Wbv8FEL1qlus=;
        b=rTTZxEblBMzb0hMBIne2PstTDZsDs6RCS5L8RZ15QgmzyuyrGoIFGk1scqkQNQGmlU
         Q/dcSe8oYHZunsQp3Td1cUG7IrI9gYmHMcCteZP/UhsOmg4deyDK9a+plJoix6avTSzg
         b3GMqNdaSFk0cb2XMZsD3GPu7mYoZrsVoILAQFyP6OE4oCpw6dtM1f1VvcvlZCJZYHBa
         diQg/3KPUp1yg03qoeuaNXWPrjrZdyQf6sRX4VWLmoSvuDpN0OXD76cagLf2U/FX4YT5
         FDiBcb9dqKoL5yq+tC7nZbOkdMUvr4YKWakO/k5qOVV22xBAuVdTSq8WKjWBAyCxgMdE
         hz7g==
X-Gm-Message-State: AOAM533bWUI9+XJHJlSlzkfOFlqZFpAVfiy6Wfy5JsNTs1+Qs40e/X3a
        OrNR2YhO+mL40LP24CYh5+QJ3XpwvOqy
X-Google-Smtp-Source: ABdhPJzRGCVAwdaAydunYFkfEvbpn17w5k9kC3M5j5eufSSBuuTXWSLhdlcmuG9m8skndRSZpj8BmuH1DPQP
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:90a:6e0c:: with SMTP id
 b12mr15821912pjk.41.1637019988883; Mon, 15 Nov 2021 15:46:28 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:46:00 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-13-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 12/15] KVM: x86/mmu: Factor out part of vmx_get_mt_mask which
 does not depend on vcpu
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the parts of vmx_get_mt_mask which do not depend on the vCPU
argument. This also requires adding some error reporting to the helper
function to say whether it was possible to generate the MT mask without
a vCPU argument. This refactoring will allow the MT mask to be computed
when noncoherent DMA is not enabled on a VM.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77f45c005f28..4129614262e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6984,9 +6984,26 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
+static bool vmx_try_get_mt_mask(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask)
+{
+	if (is_mmio) {
+		*mask =  MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+		return true;
+	}
+
+	if (!kvm_arch_has_noncoherent_dma(kvm)) {
+		*mask = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+		return true;
+	}
+
+	return false;
+}
+
 static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
+	u64 mask;
 
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
@@ -7006,11 +7023,8 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	 * EPT memory type is used to emulate guest CD/MTRR.
 	 */
 
-	if (is_mmio)
-		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
-
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
-		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+	if (vmx_try_get_mt_mask(vcpu->kvm, gfn, is_mmio, &mask))
+		return mask;
 
 	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-- 
2.34.0.rc1.387.gb447b232ab-goog

