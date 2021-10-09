Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5170427670
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbhJICTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244659AbhJICS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:18:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDABC061773
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:14:22 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id u9-20020a0cf889000000b003834c01c6e8so3142581qvn.4
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7AydOUvkdJYa6Wlt5e9uwNZNJAdbyWC8Cf+8opg/Yr0=;
        b=F5A5ElVe2ZOpGelCD8RXcxlzS2YdsbWMTlTzwP14Z0DgtKolFahczSuhBXhCWiB7eh
         NnELj9ZTA5ErFZ1Ow79fstlN9c4/ZtbMRM8599X4XIGaWCtKgIyOuh7Lbv+UbYZ/PPbM
         g0ulVkl+iFczbzGTKrUUo2glF7/M3yo4REhhrKmsbxkn4vfC9KbCtghZums5FtWbQOo8
         OtycXlioPw/pt6DxmpIj+7wp94P9in0FjxK37sJ1NDuAXa4Qi5RgxPsIzjtUPPY238Sh
         7lWK+16G09Mmx1LZ71fHA4gr7m6egsSTAl0SJJ8FILJHRjlZrGakxe80P1e6/VbXoR38
         UNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7AydOUvkdJYa6Wlt5e9uwNZNJAdbyWC8Cf+8opg/Yr0=;
        b=WfCYDKCLDvSIDVQmJQ1m6Fxs4NLaV0tK33gJRsVLBRDorrFjVzB5Jk0AupWAY+iRyu
         IRrbuuwapcqqCW8uJYvThbJpcSm/AzLt3/PjyAjYmAmCvmfqJVX8c8RjBLJX3ALveInk
         WfGxP3RQtoxd9Q6t5t6AIWnBDN6M1zEilZfZWNnR55amjt9YEdk4FvlrXe1JHzcy7l8v
         c495nUCYKJUYV++ax5dYUAwlcooo7fQJe5DB/i70ejaT3K6ZKKngRkNZIm7gPIc+qsAM
         SPxQQxgyguZNC5qPuR16GrEeV6/4gsqlyUvPtXpKuU0N/zCugeR7mIzj5jHOankMjBXE
         HnDA==
X-Gm-Message-State: AOAM532HRs9sA+y7XH7O1TnEEBS50m+YjCCu41xnH7RWYHo4vxIAgP5Z
        OmFp0Kakdy+uBnFa8v2luvoOrTokA10=
X-Google-Smtp-Source: ABdhPJys/1e5AWMBDntWj2WGnMrdS/6sXLvUM0X/SLQ0w9S9Xln2c4Up5CedikQUSxYJYOlRRBW1NpJbvEU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:594b:: with SMTP id 11mr1929826qtz.191.1633745662114;
 Fri, 08 Oct 2021 19:14:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:34 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-42-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 41/43] KVM: VMX: Pass desired vector instead of bool for
 triggering posted IRQ
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the posted interrupt helper to take the desired notification
vector instead of a bool so that the callers are self-documenting.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 78c8bc7f1b3b..f505fee3cf5c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3928,11 +3928,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 }
 
 static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-						     bool nested)
+						     int pi_vec)
 {
 #ifdef CONFIG_SMP
-	int pi_vec = nested ? POSTED_INTR_NESTED_VECTOR : POSTED_INTR_VECTOR;
-
 	if (vcpu->mode == IN_GUEST_MODE) {
 		/*
 		 * The vector of interrupt to be delivered to vcpu had
@@ -3986,7 +3984,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 		 */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		/* the PIR and ON have been set by L1. */
-		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
+		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_NESTED_VECTOR))
 			kvm_vcpu_wake_up(vcpu);
 		return 0;
 	}
@@ -4024,7 +4022,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
 	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
 	 */
-	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR))
 		kvm_vcpu_wake_up(vcpu);
 
 	return 0;
-- 
2.33.0.882.g93a45727a2-goog

