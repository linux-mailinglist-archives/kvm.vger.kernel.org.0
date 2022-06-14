Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC854BD2E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 00:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353630AbiFNV64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358400AbiFNV6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7722C1D322
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q2-20020a170902dac200b00168b3978426so5465072plx.17
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VkciRITE8MX2e/fBaXePCOT9PxykPyFPZjCAcpl0DRs=;
        b=Dgvl2DqkyuRiJ9H+pEZA8XMbJtPmxfmzXbRsqrSCNYHx54Pm7s/Vq1hUlhJqqu/dcM
         jim3cYglLC/fKlXqtfKtBBjDCxl+VBMJP4q3HqNDGwfrRigBv7wpt0/9KYBxICR36Ms3
         i82ojnxgaG8DCPcNyQTURnzVOuGWARafqEVFK621s05dCBUzjTZIUt8CoALAe3jxmrGX
         iSf0FzP07cg60UHhsMfQqDtJG8vVzsnLlBKWaweawjeNybcoeoaRkC5QdXeKrkhBjtCE
         Vo/P1veqNhnomHe55Dx+/cc+kvoJ3N1/frBOaNedTGyFguaxFoi+Yo6FCqUU2bXcb06h
         0ddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VkciRITE8MX2e/fBaXePCOT9PxykPyFPZjCAcpl0DRs=;
        b=T2PO7qxr5f+4V44UuF3r0JE2YcZm9u1N9qLGIlIRv8xKsEo+oLIWWxBKMGVItHBif+
         w77hPY+Om77vKgkEMG2FxVgOBipTIDg1yjkd/215bcNxzQgN3bDffb6Vshu52nJf7pia
         icRT1u14m2LAOoXVEao5RfMB4onySm/YqB7d9Y0OrN1ZTs/lzOAr94BzIeHPt4vPjWoT
         ZP5dW34HOkXkLHh0F8Fuvc5NaKvi6uiI6JgejG6w54+p55MWqSN9vLAVOj+dlrOkoCJe
         Rl++n7lZdQmO4alqrs/J7neIz1K0wUltZ/7pTrqWCV331Td35A4BG8OxwTO1wlenE9ty
         jcIg==
X-Gm-Message-State: AOAM530esCTAPmbfMM5Zh0jduS2XPUHpKylyoAFiVUwUamvj/i+XvxhB
        UDPiueDfMjLlHX94A6V6XcZvMGj6PVY=
X-Google-Smtp-Source: ABdhPJwtYfSgBHJzdAZ9JEnVys0qD/gftvIVUq7SlQzKbZlVNnru294GpsA3hurbIhuRRDdC2aCPnYUMcTU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a03:b0:522:990c:c795 with SMTP id
 p3-20020a056a000a0300b00522990cc795mr6481704pfh.15.1655243922923; Tue, 14 Jun
 2022 14:58:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:31 +0000
In-Reply-To: <20220614215831.3762138-1-seanjc@google.com>
Message-Id: <20220614215831.3762138-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220614215831.3762138-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 5/5] KVM: nVMX: Update vmcs12 on BNDCFGS write, not at
 vmcs02=>vmcs12 sync
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Wang <lei4.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update vmcs12->guest_bndcfgs on intercepted writes to BNDCFGS from L2
instead of waiting until vmcs02 is synchronized to vmcs12.  KVM always
intercepts BNDCFGS accesses, so the only way the value in vmcs02 can
change is via KVM's explicit VMWRITE during emulation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ---
 arch/x86/kvm/vmx/vmx.c    | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 496981b86f94..aad938e1e51d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4104,9 +4104,6 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
-	if ((vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
-	    (vmx->nested.msrs.exit_ctls_high & VM_EXIT_CLEAR_BNDCFGS))
-		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3f9b8bb1fa8..1463669f7a99 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2044,6 +2044,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
 			return 1;
+
+		if (is_guest_mode(vcpu) &&
+		    ((vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
+		     (vmx->nested.msrs.exit_ctls_high & VM_EXIT_CLEAR_BNDCFGS)))
+			get_vmcs12(vcpu)->guest_bndcfgs = data;
+
 		vmcs_write64(GUEST_BNDCFGS, data);
 		break;
 	case MSR_IA32_UMWAIT_CONTROL:
-- 
2.36.1.476.g0c4daa206d-goog

