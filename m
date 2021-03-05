Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435C632F2AC
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCESfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhCESbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:50 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681EFC061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:50 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id a1so2455467qkn.11
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DQ7Tmt2gW4abXYiFpma/L2uFHht8uCDneBUGK83ED/s=;
        b=JFgVTA12GZBrLquq22LzialuSwFqoDDQbHjexYDuqEkeP8zWA1xwrprg77bw1FiwZA
         E0zSW/dGVYPRpD5hhtW+qkZLCLCUaP6kIJpyx6nX/5jdB4aQ8KPt3YUv1GqbT5fMZBjg
         4SO4ojwLrqrEMol0w+elnM5kjBDfD2sfBN7TzQZWWi7sIv6sxUZpq3jp4A9O4c1zuesc
         CwBbZp+CJq4IcuZTM35esAY22qMiNhstivQ9gY2lNiONxxbngn75zQusKFqAnp7UM9RJ
         +hZNjle+2cREfm+GTBdb4f9Zpwm0ts5sdNVZSgOJxzg1/4j3gGIb03SFs461r9QueXfl
         +QWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DQ7Tmt2gW4abXYiFpma/L2uFHht8uCDneBUGK83ED/s=;
        b=rKlEr8TBYA520+KzaG5upnNRxEiCSOexqHrk7yoFjLgCwF4/T1oMIjMqR4DT5hxXRT
         SAUaokwrAF7H53jhMysqV62pBoJ3BBuzbZdZdQTvbRvBJPDXddrlfX/50arYEUCZhmgL
         eopx0PaLQs2fF/P1dMzlYg7Z+ITZ1J41UeWY9YsZoX49D9jyFFn8wtMkxeoN/Po3sRHN
         +pmEQ5Ob/c+OuhpaZbsMVFSHRYO6tSCZ6tq9WUrX9UZ/zyx1tmBlqNeT8WLdm/N7/Dbe
         G8eXi9YEXj3tYjuZZ4Q//kV5hh/DWx0a8yhZSthQt+j3Bb7eI+9pIRb6dj0A6nuieMjj
         W81Q==
X-Gm-Message-State: AOAM533CeEfp/Z25wqQykrCURmuQs+qUXfhLzinfYs4veEXBMTK+rRfQ
        ZXgp9Y4n5Qt3R9VZtSRX07/PizF26tI=
X-Google-Smtp-Source: ABdhPJzeAZr63UQ+tLroOoFR4kgoHB5AA3OzwqeYoBZjOIKebTedIJ3Bfhed6XfDiGAHRCSyCFrIGTxV7ZA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:ad4:5614:: with SMTP id ca20mr10084795qvb.37.1614969109574;
 Fri, 05 Mar 2021 10:31:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:21 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 09/11] KVM: VMX: Define Hyper-V paravirt TLB flush fields
 iff Hyper-V is enabled
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

Ifdef away the Hyper-V specific fields in structs kvm_vmx and vcpu_vmx
as each field has only a single reference outside of the struct itself
that isn't already wrapped in ifdeffery (and both are initialization).

vcpu_vmx.ept_pointer in particular should be wrapped as it is valid if
and only if Hyper-v is active, i.e. non-Hyper-V code cannot rely on it
to actually track the current EPTP (without additional code changes).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++++-
 arch/x86/kvm/vmx/vmx.h | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca6849c409a..78bda73173d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6920,8 +6920,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
 	vmx->pi_desc.sn = 1;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	vmx->ept_pointer = INVALID_PAGE;
-
+#endif
 	return 0;
 
 free_vmcs:
@@ -6938,7 +6939,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_vm_init(struct kvm *kvm)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+#endif
 
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fb7b2000bd0e..6d97b5a64b62 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,7 +325,9 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
+#if IS_ENABLED(CONFIG_HYPERV)
 	u64 ept_pointer;
+#endif
 
 	struct pt_desc pt_desc;
 	struct lbr_desc lbr_desc;
@@ -345,8 +347,10 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_tlb_eptp;
 	spinlock_t ept_pointer_lock;
+#endif
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-- 
2.30.1.766.gb4fecdf3b7-goog

