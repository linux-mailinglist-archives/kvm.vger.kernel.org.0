Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD445286F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbhKPDTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbhKPDSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:07 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BF9C125D64
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso685271pjb.2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Dlsx6G0Aa6YAW2eF9MRy8C2GdRBAN+E2yIu8b7+b9gE=;
        b=AEPSb9gB9X+mcoeEkrhUu6b+vkvNQpe19neoqdvuZtdk8rgBcyqmFEQqDZoShMgBCu
         HREY/EiiIwsModnlEeROFHIQBCUq8L9TIJmwLikrEdzt361/YGsezjGOKqfuowRZtoK5
         SS4gsvFbD606g0JsRcmIj2deIeblTjqimUdvAxUhiZ9Dk6MoEao7lPnuQ0qj+C07aQVt
         CiBZCpRJdTH1X0Ybb6PtPVmtrS5v0+60kQZ6vpM6x5Xa6ybC/I8Iw940CH7vD2nA4RTV
         4XaSQzbfht6xxSyB9CLzmuSLQBZSFmvGE/1Cjtv4I+zt6A+TElEvfa9ivyC49Iiy2zEX
         cORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Dlsx6G0Aa6YAW2eF9MRy8C2GdRBAN+E2yIu8b7+b9gE=;
        b=MrW6tCN4yfYWhba2HNNqh1DefVRjokMdsqNC10x/Ok1yhzJuV1HVykcDDm9LK6PE8j
         DtMsryC0ecn2iwMH3dSVNwJB5qhM4LBTCP3hEIbo06uPxmz5Se8Gjojkt+Kx9CPsPgq2
         w330aWyi5uD3vZcJ+GJ7S4kzruUWdzDpEhGS5WvSEQOFdTdzAu6usm05jicxq5BgDaka
         YKD8CLL7Svac+nEe8w0YCfPcwk0REZWAl1+V6e6HSWf6ljWn7ZcDYGIRD2l4W6LeNkR2
         elvzcEoKLqnpjtojwi85CftfAxcwEfuG2T5Wa9ZXFWv3eV/6QIDSkCBzX8/vsHpzAzro
         egYA==
X-Gm-Message-State: AOAM530/0s47hrzOabeLnPWmR1+gKXX437aNa9FzfX3QUGlOOPUEGJfb
        s2mbKzPrOsqYVIWm6J2qbSZBFkI2NqFR
X-Google-Smtp-Source: ABdhPJxR7BgjoBwQ9B89WxUa2H67v65qgcqcKHTSHeJIPSHgSFYipbBYjqUIToRFiR6eHE45WHICziu1KB4s
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr5719pjf.1.1637019990603; Mon, 15 Nov 2021 15:46:30 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:46:01 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-14-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 13/15] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
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
2.34.0.rc1.387.gb447b232ab-goog

