Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054C246CA8F
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243637AbhLHB7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243296AbhLHB6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:45 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5D5C0698CE
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:13 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e9-20020a170902ed8900b00143a3f40299so259881plj.20
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=X7msKu2GVp9E0ZpcDJCdOmGYb8rkZCL+gG+mH7XwWxU=;
        b=MGCS3s5h+GUbkgbaytoK6R5wN1WpbpF8O5CZTZYFVIUfvB0My+TiFlx0/zyrqez/ev
         tXeDJh6olo1GekmGi8gOMvHQHaqhjuZhoP7yDY0VB11bJBkq349WsBPHBNDAsJxkm29J
         SRrd3q67wwtmHgE5CW+pxL+yZ0oZGMJQO3xu8Q6871L1t5JCCKjUNCUxJMrA2iGJFcQG
         2XixkIdqSCM5nqc6GTG+rOUyGEP6pGfSIf9Bt+e+v+n8HnSnCpTUyfWUu8U1dnhN5x+p
         /s9gKdYQQbGKQP9cZxAzusWXegQcDb4Vvl2nh+kWm9bQIzlchxvuMT9i3eGafh5eWnsS
         As3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=X7msKu2GVp9E0ZpcDJCdOmGYb8rkZCL+gG+mH7XwWxU=;
        b=jDy3VTgs6ocJz8Gr0GHseaiWGsApEk7CFlutU5JwPE44kvEX+QSPDk6R3p6Oz52ok5
         pISWwcWFzaw/vYxymWgoiZSpwj5Eqnn1M6+HxB2XFihwboNxs0xui8bsvlMoNHAC+49d
         E8lCJHoB1KJoflO60Slpr9wdCbsgkJ7+w0qPUBaSyQcZ6GgDiSVnYlMyXtf6RlB24fqo
         sYmfKVRQbiDLgPgQ0k0Hn2qYNtvu/DuQC1+lDIWLvg7Lj8K1LhB89U9ILO6u42xscfC+
         +WJd9Hd+RP6Yz8y6nXiCgd0rRIoZ+LrGeCInSsrhMaZo84F5OyUSSws6hy8ZTbtqYu9O
         be+g==
X-Gm-Message-State: AOAM530KjCdcrlSh8Ew8uXIocFpcAfmOPvVAr9zevXxZHP7L3VVd4ZLA
        hhb6wI8DXREjdzcqIv7lGr1AmBQkJ4k=
X-Google-Smtp-Source: ABdhPJwwd8WUavyXWkw+OViuN+eQTI5AawYBwATEwNoGUp+lxKsz+H67sWAVn33+UEgO/j7hG//O4mVszWM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1e07:: with SMTP id
 pg7mr3527958pjb.185.1638928512956; Tue, 07 Dec 2021 17:55:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:26 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 16/26] KVM: VMX: Don't do full kick when triggering posted
 interrupt "fails"
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

Replace the full "kick" with just the "wake" in the fallback path when
triggering a virtual interrupt via a posted interrupt fails because the
guest is not IN_GUEST_MODE.  If the guest transitions into guest mode
between the check and the kick, then it's guaranteed to see the pending
interrupt as KVM syncs the PIR to IRR (and onto GUEST_RVI) after setting
IN_GUEST_MODE.  Kicking the guest in this case is nothing more than an
unnecessary VM-Exit (and host IRQ).

Opportunistically update comments to explain the various ordering rules
and barriers at play.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/x86.c     | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b8804d93776..fa90eacbf7e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3956,7 +3956,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 
 		/* the PIR and ON have been set by L1. */
 		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
-			kvm_vcpu_kick(vcpu);
+			kvm_vcpu_wake_up(vcpu);
 		return 0;
 	}
 	return -1;
@@ -3995,7 +3995,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 */
 	if (vcpu != kvm_get_running_vcpu() &&
 	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a2341e4ff30..abf99b77883e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9887,10 +9887,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	smp_mb__after_srcu_read_unlock();
 
 	/*
-	 * This handles the case where a posted interrupt was
-	 * notified with kvm_vcpu_kick.  Assigned devices can
-	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
-	 * so do it even if !kvm_vcpu_apicv_active(vcpu).
+	 * Process pending posted interrupts to handle the case where the
+	 * notification IRQ arrived in the host, or was never sent (because the
+	 * target vCPU wasn't running).  Do this regardless of the vCPU's APICv
+	 * status, KVM doesn't update assigned devices when APICv is inhibited,
+	 * i.e. they can post interrupts even if APICv is temporarily disabled.
 	 */
 	if (kvm_lapic_enabled(vcpu))
 		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
-- 
2.34.1.400.ga245620fadb-goog

