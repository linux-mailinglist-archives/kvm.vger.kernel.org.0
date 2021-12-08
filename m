Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D32746CA94
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243697AbhLHB7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243316AbhLHB6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:30 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995A3C0617A1
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:54:59 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e10-20020a17090301ca00b00141fbe2569dso268559plh.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1/Aw66oshUqg3ESqwspg+eXMi1ISq9b769Ix+vUef7Y=;
        b=Lo5e73zH8YgqQRvRWdIZEl/+aocgwtcCYU4og8Zkd2L/EebAc3UWDKdnuLWnEpoBuV
         cMh6A5AKunoPNTpu5/ZTp0vYASWYw+5Dl6dc2JzhKhfmdqGzZzo/u8zz0UX9b0mwj7aI
         OzXzByONVRk6LSETTmsSMAhP+CR2a6lyT3qCjYe+Owpom2u6mVnZrcnrV+KH1BgsyCWQ
         dZhBgaJzAi7mPEgFpMy2yNh4zSpw/iRWED1iWxMTbxIuoW0NIKmWLH3SKe0Z74vxqTym
         1ImbI/wehmcCIhvB2MvXEma6XSV7g/9zW4eweepUCs+ltwg5JeuoH6HyzvVhQROdRsRn
         gTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1/Aw66oshUqg3ESqwspg+eXMi1ISq9b769Ix+vUef7Y=;
        b=POHsm+pViT3kxBMySrjgtyx7NIid1lJaCOQAa/zBICsKBdVOylw6JmL4BpiQnIK+cA
         NQ23fLUQ4eu4jZ1yUq5wVY5RJbh7HdtzonA19ptWGgzOlXMDJf+uP/APoJENb2lb+iFi
         saaKJqY6yhVZPmJnkgCwpmhGnYnmKAOX+LMZ0n8+GLzj3qPvz0OBRn+ISEbgGTEWxnrJ
         1DYcoOFPIBdWTgbNbVRsq+cmrXlIUg0mbHiF+kCaZjSgjX5o7z8wVGLZn/Af0bftMdtj
         GyJneHKQDogZdqj1ra9tfsQTiOnPVS8dpegYP7TvCfQhQlnntZcd+h3qr9XjSOR26RmY
         lqKg==
X-Gm-Message-State: AOAM533m8R1I9w5xrVBL9QrTQ/Rw+QVH3n1DQ0ejy0QzC5WeMB3xDU5X
        zkHFlyIGSm2XWAirER9pWDmwRDH5dQo=
X-Google-Smtp-Source: ABdhPJyv4xcQqlmYYSltg7TnDvcTBERE1HFhlxtZo3nTa9A4jlHdI79RblIzvi3U6LiFmiXsfhFdaYs5EKw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:c541:0:b0:4ad:561a:5b6c with SMTP id
 j62-20020a62c541000000b004ad561a5b6cmr2897540pfg.48.1638928499087; Tue, 07
 Dec 2021 17:54:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:17 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 07/26] KVM: VMX: Move preemption timer <=> hrtimer dance to
 common x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle the switch to/from the hypervisor/software timer when a vCPU is
blocking in common x86 instead of in VMX.  Even though VMX is the only
user of a hypervisor timer, the logic and all functions involved are
generic x86 (unless future CPUs do something completely different and
implement a hypervisor timer that runs regardless of mode).

Handling the switch in common x86 will allow for the elimination of the
pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
timer if and only if it was in use (without additional params).  Add a
comment explaining why the switch cannot be deferred to kvm_sched_out()
or kvm_vcpu_block().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c |  6 +-----
 arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 64932cc3e4e8..a5ba9a069f5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7444,16 +7444,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_lapic_hv_timer_in_use(vcpu))
-		kvm_lapic_switch_to_sw_timer(vcpu);
-
 	return 0;
 }
 
 static void vmx_post_block(struct kvm_vcpu *vcpu)
 {
-	if (kvm_x86_ops.set_hv_timer)
-		kvm_lapic_switch_to_hv_timer(vcpu);
+
 }
 
 static void vmx_setup_mce(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a05a26471f19..f13a61830d9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10041,8 +10041,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
+	bool hv_timer;
+
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
+		/*
+		 * Switch to the software timer before halt-polling/blocking as
+		 * the guest's timer may be a break event for the vCPU, and the
+		 * hypervisor timer runs only when the CPU is in guest mode.
+		 * Switch before halt-polling so that KVM recognizes an expired
+		 * timer before blocking.
+		 */
+		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
+		if (hv_timer)
+			kvm_lapic_switch_to_sw_timer(vcpu);
+
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 			kvm_vcpu_halt(vcpu);
@@ -10050,6 +10063,9 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 			kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
+		if (hv_timer)
+			kvm_lapic_switch_to_hv_timer(vcpu);
+
 		if (kvm_x86_ops.post_block)
 			static_call(kvm_x86_post_block)(vcpu);
 
@@ -10244,6 +10260,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
+		/*
+		 * It should be impossible for the hypervisor timer to be in
+		 * use before KVM has ever run the vCPU.
+		 */
+		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 		kvm_vcpu_block(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
-- 
2.34.1.400.ga245620fadb-goog

