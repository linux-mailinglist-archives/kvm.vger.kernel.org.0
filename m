Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B984632F2AB
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCESfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhCESbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:48 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E20C061574
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p136so3366715ybc.21
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3vB4Y/h6QDVL+3j4AiUrMRB5AA+2aPlfzfXf1TsAcOY=;
        b=os6DcV8JeNVxhBoTQ0eq0PFgNN0naOyIneLuR0FftGMvBQYnR0HxIUpns3/gN3dAhA
         gXMx9aMHvSH6tNVqLL6EqF6ebpnvPb0u5RB1/aLKxOmkG6ZFKleGVdjloh8jXy1Lsp6a
         pPQI+h5Xp+a89H90mHiG1kbWbJT8JQhIjnpvrS7YvW1fQIyrykCQWIGEO92vvmxxCPKh
         hENHbrbtQ96/MfnKhz6mRnLFsh5mabxcrIVfyQViWeBKUqQ/lWwWWjj4OCNajS1IwgNX
         KM11CVMMLNdgUhopA4kr0qnphyzP0tiBk3ZHPiNYT959AC6ueUPpi+SPPA/7rI06A5Zr
         HKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3vB4Y/h6QDVL+3j4AiUrMRB5AA+2aPlfzfXf1TsAcOY=;
        b=dVmodbCEzWfvPZwMqllr2tPQ3vdCnl9gOBznYmlIUIjTbB8STSZdw2kpSVGXJTqR/b
         7yhcSFp62CqUkBt8sjbsUs9FFyFymVa5TDy8mS0KwbsTX9X/GI/2DSqVf+nph35y/fcy
         6K6nJVpT5RVoCDTDe0F7ID8JHsayCt2M6uzaCzyEs3622UjfKNZsVzntkpu0omULf1b5
         nbPSM5EGpOP9L5b3XkzJrZP/Zua2zgBXYDcxiMqxFs1mTIawLTvUM9PmM9fuAhsrI1o9
         0vlx/DcVHnGyLuSb0U6F0hQ9Vro5K/8RX65CVIeMEhNSv6TOsk1oxwSGfMBeWkNPgcC2
         fZVw==
X-Gm-Message-State: AOAM531AxMyD+a38Kq3BT6sgap2lmZchSOqRvlP54SE3qLp8lFtkLDdn
        9gtWUs6gcqSabGEeyaKegBbNd73Be0Y=
X-Google-Smtp-Source: ABdhPJyEL75Wk6hzvC7QA1WtSNY6jXvBvzJrkAD2foYDx8aOEcCNw123tSMzGMDg5zeo43zgHLAmOYSm8e8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:ab6a:: with SMTP id u97mr15053279ybi.288.1614969107235;
 Fri, 05 Mar 2021 10:31:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:20 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 08/11] KVM: VMX: Explicitly check for hv_remote_flush_tlb
 when loading pgd
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Explicitly check that kvm_x86_ops.tlb_remote_flush() points at Hyper-V's
implementation for PV flushing instead of assuming that a non-NULL
implementation means running on Hyper-V.  Wrap the related logic in
ifdeffery as hv_remote_flush_tlb() is defined iff CONFIG_HYPERV!=n.

Short term, the explicit check makes it more obvious why a non-NULL
tlb_remote_flush() triggers EPTP shenanigans.  Long term, this will
allow TDX to define its own implementation of tlb_remote_flush() without
running afoul of Hyper-V.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cd0d787b0a85..aca6849c409a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -576,6 +576,21 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
+static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
+	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+		spin_lock(&kvm_vmx->ept_pointer_lock);
+		to_vmx(vcpu)->ept_pointer = eptp;
+		if (eptp != kvm_vmx->hv_tlb_eptp)
+			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+		spin_unlock(&kvm_vmx->ept_pointer_lock);
+	}
+#endif
+}
+
 /*
  * Comment's format: document - errata name - stepping - processor name.
  * Refer from
@@ -3114,13 +3129,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		eptp = construct_eptp(vcpu, root_hpa, root_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		if (kvm_x86_ops.tlb_remote_flush) {
-			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-			to_vmx(vcpu)->ept_pointer = eptp;
-			if (eptp != to_kvm_vmx(kvm)->hv_tlb_eptp)
-				to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
-			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-		}
+		hv_load_mmu_eptp(vcpu, eptp);
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
-- 
2.30.1.766.gb4fecdf3b7-goog

