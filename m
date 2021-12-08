Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA31E46CA92
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243496AbhLHB7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243312AbhLHB6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:46 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8329AC061A32
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:15 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id d2-20020a656202000000b00325603f7d0bso432896pgv.12
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/zLOcA0/RCKP4IPePRP8srGBuJZlvIhnpk9KTslNG9g=;
        b=LxBE8r1fQIl3UYOlBm78E+SztDv7JU+iem9UMbs8YQEF6Ys7uOajRABh6dnsSJk9+F
         2E0dVIsCyPKv+U3D5VQvykjt0oagpsrOTuBEgNI7m2rdiZJHlV23waCf2tbnw264cD94
         VP6I18bDsVuk2s3boDNzZbo2s2BMpEq/m653dG27/JmTx9o/334flpmobw6Q5NA7jBWT
         sXCrIKzgbU4DOhdaDxIE9qh7KvtmwvCzjJB5FBkogquF99wcJ7cNJWjngzUAyfpaFD6F
         ZQP9VQt8iLqvOjouYpr+RD392YAmFADp0xI9PY+unelTWbbN/ppduOgmhuJa9LBMEZ6d
         JtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/zLOcA0/RCKP4IPePRP8srGBuJZlvIhnpk9KTslNG9g=;
        b=R2BCHtlIHwVv6W2aWEJBHE/U0QaHYnMdzhrH++cIxiUK+UDjxFSMNd1zjBFJolNT5v
         gAiRd6Qqs0oQ6WkA3t8HionXn9yykyRPF9dZGRdYRNdoAegw+E3uffIULUCKUt2hO+q6
         gim+YsWiyAQHKqYq3g9Ly0BgObw5mzhttorVi3GgWOGdK+w/4uRAegkrzZW2DOkZA6//
         C333++ngp54VPM/ERjHV6otBj2mAcJoS2YSmpPP4WiqWAnJW+r5oGwOqPWpfR6lW4SHD
         zeFlg4mOJfpEBDZKhn92TUuQV1YltiE/9TVNIaK6EH/qwTaB7ZiBVpF568SOOnFpyvgQ
         R51Q==
X-Gm-Message-State: AOAM531D03eiBEiQr5mBTDz2hOezft4uup8Au8phyQoNVqZ9dk/opTvA
        gTZFMmvhYf92aQ2NSeHwhLW7sqwtecY=
X-Google-Smtp-Source: ABdhPJwHPvMbcB39XRKoVA31QI0H5nrb6VJMxVvuk887RN62Ib5bGbXOcpKiBAI+lN/UYQJEfwVMs6WUIDI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr347865pjf.1.1638928514581; Tue, 07 Dec 2021 17:55:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:27 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 17/26] KVM: VMX: Wake vCPU when delivering posted IRQ even
 if vCPU == this vCPU
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

Drop a check that guards triggering a posted interrupt on the currently
running vCPU, and more importantly guards waking the target vCPU if
triggering a posted interrupt fails because the vCPU isn't IN_GUEST_MODE.
The "do nothing" logic when "vcpu == running_vcpu" works only because KVM
doesn't have a path to ->deliver_posted_interrupt() from asynchronous
context, e.g. if apic_timer_expired() were changed to always go down the
posted interrupt path for APICv, or if the IN_GUEST_MODE check in
kvm_use_posted_timer_interrupt() were dropped, and the hrtimer fired in
kvm_vcpu_block() after the final kvm_vcpu_check_block() check, the vCPU
would be scheduled() out without being awakened, i.e. would "miss" the
timer interrupt.

One could argue that invoking kvm_apic_local_deliver() from (soft) IRQ
context for the current running vCPU should be illegal, but nothing in
KVM actually enforces that rules.  There's also no strong obvious benefit
to making such behavior illegal, e.g. checking IN_GUEST_MODE and calling
kvm_vcpu_wake_up() is at worst marginally more costly than querying the
current running vCPU.

Lastly, this aligns the non-nested and nested usage of triggering posted
interrupts, and will allow for additional cleanups.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fa90eacbf7e2..0eac98589472 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3993,8 +3993,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
 	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
 	 */
-	if (vcpu != kvm_get_running_vcpu() &&
-	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
-- 
2.34.1.400.ga245620fadb-goog

