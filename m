Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B744CCDB
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhKJWeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhKJWeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:34:06 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E55C06120F
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h21-20020a056a001a5500b0049fc7bcb45aso2721105pfv.11
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bZTXtoL6rjrzQ4HwLwZZ68cG+tVDuxM3qYy8DkAd4cQ=;
        b=baoKiQKjU6YQRi/VZRG/k8cZ6kvnxiNjxD9yt8sWBe/hdX0Q/VLTZWrq30Eona0gDe
         LvijFooMTQipe3XWgcJZlN0FN2PaJV7BwUkfGPuabQ4n2LlkBlZ1B6PoymrI2YlWPkjl
         gbbNWMhjZYdmAutSvOIbx/UgznfZG7XGQIKE9SVPjFXhp/M8dZBT4PZSSi1jUOnE3SkY
         EVYh9EFoN6Gx+e64KvtpEcbqQfjdAf+qoV/dg9lFHyFU1LGag8SmPcFIkULn90THRfQB
         AeqMVenOvjia/xJ4+xqfg9PH0/nTYu/o+Q2lK1tVOdPMMw5EPbux0HPsScpom9HVcTC9
         o7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bZTXtoL6rjrzQ4HwLwZZ68cG+tVDuxM3qYy8DkAd4cQ=;
        b=SXRUik9GUp4B7Iv6CYH/3vpdkBGDXvNum+a9whBAe0+opJlHqVPUuZVQBOHJsQa7Mf
         hoQt3IpyJuM5X5DWlxiqa1YyHPWDBqmGB4/9GywpvnTVFK4W/Ey+/tL7w0k2tHZYYhHw
         kzjCwraNd/b1wKFCIFIc02Qs9mKMTXOohZNttDFvdxy58nQr6dkFCjuvo76LB/yj8K9V
         Zc9mlpYT0w0qOZZkXIvZY0SIxya7r4ecIgcS9VlT3/Y7DPghHEMOruXzfi/qsEEegvno
         ueAa5/QaJb3GHcvURFkeGarM0vve63N50bpUZpbZDrdCodbtzzNbSN/AEa2RLOQHq8QA
         5ilA==
X-Gm-Message-State: AOAM531n73IaWzcRXagLtqmDm+w+2h+harKXFOjj2SnCDlrL4OyiJR9R
        wSbWrQbddqDOkBbJ1vQrxupUOK4hRADy
X-Google-Smtp-Source: ABdhPJwl96mkKsHES8Eqe+lbSV/Cm0gOjq4Js/ovxC9x8ZbcgihmVW5WWukxAIvwv6UHgbSSO2vghgeeXVY7
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1312:b0:44c:becf:b329 with SMTP
 id j18-20020a056a00131200b0044cbecfb329mr2529651pfu.5.1636583470017; Wed, 10
 Nov 2021 14:31:10 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:08 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-18-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 17/19] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
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

Add another function for getting the memory type mask to x86_ops.
This version of the function can fail, but it does not require a vCPU
pointer. It will be used in a subsequent commit for in-place large page
promotion when disabling dirty logging.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/svm/svm.c             | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c             | 1 +
 4 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..c86e9629ff1a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -84,6 +84,7 @@ KVM_X86_OP_NULL(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
+KVM_X86_OP(try_get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..ae13075f4d4c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1400,6 +1400,8 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	bool (*try_get_mt_mask)(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..d073cc3985e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4067,6 +4067,13 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	return true;
 }
 
+static bool svm_try_get_mt_mask(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask)
+{
+	*mask = 0;
+	return true;
+}
+
 static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	return 0;
@@ -4660,6 +4667,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
 	.get_mt_mask = svm_get_mt_mask,
+	.try_get_mt_mask = svm_try_get_mt_mask,
 
 	.get_exit_info = svm_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4129614262e8..8cd6c1f50d3e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7658,6 +7658,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
+	.try_get_mt_mask = vmx_try_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

