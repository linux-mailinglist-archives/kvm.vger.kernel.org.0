Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478E7507E3F
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358783AbiDTBkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358773AbiDTBkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:40:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD5A36E05
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s13-20020a17090a764d00b001cb896b75ffso258771pjl.6
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TxoVH8jqumoBwLE1c1wDjm4U/jMWUAAXwwPe08KhaNQ=;
        b=pgUid2ZDi4d44G/4li3vBbWVhssPqbGi1gqwGGH+CK49KWK01tUWd+OSwKoVoHxzpb
         KRuMdZBrKjpj/qaUlRmeWQ587hra3MxjcU6sKGqnq5xvYhRD1mDZIOm+2tguZZrYVxru
         TPCKqDMU5gvgdFZVh3TSTh4J8Vbfphme53XyZ6brp373vhABZpeOz7TUjL356Uf/fGir
         k4kr4v0pQlJuvsy8uvj/awI4+RPP2Qx/HXgWgc1gsF73SfNfi+FinOo7y0NomKgv+Ws+
         oCDUcohG+RfB01zHH4XNgqQ7+CHibj3Cz8u5A/kLSV53Se+cvxYVhi50hT1nlLoc+n+S
         w8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TxoVH8jqumoBwLE1c1wDjm4U/jMWUAAXwwPe08KhaNQ=;
        b=pYQRN9kGjNdpO5It7LYIksnxk675/HEzwL33b4SLehIxxtBlb4vqq49/WG/ztESkHf
         xUh2f2asju6xTQ0jlBoqZWkZVWfIL7ZTaJPhtLMX9Uyr6b0Tk+7w9KGBeotHR27q89OK
         E41o0rlVClXuiRovOxY0O0Fy+rJ0Iu5yr7Phg1j8SmRSpQWuD8pmO3O1y4pQc5plTwlG
         j6XIYl3VwbGT883JjzVE/xhLdrSBD/1WgxflT+XAEiiqoXbhKoq7O6WzjLIDoamYPklY
         R4Zyj+tIXe80+d2DMDf1gIdXEZgwkXn0aABFs2RtITGw/G7or4apOz8VjFV+wiFYoN3r
         3x4w==
X-Gm-Message-State: AOAM531ZXzZqgReFWM1p9hteYm8FXhlsGyAteOxnLWXKecBEglbtD5H4
        iGIx+b31nzYry3kx1lJq9iwk2QibTyE=
X-Google-Smtp-Source: ABdhPJwdSECB7MRDEUGbmw+G3pthHK/0y010kvGOeNArAgHP6vfv5vQHsKabV3zq18cVCQP57bsrRTVT8EU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:864c:b0:158:c459:ab45 with SMTP id
 y12-20020a170902864c00b00158c459ab45mr18807314plt.123.1650418657553; Tue, 19
 Apr 2022 18:37:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 01:37:30 +0000
In-Reply-To: <20220420013732.3308816-1-seanjc@google.com>
Message-Id: <20220420013732.3308816-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220420013732.3308816-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2 2/4] KVM: nVMX: Defer APICv updates while L2 is active
 until L1 is active
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer APICv updates that occur while L2 is active until nested VM-Exit,
i.e. until L1 regains control.  vmx_refresh_apicv_exec_ctrl() assumes L1
is active and (a) stomps all over vmcs02 and (b) neglects to ever updated
vmcs01.  E.g. if vmcs12 doesn't enable the TPR shadow for L2 (and thus no
APICv controls), L1 performs nested VM-Enter APICv inhibited, and APICv
becomes unhibited while L2 is active, KVM will set various APICv controls
in vmcs02 and trigger a failed VM-Entry.  The kicker is that, unless
running with nested_early_check=1, KVM blames L1 and chaos ensues.

In all cases, ignoring vmcs02 and always deferring the inhibition change
to vmcs01 is correct (or at least acceptable).  The ABSENT and DISABLE
inhibitions cannot truly change while L2 is active (see below).

IRQ_BLOCKING can change, but it is firmly a best effort debug feature.
Furthermore, only L2's APIC is accelerated/virtualized to the full extent
possible, e.g. even if L1 passes through its APIC to L2, normal MMIO/MSR
interception will apply to the virtual APIC managed by KVM.
The exception is the SELF_IPI register when x2APIC is enabled, but that's
an acceptable hole.

Lastly, Hyper-V's Auto EOI can technically be toggled if L1 exposes the
MSRs to L2, but for that to work in any sane capacity, L1 would need to
pass through IRQs to L2 as well, and IRQs must be intercepted to enable
virtual interrupt delivery.  I.e. exposing Auto EOI to L2 and enabling
VID for L2 are, for all intents and purposes, mutually exclusive.

Lack of dynamic toggling is also why this scenario is all but impossible
to encounter in KVM's current form.  But a future patch will pend an
APICv update request _during_ vCPU creation to plug a race where a vCPU
that's being created doesn't get included in the "all vCPUs request"
because it's not yet visible to other vCPUs.  If userspaces restores L2
after VM creation (hello, KVM selftests), the first KVM_RUN will occur
while L2 is active and thus service the APICv update request made during
VM creation.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 arch/x86/kvm/vmx/vmx.c    | 5 +++++
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a6688663da4d..f5cb18e00e78 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4640,6 +4640,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_apicv_status) {
+		vmx->nested.update_vmcs01_apicv_status = false;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..4c407a34b11e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4174,6 +4174,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (is_guest_mode(vcpu)) {
+		vmx->nested.update_vmcs01_apicv_status = true;
+		return;
+	}
+
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9c6bfcd84008..b98c7e96697a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -183,6 +183,7 @@ struct nested_vmx {
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
+	bool update_vmcs01_apicv_status;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.36.0.rc0.470.gd361397f0d-goog

