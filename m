Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05B532F297
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCESbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCESbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:36 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B23C061574
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:36 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id i188so2459774qkd.7
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2I8FvDRJX4diQtgWxReNsunkTG6GVrDEzb4ROeqCpCA=;
        b=gUWb+oGx2kmyiKIq7Ji4QKdmYRwNg3ql6n8PT1ctaw7mpo68o5gZ3QR/clao5244n7
         RLSZg54MdHDyYUUZbZSg7pSSSDxqTFK35WRCh9TLJDMon7yETm0ZDslaiTKePL+2J+ci
         KapX3/QSdD6EJK0914fBO9wFclKZvDiGvRY9SeNxVAXKxKO5ISW98V84d+dkOVcgNavV
         aGQMy19sB5cdvnJC3+OS/y7En2p1w/rLTDT0pmgPjUk09mqZzQ7PLxNqeFY5615PpSS2
         Q7nD44i6rh5uxgk9F8aS0M4az6PBuhxw4INFgT32HnMimcYnPjj/m8wKi5UCr5gB9lW1
         6MnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2I8FvDRJX4diQtgWxReNsunkTG6GVrDEzb4ROeqCpCA=;
        b=C9gecCPWjQzn7t7xtHqyFkY4RJtKocquypiu81K2pmhk+yVG45ogFuU6Rf//0JK9ra
         Ew2ujU2Q64iI3ltWjetOW47/e9rjMojBvvUD1Aeya7I8XNj8SScy+4rJIau8+4KmUEzo
         sAVsfPDTVcqLMT3bpGnf4v4QXrGKmI81sK9JNpjcfxsN3qNnvPINt/THjmszdqV1KeVo
         4vfQRDDcaezbHISL6ecEwWFy2oSlV8tu5kj85tFHquZ5UTxUlPx1c7kT2n7tv4zmF7wE
         dBE0wS+UVYmpN10npLu2hOfuoaMfiFeJTxatQTC4LwMl/naNb1CSiZFyxt/gKRdXnefA
         8h/Q==
X-Gm-Message-State: AOAM530yqMePIzTU0o/q2WiWdCkgpnnJTicuiQ+HWV7+P/B7nKRLI37v
        ChZWX2DcoPN3hEmlvJjjiQ2exEd1tkw=
X-Google-Smtp-Source: ABdhPJzVgmTYSKJD6HI2e4kOKYb2BPoDBr6v0KNAO2kWQJUtrVakt+9VMJN58RNlGc+GxEZZgv3mjEximF0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:d6c8:: with SMTP id l8mr10149663qvi.1.1614969095547;
 Fri, 05 Mar 2021 10:31:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:15 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 03/11] KVM: VMX: Stash kvm_vmx in a local variable for
 Hyper-V paravirt TLB flush
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

Capture kvm_vmx in a local variable instead of polluting
hv_remote_flush_tlb_with_range() with to_kvm_vmx(kvm).

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4082c7a26612..cf79fc6c01bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -520,26 +520,27 @@ static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range)
 {
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
 
-	spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (to_kvm_vmx(kvm)->ept_pointers_match == EPT_POINTERS_CHECK)
+	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
 		check_ept_pointer_match(kvm);
 
-	if (to_kvm_vmx(kvm)->ept_pointers_match != EPT_POINTERS_MATCH) {
+	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			/* If ept_pointer is invalid pointer, bypass flush request. */
 			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
 				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
 							    range);
 		}
-	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
-		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);
+	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
 
-	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_unlock(&kvm_vmx->ept_pointer_lock);
 	return ret;
 }
 static int hv_remote_flush_tlb(struct kvm *kvm)
-- 
2.30.1.766.gb4fecdf3b7-goog

