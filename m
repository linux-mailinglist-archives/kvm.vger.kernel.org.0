Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1E452864
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbhKPDTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbhKPDSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:04 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8DAC125D60
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a12-20020a17090aa50cb0290178fef5c227so306030pjq.1
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0zwyK1+5SQSFi33zyn3A2qd649otgAUCjnWlf13vnt4=;
        b=eLYV4+JIwHSuMcMpNKKlGM6iy8jUFnvLlNL8Aq95E7jZBtaCwbmdVfVVHCF0LY6qeS
         3WfargDXoaDwa5wtyd3HN/VegDEqqGFbzcS/kLiu3JhWuUFMG6L0WyaXb3yNzpF1UDxT
         Db2GTF8u0GsI7+1GaPha6eX1CuiWHO0L2WKt6Y4uN9V+ZNgXMYhy/MHgOF4zHqz2Bjfq
         sIV146dWVag2Y+XUfHbjrCHJxZYXvRlqp0QspMblFxm8D8oQtbRuLUlNuqmZFtee2cT8
         Jz/BRbS5ImG9Dx2qndjtt2CeQ/C0ULPdJZdB0vP4AHrrZRioItj9bcxJbirYqucQBIxJ
         jOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0zwyK1+5SQSFi33zyn3A2qd649otgAUCjnWlf13vnt4=;
        b=XHE0tqjNvDbmVF/+iNR+LlQwJw37oQU19IJR/iOebB4YT4zCimFOXShhYZY5F8BoFF
         CZb48UfZuxPdeNWS9xHWD5uMidz1JQOZdahlk0ji5TBxnz+4go/dWifV23DXrAw7JjF0
         eNEJ3jgm6RWwzV1iJrojmAB69JZO0VAKGZkSrfU3TPH2ODu43JyxqXFqvinm+QnuihNp
         LKSxSZ1acW1QMOLNhpjvcia3/d39h2jUHG2iaetwEqD8V7/RuwJYztyq6zfKx4cqvo/l
         P3bXHerSQ9tHHCPew4SbT/fp2GqFn2TTPoEOmc8EoU8MzqnolWc3O5mGHfR+f3A9Axds
         aGbQ==
X-Gm-Message-State: AOAM531aHUz5DnJIPVtRAhVzbkayL9l7I94j+JeyKLFGAJmcQk8tcPVb
        NNSjy7tw/FeZe4uPV+r16SQFvUCljde1
X-Google-Smtp-Source: ABdhPJy0ArkW29tRlngLJfDrzxQXp4ZPpLuHRsLyZfvuNRCXPgtMO6AdXTagSFmsnZPpyQZO6mAqrpn/wzPb
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:90a:800a:: with SMTP id
 b10mr70386185pjn.162.1637019987257; Mon, 15 Nov 2021 15:46:27 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:59 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-12-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
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
2.34.0.rc1.387.gb447b232ab-goog

