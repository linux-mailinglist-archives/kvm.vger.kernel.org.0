Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D746CA65
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbhLHB63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243257AbhLHB6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:24 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3792BC061756
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:54:53 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id q2-20020a056a00084200b004a2582fcec1so679303pfk.15
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ilHbL1zM5sA2K5veDQLis+uY2bL/xuS76iOY+nyTdGE=;
        b=c5RtAmRaT2Y3w+R/IQqFpqUXhwlQrn4jp1yOv2W1qLQjnbCURiuvLhj9RrUC4pPDbo
         5FJg5WrqcsuvvIAP3hE3YxaMAhxw9Q8Oe8omOqdEOMK5a3EUFxLvxajyDi2o5F4VNuIA
         Uca6Jy4rZ9vxm9ykt1r7J3YMwFtaNOyVCsP1/xwsJ4MBBS5WPZ8oKDcTchv4BCQMmaSJ
         p005rwSoJgFECwptXyt5k7t9BvTOCFpWNxnOnI7/HLtpGX/naDKiJxhOOr6UCmhuj6mh
         OEi/V65CuC3hRc2HJmA5u1WrY5swWXD6xaEO89gSLS/yqycKxKM4g3jTVtwBi9f3ftn4
         Y8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ilHbL1zM5sA2K5veDQLis+uY2bL/xuS76iOY+nyTdGE=;
        b=uP/fpVBtdVr2+Cy7ryAaoYHJOkxYsvdyud1PYm66YdiNDzdXon/DmUb5wNTus+hpu5
         sGh8KVYdN7HVW6sGnaHbzFS+/ZsQFh2XlOvwNR64pyVhngYKMG+++xUuSRMqNdRoB1qy
         p1X0otIf0iAx0C3KZPbu1HGRzyE5oWt8FLjKxOU4tJYBUNKVnRjw81eZNcuDeeivc4Pd
         o//FBnXK8R2dF0XwOj9PMq8d61nWIZpwBk+ZBmmOYBOdf/rm87+JOsefc32eGW4y4vpS
         kvyMFEioA/QUbU10C/Gk26iY6lsu2mYd48Yeyv/slx0JT+fsoqRyaB51lZdU3xVhMy4l
         2mKw==
X-Gm-Message-State: AOAM530BjCGqwGR9sVTAnJ88rGCic18MTqclQNNGGXGIotqUHprmPXVE
        yZ9bx6q4qt2sxZGhEdJGGtRfs6JgO5E=
X-Google-Smtp-Source: ABdhPJwnOpyy2IErsNWYguDbB1MXtbsLB9E0BGGdyZgI+a9yD1F7l/JjN9pIk5ij2InfTRFDZI7vKkwBraY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr342723pjb.0.1638928492264; Tue, 07 Dec 2021 17:54:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:13 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 03/26] KVM: VMX: Clean up PI pre/post-block WARNs
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

Move the WARN sanity checks out of the PI descriptor update loop so as
not to spam the kernel log if the condition is violated and the update
takes multiple attempts due to another writer.  This also eliminates a
few extra uops from the retry path.

Technically not checking every attempt could mean KVM will now fail to
WARN in a scenario that would have failed before, but any such failure
would be inherently racy as some other agent (CPU or device) would have
to concurrent modify the PI descriptor.

Add a helper to handle the actual write and more importantly to document
why the write may need to be retried.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 35 ++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 4db2b14ee7c6..88c53c521094 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -34,6 +34,20 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
+static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
+{
+	/*
+	 * PID.ON can be set at any time by a different vCPU or by hardware,
+	 * e.g. a device.  PID.control must be written atomically, and the
+	 * update must be retried with a fresh snapshot an ON change causes
+	 * the cmpxchg to fail.
+	 */
+	if (cmpxchg64(&pi_desc->control, old, new) != old)
+		return -EBUSY;
+
+	return 0;
+}
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
@@ -74,8 +88,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 		new.ndst = dest;
 		new.sn = 0;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (pi_try_set_control(pi_desc, old.control, new.control));
 
 after_clear_sn:
 
@@ -128,17 +141,17 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	if (!x2apic_mode)
 		dest = (dest << 8) & 0xFF00;
 
+	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
+	     "Wakeup handler not enabled while the vCPU was blocking");
+
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
-		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
-		     "Wakeup handler not enabled while the VCPU is blocked\n");
 
 		new.ndst = dest;
 
 		/* set 'NV' to 'notification vector' */
 		new.nv = POSTED_INTR_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (pi_try_set_control(pi_desc, old.control, new.control));
 
 	vcpu->pre_pcpu = -1;
 }
@@ -173,17 +186,15 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 
+	WARN(pi_desc->sn == 1,
+	     "Posted Interrupt Suppress Notification set before blocking");
+
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
-		WARN((pi_desc->sn == 1),
-		     "Warning: SN field of posted-interrupts "
-		     "is set before blocking\n");
-
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (pi_try_set_control(pi_desc, old.control, new.control));
 
 	/* We should not block the vCPU if an interrupt is posted for it.  */
 	if (pi_test_on(pi_desc))
-- 
2.34.1.400.ga245620fadb-goog

