Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7A444CCD6
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhKJWd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhKJWdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:53 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F052C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:05 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso1805640pjb.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FWwXwDfBnz5LFBsDCQ1wpQlpwGxzZTjObPP1GkJajQw=;
        b=IROO4E6G6/Tu+tdfzalPUTSYwK6uUaJHX2LmS4eaKh5TTZtnmAE9yCGDoEY62aX/vL
         7OTdREb33pFkvarZYwglLn1c93rjqtLfoUEZG8aV0oSTvejcx8hXPUqEXKb5oqtsSxWn
         p4S+1x/dh9KDaZ8U5NNI/J/t4w5QJC5mDT349cbnv0qjic1Y5SZQvmTQZ7wxqMNuwkO1
         f9oflPCjnaenuvAnzSVA0Mv2U/aGvR/9D9g9bTas6o3KG8PiqjLgrCMH6QIOa9acVC1O
         CjiAzXzcscqZTr1+BITbqpcYiOY4CQ+qrBDl+1JBVpRg0BS/eJa7y+G/APsZ25ArjaKk
         Sxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FWwXwDfBnz5LFBsDCQ1wpQlpwGxzZTjObPP1GkJajQw=;
        b=DWwwqW5tOqnRLnPKdA0elvLYoE+8axbdG6G7ec7cNLnSy2sGwA7rGLt+KJOPIccgwS
         yuRJcQH2RIVQoKVDjTQu75dgkVg6vnDgKPcfrfJIGwPIQM6xNJTW1edjw4GPkYcS5ILs
         WgUwpxaiyytXkGxeXqeoVNvt5QPIFVEkTcZx6cenEQ2ZcKBq/KW4Zf2Kz6x1veD32ZSa
         FrEkWlucE8TBDdLVeYr6KX80mNfMOWbbLZCebJN2L9IebOYUjVFvuRHZKtzypXSZ03p4
         uqaPYmvAnxxNzgCRhqytOuqm675uo53kTm/fSKqmWOacpHCzydkInbuHhXPYkjGKnl37
         Pbvw==
X-Gm-Message-State: AOAM530/Kxa8wxR/v5rlkPm9IfOB3GfDE2SMZ9srnNSB3yK9j7BvGV/X
        ECQelHB9sFNBjvm9g+2MyRO8mtRZrGRz
X-Google-Smtp-Source: ABdhPJxUzvRq1lCmdEsikMFwEJuiowRKri6jjr8/fv+T3xudb3seeFH03JVAy+YjfbSGQ4njn1KEsGfxjt9X
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:174e:b0:47b:d4d6:3b9e with SMTP
 id j14-20020a056a00174e00b0047bd4d63b9emr2356149pfc.21.1636583464658; Wed, 10
 Nov 2021 14:31:04 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:06 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-16-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 15/19] KVM: x86/MMU: Refactor vmx_get_mt_mask
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

Remove the gotos from vmx_get_mt_mask to make it easier to separate out
the parts which do not depend on vcpu state.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104..77f45c005f28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6987,7 +6987,6 @@ static int __init vmx_check_processor_compat(void)
 static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
-	u64 ipat = 0;
 
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
@@ -7007,30 +7006,22 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	 * EPT memory type is used to emulate guest CD/MTRR.
 	 */
 
-	if (is_mmio) {
-		cache = MTRR_TYPE_UNCACHABLE;
-		goto exit;
-	}
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
-		ipat = VMX_EPT_IPAT_BIT;
-		cache = MTRR_TYPE_WRBACK;
-		goto exit;
-	}
+	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
-		ipat = VMX_EPT_IPAT_BIT;
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
 			cache = MTRR_TYPE_UNCACHABLE;
-		goto exit;
-	}
 
-	cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
+		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+	}
 
-exit:
-	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
+	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
 }
 
 static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx, u32 new_ctl)
-- 
2.34.0.rc0.344.g81b53c2807-goog

