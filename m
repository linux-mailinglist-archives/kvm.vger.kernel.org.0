Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713ED6C3FCC
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCVBee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCVBea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:34:30 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639022F78D
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:29 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o12so66921155edb.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679448867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yqb6xxqEsdl1mBUNggb94n0UttJEun4hmgcK+cmKl34=;
        b=j9Hot322Kw8vdSKGIYfIehjmT/lGai8NzPYa5ICVY3a14TY9+Vguh7PxjxjUzjFd+3
         LduR8N77HT/BfQ0/2w4ZG7FhtMZsuquaCNeHvX8dlTqj2l+5mMq9GmOlog6eUWR51MSC
         9hREiVlsEu+2exJrjh1tl1svB64gIjqDxw+2SFRE8YcwvFmT6D+i/kruiDtuVDOG/A/O
         owP7OadcYKm0fLJwIlsMb/e004F/1mLd05iz00FyiIJSLGAtOOvi+80c3RYpJF1Jc7Wx
         OSbi2pcSDZa+IHEzQ3nE2qTijLASVQ+T/vGuSxVI16OoHmtnoackNUmxB2A6weAnioPR
         qGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679448867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yqb6xxqEsdl1mBUNggb94n0UttJEun4hmgcK+cmKl34=;
        b=JXLtUkIlCmM41qAse4YexRBJvrU32C/Wvfmq59AXazrTRcXaylwmt+ydar8tQpjJ/H
         JchUpulCfmI68Nznt7WYUCIjzzdPcwr9N/rCDECZyoj0+YhWwtYPKT0Yt7wATQyUm1Os
         5mciucFfLnogTJ2lVlmO/cg8MBJTz3ly4xQX3gcBdscTZ5hrNUWDQm/fy2fvU9QpUjJk
         voy4kMsVHq5EIVh1wrdH/hmUaOk3rdIqIj3Pgi1iKNMjlIWOS8rILauTEI0iFueD6Z7O
         1sjrFfv4UBKDCpZn/62Z19jQjkBQOK2jsoMJ6jOcuHW+vr+9XxDJlXwgQt5GDcD6TzQc
         k6lQ==
X-Gm-Message-State: AO0yUKUNj1/as+4n5npBUmFlQMw94q6Hu411Jsm2d5zMQpi2TKNXruzD
        y6lKP1wanSs60jGVwCwIIlnrrzekDcWvOvP8vPM=
X-Google-Smtp-Source: AK7set9eBgCfAR/cbQivIjs/tUpBWpTOMswqCbPAJ4cgT/xF68y8v4aZaugowY4vdOgGiJGaI8r4Lg==
X-Received: by 2002:a17:906:5a87:b0:931:a164:8efa with SMTP id l7-20020a1709065a8700b00931a1648efamr5390850ejq.70.1679448867695;
        Tue, 21 Mar 2023 18:34:27 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af344e007f5e5982a136b54e.dip0.t-ipconnect.de. [2003:f6:af34:4e00:7f5e:5982:a136:b54e])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709067c8b00b009231714b3d4sm6356260ejo.151.2023.03.21.18.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:34:27 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v4 1/6] KVM: x86/mmu: Avoid indirect call for get_cr3
Date:   Wed, 22 Mar 2023 02:37:26 +0100
Message-Id: <20230322013731.102955-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322013731.102955-1-minipli@grsecurity.net>
References: <20230322013731.102955-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Most of the time, calls to get_guest_pgd result in calling
kvm_read_cr3 (the exception is only nested TDP).  Hardcode
the default instead of using the get_cr3 function, avoiding
a retpoline if they are enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 144c5a01cd77..9046a892998e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -242,6 +242,20 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
+static unsigned long get_guest_cr3(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu);
+}
+
+static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
+						  struct kvm_mmu *mmu)
+{
+	if (IS_ENABLED(CONFIG_RETPOLINE) && mmu->get_guest_pgd == get_guest_cr3)
+		return kvm_read_cr3(vcpu);
+
+	return mmu->get_guest_pgd(vcpu);
+}
+
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
 	return kvm_x86_ops.tlb_remote_flush_with_range;
@@ -3731,7 +3745,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	int quadrant, i, r;
 	hpa_t root;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -4181,7 +4195,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
-	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4200,7 +4214,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
@@ -4604,11 +4618,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr3(vcpu);
-}
-
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
@@ -5159,7 +5168,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5309,7 +5318,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 	kvm_init_shadow_mmu(vcpu, cpu_role);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd     = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5323,7 +5332,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 		return;
 
 	g_context->cpu_role.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a056f2773dd9..8417ecbc3887 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
-- 
2.39.2

